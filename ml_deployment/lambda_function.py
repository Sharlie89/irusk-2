import json
import boto3
import joblib
import numpy as np

s3_client = boto3.client('s3')

# Model load
model = joblib.load('/mnt/model/iris_model.joblib')

def lambda_handler(event, context):
    data = json.loads(event['body'])
    
    # Predict
    features = np.array(data['features']).reshape(1, -1)
    prediction = model.predict(features).tolist()
    species = data['species_names'][prediction[0]]
    
    # Store prediction in S3
    bucket_name = 'ml-results'
    file_name = f"predictions/{context.aws_request_id}.json"
    prediction_data = json.dumps({'prediction': species})
    
    s3_client.put_object(Body=prediction_data, Bucket=bucket_name, Key=file_name)
    
    # Generate URL to JSON file
    url = f"https://{bucket_name}.s3.amazonaws.com/{file_name}"
    
    # Return URL to user
    return {
        'statusCode': 200,
        'body': json.dumps({'url': url})
    }

