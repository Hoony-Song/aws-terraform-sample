
locals {
    
  smtp_user_name = "tobe-smtp"
  smtp_policy_name = "smtp-send-mail"

}

module "smtp_user" {
  source = "../../../modules/iam/user/iam_user"
  user_name = local.smtp_user_name

  tags = var.resource_tag
}

module "ses_sender_policy" {
  source = "../../../modules/iam/policy"
  name = local.smtp_policy_name
  jsonPath = "../../common/jsonFile/policy/ses_sender.json"
  
  tags = var.resource_tag
}

module "user_policy_attach" {
  source = "../../../modules/iam/user/iam_user_attach"
  user_name = local.smtp_user_name
  policy_arn = module.ses_sender_policy.policy_arn
  depends_on = [ module.smtp_user ]
}

