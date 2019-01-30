# Kubernetes Voting App

Today we're going to build the same voting app built previously with docker compose, only on top of Kubernetes.
Instead of a walkthrough document, you can find general requirements and the location of containers to be pulled, along with other parameters to set.

## Prerequisits

1. A running Kubernetes cluster with at least one node (in `Ready` state)
1. Helm + Tiller (use `helm/` if you need assitance)
1. A Kubernetes Dashboard

## How to build it

Below you'll find a table with all the required applications to run the voting app.
The `Name` indicates how to call each application where name is required (e.g in labels).


You'll find `templates/` dir where you can use ready templates according to the `Kind` required in the table.
Note that where `Service` exists, you'll need to expose a service so that the pod is accessible from anywhere in the cluster.

Use the templates by filling in relevant values, and `apply`ing them on to your Kubernetes cluster. Make sure they are all running with no failures, **read their logs to be certain**.

## How to access it

In order to access the applications we need an **Ingress Controller**, which is easily installed with `Helm` (look for `helm/` in the project).
Once the ingress controller is installed, we need to utilize ingress configurations, which you'll also find templates for in `/templates`.
Since we don't have a DNS server at the moment, we'll use an external service called xip.io like so:
```
# These entries should be the values of the ingress hosts
# They should be then accessible from the browser
#
vote.<strigo IP>.xip.io
result.<strigo IP>.xip.io
```
Once set, you'll be able to access `vote` and `result` directly from the browser like so: `http://vote:30001`
(*30001 is the port set for the ingress controller*)


## Applications

Name | Image | Command | Port | Kind | Ingress Host | Service
--- | --- | --- | --- | --- | --- | ---
vote | prodopsio/vote:latest | python app.py | 80 | ReplicaSet | vote.IP.xip.io | vote:80
result | prodopsio/vote:result | nodemon server.js | 5001 & 5858 | ReplicaSet | result.IP.xip.io | result:80
worker | prodopsio/vote:worker | - | - | ReplicaSet | - | -
redis | redis:alpine | - | 6379 | StatefulSet | - | redis:6379
db | postgres:9.4 | - | 5432 | StatefulSet | - | db:5432


## Defintion of Done
- [ ] All pods are up and running - no CrashLoopBacks
- [ ] Logs have been extraced from all pods showing successful runtimes
- [ ] Dashboard is up, running and accessible
- [ ] The Voting and Result applications are accessible from the browser, and are fully operational (voting changes the result)

