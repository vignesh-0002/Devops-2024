# www.getitworth.com -> ALB
resource "cloudflare_record" "www" {
  zone_id = "6a467531e283a3e42ed05e8dde1e45ef"
  name    = "www"
  type    = "CNAME"
  value   = aws_lb.ecs_alb.dns_name
  proxied = true
}

# getitworth.com -> ALB via Cloudflare CNAME flattening
resource "cloudflare_record" "root" {
  zone_id = "6a467531e283a3e42ed05e8dde1e45ef"
  name    = "getitworth.com"
  type    = "CNAME"
  value   = aws_lb.ecs_alb.dns_name
  proxied = true
}

resource "aws_acm_certificate" "ssl_cert" {
  domain_name       = "getitworth.com"
  validation_method = "DNS"

  tags = {
    Name = "getitworth-ssl"
  }
}



#output "ssl_validation_record" {
#  value = aws_acm_certificate.ssl_cert.domain_validation_options[0]
#}



output "ssl_validation_record" {
  value = tolist(aws_acm_certificate.ssl_cert.domain_validation_options)[0]
}


resource "cloudflare_record" "acm_validation" {
  zone_id = "6a467531e283a3e42ed05e8dde1e45ef"
  name    = "_ed838db0fa0fc4ffbebeb27c827c5ad6.getitworth.com"
  type    = "CNAME"
  value   = "_047313bca67e63a22ea629d24d9e0662.xlfgrmvvlj.acm-validations.aws"
  proxied = false  # MUST be false for validation to work
}
