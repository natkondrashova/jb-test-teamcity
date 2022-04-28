data "aws_route53_zone" "main" {
  name = var.main_dns_zone
}

resource "aws_route53_zone" "this" {
  name = "${var.project}.${data.aws_route53_zone.main.name}"
}

resource "aws_route53_record" "this" {
  name    = "${var.project}.${data.aws_route53_zone.main.name}"
  type    = "NS"
  ttl     = 300
  zone_id = data.aws_route53_zone.main.id
  records = aws_route53_zone.this.name_servers[*]
}
