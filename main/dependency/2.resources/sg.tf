

locals {
  sg_all = {
    sg_name = "sg-all"
    ingress_rules= [
     {
       description      ="ssh"
       from_port       =22,
       to_port         =22,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      ="HTTPS"
       from_port       =443,
       to_port         =443,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      ="NFS"
       from_port       =2049,
       to_port         =2049,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      =""
       from_port       =8080,
       to_port         =8080,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      =""
       from_port       =8081,
       to_port         =8081,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      =""
       from_port       =5671,
       to_port         =5671,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      =""
       from_port       =5672,
       to_port         =5672,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      =""
       from_port       =15672,
       to_port         =15672,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      ="HTTP"
       from_port       =80,
       to_port         =80,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      =""
       from_port       =3000,
       to_port         =3000,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      =""
       from_port       =5432,
       to_port         =5432,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      ="HTTP"
       from_port       =3306,
       to_port         =3306,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      ="HTTP"
       from_port       =5000,
       to_port         =5000,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      ="tcp"
       from_port       =32500,
       to_port         =32500,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      ="tcp"
       from_port       =32501,
       to_port         =32501,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     }
    ]
    egress_rules= [
     {
       from_port       =0,
       to_port         =0,
       protocol        ="-1",
       cidr_blocks     =["0.0.0.0/0"]
     }
    ]
  }

  sg_bastion = {
    sg_name = "sg-bastion"
    ingress_rules= [
     {
       description      ="ssh"
       from_port       =22,
       to_port         =22,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     }
    ]
    egress_rules= [
     {
       from_port       =0,
       to_port         =0,
       protocol        ="-1",
       cidr_blocks     =["0.0.0.0/0"]
     }
    ]
  }

  sg_gitlab = {
    sg_name = "sg-gitlab"
    ingress_rules= [
     {
       description      ="ssh"
       from_port       =22,
       to_port         =22,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      ="http"
       from_port       =80,
       to_port         =80,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      ="https"
       from_port       =443,
       to_port         =443,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     }
    ]
    egress_rules= [
     {
       from_port       =0,
       to_port         =0,
       protocol        ="-1",
       cidr_blocks     =["0.0.0.0/0"]
     }
    ]
  }
  
  sg_nexus = {
    sg_name = "sg-nexus"
    ingress_rules= [
     {
       description      ="http"
       from_port       =80,
       to_port         =80,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      ="https"
       from_port       =443,
       to_port         =443,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      ="http"
       from_port       =8081,
       to_port         =8081,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      ="ssh"
       from_port       =22,
       to_port         =22,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      ="tcp"
       from_port       =5000,
       to_port         =5000,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      ="tcp"
       from_port       =8080,
       to_port         =8080,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     }
    ]
    egress_rules= [
     {
       from_port       =0,
       to_port         =0,
       protocol        ="-1",
       cidr_blocks     =["0.0.0.0/0"]
     }
    ]
  }

  sg_db = {
    sg_name = "sg-db"
    ingress_rules= [
     {
       description      =""
       from_port       =5432,
       to_port         =5432,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      =""
       from_port       =3000,
       to_port         =3000,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     }
    ]
    egress_rules= [
     {
       from_port       =0,
       to_port         =0,
       protocol        ="-1",
       cidr_blocks     =["0.0.0.0/0"]
     }
    ]
  }

  sg_alb = {
    sg_name = "sg-alb"
    ingress_rules= [
     {
       description      ="HTTPS"
       from_port       =443,
       to_port         =443,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      =""
       from_port       =8080,
       to_port         =8080,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      =""
       from_port       =5672,
       to_port         =5672,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      =""
       from_port       =53,
       to_port         =53,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      =""
       from_port       =10250,
       to_port         =10250,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      =""
       from_port       =80,
       to_port         =80,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      =""
       from_port       =22,
       to_port         =22,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      =""
       from_port       =30158,
       to_port         =30158,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     },
     {
       description      =""
       from_port       =3000,
       to_port         =3000,
       protocol        ="tcp",
       cidr_blocks     =["0.0.0.0/0"]
     }
    ]
    egress_rules= [
     {
       from_port       =0,
       to_port         =0,
       protocol        ="-1",
       cidr_blocks     =["0.0.0.0/0"]
     }
    ]
  }
}

module "sg_all" {
  source       = "../../../modules/compute/vpc/securitygroup"
  vpc_id = module.vpc.vpc_id
  name = local.sg_all.sg_name
  ingress_rules = local.sg_all.ingress_rules
  egress_rules = local.sg_all.egress_rules
  
  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag
}

module "sg_bastion" {
  source       = "../../../modules/compute/vpc/securitygroup"
  vpc_id = module.vpc.vpc_id
  name = local.sg_bastion.sg_name
  ingress_rules = local.sg_bastion.ingress_rules
  egress_rules = local.sg_bastion.egress_rules
  
  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag
}

module "sg_gitlab" {
  source       = "../../../modules/compute/vpc/securitygroup"
  vpc_id = module.vpc.vpc_id
  name = local.sg_gitlab.sg_name
  ingress_rules = local.sg_gitlab.ingress_rules
  egress_rules = local.sg_gitlab.egress_rules
  
  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag
}

module "sg_nexus" {
  source       = "../../../modules/compute/vpc/securitygroup"
  vpc_id = module.vpc.vpc_id
  name = local.sg_nexus.sg_name
  ingress_rules = local.sg_nexus.ingress_rules
  egress_rules = local.sg_nexus.egress_rules
  
  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag
}
module "sg_db" {
  source       = "../../../modules/compute/vpc/securitygroup"
  vpc_id = module.vpc.vpc_id
  name = local.sg_db.sg_name
  ingress_rules = local.sg_db.ingress_rules
  egress_rules = local.sg_db.egress_rules
  
  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag
}
module "sg_alb" {
  source       = "../../../modules/compute/vpc/securitygroup"
  vpc_id = module.vpc.vpc_id
  name = local.sg_alb.sg_name
  ingress_rules = local.sg_alb.ingress_rules
  egress_rules = local.sg_alb.egress_rules
  
  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag
}
