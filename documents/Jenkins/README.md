# Guide to installing and configuring the Jenkins application
---
In this tutorial, we are going to install and configure the Jenkins application to implement our project with its CI/CD to make the deployments of our software.

<!--more-->

[//]: # (Image References)

[image1]: ./images/jenkis1.jpg "Jenkis"
[image2]: ./images/jenkis2.jpg "Jenkis"
[image3]: ./images/jenkis3.jpg "Jenkis"
[image4]: ./images/jenkis4.jpg "Jenkis"
[image5]: ./images/jenkis5.jpg "Jenkis"
[image6]: ./images/jenkis6.jpg "Jenkis"
[image7]: ./images/jenkis7.jpg "Jenkis"
[image8]: ./images/jenkis8.jpg "Jenkis"
[image9]: ./images/jenkis9.jpg "Jenkis"
[image10]: ./images/jenkis10.jpg "Jenkis"
[image11]: ./images/jenkis11.jpg "Jenkis"
[image12]: ./images/jenkis12.jpg "Jenkis"
[image13]: ./images/jenkis13.jpg "Jenkis"
[image14]: ./images/jenkis14.jpg "Jenkis"
[image15]: ./images/jenkis15.jpg "Jenkis"
[image16]: ./images/jenkis16.jpg "Jenkis"
[image17]: ./images/jenkis17.jpg "Jenkis"
[image18]: ./images/jenkis18.jpg "Jenkis"
[image19]: ./images/jenkis19.jpg "Jenkis"
[image20]: ./images/jenkis20.jpg "Jenkis"
[image21]: ./images/jenkis21.jpg "Jenkis"
[image22]: ./images/jenkis22.jpg "Jenkis"
[image23]: ./images/jenkis23.jpg "Jenkis"
[image24]: ./images/jenkis24.jpg "Jenkis"
[image25]: ./images/jenkis25.jpg "Jenkis"
[image26]: ./images/jenkis26.jpg "Jenkis"

---

### Software installation

Code to be executed to install the software correctly.

```
# Step 1 - Update existing packages
sudo apt-get update

# Step 2 - Install Java
sudo apt install -y default-jdk

# Step 3 - Download Jenkins package. 
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -

# Step 4 - Add the following entry in our /etc/apt/sources.list:
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Step 5 -Update our local package index
sudo apt-get update

# Step 6 - Install Jenkins
sudo apt-get install -y jenkins

# Step 7 - Start the Jenkins server
sudo systemctl start jenkins

# Step 8 - Enable the service to load during boot
sudo systemctl enable jenkins
sudo systemctl status jenkins
```

### Logging into Jenkins using GUI

Go to AWS dashboard to copy the public IP address of your Ubuntu EC2 instance. 

Paste the public IP address into our browser, appended with ```:8080``` port. For the first time, it will open up the Jenkins GUI as shown in the snapshot below:

![alt text][image1]

On the terminal, where we have connected to the Ubuntu EC2 instance, view the content of the file using the command ```sudo cat /var/lib/jenkins/secrets/initialAdminPassword``` It will show the default administrator password. We can copy and use this password in the GUI (browser) to log in first time.

After successful login, we may choose to install default plugins.

![alt text][image2]

If we choose to install suggested plugins, the following plugins would get installed. See the snapshot below:

![alt text][image3]

Set up the user credentials. See the snapshot below:

![alt text][image4]

Next, it will show us a success message and take us to the Jenkins dashboard.

![alt text][image5]

![alt text][image6]

We start using the application directly or we can log in later with our previously defined credentials.

![alt text][image7]

Install the plugin to use Blue Ocean.

![alt text][image8]

![alt text][image9]

Installation of plungins for aws pipelines.

![alt text][image10]

We can see in the image that the blue ocean is available on the left side for the execution of our pipelines.

![alt text][image11]

Initial screen for loading our pipelines.

![alt text][image12]

Configure credentials for AWS and Docker access.

![alt text][image13]

![alt text][image14]

![alt text][image15]

![alt text][image16]

We create the credential to communicate with AWS.

![alt text][image17]

We create the credential to communicate with Docker.

![alt text][image18]

![alt text][image19]

We open Blue Ocean.

![alt text][image20]

We will create a new pipeline in Blue Ocean.

![alt text][image21]

We will connect to our repository on github.

![alt text][image22]

We will generate a token for access to our repository.

![alt text][image23]

We select the scopes for the token.

![alt text][image24]

We copy our token, connect and indicate the organisation of our repository.

![alt text][image25]

We select the repository of our project.

![alt text][image26]

We create our pipeline for deployment.




<p align="center">
    <img src ="./images/EC2Creation1.jpg" />
</p>

### Prerequisite

1. Create an AWS account.
2. Create an IAM administrator user and a normal IAM user.
3. Create a role with administrator permissions.
4. Create a key pairs.
5. Create the default VPC.

### Go to the EC2 Dashboard

1. Log in to your AWS account, and go to the AWS Management Console. Select the EC2 service.

<p align="center">
    <img src ="./images/EC2Creation2.jpg" />
	<img src ="./images/EC2Creation3.jpg" />
</p>

2. Have a look at the EC2 Dashboard. The EC2 Dashboard is home to a variety of related services, such as Amazon Machine Images, Elastic Block Store (EBS), Load Balancer, and Auto Scaling. 

<p align="center">
    <img src ="./images/EC2Creation4.jpg" />
</p>

### Start the Launch Instance Wizard

Launching an instance is an eight-step process, as described below. At any stage, you can refer to the instruction given in the official documentation for help.

<p align="center">
    <img src ="./images/EC2Creation5.jpg" />
</p>

#### Step 1 - Choose an Amazon Machine Image (AMI)

An AMI is a template used to create a VM. AMI contains the pre-installed operating system, application server, and applications required to launch your instance. There is a variety of Linux, Windows, and other OS servers available. Choose the one available under the free-tier option.

<p align="center">
    <img src ="./images/EC2Creation6.jpg" />
</p>

We are looking for AMI Ubuntu Server 18.04 LTS x86" - ami-0ac73f33a1888c64a

<p align="center">
    <img src ="./images/EC2Creation7.jpg" />
</p>

#### Step 2 - Choose an Instance Type

Instance Type offers varying combinations of CPUs, memory (GB), storage (GB), types of network performance, and availability of IPv6 support. AWS offers a variety of instance types, based on the configuration you choose. Prefer to choose any one of those types supported by a free tier account. 

<p align="center">
    <img src ="./images/EC2Creation8.jpg" />
</p>

Select the hardware configuration of your instance. The t2.micro instance type, which is available under the free tier, is selected by default. It has 1 vCPU, 2.5 GHz, 1 GiB memory, the default root volume, and supports additional EBS storage.

#### Step 3 - Configure Instance Details

Provide the instance count and configuration details, such as network, subnet, behavior, monitoring, etc.

<p align="center">
    <img src ="./images/EC2Creation9.jpg" />
</p>

#### Step 4 - Add Storage

You can choose to attach either SSD or Standard Magnetic drive to your instance.

<p align="center">
    <img src ="./images/EC2Creation10.jpg" />
</p>

#### Step 5 - Add Tags

A tag serves as a label that you can attach to multiple AWS resources, such as volumes, instances, users, or roles. Tagging helps in easy search and grouping resources for various purposes.

<p align="center">
    <img src ="./images/EC2Creation11.jpg" />
</p>

Add Tags. Tags help to categorize the resources across AWS services. It works as a label. 

#### Step 6 - Configure Security Group

Attach a set of firewall rules to your instance(s) that controls the incoming traffic to your instance(s).

<p align="center">
    <img src ="./images/EC2Creation12.jpg" />
</p>

Security Groups. It defines the firewall rules, such as the protocol to open to network traffic and the set of valid IP addresses. By default, SSH protocol is used for a Linux instance and RDP for a Windows instance. HTTP and HTTPS allow Internet traffic to reach your instance.

<p align="center">
    <img src ="./images/EC2Creation13.jpg" />
	<img src ="./images/EC2Creation14.jpg" />
</p>

Or you can choose the one that is created by default.

#### Step 7 - Review

Review your instance details before the launch.

<p align="center">
    <img src ="./images/EC2Creation15.jpg" />
</p>

#### Step 8 - Download Key Pair

AWS generates a pair of public and private (encrypted) keys, that help in logging into the EC2 instance. Download the private key (.pem file) locally. The public key will be stored on the EC2 instance, while the private key will be available to download locally, just once. In case, if the private key file (.pem) is misplaced or lost, the AWS doesn't allow regenerating the private key. 

<p align="center">
    <img src ="./images/EC2Creation16.jpg" />
</p>

Download Private Key or you can choose the one that is created by default.

<p align="center">
    <img src ="./images/EC2Creation17.jpg" />
</p>