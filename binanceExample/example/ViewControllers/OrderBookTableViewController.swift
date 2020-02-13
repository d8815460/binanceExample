//
//  OrderBookTableViewController.swift
//  SimpleTest
//
//  Created by 陳駿逸 on 2020/2/10.
//  Copyright © 2020 vluxe. All rights reserved.
//

import UIKit
import PickerController

class OrderBookTableViewController: UITableViewController, OrderBookHeaderCellDelegate {
    
    var books: [BookTickerStream]?
    var exchangeInfo: ExchangeInfo?
    private var depthJson: DepthJSON?
    private var minTickSize: String = ""
    private var currentSize: Int?
    
    @IBOutlet weak var headerView: OrderBookHeaderCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerView.delegate = self
        BinanceAPI.sharedInstance.getDepth(limit: 20, symbol: KSSymbolKey) { (depthJson, error) in
            if error == nil {
                self.depthJson = depthJson
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
            } else {
                print("error: \(error?.localizedDescription ?? "error")")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: NSNotification.Name(rawValue: KSBookTickerUpdateNotificationKey), object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: KSBookTickerUpdateNotificationKey), object: nil)
    }
    
    @objc func handleNotification(_ notification: Notification) {
        switch notification.name.rawValue {
        case KSBookTickerUpdateNotificationKey :
            if self.depthJson != nil && (self.books![0].data.u) > (self.depthJson?.lastUpdateId)! {
                for book in self.books! {
                    self.depthJson?.bids.insert([book.data.b, book.data.B], at: 0)
                    self.depthJson?.bids.removeLast()
                    
                    self.depthJson?.asks.insert([book.data.a, book.data.A], at: 0)
                    self.depthJson?.asks.removeLast()
                }
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
            } else {
                // drop this event
            }
            break
        default:
        break
        }
    }

    @IBAction func didTickSizeButtonPressed(_ sender: Any) {
        var array:[String] = [String]()
        let count = self.decimalPlace(minTickSize: (self.exchangeInfo?.data[0].minTickSize)!)
        
        for size in 0...count {
            let sizeString = NSString(format: "%i", size)
            array.append((sizeString as String))
        }
        
        DispatchQueue.main.async {
            self.showGroupPicker(title: "Select Tick Size", groupData: [array], selectedItems: ["\(self.currentSize!)"], onDone: { (selectedIndex, selectedSize) in
                self.currentSize = selectedIndex[0]
                self.headerView.sizeButton.setTitle("\(String(describing: self.currentSize!))", for: .normal)
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
            })
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 17
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return self.headerView }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 44 }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderBookCell", for: indexPath) as! OrderBookCell
        
        // Configure the cell...
        cell.bids = depthJson?.bids[indexPath.row]
        cell.asks = depthJson?.asks[indexPath.row]
        if self.exchangeInfo != nil {
            if currentSize != nil {
                cell.minTickSize = self.currentSize!
            } else {
                self.minTickSize = (self.exchangeInfo?.data[0].minTickSize)!
                self.currentSize = self.decimalPlace(minTickSize: self.minTickSize)
                cell.minTickSize = self.currentSize!
            }
        }
        
        return cell
    }
    
    func decimalPlace(minTickSize: String) -> Int {
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
