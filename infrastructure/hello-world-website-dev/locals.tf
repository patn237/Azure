locals {
  az_region = "northcentralus"

  environment = "dev"

  application = "hello-world"


  usa_region_shortname = {
    centralus       = "cus"
    eastus          = "eus"
    eastus2         = "eus2"
    eastus3         = "eus3"
    westcentralus   = "wcus"
    westus          = "wus"
    westus2         = "wus2"
    westus3         = "wus3"
    northcentralus  = "ncus"
    sourthcentralus = "scus"
  }

  usa_regional_pair = {
    eastus         = "westus",
    eastus2        = "centralus",
    northcentralus = "southcentralus",
    westus2        = "westcentralus",
    westus3        = "eastus",
    westus         = "eastus",
    centralus      = "eastus2",
    southcentralus = "northcentralus",
    westcentralus  = "westus2",
  }

  region_short_name = lookup(local.usa_region_shortname, local.az_region, "")

  resource_names = lower(join("-", [local.application, local.environment, local.region_short_name]))

  tags = {
    Environment = title(local.environment)
    Application = title(local.application)
    Terraformed = "true"
  }
}
