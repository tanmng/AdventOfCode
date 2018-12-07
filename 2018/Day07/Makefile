DONE_FILE=done
MODULE_DIR=compute

# Change this if your system has different name for the binaries of terraform or
# pbcopy
TERRAFORM_BIN=terraform
PBCOPY_BIN=pbcopy


graph: construct_module
	pushd .
	mkdir ${MODULE_DIR}
	cd ${MODULE_DIR}
	${TERRAFORM_BIN} graph > graph.dot
	echo ' digraph { \
	compound = "true" \
	newrank = "true" \
	subgraph "root" {' > ${DONE_FILE}
	grep -E ".*null_resource.*null_resource.*" graph.dot >> ${DONE_FILE}
	echo  ' } \
	}' >> ${DONE_FILE}
	${PBCOPY_BIN} < ${DONE_FILE}
	popd

construct_module:
	mkdir ${MODULE_DIR}
	${TERRAFORM_BIN} init
	${TERRAFORM_BIN} apply -auto-approve

clean:
	rm -rf ${DONE_FILE}
