resource "google_service_account" "cgproxyt_app" {
	account_id = local.gcp_sa_app_id
	display_name = "ChatGProxyT App Service Acct"
}

resource "google_service_account" "cgproxyt_pubsub" {
	account_id = local.gcp_sa_pubsub_id
	display_name = "ChatGProxyT Pub/Sub Service Acct"
}

resource "google_service_account" "cgproxyt_bq" {
	account_id = local.gcp_sa_bq_id
	display_name = "ChatGProxyT BQ Service Acct"
}

resource "google_project_iam_binding" "cgproxyt_bg_edit" {
	project = local.gcp_project_id
	role = "roles/bigquery.dataEditor"
	members = [
		format("serviceAccount:%s",google_service_account.cgproxyt_pubsub.email), 
		format("serviceAccount:%s",google_service_account.cgproxyt_pubsub.email),
		format("serviceAccount:service-%s@gcp-sa-pubsub.iam.gserviceaccount.com",data.google_project.project.number)

	]
	depends_on = [google_service_account.cgproxyt_pubsub]
}
resource "google_project_iam_binding" "cgproxyt_bg_view" {
	project = local.gcp_project_id
	role = "roles/bigquery.metadataViewer"
	members = [
		format("serviceAccount:%s",google_service_account.cgproxyt_pubsub.email), 
		format("serviceAccount:%s",google_service_account.cgproxyt_pubsub.email),
		format("serviceAccount:service-%s@gcp-sa-pubsub.iam.gserviceaccount.com",data.google_project.project.number)

	]
	depends_on = [google_service_account.cgproxyt_pubsub]
}
