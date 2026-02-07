# 1. Specify the version of the AzureRM Provider to use
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=3.39.0"
    }
  }
}

# 2. Configure the AzureRM Provider
provider "azurerm" {
  features {}
}

# 3. Create an Azure Front Door Standard resource
resource "azurerm_cdn_frontdoor_profile" "frontdoor" {
  name                = var.frontdoor_name
  resource_group_name = var.resource_group_name
  sku_name = "Standard_AzureFrontDoor"
}

# 4. Create an Azure Front Door Endpoint for the Front Door instance
resource "azurerm_cdn_frontdoor_endpoint" "frontendEndpoint" {
  name                     = var.frontdoor_endpoint
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id
}

# 5. Create an Azure Front Door Origin Group for Login and Profile with Load balancing and Health Probe for Login endpoint
resource "azurerm_cdn_frontdoor_origin_group" "wecloudbackendloginprofile" {
  name                     = "wecloudbackendloginprofile"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id
  session_affinity_enabled = true

  load_balancing {
    // TODO
  }

  health_probe {
    // TODO
  }
}

# 6. Create an Azure Front Door Origin for Login and Profile endpoints
resource "azurerm_cdn_frontdoor_origin" "wecloudbackendloginprofileGCP" {
  name                          = "wecloudbackendloginprofileGCP"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.wecloudbackendloginprofile.id

  enabled                        = true
  certificate_name_check_enabled = false
  host_name                      = var.gcp_ingress_external_ip
  origin_host_header             = var.gcp_ingress_external_ip
  // TODO
}

resource "azurerm_cdn_frontdoor_origin" "wecloudbackendloginprofileAZURE" {
  name                          = "wecloudbackendloginprofileAZURE"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.wecloudbackendloginprofile.id

  enabled                        = true
  certificate_name_check_enabled = false
  host_name                      = var.azure_ingress_external_ip
  origin_host_header             = var.azure_ingress_external_ip
  // TODO
}

# 7. Create an Azure Front Door Origin Group for Chat with Load balancing and Health Probe for Chat endpoint
resource "azurerm_cdn_frontdoor_origin_group" "wecloudbackendchat" {
  name                     = "wecloudbackendchat"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id
  session_affinity_enabled = true

  load_balancing {
    // TODO
  }

  health_probe {
    // TODO
  }
}

# 8. Create an Azure Front Door Origin for Chat endpoints
resource "azurerm_cdn_frontdoor_origin" "wecloudbackendchatGCP" {
  name                          = "wecloudbackendchatGCP"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.wecloudbackendchat.id

  enabled                        = true
  certificate_name_check_enabled = false
  host_name                      = var.gcp_ingress_external_ip
  origin_host_header             = var.gcp_ingress_external_ip
  // TODO
}

# 9. Create an Azure Front Door Routing rule resource for Login and Profile endpoint
resource "azurerm_cdn_frontdoor_route" "loginprofilerouting" {
  name                          = "loginprofilerouting"
  // TODO
}

# 10. Create an Azure Front Door Routing rule resource for Chat endpoint
resource "azurerm_cdn_frontdoor_route" "chatrouting" {
  name                          = "chatrouting"
  // TODO
}