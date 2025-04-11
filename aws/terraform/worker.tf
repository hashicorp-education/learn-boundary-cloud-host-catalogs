output "worker_public_ip" {
  description = "boundary worker public ip address"
  value       = aws_instance.boundary_worker.public_ip
}

output "boundary_worker_key_pair_name" {
  description = "key par name used to access the ec2 instances"
  value       = aws_key_pair.boundary_worker_key.key_name
}

output "worker_private_key" {
  description = "ssh private key value used to access the ec2 instance"
  value       = tls_private_key.worker_ssh_key.private_key_pem
  sensitive   = true
}

## these resources enable SSH access to the worker later as

resource "aws_internet_gateway" "boundary_gateway" { 
  vpc_id = aws_vpc.boundary_hosts_vpc.id
  tags = {
    Name = "boundary_hosts_internet_gateway"
  }
}

resource "aws_route_table" "boundary_hosts_public_rt" {
  vpc_id = aws_vpc.boundary_hosts_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.boundary_gateway.id
  }

  tags = {
    Name = "boundary_hosts_public_route_table"
  }
}

resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.boundary_hosts_subnet.id
  route_table_id = aws_route_table.boundary_hosts_public_rt.id
}

resource "aws_security_group" "boundary_worker_outbound" {
  name        = "boundary_worker_outbound"
  description = "Allow outbound worker traffic"
  vpc_id      = aws_vpc.boundary_hosts_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_outbound"
  }
}

resource "tls_private_key" "worker_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "boundary_worker_key" {
  key_name   = "${terraform.workspace}-boundary-worker-key"
  public_key = tls_private_key.worker_ssh_key.public_key_openssh
  tags       = {
    Name = "${terraform.workspace}-boundary-worker-key"
  }
}

resource "aws_instance" "boundary_worker" {
  ami                    = data.aws_ami.amazon.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.boundary_worker_key.key_name
  subnet_id              = aws_subnet.boundary_hosts_subnet.id
  vpc_security_group_ids = [aws_security_group.boundary_ssh.id, aws_security_group.boundary_worker_outbound.id]
  iam_instance_profile   = aws_iam_instance_profile.boundary_worker_dhc_profile.id
  user_data = templatefile("worker-setup.sh.tftpl", {config = {cluster_id:var.BOUNDARY_CLUSTER_ID}})

  connection { 
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.worker_ssh_key.private_key_pem
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "../boundary-worker"
    destination = "/home/ec2-user/boundary-worker"
  }

  tags = {
    "Name":"boundary-worker","service-type":"worker","cloud":"aws"
  }
}

resource "local_sensitive_file" "worker_private_key" {
  filename = "worker_private_key.pem"
  file_permission = "600"
  content = tls_private_key.worker_ssh_key.private_key_pem
}