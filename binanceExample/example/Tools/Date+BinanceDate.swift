//
//  Date+BinanceDate.swift
//  example
//
//  Created by 陳駿逸 on 2020/2/11.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit

extension Date {

    //---------------------------------------------------------------------------------------------------------------------------------------------
    func timestamp() -> Int64 {

        return Int64(self.timeIntervalSince1970 * 1000)
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------
    static func date(timestamp: Int64) -> Date {

        let interval = TimeInterval(TimeInterval(timestamp))
        return Date(timeIntervalSince1970: interval)
    }
}
