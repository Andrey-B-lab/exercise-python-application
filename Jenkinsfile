pipeline {
    agent none

    environment {
        DOCKER_IMAGE = "andreybyhalenko/exercise-python-application:latest"
        GIT_BRANCH   = "development"
        GIT_URL      = "https://github.com/Andrey-B-lab/exercise-python-application.git"
    }

    stages {
        stage('Checkout Source (Build Node)') {
            agent { label 'build-node-1' } 
            steps {
                // Pull the code on build-node-1
                git branch: "${GIT_BRANCH}", url: "${GIT_URL}"
            }
        }

//        stage('Checkout Source (Deploy Node)') {
//            agent { label 'deploy-node-1' }
//            steps {
//                // Pull the code on deploy-node-1
//                git branch: "${GIT_BRANCH}", url: "${GIT_URL}"
//            }
//        }

        stage('Build & Push Docker Image') {
            agent { label 'build-node-1' }
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerHub',
                        usernameVariable: 'DOCKERHUB_USER',
                        passwordVariable: 'DOCKERHUB_PASS'
                    )]) {
                        sh """
                          echo "Building Docker image: \$DOCKER_IMAGE"
                          docker build -t \$DOCKER_IMAGE .

                          echo "Logging into Docker Hub..."
                          docker login -u \$DOCKERHUB_USER -p \$DOCKERHUB_PASS

                          echo "Pushing image to Docker Hub..."
                          docker push \$DOCKER_IMAGE

                          echo "Logging out..."
                          docker logout
                        """
                    }
                }
            }
        }

        stage('Deploy to K8s on deploy-node-1') {
            agent { label 'deploy-node-1' }
            steps {
                script {
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: "${GIT_BRANCH}"]],
                        userRemoteConfigs: [[url: "${GIT_URL}"]]
                    ])
                    
                    sh """
                      echo "Applying deployment.yml..."
                      kubectl apply -f k8s/deployment.yaml

                      echo "Applying service.yml..."
                      kubectl apply -f k8s/service.yml

                      echo "Applying ingress.yml..."
                      kubectl apply -f k8s/ingress.yml
                    """
                }
            }
        }
    }
}
