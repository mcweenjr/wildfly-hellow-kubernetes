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
                script {
                        try {
				'docker stop mcweenjr/hello-world-war'
				'docker rm mcweenjr/hello-world-war'
                        } catch (err) {
                            echo: 'caught error: $err'
                        }
                        sh 'docker run -p 8280:8080 -p 9990:9990 -d mcweenjr/hello-world-war:latest /opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0'
                    }
                }
            }
        }
}
