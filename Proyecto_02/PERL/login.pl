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
    print "<html><head><title>Redireccionando...</title></head><body>";
    print "<script>window.location.href = '/PROYECTO%20FINAL%20PWEB/Proyecto_02/HTML/admin.html';</script>";
    print "</body></html>";
}
else{
    my $sth = $dbh->prepare("SELECT * FROM usuario WHERE nombreUsuario = ? AND password = ?");
    $sth->execute($user, $password);

    #Si USUARIO está en la base de datos
    if(my $row = $sth->fetchrow_hashref){
        print "Content-type: text/html\n\n";
        print "<html><head><title>Redireccionando...</title></head><body>";
        print "<script>window.location.href = '/PROYECTO%20FINAL%20PWEB/Proyecto_02/HTML/usuario.html';</script>";
        print "</body></html>";
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
                <form action="../HTML/numero2.html" method="POST">
                    <input type="submit" value="Regresar">
                </form>
            </body>
            </html>
HTML
    }
}
$dbh->disconnect;