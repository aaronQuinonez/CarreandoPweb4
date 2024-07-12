#!"C:/xampp/perl/bin/perl.exe"
use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use File::Basename;
use DBI;

my $cgi = CGI->new;
my $dsn = 'DBI:mysql:database=gestiondeacreditacion;host=localhost';
my $username = 'user'; 
my $password = '1234'; 

my $dbh = DBI->connect($dsn, $username, $password) or die "No se pudo conectar a la base de datos";

print $cgi->header(-type => 'text/html', -charset => 'UTF-8');

my $user = $cgi ->param('username');

my $sth = $dbh->prepare("SELECT * FROM solicitudes WHERE usuario=?");
$sth->execute($user);

print <<"HTML";
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Estado</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        header {
            background-color: #0174DF;
            color: white;
            padding: 1rem;
            text-align: center;
        }
        .table-container {
            margin: 2rem auto;
            width: 90%;
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 2rem;
        }
        th, td {
            padding: 0.75rem;
            text-align: left;
            border: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
        .icon {
            width: 24px;
            height: 24px;
            display: inline-block;
            background-size: contain;
            vertical-align: middle;
        }
        .validated {
            color: green;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <header>
        <h1>Estado</h1>
    </header>
    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Nombre de la Institución</th>
                    <th>Dirección</th>
                    <th>Persona de Contacto</th>
                    <th>Teléfono</th>
                    <th>Correo Electrónico</th>
                    <th>Descripción</th>
                    <th>Documento</th>
                    <th>Estado</th>
                </tr>
            </thead>
            <tbody>
HTML
while (my $row = $sth->fetchrow_hashref) {
    my $institution_name = $row->{institucion};
    my $address = $row->{direccion};
    my $contact_person = $row->{contacto};
    my $phone = $row->{telefono};
    my $email = $row->{correo};
    my $description = $row->{descripcion};
    my $document = $row->{documento};
    my $estado = $row->{estado};  # Asegúrate de que tienes un campo "estado" en la base de datos

    print <<"HTML";
                <tr>
                    <td>$institution_name</td>
                    <td>$address</td>
                    <td>$contact_person</td>
                    <td>$phone</td>
                    <td>$email</td>
                    <td>$description</td>
                    <td><a href="uploads/$document" target="_blank">Ver Documento</a></td>
                    <td>$estado</td>
                </tr>
HTML
}

print <<"HTML";
            </tbody>
        </table>
    </div>
</body>
</html>
HTML

$sth->finish;
$dbh->disconnect;