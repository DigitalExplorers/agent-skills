resource "aws_db_instance" "db" {
  engine         = "{{dbEngine}}"
  instance_class = "{{dbInstanceClass}}"
}
