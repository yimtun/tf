variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the instance"
  type        = map(string)
  default     = {}
}

resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags          = var.tags
}

output "instance_id" {
  description = "The ID of the created instance"
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "The private IP of the created instance"
  value       = aws_instance.this.private_ip
}

output "public_ip" {
  description = "The public IP of the created instance"
  value       = aws_instance.this.public_ip
}
