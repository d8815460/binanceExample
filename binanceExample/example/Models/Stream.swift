//
//  Stream.swift
//  SimpleTest
//
//  Created by 陳駿逸 on 2020/2/9.
//  Copyright © 2020 vluxe. All rights reserved.
//

import UIKit

struct BookTickerStream: Hashable, Codable {
    var stream: String
    var data: BookTicker
}

struct BookTicker: Hashable, Codable {
    var u: Int
    var s: String
    var b: String
    var B: String
    var a: String
    var A: String
}

struct DepthStream: Hashable, Codable {
    var stream: String
    var data: Depth
}


struct TradeStream: Hashable, Codable {
    var stream: String
    var data: Trade
}

struct Trade: Hashable, Codable {
    var e: String       // Event type
    var E: Int64        // Event time
    var s: String       // Symbol
    var t: Int          // Trade ID
    var p: String       // Price
    var q: String       // Quantity
    var b: Int          // Buyer order ID
    var a: Int          // Seller order ID
    var T: Int64        // Trade time
    var m: Bool         // Is the buyer the market maker?
    var M: Bool         // Ignore
}

struct AggTrades: Hashable, Codable {
    var a: Int
    var p: String       // Price
    var q: String       // Quantity
    var f: Int
    var l: Int
    var T: Int64        // Trade time
    var m: Bool
    var M: Bool
}

struct DisplayTrades: Hashable, Codable {
    var T: Int64        // Trade time
    var p: String       // Price
    var q: String       // Quantity
}

struct Depth: Hashable, Codable {
    var e: String
    var E: Int
    var s: String
    var U: Int64
    var u: Int64
    var b: [[String]]
}

struct DepthJSON: Hashable, Codable {
    var lastUpdateId: Int64
    var bids:[[String]]
    var asks:[[String]]
}

struct ExchangeInfo: Hashable, Codable {
    var code: String
    var message: String?
    var messageDetail:String?
    var data:[ExchangeData]
    var success: Bool
}

struct ExchangeData: Hashable, Codable {
    var baseAsset: String
    var maxMarketOrderQty: String
    var minMarketOrderQty: String?
    var minOrderValue: String
    var minTickSize: String
    var minTradeAmount: String
    var quoteAsset: String
}
