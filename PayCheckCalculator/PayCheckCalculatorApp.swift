//
//  PayCheckCalculatorApp.swift
//  PayCheckCalculator
//
//  Created by Cesar Ibarra on 3/16/25.
//

import SwiftUI

@main
struct PayCheckCalculatorApp: App {
    @AppStorage("userName") private var storedName: String?
    var body: some Scene {
        WindowGroup {
            if storedName == nil {
                OnboardingView()
            } else {
                PaycheckView()
            }
        }
    }
}
