resource "aws_iam_role" "dms_kinesis_access" {
  name = "dms-kinesis-access-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "dms.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dms_kinesis_access_policy" {
  role       = aws_iam_role.dms_kinesis_access.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"
}