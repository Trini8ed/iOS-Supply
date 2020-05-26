//
//  ChannelData.swift
//  iOS Supply
//
//  Created by Bradley Heenk on 5/16/20.
//  Copyright © 2020 Bradley Heenk. All rights reserved.
//

import Foundation

class ChannelViewModel: ObservableObject {
    
    @Published var voltage:Double = 0.0
    @Published var voltageSet:Double = 0.0
    
    @Published var current:Double = 0.0
    @Published var currentSet:Double = 0.0
    
    @Published var limited = false
    
    @Published var active = false
    
}
