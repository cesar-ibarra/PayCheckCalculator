//
//  TableView.swift
//  PayCheckCalculator
//
//  Created by Cesar Ibarra on 3/16/25.
//

import Foundation
import SwiftUI

struct TableView: View {
    var viewModel: PaycheckViewModel
    
    var body: some View {
        VStack {
            Text("Salary Breakdown")
                .font(.headline)

            HStack {
                VStack(alignment: .leading) {
                    Text("Gross Income:")
                    Text("Federal Tax:")
                    Text("Social Security Tax:")
                    Text("Medicare Tax:")
                    Text("State Tax:")
                    Text("Net Income:")
                }
                .bold()
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("$\(viewModel.grossIncome, specifier: "%.2f")")
                    Text("-$\(viewModel.federalTax, specifier: "%.2f")")
                    Text("-$\(viewModel.socialSecurityTax, specifier: "%.2f")")
                    Text("-$\(viewModel.medicareTax, specifier: "%.2f")")
                    Text("-$\(viewModel.stateTax, specifier: "%.2f")")
                    Text("$\(viewModel.netIncome, specifier: "%.2f")")
                        .foregroundColor(.green)
                }
            }
            .padding()
        }
    }
}

#Preview {
    TableView(viewModel: PaycheckViewModel())
}
