#!"C:/xampp/perl/bin/perl.exe"
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI -> new;
print $cgi->header();

#Parámetros
my $dsn = 'DBI:mysql:database=gestiondeacreditacion;host=localhost';
my $username = 'user'; 
my $password = '1234'; 

my $dbh = DBI->connect($dsn, $username, $password) or die "No se pudo conectar a la base de datos";

#Recibimos los datos 
my $user = $cgi -> param('Usuarios');
my $name = $cgi -> param('Nombres');
my $email = $cgi -> param('Correos');
my $passwd = $cgi -> param('Contraseñas');

my $sth = $dbh->prepare("INSERT INTO usuario (nombre, nombreUsuario, correo, password) VALUES (?, ?, ?, ?)");
$sth->execute($name, $user, $email, $passwd);
print <<HTML;
    <!DOCTYPE html>
<html lang="es">
    <style>
    .container {
    padding: 20px;
    max-width: 600px;
    margin: 20px auto;
    background-color: white;
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    text-align: center;
    }
    a.btn {
        display: inline-block;
        background-color: #17014a;
        color: white;
        padding: 10px 20px;
        text-decoration: none;
        border-radius: 5px;
        margin: 10px 5px;
        font-size: 16px;
    }
    p{
        font-size: 20px;
        font-weight: bold;
    }
    </style>
<head>
    <meta charset="UTF-8">
    <title>Registro Completado</title>
    <link rel="stylesheet" href="../CSS/estyle.css">
</head>
<body>  
    <header>
        <h2 class="logo">Bienvenido Usuario</h2>
    </header>
    <div class="container">
        <h1>Registrado Exitosamente!!!</h1>
        <a href="../HTML/numero2.html" class="btn" id="Regreso">Regresar</a>
    </div>
    <script src="scriptUser.js"></script>
</body>
</html>
HTML