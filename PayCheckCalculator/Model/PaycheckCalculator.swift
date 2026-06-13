//
//  PaycheckCalculator.swift
//  PayCheckCalculator
//
//  Created by Cesar Ibarra on 3/16/25.
//

import Foundation

// MARK: - Enums

enum FilingStatus: String, CaseIterable, Identifiable {
    case single                  = "Single"
    case marriedFilingJointly    = "Married Filing Jointly"
    case marriedFilingSeparately = "Married Filing Separately"
    case headOfHousehold         = "Head of Household"
    var id: String { rawValue }
}

enum PayPeriod: String, CaseIterable, Identifiable {
    case weekly      = "Weekly"
    case biweekly    = "Bi-Weekly"
    case semimonthly = "Semi-Monthly"
    case monthly     = "Monthly"
    var id: String { rawValue }
    var periodsPerYear: Double {
        switch self {
        case .weekly:        return 52
        case .biweekly:      return 26
        case .semimonthly:   return 24
        case .monthly:       return 12
        }
    }
}

// MARK: - Tax Bracket

struct TaxBracket {
    let min: Double
    let max: Double
    let rate: Double
}

// MARK: - Calculator

struct PaycheckCalculator {

    // MARK: Standard Deductions 2024
    static func standardDeduction(filing: FilingStatus) -> Double {
        switch filing {
        case .single:                   return 14_600
        case .marriedFilingJointly:     return 29_200
        case .marriedFilingSeparately:  return 14_600
        case .headOfHousehold:          return 21_900
        }
    }

    // MARK: Federal Brackets 2024
    static func federalBrackets(filing: FilingStatus) -> [TaxBracket] {
        switch filing {
        case .single, .marriedFilingSeparately:
            return [
                TaxBracket(min:       0, max:  11_600, rate: 0.10),
                TaxBracket(min: 11_600,  max:  47_150, rate: 0.12),
                TaxBracket(min: 47_150,  max: 100_525, rate: 0.22),
                TaxBracket(min: 100_525, max: 191_950, rate: 0.24),
                TaxBracket(min: 191_950, max: 243_725, rate: 0.32),
                TaxBracket(min: 243_725, max: 609_350, rate: 0.35),
                TaxBracket(min: 609_350, max: .infinity, rate: 0.37)
            ]
        case .marriedFilingJointly:
            return [
                TaxBracket(min:       0, max:  23_200, rate: 0.10),
                TaxBracket(min: 23_200,  max:  94_300, rate: 0.12),
                TaxBracket(min: 94_300,  max: 201_050, rate: 0.22),
                TaxBracket(min: 201_050, max: 383_900, rate: 0.24),
                TaxBracket(min: 383_900, max: 487_450, rate: 0.32),
                TaxBracket(min: 487_450, max: 731_200, rate: 0.35),
                TaxBracket(min: 731_200, max: .infinity, rate: 0.37)
            ]
        case .headOfHousehold:
            return [
                TaxBracket(min:       0, max:  16_550, rate: 0.10),
                TaxBracket(min: 16_550,  max:  63_100, rate: 0.12),
                TaxBracket(min: 63_100,  max: 100_500, rate: 0.22),
                TaxBracket(min: 100_500, max: 191_950, rate: 0.24),
                TaxBracket(min: 191_950, max: 243_700, rate: 0.32),
                TaxBracket(min: 243_700, max: 609_350, rate: 0.35),
                TaxBracket(min: 609_350, max: .infinity, rate: 0.37)
            ]
        }
    }

    static func marginalTax(income: Double, brackets: [TaxBracket]) -> Double {
        var tax = 0.0
        for bracket in brackets {
            if income <= bracket.min { break }
            let taxable = min(income, bracket.max) - bracket.min
            tax += taxable * bracket.rate
        }
        return tax
    }

    // MARK: Federal Tax
    static func federalTax(
        taxableGross: Double,
        payPeriod: PayPeriod,
        filing: FilingStatus,
        extraWithholding: Double
    ) -> Double {
        let annualTaxable = max(0, taxableGross * payPeriod.periodsPerYear - standardDeduction(filing: filing))
        let annualTax = marginalTax(income: annualTaxable, brackets: federalBrackets(filing: filing))
        return (annualTax / payPeriod.periodsPerYear) + extraWithholding
    }

