//
//  OrderBookCell.swift
//  example
//
//  Created by 陳駿逸 on 2020/2/11.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit

class OrderBookCell: UITableViewCell {

    @IBOutlet var bidLabels: [UILabel]!
    @IBOutlet var askLabels: [UILabel]!
    var minTickSize:Int = 0
    var bids:[String]? {
        didSet {
            guard let bids = bids else { return }
            if bids.count > 0 {
                self.bidLabels[0].text = NSString(format: "%.6f", (bids[1] as NSString).floatValue) as String
                self.bidLabels[1].text = NSString(format: "%.\(minTickSize)f" as NSString, (bids[0] as NSString).floatValue) as String
            }
        }
    }
    
    var asks:[String]? {
        didSet {
            guard let asks = asks else { return }
            if asks.count > 0 {
                self.askLabels[0].text = NSString(format: "%.6f", (asks[1] as NSString).floatValue) as String
                self.askLabels[1].text = NSString(format: "%.\(minTickSize)f" as NSString, (asks[0] as NSString).floatValue) as String
            }
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
