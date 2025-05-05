# Terraform 类型和内置函数参考指南

## 0. Terraform 关键字（Keywords）

Terraform 中的关键字分为两类：

### 0.1 保留字（Reserved Words）
这些词完全不能用作变量名、资源名或其他标识符：

```hcl
# 主要保留字
count        # 用于创建多个相同资源的实例
for_each     # 用于基于映射或字符串集合创建多个资源实例
lifecycle    # 用于定义资源的生命周期规则
depends_on   # 用于显式声明资源之间的依赖关系
providers    # 用于在模块中指定提供者配置
source       # 用于指定模块的来源
version      # 用于指定模块或提供者的版本约束

# 块类型保留字
variable     # 用于声明输入变量
resource     # 用于声明资源
data         # 用于声明数据源
module       # 用于声明模块
output       # 用于声明输出值
locals       # 用于声明局部变量
terraform    # 用于配置 Terraform 行为
provider     # 用于配置提供者

# 生命周期相关保留字
create_before_destroy    # 指定在销毁旧资源之前创建新资源
prevent_destroy         # 防止资源被意外销毁
ignore_changes          # 指定在更新时忽略的属性
replace_triggered_by    # 指定触发资源替换的条件

# 元参数保留字
for         # 用于 for 表达式循环
in          # 用于 for 表达式和 for_each 中
to          # 用于 for 表达式范围
dynamic     # 用于动态创建嵌套块
content     # 用于动态块中引用内容

# 其他保留字
null        # 表示空值
true        # 布尔值真
false       # 布尔值假
```

### 0.2 内置函数名（Built-in Function Names）
这些词可以用作标识符，但建议避免使用以避免混淆：

```hcl
# 字符串操作函数
join        # 将列表连接成字符串
split       # 将字符串分割成列表
replace     # 替换字符串
trim        # 去除首尾指定字符
trimspace   # 去除首尾空格
upper       # 转换为大写
lower       # 转换为小写
title       # 将每个单词首字母大写
chomp       # 删除末尾的换行符
indent      # 缩进文本
trimprefix  # 删除前缀
trimsuffix  # 删除后缀

# 集合操作函数
length      # 获取集合长度
element     # 获取列表元素
concat      # 合并列表
distinct    # 去重
slice       # 获取列表片段
reverse     # 反转列表
sort        # 排序列表
contains    # 检查是否包含元素
keys        # 获取映射的所有键
values      # 获取映射的所有值
lookup      # 查找映射中的值
merge       # 合并映射
zipmap      # 将两个列表组合成映射

# 文件系统函数
file        # 读取文件内容
fileexists  # 检查文件是否存在
dirname     # 获取目录路径
basename    # 获取文件名
pathexpand  # 展开路径
abspath     # 获取绝对路径

# 编码函数
base64encode    # Base64编码
base64decode    # Base64解码
jsonencode     # 转换为JSON字符串
jsondecode     # 解析JSON字符串
urlencode      # URL编码
urldecode      # URL解码
yamlencode     # 转换为YAML
yamldecode     # 解析YAML

# 日期和时间函数
timestamp   # 获取当前时间戳
timeadd     # 时间加减
formatdate  # 格式化日期
timecmp     # 比较时间

# 数学函数
max         # 返回最大值
min         # 返回最小值
abs         # 返回绝对值
ceil        # 向上取整
floor       # 向下取整
pow         # 幂运算
log         # 对数
signum      # 符号函数
parseint    # 解析整数

# 类型转换函数
tostring    # 转换为字符串
tonumber    # 转换为数字
tobool      # 转换为布尔值
can         # 检查是否可以转换
try         # 尝试转换，失败返回默认值

# 网络函数
cidrhost    # 计算CIDR块中的主机IP
cidrnetmask # 获取CIDR块的网络掩码
cidrsubnets # 创建多个子网

# 条件函数
coalesce    # 返回第一个非空值
coalescelist # 返回第一个非空列表
nonsensitive # 移除敏感标记
sensitive   # 标记为敏感值

# 模板函数
templatefile # 处理模板文件
```

注意：
1. 使用保留字作为标识符会导致 Terraform 解析错误
2. 虽然内置函数名可以用作标识符，但建议避免使用以避免混淆
3. 在命名变量、资源等时，应避免使用任何关键字（包括保留字和内置函数名）

## 1. 基本类型（Primitive Types）

### 1.1 字符串（string）
```hcl
variable "name" {
  type    = string
  default = "example"
}
```

### 1.2 数字（number）
```hcl
variable "instance_count" {
  type    = number
  default = 42
}
```

### 1.3 布尔值（bool）
```hcl
variable "enabled" {
  type    = bool
  default = true
}
```

## 2. 集合类型（Collection Types）

### 2.1 列表（list）
```hcl
variable "subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
```

### 2.2 映射（map）
```hcl
variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Project     = "example"
  }
}
```

### 2.3 集合（set）
```hcl
variable "security_groups" {
  type    = set(string)
  default = ["sg-1", "sg-2"]
}
```

## 3. 结构类型（Structural Types）

### 3.1 对象（object）
```hcl
variable "user" {
  type = object({
    name    = string
    age     = number
    active  = bool
  })
  default = {
    name   = "John"
    age    = 30
    active = true
  }
}
```

### 3.2 元组（tuple）
```hcl
variable "mixed_list" {
  type    = tuple([string, number, bool])
  default = ["example", 42, true]
}
```

## 4. 内置函数（Built-in Functions）

