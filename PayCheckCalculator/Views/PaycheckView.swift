//
//  ContentView.swift
//  PayCheckCalculator
//
//  Created by Cesar Ibarra on 3/16/25.
//

import SwiftUI

struct PaycheckView: View {
    @State private var viewModel = PaycheckViewModel()
    @State private var showResults = false

    let states = [
        "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado",
        "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho",
        "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana",
        "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota",
        "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada",
        "New Hampshire", "New Jersey", "New Mexico", "New York",
        "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon",
        "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota",
        "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington",
        "West Virginia", "Wisconsin", "Wyoming", "District of Columbia"
    ]

    var body: some View {
        @Bindable var vm = viewModel

        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // MARK: - Input Form (always visible)
                    InputCard(title: "Pay Details", systemImage: "clock.fill") {
                        InputRow(label: "Regular Hours") {
                            NumericField(value: $vm.regularHours,
                                         format: .number.precision(.fractionLength(2)))
                        }
                        InputRow(label: "Hourly Rate") {
                            NumericField(value: $vm.hourlyRate,
                                         format: .currency(code: "USD"))
                        }
                        InputRow(label: "OT Hours") {
                            NumericField(value: $vm.overtimeHours,
                                         format: .number.precision(.fractionLength(2)))
                        }
                        InputRow(label: "OT Rate", showDivider: false) {
                            NumericField(value: $vm.overtimeRate,
                                         format: .currency(code: "USD"))
                        }
                    }

                    // MARK: - Calculate Button
                    Button {
                        hideKeyboard()
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            showResults = true
                        }
                    } label: {
                        Text("Calculate")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(.blue, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    
                    AdMobBanner()
                        .frame(width: 320, height: 50)
                        .transition(.opacity)
                    
                    // MARK: - Results (animated in)
                    if showResults {
                        VStack(spacing: 16) {

                            NetPayHeroCard(viewModel: viewModel)
                                .transition(.asymmetric(
                                    insertion: .opacity.combined(with: .move(edge: .bottom)),
                                    removal: .opacity.combined(with: .move(edge: .top))
                                ))

                            TaxBreakdownCard(viewModel: viewModel)
                                .transition(.asymmetric(
                                    insertion: .opacity.combined(with: .move(edge: .bottom)),
                                    removal: .opacity.combined(with: .move(edge: .top))
                                ))

                            // More Settings
                            InputCard(title: "Tax Settings", systemImage: "building.columns.fill") {
                                InputRow(label: "Pay Period") {
                                    Picker("", selection: $vm.payPeriod) {
                                        ForEach(PayPeriod.allCases) { Text($0.rawValue).tag($0) }
                                    }
                                    .pickerStyle(.menu).tint(.primary)
                                }
                                InputRow(label: "Filing Status") {
                                    Picker("", selection: $vm.filingStatus) {
                                        ForEach(FilingStatus.allCases) { Text($0.rawValue).tag($0) }
                                    }
                                    .pickerStyle(.menu).tint(.primary)
                                }
                                InputRow(label: "State") {
                                    Picker("", selection: $vm.state) {
                                        ForEach(states, id: \.self) { Text($0) }
                                    }
                                    .pickerStyle(.menu).tint(.primary)
                                }
                                InputRow(label: "Other Deductions") {
                                    NumericField(value: $vm.otherDeductions,
                                                 format: .currency(code: "USD"))
                                }
                                InputRow(label: "Extra Withholding", showDivider: false) {
                                    NumericField(value: $vm.extraWithholding,
                                                 format: .currency(code: "USD"))
                                }
                            }
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .move(edge: .bottom)),
                                removal: .opacity.combined(with: .move(edge: .top))
                            ))

                            Text("Estimates based on 2024 IRS tax tables.\nActual withholding may vary.")
                                .font(.footnote)
                                .foregroundStyle(.tertiary)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 12)
                                .transition(.opacity)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Paycheck Calculator")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if showResults {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                                viewModel.reset()
                                showResults = false
                            }
                        } label: {
                            Label("Clear", systemImage: "arrow.counterclockwise")
                                .font(.subheadline)
                        }
                        .tint(.red)
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { hideKeyboard() }
                }
            }
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}

// MARK: - Net Pay Hero

struct NetPayHeroCard: View {
    var viewModel: PaycheckViewModel

