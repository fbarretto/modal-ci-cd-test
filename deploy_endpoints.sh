#!/bin/bash

# Get the branch name from the first argument
BRANCH_NAME=$1
# Echo the branch name
echo "Branch name: $BRANCH_NAME"
# Set branch name to "sandbox" for debugging purposes
# Fetch the latest changes on the specified branch
git fetch origin $BRANCH_NAME --depth=2

BRANCH_NAME="sandbox"
# Get the current commit hash
COMMIT_HASH=$(git rev-parse HEAD)

# # Set the environment based on the branch name
# if [ "$BRANCH_NAME" == "main" ]; then
#     ENV="main"
# else
#     ENV="dev"
# fi

# Loop through each directory in the src folder
for dir in src/*/; do
    dir=${dir%*/}
    dir_name=${dir##*/}
    
    # Check for changes in the directory
    if [ $(git diff HEAD~ --name-only --relative=$dir | wc -l) -gt 0 ]; then
        deploy_file=$(find $dir -maxdepth 1 -name "deploy*.py" | head -n 1)
        if [ -z "$deploy_file" ]; then
            echo "Error: No deploy file found in $dir_name. Skipping deployment."
            continue
        fi
        echo "Changes detected in $dir_name. Deploying $deploy_file..."
        modal deploy --env=$BRANCH_NAME --tag=$COMMIT_HASH $deploy_file
    else
        echo "No changes detected in $dir_name. Skipping deployment for $dir_name."
    fi
done
