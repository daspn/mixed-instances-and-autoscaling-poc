# Mixed Instances on ASG with Auto Scaling Policy POC

```
cd deployment/terraform
terraform init
terraform workspace select lab
terraform apply -var-file=environments/lab.tfvars -auto-approve
```

This code deploys EC2 instances in an ASG with an user data script that causes CPU spikes (~75% CPU use) during the first 12 minutes of its existence. So it's expected to observe the auto scaling policy in action adding more instances until the spike ends. After the spike end, the auto scaling policy will keep evaluating the resource use and will eventually scale the ASG in until the original desired value is achieved.

## Clean up
```
cd deployment/terraform
terraform destroy -var-file=environments/lab.tfvars -auto-approve
```