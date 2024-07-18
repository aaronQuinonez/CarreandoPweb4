#!"C:/xampp/perl/bin/perl.exe"
use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use File::Basename;
use DBI;

my $cgi = CGI->new;
print $cgi->header(-type => 'text/html', -charset => 'UTF-8');

my $dsn = 'DBI:mysql:database=gestiondeacreditacion;host=localhost';
my $username = 'user'; 
my $password = '1234'; 

my $dbh = DBI->connect($dsn, $username, $password) or die "No se pudo conectar a la base de datos";

my $institution_name = $cgi->param('institution-name');
my $address = $cgi->param('address');
my $contact_person = $cgi->param('contact-person');
my $phone = $cgi->param('phone');
my $email = $cgi->param('email');
my $description = $cgi->param('description');
my $initial_documents = $cgi->param('initial-documents');
my $user = $cgi -> param('username');

my $sth = $dbh->prepare("INSERT INTO solicitudes (institucion, direccion, contacto, telefono, correo, descripcion, documento, usuario) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
$sth->execute($institution_name, $address, $contact_person, $phone, $email, $description, $initial_documents, $user);

my $upload_dir = "uploads";
mkdir $upload_dir unless -d $upload_dir;

my $filename;
if ($initial_documents) {
    my ($basename, $dirs, $suffix) = fileparse($initial_documents, qr/\.[^.]*/);
    if ($suffix ne '.pdf') {
        print "Lo siento, solo se permiten archivos PDF.";
        exit;
    }
    $filename = $basename . $suffix;

    my $upload_file = "$upload_dir/$filename";

    # Abrir el archivo en modo binario y asegurarse de que se manejen correctamente los datos
    open my $fh, '>:raw', $upload_file or die "No se pudo abrir el archivo '$upload_file' para escritura: $!";
    binmode $fh;

    # Leer datos del manejador de archivo y escribir al archivo de destino
    while (my $chunk = <$initial_documents>) {
        print $fh $chunk;
    }
    close $fh;
}

print <<"HTML";
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Estado</title>
    <link rel="stylesheet" href="../CSS/solicitud.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: url('fondo3.png') no-repeat;
            background-size: cover;
            background-position: center;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        header {
            background-color: #005792;
            color: white;
            padding: 20px;
            text-align: center;
            width: 100%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .table-container {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 90%;
            margin: 20px auto;
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
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>$institution_name</td>
                    <td>$address</td>
                    <td>$contact_person</td>
                    <td>$phone</td>
                    <td>$email</td>
                    <td>$description</td>
                    <td><a href="uploads/$filename" target="_blank">Ver Documento</a></td>
                </tr>
            </tbody>
        </table>
        <a href="../HTML/usuario.html?username=$user" class="back-link">Volver</a>
    </div>
</body>
</html>
HTML
