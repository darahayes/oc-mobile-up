# oc-mobile-up

oc-mobile-up is a quick and easy method for __local development__ of Aerogear Services on OpenShift. For evaluation of Aerogear Services please see the [Aerogear Minishift Mobile Core Addon](https://github.com/aerogear/minishift-mobilecore-addon) project.

## Supported Operating Systems

* Mac OS
* Linux

## Prerequisites

Befeore running this project you need to do the following:

* [Install Docker](https://www.docker.com/community-edition)
* [Create a Dockerhub Account](https://hub.docker.com/)
* [Install v3.9.0 (or greater) of the OpenShift CLI tool](https://github.com/openshift/origin/releases/tag/v3.9.0)
* [Refer to oc cluster up documentation for more prerequisites](https://github.com/openshift/origin/blob/master/docs/cluster_up_down.md)

## Getting Started

First you must export some environment variables:

```bash
export registry_username=<your dockerhub username>
export registry_password=<your dockerhub password>
```

Then run the script

```bash
./up.sh
```

If the script is successful, The OpenShift console is available at [https://192.168.99.100:8443](https://192.168.99.100:8443).

**Note that you may not instantly see the mobile services** in the service catalog as it takes 1-2 minutes for the ansible-service-broker to become ready.

## What Happens?

The `up.sh` script is very basic. It does the following:

* executes `oc cluster up`
* Creates the Mobile Custom Resource Definition and appropriate roles
* Deploys the ansible service broker using [`./scripts/provision-ansible-service-broker.sh`](./scripts/provision-ansible-service-broker.sh)

## Additional Options

#### `cluster_ip`

It is possible to start the cluster with a different IP address.

```bash
cluster_ip=127.0.0.1 ./up.sh
```

#### `skip_oc_cluster_up`

If you like to start your OpenShift cluster using some other tooling, it is possible to skip the `oc cluster up` command and apply the Mobile specific parts to your cluster. This is for advanced users only. Ensure you specify the correct `cluster_ip`.

```bash
cluster_ip=<your cluster ip> skip_oc_cluster_up=true ./up.sh
```

## Local Development of origin-web-console

This script does not install a custom version of the origin-web-console. You will probably want run your own version for local development.

Clone the [AeroGear fork](https://github.com/aerogear/origin-web-console) of the origin-web-console.

```bash
git clone git@github.com:aerogear/origin-web-console
```

Open `app/config.js` in the origin-web-console and update the `masterPublicHostname` variable to `'192.168.99.100:8443'`. This allows your local version of the web console to talk to the openshift cluster.

Now install the console's dependencies. (from within the origin-web-console directorys)

```bash
./hack/install-deps.sh
```

Now run the console.

```bash
grunt serve
```

Please consult the [origin-web-console Readme](https://github.com/openshift/origin-web-console) for more info.

## Local Development of origin-web-console

Integrating with running OpenShift 

```bash
export skip_oc_cluster_up=true
```

## Troubleshooting

### Docker version on Mac OS

The `oc cluster up` command is incompatible with newer versions of Docker for Mac OS. [Version 17.09.0](https://download.docker.com/mac/stable/19543/Docker.dmg) is recommended.

### Firewall Rules Error (Mac OS)

```
Error: timed out waiting for OpenShift container "origin"
  WARNING: 192.168.99.100:8443 may be blocked by firewall rules
```

If the `oc cluster up` command fails with a similar error, try running the installer again with the ip address `127.0.0.1`.

```bash
oc cluster down && cluster_ip=127.0.0.1 ./up.sh
```

