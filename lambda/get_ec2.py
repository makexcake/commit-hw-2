import boto3

def list_instances():

    all_instances_ids = []

    ec2 = boto3.client('ec2')
    instances = ec2.describe_instances(Filters=[{
        'Name': 'tag:scheduled',
        'Values': ["true"]
    }])

    #print (instances)

    for instance in instances['Reservations'][0]['Instances']:
        instance_id = instance['InstanceId']
        all_instances_ids.append(instance_id)
        #print (instance_id)
    
    print (len(all_instances_ids))

list_instances()
