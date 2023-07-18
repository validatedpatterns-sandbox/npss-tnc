.PHONY: default
default: help

.PHONY: help

##@ Pattern tasks

# No need to add a comment here as help is described in common/
help:
	@make -f common/Makefile MAKEFILE_LIST="Makefile common/Makefile" help

%:
	make -f common/Makefile $*

.PHONY: install
install: operator-deploy post-install ## installs the pattern and loads the secrets
	@echo "Installed"

.PHONY: post-install
post-install: ## Post-install tasks
	make load-secrets
	@echo "Done"

KUBECONFORM_SKIP=-skip 'CustomResourceDefinition,Pipeline,Task,KfDef,Integration,IntegrationPlatform,Kafka,ActiveMQArtemis,KafkaTopic,SeldonDeployment,KafkaMirrorMaker,OdhDashboardConfig,ArgoCD,CertManager,Certificate,ClusterIssuer,HyperConverged,VirtualMachine,OCSInitialization,StorageCluster,QuayRegistry'
kubeconform:
	make -f common/Makefile KUBECONFORM_SKIP="$(KUBECONFORM_SKIP)" kubeconform
.PHONY: test
test:
	@make -f common/Makefile PATTERN_OPTS="-f values-global.yaml -f values-hub.yaml" test