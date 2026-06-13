//
//  ChartView.swift
//  PayCheckCalculator
//
//  Created by Cesar Ibarra on 3/16/25.
//

import SwiftUI
import Charts

struct ChartView: View {
    var viewModel: PaycheckViewModel

    var body: some View {
        VStack {
            Text("Income & Deductions Breakdown")
                .font(.headline)

            Chart {
                BarMark(
                    x: .value("Category", "Gross Pay"),
                    y: .value("Amount", viewModel.grossPay)
                )
                .foregroundStyle(.green)

                BarMark(
                    x: .value("Category", "Federal Tax"),
                    y: .value("Amount", viewModel.federalTax)
                )
                .foregroundStyle(.red)

                BarMark(
                    x: .value("Category", "Social Security"),
                    y: .value("Amount", viewModel.socialSecurityTax)
                )
                .foregroundStyle(.blue)

                BarMark(
                    x: .value("Category", "Medicare"),
                    y: .value("Amount", viewModel.medicareTax)
                )
                .foregroundStyle(.purple)

                BarMark(
                    x: .value("Category", "State Tax"),
                    y: .value("Amount", viewModel.stateTax)
                )
                .foregroundStyle(.orange)

                if viewModel.showCASDI {
                    BarMark(
                        x: .value("Category", "CA SDI"),
                        y: .value("Amount", viewModel.caSDITax)
                    )
                    .foregroundStyle(.cyan)
                }

                BarMark(
                    x: .value("Category", "Net Pay"),
                    y: .value("Amount", viewModel.netPay)
                )
                .foregroundStyle(.green.opacity(0.7))
            }
            .frame(height: 300)
            .padding()
        }
    }
}

#Preview {
    ChartView(viewModel: PaycheckViewModel())
}
