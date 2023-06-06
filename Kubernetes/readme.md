### Kubernetess 
---------------------------------------------------------------------------------------
#### Project goals:
 - create terraform code for creating GKE cluster;
 - create kubernetess manifests for deploying CRUD application (PHP8+MySQL):
    + Different namespaces for database and application;
    + Using kubernetes secrets (dockergub credentials, mysql credentials etc.);
    + Create loadbalancer service for the 

    + Create cluster IP service for the internal connect beetwen kubernetes objects;
    + 

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

##### 2) Kubernetes secrets

```sh
kubectl create secret docker-registry secret-tiger-docker \
  --docker-email=user@example \
  --docker-username=user \
  --docker-password=passwd \
  --docker-server=https://index.docker.io/v1/
```

##### 3) Nginx Ingress Controller Helm Deployment



```sh
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```