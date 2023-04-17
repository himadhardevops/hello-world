# EKS App

## To create the infrastructure
```bash
$ terraform init
$ terraform plan
$ terraform apply
```
## Login to EKS cluster
```bash
$ aws eks update-kubeconfig \                                 
  --name dev-eks-cluster --region us-east-1
```
## To access the application
```bash
$ curl $(kubectl get ingress nginx -n default -o jsonpath="{.status.loadBalancer.ingress[].hostname}")
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
## Things to be improved
* Add tags to resources
* Adjust variables for node groups
* Add output values for cluster and app specific information (e.g App URL)
