locals {
	gcp_project_id = "schiros-net"
	gcp_region = "us-central1"
	gcs_bucket_name = "chatgproxyt"
	html_path = "../html/"

	gcp_sa_app_id = "chatgproxyt-app"
	gcp_sa_bq_id = "chatgproxyt-bq"
	gcp_sa_pubsub_id = "chatgproxyt-pubsub"
	gcp_pubsub_usage_schema = "chatgproxyt-pubsub-usage-schema"
	gcp_pubsub_usage_topic = "chatgproxyt-pubsub-usage"

	gcp_bigquery_dataset = "chatgproxyt"
	gcp_bigquery_usage_table = "usage"

	domain_label = "schiros-net"
	domain_name = "schiros.net"

}
