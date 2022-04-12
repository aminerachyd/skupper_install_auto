 - Use different namespaces
 - Deploy the site controller on each cluster : `kubectl apply -f https://raw.githubusercontent.com/skupperproject/skupper/0.8.6/cmd/site-controller/deploy-watch-current-ns.yaml`
 - Deploy sites in each namespaces : site1.yaml site2.yaml, one site doesn't need to accept incoming connections, so we it on the "edge". The edge paramter is set to "true" for this site.
 - Request token from one site and apply it to the other
 

