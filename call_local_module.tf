# 调用本地 EC2 模块
module "ec2_instance" {
  source = "./modules/ec2"

  ami_id        = "ami-0735c191cf914754d" # Amazon Linux 2023 AMI in us-west-2
  instance_type = "t2.micro"
  tags = {
    Name        = "example-instance"
    Environment = "dev"
  }
}

# 使用模块输出
output "instance_id" {
  description = "The ID of the created instance"
  value       = module.ec2_instance.instance_id
}

output "private_ip" {
  description = "The private IP of the created instance"
  value       = module.ec2_instance.private_ip
}

# 在 apply 后自动导出输出到 JSON 和 YAML 文件
resource "null_resource" "export_outputs" {
  triggers = {
    instance_id = module.ec2_instance.instance_id
  }

  # 在资源创建时执行
  provisioner "local-exec" {
    when    = create
    command = <<-EOT
      terraform output -json > outputs.json
      if command -v yq &> /dev/null; then
        terraform output -json | yq -P > outputs.yaml
      fi
    EOT
  }

  # 在资源销毁时执行
  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      echo "{}" > outputs.json
      if command -v yq &> /dev/null; then
        echo "{}" | yq -P > outputs.yaml
      fi
    EOT
  }
}
