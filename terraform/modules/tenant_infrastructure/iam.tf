# Only for test that artifacts can be loaded to S3
data "aws_iam_policy_document" "external_storage" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [
        aws_iam_role.irsa_iam_role["${var.tenant_name}-server"].arn,
        "arn:aws:iam::912773405367:user/nkondrashova"
      ]
    }
  }
}

resource "aws_iam_role" "temp_role" {
  name               = "temp-role-for-s3-storage"
  assume_role_policy = data.aws_iam_policy_document.external_storage.json
  description        = "temp role for testing teamcity external storage"
}

resource "aws_iam_role_policy_attachment" "temp" {
  policy_arn = aws_iam_policy.tc_server.arn
  role       = aws_iam_role.temp_role.name
}