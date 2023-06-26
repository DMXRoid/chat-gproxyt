import cherrypy
import redis
import json
import os
import openai
import time

redis_host = os.environ.get("REDIS_HOST", "localhost")
redis_port = os.environ.get("REDIS_PORT", 6379)
openapi_key = os.environ.get("OPENAPI_KEY","")


r = redis.Redis(host=redis_host, port=redis_port, decode_responses=True)

openai.api_key = openapi_key


class ChatGProxyT(object): 
	@cherrypy.expose
	def history(self):
		return json.dumps(r.zrange("history-" + cherrypy.request.headers['X-Goog-Authenticated-User-ID'],0,-1, withscores=True))
	
	@cherrypy.expose
	def query(self, p=""):
		if p == "":
			return json.loads('{ "error": true , "message": "No prompt provided"}')
		
		resp = openai.Completion.create( 
			model="text-davinci-003",
			prompt=p
		)
		chatgpt_answer = resp.choices[0].text

		if chatgpt_answer != "":
			history_data = {
				"prompt": p,
				"answer": chatgpt_answer
			}
			r.zadd("history-" + cherrypy.request.headers['X-Goog-Authenticated-User-ID'], { json.dumps(history_data) : time.time() } )
			#return json.loads('{ "response": "' + chatgpt_answer + '" }')
			return chatgpt_answer
			

if __name__ == "__main__":
	cherrypy.quickstart(ChatGProxyT())
