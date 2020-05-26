//
//  ControlViewController.swift
//  iOS Supply
//
//  Created by Bradley Heenk on 5/18/20.
//  Copyright © 2020 Bradley Heenk. All rights reserved.
//

var time = 0

import UIKit
import CoreBluetooth

enum BluetoothCommunication: String {
    case Service = "42000001-0000-0000-0000-000000000000"
    enum Channel1 {
        enum Notify: String {
            case VoltageOut = "420B0004-0000-0000-0000-000000000000"
            case CurrentOut = "420B0005-0000-0000-0000-000000000000"
            case VoltageSet = "420B0002-0000-0000-0000-000000000000"
            case CurrentSet = "420B0003-0000-0000-0000-000000000000"
            case PowerSet = "420Bb0006-0000-0000-0000-000000000000"
            case Limiting = "420B0007-0000-0000-0000-000000000000"
            case Indicator = "1578cb8b-1cac-4b76-8988-7b90c22fb7af" //Implement Me
            enum Temperature: String {
                case Regulator1 = "69781d76-a787-4bff-a468-ef88f2740d67" //Implement Me
                case Regulator2 = "2b8f9a32-d0d4-4303-b653-f89fca6f185a" //Implement Me
                case Regulator3 = "e6785f5c-b5df-4217-95a1-4b2c875bebe2" //Implement Me
            }
        }
        enum Write: String {
            case VoltageSet = "420A0018-0000-0000-0000-000000000000"
            case CurrentSet = "420A0019-0000-0000-0000-000000000000"
            case PowerSet = "420A0020-0000-0000-0000-000000000000"
        }
    }
    enum Channel2 {
        enum Notify: String {
            case VoltageOut = "420B0010-0000-0000-0000-000000000000"
            case CurrentOut = "420B0011-0000-0000-0000-000000000000"
            case VoltageSet = "420B0008-0000-0000-0000-000000000000"
            case CurrentSet = "420B0009-0000-0000-0000-000000000000"
            case PowerSet = "420B0012-0000-0000-0000-000000000000"
            case Limiting = "420B0013-0000-0000-0000-000000000000"
            case Indicator = "e02ccb1d-c403-49e6-a83b-e9f0f5c0ba75" //Implement Me
            enum Temperature: String {
                case Regulator1 = "29f0b734-939e-4bfc-a63f-1b146f61eedb" //Implement Me
                case Regulator2 = "21833b7a-8b83-46da-a2b5-8af8049fd8da" //Implement Me
                case Regulator3 = "25a98877-0843-4c38-894b-6c5e9d998b5c" //Implement Me
            }
        }
        enum Write: String {
            case VoltageSet = "420A0021-0000-0000-0000-000000000000"
            case CurrentSet = "420A0022-0000-0000-0000-000000000000"
            case PowerSet = "420A0023-0000-0000-0000-000000000000"
        }
    }
    enum Settings {
        enum Notify: String {
            case Mode = "420B0014-0000-0000-0000-000000000000"
            enum Fans: String {
                case Primary = "0e3c8c44-4440-426a-9bc4-607c95233e17" //Implement Me
                case Secondary = "0b3ddb7a-e5b6-43db-b8af-5495802a325b" //Implement Me
                
            }
        }
        enum Write: String {
            case Mode = "420A0024-0000-0000-0000-000000000000"
        }
    }
}

class BluetoothController: NSObject {

    var centralManager: CBCentralManager!
    var blePeripheral: CBPeripheral?
    var bleService: CBService?
    
    var ch1NotifyDelegate: ChannelNotifyDelegate?
    var ch2NotifyDelegate: ChannelNotifyDelegate?
    var settingsNotifyDelegate: SettingsNotifyDelegate?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if peripheral.identifier == UUID(uuidString: "3AFF94D8-6E6C-4A6B-F457-3A04D200B43A") {
            print(peripheral)
            blePeripheral = peripheral
            centralManager.stopScan()
            centralManager.connect(blePeripheral!, options: nil)
            peripheral.delegate = self
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    
}

extension BluetoothController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: nil)
        @unknown default:
            fatalError("central.state is defaulting to unknown case statement")
        }
    }
    
    //    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    //        while(true) {
    //            centralManager.scanForPeripherals(withServices: nil)
    //        }
    //    }
    //
}

