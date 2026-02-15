resource "helm_release" "dynatrace_operator" {
  name             = "dynatrace-operator"
  namespace        = "dynatrace"
  create_namespace = true

  # Separate the OCI repository from the chart name
  repository = "oci://public.ecr.aws/dynatrace"
  chart      = "dynatrace-operator"
  version    = "1.7.2"

  atomic          = true
  cleanup_on_fail = true

  depends_on = [aws_eks_cluster.main]
}