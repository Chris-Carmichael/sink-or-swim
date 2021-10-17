provider "kubectl" {
  # https://github.com/gavinbunney/terraform-provider-kubectl
  #host                   = module.gke_auth.host
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  #cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws-iam-authenticator"
    args = [
      "token",
      "-i",
      module.eks.cluster_id,
    ]
  }
}

data "kubectl_file_documents" "namespace" {
  content = file("../manifests/argocd-namespace.yaml")
}

resource "kubectl_manifest" "namespace" {
  count              = length(data.kubectl_file_documents.namespace.documents)
  yaml_body          = element(data.kubectl_file_documents.namespace.documents, count.index)
  override_namespace = "argocd"
}

data "kubectl_file_documents" "argocd" {
  content = file("../manifests/argocd-install.yaml")
}

resource "kubectl_manifest" "argocd" {
  depends_on = [
    kubectl_manifest.namespace,
  ]
  count              = length(data.kubectl_file_documents.argocd.documents)
  yaml_body          = element(data.kubectl_file_documents.argocd.documents, count.index)
  override_namespace = "argocd"
}
