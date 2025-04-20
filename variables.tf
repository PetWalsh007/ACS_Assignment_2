variable "keypair" {
  default = "First_key_pair_ACS"


}


variable "user_data" {
  default = <<EOT
#!/bin/bash
yum update -y
yum install -y httpd
systemctl enable httpd
systemctl start httpd

echo "<b>Instance ID:</b> " > /var/www/html/id.html
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id >> /var/www/html/id.html
EOT
}


variable "aws_region" {
  description = "AWS region that we will work in"
  default     = "us-east-1"
}
