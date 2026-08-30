//
//  RemoveAdsTip.swift
//  PayCheckCalculator
//
//  Created by Cesar Ibarra on 8/29/26.
//

import TipKit

struct RemoveAdsTip: Tip {
    var title: Text {
        Text("Remove Ads")
    }

    var message: Text? {
        Text(RemoveAdsConfig.sheetMessage)
    }

    var image: Image? {
        Image(systemName: "sparkles")
    }
}
