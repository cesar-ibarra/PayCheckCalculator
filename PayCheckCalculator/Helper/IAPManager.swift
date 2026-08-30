//
//  IAPManager.swift
//  PayCheckCalculator
//
//  Created by Cesar Ibarra on 8/29/26.
//

import StoreKit

@MainActor
final class IAPManager: ObservableObject {
    static let shared = IAPManager()

    @Published private(set) var hasRemovedAds: Bool = false
    @Published private(set) var removeAdsProduct: Product?
    @Published private(set) var isLoading: Bool = false

    private var updatesTask: Task<Void, Never>?

    private init() {
        updatesTask = listenForTransactionUpdates()
        Task {
            await loadProducts()
            await refreshEntitlements()
        }
    }

    deinit {
        updatesTask?.cancel()
    }

    func loadProducts() async {
        do {
            let products = try await Product.products(for: [RemoveAdsConfig.productID])
            removeAdsProduct = products.first
        } catch {
            print("⚠️ IAP — error cargando productos: \(error)")
        }
    }

    func purchaseRemoveAds() async {
        guard let product = removeAdsProduct else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await transaction.finish()
                    hasRemovedAds = true
                }
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            print("⚠️ IAP — error en la compra: \(error)")
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await refreshEntitlements()
        } catch {
            print("⚠️ IAP — error restaurando compras: \(error)")
        }
    }

    private func refreshEntitlements() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == RemoveAdsConfig.productID {
                hasRemovedAds = true
            }
        }
    }

    private func listenForTransactionUpdates() -> Task<Void, Never> {
        Task {
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await transaction.finish()
                    if transaction.productID == RemoveAdsConfig.productID {
                        hasRemovedAds = true
                    }
                }
            }
        }
    }
}
