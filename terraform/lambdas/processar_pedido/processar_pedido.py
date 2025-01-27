import boto3
import json
import os
import base64


eventbridge = boto3.client('events')


EVENT_BUS_NAME = os.getenv('EVENT_BUS_NAME', 'EcommerceEventBus')

def lambda_handler(event, context):
    for record in event['Records']:
       
        decoded_data = base64.b64decode(record['kinesis']['data']).decode('utf-8')
        

        payload = json.loads(decoded_data)
        print(f"Processando evento: {payload}")


        response = eventbridge.put_events(
            Entries=[
                {
                    'Source': 'ecommerce.pedidos',
                    'DetailType': 'Novo Pedido Criado',
                    'Detail': json.dumps(payload),
                    'EventBusName': EVENT_BUS_NAME
                }
            ]
        )
        print(f"Evento publicado no EventBridge: {response}")

    return {"statusCode": 200, "body": "Eventos processados com sucesso"}
