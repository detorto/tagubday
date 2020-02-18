#!/usr/bin/env bash

set -e
set -o pipefail
set -v

curl -s -X POST https://api.stackbit.com/project/5e4bd0a2c2948f001b03cfe8/webhook/build/pull > /dev/null
if [[ -z "${STACKBIT_API_KEY}" ]]; then
    echo "WARNING: No STACKBIT_API_KEY environment variable set, skipping stackbit-pull"
else
    npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5e4bd0a2c2948f001b03cfe8 
fi
curl -s -X POST https://api.stackbit.com/project/5e4bd0a2c2948f001b03cfe8/webhook/build/ssgbuild > /dev/null
jekyll build
./inject-netlify-identity-widget.js _site
curl -s -X POST https://api.stackbit.com/project/5e4bd0a2c2948f001b03cfe8/webhook/build/publish > /dev/null
