//
//  PayCheckCalculatorApp.swift
//  PayCheckCalculator
//
//  Created by Cesar Ibarra on 3/16/25.
//

import SwiftUI
import TipKit

@main
struct PayCheckCalculatorApp: App {
    @AppStorage("userName") private var storedName: String?

    init() {
        try? Tips.configure()
    }

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
