import boto3
import os

def lambda_handler(event, context):
    iam = boto3.client('iam')
    username = os.environ['IAM_USERNAME']

    # List existing access keys
    response = iam.list_access_keys(UserName=username)
    access_keys = response['AccessKeyMetadata']

    # Create new access key
    new_key = iam.create_access_key(UserName=username)['AccessKey']
    print(f"Created new key: {new_key['AccessKeyId']}")

    # Store keys in Secrets Manager (optional)
    if 'SECRETS_MANAGER_ARN' in os.environ:
        secretsmanager = boto3.client('secretsmanager')
        secretsmanager.put_secret_value(
            SecretId=os.environ['SECRETS_MANAGER_ARN'],
            SecretString=str({
                'AWS_ACCESS_KEY_ID': new_key['AccessKeyId'],
                'AWS_SECRET_ACCESS_KEY': new_key['SecretAccessKey']
            })
        )
        print("Stored keys in Secrets Manager")

    # Delete old keys (excluding the new one)
    for key in access_keys:
        if key['AccessKeyId'] != new_key['AccessKeyId']:
            iam.delete_access_key(UserName=username, AccessKeyId=key['AccessKeyId'])
            print(f"Deleted old key: {key['AccessKeyId']}")

    return {
        'statusCode': 200,
        'body': 'Access key rotated successfully.'
    }
