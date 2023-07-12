import boto3

def start_scheduled_instances():

    # This function starts all EC2 instances with the tag "scheduled" set to "true".
    
    # Get instances with the "scheduled" tag value set to "true"
    ec2 = boto3.client('ec2')
    instances = ec2.describe_instances(Filters=[{
        'Name': 'tag:scheduled',
        'Values': ["true"]
    }])

    # Start the instances with the tag
    for instance in instances['Reservations'][0]['Instances']:
        instance_id = instance['InstanceId']
        ec2.start_instances(InstanceIds=[instance_id])
        print('signal')

def lambda_handler(event, context):
    
    start_scheduled_instances()

lambda_handler(1,1)