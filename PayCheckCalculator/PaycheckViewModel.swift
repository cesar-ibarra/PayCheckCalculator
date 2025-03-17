//
//  PaycheckViewModel.swift
//  PayCheckCalculator
//
//  Created by Cesar Ibarra on 3/16/25.
//

import Foundation
import SwiftUI

@Observable
class PaycheckViewModel {
    var hoursWorked: Int = 88
    var hourlyRate: Double = 22.0
    var overtimeHours: Int = 0
    var overtimeRate: Double = 33.0
    var state: String = "California"

    // Calcular Ingresos Totales (Regular + Overtime)
    var grossIncome: Double {
        let regularIncome = Double(hoursWorked) * hourlyRate
        let overtimeIncome = Double(overtimeHours) * overtimeRate
        return regularIncome + overtimeIncome
    }

    // Cálculo de Impuestos
    var federalTax: Double {
        PaycheckCalculator.calculateFederalTax(income: grossIncome)
    }

    var socialSecurityTax: Double {
        PaycheckCalculator.calculateSocialSecurityTax(income: grossIncome)
    }

    var medicareTax: Double {
        PaycheckCalculator.calculateMedicareTax(income: grossIncome)
    }

    var stateTax: Double {
        PaycheckCalculator.calculateStateTax(income: grossIncome, state: state)
    }

    // Ingreso Neto después de deducciones
    var netIncome: Double {
        grossIncome - (federalTax + socialSecurityTax + medicareTax + stateTax)
    }
}
