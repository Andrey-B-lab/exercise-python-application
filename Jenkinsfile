pipeline {
    agent none

    environment {
        DOCKER_IMAGE = "andreybyhalenko/exercise-python-application:latest"
    }

    stages {
        stage('Build & Push Docker Image') {
            agent { label 'build-node-1' }
            steps {
                checkout scm

                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerHub',
                        usernameVariable: 'DOCKERHUB_USER',
                        passwordVariable: 'DOCKERHUB_PASS'
                    )]) {
                        // Build and push the Docker Image
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
                checkout scm

                // Install Nginx and Certbot
                sh """
                  sudo apt update
                  sudo apt install -y certbot python3-certbot-nginx nginx
                """

                // Authenticate and install certificate
                sh """
                  sudo certbot --nginx -d andreyexercise.com --non-interactive --agree-tos --email byhalenko@gmail.com
                """

                // Add minikube Nginx configurations to sites-available
                sh '''
                  cat <<EOF | sudo tee /etc/nginx/sites-available/minikube
                  server {
                      listen      443 ssl;
                      server_name andreyexercise.com;

                      ssl_certificate /etc/letsencrypt/live/andreyexercise.com/fullchain.pem;
                      ssl_certificate_key /etc/letsencrypt/live/andreyexercise.com/privkey.pem;
                      ssl_protocols TLSv1.2 TLSv1.3;
                      ssl_prefer_server_ciphers on;

                      location / {
                          proxy_pass http://192.168.49.2:30443;
                          proxy_set_header Host $host;
                          proxy_set_header X-Real-IP $remote_addr;
                          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                          proxy_set_header X-Forwarded-Proto $scheme;
                      }
                  }

                  server {
                      listen      80;
                      server_name andreyexercise.com;

                      # Redirect HTTP to HTTPS
                      return 301 https://\$host\$request_uri;
                  }
                  EOF
                '''

                // Add minikube Nginx configurations to sites-enabled and remove the default configurations
                sh """
                  sudo ln -s /etc/nginx/sites-available/minikube /etc/nginx/sites-enabled/
                  sudo rm -f /etc/nginx/sites-enabled/default
                """

                // Restart Nginx
                sh """
                  sudo systemctl restart nginx
                """

                // Start the POD and Service
                sh """
                  kubectl apply -f k8s/deployment.yml
                  kubectl apply -f k8s/service.yml
                """
            }
        }
    }
}
