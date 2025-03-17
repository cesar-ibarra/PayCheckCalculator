//
//  OnboardingView.swift
//  PayCheckCalculator
//
//  Created by Cesar Ibarra on 3/16/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var name: String = ""
    @AppStorage("userName") private var storedName: String?

    var body: some View {
        VStack {
            Text("Welcome to Paycheck Calculator!")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .padding()

            Text("Enter your name to personalize your experience.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 20)

            TextField("Your name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .multilineTextAlignment(.center)

            Button(action: {
                storedName = name // Guardar nombre en UserDefaults
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .disabled(name.isEmpty)
        }
        .padding()
    }
}

#Preview {
    OnboardingView()
}
