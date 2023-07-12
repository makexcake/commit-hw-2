import boto3

def stop_scheduled_instances():
    
    # This function stops all EC2 instances with the tag "scheduled" set to "true".
    
    # Get instances with the scheduled tag's value set to "true"
    ec2 = boto3.client('ec2')
    instances = ec2.describe_instances(Filters=[{
        'Name': 'tag:scheduled',
        'Values': ["true"]
    }])

    # Stop the instances with the tag
    for instance in instances['Reservations'][0]['Instances']:
        instance_id = instance['InstanceId']
        ec2.stop_instances(InstanceIds=[instance_id])
    
    

def lambda_handler(event, context):
    
    stop_scheduled_instances()

lambda_handler(1,1)