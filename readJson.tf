# 1. 读取 JSON 文件
locals {
  config = jsondecode(file("${path.module}/config.json"))
}

# 2. 使用 JSON 数据创建资源
resource "aws_instance" "example" {
  ami           = local.config.ami_id
  instance_type = local.config.instance_type

  tags = local.config.tags
}

# 3. 使用 JSON 文件创建多个资源
resource "aws_instance" "multiple" {
  for_each = { for idx, config in local.config.instances : idx => config }

  ami           = each.value.ami_id
  instance_type = each.value.instance_type

  tags = each.value.tags
}

# 4. 使用 JSON 文件作为变量默认值
variable "config_file" {
  type    = string
  default = "config.json"
}

locals {
  config_data = jsondecode(file(var.config_file))
}

# 5. 使用 JSON 文件中的嵌套数据
resource "aws_security_group" "example" {
  name        = local.config_data.security_group.name
  description = local.config_data.security_group.description

  dynamic "ingress" {
    for_each = local.config_data.security_group.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}

# 6. 使用 JSON 文件中的列表数据
resource "aws_route53_record" "example" {
  for_each = { for idx, record in local.config_data.dns_records : idx => record }

  zone_id = each.value.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = each.value.ttl
  records = each.value.records
}

# 7. 使用 JSON 文件中的条件配置
resource "aws_autoscaling_group" "example" {
  name             = local.config_data.asg.name
  desired_capacity = local.config_data.asg.desired_capacity
  max_size         = local.config_data.asg.max_size
  min_size         = local.config_data.asg.min_size

  launch_template {
    id      = local.config_data.asg.launch_template.id
    version = local.config_data.asg.launch_template.version
  }

  dynamic "tag" {
    for_each = local.config_data.asg.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

# 8. 使用 JSON 文件中的环境变量
resource "aws_ssm_parameter" "example" {
  for_each = local.config_data.parameters

  name        = each.value.name
  description = each.value.description
  type        = each.value.type
  value       = each.value.value
  overwrite   = each.value.overwrite
}

# 9. 使用 JSON 文件中的网络配置
resource "aws_vpc" "example" {
  cidr_block           = local.config_data.vpc.cidr_block
  enable_dns_hostnames = local.config_data.vpc.enable_dns_hostnames
  enable_dns_support   = local.config_data.vpc.enable_dns_support

  tags = local.config_data.vpc.tags
}

resource "aws_subnet" "example" {
  for_each = { for idx, subnet in local.config_data.vpc.subnets : idx => subnet }

  vpc_id            = aws_vpc.example.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = each.value.tags
}
