var dato = document.getElementById('opciones');

function accionar(){
    opcion = dato.value.toString();
    console.log(opcion);
    window.location.href = "/mostrarinfo/"+ opcion;

}


    