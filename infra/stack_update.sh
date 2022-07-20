if [ `aws cloudformation describe-stacks --stack-name nodejs | grep -e StackName |wc -l` -eq 1 ]; then cmd='update-stack'; else cmd='create-stack'; fi
aws cloudformation $cmd --stack-name nodejs --template-body file://infra/nodejs.yml --capabilities CAPABILITY_NAMED_IAM
status=`aws cloudformation describe-stacks --stack-name nodejs | grep \"StackStatus\": | awk '{print $2}'|cut -d\" -f2`
while [[ $status != "CREATE_COMPLETE" ]] && [[ $status != "UPDATE_COMPLETE" ]] && [[ $status != "UPDATE_ROLLBACK_COMPLETE" ]]
do
        sleep 20
  status=`aws cloudformation describe-stacks --stack-name nodejs | grep \"StackStatus\": | awk '{print $2}'|cut -d\" -f2`
  echo "...................."
done
