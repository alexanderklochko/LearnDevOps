### Kubernetess 
---------------------------------------------------------------------------------------
#### Project goals:
 - create terraform code for creating GKE and EKS clusters;
 - create kubernetess manifests for deploying CRUD application (PHP8+MySQL):
    + Different namespaces for database and application;
    + Using kubernetes secrets (dockergub credentials, mysql credentials etc.);
    + configuration nginx ingress controller in GKE cluster; 
    + Create cluster IP services for the internal connect beetwen kubernetes objects,
      in this case: between mysql and php deployments;
    + Create configmap for implementing environment variables and initial scripts;
    + Implement affinity rules and probes;
    + Configure and install aws alb ingress controller with the helm chart,
      using custom values, node service for connection between ingress controller and
      pods;
    + Custom healthchecks for alb controller;
    
---------------------------------------------------------------------------------------
##### 1) Docker images 

First of all create dockerfile for our application, build and an image and push it to the dockergub.

 ```js
FROM php:8.0-apache
RUN docker-php-ext-install mysqli
ENV DB_NAME="db_name" \
    DB_USER="user" \
    DB_IP=1.1.1.1 \
    USER_PASS=password
COPY ./php-mysql-crud /var/www/html/
```
Check that everything works locally:

```sh
docker run -v mysql_data:/var/lib/mysql --net test_my-net --ip 10.5.0.2 --name database -p 3306:3306 -e MARIADB_DATABASE=php_mysql_crud -e MYSQL_USER user -e MYSQL_PASSWORD=123456 mariadb
docker run --net test_my-net --ip 10.5.0.3 -p 4061:80 --name server -e DB_USER=user  -e USER_PASS=123456 -e DB_NAME=php_mysql_crud -e DB_IP=10.5.0.2 crud
```
And push to the dockerhub:

```sh
docker tag crud oleksandriyskiy/crud
docker login --username oleksandriyskiy --password
docker push oleksandriyskiy/crud
```

##### 2) Creating EKS cluster and ingress controller

During the process of creating `aws_iam_openid_connect_provider` I have encountered with problem that
`thumbprint_list` can't be assigned by terraform, we have to use this command:

```shkubectl 
echo | openssl s_client -connect oidc.eks.us-west-2.amazonaws.com:443 2>&- | openssl x509 -fingerprint -noout | sed 's/://g' | awk -F= '{print tolower($2)}'
```

After EKS cluster has been completed type this command to log
to the cluster:

```sh
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name) --no-verify-ssl --profile=<your_profile>
```

For installing nginx controller:

```sh
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

For installing aws controller:

```sh
helm install -n ingress-aws --create-namespace aws-load-balancer-controller-crds aws-load-balancer-controller-crds/aws-load-balancer-controller-crds --version 1.3.3
helm repo add aws https://aws.github.io/eks-charts
helm repo update
helm upgrade -i -n ingress-aws --create-namespace ingress-aws aws/aws-load-balancer-controller -f values.yml --version 2.4.7
kubectl annotate ingressclasses aws-alb ingressclass.kubernetes.io/is-default-class=true
```

##### 3) Create namespaces and then secrets

In this task I have created namespace and secrets using yaml files like:

```sh
apiVersion: v1
kind: Secret
metadata:
  name: db-crud-secret
  namespace: app
type: Opaque
data:
  username: YWxla3M=
  password: cGFzczEyMzQ=
immutable: true

kind: Namespace
apiVersion: v1
metadata:
  name: db
```

Secrets for docker hab have been created through kubectl command:

```sh
kubectl create secret docker-registry secret-tiger-docker \
  --docker-email=user@example \
  --docker-username=user \
  --docker-password=passwd \
  --docker-server=https://index.docker.io/v1/
```

##### 4) Affinity rules

In this case pod with where is deployed application and pods with database
are located in different nodes. For this we need to assign labels for worker-
nodes with this command:

```sh
kubectl label node k8s-node-worker-node app=app-crud
  
```
And use antiaffinity rule, which is based on topologykey `topology.kubernetes.io/zone` -
it guarantees podes will be deployed on different regions.

##### 4) Persistance volume

In this task were created high availability infrastructure, where we have nodes
in two different availability zones within one region. In this case i used EFS storage
for perssistance volume.

There is a code for installing aws-efs-csi-driver:

```sh
helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/
helm repo update
helm upgrade --install aws-efs-csi-driver --namespace kube-system aws-efs-csi-driver/aws-efs-csi-driver
```

Also before every new deploy we have to update EFS id in `persistance-volume.yaml` manifest.

Othere operations like creationg nessary polycies, creating EFS itself implementing by terraform code.
