resource "aws_db_instance" "my-rds-sql-db" {
  instance_class = "${var.db_instance}"
  engine = var.rds_db_engine
  engine_version = var.rds_db_engine_version
  storage_type = var.rds_db_storage_type
  allocated_storage = 20
  identifier = var.rds_db_identifier
  db_name = var.rds_db_name
  username = var.rds_db_username
  password = var.rds_db_password
  apply_immediately = "true"
  availability_zone = var.region_subnet_1_id
  backup_retention_period = 1
  backup_window = "09:46-10:16"
  db_subnet_group_name = "${aws_db_subnet_group.my-rds-db-subnet.name}"
  vpc_security_group_ids = ["${aws_security_group.my-rds-sg.id}"]
}

resource "aws_db_subnet_group" "my-rds-db-subnet" {
  name = "my-rds-db-subnet"
  subnet_ids = ["${var.private_subnet_1_id}","${var.private_subnet_2_id}"]
}

resource "aws_security_group" "my-rds-sg" {
  name = "my-rds-sg"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "my-rds-sg-rule" {
  from_port = 3306
  protocol = "tcp"
  security_group_id = "${aws_security_group.my-rds-sg.id}"
  to_port = 3306
  type = "ingress"
  cidr_blocks = [var.all_ips_cidr]
}

resource "aws_security_group_rule" "outbound_rule" {
  from_port = 0
  protocol = "-1"
  security_group_id = "${aws_security_group.my-rds-sg.id}"
  to_port = 0
  type = "egress"
  cidr_blocks = [var.all_ips_cidr]
}


resource "aws_db_instance" "my-rds-sql-db_replica" {
  instance_class = "${var.db_instance}"
  replicate_source_db = aws_db_instance.my-rds-sql-db.identifier
  availability_zone = var.region_subnet_2_id
  identifier = "${var.rds_db_identifier}-replica"
  apply_immediately = "true"
  #replica_mode = "open-read-only"
  db_subnet_group_name = "${aws_db_subnet_group.my-rds-db-subnet.name}"
  vpc_security_group_ids = ["${aws_security_group.my-rds-sg.id}"]
}