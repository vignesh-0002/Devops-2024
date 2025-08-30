
## EKS needs two roles:
- you must create the EKS IAM roles before running aws eks create-cluster.

- 1. EKS Cluster Role (EKSClusterRole)

This role allows EKS to manage AWS resources on your behalf.

Create it with this command:

```
aws iam create-role \
  --role-name EKSClusterRole \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": { "Service": "eks.amazonaws.com" },
        "Action": "sts:AssumeRole"
      }
    ]
  }'

```

- Then attach the required policy:

  ```
  aws iam attach-role-policy \
  --role-name EKSClusterRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy
  ```

##  2. EKS Node Group Role (EKSNodeInstanceRole)

- This role allows EC2 nodes in the cluster to connect to EKS and other AWS services.

- Create it:
  
  ```
  aws iam create-role \
  --role-name EKSNodeInstanceRole \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": { "Service": "ec2.amazonaws.com" },
        "Action": "sts:AssumeRole"
      }
    ]
  }'

  ```

## 3.  Attach the required policies:

```
aws iam attach-role-policy \
  --role-name EKSNodeInstanceRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy

aws iam attach-role-policy \
  --role-name EKSNodeInstanceRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly

aws iam attach-role-policy \
  --role-name EKSNodeInstanceRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy
```

## Steps to create Cluster:

- Command to create cluster:

```
aws eks create-cluster \
  --name budget-eks \
  --region us-east-1 \
  --role-arn arn:aws:iam::438465168997:role/EKSClusterRole \
  --resources-vpc-config subnetIds=subnet-0393724a838283392,subnet-036ee587b6816bf88,securityGroupIds=sg-052e7d0982f25afcb

```

- Here’s the command (using 2 EC2 nodes with t3.small for budget):

```
aws eks create-nodegroup \
  --cluster-name budget-eks \
  --nodegroup-name budget-ng \
  --scaling-config minSize=2,maxSize=2,desiredSize=2 \
  --disk-size 20 \
  --subnets subnet-0393724a838283392 subnet-036ee587b6816bf88 \
  --instance-types t3.small \
  --ami-type AL2023_x86_64_STANDARD \
  --node-role arn:aws:iam::438465168997:role/EKSNodeInstanceRole \
  --region us-east-1
```

