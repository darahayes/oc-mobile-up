# oc-mobile-up

oc-mobile-up is a quick and easy method for __local development__ of Aerogear Services on OpenShift. For evaluation of Aerogear Services please see the [Aerogear Minishift Mobile Core Addon](https://github.com/aerogear/minishift-mobilecore-addon) project.

## Supported Operating Systems

* Mac Os
* Linux

## Prerequisites

Befeore running this project you need to do the following:

* [Instal Docker](https://www.docker.com/community-edition)
* [Create a Dockerhub Account](https://hub.docker.com/)
* [Install v3.9.0 (or greater) of the OpenShift CLI tool](https://github.com/openshift/origin/releases/tag/v3.9.0)

## Getting Started

First you must export some environment variables:

```bash
export registry_username=<your dockerhub username>
export registry_password<your dockerhub password>
```

Then run the script

```bash
./up.sh
```

If the script is successful, The OpenShift console is available at [https://192.168.99.100:8443](https://192.168.99.100:8443).

**Note that you may not instantly see the mobile services** in the service catalog as it takes 1-2 minutes for the ansible-service-broker to become ready.

## What Happens?

The `up.sh` script is very basic. It essentially does the following:

* executes `oc cluster up`
* creates the Mobile Custom Resource Definition and appropriate roles
* Deploys the ansible service broker using [`./scripts/provision-ansible-service-broker.sh`](provision-ansible-service-broker)

## Next Steps

This script does not install a custom version of the origin-web-console. You will probably want run your own version for local development.

Clone the [Aerogear fork](https://github.com/aerogear/origin-web-console) of the origin-web-console.

```
git clone git@github.com:aerogear/origin-web-console
```

Open `app/config.js` in the origin-web-console and updatethe `masterPublicHostname` variable to `'192.168.99.100:8443'`. This allows your local version of the web console to talk to the openshift cluster.

