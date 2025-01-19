pipeline {
    agent none
    
    stages {
        stage('Build on Server-1') {
            agent { label 'build-node-1' }
            steps {
                sh 'echo "Building the Flask application on server-1."'
                // e.g., Docker build commands, pip install, etc.
            }
        }
        
        stage('Deploy on Server-2') {
            agent { label 'deploy-node-1' }
            steps {
                sh 'echo "Deploying the Flask application as a Pod on server-2."'
                // e.g., kubectl apply, helm install, etc.
            }
        }
    }
}
