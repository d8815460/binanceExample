//////////////////////////////////////////////////////////////////////////////////////////////////
//
//  ViewController.swift
//  SimpleTest
//
//  Created by Dalton Cherry on 8/12/14.
//  Copyright © 2014 Vluxe. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//////////////////////////////////////////////////////////////////////////////////////////////////

import UIKit
import Starscream

let binanceStreamPath = "wss://stream.binance.com:9443/stream?streams=btcusdt@bookTicker/btcusdt@trade"
let binanceStreamPath2 = "wss://stream.binance.com:9443/ws/btcusdt@depth"

class ViewController: UIViewController {
    var socket: WebSocket!
    var isConnected = false
    let server = WebSocketServer()
    var books: BookTickerStream?
    var trades: TradeStream?
    var depths: DepthStream?
    var pageMenu: CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var request = URLRequest(
            url: URL(string:binanceStreamPath)!)
        request.timeoutInterval = 5
        
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        
        setupPageMenu()
    }
    
    func setupPageMenu() {
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let child_1 = storyboard.instantiateViewController(withIdentifier: "OrderBookTableViewController") as! OrderBookTableViewController
        child_1.title = "Order Book"
        controllerArray.append(child_1)
        let child_2 = storyboard.instantiateViewController(withIdentifier: "MarketHistoryTableViewController") as! MarketHistoryTableViewController
        child_2.title = "Market History"
        controllerArray.append(child_2)


        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        //Customize PageMenu
        let parameters: [CAPSPageMenuOption] = [
            CAPSPageMenuOption.menuMargin(10),
            .menuHeight(40.0),
            .selectionIndicatorHeight(4.0),
            .scrollMenuBackgroundColor(UIColor.lightGray),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor.brown),
            .menuItemFont(UIFont.systemFont(ofSize: 20)),
            .selectedMenuItemLabelColor(UIColor.brown),
            .unselectedMenuItemLabelColor(UIColor.black),
            .addBottomMenuHairline(true),
            .bottomMenuHairlineColor(UIColor.brown), CAPSPageMenuOption.scrollAnimationDurationOnMenuItemTap(400),
            .menuItemSeparatorColor(UIColor.black),
        ]

        // Initialize page menu
        if self.isIPhoneX() {
            pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), pageMenuOptions: parameters, isFromBrand: true, iSForTop : false, isForSearch: false)
        } else {
            pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-49), pageMenuOptions: parameters, isFromBrand: true, iSForTop : false, isForSearch: false)
        }
        


        pageMenu!.delegate = self
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)
    }
    
    // MARK: Write Text Action
    
    @IBAction func writeText(_ sender: UIBarButtonItem) {
        socket.write(string: "hello there!")
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
            print("Received text: \(string)")
            let valuse = try? string.asJSONToDictionary()
            switch (valuse!["stream"]) as! String {
            case "btcusdt@bookTicker":
                try? self.decoderBookTicker(data: (valuse?.toData())!) { (bookTickers, error) in
                    if error == nil { self.books = bookTickers }
                }
            case "btcusdt@trade":
                try? self.decoderTrade(data: (valuse?.toData())!, handler: { (tradestream, error) in
                    if error == nil { self.trades = tradestream }
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
}

extension ViewController {
    /// 判断机型是否为 iPhone X、XR、XS、XS Max 的方法
    /// 原理是根据手机底部安全区的高度 判断是否为 iPhone X、XR、XS、XS Max 几款机型
    func isIPhoneX() -> Bool {
        if #available(iOS 11.0, *) {
            if let delegate = UIApplication.shared.delegate {
                if let window = delegate.window {
                    let safeAreaInsets = window?.safeAreaInsets
                    if let bottom = safeAreaInsets?.bottom  {
                        if bottom > 0.0 {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
}

extension ViewController: CAPSPageMenuDelegate {
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        
    }
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        
    }
}


// MARK: - CastingError

struct CastingError: Error {
    let fromType: Any.Type
    let toType: Any.Type
    init<FromType, ToType>(fromType: FromType.Type, toType: ToType.Type) {
        self.fromType = fromType
        self.toType = toType
    }
}

extension CastingError: LocalizedError {
    var localizedDescription: String { return "Can not cast from \(fromType) to \(toType)" }
}

extension CastingError: CustomStringConvertible { var description: String { return localizedDescription } }

// MARK: - Data cast extensions

extension Data {
    func toDictionary(options: JSONSerialization.ReadingOptions = []) throws -> [String: Any] {
        return try to(type: [String: Any].self, options: options)
    }

    func to<T>(type: T.Type, options: JSONSerialization.ReadingOptions = []) throws -> T {
        guard let result = try JSONSerialization.jsonObject(with: self, options: options) as? T else {
            throw CastingError(fromType: type, toType: T.self)
        }
        return result
    }
}

// MARK: - String cast extensions

extension String {
    func asJSON<T>(to type: T.Type, using encoding: String.Encoding = .utf8) throws -> T {
        guard let data = data(using: encoding) else { throw CastingError(fromType: type, toType: T.self) }
        return try data.to(type: T.self)
    }

    func asJSONToDictionary(using encoding: String.Encoding = .utf8) throws -> [String: Any] {
        return try asJSON(to: [String: Any].self, using: encoding)
    }
}

// MARK: - Dictionary cast extensions

extension Dictionary {
    func toData(options: JSONSerialization.WritingOptions = []) throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: options)
    }
}
