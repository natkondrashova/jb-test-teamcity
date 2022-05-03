resource "random_password" "mysql" {
  length  = 32
  special = false
  lower   = true
  upper   = true
  number  = true
}

# TODO: shared db instance for all tenants
resource "aws_db_instance" "tenant" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0.25"
  instance_class         = "db.t3.micro"
#  name                   = "${var.tenant_name}-${random_string.tenant.result}"
  db_name                = var.tenant_name
  username               = "tc_server"
  password               = random_password.mysql.result
  vpc_security_group_ids = [local.security_group_id]
  db_subnet_group_name   = local.mysql_subnet_group
  skip_final_snapshot    = true
  storage_encrypted      = true
}
