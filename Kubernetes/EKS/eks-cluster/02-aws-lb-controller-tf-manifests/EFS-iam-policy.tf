# Datasource: EFS Controller IAM Policy get from aws-load-balancer-controller/ GIT Repo (latest)

data "http" "EFS_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/v1.2.0/docs/iam-policy-example.json"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}

# Resource: Create AWS EFS Controller IAM Policy 
resource "aws_iam_policy" "EFS_iam_policy" {
  name        = "${var.environment}-EFSControllerIAMPolicy"
  path        = "/"
  description = "EFS Controller IAM Policy"
  policy      = data.http.EFS_iam_policy.body
}

# Associate Load Balanacer Controller IAM Policy to  IAM Role
resource "aws_iam_role_policy_attachment" "EFS_iam_role_policy_attach" {
  policy_arn = aws_iam_policy.EFS_iam_policy.arn
  role       = aws_iam_role.lbc_EFS_iam_role.name
}

# Resource: Create IAM Role 
resource "aws_iam_role" "lbc_EFS_iam_role" {
  name = "${var.environment}-lbc-EFS-iam-role"

  # Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "${data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_arn}"
        }
        Condition = {
          StringEquals = {
            "${data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_extract_from_arn}:aud" : "sts.amazonaws.com",
            "${data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_extract_from_arn}:sub" : "system:serviceaccount:kube-system:efs-csi-controller-sa"
          }
        }
      },
    ]
  })

  tags = {
    tag-key = "EFSControllerIAMPolicy"
  }
}
