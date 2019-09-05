# Testcar Sidecar Agent
The Testcar sidecar is responsible for:
  * Discovery of tests
  * Execution of the tests against the System Under Test (SUT)
  * Reporting of results using standard Kubernetes patterns (i.e., stdout)
  * Meeting any prerequisites for the test execution (e.g., obtaining appropriate credentials to call the SUT service)

# Test Discovery
The Testcar container will look for tests in `/etc/testcar/tests/`. This directory is a shared K8s volume mounted in both the Testcar container and the SUT container. The intent is that the SUT will be aware of Testcar's requirement to look in this directory and its container image will include some (Artillery) test definitions as well as the SUT itself. The location of these test definitions will then need to be specified in the K8s manifest for mounting the volume.

# Execution
Testcar, having found the test definitions, must now pass these on to the actual test framework doing the work. In the case of Artillery, this is as simple as calling `artillery run -c <path>`.

# Reporting
First and foremost, Artillery exits with an appropriate zero or non-zero exit code. This should be the ultimate test of success. Testcar captures this and reports a machine readable status output for Testcar Gate.

## Log persistence
K8s provides access to container logs for n and n-1 container instances. Since Testcar is a run-once-and-stay-dead, Testcar Gate will still have access to the one and only log set (n-1).

## Preventing container restarts
We don't want Testcar continuously running. We also don't want it constantly overwriting the n-1 logs that Testcar Gate is relying on.
TODO: Testcar runs once upon deployment, and then never again. How do we ensure it doesn't? Probably straightforward. Just call it out here anyway.

# Prerequisites
Testcar will need to call the SUT as if it were a regular client. To this end, it will need to gather any credentials required to make those requests before making them.
## OAuth module
One means a SUT has of authenticating and authorizing Testcar is via an OAuth token. A Testcar module will need to exist that enables it to make a preflight request to a token service to get a bearer token.
## Kerberos module
Another means of authorizing Testcar is with a Kerberos ticket. Another module will be required that can perform this step.
## Chaining modules
It's possible that the the token service might require Kerberos auth before providing a bearer token. Chaining modules can facilitate this.
