# 1. AWS VPC Infrastructure Overview

## Components

| Resource Type              | Count | Description                                           |
|---------------------------|-------|-------------------------------------------------------|
| `aws_vpc`                 | 1     | Virtual Private Cloud with CIDR block `10.0.0.0/16`. |
| `aws_subnet`              | 4     | 2 Public + 2 Private subnets across 2 AZs.           |
| `aws_internet_gateway`    | 1     | Provides internet access to public subnets.          |
| `aws_nat_gateway`         | 1     | Enables outbound internet for private subnets.       |
| `aws_eip`                 | 1     | Elastic IP for the NAT gateway.                      |
| `aws_route_table`         | 2     | 1 for public, 1 for private routes.                  |
| `aws_route_table_association` | 4 | Associates subnets with respective route tables.     |

## Workflow / Architecture Flow
1. VPC Created with CIDR `10.0.0.0/16`.

2. Public Subnets in `us-east-1a` and `us-east-1b` created:
    - Associated with an Internet Gateway.
    - Instances launched here get public IPs and direct internet access.

3. Private Subnets in both AZs:
    - Have no direct internet access.
    - Route internet traffic through a `NAT Gateway` in a public subnet.

4. Route Tables:
    - Public Route Table: Directs `0.0.0.0/0` via `Internet Gateway`.
    - Private Route Table: Directs `0.0.0.0/0` via `NAT Gateway`.


## Estimated Monthly Cost

| Resource            | Estimated Cost                |
|---------------------|-------------------------------|
| VPC & Subnets       | $0                            |
| Internet Gateway    | $0                            |
| Elastic IP (EIP)    | ~$3.60                        |
| NAT Gateway         | ~$32.40 + data transfer       |
| **Total (approx.)** | **~$36+/mo**                  |


## Architecture Diagram (Text Representation)

                              +--------------------+
                              |   Internet         |
                              +---------+----------+
                                        |
                              +---------v----------+
                              |  Internet Gateway  |
                              +---------+----------+
                                        |
                +-----------------------+----------------------+
                |                                              |
     +----------v-----------+                     +-----------v----------+
     |  Public Subnet A     |                     |  Public Subnet B     |
     | (us-east-1a)         |                     | (us-east-1b)         |
     | + NAT Gateway        |                     |                      |
     +----------+-----------+                     +-----------+----------+
                |                                             |
     +----------v-----------+                     +-----------v----------+
     |  Private Subnet A     |                    |  Private Subnet B    |
     |  (us-east-1a)         |                    |  (us-east-1b)        |
     |  Routes via NAT GW    |                    |  Routes via NAT GW   |
     +-----------------------+                    +----------------------+



Note: NAT Gateway incurs $0.045/hour and $0.045/GB data processed. Costs may rise depending on usage.

# 2. 🛡️ AWS IAM Setup for ECS using Terraform
This Terraform script provisions the necessary AWS IAM roles, policies, and instance profiles required for running Amazon ECS using both EC2 and Fargate launch types.

## ✅ IAM Roles, Policies, and Instance Profile

### 1️⃣ aws_iam_role.ecs_instance_role  
**Purpose**: IAM role that EC2 instances assume to communicate with ECS and other AWS services.

### 2️⃣ aws_iam_role_policy_attachment.ecs_instance_role_policy  
**Purpose**: Attaches the AWS-managed policy `AmazonEC2ContainerServiceforEC2Role` to the EC2 IAM role, enabling ECS container instance functionality.

### 3️⃣ aws_iam_instance_profile.ecs_instance_profile  
**Purpose**: Allows the EC2 IAM role to be attached to ECS container instances when launching them.

### 4️⃣ aws_iam_role.ecs_task_execution_role  
**Purpose**: IAM role that ECS tasks assume at runtime to access required AWS services (e.g., ECR, CloudWatch, Secrets Manager).

### 5️⃣ aws_iam_role_policy_attachment.ecs_task_execution_policy  
**Purpose**: Attaches the AWS-managed policy `AmazonECSTaskExecutionRolePolicy` to the ECS task execution role, enabling ECS tasks to pull images, send logs, and access secrets.

# 3. 🖥️ ECS-based application on EC2 using a Launch Template

- This section of Terraform code provisions core infrastructure to support an ECS-based application on EC2 using a Launch Template, Auto Scaling Group, Load Balancer, Listeners, and Security Groups.

## 3.1 EC2 Launch Template
In our code the EC2 launch template created the following:
   - An EC2 launch template that defines the configuration for ECS container instances, including:
   - AMI (ami-0b42a7f312a9ed8a5)
   - Instance type (t3.micro)
   - Key pair (vignesh)
   - IAM role (ecs_instance_profile)
   - Disk config (30GB gp2)
   - ECS bootstrap script (ecs.sh via user_data)

## 3.2 Auto Scaling Group (ASG)
   - An Auto Scaling Group that:
     - Launches EC2 instances using the Launch Template
     - Spans two public subnets
     - Maintains between 1 and 3 ECS container instances
     - Automatically registers instances with ECS via the ecs.sh bootstrap script
## 3.3 🌐 Application Load Balancer (ALB)
 - An external ALB that:
      - Distributes traffic across frontend/backend services
      - Is placed in public subnets
      - Associated with the general security group
      - Tagged as ecs-alb
## 3.4 🔁 ALB Listeners
   - Creates:

        - HTTP listener (port 80):
             -   Forwards HTTP requests to frontend target group
        - HTTPS listener (port 443):
             -   Uses ACM certificate for SSL termination
             -   Forwards HTTPS requests to frontend target group
## 4. Security Groups
### 4.1 🔧 General ECS Security Group
- Creates:
     - Allows:
          - SSH (22) from anywhere (⚠️ insecure)
          - HTTP (80) and HTTPS (443) from anywhere
          - Used by EC2 instances and ALB
### 4.2 🌐 Frontend Security Group
- Creates:
     - Allows:
          - Port 3000 inbound from ALB SG (used by frontend container)
          - Used by ECS frontend service

## 4.3 🔒 Backend Security Group
- Creates:
     - Allows:
         - Port 8080 inbound only from ALB SG
         - Used by ECS backend service (Spring Boot API)




    
