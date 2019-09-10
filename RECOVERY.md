# Fault Model and Recovery Playbook

![failure.png](/.attachments/failure-bf2d3f87-7f7e-42f5-a26e-dc61439a448f.png)

## Kubernetes cluster goes offline
The entire cluster going offline is a rare edge case event, and should be treated as a disaster scenario (with recovery).

### Technical Impact
No deployments will happen in the cluster, so testcar will not be executed or needed.

### Customer Impact
No customer impact beyond the impact by the SUT services being unavailable.

### Data Loss
Any existing runs of testcar will lose their state, but the SUT deployment they were operating against will no longer exist anyway, so this has no impact.

### Remediation
First it must be determined if the cluster is offline because of a network/firewall/route issue, or if the nodes are offline. If a network based issue it might be possible to restore connectivity and bring the cluster back online. If the nodes are offline, and there appears to be no indication of them coming back up the remediation should be to execute a DR for this system, which can be found in the playbooks.

## System Under Test unavailable or offline
The SUT service might be experiencing problems. In this case, Testcar is likely to run tests against the SUT that fail, as they should, and report a failure. This is not so much a failure scenario as much as Testcar operating normally and doing the job it's supposed to be doing.

## Errors internal to Testcar
A scenario could arise where Testcar has some failure despite its SUT being healthy.

### Technical Impact
Testcar Gate will fail the build and the SUT deployment will never be marked as passing. The existing deployment version of the SUT will continue to operate normally and serve requests. The new version of the SUT will behave as if it were never deployed.

### Customer Impact
Customers will continue to see old behaviors. Depending on how inter-service dependencies and deployments are managed (which at this point is more of a human process outside the scope of this document), it's possible that a service dependent on the new version will succeed in being deployed, and then may behave abnormally because its dependencies are not met. The outcomes of this vary widely and will be based on the specific inter-serviec dependencies.

### Data Loss
Since no new version was deployed, and the old service continues to serve requests, no data loss intrinsic to the SUT would occur. However, see the caveat above regarding the human process of dependency management.

### Remediation
Investigation should start with the logs from Testcar Gate in the ADO pipeline.