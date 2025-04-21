variable "keypair" {
  default = "First_key_pair_ACS"


}


variable "user_data" {
  default = <<EOT
#!/bin/bash
yum update -y
echo "Instance ID:" > /home/ec2-user/assign2-app/instance_data.txt
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id >> /home/ec2-user/assign2-app/instance_data.txt
systemctl restart assign2-dashapp
EOT
}


variable "aws_region" {
  description = "AWS region that we will work in"
  default     = "us-east-1"
}
