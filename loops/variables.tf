#varibale creation for count loop by using list
variable "public_cidr_block" {
  type = list
  default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "azs" {
  type = list
  default = ["ap-south-1a","ap-south-1b"]
}

variable "public_tags" {
    type = list
    default = ["public-timing-1","public-timing-2"]
  
}

#variable creation for for each loop by using MAP

variable "private_subnets" {
  type = map
  default = {
    private-subnet-1 = {
        Name = "private-1a"
        cidr = "10.0.11.0/24"
        azs = "ap-south-1a" 
    }
  
 private-subnet-2 = {
        Name = "private-2a"
        cidr = "10.0.12.0/24"
        azs = "ap-south-1b"       
  }
}
}