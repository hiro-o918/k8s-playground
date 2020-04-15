# build and push images
docker build -t $DOKERHUB_ID/k8s-complex-client:latest -t $DOKERHUB_ID/k8s-complex-client:$SHA -f ./client/Dockerfile ./client
docker build -t $DOKERHUB_ID/k8s-complex-worker:latest -t $DOKERHUB_ID/k8s-complex-worker:$SHA -f ./worker/Dockerfile ./worker
docker build -t $DOKERHUB_ID/k8s-complex-server:latest -t $DOKERHUB_ID/k8s-complex-server:$SHA -f ./server/Dockerfile ./server
echo "$DOKERHUB_LOGIN_KEY" | docker login -u "$DOKERHUB_ID" --password-stdin
docker push $DOKERHUB_ID/k8s-complex-client:latest
docker push $DOKERHUB_ID/k8s-complex-worker:latest
docker push $DOKERHUB_ID/k8s-complex-server:latest
docker push $DOKERHUB_ID/k8s-complex-client:$SHA
docker push $DOKERHUB_ID/k8s-complex-worker:$SHA
docker push $DOKERHUB_ID/k8s-complex-server:$SHA

# configre kubectl
aws eks --region ap-northeast-1 update-kubeconfig --name hironori-udemy-k8s-cluster
# apply manufests
kubectl apply -f k8s
kubectl set image deployments/client-deployment client=$DOKERHUB_ID/k8s-complex-client:$SHA
kubectl set image deployments/worker-deployment worker=$DOKERHUB_ID/k8s-complex-worker:$SHA
kubectl set image deployments/server-deployment server=$DOKERHUB_ID/k8s-complex-server:$SHA