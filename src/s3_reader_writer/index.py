import json
import boto3
import os
from botocore.exceptions import ClientError

# Initialize the S3 client
s3_client = boto3.client('s3')

# Get the bucket name from environment variables
BUCKET_NAME = os.environ.get('BUCKET_NAME')

def lambda_handler(event, context):
    try:
        # Parse the incoming event data
        data = json.loads(event['body'])
        
        # Generate a unique key for the S3 object
        object_key = f"{data['filename']}_{context.aws_request_id}"
        
        # Convert the data to JSON string
        file_content = json.dumps(data['content'])
        
        # Upload the file to S3
        s3_client.put_object(
            Bucket=BUCKET_NAME,
            Key=object_key,
            Body=file_content,
            ContentType='application/json'
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps(f'Successfully uploaded {object_key} to {BUCKET_NAME}')
        }
    
    except ClientError as e:
        print(f"Error uploading to S3: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps('Error uploading to S3')
        }
    
    except KeyError as e:
        print(f"Missing required field: {str(e)}")
        return {
            'statusCode': 400,
            'body': json.dumps('Missing required field in the request')
        }
    
    except Exception as e:
        print(f"Unexpected error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps('An unexpected error occurred')
        }
