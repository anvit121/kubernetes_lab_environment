#####
####     *** Run this File to Set Up JupyterHub   ***
###

### Overview
# When making clusters type: hub.jupyter.org/node-purpose=core
# At the time of this tutorial I used helm versions 2.11 and jupyterhub version 0.7.0
# Helm Releases: https://github.com/helm/helm/releases
# JupyterHub Releases: https://jupyterhub.github.io/helm-chart/
# Helm Tutorial: https://docs.helm.sh/using_helm/#quickstart-guide

### Download & Set Up Helm
# https://zero-to-jupyterhub.readthedocs.io/en/latest/setup-helm.html
# curl https://raw.githubusercontent.com/helm/helm/HEAD/scripts/get-helm-3 | bash
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
kubectl --namespace kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
#helm init --service-account tiller
#helm init --service-account tiller --wait
kubectl patch deployment tiller-deploy --namespace=kube-system --type=json --patch='[{"op": "add", "path": "/spec/template/spec/containers/0/command", "value": ["/tiller", "--listen=localhost:44134"]}]'

# Make io Hub faster, Create Optimized Storage Class
#kubectl apply -f storageclass.yaml

### Create & Run JupyterHub
# https://zero-to-jupyterhub.readthedocs.io/en/latest/setup-jupyterhub.html
# Add Security Token to config.yaml
sed -i 's/<RANDOM_HEX>/'"$( openssl rand -hex 32 )"'/g' config.yaml
# Add jupyterhub github repo to helm
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update
# Run the config.yaml file to start up JupyterHub: RELEASE=NAMESPACE=jhub, JUPYTER_VERSION=0.7.0
# helm upgrade --cleanup-on-fail --install jhub jupyterhub/jupyterhub --namespace jhub --version=0.8.0 --values config.yaml
helm upgrade --install jhub jupyterhub/jupyterhub --namespace jhub --version 0.8.2 --values config.yaml
# helm upgrade --cleanup-on-fail \
#   --install jhub jupyterhub/jupyterhub \
#   --namespace jhub \
#   --create-namespace \
#   --version=0.8.0 \
#   --values config.yaml

