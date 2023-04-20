# App manifests

resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_namespace" "app_namespace" {
  metadata {
    name = var.app_namespace
  }
}

resource "helm_release" "jenkins" {
  name             = "jenkins"
  namespace        = kubernetes_namespace.namespace.id
  create_namespace = false
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"

  values = [
    "${file("${path.module}/values.yaml")}"             
  ]
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  namespace        = kubernetes_namespace.namespace.id
  chart            = "argo-cd"

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "server.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-internal"
    value = "true"
  }
}

resource "helm_release" "argocd-image-updater" {
  chart = "argocd-image-updater"
  name  = "argocd-image-updater"
  repository = "https://argoproj.github.io/argo-helm"
  namespace = kubernetes_namespace.namespace.id 
}

resource "kubectl_manifest" "argocd-app" {
  yaml_body = <<YAML
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
      annotations:
        argocd-image-updater.argoproj.io/backend.helm.image-name: image.repository
        argocd-image-updater.argoproj.io/backend.helm.image-tag: image.tag
        argocd-image-updater.argoproj.io/backend.update-strategy: latest
        argocd-image-updater.argoproj.io/image-list: himadhardevops/hello-world
        argocd-image-updater.argoproj.io/write-back-method: argocd
        meta.helm.sh/release-name: image-updater
        meta.helm.sh/release-namespace: argocd-image-updater
      labels:
        app.kubernetes.io/managed-by: Helm
        env: dev
      name: hello-world
      namespace: argocd-image-updater
    spec:
      destination:
        namespace: app
        server: https://kubernetes.default.svc
      project: default 
      source:
        helm:
          parameters:
          - name: replicaCount
            value: "3"
          - forceString: true
            name: image.name
            value: himadhardevops/hello-world
          - forceString: true
            name: image.tag
            value: v1
        path: helm/hello-world
        repoURL: https://github.com/himadhardevops/hello-world.git
        targetRevision: master
      syncPolicy:
        automated:
          prune: true
        syncOptions:
        - CreateNamespace=true
  YAML

  depends_on = [helm_release.argocd]
}

resource "kubectl_manifest" "argocd-ingress" {
  yaml_body = <<YAML
    apiVersion: argoproj.io/v1alpha1
    kind: AppProject
    metadata:
      name: hello-world 
      namespace: argocd-image-updater
    spec:
      destinations:
      - namespace: ecsdemo-crystal
        server: https://kubernetes.default.svc
      sourceRepos:
      - https://github.com/himadhardevops/hello-world.git
  YAML

  depends_on = [kubectl_manifest.argocd-app]
}
