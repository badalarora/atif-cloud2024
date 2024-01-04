data "google_compute_global_address" "nginx_ip" {
  name = google_compute_address.nginx_ip.name
}

data "google_compute_global_address" "grafana_ip" {
  name = google_compute_address.grafana_ip.name
}

output "nginx_ip" {
  value = data.google_compute_global_address.nginx_ip.address
}

output "grafana_ip" {
  value = data.google_compute_global_address.grafana_ip.address
}