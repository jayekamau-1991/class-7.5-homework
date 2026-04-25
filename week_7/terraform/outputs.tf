output "website_url" {
  description = "URL to the static site index page"
  value       = "https://storage.googleapis.com/${google_storage_bucket.site.name}/index.html"
}