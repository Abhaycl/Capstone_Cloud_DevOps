pipeline {
    agent any
    stages {
        stage('Check Git Repo') {
            steps {
                sh 'echo Checkout code from source control...'
                checkout scm
				sh 'printenv'
            }
        }
        stage('Check Environment') {
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
        stage('Continuous Integration') {
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
        stage('Continuous Deployment') {
            parallel {
                stage('Blue') {
                    stages {
                        stage('Build Docker Image') {
                            steps {
                                sh 'echo Building blue docker image...'
                                withCredentials(bindings: [[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKERHUBUSERNAME', passwordVariable: 'DOCKERHUBPASSWORD']]) {
                                    sh 'docker login -u $DOCKERHUBUSERNAME -p $DOCKERHUBPASSWORD'
                                    sh 'docker build -t $DOCKERHUBUSERNAME/capstoneblue capstoneblue/.'
                                }
                            }
                        }
                        stage('Push Image') {
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
                        stage('Deploy Container') {
                            steps {
                                sh 'echo Deploy blue container...'
                                withAWS(region: 'us-west-2', credentials: 'aws_credentials') {
                                    sh 'kubectl apply -f ./blue_controller.json'
                                }
                            }
                        }
                    }
                }
                stage('Green') {
                    stages {
                        stage('Build Docker Image') {
                            steps {
                                sh 'echo Building green docker image...'
                                withCredentials(bindings: [[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKERHUBUSERNAME', passwordVariable: 'DOCKERHUBPASSWORD']]) {
                                    sh 'docker login -u $DOCKERHUBUSERNAME -p $DOCKERHUBPASSWORD'
                                    sh 'docker build -t $DOCKERHUBUSERNAME/capstonegreen capstonegreen/.'
                                }
                            }
                        }
                        stage('Push Image') {
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
                        stage('Deploy Container') {
                            steps {
                                sh 'echo Deploy green container...'
                                withAWS(region: 'us-west-2', credentials: 'aws_credentials') {
                                    sh 'kubectl apply -f ./green_controller.json'
                                }
                            }
                        }
                    }
                }
            }
        }
        stage('Creation Blue Cluster Service') {
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
        stage('Creation Green Cluster Service') {
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