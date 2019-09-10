# Documentation roughwork

Non-DOF documentation that would be good for Testcar:
How to debug/test/etc.

# Where do these sentences fit?
Fail-safe path and (un)intentional circumvention of Testcar
In any of the following scenarios...
* Testcar runs tests and they fail
* Testcar runs but finds no tests
* Testcar runs but experiences internal failure
* Testcar is completely skipped and not run at all
...then there will be no logs for Testcar Gate to read and it will fail the ADO release.
Limitations of failsafe
The failsafe can be truly circumvented in the following situations
* Tests exist but don't correctly test behavior or pass when the SUT is actually broken
* Testcar Evaluator is not in the deployment pipeline
To mitigate these eventualities, we rely on human oversight and peer review.
Testcar Gate is required to be part of the ADO release pipeline of systems that subscribe to Testcar's methodology. As such, making Testcar Gate part of the default pipeline templates and preventing it from being removed can help mitigate the latter above.
## Scalability
Testcar doesn't require any kind of horizontal scalability. It makes a best-effort one-shot attempt to run its suite of tests, and logs any success or failure.
## Performance
Testcar doesn't operate within the customer's user flow. Poor performance will result in slower deployments and hence slower feedback loops to developers. As such, while performance is not crucial, it should not be completely ignored.


# To address...
I guess Testcar will run upon creation of every single pod of a given type. I haven't given much thought to this yet. I've been assuming it would run once per deployment, but it really continuously runs as long as the K8s deployment keeps starting and restarting pods.

Relatedly, there could theoretically be deployments that happen that don't naturally cause new instances to be spun up. As a contrived example, if we managed to deploy a new version of DOF without redeploying Doferator, the Knative services would be updated, but no PODs would be instantiated and there would be nothing to run tests against. The test design will have to take this into consideration. In the case of DOF, the test's request to an instance of DOF would cause knative to spin up a POD.

So what if Testcar reports errors and Testcar Gate fails the build? The SUT has already been deployed and theoretically is accessible to users. We need some mechanism of flagging a deployment as ready after it's been deployed and tested to be good. There are several well-established patterns for this in Kubernetes. We just need to define how we will use them.

# Interesting reading, but not really relevant
https://github.com/kubernetes/enhancements/issues/753
