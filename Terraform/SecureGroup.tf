# Security Groups

# Instance 

resource "aws_security_group" "allow_ssh_http_https" {
    name = "allow_ssh_http_https"
    vpc_id = module.vpc.vpc_id

    # allow http from anywhere
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    # allow ssh from anywhere
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    # allow all outbound
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = merge(local.common_tags, {Name = "For_Instance"})
}

resource "aws_security_group" "ELB-sg" {
    name = "ELB-sg"
    vpc_id = module.vpc.vpc_id
    # allow http from any where
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    # allow all outbound
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = merge(local.common_tags, {Name = "For_Instance"})
}