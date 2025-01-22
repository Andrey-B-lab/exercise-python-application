This is the exercise file for the following pipeline:

JenkinsFile that clones the GitHub code to build server-1, build the Docker Image from it, upload it to DockerHub, then run it as a POD on deploy server-2 and expose it on port 443 using Nginx.

I added Sonar Cloud and Snyk tests to the GitHub Actions. Every time new code gets pushed to the Development branch, the test runs.

server-1 (build-node-1), Ubuntu 24.04 with Docker installed.

server-2 (deploy-node-1), Ubuntu 24.04 with minikube.

Route 53 Domain pointed to the server-2 EC2 instance.
