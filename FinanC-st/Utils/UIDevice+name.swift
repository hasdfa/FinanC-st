//
//  UIDevice+name.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 17.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

extension UIDevice {

    public var machineString: String {
        get {
            #if (arch(i386) || arch(x86_64)) && os(iOS)
                let DEVICE_IS_SIMULATOR = true
            #else
                let DEVICE_IS_SIMULATOR = false
            #endif
            
            var machineString = ""
            if DEVICE_IS_SIMULATOR == true {
                if let dir = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    machineString = dir
                }
            } else {
                var systemInfo = utsname()
                uname(&systemInfo)
                let machineMirror = Mirror(reflecting: systemInfo.machine)
                machineString = machineMirror.children.reduce("") { identifier, element in
                    guard let value = element.value as? Int8, value != 0 else { return identifier }
                    return identifier + String(UnicodeScalar(UInt8(value)))
                }
            }
            return machineString
        }
    }
    
}
