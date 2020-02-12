//
//  PAPCache.swift
//  example
//
//  Created by 陳駿逸 on 2020/2/11.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit

final class PAPCache: NSCache<AnyObject, AnyObject> {
    fileprivate var cache: NSCache<AnyObject, AnyObject>
    // MARK:- Initialization
    static let sharedCache = PAPCache()
    
    fileprivate override init() {
        self.cache = NSCache()
    }
    
    // MARK:- PAPCache
    
    func clear() {
        cache.removeAllObjects()
    }
    
    // MARK:- ()
    
    func setAttributesForDepth(depth: DepthJSON) {
        let attributes = [
            "depth": depth
            ] as [String : Any]
        
        cache.setObject(attributes as AnyObject, forKey: depth.lastUpdateId as AnyObject)
    }
    
    func getCatchDepth(lastUpdateId: String) -> DepthJSON? {
        if let attributes = cache.object(forKey: lastUpdateId as AnyObject) as? [String:AnyObject] {
            return attributes["depth"] as? DepthJSON
        } else {
            return nil
        }
    }
}
