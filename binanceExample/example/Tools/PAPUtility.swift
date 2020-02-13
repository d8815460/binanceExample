//
//  PAPUtility.swift
//  example
//
//  Created by 陳駿逸 on 2020/2/13.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit

class PAPUtility: NSObject {
    class func decoderBookTicker(data: Data, handler: @escaping (_ booktickerstream: BookTickerStream?, _ error: NSError?) -> Void) {
        let model = try? JSONDecoder().decode(BookTickerStream.self, from: data)
        handler(model, nil)
    }
    
    class func decoderTrade(data: Data, handler: @escaping (_ tradestream: TradeStream?, _ error: NSError?) -> Void) {
        let model = try? JSONDecoder().decode(TradeStream.self, from: data)
        handler(model, nil)
    }
    
    class func decoderDepth(data: Data, handler: @escaping (_ depthstream: DepthStream?, _ error: NSError?) -> Void) {
        let model = try? JSONDecoder().decode(DepthStream.self, from: data)
        handler(model, nil)
    }
    
    class func postNotificationWithKey(key: String) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: key), object: nil)
    }
    
    // 計算小數點位數
    class func decimalPlace(minTickSize: String) -> Int {
        let array = minTickSize.components(separatedBy: ".")
        var count = 1
        for character in array[1] {
            if character != "1" {
                count = count + 1
            }
        }
        return count
    }
}
