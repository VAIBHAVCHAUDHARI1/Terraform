terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}
provider "docker" {
  host = "unix:///var/run/docker.sock"
}
import {
  id = "83fa09960bd9bed4c17cd7f6452f5827e93ce0fa1a461e433a3d4a031e984faf"
  to = docker_container.web
}
