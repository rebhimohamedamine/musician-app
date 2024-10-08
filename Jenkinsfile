pipeline {
    agent any

     	tools {
		nodejs 'NodeJS'
	}
	environment {
		DOCKER_HUB_CREDENTIALS_ID = 'dockerhub-jenkins-token'
		DOCKER_HUB_REPO = 'mohamedrebhi/projet'
	}
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master', credentialsId: 'git-cred' , url :'https://github.com/rebhimohamedamine/musician-app' // Replace with your repo URL
            }
        }
        
        stage('Install Dependencies') {
            steps {
                script {
                    sh 'npm install' // Install Node.js dependencies
                }
            }
        }
        
        stage('Install PM2') {
            steps {
                script {
                    sh 'npm install -g pm2' // Install PM2 globally
                }
            }
        }
        
        stage('Deploy Application') {
            steps {
                script {
                    // Replace with your deploy command
                    sh 'pm2 start app.js --name "your-app"'
                }
            }
        }
        
        stage('Build Docker Image'){
			steps {
				script {
	dockerImage = docker.build("${DOCKER_HUB_REPO}:latest")				}
			}
		}
		
		stage('Push Image to DockerHub'){
			steps {
				script {
					docker.withRegistry('https://registry.hub.docker.com', "${DOCKER_HUB_CREDENTIALS_ID}"){
						dockerImage.push('latest')
					}
				}
			}
		}
    }
    
    post {
        success {
            echo 'Deployment completed successfully!'
        }
        failure {
            echo 'Deployment failed. Please check the logs.'
        }
    }
}
