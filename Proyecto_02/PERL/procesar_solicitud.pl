#!"C:/xampp/perl/bin/perl.exe"
use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use File::Basename;
use DBI;

my $cgi = CGI->new;
print $cgi->header(-type => 'text/html', -charset => 'UTF-8');

#Parámetros
my $dsn = 'DBI:mysql:database=gestiondeacreditacion;host=localhost';
my $username = 'user'; 
my $password = '1234'; 

my $dbh = DBI->connect($dsn, $username, $password) or die "No se pudo conectar a la base de datos";

# Recibir los datos del formulario
my $institution_name = $cgi->param('institution-name');
my $address = $cgi->param('address');
my $contact_person = $cgi->param('contact-person');
my $phone = $cgi->param('phone');
my $email = $cgi->param('email');
my $description = $cgi->param('description');
my $initial_documents = $cgi->param('initial-documents');

my $sth = $dbh->prepare("INSERT INTO solicitudes (institucion, direccion, contacto, telefono, correo, descripcion, documento) VALUES (?, ?, ?, ?, ?, ?, ?)");
$sth->execute($institution_name, $address, $contact_person, $phone, $email, $description, $initial_documents);

# Definir directorio de subida
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

# Generar HTML para la tabla con los datos recibidos
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
    </div>
</body>
</html>
HTML
