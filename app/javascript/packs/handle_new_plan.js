document.querySelectorAll(".bank-account-choice").forEach((element) => {

  element.addEventListener("click", (event) => {
    event.currentTarget.classList.toggle("active");
  });
});

const computeWeeklySavings = (targetAmount, targetYear) => {
  sumReturns = 0;
  for (i = 0; i < targetYear; i++) {
    sumReturns += 52 * Math.pow(1.02, i);
  }
  return (targetAmount/sumReturns).toFixed(2);
};

const updateWeeklySavings = () => {
  const planTargetAmount = parseInt(document.getElementById("plan_target_amount").value);
  const planTargetYear = parseInt(document.getElementById("plan_target_year").value);

  const savings = computeWeeklySavings(planTargetAmount, planTargetYear);
  document.getElementById("weekly_target").innerHTML = savings;
  document.getElementById("hidden_weekly_target").value = savings;
};

document.querySelectorAll("[type='range']").forEach((element) => {
  element.addEventListener("input", (event) => {
    event.currentTarget.nextElementSibling.querySelector(".range-value").innerHTML = element.value;
    updateWeeklySavings();
  });
})