### 4.1 字符串函数
```hcl
# 基本字符串操作
join(",", ["a", "b", "c"])        # 将列表连接成字符串
split(",", "a,b,c")               # 将字符串分割成列表
replace("hello world", "world", "terraform")  # 替换字符串
trim("  hello  ", " ")            # 去除首尾指定字符
trimspace("  hello  ")            # 去除首尾空格
upper("hello")                    # 转换为大写
lower("HELLO")                    # 转换为小写
title("hello world")              # 将每个单词首字母大写
chomp("hello\n")                  # 删除末尾的换行符
indent(2, "hello\nworld")         # 缩进文本
trimprefix("hello-world", "hello-")  # 删除前缀
trimsuffix("hello-world", "-world")  # 删除后缀
```

### 4.2 集合函数
```hcl
# 列表操作
length(["a", "b", "c"])           # 获取列表长度
element(["a", "b", "c"], 1)       # 获取列表元素
concat(["a", "b"], ["c", "d"])    # 合并列表
distinct(["a", "b", "a"])         # 去重
slice(["a", "b", "c", "d"], 1, 3) # 获取列表片段
reverse(["a", "b", "c"])          # 反转列表
sort(["c", "a", "b"])             # 排序列表
contains(["a", "b", "c"], "b")    # 检查是否包含元素

# Map操作
keys({a=1, b=2})                  # 获取所有键
values({a=1, b=2})                # 获取所有值
lookup({a=1, b=2}, "a", "default") # 查找键值
merge({a=1}, {b=2})               # 合并map
zipmap(["a", "b"], [1, 2])        # 将两个列表组合成map
```

### 4.3 文件系统函数
```hcl
file("path/to/file")              # 读取文件内容
fileexists("path/to/file")        # 检查文件是否存在
dirname("path/to/file")           # 获取目录路径
basename("path/to/file.txt")      # 获取文件名
pathexpand("~/file")              # 展开路径
abspath("file")                   # 获取绝对路径
```

### 4.4 编码函数
```hcl
base64encode("hello")             # Base64编码
base64decode("aGVsbG8=")          # Base64解码
jsonencode({name = "John"})       # 转换为JSON字符串
jsondecode("{\"name\":\"John\"}") # 解析JSON字符串
urlencode("hello world")          # URL编码
urldecode("hello%20world")        # URL解码
yamlencode({name = "John"})       # 转换为YAML
yamldecode("name: John")          # 解析YAML
```

### 4.5 日期和时间函数
```hcl
timestamp()                       # 获取当前时间戳
timeadd("2024-01-01", "24h")      # 时间加减
formatdate("YYYY-MM-DD", timestamp())  # 格式化日期
timecmp("2024-01-01", "2024-02-01")    # 比较时间
```

### 4.6 数学函数
```hcl
max(1, 2, 3)                     # 返回最大值
min(1, 2, 3)                     # 返回最小值
abs(-5)                          # 返回绝对值
ceil(3.7)                        # 向上取整
floor(3.7)                       # 向下取整
pow(2, 3)                        # 幂运算
log(10, 100)                     # 对数
signum(-5)                       # 符号函数
parseint("100", 10)              # 解析整数
```

### 4.7 类型转换函数
```hcl
tostring(42)                     # 转换为字符串
tonumber("42")                   # 转换为数字
tobool("true")                   # 转换为布尔值
can(tonumber("42"))              # 检查是否可以转换
try(tonumber("42"), 0)           # 尝试转换，失败返回默认值
```

### 4.8 网络函数
```hcl
cidrhost("10.0.0.0/24", 5)       # 计算CIDR块中的主机IP
cidrnetmask("10.0.0.0/24")       # 获取CIDR块的网络掩码
cidrsubnets("10.0.0.0/16", 8, 8) # 创建多个子网
```

### 4.9 条件函数
```hcl
coalesce("", "b", "c")           # 返回第一个非空值
coalescelist([], ["b"], ["c"])   # 返回第一个非空列表
nonsensitive(sensitive("secret")) # 移除敏感标记
sensitive("secret")              # 标记为敏感值
```

### 4.10 模板函数
```hcl
templatefile("template.tpl", {
  name = "John"
})                                # 处理模板文件
```

## 5. 使用示例

### 5.1 基本类型使用
```hcl
variable "name" {
  type    = string
  default = "example"
}

variable "instance_count" {
  type    = number
  default = 5
}

variable "enabled" {
  type    = bool
  default = true
}
```

### 5.2 集合类型使用
```hcl
variable "subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Project     = "example"
  }
}
```

### 5.3 结构类型使用
```hcl
variable "user" {
  type = object({
    name    = string
    age     = number
    active  = bool
  })
  default = {
    name   = "John"
    age    = 30
    active = true
  }
}

variable "mixed_list" {
  type    = tuple([string, number, bool])
  default = ["example", 42, true]
}
```

### 5.4 函数组合使用
```hcl
locals {
  # 字符串处理
  name = upper(trimspace("  hello world  "))
  
  # 列表处理
  sorted_list = sort(distinct(["c", "a", "b", "a"]))
  
  # 条件处理
  instance_type = var.environment == "prod" ? "t3.large" : "t3.micro"
  
  # 网络计算
  subnet_cidrs = cidrsubnets(var.vpc_cidr, 8, 8)
}
```

## 6. 注意事项

1. 变量名不能使用 Terraform 保留字：
   - count
   - for_each
   - lifecycle
   - depends_on
   - providers
   - source
   - version

2. 函数调用注意事项：
   - 函数调用必须用在正确的位置（变量定义、资源属性、输出等）
   - 函数可以嵌套使用
   - 确保函数返回的类型符合使用场景

3. 类型转换注意事项：
   - 某些类型可以自动转换（如数字到字符串）
   - 某些类型需要显式转换
   - 使用 try() 函数处理可能的转换错误
