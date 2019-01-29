# Initializing helm client, installing Tiller on the cluster and waiting for it to be ready
#
helm init --wait

# Adding necessary roles for helm and Tiller to be able to communicate
#
kubectl create clusterrolebinding add-on-cluster-admin \
  --clusterrole=cluster-admin --serviceaccount=kube-system:default

# Install the latest nginx ingress controller, setting it to type "NodePort" and hardcoding it's port
# Usually we won't hardcode such a parameter and we do that just to be able to access the controller remotely from the browser
#
helm install --name ingress stable/nginx-ingress \
  --set controller.service.type=NodePort \
  --set controller.service.nodePorts.http=30001

