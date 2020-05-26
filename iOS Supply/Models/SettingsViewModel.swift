//
//  ChannelSettings.swift
//  iOS Supply
//
//  Created by Bradley Heenk on 5/16/20.
//  Copyright © 2020 Bradley Heenk. All rights reserved.
//

import Foundation

enum Mode {
    case independent
    case serial
    case parallel
    case disconnected
}

class SettingsViewModel: ObservableObject, SettingsDelegate {
    
    @Published var mode: Mode = .independent
    
    //Bluetooth Communication
    func NotifyMode(data: Data?) {
        //
    }
    
    func WriteMode() {
        //
    }
    
    //Internal Communication
    
    
}