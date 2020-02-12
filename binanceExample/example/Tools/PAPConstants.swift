//
//  PAPConstants.swift
//  example
//
//  Created by 陳駿逸 on 2020/2/11.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit

// Notification
let KSBookTickerUpdateNotificationKey = "KSBookTickerUpdateNotification"
let KSTradeUpdateNotificationKey = "KSTradeUpdateNotification"
let KSDidEnterBackgroundNotificationKey = "KSDidEnterBackgroundNotification"
let KSWillEnterForegroundNotificationKey = "KSWillEnterForegroundNotification"
let KSReachabilityConnectedNotificationKey = "KSReachabilityConnectedNotification"
let KSReachabilityDisConnectedNotificationKey = "KSReachabilityDisConnectedNotification"
let KSWillMoveToPageNotificationKey = "KSWillMoveToPageNotification"
let KSDidMoveToPageNotificationKey = "KSDidMoveToPageNotification"

let KSSymbolKey = "BTCUSDT"
// Path
let binanceStreamPath = "wss://stream.binance.com:9443/stream?streams=btcusdt@bookTicker/btcusdt@trade"
let baseUrl = "https://www.binance.com/"
let getDepthPath = "api/v1/depth"
let getAggTradesPath = "api/v1/aggTrades"
let getExchangeInfoPath = "gateway-api/v1/public/asset-service/product/get-exchange-info"
