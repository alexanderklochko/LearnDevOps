# General parameters
environment = "crud"

# Network parameter
vpc_cidr = "10.0.0.0/16"
public_subnet = {
  public_1 = {
    cidr = "10.0.1.0/24"
    az   = "ca-central-1b"
  },
  public_2 = {
    cidr = "10.0.2.0/24"
    az   = "ca-central-1a"
  }
}
private_subnet = {
  private_1 = {
    cidr = "10.0.3.0/24"
    az   = "ca-central-1b"
  },
  private_2 = {
    cidr = "10.0.4.0/24"
    az   = "ca-central-1a"
  }
}
private_subnet_RDS = {
  private_RDS_1 = {
    cidr = "10.0.5.0/24"
    az   = "ca-central-1b"
  },
  private_RDS_2 = {
    cidr = "10.0.6.0/24"
    az   = "ca-central-1a"
  }
}