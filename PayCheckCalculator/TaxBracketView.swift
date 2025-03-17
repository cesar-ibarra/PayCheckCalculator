//
//  TaxBracketView.swift
//  PayCheckCalculator
//
//  Created by Cesar Ibarra on 3/16/25.
//

import Foundation
import SwiftUI

struct TaxBracketView: View {
    var taxBreakdown: [(String, Double)]

    var body: some View {
        VStack {
            Text("Tax Breakdown")
                .font(.headline)
                .padding(.top)

            List {
                ForEach(taxBreakdown, id: \.0) { bracket, tax in
                    HStack {
                        Text(bracket)
                            .font(.subheadline)
                        Spacer()
                        Text("$\(tax, specifier: "%.2f")")
                            .foregroundColor(.red)
                    }
                }
            }
            .frame(height: 250)
        }
        .padding()
    }
}

#Preview {
    TaxBracketView(taxBreakdown: [
            ("Up to $9,325", 93.25),
            ("Up to $22,107", 254.15),
            ("Up to $34,892", 458.20),
            ("Up to $48,435", 811.50)
        ])
}
