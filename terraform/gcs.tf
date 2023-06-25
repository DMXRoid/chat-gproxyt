resource "google_storage_bucket" "hosting_bucket" {
	name = local.gcs_bucket_name
	location = "US"
	storage_class = "STANDARD"

	uniform_bucket_level_access = true

	website {
		main_page_suffix = "index.html"
		not_found_page = "404.html"
	}
}

resource "google_storage_bucket_iam_binding" "hosting_public" {
	bucket = google_storage_bucket.hosting_bucket.name
	role = "roles/storage.objectViewer"
	members = ["allUsers"]

}

resource "google_storage_bucket_object" "index_html" {
	name = "index.html"
	source = format("%s%s",local.html_path, "index.html")
	content_type = "text/html"
	bucket = google_storage_bucket.hosting_bucket.id
}

resource "google_storage_bucket_object" "not_found" {
	name = "404.html"
	source = format("%s%s",local.html_path, "404.html")
	content_type = "text/html"
	bucket = google_storage_bucket.hosting_bucket.id
}


resource "google_storage_bucket_object" "site_scripts" {
	name = "site-scripts.js"
	source = format("%s%s",local.html_path, "site-scripts.js")
	content_type = "text/javascript"
	bucket = google_storage_bucket.hosting_bucket.id
}

resource "google_storage_bucket_object" "styles" {
	name = "styles.css"
	source = format("%s%s",local.html_path, "styles.css")
	content_type = "text/css"
	bucket = google_storage_bucket.hosting_bucket.id
}
