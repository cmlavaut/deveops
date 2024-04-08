variable "container_name" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "KMINginxContainer"
}

variable "text_file" {
     description= "vaalor del contenido del texto"
     type = string
     default = "Prueba de contenido de texto con terraform"
   

}
