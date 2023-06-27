import cherrypy
import redis
import json
import os
import openai
import time
from google.cloud import pubsub
from google.pubsub_v1.types import Encoding
from google.protobuf.json_format import MessageToJson
import events_pb2

redis_host = os.environ.get("REDIS_HOST", "localhost")
redis_port = os.environ.get("REDIS_PORT", 6379)
openapi_key = os.environ.get("OPENAPI_KEY","")
pubsub_topic = os.environ.get("PUBSUB_TOPIC", "")
gcp_project = os.environ.get("GCP_PROJECT","")

r = redis.Redis(host=redis_host, port=redis_port, decode_responses=True)

openai.api_key = openapi_key


class ChatGProxyT(object): 
	@cherrypy.expose
	def history(self):
		return json.dumps(r.zrange("history-" + cherrypy.request.headers['X-Goog-Authenticated-User-ID'],0,-1, withscores=True))
	
	@cherrypy.expose
	def query(self, p=""):
		if p == "":
			return json.loads('{ "code": 500 , "message": "No prompt provided"}')
		
		resp = openai.Completion.create( 
			model="text-davinci-003",
			prompt=p
		)
		chatgpt_answer = resp.choices[0].text

		if chatgpt_answer != "":

			ts = int(time.time())
			history_data = {
				"user": cherrypy.request.headers['X-Goog-Authenticated-User-ID'],
				"prompt": p,
				"response": chatgpt_answer,
				"timestamp": ts
			}
			r.zadd("history-" + cherrypy.request.headers['X-Goog-Authenticated-User-ID'], { json.dumps(history_data) : ts } )
			return json.dumps({ "code": 200, "response": chatgpt_answer})


def publishEvent(payload):
	if pubsub_topic != "" and gcp_project != "":
		publisher = pubsub_v1.PublisherClient()
		topic_path = publisher.topic_path(gcp_project, pubsub_topic)
		
		topic = publisher.get_topic(request={"topic": topic_path})
		encoding = topic.schema_settings.encoding
	

		ue = events_pb2.ChatGProxyTUsage()
		ue.user = payload["user"]
		ue.prompt = payload["prompt"]
		ue.response = payload["response"]
		ue.timestamp = payload["timestamp"]

		if encoding == Encoding.BINARY:
			message_data = ue.SerializeToSTring()
		else:
			j = MessageToJSON(ue)
			message_data = str(json_object).encode("utf-8")

		publisher.publish(topic, message_data)
	
		

if __name__ == "__main__":
	cherrypy.config.update({'server.socket_host': "0.0.0.0"})
	cherrypy.quickstart(ChatGProxyT())
