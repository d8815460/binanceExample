//
//  ViewController.swift
//  example
//
//  Created by 陳駿逸 on 2020/2/10.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit
import Starscream
import CAPSPageMenu


class ViewController: UIViewController {
    var socket: WebSocket!
    
    private var isConnected = false
    private var books: [BookTickerStream] = [BookTickerStream]()
    private var depths: DepthStream?
    private var exchangeInfo: ExchangeInfo?
    private var pageMenu: CAPSPageMenu?
    private var child_1:OrderBookTableViewController?
    private var child_2:MarketHistoryTableViewController?
    private var timer: Timer? // post notify per sec.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: NSNotification.Name(rawValue: KSDidEnterBackgroundNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: NSNotification.Name(rawValue: KSWillEnterForegroundNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: NSNotification.Name(rawValue:    KSReachabilityConnectedNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: NSNotification.Name(rawValue:    KSReachabilityDisConnectedNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: NSNotification.Name(rawValue: KSWillMoveToPageNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: NSNotification.Name(rawValue: KSDidMoveToPageNotificationKey), object: nil)
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.postNotification(timer:)), userInfo: KSBookTickerUpdateNotificationKey, repeats: true)
        
        //------------------------------------- WebSocket Start -------------------------------------
        var request = URLRequest(url: URL(string:binanceStreamPath)!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        //------------------------------------- WebSocket End -------------------------------------
        
        //------------------------------------- Exchange Info Start -------------------------------------
        BinanceAPI.sharedInstance.getExchangeInfo(symbol: KSSymbolKey) { (exchangeInfo, error) in
            self.exchangeInfo = exchangeInfo
            self.setupPageMenu()
        }
        //------------------------------------- Exchange Info End -------------------------------------
    }
    
    
    
    // MARK: Disconnect Action
    
    @IBAction func disconnect(_ sender: UIBarButtonItem) {
        if isConnected {
            sender.title = "Connect"
            socket.disconnect()
        } else {
            sender.title = "Disconnect"
            socket.connect()
        }
    }
    
    // MARK: Notification
    
    @objc func handleNotification(_ notification: Notification) {
        switch notification.name.rawValue {
        case KSDidEnterBackgroundNotificationKey :
            socket.disconnect()
            break
        case KSWillEnterForegroundNotificationKey :
            socket.connect()
            break
        case KSReachabilityConnectedNotificationKey :
            socket.connect()
            break
        case KSReachabilityDisConnectedNotificationKey :
            socket.disconnect()
            break
        case KSDidMoveToPageNotificationKey :
            socket.connect()
            break
        case KSWillMoveToPageNotificationKey :
            socket.disconnect()
            break
        default:
        break
        }
    }
}

