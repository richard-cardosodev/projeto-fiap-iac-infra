data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-internal"
    value = "true"
  }

}

data "kubernetes_service" "nginx_ingress_lb" {
  metadata {
    name      = "projetofiap-ingress" 
    namespace = "ingress-nginx"
  }

  depends_on = [
    helm_release.nginx_ingress
  ]
}

data "aws_lb" "nginx_ingress_nlb" {
  name = regex("^(?P<name>.+)-.+\\.elb\\..+\\.amazonaws\\.com", data.kubernetes_service.nginx_ingress_lb.status.0.load_balancer.0.ingress.0.hostname)["name"]
}

resource "null_resource" "wait_for_ingress_nlb" {
  triggers = {
    name = data.aws_lb.nginx_ingress_nlb.name
  }

  provisioner "local-exec" {
    command = "aws elbv2 wait load-balancer-available --region ${var.region} --names ${self.triggers.name}"
  }
}

output "wait_for_nlb_trigger" {
  value = null_resource.wait_for_ingress_nlb.triggers
}

output "nlb_arn" {
  description = "The ARN of the NLB created by the Ingress controller"
  value       = data.aws_lb.nginx_ingress_nlb.arn
}

output "nlb_dns_name" {
  description = "The DNS name of the NLB created by the Ingress controller"
  value       = data.kubernetes_service.nginx_ingress_lb.status.0.load_balancer.0.ingress.0.hostname
}