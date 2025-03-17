//
//  PayCheck.swift
//  PayCheckCalculator
//
//  Created by Cesar Ibarra on 3/16/25.
//

import Foundation
import SwiftData

@Model
class Paycheck {
    var grossIncome: Double
    var federalTax: Double
    var socialSecurityTax: Double
    var medicareTax: Double
    var stateTax: Double
    var netIncome: Double
    var hoursWorked: Int
    var hourlyRate: Double
    var state: String

    init(hoursWorked: Int, hourlyRate: Double, state: String) {
        self.hoursWorked = hoursWorked
        self.hourlyRate = hourlyRate
        self.state = state

        // Primero, calcular Gross Income
        let calculatedGrossIncome = Double(hoursWorked) * hourlyRate

        // Luego, calcular impuestos usando variables locales
        let calculatedFederalTax = PaycheckCalculator.calculateFederalTax(income: calculatedGrossIncome)
        let calculatedSocialSecurityTax = PaycheckCalculator.calculateSocialSecurityTax(income: calculatedGrossIncome)
        let calculatedMedicareTax = PaycheckCalculator.calculateMedicareTax(income: calculatedGrossIncome)
        let calculatedStateTax = PaycheckCalculator.calculateStateTax(income: calculatedGrossIncome, state: state)

        // Calcular Net Income
        let calculatedNetIncome = calculatedGrossIncome - (calculatedFederalTax + calculatedSocialSecurityTax + calculatedMedicareTax + calculatedStateTax)

        // Finalmente, asignar los valores a las propiedades
        self.grossIncome = calculatedGrossIncome
        self.federalTax = calculatedFederalTax
        self.socialSecurityTax = calculatedSocialSecurityTax
        self.medicareTax = calculatedMedicareTax
        self.stateTax = calculatedStateTax
        self.netIncome = calculatedNetIncome
    }
}
