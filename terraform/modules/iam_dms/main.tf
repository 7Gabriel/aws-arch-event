resource "aws_iam_role" "dms_role" {
  name = "dms-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "dms.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "dms_policy" {
  name = "dms-access-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "rds:*",
          "dms:*",
          "logs:*",
          "kinesis:*",
          "s3:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dms_policy_attachment" {
  role       = aws_iam_role.dms_role.name
  policy_arn = aws_iam_policy.dms_policy.arn
}
