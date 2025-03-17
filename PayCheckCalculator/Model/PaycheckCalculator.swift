//
//  PaycheckCalculator.swift
//  PayCheckCalculator
//
//  Created by Cesar Ibarra on 3/16/25.
//

import Foundation

struct PaycheckCalculator {
    
    // Cálculo del impuesto federal según las tablas del IRS (simplificado)
    static func calculateFederalTax(income: Double) -> Double {
        switch income {
        case 0...11000: return income * 0.10
        case 11001...44725: return income * 0.12
        case 44726...95375: return income * 0.22
        case 95376...182100: return income * 0.24
        default: return income * 0.32
        }
    }

    // Cálculo del impuesto estatal con tasas fijas y progresivas
    static func calculateStateTax(income: Double, state: String) -> Double {
        let stateRates: [String: Double] = [
            "Alabama": 0.05, "Alaska": 0.0, "Arizona": 0.025, "Arkansas": 0.049,
            "California": 0.093, "Colorado": 0.0463, "Connecticut": 0.0699, "Delaware": 0.066,
            "Florida": 0.0, "Georgia": 0.0575, "Hawaii": 0.0825, "Idaho": 0.058,
            "Illinois": 0.0495, "Indiana": 0.0323, "Iowa": 0.0596, "Kansas": 0.057,
            "Kentucky": 0.05, "Louisiana": 0.0485, "Maine": 0.0715, "Maryland": 0.0575,
            "Massachusetts": 0.05, "Michigan": 0.0425, "Minnesota": 0.0785, "Mississippi": 0.047,
            "Missouri": 0.0495, "Montana": 0.0675, "Nebraska": 0.0684, "Nevada": 0.0,
            "New Hampshire": 0.0, "New Jersey": 0.0897, "New Mexico": 0.049, "New York": 0.0685,
            "North Carolina": 0.0475, "North Dakota": 0.029, "Ohio": 0.02975, "Oklahoma": 0.0475,
            "Oregon": 0.0875, "Pennsylvania": 0.0307, "Rhode Island": 0.0599, "South Carolina": 0.07,
            "South Dakota": 0.0, "Tennessee": 0.0, "Texas": 0.0, "Utah": 0.0485,
            "Vermont": 0.0875, "Virginia": 0.0575, "Washington": 0.0, "West Virginia": 0.065,
            "Wisconsin": 0.0627, "Wyoming": 0.0, "District of Columbia": 0.085
        ]
        return income * (stateRates[state] ?? 0.0)
    }

    // Cálculo de Social Security Tax (6.2%)
    static func calculateSocialSecurityTax(income: Double) -> Double {
        let maxWageBase = 168600.0 // Límite 2024
        return min(income, maxWageBase) * 0.062
    }

    // Cálculo de Medicare Tax (1.45%)
    static func calculateMedicareTax(income: Double) -> Double {
        return income * 0.0145
    }
}
