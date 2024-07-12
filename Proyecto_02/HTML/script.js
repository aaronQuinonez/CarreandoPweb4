const wrapper = document.querySelector('.wrapper');
const loginLink = document.querySelector('.login-link');
const registerLink = document.querySelector('.register-link');
const btnPopup = document.querySelector('.btnLogin-popup');
const iconClose = document.querySelector('.icon-close');

wrapper.classList.add('active-popup');

registerLink.addEventListener('click', () => {
    console.log("Register link clicked");
    wrapper.classList.add('active');
});

loginLink.addEventListener('click', () => {
    console.log("Login link clicked");
    wrapper.classList.remove('active');
});

btnPopup.addEventListener('click', () => {
    console.log("Login button clicked");
    wrapper.classList.add('active-popup');
});

iconClose.addEventListener('click', () => {
    console.log("Close icon clicked");
    wrapper.classList.remove('active-popup');
});

function verificar() {
    var correo = document.getElementById('email').value;
    if (!correo.endsWith("@unsa.edu.pe")) {
        alert("Ingrese un correo válido");
        return false;
    }
    return true;
}

function verificarPswd() {
    var contraseña = document.getElementById('Contraseñas').value;
    var verificarContraseña = document.getElementById('VerificarContraseña').value;
    if (contraseña !== verificarContraseña) {
        alert("Las contraseñas no coinciden");
        return false;
    }
    return true;
}

function verificarTodo() {
    return verificar() && verificarPswd();
}