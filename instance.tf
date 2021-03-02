# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  shared_credentials_file = "/home/ricardocampelo/.aws/credentials"
  profile = "lrcampelo"
}
 
 
resource "aws_instance" "unyleya" {
  ami = "ami-042e8287309f5df03"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.my-key.key_name}"
  security_groups = ["${aws_security_group.gpo_ssh.name}"]
}

resource "aws_key_pair" "my-key" {
  key_name = "my-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_security_group" "gpo_ssh" {
    name = "gpo_ssh"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output "unyleya_public_dns"{
    value = "${aws_instance.unyleya.public_dns}"
}