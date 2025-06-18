variable vpc_cidr_block {}
variable private_subnet_cidr_blocks {} 
variable public_subnet_cidr_blocks {} 

variable env_prefix {
    default = "test"
}
variable cluster_name {
    default = "my-app-cluster"
}
variable cluster_version {
    default = "1.31"
}
variable region {
    default = "ap-southeast-1"
}
