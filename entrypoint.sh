#!/bin/bash
# Loop forever, running cleanup every $INTERVAL

set -eo pipefail

INTERVAL=${INTERVAL:-3600}

# NOTE this only works with JSON files, not p12
if [[ -n "$GOOGLE_APPLICATION_CREDENTIALS" ]]; then
    echo "Setting up service-account"
    gcloud auth activate-service-account "--key-file=$GOOGLE_APPLICATION_CREDENTIALS"
    gcloud container clusters get-credentials cluster-01-$ENV --region $ZONE --project $PROJECT --quiet
fi

# Setting this to true will use the gcloud auth plugin for kubectl
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

while true; do
    echo "Executing delete-orphaned-kube-network-load-balancers.sh @ $(date)"

    bash /cleanup/delete-orphaned-kube-network-load-balancers.sh

    echo "Sleeping for $INTERVAL"
    sleep "$INTERVAL"
done
