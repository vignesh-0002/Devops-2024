
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
