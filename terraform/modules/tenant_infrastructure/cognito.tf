resource "aws_cognito_user_pool" "tenant" {
  name = var.tenant_name

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length                   = 6
    temporary_password_validity_days = 7
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "Account Confirmation"
    email_message        = "Your confirmation code is {####}"
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }
}

resource "aws_cognito_user_pool_client" "tenant" {
  name = var.tenant_name

  user_pool_id    = aws_cognito_user_pool.tenant.id
  generate_secret = true

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["openid"]
  allowed_oauth_flows                  = ["code"]
  prevent_user_existence_errors        = "ENABLED"
  supported_identity_providers         = ["COGNITO"]
  callback_urls                        = ["https://${var.tenant_name}.${data.aws_route53_zone.main.name}/oauth2/idpresponse"]
  explicit_auth_flows = [
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
  ]

  refresh_token_validity = 90
  access_token_validity  = 60
  id_token_validity      = 60
  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
}

resource "aws_cognito_user_pool_domain" "tenant" {
  domain       = "${var.tenant_name}-${random_string.tenant.result}"
  user_pool_id = aws_cognito_user_pool.tenant.id
}
