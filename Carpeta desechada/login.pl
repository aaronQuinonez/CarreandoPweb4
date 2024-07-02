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
my $password = '1234';

my $dbh = DBI->connect($dsn, $username, $password) or die "No se pudo conectar a la base de datos";

#Comprobamos si usuario y contraseña están en la base de datos
my $user = $cgi -> param('usuario');
my $password = $cgi -> param('contraseña');

#Primero comprobamos si los datos pertenecen al administrador
my $sthadm = $dbh->prepare("SELECT * FROM administradores WHERE nombreUsuario = ? AND password = ?");
$sthadm->execute($user, $password)
if(my $rowadm = $sth->fetchrow_hashref){
    print $cgi->redirect('admin.html');
}
else{
    my $sth = $dbh->prepare("SELECT * FROM usuario WHERE nombreUsuario = ? AND password = ?");
    $sth->execute($user, $password);

    #Si USUARIO está en la base de datos
    if(my $row = $sth->fetchrow_hashref){
        print $cgi->redirect('usuario.html');   #Llenar
    }
    else {
        print <<HTML;
            <!DOCTYPE HTML>
            <html>
            <head>
                <title>Error de autenticación</title>
            </head>
            <body>
                <p>Usuario o contraseña incorrectos. Intente de nuevo.</p>
                <form action="index.html" method="POST">
                    <input type="submit" value="Regresar">
                </form>
            </body>
            </html>
HTML
    }
}