data "http" "external-ip" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  external-cidr = "${chomp(data.http.external-ip.body)}/32"
}
