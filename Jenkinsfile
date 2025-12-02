pipeline {
    agent { label 'syed' } // agent VM

    environment {
        APP_NAME = "angular-app"
        CONTAINER_NAME = "angular-app-container"
        DOCKER_IMAGE = "angular-app:latest"
    }

    stages {

        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }

        stage('Build Angular (Production)') {
            steps {
                sh "npm run build --prod"
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t ${DOCKER_IMAGE} .
                """
            }
        }

        stage('Deploy Container') {
            steps {
                sh """
                docker rm -f ${CONTAINER_NAME} || true
                docker run -d -p 8080:80 --name ${CONTAINER_NAME} ${DOCKER_IMAGE}
                """
            }
        }
    }

    post {
        always {
            echo "Build finished..."
        }
        success {
            echo "Deployment successful! App running on port 8080."
        }
        failure {
            echo "Pipeline failed. Check logs."
        }
    }
}
