resource "google_compute_global_address" "lb_ip" {
  name = "chatgproxyt-ssl-lb-ip"
}

resource "google_compute_region_network_endpoint_group" "chatgproxyt_cloudrun_neg" {
  name                  = "chatgproxyt-cloudrun"
  network_endpoint_type = "SERVERLESS"
  region                = local.gcp_region
  cloud_run {
    service = google_cloud_run_service.chatgproxyt_api.name
  }
}
