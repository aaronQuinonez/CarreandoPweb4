#!"C:/xampp/perl/bin/perl.exe"
use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use File::Basename;
use DBI;

# Datos de conexión
my $username = "user";
my $password = "1234";

# Conexión a la base de datos
my $dsn = 'DBI:mysql:database=gestiondeacreditacion;host=localhost';
my $dbh = DBI->connect($dsn, $username, $password) or die "No se pudo conectar a la base de datos";

my $cgi = CGI->new;

# Consulta a la base de datos
my $sql = "SELECT * FROM solicitudes";
my $sth = $dbh->prepare($sql);
$sth->execute();

my $user = $cgi->param('username');

print "Content-Type: text/html\n\n";

print <<"HTML";
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Solicitudes</title>
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
        <h1>LISTA DE SOLICITUDES</h1>
    </header>
    <div class="table-container">
        <a href="../HTML/admin.html?username=$user" class="back-link">Volver</a>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Institución</th>
                    <th>Dirección</th>
                    <th>Contacto</th>
                    <th>Teléfono</th>
                    <th>Correo</th>
                    <th>Descripción</th>
                    <th>Documento</th>
                    <th>Usuario</th>
                    <th>Estado</th>
                </tr>
            </thead>
            <tbody>
HTML

# Obtención de los datos
while (my $row = $sth->fetchrow_hashref()) {
    print <<"HTML";
                <tr>
                    <td>$row->{id}</td>
                    <td>$row->{institucion}</td>
                    <td>$row->{direccion}</td>
                    <td>$row->{contacto}</td>
                    <td>$row->{telefono}</td>
                    <td>$row->{correo}</td>
                    <td>$row->{descripcion}</td>
                    <td><a href="uploads/$row->{documento}" target="_blank">$row->{documento}</a></td>
                    <td>$row->{usuario}</td>
                    <td>
                        <form method="post" action="">
                            <input type="hidden" name="id" value="$row->{id}">
                            <select name="nuevo_estado" onchange="this.form.submit()">
                                <option value="Pendiente" @{[$row->{estado} eq 'Pendiente' ? 'selected' : '']}>Pendiente</option>
                                <option value="En Proceso" @{[$row->{estado} eq 'En Proceso' ? 'selected' : '']}>En Proceso</option>
                                <option value="Completado" @{[$row->{estado} eq 'Completado' ? 'selected' : '']}>Completado</option>
                            </select>
                        </form>
                    </td>
                </tr>
HTML
}

# Procesa la entrada del formulario
if ($cgi->param('id') && $cgi->param('nuevo_estado')) {
    my $id = $cgi->param('id');
    my $nuevo_estado = $cgi->param('nuevo_estado');

    # Conexión a la base de datos
    my $dsn = 'DBI:mysql:database=gestiondeacreditacion;host=localhost';
    my $username = "user";
    my $password = "1234";
    my $dbh = DBI->connect($dsn, $username, $password) or die "No se pudo conectar a la base de datos";

    # Actualiza el estado en la base de datos
    my $update_sql = "UPDATE solicitudes SET estado = ? WHERE id = ?";
    my $update_sth = $dbh->prepare($update_sql);
    $update_sth->execute($nuevo_estado, $id);

    # Cierra la conexión
    $update_sth->finish();
    $dbh->disconnect();
}
print <<"HTML";
            </tbody>
        </table>
    </div>
</body>
</html>
HTML

# Cierre de la conexión
$sth->finish();
$dbh->disconnect();
