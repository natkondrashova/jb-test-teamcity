resource "aws_db_subnet_group" "this" {
  name       = var.project
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "Subnet group for ${var.project}"
  }
}
