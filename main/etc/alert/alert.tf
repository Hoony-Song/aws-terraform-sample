locals {
  sns_topic_name = "user_topic"

  export_data = {
    access_key = module.smtp_user.username
    secret_key = module.smtp_user.secret_key
    password = module.smtp_user.password
   }
   sns_data = {
    ACCOUNT_ID = var.ACCOUNT_ID,
    topic = local.sns_topic_name
   }
}

module "ses" {
  source = "../../../modules/alert/ses"
  host_name = var.host_name
}

module "sns_topic" {
  source = "../../../modules/alert/sns"
  name = local.sns_topic_name
  delivery_policy = "${var.json_path}/policy/sns_topic.json" 
  policy = templatefile("../../common/jsonFile/policy/sns_polish.json.tpl", local.sns_data)
  
  tags = var.resource_tag
}

module "keyoutput" {
  source = "../../../modules/ETC/output_file"
  value = templatefile("${var.user_templats_path}/alert_readme.tpl", local.export_data)
  out_path = "${path.module}/alert_readme.md"
}

