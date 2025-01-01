# Top 15 DevOps Interview Questions by Topic with Answers

## AWS
1. **What is the difference between EBS and S3?**  
   - **EBS**: Block storage for EC2 instances, used for high-performance storage.  
   - **S3**: Object storage, ideal for large-scale data storage like backups or logs.

2. **How does AWS Route 53 provide high availability?**  
   - Through DNS failover and routing policies like latency, geolocation, and weighted routing.

3. **What is the difference between a security group and a network ACL?**  
   - **Security Group**: Instance-level firewall with stateful rules.  
   - **Network ACL**: Subnet-level firewall with stateless rules.

4. **How do you enable high availability in AWS RDS?**  
   - Use Multi-AZ deployments to replicate data synchronously across availability zones.

5. **What are reserved instances, and how are they different from on-demand instances?**  
   - Reserved instances offer significant discounts for long-term commitments compared to on-demand pay-as-you-go instances.

6. **Explain the AWS Shared Responsibility Model.**  
   - AWS secures the infrastructure, while users secure data, OS, and application layers.

7. **How do you use AWS Lambda in a serverless architecture?**  
   - Write code for event-driven processes like API calls, database triggers, or S3 events.

8. **What is an Elastic IP, and how is it used?**  
   - A static public IP address used to maintain a consistent endpoint for instances.

9. **What is the difference between CloudFront and an Application Load Balancer?**  
   - CloudFront is a CDN for content delivery, while ALB distributes traffic across instances.

10. **How do you encrypt data at rest and in transit in AWS?**  
    - Use AWS KMS for at-rest encryption and SSL/TLS for in-transit encryption.

11. **What is the use of AWS Auto Scaling policies?**  
    - Automatically adjust compute resources based on demand.

12. **What are the key features of AWS ECS and EKS?**  
    - **ECS**: Container orchestration service for Docker containers.  
    - **EKS**: Managed Kubernetes service for deploying Kubernetes clusters.

13. **How do you monitor billing in AWS?**  
    - Use AWS Budgets, Cost Explorer, and Billing Dashboard.

14. **What is AWS Trusted Advisor, and how does it help optimize resources?**  
    - Provides recommendations for cost optimization, security, performance, and fault tolerance.

15. **How do you migrate on-premises data to AWS using Snowball or other tools?**  
    - Use AWS Snowball for large-scale data transfer or AWS DataSync for continuous sync.

---

## Terraform
1. **What are the benefits of using Terraform in a multi-cloud setup?**  
   - Unified management of resources across multiple clouds with consistent syntax.

2. **How do you import existing infrastructure into Terraform?**  
   - Use `terraform import` to map existing resources to Terraform configuration.

3. **What is a data source in Terraform, and how is it used?**  
   - A data source fetches information from an existing resource for use in configuration.

4. **Explain the difference between local and remote state in Terraform.**  
   - **Local State**: Stored on the user's machine.  
   - **Remote State**: Stored on a shared backend like S3 or Terraform Cloud.

5. **How do you resolve state file conflicts in Terraform?**  
   - Enable state locking and resolve conflicts by applying changes sequentially.

6. **What is the purpose of a `terraform.workspace`?**  
   - To manage multiple environments like dev, staging, and prod using a single configuration.

7. **How do you upgrade Terraform to a new version safely?**  
   - Test the upgrade in a sandbox environment and review the state file compatibility.

8. **What are the different backends supported by Terraform?**  
   - S3, Azure Blob Storage, Consul, Terraform Cloud, and more.

9. **Explain the concept of resource dependency in Terraform.**  
   - Dependencies are automatically inferred based on resource references.

10. **How do you execute a partial plan in Terraform?**  
    - Use `-target` to specify the resource to apply.

11. **What are the different types of provisioners in Terraform?**  
    - File, remote-exec, and local-exec provisioners.

12. **How do you implement dynamic blocks in Terraform configurations?**  
    - Use `for_each` or `count` to iterate and create dynamic blocks.

13. **What are provider versions, and how do you manage them in Terraform?**  
    - Specify the version in the provider block using the `version` attribute.

14. **How do you debug Terraform execution issues?**  
    - Use `terraform plan` or `terraform apply` with `-debug` for detailed logs.

15. **What are some best practices for structuring Terraform code?**  
    - Use modules, separate state files, and version-controlled repositories.

---

## Ansible
1. **What are the benefits of using Ansible over other configuration management tools?**  
   - Agentless, simple YAML syntax, and large community support.

