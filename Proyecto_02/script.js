const wrapper = document.querySelector('.wrapper');
const loginLink = document.querySelector('.login-link');
const registerLink = document.querySelector('.register-link');
const btnPopup = document.querySelector('.btnLogin-popup');
const iconClose = document.querySelector('.icon-close');

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
