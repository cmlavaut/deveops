#!/bin/bash
echo "Ingrese el número de nodos que conectará al servidor de ansible!"
read var
echo "Bien, ingrese todas las ${var} de los nodos en líneas separadas ..."
for (( i=1; i<=var; i++ ))
do
  read ip
  echo "${ip} ansible_ssh_user=kmi ansible_ssh_pass=kmi ansible_ssh_port=22" >> /etc/ansible/hosts
done
echo "¡Agregado correctamente al servidor de Ansible!"
/bin/bash