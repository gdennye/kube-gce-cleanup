GCE cleanup scripts
===================

Scripts in this directory are necessary due to bugs in GKE that
cause network load-balancer resources to become orphaned and unused but
accruing charges against the account. These charges can be substantial. Before
we realized what was happening (with the help of google support) we were seeing
40-50% of the monthly bill going to these network load-balancer resources.

<!-- toc -->

- [GCE cleanup scripts](#gce-cleanup-scripts)
  - [Usage](#usage)
    - [Configuration](#configuration)
    - [Running the script](#running-the-script)
  - [Deployment](#deployment)
  - [Development \& Testing](#development--testing)

<!-- tocstop -->

Usage
-----

### Configuration

Configuration is handled through environment variables:

- `PROJECT`: The GCE project that we should operate on
- `REGION`: The region where GCE resources should be probed
- `GKE_CLUSTER_NAME`: The Kube cluster name for verifying network resources against
- `KUBE_CONTEXT`: the kube context to use when running kubectl commands - not needed when running inside a cluster.

### Running the script

Set the env variables and execute the script
```
PROJECT: <project-id> \
REGION: <region> \
ZONE: <zone> \
GKE_CLUSTER_NAME: <gke-cluster-name> \
GOOGLE_APPLICATION_CREDENTIALS: /cleanup/credential.json \
ENV: <env> \
KUBE_CONTEXT: gke_<project-id>_<zone>_<gke-cluster-name> \
./delete-orphaned-kube-network-load-balancers.sh
```

This script is derived from the similar script in the kubernetes github repo.
That script deletes load-balancers that are pointing to nodes that no longer
exist. This is helpful but does not cleanup all orphaned resources.

The `delete-orphaned-kube-network-load-balancers.sh` is written and maintained
by Pantheon and offers a more complete cleanup function. It uses `kubectl` to
get a list of public IP's assigned to active Services and then iterates through
gcloud firewall-rules and forwarding-rules looking for IP's that are not in use
by the cluster.


Deployment
----------

See the `deployment-example.yaml` file for an example Deployment.


Development & Testing
---------------------

It's just a simple shell script. All code should pass shellcheck linting
(`make test` or `make test-shell`) and follow the
[Google Shell Style Guide](https://google.github.io/styleguide/shell.xml).

`make build-docker` will build the docker container. `make push` will push
it to quay.io. You can override the repo by setting the REGISTRY variable on
the make task.