extension ViewController: WebSocketDelegate {
    // MARK: - WebSocketDelegate
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            let valuse = try? string.asJSONToDictionary()
            switch (valuse!["stream"]) as! String {
            case "btcusdt@bookTicker":
                try? self.decoderBookTicker(data: (valuse?.toData())!) { (bookTickers, error) in
                    if error == nil {
                        self.books.insert(bookTickers!, at: 0)
                        if self.books.count > 17 { self.books.removeLast() }
                    }
                }
            case "btcusdt@trade":
                try? self.decoderTrade(data: (valuse?.toData())!, handler: { (tradestream, error) in
                    if error == nil {
                        self.child_2?.trades = tradestream
                        self.throttle(threshold: 0.25, postKey: KSTradeUpdateNotificationKey)
                    }
                })
            case "btcusdt@depth":
                try? self.decoderDepth(data: (valuse?.toData())!, handler: { (depthstream, error) in
                    if error == nil { self.depths = depthstream }
                })
            default:
                return
            }
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            print("ping")
            socket.write(string: "pong") {
                print("sended pong.")
            }
            break
        case .pong(_):
            print("pong")
            break
        case .viablityChanged(_):
            print("viablityChanged")
            break
        case .reconnectSuggested(_):
            print("reconnectSuggested")
            break
        case .cancelled:
            print("cancelled")
            isConnected = false
        case .error(let error):
            isConnected = false
            handleError(error)
        }
    }
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
    
    func decoderBookTicker(data: Data, handler: @escaping (_ booktickerstream: BookTickerStream?, _ error: NSError?) -> Void) {
        let model = try? JSONDecoder().decode(BookTickerStream.self, from: data)
        handler(model, nil)
    }
    
    func decoderTrade(data: Data, handler: @escaping (_ tradestream: TradeStream?, _ error: NSError?) -> Void) {
        let model = try? JSONDecoder().decode(TradeStream.self, from: data)
        handler(model, nil)
    }
    
    func decoderDepth(data: Data, handler: @escaping (_ depthstream: DepthStream?, _ error: NSError?) -> Void) {
        let model = try? JSONDecoder().decode(DepthStream.self, from: data)
        handler(model, nil)
    }
    
    @objc func postNotification(timer: Timer) {
        if (timer.userInfo as! String) == KSBookTickerUpdateNotificationKey { self.child_1?.books = self.books
            NotificationCenter.default.post(name: Notification.Name(rawValue: KSBookTickerUpdateNotificationKey), object: nil)
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: KSTradeUpdateNotificationKey), object: nil)
        }
    }
    
    func postNotificationWithKey(key: String) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: key), object: nil)
    }
    
    func throttle(threshold: TimeInterval, postKey: String) {
        var last: CFAbsoluteTime = 0
        var timer: DispatchSourceTimer?
        let current = CFAbsoluteTimeGetCurrent();
        if current >= last + threshold {
            self.postNotificationWithKey(key: postKey)
            last = current
        } else {
            if timer != nil {
                timer!.cancel()
            }

            timer = DispatchSource.makeTimerSource()
            timer!.setEventHandler {
                self.postNotificationWithKey(key: postKey)
            }

            timer!.schedule(deadline: .now() + .milliseconds(Int(threshold * 1000)))
            timer!.activate()
        }
    }
}


extension ViewController: CAPSPageMenuDelegate {
    
    func setupPageMenu() {
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        self.child_1 = storyboard.instantiateViewController(withIdentifier: "OrderBookTableViewController") as? OrderBookTableViewController
        self.child_1!.title = "Order Book"
        self.child_1?.exchangeInfo = self.exchangeInfo
        controllerArray.append(self.child_1!)
        self.child_2 = storyboard.instantiateViewController(withIdentifier: "MarketHistoryTableViewController") as? MarketHistoryTableViewController
        self.child_2!.title = "Market History"
        controllerArray.append(self.child_2!)

        //Customize PageMenu
        let parameters: [CAPSPageMenuOption] = [
            CAPSPageMenuOption.menuMargin(10),
            .menuHeight(40.0),
            .selectionIndicatorHeight(4.0),
            .scrollMenuBackgroundColor(UIColor.binanceGrey()),
            .viewBackgroundColor(UIColor.binanceGrey()),
            .selectionIndicatorColor(UIColor.binanceYellowColor()),
            .menuItemFont(UIFont.systemFont(ofSize: 20)),
            .selectedMenuItemLabelColor(UIColor.binanceYellowColor()),
            .unselectedMenuItemLabelColor(UIColor.binanceTextColor()),
            .addBottomMenuHairline(true),
            .bottomMenuHairlineColor(UIColor.binanceYellowColor()), CAPSPageMenuOption.scrollAnimationDurationOnMenuItemTap(400),
            .menuItemSeparatorColor(UIColor.black),
            .menuItemWidth(150)
        ]

        // Initialize page menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), pageMenuOptions: parameters)
        
        pageMenu!.delegate = self
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        self.postNotificationWithKey(key: KSWillMoveToPageNotificationKey)
    }
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        self.postNotificationWithKey(key: KSDidMoveToPageNotificationKey)
    }
}

