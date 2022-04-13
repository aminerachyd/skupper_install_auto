#!/bin/bash

FIRST_NS='east'
SECOND_NS='west'

# Create two projects on the cluster
oc new-project $FIRST_NS
oc new-project $SECOND_NS

# Apply site-controller to watch for skupper configurations
oc apply -f deploy-watch-current-ns.yaml -n $FIRST_NS
oc apply -f deploy-watch-current-ns.yaml -n $SECOND_NS

# Apply skupper configuration for each site, deployments skupper-router and skupper-service-controller will be created
oc apply -f east-site.yaml -n $FIRST_NS
oc apply -f west-site.yaml -n $SECOND_NS

# Wait for skupper to be up and running
while [[ $(skupper status -n $FIRST_NS | grep 'It is not connected to any other sites') == '' ]]  || [[ $(skupper status -n $SECOND_NS | grep 'It is not connected to any other sites') == '' ]]
do
  sleep 5;
  echo "Waiting for skupper to be up and running on both namespaces. Retrying in 5 seconds...";
done

# Fetch login token from a namespace and pass it to another
oc apply -f token-request.yaml -n west
sleep 2;
oc get secret west-secret -o yaml -n west > west-secret.yaml
sed 's/namespace: west/namespace: east/' west-secret.yaml > west-secret-east.yaml
oc apply -f west-secret-east.yaml -n east

# Verify skupper status for each namespace
while [[ $(skupper status -n $FIRST_NS | grep 'It is connected') == '' ]]  || [[ $(skupper status -n $SECOND_NS | grep 'It is connected') == '' ]]
do
  sleep 5;
  echo "Waiting for skupper link to be ready. Retrying in 5 seconds...";
done
echo "Skupper link is ready. The namespaces can communicate through skupper."