    // MARK: State Tax
    static func stateTax(taxableGross: Double, state: String) -> Double {
        let rates: [String: Double] = [
            "Alabama": 0.04, "Alaska": 0.0, "Arizona": 0.025, "Arkansas": 0.044,
            "California": 0.073, "Colorado": 0.044, "Connecticut": 0.050,
            "Delaware": 0.052, "Florida": 0.0, "Georgia": 0.0549, "Hawaii": 0.072,
            "Idaho": 0.058, "Illinois": 0.0495, "Indiana": 0.0305, "Iowa": 0.054,
            "Kansas": 0.053, "Kentucky": 0.045, "Louisiana": 0.030, "Maine": 0.060,
            "Maryland": 0.050, "Massachusetts": 0.05, "Michigan": 0.0405,
            "Minnesota": 0.065, "Mississippi": 0.047, "Missouri": 0.047,
            "Montana": 0.059, "Nebraska": 0.0584, "Nevada": 0.0,
            "New Hampshire": 0.0, "New Jersey": 0.063, "New Mexico": 0.049,
            "New York": 0.0609, "North Carolina": 0.045, "North Dakota": 0.0195,
            "Ohio": 0.030, "Oklahoma": 0.045, "Oregon": 0.085,
            "Pennsylvania": 0.0307, "Rhode Island": 0.0475, "South Carolina": 0.064,
            "South Dakota": 0.0, "Tennessee": 0.0, "Texas": 0.0, "Utah": 0.0465,
            "Vermont": 0.066, "Virginia": 0.055, "Washington": 0.0,
            "West Virginia": 0.055, "Wisconsin": 0.053, "Wyoming": 0.0,
            "District of Columbia": 0.072
        ]
        return taxableGross * (rates[state] ?? 0.0)
    }

    // MARK: CA SDI 2024 — 1.1%, no wage cap
    static func caSDITax(taxableGross: Double, state: String) -> Double {
        state == "California" ? taxableGross * 0.011 : 0.0
    }

    // MARK: Social Security — 6.2% up to $168,600/yr
    static func socialSecurityTax(taxableGross: Double, payPeriod: PayPeriod) -> Double {
        let annualCap = 168_600.0
        let annualTaxable = min(taxableGross * payPeriod.periodsPerYear, annualCap)
        return (annualTaxable * 0.062) / payPeriod.periodsPerYear
    }

    // MARK: Medicare — 1.45% (+ 0.9% over $200k/yr)
    static func medicareTax(taxableGross: Double, payPeriod: PayPeriod) -> Double {
        let annualGross = taxableGross * payPeriod.periodsPerYear
        var annualTax = annualGross * 0.0145
        if annualGross > 200_000 { annualTax += (annualGross - 200_000) * 0.009 }
        return annualTax / payPeriod.periodsPerYear
    }

    // MARK: - Result

    struct Result {
        let grossPay: Double
        let federalTaxableWages: Double
        let federalTax: Double
        let socialSecurityTax: Double
        let medicareTax: Double
        let stateTax: Double
        let caSDITax: Double
        let totalTaxes: Double
        let otherDeductions: Double
        let netPay: Double

        var effectiveTaxRate: Double {
            grossPay > 0 ? totalTaxes / grossPay : 0
        }
    }

    // MARK: - Calculate
    static func calculate(
        regularHours: Double,
        hourlyRate: Double,
        overtimeHours: Double,
        overtimeRate: Double,
        state: String,
        payPeriod: PayPeriod,
        filing: FilingStatus,
        extraWithholding: Double = 0,
        otherDeductions: Double = 0
    ) -> Result {
        let regularPay  = regularHours * hourlyRate
        let overtimePay = overtimeHours * overtimeRate
        let grossPay    = regularPay + overtimePay

        // Other deductions are pre-tax (reduce taxable wages)
        let taxableGross = max(0, grossPay - otherDeductions)

        let federal  = federalTax(taxableGross: taxableGross, payPeriod: payPeriod,
                                  filing: filing, extraWithholding: extraWithholding)
        let ss       = socialSecurityTax(taxableGross: taxableGross, payPeriod: payPeriod)
        let medicare = medicareTax(taxableGross: taxableGross, payPeriod: payPeriod)
        let stateT   = stateTax(taxableGross: taxableGross, state: state)
        let caSDI    = caSDITax(taxableGross: taxableGross, state: state)

        let totalTaxes = federal + ss + medicare + stateT + caSDI
        let netPay     = grossPay - totalTaxes - otherDeductions

        return Result(
            grossPay: grossPay,
            federalTaxableWages: taxableGross,
            federalTax: federal,
            socialSecurityTax: ss,
            medicareTax: medicare,
            stateTax: stateT,
            caSDITax: caSDI,
            totalTaxes: totalTaxes,
            otherDeductions: otherDeductions,
            netPay: netPay
        )
    }
}