extension BluetoothController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            if service.uuid.uuidString == BluetoothCommunication.Service.rawValue {
                bleService = service
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            let uuid = characteristic.uuid.uuidString
            switch uuid {
                
            //Notifications from Channel 1
            case BluetoothCommunication.Channel1.Notify.VoltageOut.rawValue:
                peripheral.setNotifyValue(true, for: characteristic)
            case BluetoothCommunication.Channel1.Notify.CurrentOut.rawValue:
                peripheral.setNotifyValue(true, for: characteristic)
            case BluetoothCommunication.Channel1.Notify.VoltageSet.rawValue:
                peripheral.setNotifyValue(true, for: characteristic)
            case BluetoothCommunication.Channel1.Notify.CurrentSet.rawValue:
                peripheral.setNotifyValue(true, for: characteristic)
            case BluetoothCommunication.Channel1.Notify.PowerSet.rawValue:
                peripheral.setNotifyValue(true, for: characteristic)
            case BluetoothCommunication.Channel1.Notify.Limiting.rawValue:
                peripheral.setNotifyValue(true, for: characteristic)
            
            //Notifications from Channel 2
            case BluetoothCommunication.Channel2.Notify.VoltageOut.rawValue:
                peripheral.setNotifyValue(true, for: characteristic)
            case BluetoothCommunication.Channel2.Notify.CurrentOut.rawValue:
                peripheral.setNotifyValue(true, for: characteristic)
            case BluetoothCommunication.Channel2.Notify.VoltageSet.rawValue:
                peripheral.setNotifyValue(true, for: characteristic)
            case BluetoothCommunication.Channel2.Notify.CurrentOut.rawValue:
                peripheral.setNotifyValue(true, for: characteristic)
            case BluetoothCommunication.Channel2.Notify.PowerSet.rawValue:
                peripheral.setNotifyValue(true, for: characteristic)
            case BluetoothCommunication.Channel2.Notify.Limiting.rawValue:
                peripheral.setNotifyValue(true, for: characteristic)
            
            //Notifications from Settings
            case BluetoothCommunication.Settings.Notify.Mode.rawValue:
                peripheral.setNotifyValue(true, for: characteristic)
                
            default:
                print("Unsubscriable characteristic: ",uuid)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        centralManager.scanForPeripherals(withServices: nil)
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("We got a new update for a characteristic!")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        //print("Update for: ",characteristic)
        
        let uuid = characteristic.uuid.uuidString
        switch uuid {
            
        //Notifications from Channel 1
        case BluetoothCommunication.Channel1.Notify.VoltageOut.rawValue:
            ch1NotifyDelegate?.VoltageOut(data: characteristic.value)
        case BluetoothCommunication.Channel1.Notify.CurrentOut.rawValue:
            ch1NotifyDelegate?.CurrentOut(data: characteristic.value)
        case BluetoothCommunication.Channel1.Notify.VoltageSet.rawValue:
            ch1NotifyDelegate?.VoltageSet(data: characteristic.value)
            print("Update for: ",characteristic)
        case BluetoothCommunication.Channel1.Notify.CurrentSet.rawValue:
            ch1NotifyDelegate?.CurrentSet(data: characteristic.value)
            print("Update for: ",characteristic)
        case BluetoothCommunication.Channel1.Notify.PowerSet.rawValue:
            ch1NotifyDelegate?.PowerSet(data: characteristic.value)
            print("Update for: ",characteristic)
        case BluetoothCommunication.Channel1.Notify.Limiting.rawValue:
            ch1NotifyDelegate?.Limiting(data: characteristic.value)
            print("Update for: ",characteristic)
        
        //Notifications from Channel 2
        case BluetoothCommunication.Channel2.Notify.VoltageOut.rawValue:
            ch2NotifyDelegate?.VoltageOut(data: characteristic.value)
        case BluetoothCommunication.Channel2.Notify.CurrentOut.rawValue:
            ch2NotifyDelegate?.CurrentOut(data: characteristic.value)
        case BluetoothCommunication.Channel2.Notify.VoltageSet.rawValue:
            ch2NotifyDelegate?.VoltageSet(data: characteristic.value)
        case BluetoothCommunication.Channel2.Notify.CurrentOut.rawValue:
            ch2NotifyDelegate?.CurrentSet(data: characteristic.value)
        case BluetoothCommunication.Channel2.Notify.PowerSet.rawValue:
            ch2NotifyDelegate?.PowerSet(data: characteristic.value)
        case BluetoothCommunication.Channel2.Notify.Limiting.rawValue:
            ch2NotifyDelegate?.Limiting(data: characteristic.value)
        
        //Notifications from Settings
        case BluetoothCommunication.Settings.Notify.Mode.rawValue: settingsNotifyDelegate?.Mode(data: characteristic.value)
            
        default: print(uuid + "is not a valid characteristic")
        }
        
    }
    
    func WriteCharacteristic(uuid: String, value: Any) {
        if let peripheral = blePeripheral {
            if let service = bleService {
                if let characteristics = service.characteristics {
                    for characteristic in characteristics {
                        if characteristic.uuid.uuidString == uuid {
                            if let data = value as? Data {
                                peripheral.writeValue(data, for: characteristic, type: .withResponse)
                            }
                            else {
                                print("Error casting vale to Data")
                            }
                        }
                    }
                }
                else {
                    print("Error getting Bluetooth Characteristics")
                }
            }
            else {
                print("Error finding Bluetooth Service")
            }
        }
        else {
            print("Error getting Bluetooth Peripheral")
        }
    }
}

extension BluetoothController: ChannelWriteDelegate, SettingsWriteDelegate {
    
    func VoltageSet(value: Double, id: Int) {
        print(value,id)
        if(id == 0) {
//            WriteCharacteristic(uuid: BluetoothCommunication.Channel1.Write.VoltageSet.rawValue, value: value)
        }
        else {
//            WriteCharacteristic(uuid: BluetoothCommunication.Channel2.Write.VoltageSet.rawValue, value: value)
        }
    }
    
    func CurrentSet(value: Double, id: Int) {
        print(value,id)
        if(id == 0) {
//            WriteCharacteristic(uuid: BluetoothCommunication.Channel1.Write.VoltageSet.rawValue, value: value)
        }
        else {
//            WriteCharacteristic(uuid: BluetoothCommunication.Channel1.Write.VoltageSet.rawValue, value: value)
        }
    }
    
    func PowerSet(value: Bool, id: Int) {
        print(value,id)
        if(id == 0) {
//            WriteCharacteristic(uuid: BluetoothCommunication.Channel1.Write.VoltageSet.rawValue, value: value)
        }
        else {
//            WriteCharacteristic(uuid: BluetoothCommunication.Channel1.Write.VoltageSet.rawValue, value: value)
        }
    }
    
    func Mode(value: Int) {
//        WriteCharacteristic(uuid: BluetoothCommunication.Settings.Write.Mode.rawValue, value: value)
    }
    
}
