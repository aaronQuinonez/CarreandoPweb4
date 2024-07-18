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

my $user = $cgi->param('username');

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
            font-family: 'Poppins', sans-serif;
            background: url('../CSS/fondo3.png') no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            box-sizing: border-box;
        }

        header {
            background-color: #005792;
            color: white;
            padding: 10px; /* Reduce the padding to make the header thinner */
            text-align: center;
            width: 100%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            position: fixed;
            top: 0;
        }

        .table-container {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 90%;
            margin: 120px auto 20px auto;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border: 1px solid #ddd;
        }

        th {
            background-color: #f2f2f2;
            font-weight: 600;
        }

        a {
            color: #005792;
            text-decoration: none;
            font-weight: bold;
        }

        a:hover {
            text-decoration: underline;
        }

        .back-link {
            display: inline-block;
            padding: 10px 20px;
            background-color: #005792;
            color: white;
            border-radius: 5px;
            text-align: center;
            text-decoration: none;
            font-weight: 500;
            transition: background-color 0.3s;
            margin-top: 20px;
        }

        .back-link:hover {
            background-color: #0174DF;
        }
    </style>
</head>
<body>
    <header>
        <h1>ESTADO</h1>
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
    my $estado = $row->{estado};

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
        <a href="../HTML/usuario.html?username=$user" class="back-link">Volver</a>
    </div>
</body>
</html>
HTML

$sth->finish;
$dbh->disconnect;
