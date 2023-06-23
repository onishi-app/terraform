TARGET := TARGET
PARALLEL_SIZE = 30

init-plan:
	terraform init;
	terraform fmt -recursive;
	terraform plan -out=output.tfplan;

init-plan-target:
	terraform init;
	terraform fmt -recursive;
	terraform plan -out=output.tfplan -target=$(TARGET);

apply:
	terraform apply -auto-approve output.tfplan;
	rm output.tfplan;

apply-target:
	terraform apply -auto-approve -target=$(TARGET) output.tfplan;
	rm output.tfplan;

destroy:
	terraform init;
	terraform fmt -recursive;
	terraform plan -out=output.tfplan -destroy;
	terraform fmt -check;
	terraform destroy -auto-approve -compact-warnings;
	rm output.tfplan;