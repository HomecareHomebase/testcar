# Documentation roughwork

# To address...
I guess Testcar will run upon creation of every single pod of a given type. I haven't given much thought to this yet. I've been assuming it would run once per deployment, but it really continuously runs as long as the K8s deployment keeps starting and restarting pods.

Relatedly, there could theoretically be deployments that happen that don't naturally cause new instances to be spun up. As a contrived example, if we managed to deploy a new version of DOF without redeploying Doferator, the Knative services would be updated, but no PODs would be instantiated and there would be nothing to run tests against. The test design will have to take this into consideration. In the case of DOF, the test's request to an instance of DOF would cause knative to spin up a POD.

So what if Testcar reports errors and Testcar Gate fails the build? The SUT has already been deployed and theoretically is accessible to users. We need some mechanism of flagging a deployment as ready after it's been deployed and tested to be good. There are several well-established patterns for this in Kubernetes. We just need to define how we will use them.
