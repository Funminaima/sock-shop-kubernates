terraform {
    backend "s3" {
        bucket = "sock-shop-bucket-10-08-2024"
        key = "aws-cluster/terraform.tfstate"
        region = "eu-west-2"
      
    }
}