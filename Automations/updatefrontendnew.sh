#!/bin/bash

# Path to frontend .env file
file_to_find="../frontend/.env.docker"

# Get the backend NodePort dynamically from Kubernetes
backend_port=$(kubectl get svc backend-service -n wanderlust -o jsonpath='{.spec.ports[0].nodePort}')

# Construct the new VITE_API_PATH
new_url="VITE_API_PATH=\"http://localhost:${backend_port}\""

# Read the current VITE_API_PATH value from the file
current_url=$(grep VITE_API_PATH $file_to_find)

# Update the .env file if the value has changed
if [[ "$current_url" != "$new_url" ]]; then
    if [ -f $file_to_find ]; then
        sed -i -e "s|VITE_API_PATH.*|$new_url|g" $file_to_find
        echo "Updated frontend .env.docker with $new_url"
    else
        echo "ERROR: File not found: $file_to_find"
    fi
else
    echo "No update needed. VITE_API_PATH is already set to $new_url"
fi

