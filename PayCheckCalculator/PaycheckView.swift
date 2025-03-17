//
//  ContentView.swift
//  PayCheckCalculator
//
//  Created by Cesar Ibarra on 3/16/25.
//

import SwiftUI

struct PaycheckView: View {
    @State private var viewModel = PaycheckViewModel()
    @AppStorage("userName") private var storedName: String?
    
    let states = [
        "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware",
        "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky",
        "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri",
        "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York",
        "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island",
        "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia",
        "Washington", "West Virginia", "Wisconsin", "Wyoming", "District of Columbia"
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                if let name = storedName {
                    Text("Welcome, \(name)!")
                        .font(.title)
                        .bold()
                        .padding(.bottom, 10)
                }
                Text("Paycheck Calculator")
                    .font(.largeTitle)
                    .bold()
                
                // Tabla de cálculos
                TableView(viewModel: viewModel)
                
                // Configuración en tiempo real
                Form {
                    Section(header: Text("Work Details")) {
                        Stepper("Hours worked: \(viewModel.hoursWorked)", value: $viewModel.hoursWorked, in: 0...200)
                        TextField("Hourly Rate", value: $viewModel.hourlyRate, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                    }
                    
                    Section(header: Text("Overtime")) {
                        Stepper("Overtime Hours: \(viewModel.overtimeHours)", value: $viewModel.overtimeHours, in: 0...100)
                        TextField("Overtime Rate", value: $viewModel.overtimeRate, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                    }
                    
                    Section(header: Text("State Selection")) {
                        Picker("State", selection: $viewModel.state) {
                            ForEach(states, id: \.self) { state in
                                Text(state)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                .doneToolbar()
            }
            .padding()
        }
    }
}

#Preview {
    PaycheckView()
}
