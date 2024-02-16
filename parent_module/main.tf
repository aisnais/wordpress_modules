provider "aws" {
  region = "us-east-1"
}
### Creating Remote Backend on AWS S3: S3 for storage and DynamoDB for locking the tf state file 

terraform {
  backend "s3" {
    bucket = "ais-wordpress"
    key    = "tf-infra/terraform.tfstate"
    dynamodb_table = "ais-tfstate-locking"
    region = "us-east-1"
    encrypt = true
  }
}

resource "aws_s3_bucket" "wordpress_s3" {
  bucket = "ais-wordpress"
    tags = {
    Name        = "tf state file storage"
    Environment = "Storage"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket-encryption" {
  bucket = aws_s3_bucket.wordpress_s3.bucket
  rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
}

resource "aws_s3_bucket_versioning" "versioning_bucket" {
  bucket = aws_s3_bucket.wordpress_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "wordpress_db" {
  name           = "ais-tfstate-locking"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
#------------------------------------------------------------------#

module network {
  source  = "../child_modules/network"
  vpc_cidr_block = "10.0.0.0/16"
  vpc_tag = "wordpress-vpc"
  pubsubnets = {
    pub_sub1 = "10.0.10.0/24"
    pub_sub2 = "10.0.20.0/24" 
    pub_sub3 = "10.0.30.0/24" 
  }
    privsubnets = {
    priv_sub1 = "10.0.40.0/24"
    priv_sub2 = "10.0.50.0/24" 
    priv_sub3 = "10.0.60.0/24" 
  }
  azs_pub = {
    pub_sub1 = "us-east-1a"
    pub_sub2 = "us-east-1b"
    pub_sub3 = "us-east-1c"
  }
   azs_priv = {
    priv_sub1 = "us-east-1f"
    priv_sub2 = "us-east-1b"
    priv_sub3 = "us-east-1c"
  }
  igw_tag = "wordpress_igw"
  rt_tag = "wordpress_rt"
  cidr_rt = "0.0.0.0/0"
}

module server {
  source = "../child_modules/server"
  vpc_server = module.network.vpc_server
  wordpress_sg_name = "wordpress-sg"
  wordpress_sg_description = "Allow HTTP, HTTPS and SSH ports inbound traffic and all outbound traffic"
  wordpress_sg_tag = "wordpress"
  ports = {
    port1 = 22
    port2 = 80
    port3 = 443
  }
  wordpress_sg_protocol = "tcp"
  wordpress_sg_cidr_blocks = ["0.0.0.0/0"]
  pub_sub_server = module.network.pub_sub_server
  instance_ami = "ami-0cf10cdf9fcd62d37"
  instance_type = "t2.micro"
  pub_ip_address = true
  instance_tag = "wordpress_ec2"
  rds_sg_name = "rds-sg"
  rds_sg_description = "Allow traffic from Wordpress sg"
  rds_sg_tag = "rds"
  rds_sg_fromport = 3306
  rds_sg_toport = 3306
  rds_sg_protocol = "tcp"
  storage = 20
  db_name = "wordpress_db"
  engine = "mysql"
  engine_version = "5.7"
  db_class = "db.t2.micro"
  username = "admin"
  password = "adminadmin"
  skip_final_snapshot = true
  db_subnet_name = "wordpress-db-subnet"
  priv_sub_server = module.network.priv_sub_server
}
