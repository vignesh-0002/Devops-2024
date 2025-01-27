# To attach an additional EBS volume to an EC2 instance, follow these steps:

## 1. Create a New EBS Volume
- Go to the AWS Management Console.
- In the Navigation pane, choose EC2.
- Under Elastic Block Store, select Volumes.
  ![image](https://github.com/user-attachments/assets/333c6462-3de2-4ee0-acf0-9440d5c7239b)

- Click Create Volume.
  ![image](https://github.com/user-attachments/assets/f496f199-ede1-4ce9-961a-fa0ccda0c5dd)

- Select the volume type (e.g., General Purpose SSD (gp2)).
- Choose the size and availability zone. Ensure the volume is in the same Availability Zone as your EC2 instance.
- Click Create Volume.
  ![image](https://github.com/user-attachments/assets/51d31ea5-b970-4696-838d-9ff68c52c416)


## 2. Attach the EBS Volume to Your EC2:

- After the volume is created, go to the Volumes page in the EC2 console.
- Select the volume you just created.
- Click on Actions, then select Attach Volume.
  ![image](https://github.com/user-attachments/assets/2fda56b5-d40b-453e-8eb2-66de506a65f7)

- Choose the instance you want to attach the volume to.
- Select the device name (e.g., /dev/sdf or /dev/xvdf depending on your OS).
- Click Attach.
  ![image](https://github.com/user-attachments/assets/3dd4e8c5-bfc4-4f8b-8364-c690034b1c07)

## 3. Log into the EC2 Instance
SSH into your EC2 instance using your private key:
```
ssh -i /path/to/your-key.pem ec2-user@your-ec2-public-ip 
```
## 4. Verify the Attached Volume
Check if the new volume is recognized by your instance:
```
lsblk
```
- You should see the new volume listed, typically as /dev/xvdf or /dev/sdf.
![image](https://github.com/user-attachments/assets/eb5ba46e-3ad6-4058-9f26-8ebc6deca940)

## 5. Format the EBS Volume (if necessary)
If the volume is new (unformatted), you need to create a file system on it:
```
sudo mkfs -t ext4 /dev/xvdf
```

## 6. Mount the Volume
- Create a directory where the volume will be mounted:
```
sudo mkdir /mnt/data
```
- Mount the volume:
```
sudo mount /dev/xvdf /mnt/data
```

## 7. Verify the Mount
Check if the volume is mounted:
```
df -h
```
![image](https://github.com/user-attachments/assets/de258d59-e839-46cd-af7d-2f6532631a32)

## 8. Make the Mount Permanent (Optional)
To automatically mount the volume on reboot, edit the /etc/fstab file:
```
sudo nano /etc/fstab
```
- Add the following line (replace `/dev/xvdf` with the correct device name and `/mnt/data` with the desired mount point):
```
/dev/xvdf  /mnt/data  ext4  defaults,nofail  0  2
```
- Save and exit.
## 9. Unmount the Volume (Optional)
- If you need to unmount the volume, use:
```
sudo umount /mnt/data
```
