terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=3.39.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_cdn_frontdoor_profile" "frontdoor" {
  name                = var.frontdoor_name
  resource_group_name = var.resource_group_name
  sku_name = "Standard_AzureFrontDoor"
  tags = {
    Environment = "Production"
  }
}

resource "azurerm_cdn_frontdoor_endpoint" "frontendEndpoint" {
  name                     = var.frontdoor_endpoint
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id
}

resource "azurerm_cdn_frontdoor_origin_group" "wecloudbackendloginprofile" {
  name                     = "wecloudbackendloginprofile"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id
  session_affinity_enabled = true

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 2
    additional_latency_in_milliseconds    = 100
  }

  health_probe {
    path                = "/login"
    protocol            = "Http"
    request_type        = "GET"
    interval_in_seconds = 30
  }
}

resource "azurerm_cdn_frontdoor_origin" "wecloudbackendloginprofileGCP" {
  name                          = "wecloudbackendloginprofileGCP"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.wecloudbackendloginprofile.id

  enabled                        = true
  certificate_name_check_enabled = false
  host_name                      = var.gcp_ingress_external_ip
  origin_host_header             = var.gcp_ingress_external_ip
  http_port                      = 80
  https_port                     = 443
}

resource "azurerm_cdn_frontdoor_origin" "wecloudbackendloginprofileAZURE" {
  name                          = "wecloudbackendloginprofileAZURE"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.wecloudbackendloginprofile.id

  enabled                        = true
  certificate_name_check_enabled = false
  host_name                      = var.azure_ingress_external_ip
  origin_host_header             = var.azure_ingress_external_ip
  http_port                      = 80
  https_port                     = 443
}

resource "azurerm_cdn_frontdoor_origin_group" "wecloudbackendchat" {
  name                     = "wecloudbackendchat"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id
  session_affinity_enabled = true

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 2
    additional_latency_in_milliseconds    = 100
  }

  health_probe {
    path                = "/chat"
    protocol            = "Http"
    request_type        = "GET"
    interval_in_seconds = 30
  }
}

resource "azurerm_cdn_frontdoor_origin" "wecloudbackendchatGCP" {
  name                          = "wecloudbackendchatGCP"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.wecloudbackendchat.id

  enabled                        = true
  certificate_name_check_enabled = false
  host_name                      = var.gcp_ingress_external_ip
  origin_host_header             = var.gcp_ingress_external_ip
  http_port                      = 80
  https_port                     = 443
}

resource "azurerm_cdn_frontdoor_route" "loginprofilerouting" {
  name                          = "loginprofilerouting"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.frontendEndpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.wecloudbackendloginprofile.id
  cdn_frontdoor_origin_ids       = [azurerm_cdn_frontdoor_origin.wecloudbackendloginprofileGCP.id, azurerm_cdn_frontdoor_origin.wecloudbackendloginprofileAZURE.id]

  patterns_to_match     = ["/login", "/profile"]
  supported_protocols   = ["Http"]
  forwarding_protocol   = "HttpOnly"
  https_redirect_enabled = false
}

resource "azurerm_cdn_frontdoor_route" "chatrouting" {
  name                          = "chatrouting"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.frontendEndpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.wecloudbackendchat.id
  cdn_frontdoor_origin_ids       = [azurerm_cdn_frontdoor_origin.wecloudbackendchatGCP.id]

  patterns_to_match     = ["/chat", "/chat/*"]
  supported_protocols   = ["Http"]
  forwarding_protocol   = "HttpOnly"
  https_redirect_enabled = false
}