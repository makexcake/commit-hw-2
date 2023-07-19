import boto3

def start_scheduled_instances():

    # This function starts all EC2 instances with the tag "scheduled" set to "true".
    
    # Get stopped instances with the "scheduled" tag value set to "true"
    ec2 = boto3.client('ec2')
    instances = ec2.describe_instances(Filters=[{
        'Name': 'tag:scheduled',
        'Values': ["true"]
    },
    {
        "Name": "instance-state-name",
        "Values": ["stopped"],
    }])

    # Check if there are instances in the list
    if len(instances['Reservations']) > 0:
        # Start the instances 
        for reservation in instances['Reservations']:
            for instance in reservation['Instances']:
                instance_id = instance['InstanceId']
                ec2.start_instances(InstanceIds=[instance_id])


def lambda_handler(event, context):
    
    start_scheduled_instances()



