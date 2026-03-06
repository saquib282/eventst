pipeline {
    agent any
    tools {
        nodejs 'node23'
    }
    
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {
        stage('GIT Checkout') {
            steps {
                git branch: 'main', url: 'git@github.com:saquib282/eventst.git'
            }
        }
        
        stage('GITLeaks Scan') {
            steps {
                sh 'gitleaks detect --source . --exit-code 1'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=NodeJS-Project \
                    -Dsonar.projectKey=NodeJS-Project '''
                }
            }
        }
        stage('Quality Gate Check') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                   waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token' 
                }
              }
            }
        stage('Trivy FS Scan') {
            steps {
                sh 'trivy fs --format table -o fs-report.html .'
            }
        }
        
        stage('Aahar Build and Push'){
            steps {
                script {
                withDockerRegistry(credentialsId: 'docker-cred') {
                    dir('aahar') {
                    sh 'docker build -t royalsaquib/aahar:${BUILD_NUMBER} .'
                    sh 'trivy image --format table -o aahar-report.html royalsaquib/aahar:${BUILD_NUMBER}'
                    sh 'docker push royalsaquib/aahar:${BUILD_NUMBER}'
                    }
                  }
                }
             }
          }

          stage('Analytics Build and Push'){
            steps {
                script {
                withDockerRegistry(credentialsId: 'docker-cred') {
                    dir('analytics') {
                    sh 'docker build -t royalsaquib/analytics:${BUILD_NUMBER} .'
                    sh 'trivy image --format table -o analytics-report.html royalsaquib/analytics:${BUILD_NUMBER}'
                    sh 'docker push royalsaquib/analytics:${BUILD_NUMBER}'
                    }
                  }
                }
             }
          }

          stage('Blog Build and Push'){
            steps {
                script {
                withDockerRegistry(credentialsId: 'docker-cred') {
                    dir('blog') {
                    sh 'docker build -t royalsaquib/blog:${BUILD_NUMBER} .'
                    sh 'trivy image --format table -o blog-report.html royalsaquib/blog:${BUILD_NUMBER}'
                    sh 'docker push royalsaquib/blog:${BUILD_NUMBER}'
                    }
                  }
                }
             }
          }

          stage('client Build and Push'){
            steps {
                script {
                withDockerRegistry(credentialsId: 'docker-cred') {
                    dir('client') {
                    sh 'docker build -t royalsaquib/client:${BUILD_NUMBER} .'
                    sh 'trivy image --format table -o client-report.html royalsaquib/client:${BUILD_NUMBER}'
                    sh 'docker push royalsaquib/client:${BUILD_NUMBER}'
                    }
                  }
                }
             }
          }

          stage('Meeting Build and Push'){
            steps {
                script {
                withDockerRegistry(credentialsId: 'docker-cred') {
                    dir('meeting') {
                    sh 'docker build -t royalsaquib/meeting:${BUILD_NUMBER} .'
                    sh 'trivy image --format table -o meeting-report.html royalsaquib/meeting:${BUILD_NUMBER}'
                    sh 'docker push royalsaquib/meeting:${BUILD_NUMBER}'
                    }
                  }
                }
             }
          }

          stage('Notification Build and Push'){
            steps {
                script {
                withDockerRegistry(credentialsId: 'docker-cred') {
                    dir('notification') {
                    sh 'docker build -t royalsaquib/notification:${BUILD_NUMBER} .'
                    sh 'trivy image --format table -o notification-report.html royalsaquib/notification:${BUILD_NUMBER}'
                    sh 'docker push royalsaquib/notification:${BUILD_NUMBER}'
                    }
                  }
                }
             }
          }

          stage('Polls Build and Push'){
            steps {
                script {
                withDockerRegistry(credentialsId: 'docker-cred') {
                    dir('polls') {
                    sh 'docker build -t royalsaquib/polls:${BUILD_NUMBER} .'
                    sh 'trivy image --format table -o polls-report.html royalsaquib/polls:${BUILD_NUMBER}'
                    sh 'docker push royalsaquib/polls:${BUILD_NUMBER}'
                    }
                  }
                }
             }
          }

          stage('Sessions Build and Push'){
            steps {
                script {
                withDockerRegistry(credentialsId: 'docker-cred') {
                    dir('sessions') {
                    sh 'docker build -t royalsaquib/sessions:${BUILD_NUMBER} .'
                    sh 'trivy image --format table -o sessions-report.html royalsaquib/sessions:${BUILD_NUMBER}'
                    sh 'docker push royalsaquib/sessions:${BUILD_NUMBER}'
                    }
                  }
                }
             }
          }

          stage('UMS Build and Push'){
            steps {
                script {
                withDockerRegistry(credentialsId: 'docker-cred') {
                    dir('ums') {
                    sh 'docker build -t royalsaquib/ums:${BUILD_NUMBER} .'
                    sh 'trivy image --format table -o ums-report.html royalsaquib/ums:${BUILD_NUMBER}'
                    sh 'docker push royalsaquib/ums:${BUILD_NUMBER}'
                    }
                  }
                }
             }
          }
          
          stage('Manual Approval for Production'){
              steps {
                  timeout(time: 1, unit: 'HOURS') {
                input message: 'Approve Deployment to Production ?', ok: 'Deploy'
            }
          }
        }
        stage('Deployment to Prod') {
            steps {
                script {
                    withKubeConfig(caCertificate: '', clusterName: 'eventstrat-cluster', contextName: '', credentialsId: 'k8-prod-token', namespace: 'eventstrat', restrictKubeConfigAccess: false, serverUrl: 'https://5BE13676B87469F594E76C5E34D70D15.gr7.us-east-1.eks.amazonaws.com') {

                        sh 'kubectl apply -f k8s/namespace.yaml'
                        sleep 10
                        sh 'kubectl apply -f k8s/ums/deployment.yaml -n eventstrat'
                        sh 'kubectl apply -f k8s/meeting/deployment.yaml -n eventstrat'
                        sh 'kubectl apply -f k8s/analytics/deployment.yaml -n eventstrat'
                        sh 'kubectl apply -f k8s/sessions/deployment.yaml -n eventstrat'
                        sh 'kubectl apply -f k8s/polls/deployment.yaml -n eventstrat'
                        sh 'kubectl apply -f k8s/blog/deployment.yaml -n eventstrat'
                        sh 'kubectl apply -f k8s/notification/deployment.yaml -n eventstrat'
                        sh 'kubectl apply -f k8s/aahar/deployment.yaml -n eventstrat'
                        sh 'kubectl apply -f k8s/client/deployment.yaml -n eventstrat'

                        sh 'kubectl apply -f k8s/ingress.yaml -n eventstrat'
                        sleep 30
                   } 
                }
            }
        }
        stage('Verify Deployment to Prod') {
            steps {
                script {
                    withKubeConfig(caCertificate: '', clusterName: 'eventstrat-cluster', contextName: '', credentialsId: 'k8-prod-token', namespace: 'eventstrat', restrictKubeConfigAccess: false, serverUrl: 'https://5BE13676B87469F594E76C5E34D70D15.gr7.us-east-1.eks.amazonaws.com') {
                       sh 'kubectl get pods -n eventstrat'
                       sh 'kubectl get ingress -n eventstrat'
                   } 
                }
            }
        }
     }
  }