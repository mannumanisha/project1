provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-080e1f13689e07408"
  instance_type = "t2.micro"
  key_name      = "project"
  security_groups = [
    "my-sec"
  ]
  tags = {
    Name = "Ubuntu Instance"
  }
}

resource "aws_ebs_volume" "example_volume" {
  availability_zone = "us-east-1a"
  size              = 8
}

resource "aws_volume_attachment" "example_attachment" {
  device_name = "/dev/xvdf"  # Changed device name for Ubuntu
  volume_id   = aws_ebs_volume.example_volume.id
  instance_id = aws_instance.example.id
}

resource "null_resource" "install_tools" {
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y git unzip",
      "sudo unzip terraform_1.0.0_linux_amd64.zip -d /usr/local/bin/"  # Adjusted unzip command for Ubuntu
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("C:\Users\Manisha\Downloads\project.pem")
      host        = aws_instance.example.public_ip
    }
  }
}
variable "aws_access_key" {
  description = "AWS Access Key ID"
}

variable "aws_secret_key" {
  description = "AWS Secret Access Key"
}
