resource "aws_cloudwatch_event_bus" "ecommerce_bus" {
  name = var.bus_name

}

output "cloudwatch_bus_arn" {
  value = aws_cloudwatch_event_bus.ecommerce_bus.arn
}

resource "aws_cloudwatch_event_rule" "processar_pedido_rule" {
  name        = "ProcessarPedidoEventRule"
  description = "Regra para direcionar eventos do ProcessarPedido para destinos"
  event_bus_name = aws_cloudwatch_event_bus.ecommerce_bus.name
  event_pattern = jsonencode({
    source = ["custom.ProcessarPedido"]
  })
}

resource "aws_cloudwatch_event_target" "processar_pedido_target" {
  rule = aws_cloudwatch_event_rule.processar_pedido_rule.name
  target_id     = "${var.function_name}-event-target"
  arn  = var.target_arn
  event_bus_name = aws_cloudwatch_event_bus.ecommerce_bus.name
}

resource "aws_iam_role" "eventbridge_target_role" {
  name = "eventbridge_target_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "events.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "eventbridge_target_role_policy" {
  name   = "EventBridgeTargetPolicy"
  role   = aws_iam_role.eventbridge_target_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["lambda:InvokeFunction"],
        Resource = var.target_arn
      }
    ]
  })
}

resource "aws_iam_policy" "eventbridge_policy" {
  name = "EventBridgeLambdaPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "events:PutTargets",
          "events:PutRule",
          "events:DescribeRule",
          "events:EnableRule"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "processar_pedido_event_permission" {
  role       = var.lambda_execution_role_name
  policy_arn = aws_iam_policy.eventbridge_policy.arn
}

