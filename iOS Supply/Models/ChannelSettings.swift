//
//  ChannelSettings.swift
//  iOS Supply
//
//  Created by Bradley Heenk on 5/16/20.
//  Copyright © 2020 Bradley Heenk. All rights reserved.
//

import Foundation

enum Settings {
    case independent
    case serial
    case parallel
}

class ChannelSettings {
    
    var mode: Settings = .independent
    
}
