output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}


output "alb_dns_name" {
  value = aws_lb.web_alb.dns_name
}

data "aws_instances" "web_asg_instances" {
  filter {
    name   = "tag:Name"
    values = ["assign2-web-asg-instance"] 
    }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
  }

output "web_inst_private_ips" { value = data.aws_instances.web_asg_instances.private_ips}

output "DB_server_priv_ip" { value = aws_instance.db_server_priv.private_ip}