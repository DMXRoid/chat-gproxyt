resource "google_pubsub_schema" "chatgproxyt_usage_schema" {
	name = local.gcp_pubsub_usage_schema
	type = "PROTOCOL_BUFFER"
	definition = "syntax = \"proto3\";\nmessage CGProxyTUsage {\nstring user = 1;\nstring prompt = 2;\nstring response = 3;\nint32 timestamp = 4;\n}"
	
}

resource "google_pubsub_topic" "chatgproxyt_pubsub_usage" {
	name = local.gcp_pubsub_usage_topic
	depends_on = [google_pubsub_schema.chatgproxyt_usage_schema]
	schema_settings {
		schema = format("projects/%s/schemas/%s", local.gcp_project_id, local.gcp_pubsub_usage_schema)
		encoding = "JSON"
	}
}

resource "google_pubsub_subscription" "chatgproxyt_pubsub_sink" {
	name = "chatgproxyt-sink"
	topic = google_pubsub_topic.chatgproxyt_pubsub_usage.name
	depends_on = [google_pubsub_topic.chatgproxyt_pubsub_usage, google_project_iam_binding.cgproxyt_bg_edit,google_project_iam_binding.cgproxyt_bg_view]
	bigquery_config {
		table = format("%s.%s.%s", local.gcp_project_id, local.gcp_bigquery_dataset, local.gcp_bigquery_usage_table)
		use_topic_schema = true
	}
}
