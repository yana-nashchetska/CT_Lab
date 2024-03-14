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
    name   = "lamda"
    stage  = "dev"

    get_all_authors_arn = module.iam.get_all_authors_role_arn
    save_course_arn     = module.iam.save_course_role_arn
}


