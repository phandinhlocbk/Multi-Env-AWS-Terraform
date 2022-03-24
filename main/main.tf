#-----root/main.tf-----



module "networking" {
  source                   = "../modules/networking"
  test_vpc_cidr_block      = "172.32.0.0/16"
  public_sn_count          = 2
  private_sn_count         = 2
  test_public_subnet_cidr  = ["172.32.2.0/24", "172.32.4.0/32"]
  test_private_subnet_cidr = ["172.32.1.0/24", "172.32.3.0/32"]
  security_groups          = local.security_groups
  test_nat_gateway_id      = module.interfacing.test_nat_gateway
}

module "loadbalancing" {
  source            = "../modules/loadbalancing"
  public_sg         = module.networking.public_sg
  public_subnets    = module.networking.public_subnets
  tg_port           = 80
  tg_protocol       = "http"
  vpc_id            = module.networking.vpc_id
  listener_port     = 80
  listener_protocol = "http"

}

module "compute" {
  source                 = "../modules/compute"
  private_instance_count = 2
  private_instance_type  = var.private_instance_type
  private_sg             = module.networking.private_sg
  private_subnets        = module.networking.private_subnets
  private_volume_size    = 8
  user_data_path         = "${path.root}/userdata.tpl"

  #----------------------
  public_instance_count = 1
  public_instance_type  = "t2.micro"
  public_sg             = module.networking.public_sg
  public_subnets        = module.networking.public_subnets
  public_volume_size    = 8


}

#---------------------------nat gateway

module "interfacing" {
  source           = "../modules/interfacing"
  public_sn_count  = 2
  public_subnet_id = module.networking.public_subnets
}
