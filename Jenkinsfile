pipeline {
    agent none

    environment {
        DOCKER_IMAGE = "andreybyhalenko/exercise-python-application:latest"
    }

    stages {
        stage('Build & Push Docker Image') {
            agent { label 'build-node-1' }
            steps {
                //ensure the code is on build-node-1
                checkout scm

                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerHub',
                        usernameVariable: 'DOCKERHUB_USER',
                        passwordVariable: 'DOCKERHUB_PASS'
                    )]) {
                        sh """
                          docker build -t \$DOCKER_IMAGE .
                          docker login -u \$DOCKERHUB_USER -p \$DOCKERHUB_PASS
                          docker push \$DOCKER_IMAGE
                          docker logout
                        """
                    }
                }
            }
        }

        stage('Deploy') {
            agent { label 'deploy-node-1' }
            steps {
                checkout scm   //ensure the code is on deploy-node-1

                sh """
                  kubectl apply -f /home/ubuntu/jenkins_agent/workspace/exercise-python-application-pipeline/k8s/deployment.yaml
                  kubectl apply -f /home/ubuntu/jenkins_agent/workspace/exercise-python-application-pipeline/k8s/service.yaml
                  kubectl apply -f /home/ubuntu/jenkins_agent/workspace/exercise-python-application-pipeline/k8s/ingress.yaml
                """
            }
        }
    }
}
