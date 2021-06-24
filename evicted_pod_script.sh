#!/bin/bash

EVICTED_POD_COUNT=`kubectl get pods --all-namespaces | grep -w 'Evicted' | wc -l`

EVICTED_POD_DELETION_DATE_TIME=$(date +%F_%H%M)

if [ $EVICTED_POD_COUNT -ge 1 ]
then
   echo "Storing the evicted pod information in evicted_pod_${EVICTED_POD_DELETION_DATE_TIME}.csv file"
   kubect get pods --all-namespaces | grep -wE 'Evicted|NAMESPACE' | tr -s " " "," > /var/evicted_pod_info/evicted_pod_${EVICTED_POD_DELETION_DATE_TIME}.csv
   echo "Removing all the evicted pod from cluster"
   
   for namespace in $(kubectl get namespace | grep -a 'Active' | grep -v kube-system | awk '{print $1}')
   do
      kubect delete pod --namespace $namespace $(kubect get pods --namespace $namespace | grep -w 'Evicted' | awk '{print $1}' )

      if [ $? -eq 0 ]
      then 
         echo "Script executed successfully"
         exit 0
      else
         echo "Script executed with error."
         exit 1
      fi
   done
    
else
   echo "Pods Evicted: $EVICTED_POD_COUNT"
   echo "No Action Needed."
fi
