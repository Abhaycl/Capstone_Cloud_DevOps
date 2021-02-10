# Guide to installing and configuring the Jenkins application
---
In this tutorial, we are going to install and configure the Jenkins application to implement our project with its CI/CD to make the deployments of our software.

<!--more-->

[//]: # (Image References)

[image0]: ./images/jenkins0.jpg "Jenkis"
[image1]: ./images/jenkins1.jpg "Jenkis"
[image2]: ./images/jenkins2.jpg "Jenkis"
[image3]: ./images/jenkins3.jpg "Jenkis"
[image4]: ./images/jenkins4.jpg "Jenkis"
[image5]: ./images/jenkins5.jpg "Jenkis"
[image6]: ./images/jenkins6.jpg "Jenkis"
[image7]: ./images/jenkins7.jpg "Jenkis"
[image7a]: ./images/jenkins7a.jpg "Jenkis"
[image8]: ./images/jenkins8.jpg "Jenkis"
[image9]: ./images/jenkins9.jpg "Jenkis"
[image10]: ./images/jenkins10.jpg "Jenkis"
[image11]: ./images/jenkins11.jpg "Jenkis"
[image12]: ./images/jenkins12.jpg "Jenkis"
[image13]: ./images/jenkins13.jpg "Jenkis"
[image14]: ./images/jenkins14.jpg "Jenkis"
[image15]: ./images/jenkins15.jpg "Jenkis"
[image16]: ./images/jenkins16.jpg "Jenkis"
[image17]: ./images/jenkins17.jpg "Jenkis"
[image18]: ./images/jenkins18.jpg "Jenkis"
[image19]: ./images/jenkins19.jpg "Jenkis"
[image20]: ./images/jenkins20.jpg "Jenkis"
[image21]: ./images/jenkins21.jpg "Jenkis"
[image22]: ./images/jenkins22.jpg "Jenkis"
[image23]: ./images/jenkins23.jpg "Jenkis"
[image24]: ./images/jenkins24.jpg "Jenkis"
[image25]: ./images/jenkins25.jpg "Jenkis"
[image26]: ./images/jenkins26.jpg "Jenkis"
[image27]: ./images/jenkins27.jpg "Jenkis"


---

### Software installation

Code to be executed to install the software correctly.

```
# Step 1 - Update existing packages.
sudo apt-get update

# Step 2 - Install Java.
sudo apt install -y default-jdk

# Step 3 - Download Jenkins package. 
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -

# Step 4 - Add the following entry in our /etc/apt/sources.list:
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Step 5 -Update our local package index.
sudo apt-get update

# Step 6 - Install Jenkins.
sudo apt-get install -y jenkins

# Step 7 - Start the Jenkins server.
sudo systemctl start jenkins

# Step 8 - Enable the service to load during boot.
sudo systemctl enable jenkins
sudo systemctl status jenkins
```

### Logging into Jenkins using GUI

We go to the EC2 dashboard in AWS and copy the public IP address of our Ubuntu EC2 instance.

![alt text][image0]

And we get the address:

```ec2-34-221-80-14.us-west-2.compute.amazonaws.com``` or ```34.221.80.14```

Paste the public IP address into our browser, appended with 8080 port:

```ec2-34-221-80-14.us-west-2.compute.amazonaws.com:8080``` or ```34.221.80.14:8080```

For the first time, it will open up the Jenkins GUI as shown in the snapshot below:

![alt text][image1]

On the terminal, where we have connected to the Ubuntu EC2 instance, view the content of the file using the command:

```
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

It will show the default administrator password. We can copy and use this password in the GUI (browser) to log in first time.

After successful login, we may choose to install default plugins.

![alt text][image2]

If we choose to install suggested plugins, the following plugins would get installed. See the snapshot below:

![alt text][image3]

Set up the user credentials. See the snapshot below:

![alt text][image4]

Next, it will show us a success message and take us to the Jenkins dashboard.

![alt text][image5]

![alt text][image6]

We start using the application directly.

![alt text][image7]

Or we can login later with our previously defined credentials.

![alt text][image7a]

### Jenkins Plugins

Jenkins supports a plenitude of plugins. Plugins extend Jenkins with additional features to support various requirements. Here we will install the Blue Ocean Plugin into Jenkins. The general sequence of steps to select and install any plugin into Jenkins are: 

*Jenkins dashboard --> Manage Jenkins --> Manage Plugins --> Available tab --> Filter out using a keyword*

### Blue Ocean Plugin and aws plugin

Blue Ocean essentially provides a re-skinned and simplified GUI for working with Jenkins. Blue Ocean can help us configure our pipeline using a few clicks.

"Blue Ocean" and other required plugins need to be installed. Logged in as an admin, go to the top left, click 'Jenkins', then 'manage Jenkins', and select 'Manage Plugins'.

Use the "Available" tab, filter by "Blue Ocean," select the first option ("BlueOcean aggregator") and install without a restart.

![alt text][image8]

Filter once again for "pipeline-aws" and install, this time selecting "Download now and install after restart.

![alt text][image9]

Once all plugins are installed, Jenkins will restart. If it hasn't restarted, run the following in the VM:

```
    sudo systemctl restart jenkins
```

![alt text][image10]

### Set up credentials in Jenkins.

Credentials need to be created so that they can be used in our pipeline.

On the Jenkins home page. Then click on the "Manage Jenkins" link in the sidebar and select the "Manage Credentials" option.

![alt text][image13]

![alt text][image14]

![alt text][image15]

![alt text][image16]

We create the credential to communicate with AWS.

In the option kind, choose "AWS Credentials" from the dropdown, set an ID, a description and fill in the Access Key ID and Secret Access Key generated when the IAM role was created and Click OK.

![alt text][image17]

We create the credential to communicate with Docker.

In the option kind, choose "Username with password" from the dropdown, set an ID, a description and fill Username and Password generated when docker hub was created and Click OK. 

![alt text][image18]

The credentials should now be available for the rest of the system.

![alt text][image19]

### Open our pipeline

We verify that everything works for Blue Ocean by logging in. We should see an "Open Blue Ocean" link in the sidebar. Click on it, and it will take us to the "Blue Ocean" screen, where we will have to add our project.

![alt text][image11]

A welcome screen will appear, telling you it is time to create your first pipeline. Click "create pipeline."

![alt text][image12]

### Uploading our pipeline from our repository

We open Blue Ocean and we will create a new pipeline in Blue Ocean.

![alt text][image20]

Select GitHub from the options available.

![alt text][image21]

We will connect to our repository on github.

![alt text][image22]

We will generate a token for Jenkins to use to access our repository.

Authenticate in Github, and add a note for what this token is (easier for later removal): "Capstone Project".

![alt text][image23]

We can select the default scopes in the opened link, that defines the access for a personal token for Jenkins.

We ensured that we copied the token - there is no way to see it again!.

![alt text][image24]

We copy our token after pasting the token into the form in Jenkins, click "connect", and our account should show up. If our account belongs to multiple organizations, they will be listed - we make sure that we use our personal account and our organisation.

![alt text][image25]

Next, search for our project so that the repository is matched, and click "create pipeline".

![alt text][image26]

We create our pipeline for deployment.

In the page where the job shows our project, there is a gear icon - click on it to edit the job directly. Find the "Scan repository triggers" and click on "Periodically if not otherwise run," and select an interval of 2 minutes.

This completes the initial pipeline configuration for Jenkins in which our deployment pipeline has been created.

![alt text][image27]