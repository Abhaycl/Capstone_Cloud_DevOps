#!/bin/sh
# Create install log file
touch install.log
sudo chmod 666 install.log

# Installation of all necessary software.
# Update existing packages.
echo '##### Update existing packages #####' >> install.log
sudo apt-get -y update
sudo apt-get -y upgrade
echo '---------------' >> install.log
echo ' ' >> install.log

# Install Java.
echo '##### Install Java #####' >> install.log
sudo apt-get -y install default-jdk
java --version >> install.log
echo '---------------' >> install.log
echo ' ' >> install.log

# Install Jenkins and start it.
echo '##### Install Jenkins #####' >> install.log
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get -y update
sudo apt-get -y install jenkins
sudo systemctl status jenkins >> install.log
#sudo systemctl start jenkins
#sudo systemctl enable jenkins
echo '---------------' >> install.log
echo ' ' >> install.log

# Install and Setup Docker.
echo '##### Install Docker #####' >> install.log
sudo apt-get -y update
sudo apt-get -y install docker.io
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
#sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add –
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" 
sudo apt-get -y update
sudo apt-get -y install docker-ce docker-ce-cli
#sudo apt-get -y install docker-ce docker-ce-cli containerd.io
sudo chmod 666 /var/run/docker.sock
sudo service docker start
sudo usermod -a -G docker ubuntu
#docker info >> install.log
docker --version >> install.log
echo '---------------' >> install.log
echo ' ' >> install.log

# Install Tidy.
echo '##### Install Tidy #####' >> install.log
sudo apt-get -y update
sudo apt-get -y install tidy
tidy --version >> install.log
echo '---------------' >> install.log
echo ' ' >> install.log

# Install hadolint.
echo '##### Install Hadolint #####' >> install.log
sudo wget -q -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.21.0/hadolint-Linux-x86_64
sudo chmod +x /bin/hadolint
hadolint --version >> install.log
echo '---------------' >> install.log
echo ' ' >> install.log

# Install Unzip.
echo '##### Install Unzip #####' >> install.log
sudo apt-get -y install unzip
unzip -v >> install.log
echo '---------------' >> install.log
echo ' ' >> install.log

# Install AWS CLI V2.
echo '##### Install AWS CLI V2 #####' >> install.log
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -o awscliv2.zip
sudo ./aws/install
rm awscliv2.zip
aws --version >> install.log
echo '---------------' >> install.log
echo ' ' >> install.log

# Install Kubectl.
echo '##### Install Kubectl #####' >> install.log
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2020-11-02/bin/linux/amd64/kubectl
chmod +x ./kubectl
# kubectl by google
#curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client >> install.log
echo '---------------' >> install.log
echo ' ' >> install.log

# Install eksctl.
echo '##### Install Eksctl #####' >> install.log
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version >> install.log
echo '---------------' >> install.log
echo ' ' >> install.log

# Update existing packages.
sudo apt-get -y update
sudo apt-get -y upgrade