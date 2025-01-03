resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(
    var.common_tags,
    {
      Name = "main_vpc"
    }
  )
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(
    var.common_tags,
    {
      Name = "main_igw"
    }
  )
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "main_public_rt"
    }
  )
}

resource "aws_subnet" "public_subnet" {
  count                   = var.number_of_public_subnets
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  map_public_ip_on_launch = true
  tags = merge(
    var.common_tags,
    {
      Name = "main_public_subnet_${count.index}"
    }
  )
}

resource "aws_route_table_association" "public_rt_association" {
  count          = var.number_of_public_subnets
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "private_subnet" {
  count             = var.number_of_private_subnets
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidr_block[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  tags = merge(
    var.common_tags,
    {
      Name = "main_private_subnet_${count.index}"
    }
  )

}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id
  tags = merge(
    var.common_tags,
    {
      Name = "main_private_rt"
    }
  )
}

resource "aws_route_table_association" "private_rt_association" {
  count          = var.number_of_private_subnets
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}


resource "aws_nat_gateway" "nat" {
  count         = var.number_of_natgateways
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  tags = merge(
    var.common_tags,
    {
      Name = "main_nat_${count.index}"
    }
  )
}

resource "aws_eip" "nat" {
  count = var.number_elastic_ips
  tags = merge(
    var.common_tags,
    {
      Name = "main_nat_eip_${count.index}"
    }
  )
}

resource "aws_flow_log" "vpc_flow_log" {
  log_destination = aws_cloudwatch_log_group.main_cloudwatch_log.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main_vpc.id
  iam_role_arn    = aws_iam_role.vpc_flow_logs_role.arn

  tags = merge(
    var.common_tags,
    {
      Name = "vpc_flow_log"
    }
  )
}

resource "aws_cloudwatch_log_group" "main_cloudwatch_log" {
  name              = "main_cloudwatch_log"
  retention_in_days = 7

  tags = merge(
    var.common_tags,
    {
      Name = "main_cloudwatch_log"
    }
  )
}

resource "aws_iam_role" "vpc_flow_logs_role" {
  name               = var.vpc_flow_logs_role_name
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
}



data "aws_iam_policy_document" "trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "vpc_flow_logs_policy" {
  statement {
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.flow_logs_bucket.arn}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["AES256"]
    }
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "vpc_flow_logs_role_policy" {
  name   = "vpc_flow_logs_role_policy"
  role   = aws_iam_role.vpc_flow_logs_role.id
  policy = data.aws_iam_policy_document.vpc_flow_logs_policy.json
}

resource "aws_s3_bucket" "flow_logs_bucket" {
  bucket = var.s3_bucket_name

  tags = merge(
    var.common_tags,
    {
      Name = "flow_logs_bucket"
    }
  )
}

resource "aws_s3_bucket_versioning" "versioning_configuration" {
  bucket = aws_s3_bucket.flow_logs_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "server_side_encryption_configuration" {
  bucket = aws_s3_bucket.flow_logs_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.flow_logs_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_flow_log" "vpc_flow_log_s3" {
  log_destination      = aws_s3_bucket.flow_logs_bucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main_vpc.id
  iam_role_arn         = aws_iam_role.vpc_flow_logs_role.arn

  tags = merge(
    var.common_tags,
    {
      Name = "vpc_flow_log_s3"
    }
  )
}

data "aws_iam_policy_document" "flow_logs_bucket_policy" {
  statement {
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.flow_logs_bucket.arn}/*"]
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["AES256"]
    }
  }

  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.vpc_flow_logs_role_name}"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.flow_logs_bucket.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "flow_logs_bucket_policy" {
  bucket = aws_s3_bucket.flow_logs_bucket.id
  policy = data.aws_iam_policy_document.flow_logs_bucket_policy.json
}
