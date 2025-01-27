import boto3
import json
import os


sns = boto3.client('sns')


SNS_TOPIC_ARN = os.getenv('SNS_TOPIC_ARN')

def lambda_handler(event, context):
    for record in event['Records']:
        detail = json.loads(record['body'])
        cliente_email = detail['Email']
        mensagem = f"Olá {detail['ClienteNome']}, seu pedido foi recebido com sucesso!"

        response = sns.publish(
            TopicArn=SNS_TOPIC_ARN,
            Message=mensagem,
            Subject="Confirmação de Pedido"
        )
        print(f"Notificação enviada para {cliente_email}: {response}")

    return {"statusCode": 200, "body": "Notificações enviadas com sucesso"}
