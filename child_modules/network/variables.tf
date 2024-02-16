variable vpc_cidr_block {
  type        = string
  description = "CIDR block of VPC"
}

variable vpc_tag {
  type = string
}

variable pubsubnets {
  type        = map(string)
}

variable privsubnets {
  type        = map(string)
}

variable igw_tag {
  type = string
}

variable cidr_rt {
  type        = string
  description = "CIDR of route table"
}

variable rt_tag {
  type = string
}

variable azs_pub {
  type = map(string)
}

variable azs_priv {
  type = map(string)
}
