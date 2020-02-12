//
//  Error+BinanceError.swift
//  example
//
//  Created by 陳駿逸 on 2020/2/11.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit

// MARK: - BinanceError

struct BinanceError: Error {
    let fromType: Any.Type
    let toType: Any.Type
    init<FromType, ToType>(fromType: FromType.Type, toType: ToType.Type) {
        self.fromType = fromType
        self.toType = toType
    }
}

struct BinanceHttpsError: Error, Codable {
    let code: Int
    let msg: String
}

extension BinanceError: LocalizedError {
    var localizedDescription: String { return "Can not cast from \(fromType) to \(toType)" }
}

extension BinanceError: CustomStringConvertible { var description: String { return localizedDescription } }
