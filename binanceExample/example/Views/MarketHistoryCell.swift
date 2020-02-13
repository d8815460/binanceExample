//
//  MarketHistoryCell.swift
//  example
//
//  Created by 陳駿逸 on 2020/2/11.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit

class MarketHistoryCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var trade: DisplayTrades? {
        didSet {
            guard let trade = trade else { return }
            let date = NSDate(timeIntervalSince1970: TimeInterval(trade.T/1000))
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            dateFormatter.dateFormat = "HH:mm:ss"
            
            self.timeLabel.text = dateFormatter.string(from: date as Date)
            self.priceLabel.text = NSString(format: "%.2f", (trade.p as NSString).floatValue) as String
            self.quantityLabel.text = NSString(format: "%.6f", (trade.q as NSString).floatValue) as String
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
