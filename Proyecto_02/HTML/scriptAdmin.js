var urlParams = new URLSearchParams(window.location.search);
var username = urlParams.get('username');
document.getElementById('usuario').innerHTML = username;

const seguimientoSolicitudLink = document.getElementById('adminLink');
if (seguimientoSolicitudLink) {
    seguimientoSolicitudLink.href = `../PERL/evaluacion.pl?username=${username}`;
}