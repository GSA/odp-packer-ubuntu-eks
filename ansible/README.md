# Test ansible playbook on desired AMI

It is always good to test/debug your ansible playbook on desired EC2 

**BEFORE you run ansible within packer build or CI/CD**:

Launch an EC2 using AWS maintained Amazon EKS optimized Amazon Linux AMIs, ami id can be found here: https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html

ssh to the EC2:

```bash
EC2_PEM="/path-to-your-pem-file"
EC2_USER="ec2-user"
EC2_IP="111.111.111.111"
echo EC2_PEM="${EC2_PEM}", EC2_USER="${EC2_USER}", EC2_IP="${EC2_IP}" && ssh -i ${EC2_PEM} ${EC2_USER}@${EC2_IP}
```

Prepare ansible playbook variables:

In CI environment, it pulls variables from json file from S3 bucket. To test it on Non-CI environment, you can create var file manually for testing.

```bash
# create var file, the file name is imporatant
vi playbook-var-file.json
```
Copy and fill in the content:

```
{
    "fireeye_cacert": "a-base64-encoded-token",
    "fireeye_provocert": "a-base64-encoded-token",
    "fireeye_provokey": "a-base64-encoded-token",
    "fireeye_servers": [ "111.111.111.111", "111.111.111.111" ],
    "fireeye_package": "xagt-32.30.0-1.el7.x86_64.rpm",
    "fireeye_s3_bucket": "bucket-name",
    "fireeye_s3_prefix": "artifacts-s3-dir-path",
    "cylance_zone": "",
    "cylance_token": "a-token",
    "cylance_version": "CylancePROTECT.amzn2.rpm",
    "cylance_s3_bucket": "bucket-name",
    "cylance_s3_prefix": "artifacts-s3-dir-path",
    "nessus_agent_key": "a-token",
    "nessus_server_url": "nm02.sec.helix.gsa.gov",
    "redhat_nessus_agent_artifacts_s3_bucket": "bucket-name",
    "redhat_nessus_agent_artifacts_s3_key": "/rpm/NessusAgent-8.0.0-amzn.x86_64.rpm"
}
```

Run ansible playbook on EC2 localhost:

```bash
# Install dependencies
# install git
sudo yum install git -y
# install ansible
sudo amazon-linux-extras install epel -y
sudo yum install ansible -y

# clone code and run playbook
git clone https://github.com/GSA/odp-packer-amazon-linux2-eks.git
# or
git clone https://github.com/GSA/odp-packer-amazon-linux2-eks.git --branch ${your_git_branch_name}
cd odp-packer-amazon-linux2-eks/ansible
git pull && bash ./run-playbook.sh
```
