//
//  ChannelData.swift
//  iOS Supply
//
//  Created by Bradley Heenk on 5/16/20.
//  Copyright © 2020 Bradley Heenk. All rights reserved.
//

import Foundation

enum Incremenent {
    case low
    case medium
    case high
    case max
}

class ChannelData {
    
    var voltage = 0
    var voltageSet = 0.0
    var voltageInc: Incremenent = .max
    
    var current = 0
    var currentInc = 0.0
    var incCurrent: Incremenent = .max
    
    var active = false
    
}
