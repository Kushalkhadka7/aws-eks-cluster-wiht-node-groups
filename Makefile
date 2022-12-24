.PHONY: env, format
.DEFAULT_GOAL := format

init:
	@terraform init

plan:
	@terraform plan

output:
	@terraform output

format:
	@terraform fmt
	
apply: init
	@terraform apply -input=false -auto-approve

