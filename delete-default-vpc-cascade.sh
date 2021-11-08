# get default vpc
vpc=$(aws ec2 --region us-east-1 \
  describe-vpcs --filter Name=isDefault,Values=true \
  | jq -r .Vpcs[0].VpcId)
if [ "${vpc}" = "null" ]; then
  echo "No default vpc found"
  continue
fi
echo "Found default vpc ${vpc}"

# get internet gateway
igw=$(aws ec2 --region us-east-1 \
  describe-internet-gateways --filter Name=attachment.vpc-id,Values=${vpc} \
  | jq -r .InternetGateways[0].InternetGatewayId)
if [ "${igw}" != "null" ]; then
  echo "Detaching and deleting internet gateway ${igw}"
  aws ec2 --region us-east-1 \
    detach-internet-gateway --internet-gateway-id ${igw} --vpc-id ${vpc}
  aws ec2 --region us-east-1 \
    delete-internet-gateway --internet-gateway-id ${igw}
fi

# get subnets
subnets=$(aws ec2 --region us-east-1 \
  describe-subnets --filters Name=vpc-id,Values=${vpc} \
  | jq -r .Subnets[].SubnetId)
if [ "${subnets}" != "null" ]; then
  for subnet in ${subnets}; do
    echo "Deleting subnet ${subnet}"
    aws ec2 --region us-east-1 \
      delete-subnet --subnet-id ${subnet}
  done
fi

# https://docs.aws.amazon.com/cli/latest/reference/ec2/delete-vpc.html
# - You can't delete the main route table
# - You can't delete the default network acl
# - You can't delete the default security group

# delete default vpc
echo "Deleting vpc ${vpc}"
aws ec2 --region us-east-1 \
  delete-vpc --vpc-id ${vpc}