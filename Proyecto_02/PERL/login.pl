#!"C:/xampp/perl/bin/perl.exe"
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI -> new;
print $cgi->header('text/html; charset=utf-8');

#Parámetros
my $dsn = 'DBI:mysql:database=gestiondeacreditacion;host=localhost';
my $username = 'user';
my $passwd = '1234';

my $dbh = DBI->connect($dsn, $username, $passwd) or die "No se pudo conectar a la base de datos";

#Comprobamos si usuario y contraseña están en la base de datos
my $user = $cgi -> param('usuario');
my $password = $cgi -> param('contraseña');

#Primero comprobamos si los datos pertenecen al administrador
my $sthadm = $dbh->prepare("SELECT * FROM administradores WHERE usuario = ? AND password = ?");
$sthadm->execute($user, $password) or die "Error al ejecutar la consulta SQL para administradores: $DBI::errstr";
if(my $rowadm = $sthadm->fetchrow_hashref){
    print "Content-type: text/html\n\n";
    print "<script>window.location.href = '/PROYECTO%20FINAL%20PWEB/Proyecto_02/HTML/admin.html?username=$user';</script>";
    print "</body></html>";
}
else{
    my $sth = $dbh->prepare("SELECT * FROM usuario WHERE nombreUsuario = ? AND password = ?");
    $sth->execute($user, $password);

    #Si USUARIO está en la base de datos
    if(my $row = $sth->fetchrow_hashref){
        print "Content-type: text/html\n\n";
        print "<html><head><title>Redireccionando...</title></head><body>";
        print "<script>window.location.href = '/PROYECTO%20FINAL%20PWEB/Proyecto_02/HTML/usuario.html?username=$user';</script>";
        print "</body></html>";
    }
    else {
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
    <title>Error de Autenticacion</title>
    <link rel="stylesheet" href="../CSS/estyle.css">
</head>
<body>  
    <header>
        <h2 class="logo">Error de Autenticacion</h2>
    </header>
    <div class="container">
        <h1>Usuario o contraseña incorrectos.</h1><br>
        <h1>Intente de nuevo.</h1>
        <a href="../HTML/numero2.html" class="btn" id="Regreso">Regresar</a>
    </div>
    <script src="scriptUser.js"></script>
</body>
</html>
HTML
    }
}
$dbh->disconnect;