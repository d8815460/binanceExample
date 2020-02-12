//
//  UIColor+BinanceColor.swift
//  example
//
//  Created by 陳駿逸 on 2020/2/11.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit

extension UIColor {
    
    func colorWithHexString (_ hex:String) -> UIColor {
        
        var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    //Static colors
    public class func binanceYellowColor() -> UIColor {
        return UIColor(red: 238.0/255.0, green: 190.0/255.0, blue: 28.0/255.0, alpha: 1.0)
    }
    
    public class func binanceGrey() -> UIColor {
        return UIColor(red: 14.0/255.0, green: 17.0/255.0, blue: 22.0/255.0, alpha: 1.0)
    }
    
    public class func binanceTextColor() -> UIColor {
        return UIColor(red: 112.0/255.0, green: 124.0/255.0, blue: 140.0/255.0, alpha: 1.0)
    }
    
    public class func binanceNavigationColor() -> UIColor {
        return UIColor(red: 17.0/255.0, green: 21.0/255.0, blue: 27.0/255.0, alpha: 1.0)
    }
    
    public class func filterRedColor() -> UIColor {
        return UIColor(red: 233.0/255.0, green: 138.0/255.0, blue: 133.0/255.0, alpha: 1.0)
    }
    
    public class func pinkishGreyColor() -> UIColor {
        return UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0)
    }
    
    public class func oldPinkColor() -> UIColor {
        return UIColor(red: 217/255.0, green: 169/255.0, blue: 155/255.0, alpha: 1.0)
    }
    
    public class func warmGrey() -> UIColor {
        return UIColor(red: 142/255.0, green: 142/255.0, blue: 142/255.0, alpha: 1.0)
    }
    
    public class func coolGrey() -> UIColor {
        return UIColor(red: 152/255.0, green: 150/255.0, blue: 164/255.0, alpha: 1.0)
    }
    
    public class func brownishGrey() -> UIColor {
        return UIColor(red: 99/255.0, green: 99/255.0, blue: 99/255.0, alpha: 1.0)
    }
    
    public class func darkPeach() -> UIColor {
        return UIColor(red: 230/255.0, green: 115/255.0, blue: 115/255.0, alpha: 1.0)
    }
    
    public class func darkGold() -> UIColor {
        return UIColor(red: 193/255.0, green: 165/255.0, blue: 93/255.0, alpha: 1.0)
    }
    
    public class func diamond() -> UIColor {
        return UIColor(red: 89/255.0, green: 104/255.0, blue: 179/255.0, alpha: 1.0)
    }
    
    public class func greenyBlue() -> UIColor {
        return UIColor(red: 89/255.0, green: 179/255.0, blue: 148/255.0, alpha: 1.0)
    }
    
    public class func whiteThree() -> UIColor {
        return UIColor(red: 227/255.0, green: 227/255.0, blue: 227/255.0, alpha: 1.0)
    }
    
    public class func fontGrey() -> UIColor {
        return UIColor(red: 108/255.0, green: 110/255.0, blue: 112/255.0, alpha: 1.0)
    }
    
    //NORMAL
    public class func neutralStartColor() -> UIColor {
        return UIColor(red: 0x65/0xFF, green: 0x65/0xFF, blue: 0x65/0xFF, alpha: 1.0)
    }
    
    public class func neutralEndColor() -> UIColor {
        return UIColor(red: 0xFF/0xFF, green: 0xC1/0xFF, blue: 0xAF/0xFF, alpha: 1.0)
    }
    
    //COOL
    public class func coolStartColor() -> UIColor {
        return UIColor(red: 0x52/0xFF, green: 0x3A/0xFF, blue: 0x61/0xFF, alpha: 1.0)
    }
    
    public class func coolEndColor() -> UIColor {
        return UIColor(red: 0x88/0xFF, green: 0xAE/0xFF, blue: 0xD5/0xFF, alpha: 1.0)
    }
    
    //WARM
    public class func warmStartColor() -> UIColor {
        return UIColor(red: 0x79/0xFF, green: 0xCC/0xFF, blue: 0xCC/0xFF, alpha: 1.0)
    }
    
    public class func warmEndColor() -> UIColor {
        return UIColor(red: 0xFB/0xFF, green: 0x94/0xFF, blue: 0x79/0xFF, alpha: 1.0)
    }
    
    //KOLLECTIN
    public class func kollectinStartColor() -> UIColor {
        return UIColor(red: 0xD9/0xFF, green: 0xA9/0xFF, blue: 0x9B/0xFF, alpha: 1.0)
    }
    
    public class func kollectinEndColor() -> UIColor {
        return UIColor(red: 0x98/0xFF, green: 0x96/0xFF, blue: 0xA4/0xFF, alpha: 1.0)
    }
    
    //NewColor
    
    public class func kollectinNewStartColor() -> UIColor {
        return UIColor(red: 250.0/255.0, green: 131.0/255.0, blue: 147.0/255.0, alpha: 1.0)
    }
    
    public class func kollectinNewEndColor() -> UIColor {
        return UIColor(red: 254.0/255.0, green: 182.0/255.0, blue: 139.0/255.0, alpha: 1.0)
    }
}
