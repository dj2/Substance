document.addEventListener('DOMContentLoaded', () => {
  const links = document.querySelectorAll("a[data-remote]");
  links.forEach((el) => {
    el.addEventListener('click', (ev) => {
      const req = new XMLHttpRequest();
      req.open('GET', el.getAttribute('href'), true);
      req.send();

      ev.preventDefault();
      ev.stopPropagation();

      el.parentElement.parentElement.remove();
    });
  });
});
