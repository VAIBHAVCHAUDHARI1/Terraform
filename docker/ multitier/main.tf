terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}
#provider "docker" {
#  host = "ssh://root@192.168.72.151"
#}
resource "docker_network" "mynet" {
  name = "my_network"
}
resource "docker_container" "mysql_container" {
  name  = "mydb"
  image = "docker.io/mysql:5.6"
  env   = ["MYSQL_ROOT_PASSWORD=unnati", "MYSQL_DATABASE=test"]
  networks_advanced {
    name = docker_network.mynet.name
  }
}

resource "docker_container" "wordpress_container" {
  name  = "wp"
  image = "docker.io/wordpress"
  env = [
    "WORDPRESS_DB_HOST=mydb",
    "WORDPRESS_DB_NAME=test",
    "WORDPRESS_DB_USER=root",
    "WORDPRESS_DB_PASSWORD=unnati",
  ]
  ports {
    internal = 80
    external = 18008
  }

  networks_advanced {
    name = docker_network.mynet.name
  }

}
ro
