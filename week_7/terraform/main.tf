resource "google_storage_bucket" "site" {
  name          = "kamau-week7-site-2026"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true
website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
}
}
resource "google_storage_bucket_object" "index" {
  name         = "index.html"
  source       = "index.html"
  bucket       = google_storage_bucket.site.name
  content_type = "text/html"
}
resource "google_storage_bucket_object" "error" {
  name         = "404.html"
  source       = "404.html"
  bucket       = google_storage_bucket.site.name
  content_type = "text/html"
}
resource "google_storage_bucket_object" "css" {
  name         = "style.css"
  source       = "style.css"
  bucket       = google_storage_bucket.site.name
  content_type = "text/css"
}
resource "google_storage_bucket_object" "image" {
  name         = "image.jpg"
  source       = "image.jpg"
  bucket       = google_storage_bucket.site.name
  content_type = "image/jpeg"
}
resource "google_storage_bucket_iam_member" "public_read" {
  bucket = google_storage_bucket.site.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
