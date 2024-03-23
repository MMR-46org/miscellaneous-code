aws elbv2 describe-load-balancers  --load-balancer-arn $(aws elbv2 describe-load-balancers | grep LoadBalancerArn | grep tools | awk '{print $2}' | sed -e 's/,//' | xargs)
