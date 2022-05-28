docker build -t robowoofy:v0.0.3 --network=host -f build.Dockerfile .
az acr login --name robowoofyregistry
docker tag robowoofy:v0.0.3 robowoofyregistry.azurecr.io/robowoofy:v0.0.3
docker push robowoofyregistry.azurecr.io/robowoofy:v0.0.3