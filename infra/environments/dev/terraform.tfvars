project     = "fluxdeploy"
environment = "dev"
region      = "ap-south-1"

availability_zones   = ["ap-south-1a", "ap-south-1b"]
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]

node_instance_type = "t3.small"
node_desired_size  = 2
node_min_size      = 1
node_max_size      = 4

db_password = "FluxDeploy2024!"