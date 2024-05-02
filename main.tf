locals {
  tag_name = var.use_locals ? "forum" : var.bucket_name
}

module "course" {
    source = "./modules/dynamodb/eu-central-1"
    name = "courses"
    table_name = "courses-table"
    hash_key = "courses-id"
}

module "author" {
    source = "./modules/dynamodb/eu-central-1"
    name = "authors"
    table_name = "authors-table"
    hash_key = "authors-id"
}

module "iam" {
  source                = "./modules/iam"
  name                  = "iam"
  dynamodb_authors_arn = module.author.dynamodb_arn
  dynamodb_courses_arn = module.course.dynamodb_arn
}

module "lambda" {
    source = "./modules/lambda"
    name   = "lambda"
    stage  = "dev"

    get_all_authors_arn = module.iam.get_all_authors_role_arn
    save_course_arn     = module.iam.save_course_role_arn
    update_course_arn   = module.iam.update_course_role_arn
    get_all_courses_arn = module.iam.get_all_courses_role_arn
    get_one_course_arn  = module.iam.get_one_course_role_arn
    delete_course_arn   = module.iam.delete_course_role_arn
}

module "api" {
    source = "./modules/api"
    region = "eu-central-1"
    name = "my-million-api"
    myprofile = var.myprofile

    get_all_authors_invoke_arn = module.lambda.get_all_authors_invoke_arn
    get_all_authors_arn = module.lambda.get_all_authors_arn
    get_all_courses_invoke_arn = module.lambda.get_all_courses_invoke_arn
    get_all_courses_arn = module.lambda.get_all_courses_arn
    save_course_arn = module.lambda.save_course_arn
    save_course_invoke_arn = module.lambda.save_course_invoke_arn
    get_one_course_arn = module.lambda.get_one_course_arn
    get_one_course_invoke_arn = module.lambda.get_one_course_invoke_arn
    delete_course_arn = module.lambda.delete_course_arn
    delete_course_invoke_arn = module.lambda.delete_course_invoke_arn
    update_course_arn = module.lambda.update_course_arn
    update_course_invoke_arn = module.lambda.update_course_invoke_arn
}

# module "s3-bucket" {
#   source  = "terraform-aws-modules/s3-bucket/aws"
#   version = "4.1.2"
# }