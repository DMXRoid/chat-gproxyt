resource "google_dns_managed_zone" "default" {
	name = local.domain_label
	dns_name = format("%s.", local.domain_name)
}

resource "google_dns_record_set" "chatgproxyt_frontend" {
	name = format("chatgproxyt.%s.", local.domain_name)
	type = "A"
	ttl = 300
	managed_zone = google_dns_managed_zone.default.name
	rrdatas = [ google_compute_global_address.lb_ip.address ]
}
resource "google_dns_record_set" "chatgproxyt_api" {
	name = format("api.chatgproxyt.%s.", local.domain_name)
	type = "A"
	ttl = 300
	managed_zone = google_dns_managed_zone.default.name
	rrdatas = [ google_compute_global_address.lb_ip.address ]
}


resource "google_dns_record_set" "dns_authorization_wildcard_certificate" {
  name         = google_certificate_manager_dns_authorization.chatgproxyt.dns_resource_record[0].name
  managed_zone = google_dns_managed_zone.default.name
  type         = google_certificate_manager_dns_authorization.chatgproxyt.dns_resource_record[0].type
  ttl          = 300
  rrdatas      = [google_certificate_manager_dns_authorization.chatgproxyt.dns_resource_record[0].data]
}

