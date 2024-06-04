# A makefile for Reliable App Platform

# Run all commands in the same shell, to ease directory management
.ONESHELL:

# These are not standard makefile recipes, so treat them as phony.
.-PHONY: *

# Update the documentation embedded in the READMEs of the terraform modules
# This uses the following tool: https://terraform-docs.io/user-guide/installation/
# it can be installed with go install github.com/terraform-docs/terraform-docs@v0.17.0
update-tf-docs:
	terraform-docs markdown table modules/artifact-registry --output-file README.md --hide modules
	terraform-docs markdown table modules/deploy-pipeline --output-file README.md --hide modules
	terraform-docs markdown table modules/endpoints --output-file README.md --hide modules
	terraform-docs markdown table modules/onboard-app --output-file README.md --hide modules,header
	terraform-docs markdown table modules/slos --output-file README.md --hide modules
	terraform-docs markdown table modules/http-loadbalancer-global --output-file README.md --hide modules
