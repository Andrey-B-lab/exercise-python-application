resource "aws_instance" "docker-server-01" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  key_name      = var.key_pair_name
  
  vpc_security_group_ids = [
    aws_security_group.jenkins_access.id,
    aws_security_group.my_ip_ssh.id
  ]
  tags = {
    Name = "docker-server-1"
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
            # Add Docker’s official GPG key
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
            
            # Add Docker’s official APT repository
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

            EOF
}
