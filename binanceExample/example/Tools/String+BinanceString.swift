//
//  String+BinanceString.swift
//  example
//
//  Created by 陳駿逸 on 2020/2/11.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit

// MARK: - String cast extensions

extension String {
    func asJSON<T>(to type: T.Type, using encoding: String.Encoding = .utf8) throws -> T {
        guard let data = data(using: encoding) else { throw BinanceError(fromType: type, toType: T.self) }
        return try data.to(type: T.self)
    }

    func asJSONToDictionary(using encoding: String.Encoding = .utf8) throws -> [String: Any] {
        return try asJSON(to: [String: Any].self, using: encoding)
    }
}
