//
//  AdMobInterstitial.swift
//  PayCheckCalculator
//
//  Created by Cesar Ibarra on 8/29/26.
//

import SwiftUI
import GoogleMobileAds

final class InterstitialAdManager: NSObject, ObservableObject, FullScreenContentDelegate {

    @Published var isReady = false
    var onDismiss: (() -> Void)?

    private var interstitial: InterstitialAd?

    // Production ID
    private let adUnitID = "ca-app-pub-9405221176366476/7018739415"

    // Test ID — use this while developing:
    // private let adUnitID = "ca-app-pub-3940256099942544/4411468910"

    override init() {
        super.init()
        loadAd()
    }

    func loadAd() {
        Task { @MainActor in
            do {
                interstitial = try await InterstitialAd.load(
                    with: adUnitID,
                    request: Request()
                )
                interstitial?.fullScreenContentDelegate = self
                isReady = true
            } catch {
                print("⚠️ Interstitial failed to load: \(error)")
                isReady = false
            }
        }
    }

    func show(from rootVC: UIViewController) {
        guard let ad = interstitial else { return }
        ad.present(from: rootVC)
    }

    // MARK: - FullScreenContentDelegate

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        isReady = false
        onDismiss?()
        onDismiss = nil
        loadAd() // preload next
    }

    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("⚠️ Interstitial failed to present: \(error)")
        isReady = false
        onDismiss?()
        onDismiss = nil
        loadAd()
    }
}

