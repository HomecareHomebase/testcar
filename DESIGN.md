# Epic(s)
  * #139610

[[_TOC_]]


# Design
Drill into the specific design areas via the following sub-pages
* [Overview](CONCEPTS.md)
* [Testcar Agent](AGENT.md)
* [Testcar Gate](GATE.md)
* [Auto-injection](INJECTION.md)

## Tech Stack
Testcar is built on top of several technologies, some are core components that allow the system to work, while others are additive that could be replaced.

### Docker
Testcar is packaged into Docker run time image(s) for simple self containment, dependency gathering, and ease of deployment.

### Kubernetes
Testcar is designed as a Kubernetes sidecar. While it could theoretically run without K8s, doing so would call into question the reason Testcar exists.

### Artillery
Although it's hoped in the future it may support multiple integration test frameworks, Testcar is being built from the ground up as an enabler of Artillery tests. Modularization will come later, if at all.

### Shell script
Being a glue product between containers, Artillery, and authentication schemes, Testcar's most significant logic will be implemented as shell scripts.

### Testcar-ADO
Node.js and TypeScript are first class citizens when it comes to writing custom ADO pipeline tasks. As such, they will be used for this component.


## Authentication / Authorization
Testcar will be required to test its System Under Test (SUT) container as a black box. It needs to be able make HTTP requests using whatever authorization mechanism the SUT container's clients typically use. This lends itself strongly to an authorization-as-a-module approach, with the initial model being to use Kerberos authorizaiton against a token service to gain an OAuth token, and then using the OAuth token to make requests its SUT.

# Infrastructure
Testcar is intended to be hosted as a sidecar container inside the K8s pod of its SUT. Being an ancillary application, Testcar's needs should not significantly impact the choice of capabilities of the K8s cluster.

# DevOps
## Availability
Since this is a development tool and not within the customer's user flow, high availability is not as important. The fail-safe is that a newly deployed version of the SUT is not flagged as good. The existing SUT version will be unaffected and continue serving requests. In the event of a prolonged outage, manual execution of integration tests against a SUT deployment should be considered.

## Disaster Recovery
Testcar itself has no DR system in place, since there is no durable storage or recovery of data needed. Testcar only operates at time of deployment of its SUT, so any DR efforts to deploy the SUT to another cluster will result in Testcar being auto-injected and activated.

# Security
[Threat Model](https://htmlpreview.github.com/?https://github.com/Balfa/testcar/blob/master/Testcar_threat_model_report.htm)
(See also [Testcar_threat_model.tm7](Testcar_threat_model.tm7), created using Microsft Threat Modeling Tool 7.1)

# Shortcomings of this documentation
We're currently in a strange place where Artillery is both a module for Testcar, and _the only_ way Testcar works for the foreseeable future. As such, documentation might flip back and forth between taking Artillery's use for granted, and not.
