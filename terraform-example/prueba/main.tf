provider "local" {
  
}

resource "local_file" "hello"{
        content = var.text_file
        filename = "prueba.txt"

}
