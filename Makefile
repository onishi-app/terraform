init-plan:
	terraform init;
	terraform fmt -recursive;
	terraform plan;

apply:
	terraform apply -auto-approve;

destroy:
	terraform init;
	terraform fmt -recursive;
	terraform plan -destroy;
	terraform fmt -check;
	terraform destroy -auto-approve -compact-warnings;