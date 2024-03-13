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
