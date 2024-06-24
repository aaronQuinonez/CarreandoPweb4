#!"C:/xampp/perl/bin/perl.exe"
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI -> new;
print $cgi->header('text/html; charset=utf-8');

#Parámetros
my $dsn = 'DBI:mysql:database=gestiondeacreditacion;host=localhost'; #Llenar
my $username = 'user';
my $password = '1234';

my $dbh = DBI->connect($dsn, $username, $password) or die "No se pudo conectar a la base de datos";

#Comprobamos si usuario y contraseña están en la base de datos
my $user = $cgi -> param('usuario');
my $password = $cgi -> param('contraseña');

my $sth = $dbh->prepare("SELECT * FROM usuario WHERE nombreUsuario = ? AND password = ?");
$sth->execute($user, $password);

#Si está en la base de datos
if(my $row = $sth->fetchrow_hashref){
    #print $cgi->redirect('');   #Llenar
    print <<HTML;
        <!DOCTYPE HTML>
        <html>
        <head>
            <title>a</title>
        </head>
        <body>
            <p>BIENVENIDO</p>
            <form action="index.html" method="POST">
                <input type="submit" value="Regresar">
            </form>
        </body>
        </html>
HTML
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