    var body: some View {
        VStack(spacing: 8) {
            Text("Estimated Take-Home")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(viewModel.netPay, format: .currency(code: "USD"))
                .font(.system(size: 56, weight: .bold, design: .rounded))
                .foregroundStyle(viewModel.netPay > 0 ? Color.green : Color.red)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.35), value: viewModel.netPay)

            HStack(spacing: 4) {
                Image(systemName: "percent").font(.subheadline)
                Text("\(viewModel.effectiveTaxRate * 100, specifier: "%.1f")% effective tax rate")
                    .font(.subheadline)
            }
            .foregroundStyle(.secondary)

            Divider().padding(.top, 8)

            HStack {
                SummaryPill(label: "Gross Pay",   value: viewModel.grossPay,   color: .blue)
                Spacer()
                SummaryPill(label: "Total Taxes", value: viewModel.totalTaxes, color: .red)
            }
            .padding(.top, 6)
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct SummaryPill: View {
    let label: String
    let value: Double
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(value, format: .currency(code: "USD"))
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(color)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.35), value: value)
        }
    }
}

// MARK: - Tax Breakdown Card

struct TaxBreakdownCard: View {
    var viewModel: PaycheckViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader(title: "Tax Breakdown", systemImage: "list.bullet.rectangle")
                .padding(.bottom, 14)

            VStack(spacing: 2) {
                BreakdownRow(label: "Federal Income Tax",
                             value: viewModel.federalTax,
                             pct: pct(viewModel.federalTax),
                             color: .orange)
                BreakdownRow(label: "Social Security",
                             value: viewModel.socialSecurityTax,
                             pct: pct(viewModel.socialSecurityTax),
                             color: .purple)
                BreakdownRow(label: "Medicare",
                             value: viewModel.medicareTax,
                             pct: pct(viewModel.medicareTax),
                             color: .pink)
                BreakdownRow(label: "\(viewModel.state) State Tax",
                             value: viewModel.stateTax,
                             pct: pct(viewModel.stateTax),
                             color: .teal)
                if viewModel.showCASDI {
                    BreakdownRow(label: "CA SDI",
                                 value: viewModel.caSDITax,
                                 pct: pct(viewModel.caSDITax),
                                 color: .cyan)
                }
                if viewModel.result.otherDeductions > 0 {
                    BreakdownRow(label: "Other Deductions",
                                 value: viewModel.result.otherDeductions,
                                 pct: pct(viewModel.result.otherDeductions),
                                 color: .gray,
                                 showDivider: false)
                }
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func pct(_ value: Double) -> Double {
        viewModel.grossPay > 0 ? value / viewModel.grossPay : 0
    }
}

struct BreakdownRow: View {
    let label: String
    let value: Double
    let pct: Double
    let color: Color
    var showDivider: Bool = true

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Circle().fill(color).frame(width: 10, height: 10)
                Text(label).font(.body)
                Spacer()
                Text(value, format: .currency(code: "USD"))
                    .font(.body.monospacedDigit())
                    .fontWeight(.medium)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.35), value: value)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(color.opacity(0.15))
                        .frame(height: 5)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(color)
                        .frame(width: geo.size.width * min(pct * 3, 1.0), height: 5)
                        .animation(.spring(response: 0.5), value: pct)
                }
            }
            .frame(height: 5)
        }
        .padding(.vertical, 10)
        if showDivider { Divider() }
    }
}

// MARK: - Shared Components

struct InputCard<Content: View>: View {
    let title: String
    let systemImage: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader(title: title, systemImage: systemImage)
                .padding(.bottom, 14)
            content
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct InputRow<Content: View>: View {
    let label: String
    var showDivider: Bool = true
    @ViewBuilder var content: Content

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(label).font(.body).foregroundStyle(.primary)
                Spacer()
                content
            }
            .padding(.vertical, 10)
            if showDivider { Divider() }
        }
    }
}

struct NumericField<F: ParseableFormatStyle>: View
where F.FormatOutput == String, F.FormatInput == Double {
    @Binding var value: Double
    let format: F

    var body: some View {
        TextField("", value: $value, format: format)
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)
            .frame(width: 120)
            .font(.body.monospacedDigit())
    }
}

struct SectionHeader: View {
    let title: String
    let systemImage: String

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
            .tracking(0.5)
    }
}

#Preview {
    PaycheckView()
}
