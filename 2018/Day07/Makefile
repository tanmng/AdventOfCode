MODULE_DIR=compute

# Change this if your system has different name for the binaries of terraform or
# pbcopy
TERRAFORM_BIN=terraform
PBCOPY_BIN=pbcopy


graph: construct_module
	cd ${MODULE_DIR}; \
	${TERRAFORM_BIN} init; \
	${TERRAFORM_BIN} graph > graph.dot; \
	${PBCOPY_BIN} < graph.dot;

construct_module:
	mkdir ${MODULE_DIR} || exit 0
	${TERRAFORM_BIN} init
	${TERRAFORM_BIN} apply -auto-approve -var-file real_input.tfvars
