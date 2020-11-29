resource "aws_instance" "jenkins_agent" {
  ami = "ami-04d29b6f966df1537"
  instance_type = "t2.micro"
  key_name = aws_key_pair.jenkins_ec2_key.key_name

  tags = {
    Name = "Jenkins Agent"
  }

  security_groups = ["default", aws_security_group.jenkins.name]

  connection {
    host = aws_instance.jenkins_agent.public_ip
    user = "ec2-user"
    private_key = file("jenkins_ec2_key")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install docker git java-1.8.0 -y",
      "sudo service docker start",
      "sudo usermod -aG docker ec2-user"
    ]
  }
}