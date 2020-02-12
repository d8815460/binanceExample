//
//  OrderBookHeaderCell.swift
//  example
//
//  Created by 陳駿逸 on 2020/2/11.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit

protocol OrderBookHeaderCellDelegate {
    func didTickSizeButtonPressed(_ sender: Any)
}

class OrderBookHeaderCell: UITableViewCell {
    var delegate: OrderBookHeaderCellDelegate?
    
    @IBOutlet weak var sizeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func tickSizeButton(_ sender: Any) {
        self.delegate?.didTickSizeButtonPressed(sender)
    }
}
