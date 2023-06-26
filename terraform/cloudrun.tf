resource "google_cloud_run_service" "chatgproxyt_api" {
	name = "chatgproxyt-api"
	location = local.gcp_region
	template {
		spec {
			containers {
				image = "gcr.io/cloudrun/hello"
				env {
					name = "REDIS_HOST"
					value = google_redis_instance.chatgproxyt.host
				}
				env {
					name = "REDIS_PORT"
					value = google_redis_instance.chatgproxyt.port
				}
			}
		}
	}

	metadata {
		annotations = {
			"run.googleapis.com/ingress" = "internal-and-cloud-load-balancing"
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
