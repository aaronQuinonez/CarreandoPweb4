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
        <!DOCTYPE HTML>
        <html>
        <head>
            <title>Registro completado</title>
        </head>
        <body>
            <p>Usuario registrado</p>
            <form action="../HTML/numero2.html" method="POST">
                <input type="submit" value="Regresar">
            </form>
        </body>
        </html>
HTML