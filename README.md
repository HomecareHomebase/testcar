# Testcar 📋🚗
An integration-testing sidecar for Kubernetes applications. Run integration tests automatically against newly deployed versions of your app. Integrate your build pipeline and fail the deployment if the tests fail.

# Quickstart
TODO

# Concepts
Testcar is a lightweight docker container that is auto-injected into your cluster's pods and will automatically find (by convention) and execute tests against the user container. The results are consumed by an Azure Devops release pipeline task that can flag a deployment as successful or failing.

## Supported test frameworks
Currently only [Artillery](https://artillery.io/) scripts are supported.

## How it finds tests
Test scripts ... TODO

## How it reports results
Testcar outputs to Kubernetes logs (via stdout). A build-pipeline tool such as testcar-ado can be used to interpret the results and flag a deployment as successful or not.