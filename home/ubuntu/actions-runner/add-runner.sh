#!/bin/bash

# Create the runner and start the configuration experience
TOKEN=$(curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$ORGANIZATION/$REPO/actions/runners/registration-token | jq -r '.token')

./config.sh --url https://github.com/$ORGANIZATION/$REPO --token ${TOKEN} --labels self-hosted --unattended --disableupdate
# delete "--disableupdate" from command above
# --ephemeral - temporary deleted due to long start up time
# Last step, run it!
./run.sh
