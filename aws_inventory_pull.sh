#!/bin/bash

Date=$(date +%F)
Subject="Inventory For Dev Servers"

echo 'Name,intl_platform,aws:autoscaling:groupName,lm_app_env,WEM_OS,lm_troux_uid,intl_country,lm_app,intl_service,intl_region,aws:cloudformation:stack-name,aws:cloudformation:groupName,Instance_id,State,Instance_Type,Private IP Address,KeyName,LaunchTime,Platform,' > Dev_Inventory.csv

aws ec2 describe-instances --region eu-west-1 --query 'Reservations[].Instances[].[join(`,`,Tags[?Key==`Name`].Value),join(`,`,Tags[?Key==`intl_platform`].Value),join(`,`,Tags[?Key==`aws:autoscaling:groupName`].Value),join(`,`,Tags[?Key==`lm_app_env`].Value),join(`,`,Tags[?Key==`WEM_OS`].Value),join(`,`,Tags[?Key==`lm_troux_uid`].Value),join(`,`,Tags[?Key==`intl_country`].Value),join(`,`,Tags[?Key==`lm_app`].Value),join(`,`,Tags[?Key==`intl_service`].Value),join(`,`,Tags[?Key==`intl_region`].Value),join(`,`,Tags[?Key==`aws:cloudformation:stack-name`].Value),join(`,`,Tags[?Key==`aws:cloudformation:groupName`].Value),InstanceId,State.Name,InstanceType,PrivateIpAddress,KeyName,LaunchTime,Platform]' --output text | sed 's|\t|,|g' >> Dev_Inventory.csv

if [ $? -eq 0 ]
then
    echo " Please find the attached Dev inventory as on $Date " | mail -s '$Subject on $Date' -a Dev_Inventory.csv -r mail@capgemini.com mail@capgemini.com
fi
