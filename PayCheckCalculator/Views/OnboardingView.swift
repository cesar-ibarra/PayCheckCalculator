//
//  OnboardingView.swift
//  PayCheckCalculator
//
//  Created by Cesar Ibarra on 3/16/25.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("userName") private var storedName: String?
    @State private var name: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Icon
            Image(systemName: "dollarsign.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)
                .padding(.bottom, 24)

            // Title
            Text("Paycheck Calculator")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)

            Text("Estimates your take-home pay\nquickly and accurately.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
                .padding(.bottom, 48)

            // Name field
            VStack(alignment: .leading, spacing: 8) {
                Text("What's your name?")
                    .font(.headline)
                    .foregroundStyle(.primary)

                TextField("Enter your name", text: $name)
                    .font(.system(size: 22, weight: .medium))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(.secondarySystemBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(isFocused ? Color.blue : Color.clear, lineWidth: 2)
                            )
                    )
                    .focused($isFocused)
                    .submitLabel(.done)
                    .onSubmit { saveAndContinue() }
            }
            .padding(.horizontal, 32)

            Spacer()

            // Continue button
            Button(action: saveAndContinue) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        name.trimmingCharacters(in: .whitespaces).isEmpty
                            ? Color.blue.opacity(0.4)
                            : Color.blue,
                        in: RoundedRectangle(cornerRadius: 14, style: .continuous)
                    )
            }
            .buttonStyle(.plain)
            .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            .padding(.horizontal, 32)
            .padding(.bottom, 48)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onAppear { isFocused = true }
    }

    private func saveAndContinue() {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        storedName = trimmed
    }
}

#Preview {
    OnboardingView()
}
