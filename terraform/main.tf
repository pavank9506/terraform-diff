resource "aws_instance" "terraform" {

    ami = "ami-0c02fb55956c7d316"
    instance_type = "t2.small"
    # vpc_security_group_ids = [aws_security_group.allow_ssh_terraform.id]
    tags = {
        Name = "terraform"
    }
}