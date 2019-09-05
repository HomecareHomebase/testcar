# Testcar Gate
Testcar Gate is responsible for:
  * Discovery of Testcar instance
  * Polling Testcar's K8s logs for test results
  * Delaying the release pipeline until logging of test results is complete
  * Passing or Failing an ADO release based on the results of testing
  * Providing a human-readable reason in the case of failure (e.g., just pasting the logs directly from Testcar)

# Testcar discovery
The Testcar container will, by convention, be called `testcar`. It can be found within each pod of a given type, and K8s already provides straightforward conventions for pod discovery.
Testcar Gate will also have access to ADO variables that will aid it in figuring out 

# Polling the logs and delaying the pipeline
  * Hit the K8s logs API until the returned logs include the indication that Testcar has completed.
  * Polling delay between logs API calls: 10 seconds
  * See https://github.com/godaddy/kubernetes-client/blob/master/examples/pod-logs.js
# Pass or fail
  * If Testcar's logs show a (explicitly included) status code of 0, then the tests have succeeded.
    * Continue and allow the ADO Release to succeed.
  * If Testcar's logs cannot be obtained, or do not include a final status code, or have a non-zero final status code, then the tests are considered to have failed and Testcar Gate will flag the ADO Release as failing.
  * A Timeout for the entire build task is shall be 5 minutes. If this passes without having obtained a status code of zero from the logs, then Testcar Gate will flag the ADO Release as failing.

# Human readable output
In addition to an exit code of zero or non-zero, Testcar Gate should provide in the ADO Release logs a human-readable description of why the task failed.
