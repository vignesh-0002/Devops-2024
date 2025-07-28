# Configure the AWS Provider
provider "aws" {
  profile                = "default"
  region                 = "us-east-1"
}


provider "cloudflare" {
  api_token = "OKny-C7uscAtXz0drVnSILI2GkiNFOqK5bLGaRch" # or use API token
}


terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"  # or any version you need
    }
  }

  required_version = ">= 1.3.0"
}
