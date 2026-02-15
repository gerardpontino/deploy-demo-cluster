data "aws_eks_cluster_auth" "main" {
  name = aws_eks_cluster.main.name
}

# 👇 Delete existing gp2 StorageClass (if exists)
#resource "null_resource" "delete_gp2" {
#  provisioner "local-exec" {
#    command = "kubectl delete storageclass gp2 --ignore-not-found=true"
#  }

#  depends_on = [
#    aws_eks_cluster.main
#  ]
#}

# 👇 Create new gp3 StorageClass
resource "kubernetes_storage_class_v1" "gp3_default" {
  metadata {
    name = "gp3"  # or "gp2" if Dynatrace needs the name
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner = "ebs.csi.eks.amazonaws.com"

  parameters = {
    type       = "gp3"
    iops       = "3000"
    throughput = "125"
  }

  reclaim_policy      = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"

 # depends_on = [
  #  null_resource.delete_gp2
  #]
}