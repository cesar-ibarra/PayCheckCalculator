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

    // MARK: - Persisted Inputs (AppStorage via UserDefaults)
    var regularHours: Double {
        didSet { UserDefaults.standard.set(regularHours, forKey: "regularHours") }
    }
    var hourlyRate: Double {
        didSet { UserDefaults.standard.set(hourlyRate, forKey: "hourlyRate") }
    }
    var overtimeHours: Double {
        didSet { UserDefaults.standard.set(overtimeHours, forKey: "overtimeHours") }
    }
    var overtimeRate: Double {
        didSet { UserDefaults.standard.set(overtimeRate, forKey: "overtimeRate") }
    }
    var state: String {
        didSet { UserDefaults.standard.set(state, forKey: "state") }
    }
    var payPeriodRaw: String {
        didSet { UserDefaults.standard.set(payPeriodRaw, forKey: "payPeriodRaw") }
    }
    var filingStatusRaw: String {
        didSet { UserDefaults.standard.set(filingStatusRaw, forKey: "filingStatusRaw") }
    }
    var extraWithholding: Double {
        didSet { UserDefaults.standard.set(extraWithholding, forKey: "extraWithholding") }
    }
    var otherDeductions: Double {
        didSet { UserDefaults.standard.set(otherDeductions, forKey: "otherDeductions") }
    }

    // MARK: - Enum wrappers
    var payPeriod: PayPeriod {
        get { PayPeriod(rawValue: payPeriodRaw) ?? .semimonthly }
        set { payPeriodRaw = newValue.rawValue }
    }
    var filingStatus: FilingStatus {
        get { FilingStatus(rawValue: filingStatusRaw) ?? .single }
        set { filingStatusRaw = newValue.rawValue }
    }

    // MARK: - Init (restore from UserDefaults)
    init() {
        let ud = UserDefaults.standard
        regularHours    = ud.object(forKey: "regularHours")    as? Double ?? 80.0
        hourlyRate      = ud.object(forKey: "hourlyRate")      as? Double ?? 24.0
        overtimeHours   = ud.object(forKey: "overtimeHours")   as? Double ?? 0.0
        overtimeRate    = ud.object(forKey: "overtimeRate")    as? Double ?? 36.0
        state           = ud.string(forKey: "state")           ?? "California"
        payPeriodRaw    = ud.string(forKey: "payPeriodRaw")    ?? PayPeriod.semimonthly.rawValue
        filingStatusRaw = ud.string(forKey: "filingStatusRaw") ?? FilingStatus.single.rawValue
        extraWithholding = ud.object(forKey: "extraWithholding") as? Double ?? 0.0
        otherDeductions  = ud.object(forKey: "otherDeductions")  as? Double ?? 0.0
    }

    // MARK: - Reset
    func reset() {
        regularHours     = 0.0
        hourlyRate       = 0.0
        overtimeHours    = 0.0
        overtimeRate     = 0.0
        extraWithholding = 0.0
        otherDeductions  = 0.0
        state            = "California"
        payPeriod        = .semimonthly
        filingStatus     = .single
    }

    // MARK: - Computed Result
    var result: PaycheckCalculator.Result {
        PaycheckCalculator.calculate(
            regularHours: regularHours,
            hourlyRate: hourlyRate,
            overtimeHours: overtimeHours,
            overtimeRate: overtimeRate,
            state: state,
            payPeriod: payPeriod,
            filing: filingStatus,
            extraWithholding: extraWithholding,
            otherDeductions: otherDeductions
        )
    }

    // MARK: - Convenience
    var grossPay: Double            { result.grossPay }
    var netPay: Double              { result.netPay }
    var federalTax: Double          { result.federalTax }
    var socialSecurityTax: Double   { result.socialSecurityTax }
    var medicareTax: Double         { result.medicareTax }
    var stateTax: Double            { result.stateTax }
    var caSDITax: Double            { result.caSDITax }
    var totalTaxes: Double          { result.totalTaxes }
    var effectiveTaxRate: Double    { result.effectiveTaxRate }
    var federalTaxableWages: Double { result.federalTaxableWages }
    var showCASDI: Bool             { state == "California" }
}
