#Server variables

variable vpc_server {
  type        = string
}

variable pub_sub_server {
  type        = string
}

variable priv_sub_server {
  type        = set(string)
}


variable wordpress_sg_name  {
  type        = string
}

variable wordpress_sg_description {
  type        = string
}

variable wordpress_sg_tag {
  type = string
}

variable ports {
  type        = map(number)
}

variable wordpress_sg_protocol {
  type        = string
}

variable wordpress_sg_cidr_blocks {
  type        = list(string)
}

variable instance_ami {
  type        = string
}


variable instance_type {
  type        = string
}

variable pub_ip_address {
  type        = bool
}

variable instance_tag {
  type        = string
}

variable rds_sg_name {
  type        = string
}

variable rds_sg_description {
  type        = string
}

variable rds_sg_tag {
  type = string
}

variable rds_sg_fromport {
  type        = number
}

variable rds_sg_toport {
  type        = number
}

variable rds_sg_protocol {
  type        = string
}

variable storage {
  type        = number
}

variable db_name {
  type        = string
}

variable engine {
  type        = string
}

variable engine_version {
  type        = string
}

variable db_class {
  type        = string
}

variable username {
  type        = string
}

variable password {
  type        = string
}

variable skip_final_snapshot {
  type        = bool
}

variable db_subnet_name {
  type        = string
}
