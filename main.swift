import Foundation

func calculateBMI(weight: Double, height: Double) -> Double {
  return ((10000 * weight) / (height * height))
}

func carbsToEnergy(carbs: Double) -> Double {
  return 4 * carbs
}

func proteinsToEnergy(proteins: Double) -> Double {
  return 4 * proteins
}

func fatToEnergy(fat: Double) -> Double {
  return 9 * fat
}

func calculateBFP(bmi: Double, age: Int, gender: String) -> Double {
  let genderCoef: Int = (gender == "Male") ? 1 : 0
  return (1.30 * bmi + 0.16 * Double(age) - 10.34 * Double(genderCoef) - 9)
}

func calculateTDEE(bmr: Double, activity: Double) -> Double {
  return bmr * activity
}

func calculateBMR(weight: Double, height: Double, age: Int, gender: String) -> Double {
  let genderCoef: Int = (gender == "Male") ? 1 : 0
  return (10 * weight + 6.25 * height - 5 * Double(age) + Double(genderCoef))
}

func calculateEssentialFat(totalFat: Double) -> Double {
  return -0.029412 * totalFat + 2.741176
}

func calculateProteinNeeded(weight: Double, bfp: Double) -> Double {
  let totalFat = 0.01 * bfp * weight
  let essentialFat = calculateEssentialFat(totalFat: totalFat)
  let leanWeight = weight - totalFat
  let proteinMin = (leanWeight + essentialFat) * 1.3
  let proteinMax = (leanWeight + essentialFat) * 2.2
  return (proteinMin + proteinMax) / 2
}

func recalculateMacros() {

  /*
  let defaults = UserDefaults.standard
  let goal = defaults.string(forKey: "GenderGoal")
  let activity = defaults.string(forKey: "GenderActivity")
  let weight = defaults.string(forKey: "GenderWeight")
  let height = defaults.string(forKey: "GenderHeight")
  let age = defaults.string(forKey: "GenderAge")
  let sex = defaults.string(forKey: "GenderMacros")
  _ = defaults.string(forKey: "userId")
  */

  //Test values
  let goal = "Maintain Shape"
  let activity = "Never"
  let height = String?("185 cm")
  let weight = String?("75 Kg")
  let age = String?("27")
  let sex = String?("Male")

  var bmr: Double = 0
  var heightReplaced: Double = 0.0
  var weightReplaced: Double = 0.0

  if (height?.contains(" cm"))! {
    heightReplaced = Double(height!.replacingOccurrences(of: " cm", with: ""))!
  } else {
    let trim = height!.replacingOccurrences(of: " ft ", with: ".")
    let d = Double(trim)
    let result = d! / 0.032808399
    let rInt = Int(result.rounded())
    heightReplaced = Double(rInt)
  }

  if (weight?.contains(" Kg"))! {
    weightReplaced = Double(weight!.replacingOccurrences(of: " Kg", with: ""))!
  } else {
    let trim = weight!.replacingOccurrences(of: " lbs", with: "")
    let d = Double(trim)
    let result = d! / 2.2046226218488
    let rInt = Int(result.rounded())
    weightReplaced = Double(rInt)
  }

  let ageReplaced = Int(age!)!
  bmr = calculateBMR(weight: weightReplaced, height: heightReplaced, age: ageReplaced, gender: sex!)

  var activityPonder = 1.2

  if activity == "Never" {
    activityPonder = 1.1
  } else if activity == "Rarely" {
    activityPonder = 1.375
  } else if activity == "2 - 3 times" {
    activityPonder = 1.55
  } else {
    activityPonder = 1.725
  }

  let tdee = calculateTDEE(bmr: bmr, activity: activityPonder)

  var goalPonder = 0.8

  if goal == "Maintain Shape" {
    goalPonder = 1
  } else if goal == "Stay Healthy" {
    goalPonder = 0.88
  } else if goal == "Weight-Loss" {
    goalPonder = 0.8
  } else {
    goalPonder = 1.2
  }

  let goalTDEE = Int((tdee * goalPonder).rounded())
  let bmi = calculateBMI(weight: weightReplaced, height: heightReplaced)
  let bfp = calculateBFP(bmi: bmi, age: ageReplaced, gender: sex!)
  let eCarbs = Int(carbsToEnergy(carbs: Double(20)).rounded())
  let eProtein = Int(
    proteinsToEnergy(
      proteins: calculateProteinNeeded(weight: weightReplaced, bfp: bfp)
    ).rounded())
  let eFat = goalTDEE - eCarbs - eProtein

  //Test output:
  print("Fat: \(eFat) kcal")
  print("Carbs: \(eCarbs) kcal")
  print("Protein: \(eProtein) kcal")
  print("Total cals: \(goalTDEE) kcal")

  print("Fat(g): \(eFat / 9) g")
  print("Protein(g): \(calculateProteinNeeded(weight: weightReplaced, bfp: bfp)) g")
  print("Carbs(g): \(eCarbs / 4) g")

  UserDefaults.standard.set(eCarbs, forKey: "carbsMacros")
  UserDefaults.standard.set(eProtein, forKey: "proteinMacros")
  UserDefaults.standard.set(eFat, forKey: "fatMacros")
  UserDefaults.standard.set(goalTDEE, forKey: "calsTotalMacros")

}

recalculateMacros()
