/*resource "aws_ecrpublic_repository" "ecr_repo" {
  repository_name = "${var.prefix}-repo"
}*/

resource "aws_ecr_repository" "ecr_repo" {
  name = "${var.prefix}-repo"
}