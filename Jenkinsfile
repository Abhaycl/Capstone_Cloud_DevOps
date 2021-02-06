pipeline {
    agent any
    stages {
        stage('Check Git Repo') {
            steps {
                echo 'Checkout code from source control...'
                sh 'pwd'
                sh 'printenv'
                checkout scm
            }
        }
        stage('Check Our Environment') {
            steps {
                sh 'echo Checkout environment...'
                sh 'echo Branch: ' + env.BRANCH_NAME
                sh 'git --version'
                sh 'unzip -v'
                sh 'java --version'
                sh 'aws --version'
                sh 'docker --version'
                sh 'tidy --version'
                sh 'hadolint --version'
                sh 'kubectl version --short --client'
                sh 'eksctl version'
            }
        }
        stage('Parallel') {
            parallel {
                stage('Blue') {
                    stages {
                        stage('Lint Blue') {
                            steps {
                                sh 'echo Lint blue project...'
                                sh 'tidy -q -e capstoneblue/*.html'
                            }
                        }
                        stage('Hadolint Blue') {
                            steps {
                                sh 'echo Hadolint blue docker...'
                                sh 'hadolint capstoneblue/Dockerfile'
                            }
                        }
                        stage('Build Blue Docker Image') {
                            steps {
                                sh 'echo Building blue docker image...'
                                withCredentials(bindings: [[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKERHUBUSERNAME', passwordVariable: 'DOCKERHUBPASSWORD']]) {
                                    sh 'docker login -u $DOCKERHUBUSERNAME -p $DOCKERHUBPASSWORD'
                                    sh 'docker build -t $DOCKERHUBUSERNAME/capstoneblue capstoneblue/.'
                                }
                            }
                        }
                        stage('Push Blue Image') {
                            steps {
                                sh 'echo Push blue image to dockerhub...'
                                withCredentials(bindings: [[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKERHUBUSERNAME', passwordVariable: 'DOCKERHUBPASSWORD']]) {
                                    sh 'docker login -u $DOCKERHUBUSERNAME -p $DOCKERHUBPASSWORD'
                                    sh 'docker tag $DOCKERHUBUSERNAME/capstoneblue $DOCKERHUBUSERNAME/capstoneblue'
                                    sh 'docker push $DOCKERHUBUSERNAME/capstoneblue'
                                    sh 'docker images'
                                }
                            }
                        }
                    }
                }
                stage('Green') {
                    stages {
                        stage('Lint Green') {
                            steps {
                                sh 'echo Lint green project...'
                                sh 'tidy -q -e capstonegreen/*.html'
                            }
                        }
                        stage('Hadolint Green') {
                            steps {
                                sh 'echo Hadolint green docker...'
                                sh 'hadolint capstonegreen/Dockerfile'
                            }
                        }
                        stage('Build Green Docker Image') {
                            steps {
                                sh 'echo Building green docker image...'
                                withCredentials(bindings: [[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKERHUBUSERNAME', passwordVariable: 'DOCKERHUBPASSWORD']]) {
                                    sh 'docker login -u $DOCKERHUBUSERNAME -p $DOCKERHUBPASSWORD'
                                    sh 'docker build -t $DOCKERHUBUSERNAME/capstonegreen capstonegreen/.'
                                }
                            }
                        }
                        stage('Push Green Image') {
                            steps {
                                sh 'echo Push green image to dockerhub...'
                                withCredentials(bindings: [[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKERHUBUSERNAME', passwordVariable: 'DOCKERHUBPASSWORD']]) {
                                    sh 'docker login -u $DOCKERHUBUSERNAME -p $DOCKERHUBPASSWORD'
                                    sh 'docker tag $DOCKERHUBUSERNAME/capstonegreen $DOCKERHUBUSERNAME/capstonebluegreen'
                                    sh 'docker push $DOCKERHUBUSERNAME/capstonegreen'
                                    sh 'docker images'
                                }
                            }
                        }
                    }
                }
            }
        }
        stage('Create Conf File Cluster') {
            steps {
                sh 'echo Create conf file cluster...'
                withAWS(region: 'us-west-2', credentials: 'aws_credentials') {
                    sh 'aws eks --region us-west-2 update-kubeconfig --name capstone'
                    sh 'eksctl get clusters'
                }
            }
        }
        stage('Deployment') {
            parallel {
                stage('Blue Container') {
                    steps {
                        sh 'echo Deploy blue container...'
                        withAWS(region: 'us-west-2', credentials: 'aws_credentials') {
                            sh 'kubectl apply -f ./blue_controller.json'
                        }
                    }
                }
                stage('Green Container') {
                    steps {
                        sh 'echo Deploy green container...'
                        withAWS(region: 'us-west-2', credentials: 'aws_credentials') {
                            sh 'kubectl apply -f ./green_controller.json'
                        }
                    }
                }
            }
        }
        stage('Create Blue Service In The Cluster') {
            steps {
                sh 'echo Redirect to blue...'
                withAWS(region: 'us-west-2', credentials: 'aws_credentials') {
                    sh 'kubectl apply -f ./blue_service.json'
                }
            }
        }
        stage('Confirm Deployment By User') {
            steps {
                withAWS(region: 'us-west-2', credentials: 'aws_credentials') {
                    sh 'kubectl get nodes'
                    sh 'kubectl get deployments'
                    sh 'kubectl get pods -o wide'
                    sh 'kubectl get svc'
                }
                sh 'echo Confirm deployment by user...'
                input 'Redirect traffic to green?'
            }
        }
        stage('Create Green Service In The Cluster') {
            steps {
                sh 'echo Redirect to green...'
                withAWS(region: 'us-west-2', credentials: 'aws_credentials') {
                    sh 'kubectl apply -f ./green_service.json'
                    sh 'kubectl get nodes'
                    sh 'kubectl get deployments'
                    sh 'kubectl get pods -o wide'
                    sh 'kubectl get svc'
                }
            }
        }
    }
}