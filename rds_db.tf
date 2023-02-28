resource "aws_db_instance" "my-rds-sql-db" {
  instance_class = "${var.db_instance}"
  engine = "mysql"
  engine_version = "5.7"
  storage_type = "gp2"
  allocated_storage = 20
  identifier = "my-rds-sql-db"
  db_name = "my-rds-sql-db"
  username = "admin"
  password = "admin123"
  apply_immediately = "true"
  availability_zone = var.region_subnet_1_id
  backup_retention_period = 1
  backup_window = "09:46-10:16"
  db_subnet_group_name = "${aws_db_subnet_group.my-rds-db-subnet.name}"
  vpc_security_group_ids = ["${aws_security_group.my-rds-sg.id}"]
}

resource "aws_db_subnet_group" "my-rds-db-subnet" {
  name = "my-rds-db-subnet"
  subnet_ids = ["${aws_subnet.private1.id}","${aws_subnet.private1.id}"]
}

resource "aws_security_group" "my-rds-sg" {
  name = "my-rds-sg"
  vpc_id = "${aws_vpc.myvpc.id}"
}

resource "aws_security_group_rule" "my-rds-sg-rule" {
  from_port = 3306
  protocol = "tcp"
  security_group_id = "${aws_security_group.my-rds-sg.id}"
  to_port = 3306
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_rule" {
  from_port = 0
  protocol = "-1"
  security_group_id = "${aws_security_group.my-rds-sg.id}"
  to_port = 0
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}


resource "aws_db_instance" "my-rds-sql-db_replica" {
  instance_class = "${var.db_instance}"
  replicate_source_db = aws_db_instance.my-rds-sql-db.identifier
  availability_zone = var.region_subnet_2_id
  identifier = "my-rds-sql-db-replica"
  apply_immediately = "true"
  replica_mode = "open-read-only"
  db_subnet_group_name = "${aws_db_subnet_group.my-rds-db-subnet.name}"
  vpc_security_group_ids = ["${aws_security_group.my-rds-sg.id}"]
}