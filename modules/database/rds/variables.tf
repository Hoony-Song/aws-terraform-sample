//rds 생성시 필요한 변수 목록 

//rds이름 
variable "name" {
  type = string
  default = "unknown"
}

variable "prefix_name" {
  type = string
  default = "unknown"
}

variable "rds_region" {
  type = number
}

//db 종류 
variable "rds_engine" {
    type = string
}

//db 버전 
 variable "rds_engine_version" {
    type = string
    }

    //기본 관리자 id 
 variable "rds_username" {
    type = string
    default = "admin"
   }

   //기본 관리자 패스워드
 variable "rds_password" {
    type = string
    default = "admin1234"
   }

   //parameter_group
 variable "rds_parameter_group_name" {
    type = string
   }

   //db 기본 용량
 variable "rds_vol_allocated_size" {
    type = number
    default = 30
   }

   //db 용량 최대 임계값
 variable "rds_vol_max_allocated_size" {
    type = number
    default = 1000
   }

   //db instance type
 variable "rds_inst_type" {
    type = string
    default = "db.t2.micro"
   }

   //SG
 variable "rds_security_group_id" {
  type = string
   }


variable "rds_subnet_ids" {
  type = list
}

//외부access 접근 여부 
variable "rds_public_acces" {
  type = bool
  default = true
}
variable "rds_port" {
  type = number
}


//디폴트 태그 
variable "tags" { 
  type = map(string)
}

// name tag

