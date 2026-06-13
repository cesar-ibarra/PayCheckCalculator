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
    var grossPay: Double
    var federalTax: Double
    var socialSecurityTax: Double
    var medicareTax: Double
    var stateTax: Double
    var caSDITax: Double
    var netPay: Double
    var regularHours: Double
    var overtimeHours: Double
    var hourlyRate: Double
    var overtimeRate: Double
    var state: String
    var payPeriodRaw: String
    var filingStatusRaw: String

    init(
        regularHours: Double,
        hourlyRate: Double,
        overtimeHours: Double = 0,
        overtimeRate: Double = 0,
        state: String,
        payPeriod: PayPeriod = .biweekly,
        filing: FilingStatus = .single
    ) {
        self.regularHours = regularHours
        self.hourlyRate = hourlyRate
        self.overtimeHours = overtimeHours
        self.overtimeRate = overtimeRate
        self.state = state
        self.payPeriodRaw = payPeriod.rawValue
        self.filingStatusRaw = filing.rawValue

        let result = PaycheckCalculator.calculate(
            regularHours: regularHours,
            hourlyRate: hourlyRate,
            overtimeHours: overtimeHours,
            overtimeRate: overtimeRate,
            state: state,
            payPeriod: payPeriod,
            filing: filing
        )

        self.grossPay = result.grossPay
        self.federalTax = result.federalTax
        self.socialSecurityTax = result.socialSecurityTax
        self.medicareTax = result.medicareTax
        self.stateTax = result.stateTax
        self.caSDITax = result.caSDITax
        self.netPay = result.netPay
    }
}

