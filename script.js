$(() => {
  $("#calc").on("click", () => {
    const weight = parseInt($("#weight").val());
    const height = parseInt($("#height").val());
    const age = parseInt($("#age").val())
    const gender = $('input[name="gender"]:checked').val();

    const goal = parseFloat($('input[name="goal"]:checked').val());
    const bmr = calculateBMR(weight, height, age, gender);
    const activity = parseFloat($('input[name="activity"]:checked').val())
    const tdee = calculateTDEE(bmr, activity)
    const goalTDEE = tdee * goal;
    const bmi = calculateBMI(weight, height);
    const bfp = calculateBFP(bmi, age, gender);
    const eCarbs = carbsToEnergy(20);
    const eProtein = proteinsToEnergy(calculateProteinNeeded(weight, bfp))
    const eFat = goalTDEE - eCarbs - eProtein;
    $("#results").empty();
    $("#results").append(`<p>Total Daily Energy Expenditure: ${tdee} kcal</p>`)
    $("#results").append(`<p>Total Goal Daily Energy Expenditure: ${goalTDEE} kcal</p>`)
    //$("#results").append(`<p>BFP: ${bfp} %</p>`)
    $("#results").append(`<p>Fat(g): ${eFat / 9}</p>`)
    $("#results").append(`<p>Protein(g): ${calculateProteinNeeded(weight, bfp)}</p>`)
    $("#results").append(`<p>Carbs(g): ${eCarbs / 4}</p>`)
    $("#results").append(`<p>Fat(E): ${eFat} kcal</p>`)
    $("#results").append(`<p>Protein(E): ${eProtein} kcal</p>`)
    $("#results").append(`<p>Carbs(E): ${eCarbs} kcal</p>`)
    $("#results").append(`<p>Fat(%): ${100 * eFat / goalTDEE} %</p>`)
    $("#results").append(`<p>Protein(%): ${100 * eProtein / goalTDEE} %</p>`)
    $("#results").append(`<p>Carbs(%): ${100 * eCarbs / goalTDEE} %</p>`)
  })
})

function calculateProteinNeeded(weight, bfp) {
  const totalFat = 0.01 * bfp * weight;
  const essentialFat = calculateEssentialFat(totalFat);
  const leanWeight = weight - totalFat;
  const proteinMin = (leanWeight + essentialFat) * 1.3
  const proteinMax = (leanWeight + essentialFat) * 2.2
  return (proteinMin + proteinMax) / 2
}

function calculateEssentialFat(totalFat) {
  return -0.029412 * totalFat + 2.741176
}

function calculateBMR(weight, height, age, gender) {
  const genderCoef = (gender === "male") ? 5 : -161;
  return (10 * weight + 6.25 * height - 5 * age + genderCoef)
}

function calculateTDEE(bmr, activity) {
  return bmr * activity
}

function calculateBFP(bmi, age, gender) {
  const genderCoef = (gender === "male") ? 1 : 0;
  return (1.30 * bmi + 0.16 * age - 10.34 * genderCoef - 9)
}

function calculateBMI(weight, height) {
  return ((10000 * weight) / (height * height))
}

function carbsToEnergy(carbs) {
  return 4 * carbs;
}

function proteinsToEnergy(proteins) {
  return 4 * proteins;
}

function fatToEnergy(fat) {
  return 9 * fat;
}
