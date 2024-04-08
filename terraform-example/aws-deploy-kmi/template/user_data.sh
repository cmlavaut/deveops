#!/bin/bash
#echo "<h1>Hello, World</h1>" > index.html
cat <<- EOF > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KMI WEB</title>
</head>
<body>
    <h1>DEPLOY WITH TERRAFORM</h1>
    <p>Este es un ejemplo básico de un archivo HTML.</p>
</body>
</html>

EOF

nohup busybox httpd -f -p 80 &
