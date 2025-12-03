pipeline {
    agent { label 'syed' }

    environment {
        APP_NAME = "angular-app"
        CONTAINER_NAME = "angular-app-container"
        DOCKER_IMAGE = "angular-app:latest"
    }

    stages {

        stage('Cleanup BEFORE Build') {
            steps {
                sh """
                docker rm -f \$(docker ps -aq) || true
                docker system prune -a -f || true
                """
            }
        }

        stage('Checkout Source') {
            steps { checkout scm }
        }

        stage('Install & Build Angular') {
            steps {
                sh """
                npm install
                npm run build --prod
                """
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
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
            echo "Running on 8080"
        }
    }
}
