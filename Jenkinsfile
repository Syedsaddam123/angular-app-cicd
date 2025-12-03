pipeline {
    agent { label 'syed' }

    environment {
        IMAGE_NAME   = "angular-app"
        TAG          = "${env.BUILD_NUMBER}"
    }

    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timestamps()
    }

    stages {

        stage('Pre-Cleanup') {
            steps {
                sh '''
                    docker system prune -af || true
                    docker builder prune -af || true
                    rm -rf node_modules || true
                '''
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install & Build Angular') {
            steps {
                sh '''
                    npm ci
                    npm run build --prod
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh """
                    docker build \
                    --no-cache \
                    -t ${IMAGE_NAME}:${TAG} .
                """
            }
        }

        stage('Deploy') {
            steps {
                sh """
                    docker rm -f ${IMAGE_NAME} || true
                    docker run -d -p 8080:80 \
                        --name ${IMAGE_NAME} \
                        ${IMAGE_NAME}:${TAG}
                """
            }
        }

    }

    post {
        always {
            sh """
                docker image prune -af || true
                docker container prune -f || true
            """
            echo "Build finished..."
        }

        success {
            echo "App deployed: http://<agent-ip>:8080"
        }
    }
}
