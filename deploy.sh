#!/bin/bash
#set -e

# note that the character '_' is an invalid value if you are replacing the defaults below
mgmt_context=`kubectl config current-context`

# check to see if defined contexts exist
if [[ $(kubectl config get-contexts | grep ${mgmt_context}) == "" ]] ; then
  echo "Check Failed: mgmt context does not exist. Please check to see if you have the clusters available"
  echo "Run 'kubectl config get-contexts' to see currently available contexts. If the clusters are available, please make sure that they are named correctly. Default is mgmt"
  exit 1;
fi

# install argocd on ${mgmt_context}, ${cluster1_context}, and ${cluster2_context}
cd bootstrap-argocd
./install-argocd.sh insecure-rootpath ${mgmt_context}
cd ..

# wait for argo cluster rollout
./tools/wait-for-rollout.sh deployment argocd-server argocd 20 ${mgmt_context}




# echo port-forward commands
echo
echo "access gloo mesh dashboard:"
echo "kubectl port-forward -n gloo-mesh svc/gloo-mesh-ui 8090 --context ${mgmt_context}"
echo 
echo "access argocd dashboard:"
echo "kubectl port-forward svc/argocd-server -n argocd 9999:443 --context ${mgmt_context}"
echo

