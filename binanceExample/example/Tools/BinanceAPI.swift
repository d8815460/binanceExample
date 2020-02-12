//
//  BinanceAPI.swift
//  example
//
//  Created by 陳駿逸 on 2020/2/11.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit
import Alamofire

class BinanceAPI {
    static let sharedInstance = BinanceAPI()
    fileprivate let alamoFireManager : Alamofire.SessionManager!
    
    init(){
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60 // seconds
        configuration.timeoutIntervalForResource = 60
        self.alamoFireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    fileprivate func getStatusCodeFrom(_ response: DataResponse<Any>  ) -> Int {
        if let httpError = response.result.error?._code {
            return httpError
        } else {
            return (response.response?.statusCode)!
        }
    }
    
    fileprivate func validateResponseSuccess(_ response: DataResponse<Any>) -> Bool {
        print("Request: \(response.request!)")
        let success = response.result.isSuccess && (self.getStatusCodeFrom(response) == 200)
        print(success ? "SUCCESS" : "FAILURE")
        return success
    }
    
    
    //API Calls
    func getDepth(
        limit: Int,
        symbol: String,
        handler: @escaping (_ depthJson: DepthJSON?, _ error: Error?) -> Void)
    {
        let path: String = baseUrl+getDepthPath+"?limit=\(limit)"+"&symbol=\(symbol)"
        
        self.alamoFireManager.request(path, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).validate(statusCode: 200..<600).validate(contentType: ["application/json"]).responseJSON { response in
            
            let success = self.validateResponseSuccess(response)
            
            if (success) {
                do {
                    let depthJson = try JSONDecoder().decode(DepthJSON.self, from: (response.data)!)
                    handler(depthJson, nil)
                } catch {
                    let error = NSError()
                    handler(nil, error)
                }
            } else {
                do {
                    let error = try JSONDecoder().decode(BinanceHttpsError.self, from: (response.data)!)
                    handler(nil, error)
                } catch {
                    print("get Depth API unknow error, please try again.")
                }
            }
        }
    }
    
    func getExchangeInfo(
        symbol: String,
        handler: @escaping (_ depthJson: ExchangeInfo?, _ error: Error?) -> Void)
    {
        let path: String = baseUrl+getExchangeInfoPath+"?symbol=\(symbol)"
        
        self.alamoFireManager.request(path, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).validate(statusCode: 200..<600).validate(contentType: ["application/json"]).responseJSON { response in
            
            let success = self.validateResponseSuccess(response)
            
            if (success) {
                do {
                    let exchangeInfo = try JSONDecoder().decode(ExchangeInfo.self, from: (response.data)!)
                    handler(exchangeInfo, nil)
                } catch {
                    let error = NSError()
                    handler(nil, error)
                }
            } else {
                do {
                    let error = try JSONDecoder().decode(BinanceHttpsError.self, from: (response.data)!)
                    handler(nil, error)
                } catch {
                    print("get Exchange Info API unknow error, please try again.")
                }
            }
        }
    }
    
    func getAggTrades(
        limit: Int,
        symbol: String,
        handler: @escaping (_ aggTrades: [AggTrades]?, _ error: Error?) -> Void)
    {
        let path: String = baseUrl+getAggTradesPath+"?limit=\(limit)"+"&symbol=\(symbol)"
        
        self.alamoFireManager.request(path, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).validate(statusCode: 200..<600).validate(contentType: ["application/json"]).responseJSON { response in
            
            let success = self.validateResponseSuccess(response)
            
            if (success) {
                do {
                    let aggTrades = try JSONDecoder().decode([AggTrades].self, from: (response.data)!)
                    handler(aggTrades, nil)
                } catch {
                    let error = NSError()
                    handler(nil, error)
                }
            } else {
                do {
                    let error = try JSONDecoder().decode(BinanceHttpsError.self, from: (response.data)!)
                    handler(nil, error)
                } catch {
                    print("get AggTrades API unknow error, please try again.")
                }
            }
        }
    }
}
