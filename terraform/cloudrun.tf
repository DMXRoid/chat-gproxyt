resource "google_cloud_run_service" "chatgproxyt_api" {
	name = "chatgproxyt-api"
	location = local.gcp_region
	template {
		spec {
			containers {
				image = "us-central1-docker.pkg.dev/schiros-net/chatgproxyt/chatgproxyt:1.2"
				env {
					name = "REDIS_HOST"
					value = google_redis_instance.chatgproxyt.host
				}
				env {
					name = "REDIS_PORT"
					value = google_redis_instance.chatgproxyt.port
				}
			}
			service_account_name = google_service_account.cgproxyt_app.email
		}
	}

	metadata {
		annotations = {
			"run.googleapis.com/ingress" = "internal-and-cloud-load-balancing"
			"run.googleapis.com/vpc-access-connector" = "chatgproxyt"
		}
	}

	autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_member" "public-access" {
	location = local.gcp_region
	service = google_cloud_run_service.chatgproxyt_api.name
 	role     = "roles/run.invoker"
	member   = "allUsers"
}
