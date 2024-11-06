#!/bin/bash

# Fetch the latest changes on the main branch
git fetch origin main --depth=2

# Check for changes in project-a directory
if [ $(git diff HEAD~ --name-only --relative=project-a | wc -l) -gt 0 ]; then
    echo "Changes detected in project-a. Deploying endpoint-a.py..."
    modal deploy --env=sandbox project-a/endpoint-a.py
else
    echo "No changes detected in project-a. Skipping deployment for endpoint-a."
fi

# Check for changes in project-b directory
if [ $(git diff HEAD~ --name-only --relative=project-b | wc -l) -gt 0 ]; then
    echo "Changes detected in project-b. Deploying endpoint-b.py..."
    modal deploy --env=sandbox project-b/endpoint-b.py
else
    echo "No changes detected in project-b. Skipping deployment for endpoint-b."
fi