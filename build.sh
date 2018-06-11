#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

SOURCE_BRANCH="master"
TARGET_BRANCH="development"
ENCRYPTION_LABEL="2fbc6d173e85"

# Pull requests and commits to other branches shouldn't try to deploy, just build to verify
if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "$SOURCE_BRANCH" ]; then
    echo "Skipping deploy; just doing a build."
    doCompile
    exit 0
fi

# Save some useful information
REPO="https://github.com/SudharakaP/ServiceLinkNode.git"
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}

# Clone the existing ServiceLinkNode server backend
# Create a new empty branch if it doesn't exist yet (should only happen on first deploy)
cd .. && git clone $REPO && cd Service-Link-Angular
cp -rf dist/* ../ServiceLinkNode/public/

cd ../ServiceLinkNode
git checkout $TARGET_BRANCH || git checkout --orphan $TARGET_BRANCH
rm -f .gitignore

# Now let's go have some fun with the cloned repo
git config user.name "Travis CI"
git config user.email "sudharaka@service-link.us"

# Commit the "changes", i.e. the new version.
git add public/*
git commit -m "TravisCI Auto Deploy: $TRAVIS_COMMIT"

# Get the deploy key by using Travis's stored variables to decrypt deploy_key.enc
cd ../Service-Link-Angular
ENCRYPTED_KEY_VAR="encrypted_${ENCRYPTION_LABEL}_key"
ENCRYPTED_IV_VAR="encrypted_${ENCRYPTION_LABEL}_iv"
ENCRYPTED_KEY=${!ENCRYPTED_KEY_VAR}
ENCRYPTED_IV=${!ENCRYPTED_IV_VAR}
openssl aes-256-cbc -K $ENCRYPTED_KEY -iv $ENCRYPTED_IV -in id_rsa.enc -out deploy_key -d
chmod 600 deploy_key
cd ../ServiceLinkNode
eval `ssh-agent -s`
ssh -o StrictHostKeyChecking=no github.com
ssh-add ../Service-Link-Angular/deploy_key

# Now that we're all set up, we can push.
git push $REPO $TARGET_BRANCH >/dev/null 2>&1