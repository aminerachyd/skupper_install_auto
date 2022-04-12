#!/bin/bash

# Create two projects on the cluster
oc new-project east
oc new-project west

# Apply site-controller to watch for skupper configurations
oc apply -f deploy-watch-current-ns.yaml -n east
oc apply -f deploy-watch-current-ns.yaml -n west

# Apply skupper configuration for each site, deployments skupper-router and skupper-service-controller will be created
oc apply -f west-site.yaml -n west
oc apply -f east-site.yaml -n east

# Fetch login token from a namespace and pass it to another
oc apply -f token-request.yaml -n west
oc secret get west-secret -o yaml > west-secret.yaml
sed 's/namespace: west/namespace: east/' west-secret.yaml | oc apply -f - -n east

# Verify skupper status for each namespace
skupper status -n west
skupper status -n east
