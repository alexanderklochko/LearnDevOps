resource "aws_efs_file_system" "kube" {
  creation_token = "eks-efs"
}

resource "aws_efs_mount_target" "mount" {
    file_system_id = aws_efs_file_system.kube.id
    subnet_id = each.key
    for_each = toset(module.vpc.private_subnets )
    security_groups = [aws_security_group.efs.id]
}