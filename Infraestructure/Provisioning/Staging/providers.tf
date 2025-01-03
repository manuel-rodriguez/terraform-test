# Azure Provider source and version
terraform {
  cloud {
    organization = "OXXO"
 
    workspaces {
      name = "WEB_GIS2_CNT_API_INFRA-QA"
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
} 