#!/bin/bash

# Path to backend .env file
file_to_find="../backend/.env.docker"

# Get the frontend NodePort dynamically from Kubernetes
frontend_port=$(kubectl get svc frontend-service -n wanderlust -o jsonpath='{.spec.ports[0].nodePort}')

# Construct the new FRONTEND_URL
new_url="FRONTEND_URL=\"http://localhost:${frontend_port}\""

# Read the current FRONTEND_URL value from the file
current_url=$(grep FRONTEND_URL $file_to_find)

# Update the .env file if the value has changed
if [[ "$current_url" != "$new_url" ]]; then
    if [ -f $file_to_find ]; then
        sed -i -e "s|FRONTEND_URL.*|$new_url|g" $file_to_find
        echo "Updated backend .env.docker with $new_url"
    else
        echo "ERROR: File not found: $file_to_find"
    fi
else
    echo "No update needed. FRONTEND_URL is already set to $new_url"
fi

