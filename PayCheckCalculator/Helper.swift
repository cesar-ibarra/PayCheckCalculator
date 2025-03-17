//
//  Helper.swift
//  PayCheckCalculator
//
//  Created by Cesar Ibarra on 3/16/25.
//

import Foundation
import SwiftUI

extension View {
    func doneToolbar() -> some View {
        self.toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    hideKeyboard()
                }
            }
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
