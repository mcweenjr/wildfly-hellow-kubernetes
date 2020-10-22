pipeline {
    agent any
    stages {
        stage('Maven Build') {
            steps {
                echo 'Running build automation'
                sh 'mvn clean package'
            }
        }
        stage('Build Docker Image') {
            steps {
                input 'Build the the Docker Image?'
                milestone(1)
                script {
                    app = docker.build("mcweenjr/hello-world-war:${env.BUILD_ID}")
                    app.inside {
                        sh 'echo $(curl localhost:8080)'
                    }
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                input 'Push Docker Image?'
                milestone(2)
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub_id') {
                        app.push("${env.BUILD_ID}")
                        app.push("latest")
                    }
                }
            }
        }
        stage('DeployToProduction') {
            steps {
                input 'Deploy to Production?'
                milestone(3)
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                    configs: 'hello-world-kube.yml',
                    enableConfigSubstitution: true
                      )                
                    }
                }
            }
        }
