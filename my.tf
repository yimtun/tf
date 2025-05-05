# 字符串类型
variable "name" {
  type    = string
  default = "example"
}

# 数字类型
variable "age" {
  type    = number
  default = 5
}

# 布尔类型
variable "enabled" {
  type    = bool
  default = true
}

# 列表类型
variable "subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

# 映射类型
variable "tags_me" {
  type = map(string)
  default = {
    Environment = "dev"
    Project     = "example"
  }
}

# 对象类型
variable "user" {
  type = object({
    name   = string
    age    = number
    active = bool
  })
  default = {
    name   = "John"
    age    = 30
    active = true
  }
}

# 元组类型
variable "mixed_list" {
  type    = tuple([string, number, bool])
  default = ["example", 42, true]
}


# 首先定义一些基础变量
variable "base_name" {
  type    = string
  default = "my-app"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "tags" {
  type = map(string)
  default = {
    Project     = "demo"
    Environment = "dev"
    Owner       = "team"
  }
}

# 使用 locals 定义一些中间值
locals {
  # 基础字符串
  full_name = "${var.base_name}-${var.environment}"

  # 带空格的字符串
  spaced_name = "  ${local.full_name}  "

  # 带特殊字符的字符串
  special_name = "my@special#name"
}

# 使用 output 演示各种字符串操作函数
output "string_operations" {
  description = "演示各种字符串操作函数"
  value = {
    # 1. join 函数示例
    join_example = join("-", ["prefix", var.base_name, var.environment])

    # 2. split 函数示例
    split_example = split("-", local.full_name)

    # 3. replace 函数示例
    replace_example = replace(local.special_name, "@", "-")

    # 4. trim 函数示例
    trim_example = trim(local.spaced_name, " ")

    # 5. upper 函数示例
    upper_example = upper(local.full_name)

    # 6. lower 函数示例
    lower_example = lower(local.full_name)
  }
}

# 演示字符串函数组合使用
output "combined_operations" {
  description = "演示字符串函数的组合使用"
  value = {
    # 组合使用多个函数
    complex_example = upper(
      trim(
        replace(
          join("-", [var.base_name, var.environment]),
          "my",
          "our"
        ),
        ""
      )
    )
  }
}

# 演示在标签处理中使用字符串函数
output "tag_operations" {
  description = "演示在标签处理中使用字符串函数"
  value = {
    # 处理标签值
    formatted_tags = {
      for k, v in var.tags : k => upper(trim(v, " "))
    }

    # 创建标签字符串
    tag_string = join(", ", [
      for k, v in var.tags : "${k}=${v}"
    ])
  }
}

# 演示在路径处理中使用字符串函数
output "path_operations" {
  description = "演示在路径处理中使用字符串函数"
  value = {
    # 构建路径
    path_example = join("/", [
      var.environment,
      var.base_name,
      "config"
    ])

    # 清理路径
    clean_path = replace(
      join("/", ["", var.environment, var.base_name, "config"]),
      "//",
      "/"
    )
  }
}

# 演示条件字符串处理
output "conditional_operations" {
  description = "演示条件字符串处理"
  value = {
    # 根据环境使用不同的前缀
    conditional_name = join("-", [
      var.environment == "prod" ? "prod" : "dev",
      var.base_name
    ])

    # 条件替换
    conditional_replace = replace(
      local.full_name,
      var.environment == "prod" ? "my" : "dev",
      "new"
    )
  }
}

# 1字符串操作
#join(",", ["a", "b", "c"])        # 将列表连接成字符串
#split(",", "a,b,c")               # 将字符串分割成列表
#replace("hello world", "world", "terraform")  # 替换字符串
#trim("  hello  ")                 # 去除首尾空格
#upper("hello")                    # 转换为大写
#lower("HELLO")                    # 转换为小写

