import json
import boto3
import os

# Get the DynamoDB table name from environment variables
TABLE_NAME = os.environ.get('TABLE_NAME')

# Create a DynamoDB client
dynamodb = boto3.client('dynamodb')

def lambda_handler(event, context):
    # Parse the incoming event data
    data = json.loads(event['body'])

    # Prepare the item to be inserted into DynamoDB
    item = {
        'id': {'S': data['id']},
        'name': {'S': data['name']},
        'age': {'N': str(data['age'])}
    }

    # Write the item to DynamoDB
    response = dynamodb.put_item(
        TableName=TABLE_NAME,
        Item=item
    )

    # Return a success response
    return {
        'statusCode': 200,
        'body': json.dumps('Item inserted successfully!')
    }
