provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "example" {
  ami           = "ami-080e1f13689e07408"  # Replace with Ubuntu AMI ID
  instance_type = "t2.micro"
  key_name      = "project"   # Replace with your key pair name
  security_groups = [
    "my-sec"          # Replace with your security group name
  ]
  tags = {
    Name = "Ubuntu Instance"
  }
}
resource "aws_ebs_volume" "example_volume" {
  availability_zone = "us-east-1a"  # Specify the availability zone where your instance is located
  size              = 8             # Specify the size of the volume in gigabytes
}
resource "aws_volume_attachment" "example_attachment" {
  device_name = "/prod/xvdf"             # Specify the device name for the volume
  volume_id   = aws_ebs_volume.example_volume.id
  instance_id = aws_instance.example.id  # Specify the instance ID
}
 provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y git"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("C:\Users\Manisha\Downloads\project.pem")  # Replace with the path to your private key file
      host        = self.public_ip
    }
  }

variable "aws_access_key" {
  description = "AWS Access Key ID"
}

variable "aws_secret_key" {
  description = "AWS Secret Access Key"
}
