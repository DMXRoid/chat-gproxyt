resource "google_bigquery_dataset" "chatgproxyt" {
  dataset_id                  = local.gcp_bigquery_dataset
  friendly_name               = "chatgproxyt"
  description                 = "For ChatGProxyT Metrics and such"
  location                    = "US"
  default_table_expiration_ms = 3600000
  access {
		role = "OWNER"
		user_by_email = google_service_account.cgproxyt_bq.email
  }
  access {
		role = "OWNER"
		user_by_email = google_service_account.cgproxyt_pubsub.email
  }

  access {
		role = "OWNER"
		user_by_email = "schiros@gmail.com"
  }


  access {
		role = "WRITER"
		user_by_email = google_service_account.cgproxyt_pubsub.email
  }
}

resource "google_bigquery_table" "chatgproxyt_usage" {
	table_id = local.gcp_bigquery_usage_table
	dataset_id = google_bigquery_dataset.chatgproxyt.dataset_id
	deletion_protection = false
	schema = <<EOF
[
	{
		"name": "user",
		"type": "STRING",
		"mode": "NULLABLE"
	},
	{
		"name": "prompt",
		"type": "STRING",
		"mode": "NULLABLE"
	},
	{
		"name": "response",
		"type": "STRING",
		"mode": "NULLABLE"
	},
	{
		"name": "timestamp",
		"type": "INTEGER",
		"mode": "NULLABLE"
	}
]
EOF

}
