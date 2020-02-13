//
//  MarketHistoryTableViewController.swift
//  SimpleTest
//
//  Created by 陳駿逸 on 2020/2/10.
//  Copyright © 2020 vluxe. All rights reserved.
//

import UIKit

class MarketHistoryTableViewController: UITableViewController {
    var trades: TradeStream?
    private var aggTrades: [AggTrades]?
    private var displayTrades: [DisplayTrades] = [DisplayTrades]()
    @IBOutlet weak var headerView: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //------------------------------------- Get AggTrades Start -------------------------------
        BinanceAPI.sharedInstance.getAggTrades(limit: 20, symbol: KSSymbolKey) { (aggTrades, error) in
            self.aggTrades = aggTrades
            for aggTrade in aggTrades! {
                let trade = DisplayTrades(T: aggTrade.T, p: aggTrade.p, q: aggTrade.q)
                self.displayTrades.append(trade)
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
            }
        }
        //------------------------------------- Get AggTrades End ---------------------------------
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: NSNotification.Name(rawValue: KSTradeUpdateNotificationKey), object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: KSTradeUpdateNotificationKey), object: nil)
    }
    
    @objc func handleNotification(_ notification: Notification) {
        switch notification.name.rawValue {
        case KSTradeUpdateNotificationKey :
            if self.aggTrades != nil && (self.trades?.data.T)! > (self.aggTrades?.first?.T)! {
                
                self.displayTrades.insert(
                    DisplayTrades(T: (self.trades?.data.T)!,
                                  p: (self.trades?.data.p)!,
                                  q: (self.trades?.data.q)!), at: 0)
                self.displayTrades.removeLast()
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
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.displayTrades.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarketHistoryCell", for: indexPath) as! MarketHistoryCell

        // Configure the cell...
        cell.trade = self.displayTrades[indexPath.row]
        
        if indexPath.row > 0 {
            if (self.displayTrades[indexPath.row].p as NSString).floatValue >= (self.displayTrades[indexPath.row - 1].p as NSString).floatValue {
                cell.priceLabel.textColor = UIColor.green
            } else {
                cell.priceLabel.textColor = UIColor.red
            }
        }
        return cell
    }
}
