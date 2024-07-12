document.addEventListener('DOMContentLoaded', function() {
    var urlParams = new URLSearchParams(window.location.search);
    var username = urlParams.get('username');
    document.getElementById('usuario').innerHTML = username;
});

const urlParams = new URLSearchParams(window.location.search);
const username = urlParams.get('username');

const solicitudEvaluacionLink = document.getElementById('solicitudEvaluacionLink');
if (solicitudEvaluacionLink) {
    solicitudEvaluacionLink.href = `solicitudDeEvaluacion.html?username=${username}`;
}

const seguimientoSolicitudLink = document.getElementById('seguimientoLink');
if (seguimientoSolicitudLink) {
    seguimientoSolicitudLink.href = `../PERL/seguimiento.pl?username=${username}`;
}