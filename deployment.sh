hostIP=`aws cloudformation describe-stacks --stack-name nodejs | grep -A 1 PublicIP | grep OutputValue | awk '{print $2}'|cut -d\" -f2`
KeyID=`aws cloudformation describe-stacks --stack-name nodejs | grep -A 1 KeypairID | grep OutputValue | awk '{print $2}'|cut -d\" -f2`
echo $hostIP
echo $KeyID
aws ssm get-parameter --name /ec2/keypair/$KeyID --region us-east-1 --with-decryption | jq -r .Parameter.Value > nodejs.pem
chmod 600 nodejs.pem
#ssh -i "nodejs.pem" -o StrictHostKeyChecking=no ec2-user@$hostIP "ip addr"
ssh -i "nodejs.pem" -o StrictHostKeyChecking=no ec2-user@$hostIP "sudo dnf module install nodejs:14 -y"
##start backend
ssh -i "nodejs.pem" -o StrictHostKeyChecking=no ec2-user@$hostIP "sudo mkdir -p /var/lightfeather-app/backend"
ssh -i "nodejs.pem" -o StrictHostKeyChecking=no ec2-user@$hostIP "sudo chown -R ec2-user /var/lightfeather-app/backend"
sed -i "s/localhost/$hostIP/g" backend/config.js
/usr/bin/rsync -avL -e "ssh -i nodejs.pem" backend/* ec2-user@$hostIP:/var/lightfeather-app/backend/ 
/usr/bin/scp -i "nodejs.pem" startup/backend-start.sh ec2-user@$hostIP:/var/lightfeather-app/backend/
ssh -i "nodejs.pem" -o StrictHostKeyChecking=no ec2-user@$hostIP "sudo chmod +x /var/lightfeather-app/backend/backend-start.sh && sh /var/lightfeather-app/backend/backend-start.sh"
##start front-end
ssh -i "nodejs.pem" -o StrictHostKeyChecking=no ec2-user@$hostIP "sudo mkdir -p /var/lightfeather-app/frontend"
ssh -i "nodejs.pem" -o StrictHostKeyChecking=no ec2-user@$hostIP "sudo chown -R ec2-user /var/lightfeather-app/frontend"
sed -i "s/localhost/$hostIP/g" frontend/src/config.js
/usr/bin/rsync -avL -e "ssh -i nodejs.pem" frontend/* ec2-user@$hostIP:/var/lightfeather-app/frontend/
/usr/bin/scp -i "nodejs.pem" startup/frontend-start.sh ec2-user@$hostIP:/var/lightfeather-app/frontend/
ssh -i "nodejs.pem" -o StrictHostKeyChecking=no ec2-user@$hostIP "sudo chmod +x /var/lightfeather-app/frontend/frontend-start.sh && sh /var/lightfeather-app/frontend/frontend-start.sh"

echo "deployment successful"
echo "http://$hostIP:3000"
