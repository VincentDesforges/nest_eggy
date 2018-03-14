
document.querySelectorAll(".bank-account-choice").forEach((element) => {
  element.addEventListener("click", (event) => {
    event.currentTarget.classList.toggle("active");
  });
});
