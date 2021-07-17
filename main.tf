# --- root/main.tf ---

module "networking" {
  source       = "./networking"
  vpc_cidr     = "10.0.0.0/16"
  public_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
}

module "compute" {
  source        = "./compute"
  web_sg        = module.networking.web_sg
  public_subnet = module.networking.public_subnet
}