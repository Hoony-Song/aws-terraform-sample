
   //가용영역 
  region_a = 0
  region_c = 1

  backend_bucket = "hoony-terra-test"
  backend_dynamodb = "dydb-lock"

  //instance hostname 
  gitlab_hostname = "tobe-gitlab"
  nexus_hostname = "tobe-nexus"  
  bastion_hostname = "tobe-bastion"

  //instance type 
  eks_inst_type = ["t3a.2xlarge","m6i.2xlarge"]
  gitlab_inst_type = "t3a.xlarge"
  nexus_inst_type = "t3a.xlarge"
  bastion_inst_type = "t3a.large"
  rds_inst_type = "db.t4g.large" 

  //ssh-Key
  default_Key = "hoony-test"

  //default password
  default_password = "Tobe1234"

  //instance에 사용 될 ami 목록  
  default_ami = "ami-04341a215040f91bb"   //ubuntu 18.04

  //userdata
  scripts_path = "../../common/scripts"
  json_path = "../../common/jsonfile"
  manifest_path = "../../common/manifests"
  user_templats_path = "../../common/user_templats"

  // Route53 record type
  record_type = "A"

  // route53 host name
  host_name = "hoony.shop"
  host_pattern = "*.hoony.shop"
  ACCOUNT_ID = 530406784682
  availability_zones = "ap-northeast-2"


  //domain 
  gitlab_domain_name = "gitlab.hoony.shop"
  nexus_domain_name = "nexus.hoony.shop"
  reg_domain_name = "reg.hoony.shop"

  //instance ip
  gitlab_ip = "10.0.128.254"
  nexus_ip = "10.0.192.254"
  bastion_ip = "10.0.0.254"

// default Prefix name 
  prefix_name = {
    Owner = "tobe"
  }

  //default Tag
  resource_tag= {
    Type = "install"
    Project = "nexacro-deploy"
    Owner = "tobesoft"
  }

  //port 
  ssh_port = 22
  HTTP_port = 80
  HTTPS_port = 443

  //protocol  
  protocol_tcp = "TCP"
  protocol_http = "HTTP"
  protocol_https = "HTTPS"

  //elb 구성요소
  target_type_inst = "instance"
  target_type_alb = "alb"
  load_balancer_type_net = "network"
  load_balancer_type_app = "application"

  
