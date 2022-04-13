#!/bin/bash

# Delete the namespaces east and west
echo "Deleting both namespaces..."
oc delete project east
oc delete project west
