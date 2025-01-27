import boto3
import json
import os


dynamodb = boto3.resource('dynamodb')

TABLE_NAME = os.getenv('TABLE_NAME', 'Inventario')


def lambda_handler(event, context):
    table = dynamodb.Table(TABLE_NAME)
    for record in event['Records']:
        detail = json.loads(record('body'))
        produto_id = detail['ProdutoID']
        quantidade = detail['Quantidade']

        response = table.update_item(
            Key={'ProdutoID': produto_id},
            UpdateExpression="SET Quantidade = Quantidade - :qtd",
            ExpressionAttributeValues={':qtd': quantidade},
            ConditionExpression="Quantidade >= :qtd",
        )
        print(f"Estoque atualizado para ProdutoID {produto_id}: {response}")
    
    return {"statusCode": 200, "body": "Estoque atualizado com sucesso"}