2. **What is an Ansible handler, and how is it used?**  
   - A task triggered only when notified, used for actions like service restarts.

3. **How do you ensure idempotency in Ansible tasks?**  
   - By using Ansible modules designed for idempotent operations.

4. **What are Ansible variables, and how are they managed?**  
   - Parameters used in playbooks, stored in inventory files, or separate vars files.

5. **How do you handle sensitive information in Ansible?**  
   - Use `ansible-vault` to encrypt sensitive data like passwords.

6. **Explain the difference between `ansible-playbook` and `ansible` commands.**  
   - `ansible`: Executes a single ad-hoc task.  
   - `ansible-playbook`: Runs a structured playbook.

7. **What is the role of a dynamic inventory in Ansible?**  
   - Dynamically generates inventory data from cloud providers or external sources.

8. **How do you test Ansible playbooks for correctness?**  
   - Use tools like Molecule or run them in a staging environment.

9. **What is `ansible-vault`, and how is it used?**  
   - A tool for encrypting secrets in Ansible files.

10. **How do you execute tasks conditionally in Ansible?**  
    - Use the `when` keyword to specify conditions.

11. **What is a fact in Ansible, and how do you gather it?**  
    - Facts are system information collected using the `setup` module.

12. **How do you limit playbook execution to specific hosts?**  
    - Use `--limit` with the `ansible-playbook` command.

13. **What is the difference between roles and collections in Ansible?**  
    - **Roles**: Structured reusable components.  
    - **Collections**: Broader packaging of roles, modules, and plugins.

14. **How do you create reusable components in Ansible?**  
    - Organize configurations into roles.

15. **What are callback plugins in Ansible, and when are they used?**  
    - Plugins that modify output or behavior during playbook execution.

---

## Top 15 AWS Interview Questions with Answers Related to Git

1. **What is Git, and how does it work?**  
   - Git is a distributed version control system that tracks changes in source code during development. It allows multiple developers to collaborate and manage code history efficiently.

2. **What are the differences between Git and SVN?**  
   - **Git**: Distributed version control system where each user has a full copy of the repository.  
   - **SVN**: Centralized version control system where the repository is stored on a central server.

3. **What is the purpose of a Git repository?**  
   - A Git repository stores all the files, commits, branches, and history for a project, allowing for version control and collaboration.

4. **What are the differences between `git pull` and `git fetch`?**  
   - **`git pull`**: Fetches and merges changes from the remote repository to the local repository.  
   - **`git fetch`**: Fetches changes from the remote repository but does not merge them into the local branch.

5. **What is the purpose of a Git branch, and how do you create one?**  
   - A Git branch allows you to work on different versions of a project simultaneously. Use `git branch <branch-name>` to create a new branch.

6. **How does Git handle merge conflicts?**  
   - Git identifies conflicting changes between branches and marks them in the files. You must manually resolve conflicts and commit the resolved changes.

7. **What is the purpose of `git rebase`?**  
   - `git rebase` is used to integrate changes from one branch into another by applying the commits from one branch onto the base of another, providing a linear history.

8. **How do you revert a commit in Git?**  
   - Use `git revert <commit-hash>` to create a new commit that undoes the changes from the specified commit.

9. **What are Git tags, and how are they used?**  
   - Git tags are references to specific points in the Git history, typically used for marking release versions. Use `git tag <tag-name>` to create a tag.

10. **What is the purpose of `.gitignore` file?**  
    - A `.gitignore` file specifies files and directories that Git should not track or version control, typically for build files, logs, or sensitive data.

11. **How do you clone a repository in Git?**  
    - Use `git clone <repository-url>` to create a local copy of a remote repository.

12. **What is a pull request (PR) in Git?**  
    - A pull request is a GitHub or GitLab feature that allows a user to request changes from one branch to be merged into another branch, often used for collaboration and code review.

13. **What is the difference between `git merge` and `git rebase`?**  
    - **`git merge`**: Combines two branches, preserving history and creating a merge commit.  
    - **`git rebase`**: Re-applies commits from one branch onto another, creating a linear history.

14. **What is the role of a remote repository in Git?**  
    - A remote repository is hosted on a server, enabling collaboration among multiple developers. It can be accessed by using `git push` and `git pull` to synchronize changes.

15. **How do you reset a file in Git to its previous state?**  
    - Use `git checkout -- <file>` to reset a file to its last committed state or `git reset --hard` to reset the entire repository to the previous commit.




