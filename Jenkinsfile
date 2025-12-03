pipeline {
    agent { label 'Agent-syed' }

    options {
        buildDiscarder(logRotator(numToKeepStr: '3'))
        disableConcurrentBuilds()
    }

    stages {

        stage('Cleanup') {
            steps {
                sh '''
                    docker container prune -f || true
                    docker image prune -af || true
                    rm -rf dist || true
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
                sh """
                    npm ci
                    npm run build --prod
                """
            }
        }

        stage('Docker Build') {
            steps {
                sh """
                    docker build -t angular-app:${BUILD_NUMBER} .
                """
            }
        }

        stage('Deploy') {
            steps {
                sh """
                    docker rm -f angular-app || true
                    docker run -d -p 8080:80 --name angular-app angular-app:${BUILD_NUMBER}
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
        }
    }
}
