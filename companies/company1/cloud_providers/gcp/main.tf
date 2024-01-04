resource "google_container_cluster" "my_cluster" {
  name     = "my-gke-cluster"
  location = "us-central1"
  initial_node_count = 1
  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "kubernetes_namespace" "services" {
  metadata {
    name = "services"
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "nginx" {
  name       = "nginx"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx"
  namespace  = kubernetes_namespace.services.metadata.0.name
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata.0.name
}

resource "google_compute_address" "nginx_ip" {
  name = "nginx-ip"
}

resource "google_compute_address" "grafana_ip" {
  name = "grafana-ip"
}