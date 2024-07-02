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

print "Content-Type: text/html\n\n";

print <<"HTML";
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Solicitudes</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>Lista de Solicitudes</h1>
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
                <td>$row->{documento}</td>
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
</body>
</html>
HTML

# Cierre de la conexión
$sth->finish();
$dbh->disconnect();
