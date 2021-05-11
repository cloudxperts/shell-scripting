import boto3
def lambda_handler(event, context):

    value = list_instances_by_tag_value("intl_scheduler_id","1")
    print(value)
 

def list_instances_by_tag_value(tagkey,tagvalue):
    # When passed a tag key, tag value this will return a list of InstanceIds that were found.
 
    ec2client = boto3.client('ec2')
 
    response = ec2client.describe_instances(
        Filters=[
            {
                'Name': 'tag:'+tagkey,
                'Values': [tagvalue]
            }
        ]
    )
    instancelist = []
    for reservation in (response["Reservations"]):
        for instance in reservation["Instances"]:
            name = ""
            scheduler_value = ""
            for instancetag in instance['Tags']:
                # instancelist.append(instancetag)
                if instancetag['Key'] == 'Name':
                    name = instancetag['Value']
                if instancetag['Key'] == 'intl_scheduler':
                    scheduler_value = instancetag['Value']
					
            instancelist.append({​​​​"Server_name": name, "SDT_scheduler_value": scheduler_value }​​​​)\

    return instancelist
