pipeline {
    agent any

    tools {
        nodejs 'NodeJS'
    }

    environment {
        DOCKER_HUB_CREDENTIALS_ID = 'dockerhub-jenkins-token'
        DOCKER_HUB_REPO = 'mohamedrebhi/projet'
        VERSION = "${BUILD_NUMBER}"  // Use Jenkins BUILD_NUMBER as the version
        SONAR_PROJECT_KEY = 'appnode'
	SONAR_SCANNER_HOME = tool 'SonarQubeScanner'


    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master', credentialsId: 'git-cred', url: 'https://github.com/rebhimohamedamine/musician-app' // Replace with your repo URL
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    sh 'npm install' // Install Node.js dependencies
                }
            }
        }
        //  stage('Tests'){
	//		steps {
	//			sh 'npm test'
	//		}
	//	}
        stage('Install PM2') {
            steps {
                script {
                    sh 'npm install -g pm2' // Install PM2 globally
                }
            }
        }

        stage('SonarQube Analysis'){
			steps {
				withCredentials([string(credentialsId: 'node-app-token', variable: 'SONAR_TOKEN')]) {
				   
					withSonarQubeEnv('SonarQube') {
						sh """
                  				${SONAR_SCANNER_HOME}/bin/sonar-scanner \
                  				-Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                    				-Dsonar.sources=. \
                   				-Dsonar.host.url=http://localhost:9000 \
                    				-Dsonar.login=${SONAR_TOKEN}
                    				"""
					}	
				}
			}
		}

	

        stage('Build Docker Image') {
            steps {
                script {
                    // Build and tag the image with the version and latest
                    dockerImage = docker.build("${DOCKER_HUB_REPO}:${VERSION}")
                    dockerImage.tag('latest')  // Tag the same image as 'latest'
                }
            }
        }


        stage('Push Image to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', "${DOCKER_HUB_CREDENTIALS_ID}") {
                        // Push both the versioned and the latest tag
                        dockerImage.push("${VERSION}")  // Push versioned image
                        dockerImage.push('latest')       // Push 'latest' tag
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
