resource "aws_instance" "minikube-server-02" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t3.medium"
  vpc_security_group_ids = [
    aws_security_group.my_ip_ssh.id,
    aws_security_group.jenkins_access.id,
    aws_security_group.https_world.id
  ]
  key_name               = "${var.key_pair_name}"
  root_block_device {
    volume_size = 20  ## 20GB is the minimum requirements for minikube
    volume_type = "gp3"
  }
  tags = {
    Name = "minikube-server-2"
  }
user_data = <<-EOF
            #!/bin/bash
            # Update the package index
            sudo apt-get update -y

            # Install prerequisite packages
            sudo apt-get install -y \
                apt-transport-https \
                ca-certificates \
                curl \
                software-properties-common

            # -----------------------------
            ####    INSTALL DOCKER     ####
            # -----------------------------
            # Add Docker's official GPG key
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
            
            # Add Docker's official APT repository
            echo \
              "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
              $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            
            # Update the package index again to include Docker packages
            sudo apt-get update -y

            # Install Docker
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io

            # Start Docker service
            sudo systemctl start docker

            # Enable Docker to start on boot
            sudo systemctl enable docker

            # Add the ec2-user to the docker group to run Docker without sudo
            sudo usermod -aG docker ubuntu

            # -----------------------------
            ###    INSTALL KUBECTL    ####
            # -----------------------------
            # Install kubectl binary with curl on Linux
            curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

            # Validate the binary (optional)
            # Download the kubectl checksum file:
            curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
            
            # Validate the kubectl binary against the checksum file:
            echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
            # If valid, the output is: kubectl: OK

            # Install kubectl:
            sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

            # Test to ensure the version you installed is up-to-date:
            kubectl version --client

            # -----------------------------
            ###    INSTALL MINIKUBE    ####
            # -----------------------------
            # Download the latest Minikube binary
            curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
            sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
            
            # To make docker the default driver:
            minikube config set driver docker

            # Start a cluster using the docker driver:
            minikube start --driver=docker

            EOF
}
