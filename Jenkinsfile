pipeline {
    agent { label 'syed' } // agent VM
    stages {
        stage('Install dependencies') {
            steps {
                sh 'npm install'
            }
        }
        stage('Build Angular') {
            steps {
                sh 'npm run build'
            }
        }
        // optional: Docker build, deploy
    }
}
