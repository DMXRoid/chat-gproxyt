resource "google_certificate_manager_dns_authorization" "chatgproxyt" {
  name        = "frontend-dns-auth"
  description = "Frontned DNS auth"
  domain      = format("%s.%s","chatgproxyt", local.domain_name)

}

resource "google_certificate_manager_certificate" "chatgproxyt_ssl" {
	name = "chatgproxyt-ssl"
	description = "SSL cert for chatgproxyt"
	scope = "DEFAULT"

	managed {
		domains = [
			google_certificate_manager_dns_authorization.chatgproxyt.domain,		
			format("*.%s",google_certificate_manager_dns_authorization.chatgproxyt.domain)

		]

		dns_authorizations = [
			google_certificate_manager_dns_authorization.chatgproxyt.id

		]
	}
}

resource "google_certificate_manager_certificate_map" "chatgproxyt" {
  name        = "certificate-map"
  description = "certificate map containing the domain names and sub-domains names for the SSL certificate"
}

resource "google_certificate_manager_certificate_map_entry" "chatgproxyt_root" {
  name         = "chatgproxyt-root"
  description = "root cert"
  map          = google_certificate_manager_certificate_map.chatgproxyt.name
  certificates = [google_certificate_manager_certificate.chatgproxyt_ssl.id]
  hostname     = local.domain_name
}

resource "google_certificate_manager_certificate_map_entry" "chatgproxyt_wildcard" {
  name         = "chatgproxyt-wildcard"
  description = "wildcard cert"
  map          = google_certificate_manager_certificate_map.chatgproxyt.name
  certificates = [google_certificate_manager_certificate.chatgproxyt_ssl.id]
  hostname     = format("*.%s",local.domain_name)
}


