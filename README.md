# TeamCity in EKS

### Requirements

- [task](https://taskfile.dev/) - as an analog of `make`(to make something like CICD)
- [terraform](https://http://terraform.io/) - to provision an infrastructure
- [helm](https://helm.sh/) - to deploy to Kubernetes
- [jq](https://github.com/stedolan/jq) - for matching terraform and helm charts variables

### How to deploy

- Create infrastructure(terraform + cluster infra charts):
```shell
task deploy-all
```
If you need you can apply only terraform infra: `task terraform-apply` or only helm charts(infra apps): `task deploy-infra-apps`  

- Deploy Tenant infrastructure(terraform + tc chart): 
```shell
cd tenants/tenant1
task deploy-all
cd ../..
```
If you need you can apply only terraform: `task terraform-apply` or only tc chart: `task deploy-tc`  

- Add cognito user. Example (user: user@example.com, temp pass: qwerty123):
```shell
cd tenants/tenant1
task add-cognito-user
cd ../..
```

- Move on

### How to destroy

- Destroy tenant infrastructure(terraform + tc chart)
```shell
cd tenants/tenant1
task delete-all
```
- Destroy cluster infra + infra applications
```
cd ../..
task delete-all
```

### Todos
1. Replace current tc-agent specs with cloud profile (the infrastructure is written specifically for this scenario, but it isn't clear how to configure cloud profile not from ui)
2. MySQL encryption in transit - TC side? MySQL auth using IAM token instead static password(Does tc support this?)
https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.Connecting.AWSCLI.html
3. S3 backend. For test purpose local state is used, but in real infrastructure it is required to use S3 backend + dynamodb lock
4. Cloudfront todo: 
   - restrict access to cloudfront content https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-choosing-signed-urls-cookies.html
   - configure teamcity to use cloudfront for artifacts?
5. Monitoring and logging

Improvements:
- 2 replicas of tc-server + pdb with max_unavailable=1
- use network policies (for this purpose we need to configure cillium in addition to or instead of vpc cni)
- we can upgrade cluster on 1.21 version and start using containerd as runtime 
