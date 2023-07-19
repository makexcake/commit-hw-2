import boto3

def stop_scheduled_instances():
    
    # This function stops all EC2 instances with the tag "scheduled" set to "true".
    
    # Get running instances with the tag "scheduled" = "true"
    ec2 = boto3.client('ec2')
    instances = ec2.describe_instances(Filters=[{
        'Name': 'tag:scheduled',
        'Values': ["true"]
    },
    {
        "Name": "instance-state-name",
        "Values": ["running"],
    }])

    # Check if there are instances in the list
    if len(instances['Reservations']) > 0:
        # Stop the instances 
        for reservation in instances['Reservations']:
            for instance in reservation['Instances']:
                instance_id = instance['InstanceId']
                ec2.stop_instances(InstanceIds=[instance_id])
    
    
def lambda_handler(event, context):
    
    stop_scheduled_instances()



