# ***** main.tf ###

resource "aws_vpc" "vpc_ecs" {
  cidr_block   = "10.10.0.0/16"

  tags = {
    Name  = "my-ecs-vpc"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id              = aws_vpc.vpc_ecs.id
  cidr_block          = "10.10.1.0/24"
  availability_zone   = "us-east-1a"

  tags = {
    Name  = "private-sub"
  }
}

resource "aws_ecs_cluster" "blackntech_cluster" {
  name = "blackntech-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.blackntech_cluster.name

  capacity_providers = ["FARGATE"]  # Our Launch type 

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_service" "centos" {
  name            = "centos"
  cluster         = aws_ecs_cluster.blackntech_cluster.id
  task_definition = aws_ecs_task_definition.centos.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = [aws_subnet.private_subnet.id]
  }
}

resource "aws_ecs_task_definition" "centos" {
  family = "centos"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode([
    {
      name      = "centos"
      image     = "centos:8"
      essential = true
      cpu       = 256
      memory    = 512
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}