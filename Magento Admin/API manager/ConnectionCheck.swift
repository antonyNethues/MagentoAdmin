//
//  ConnectionCheck.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 31/08/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import Foundation
import SystemConfiguration


struct Screen {
    static let height=UIScreen.main.bounds.size.height
    static let width=UIScreen.main.bounds.size.width
}

struct AppFont {
    
    static let UltraLight=".HelveticaNeueDeskInterface-UltraLightP2"
    static let Regular=".HelveticaNeueDeskInterface-Regular"
    static let Thin=".HelveticaNeueDeskInterface-Thin"
    static let Bold=".HelveticaNeueDeskInterface-Bold"
    static let TextMedium=".HelveticaNeueDeskInterface-MediumP4"
    
    static func thinFontSize(size:CGFloat) -> UIFont {
        return self.fontFrom(name: Thin, size: size)
    }
    
    static func ultraLightFontSize(size:CGFloat) -> UIFont {
        return self.fontFrom(name: UltraLight, size: size)
    }
    
    static func regularFontSize(size:CGFloat) -> UIFont {
        return self.fontFrom(name: Regular, size: size)
    }
    
    static func boldFontSize(size:CGFloat) -> UIFont {
        return self.fontFrom(name: Bold, size: size)
    }
    
    static func textMediumFontSize(size:CGFloat) -> UIFont {
        return self.fontFrom(name: TextMedium, size: size)
    }
    
    private static func fontFrom(name:String,size:CGFloat) -> UIFont {
        let fontSize = size * (Screen.width / 320.0)
        return UIFont(name: name, size: fontSize)!
    }
    
}

public class ConnectionCheck {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)

    }
}
