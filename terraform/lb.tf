resource "google_compute_backend_bucket" "frontend_bucket" {
	name = "chatgproxyt-frontend-bucket"
	description = "Frontend for chatgproxyt"
	bucket_name = google_storage_bucket.hosting_bucket.name
	enable_cdn = true

}

resource "google_compute_url_map" "frontend_map" {
	name = "chatgproxyt-frontend-lb"
	default_service = google_compute_backend_bucket.frontend_bucket.id

	host_rule {
		hosts = [ format("chatgproxyt-api.%s", local.domain_name) ]
		path_matcher = "api"
	}

	path_matcher {
		name = "api"
		default_service = google_compute_backend_service.chatgproxyt_api.id
	}
}


resource "google_compute_target_https_proxy" "frontend" {
	name = "chatgproxyt-frontend"
	url_map = google_compute_url_map.frontend_map.id
	certificate_map = format("//%s/%s", "certificatemanager.googleapis.com" , google_certificate_manager_certificate_map.chatgproxyt.id)
}

resource "google_compute_backend_service" "chatgproxyt_api" {
	name = "chatgproxyt-api"
	protocol = "HTTP"
	port_name = "http"
	timeout_sec = 30
	
	iap {
		oauth2_client_id = local.oauth2_client_id
		oauth2_client_secret = local.oauth2_client_secret
	}

	backend {
		group = google_compute_region_network_endpoint_group.chatgproxyt_cloudrun_neg.id
	}
}


resource "google_compute_global_forwarding_rule" "https" {
  name        = "chatgproxyt-https"
  description = "Global external load balancer"
  ip_address  = google_compute_global_address.lb_ip.id
  port_range  = "443"
  target      = google_compute_target_https_proxy.frontend.self_link
}

resource "google_compute_global_forwarding_rule" "http" {
  name        = "chatgproxyt-http"
  description = "Global external load balancer HTTP redirect"
  ip_address  = google_compute_global_address.lb_ip.id
  port_range  = "80"
  target      = google_compute_target_http_proxy.http_proxy.self_link
}


resource "google_compute_target_http_proxy" "http_proxy" {
  name        = "http-webserver-proxy"
  description = "Redirect proxy mapping for the Load balancer"
  url_map     = google_compute_url_map.http_https_redirect.self_link
}

resource "google_compute_url_map" "http_https_redirect" {
  name        = "http-https-redirect"
  description = "HTTP Redirect map"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}
