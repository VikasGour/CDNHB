#!/bin/bash
 
#image_file=$(find . -name "*tar")
 
# load image into local (jump point) docker
#docker image load -i "$image_file"
 
# get image id of loaded docker image
image_id=$1
 
# login to ecr (jump point needs the appropriate IAM permissions via ec2 instance role/access keys)
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin "784190227945.dkr.ecr.us-west-2.amazonaws.com"
 
# push loaded docker image to ecr
docker tag "nodename:nodejs-jenkins-CIFORNHB-${image_id}" "784190227945.dkr.ecr.us-west-2.amazonaws.com/nhb:nodejs-jenkins-CIFORNHB-latest"
docker push "784190227945.dkr.ecr.us-west-2.amazonaws.com/nhb:nodejs-jenkins-CIFORNHB-latest"
 
# update ecs service with new image (jump point needs appropriate iam permissions)
#aws ecs update-service --cluster "$ecs_cluster_name" --service "$ecs_service_name" --force-new-deployment

aws ecs update-service \
    --region "us-west-2" \
    --cluster "Dev" \
    --service "Nodejs" \
    --task-definition "nginx" \
    --force-new-deployment \
    --output json
