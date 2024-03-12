module "course" {
    source = "./modules/dynamodb/eu-central-1"
    name = "this"
    table_name = "courses"
    hash_key = "courses-id"
}

module "author" {
    source = "./modules/dynamodb/eu-central-1"
    name = "this"
    table_name = "authors"
    hash_key = "authors-id"
}
