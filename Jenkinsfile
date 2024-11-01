pipeline {
    agent any

    tools {
        nodejs 'NodeJS'
    }

    environment {
        DOCKER_HUB_CREDENTIALS_ID = 'dockerhub-jenkins-token'
        DOCKER_HUB_REPO = 'mohamedrebhi/projet'
        VERSION = "${BUILD_NUMBER}"  // Use Jenkins BUILD_NUMBER as the version


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

        stage('Install PM2') {
            steps {
                script {
                    sh 'npm install -g pm2' // Install PM2 globally
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
