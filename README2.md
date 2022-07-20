# How to deploy
> Create codebuild pipleline in aws
> This will create Cloudformation stack to provision ec2, keypair and security group with required rules to run this application
> In post build steps it will deploy the application and start the services
> On successful completetion it will print URL with public IP as http://<IP>:3000, this can be used to access the frontend.
Please note this has small issue with startup process, the script does not return to command prompt so process does not complete. To deploy this application successfully stop codebuild once backend is started and start codebuild process again and in second time it will start frontend as well.

