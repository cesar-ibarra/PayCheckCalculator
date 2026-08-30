//
//  RemoveAdsSheetView.swift
//  PayCheckCalculator
//
//  Created by Cesar Ibarra on 8/29/26.
//

import SwiftUI

struct RemoveAdsSheetView: View {
    @ObservedObject var iap = IAPManager.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "sparkles")
                    .font(.system(size: 56))
                    .foregroundStyle(Color.accentColor)

                Text(RemoveAdsConfig.sheetTitle)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)

                Text(RemoveAdsConfig.sheetMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Button {
                    Task { await iap.purchaseRemoveAds() }
                } label: {
                    if iap.isLoading {
                        ProgressView().frame(maxWidth: .infinity)
                    } else {
                        Text("Remove Ads — \(priceLabel)")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(iap.removeAdsProduct == nil || iap.isLoading)

                Button("Restore Purchase") {
                    Task { await iap.restorePurchases() }
                }
                .font(.footnote)
                .foregroundStyle(.secondary)

                Spacer()
            }
            .padding()
            .padding(.top, 40)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }

    private var priceLabel: String {
        iap.removeAdsProduct?.displayPrice ?? "…"
    }
}

#Preview {
    RemoveAdsSheetView()
}
