# Auto-Injection
To ensure developers fall into the pit of success, your Kubernetes cluster should be configured to auto-inject Testcar into user pods at creation time. This can be accomplished with https://github.com/tumblr/k8s-sidecar-injector

# Unanswered questions
Since Testcar should run once upon deployment and never again for that deployment, the injection must be configured accordingly. How this is done is a somewhat open-ended question at this point.

Relatedly, there could theoretically be deployments that happen that don't naturally cause new instances to be spun up. As a contrived example, if we managed to deploy a new version of DOF without redeploying Doferator, the Knative services would be updated, but no PODs would be instantiated and there would be nothing to run tests against. This is currently too much of an edge case to pay special attention to.
