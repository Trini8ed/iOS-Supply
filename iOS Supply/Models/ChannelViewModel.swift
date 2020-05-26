//
//  ChannelData.swift
//  iOS Supply
//
//  Created by Bradley Heenk on 5/16/20.
//  Copyright © 2020 Bradley Heenk. All rights reserved.
//

import Foundation

protocol ChannelNotifyDelegate {
    func VoltageOut(data: Data?)
    func CurrentOut(data: Data?)
    func VoltageSet(data: Data?)
    func CurrentSet(data: Data?)
    func PowerSet(data: Data?)
    func Limiting(data: Data?)
}

protocol ChannelWriteDelegate {
    func VoltageSet(value: Double, id: Int)
    func CurrentSet(value: Double, id: Int)
    func PowerSet(value: Bool, id: Int)
}

class ChannelViewModel: ObservableObject {
    
    var id:Int = 0
    
    var channelWriteDelegate: ChannelWriteDelegate?
    
    @Published var voltage:Double = 0.0
    @Published var current:Double = 0.0
    @Published var limited = false
    
    @Published var voltageSet:Double = 0.0 {
        willSet {
            channelWriteDelegate?.VoltageSet(value: voltageSet, id: id)
        }
    }
    
    @Published var currentSet:Double = 0.0{
        willSet {
            channelWriteDelegate?.CurrentSet(value: currentSet, id: id)
        }
    }
    
    @Published var active = false{
        willSet {
            channelWriteDelegate?.PowerSet(value: active, id: id) //delegate
        }
    }
}

extension ChannelViewModel: ChannelNotifyDelegate {
    
    func VoltageOut(data: Data?) {
        if let converted = ProcessData(data: data) {
            if let value = Double(converted) {
                voltage = value
            }
            else {
                print("Failed to convert to string to double")
            }
        }
        else {
            print("Error converting data to a string")
        }
    }
    
    func CurrentOut(data: Data?) {
        if let converted = ProcessData(data: data) {
            if let value = Double(converted) {
                current = value
            }
            else {
                print("Failed to convert to string to double")
            }
        }
        else {
            print("Error converting data to a string")
        }
    }
    
    func VoltageSet(data: Data?) {
        if let converted = ProcessData(data: data) {
            if let value = Double(converted) {
                voltageSet = value
            }
            else {
                print("Failed to convert to string to double")
            }
        }
        else {
            print("Error converting data to a string")
        }
    }
    
    func CurrentSet(data: Data?) {
        if let converted = ProcessData(data: data) {
            if let value = Double(converted) {
                currentSet = value
            }
            else {
                print("Failed to convert to string to double")
            }
        }
        else {
            print("Error converting data to a string")
        }
    }
    
    func PowerSet(data: Data?) {
        if let converted = ProcessData(data: data) {
            if let value = Bool(converted) {
                active = value
            }
            else {
                print("Failed to convert to string to double")
            }
        }
        else {
            print("Error converting data to a string")
        }
    }
    
    func Limiting(data: Data?) {
        if let converted = ProcessData(data: data) {
            if let value = Bool(converted) {
                limited = value
            }
            else {
                print("Failed to convert to string to double")
            }
        }
        else {
            print("Error converting data to a string")
        }
    }
    
    func ProcessData(data: Data?) -> String? {
        if let converted = data {
            let value = String(decoding: converted, as: UTF8.self)
            return value
        }
        else {
            return nil
        }
    }
    
}
