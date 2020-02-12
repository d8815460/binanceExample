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

struct TradeStream: Hashable, Codable {
    var stream: String
    var data: Trade
}

struct DepthStream: Hashable, Codable {
    var stream: String
    var data: Depth
}


struct BookTicker: Hashable, Codable {
    var u: Int
    var s: String
    var b: String
    var B: String
    var a: String
    var A: String
}

struct Trade: Hashable, Codable {
    var e: String
    var E: CGFloat
    var s: String
    var t: CGFloat
    var p: String
    var q: String
    var b: CGFloat
    var a: CGFloat
    var T: CGFloat
    var m: Bool
    var M: Bool
}

struct Depth: Hashable, Codable {
    var e: String
    var E: Int
    var s: String
    var U: Int
    var u: Int
    var b: [[String]]
}

