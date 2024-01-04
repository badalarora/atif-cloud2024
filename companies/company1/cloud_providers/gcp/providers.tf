terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.10.0"
    }
  }
}

provider "google" {
  project = "atif-cloud"
  region  = "us-central1"
  #credentials = file("C:\\Users\\BadalArora\\atif-cloud\\companies\\company1\\cloud_providers\\gcp")
}

data "google_container_cluster" "my_cluster" {
  name     = "my-gke-cluster"
  location = "us-central1"
}

provider "kubernetes" {
  host                   = data.google_container_cluster.my_cluster.endpoint
  token                  = data.google_container_cluster.my_cluster.master_auth.0.token
  cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth.0.cluster_ca_certificate)
}

data "kubernetes_config_map" "my_config" {
  metadata {
    name      = "my-gke-cluster"
    namespace = "kube-system"
  }
}

provider "helm" {
  kubernetes {
    config_path = data.kubernetes_config_map.my_config.data["kubeconfig"]
  }
}
