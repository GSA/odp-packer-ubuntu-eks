# packer-cis-hardened-amz-linux2-eks

This repository uses Packer and Ansible to harden Amazon Linux 2 EKS Enhanced AMI.

## Jenkins Pipeline Configuration

Parameters:

- P1
    - Name = ``git_branch``
    - Default Value = ``main or master``
    - Description = ``the branch you want to use to run your build``
- P2
    - Name = ``s3_uri_packer_var_file``
    - Default Value = ``s3://gsa-is-setup-dev/jenkins/pipelines/odp-packer-amazon-linux2-eks/packer-var-file.json``
    - Description = ``Where your store the packer vars.json file``
- P3
    - Name = ``s3_uri_playbook_var_file``
    - Default Value = ``s3://gsa-is-setup-dev/jenkins/pipelines/odp-packer-amazon-linux2-eks/playbook-var-file.json``
    - Description = ``Where your store the playbook-var-file.json file for ansible``

## About Jenkins Build Runtime

ODP DevSecOps team use Jenkins for CI/CD.

For AMI Build pipeline, we use docker container as a runtime. It is a simple container with ``packer``, ``ansible``, ``terraform``, ``python``, ``awscli``, ``git`` and other common linux tool like ``wget``, ``curl`` installed.

## About Jenkins IAM Role

It requires IAM Policy for these things:

1. Access to ECR to pull and publish docker images
2. Access to EC2 to build AMI
3. Access to S3 to pull artifacts.
4. Access AWS Secret Manager to read sensitive parameters.

**Minmal IAM Policy for Packer**:

From packer website (https://www.packer.io/docs/builders/amazon#iam-task-or-instance-role), it recommends to use this minimal IAM Policy.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AttachVolume",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CopyImage",
                "ec2:CreateImage",
                "ec2:CreateKeypair",
                "ec2:CreateSecurityGroup",
                "ec2:CreateSnapshot",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:DeleteKeyPair",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteSnapshot",
                "ec2:DeleteVolume",
                "ec2:DeregisterImage",
                "ec2:DescribeImageAttribute",
                "ec2:DescribeImages",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeRegions",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSnapshots",
                "ec2:DescribeSubnets",
                "ec2:DescribeTags",
                "ec2:DescribeVolumes",
                "ec2:DetachVolume",
                "ec2:GetPasswordData",
                "ec2:ModifyImageAttribute",
                "ec2:ModifyInstanceAttribute",
                "ec2:ModifySnapshotAttribute",
                "ec2:RegisterImage",
                "ec2:RunInstances",
                "ec2:StopInstances",
                "ec2:TerminateInstances"
            ],
            "Resource": "*"
        }
    ]
}
```

**Minimal IAM Policy for Secret Managers**

We enforce to use naming convention ``sectools-jenkins/pipelines/${pipeline-name}`` for secret names used by jenkins. 

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "secretsmanager:GetSecretValue",
            "Resource": "arn:aws:secretsmanager:us-east-1:${AWS_ACCOUNT_ID}:secret:sectools-jenkins/pipelines/*"
        }
    ]
}
```
