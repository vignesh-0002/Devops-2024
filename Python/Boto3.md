# What is boto3?
- `boto3` is the Amazon Web Services (AWS) SDK for Python. 
- It allows developers to interact with AWS services like S3 (Simple Storage Service), EC2 (Elastic Compute Cloud), DynamoDB, Lambda, and more programmatically.

# Install boto3
- In order to work with boto3 in our script we need to install it on our local machine.
- Install the latest Boto3 release via pip:
  ```sh
    pip install boto3
  ```

#  Configuration
- To allow AWS SDK to communicate with AWS set up authentication credentials for your AWS account with required permissions.
- Once done we are good to create our script.

# Using Boto3:
  ```python
   import boto3

   # Let's use Amazon S3
   s3 = boto3.resource('s3')

   # Print out bucket names
   for bucket in s3.buckets.all():
     print(bucket.name) 
  ```

- To use Boto3, you must first import it and indicate which service or services you’re going to use:

  ```python
  import boto3
  ```
- `boto3.resource('s3')`: This part of the code creates a high-level, resource-oriented interface to access the Amazon S3 service. S3 stands for Simple Storage Service, which is an object storage service offered by AWS.
- `s3`: This variable is assigned to the S3 resource object. You can now use this s3 variable to interact with your S3 buckets and objects.
  ```python
  s3 = boto3.resource('s3')
  ```
  
  
