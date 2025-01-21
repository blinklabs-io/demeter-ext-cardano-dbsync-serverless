locals {
  dns_names        = flatten([var.network, ["*.${var.dns_zone}"]])
  cert_secret_name = "${var.extension_name}-wildcard-tls"
}

resource "kubernetes_manifest" "certificate_cluster_wildcard_tls" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata" = {
      "name"      = local.cert_secret_name
      "namespace" = var.namespace
    }
    "spec" = {
      "dnsNames" = local.dns_names

      "issuerRef" = {
        "kind" = "ClusterIssuer"
        "name" = var.cluster_issuer
      }
      "secretName" = local.cert_secret_name
    }
  }
}
