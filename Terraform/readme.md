## Terraform 
---------------------------------------------------------------------------------------

### SUMMARY

This terraform code creates high availability infrastructure for simle web-application in AWS.
There are internet-facing application load balancer with two listeners (http listener redirect to 
https listener), autoscalling group which is triggered by cloudwatch alarm (alarm type - request 
per target) and has two autoscalling policy: adding instance to target group (when cloudwatch 
alarm in alarm state), and deleting instance from the target group, when alarm state is OK.
For database storage were chosen RDS mysql, which is located in private subnet and db subnet group
consists of two private subnets (one per availability zone) Autoscalling group ups their
instances in two private subnets (one per availability zone).

