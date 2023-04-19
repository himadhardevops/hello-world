# Hello World
This application prints hello world along with a date and time.
## Architecture
![image](https://user-images.githubusercontent.com/130277163/232400925-bc6c6090-432a-4f41-b65a-48bf4e1ca193.png)
## Deployment process
The following provisions an EKS cluster, Jenkins, ArgoCD and hello world application
1. Create S3 bucket for the terraform backend and update the bucket name in `infra/backend-config.tf` file
```
$ aws s3 mb us-east-1-priv2-tf-backend
```
2. Initialize the backend
```
$ cd infra/
$ terraform init
```
3. Provision the resources
```
$ terraform apply
```
##  Verify the cluster access, and resources
1. Login to the cluster
```
$ aws eks update-kubeconfig --name dev-eks-cluster
```
2. Verify Jenkins, ArgoCD and ArgoCD image updater resources are deployed
```
$ kubectl get pod -n argocd-image-updater
NAME                                               READY   STATUS    RESTARTS       AGE
argocd-application-controller-0                    1/1     Running   0              130m
argocd-applicationset-controller-b48b96dd9-s7jr5   1/1     Running   0              130m
argocd-dex-server-9d7976dc9-8p7j9                  1/1     Running   2 (130m ago)   130m
argocd-image-updater-79987b8b84-wsntq              1/1     Running   0              132m
argocd-notifications-controller-6c868cff74-f5tdd   1/1     Running   0              130m
argocd-redis-6856f9fdb4-mjpg9                      1/1     Running   0              130m
argocd-repo-server-6c5bf9b59f-lvh2n                1/1     Running   0              130m
argocd-server-85fb8cd989-4hf6c                     1/1     Running   0              130m
jenkins-0                                          2/2     Running   0              132m
```
3. Verify the application is deployed successfully via ArgoCD and synced successfully
```
$ kubectl get application            
NAME          SYNC STATUS   HEALTH STATUS
hello-world   Synced        Healthy

$ kubectl get pod -n app       
NAME                           READY   STATUS    RESTARTS   AGE
hello-world-59fc87f589-64s7t   1/1     Running   0          41m
hello-world-59fc87f589-cqsm6   1/1     Running   0          41m
hello-world-59fc87f589-xsrvt   1/1     Running   0          41m
```
4. Try accessing the application
```
$ kubectl port-forward svc/hello-world 5000:5000 -n app

$ curl localhost:5000                                                             
Hello, World! The time is 2023-04-17 06:42:19.961930
```
