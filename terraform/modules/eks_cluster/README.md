# eks_cluster

## Inputs
### Required variables

| Name  | Description   | Type   |
|---|---|---|
| eks_cluster_name  | name of the cluster  | string  |
| eks_version  | cluster version  | string   |
| subnet_ids   | list of subnet ids  | list   | 
| profile  | the variable is only used during kubeconfig file generation    | string  |
| admin_roles  | list of role arn for aws-auth config map (system:masters group, who can manage kubernetes resources)  | list  |
| kubeconfig_role   | role arn used in the kubeconfig file  | string   |
| tags  | tags used in the creation of all resources    | map   |
|   |   |   |

### Optional variables

| Name  | Description   | Type   | Default  |
|---|---|---|---|
| enabled_cluster_log_types  | list of cluster logg types  | list  | ["api", "controllerManager", "scheduler"]  |
| endpoint_public_access  | if your cluster API server is accessible from the internet  | bool  | true |
| endpoint_private_access  | if Kubernetes API requests within your cluster's VPC use the private VPC endpoint   | bool   | true   |
| create_kubeconfig   | whether to create a configuration file  | bool  | true |
| additional_worker_policies  | list of policy arn to attach to worker role* (see more information below)  | list  | [] |
| custom_aws_auth_roles | data to be passed to the aws-auth config map in mapRoles section. Used to grant restricted rights for users/groups in k8s cluster. See the example in `Additional information` | list | `[]`

### Additional information

#### Worker policies
*If no additional worker policies are passed (`additional_worker_policies`), the worker role has the following permissions:
- AmazonEC2RoleforSSM  
- AmazonEC2ContainerRegistryReadOnly
- AmazonEKS_CNI_Policy
- AmazonEKSWorkerNodePolicy

#### Security group for control plane
- created by Amazon EKS
- allow:
    - inbound traffic `within security group`
    - outbound traffic `all` 

#### Custom aws-auth roles.
Example:
```buildoutcfg
  custom_aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::975647215713:role/test_role"
      username = "test_user1"
      groups   = ["test_group"]
    }
  ]
```

## Usage example
```buildoutcfg
module "eks_cluster" {
  source = "./modules/eks_cluster"
  eks_cluster_name = "my-cluster"
  eks_version = "1.17"
  subnet_ids = [
    "subnet-0f4687b04a0bc2fc4",
    "subnet-03314838770b5d991",
    "subnet-0123ef3385571707c"
    ]
  profile = "my-profile"
  admin_roles = ["arn:aws:iam::account_id:role/role_name"]
  kubeconfig_role = "arn:aws:iam::account_id:role/role_name"
  additional_worker_policies = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
  tags = {
    "Environment" = "lab"
    "Team"        = "my-team"
  }
```
