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

protocol ChannelDelegate {
    //Reading from the device
    func NotifyVoltageOut(data: Data?)
    func NotifyCurrentOut(data: Data?)
    func NotifyVoltageSet(data: Data?)
    func NotifyCurrentSet(data: Data?)
    func NotifyPowerSet(data: Data?)
    func NotifyLimiting(data: Data?)
    
    //Writing to the device
    func WriteVoltageSet()
    func WriteCurrentSet()
    func WritePowerSet()
    func WriteMode()
}

protocol SettingsDelegate {
    //Reading from the device
    func NotifyMode(data: Data?)
    
    //Writing to the device
    func WriteMode()
}

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

//Quinns Definition table
//420b0002-0000-0000-0000-000000000000 = MAX Vol Ch1 transmit
//420b0003-0000-0000-0000-000000000000 = MAX Amp Ch1 transmit
//420b0004-0000-0000-0000-000000000000 = INA260 voltage reading Ch1 transmit
//420b0005-0000-0000-0000-000000000000 = INA260 current reading Ch1 transmit
//420b0006-0000-0000-0000-000000000000 = POW state reading Ch1 transmit
//420b0007-0000-0000-0000-000000000000 = C.V or C.C state reading Ch1 transmit
//420b0008-0000-0000-0000-000000000000 = MAX Vol Ch2 transmit
//420b0009-0000-0000-0000-000000000000 = MAX Amp Ch2 transmit
//420b0010-0000-0000-0000-000000000000 = INA260 voltage reading Ch2 transmit
//420b0011-0000-0000-0000-000000000000 = INA260 current reading Ch2 transmit
//420b0012-0000-0000-0000-000000000000 = POW state reading Ch2 transmit
//420b0013-0000-0000-0000-000000000000 = C.V or C.C state reading Ch2 transmit
//420b0014-0000-0000-0000-000000000000 = Modes transmit
//420b0015-0000-0000-0000-000000000000 = temperature transmit
//420b0016-0000-0000-0000-000000000000 = rgb transmit
//420b0017-0000-0000-0000-000000000000 = fanrpm transmit
//420a0018-0000-0000-0000-000000000000 = MAX vol ch1 receive
//420a0019-0000-0000-0000-000000000000 = MAX AMP ch1 receive
//420a0020-0000-0000-0000-000000000000 = POW state ch1 receive
//420a0021-0000-0000-0000-000000000000 = MAX vol ch2 receive
//420a0022-0000-0000-0000-000000000000 = MAX AMP ch2 receive
//420a0023-0000-0000-0000-000000000000 = POW state ch2 receive
//420a0024-0000-0000-0000-000000000000 = modes receive
//42000001-0000-0000-0000-000000000000 = service

class BluetoothController: UIViewController {
    
    var centralManager: CBCentralManager!
    var blePeripheral: CBPeripheral?
    var writeCharacteristics: [CBCharacteristic]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func testingBluetooth() {
        print("I loaded :O")
        
        // Do any additional setup after loading the view.
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        
        
        
        if peripheral.identifier == UUID(uuidString: "3AFF94D8-6E6C-4A6B-F457-3A04D200B43A") {
            blePeripheral = peripheral
            centralManager.stopScan()
            centralManager.connect(blePeripheral!, options: nil)
            peripheral.delegate = self
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    
    func sendShit() {
        print("I WORKED!")
        
        let data: Data = "0".data(using: .utf8)!
        
        for characteristic in writeCharacteristics! {
            blePeripheral?.writeValue(data, for: characteristic, type: .withResponse)
            print(characteristic)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
        
        print("Checking SHIT")
        
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        
        print("Services Modified :(")
        
        centralManager.scanForPeripherals(withServices: nil)
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print(characteristic)
            
            print(characteristic.service)
            
            if(characteristic.properties.contains(.read)){
                print("I can read shit!")            }
            if(characteristic.properties.contains(.write)){
                self.writeCharacteristics!.append(characteristic)
                print("I can write shit!")
            }
            if(characteristic.properties.contains(.notify)){
                print("I can notify shit!")
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("We got a new update for a characteristic!")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        //print(characteristic)
        print(characteristic.uuid.uuidString)
        
        switch characteristic.uuid.uuidString {
        case BluetoothCommunication.Channel1.Notify.VoltageOut.rawValue:
            time = time + 1
            print(time)
        case BluetoothCommunication.Channel1.Notify.CurrentOut.rawValue: print("voltage out")
        case BluetoothCommunication.Channel1.Notify.VoltageSet.rawValue: print("current out")
        case BluetoothCommunication.Channel1.Notify.CurrentOut.rawValue: print("voltage out")
        case BluetoothCommunication.Channel1.Notify.PowerSet.rawValue: print("current out")
        case BluetoothCommunication.Channel1.Write.VoltageSet.rawValue: print("current out")
        case BluetoothCommunication.Channel1.Write.CurrentSet.rawValue: print("voltage out")
        case BluetoothCommunication.Channel1.Write.PowerSet.rawValue: print("current out")
        case BluetoothCommunication.Channel1.Notify.Limiting.rawValue: print("voltage out")
        case BluetoothCommunication.Channel2.Notify.VoltageOut.rawValue: print("current out")
        case BluetoothCommunication.Channel2.Notify.CurrentOut.rawValue: print("voltage out")
        case BluetoothCommunication.Channel2.Notify.VoltageSet.rawValue: print("current out")
        case BluetoothCommunication.Channel2.Notify.CurrentOut.rawValue: print("voltage out")
        case BluetoothCommunication.Channel2.Notify.PowerSet.rawValue: print("current out")
        case BluetoothCommunication.Channel2.Notify.Limiting.rawValue: print("voltage out")
        case BluetoothCommunication.Channel2.Write.VoltageSet.rawValue: print("current out")
        case BluetoothCommunication.Channel2.Write.CurrentSet.rawValue: print("voltage out")
        case BluetoothCommunication.Channel2.Write.PowerSet.rawValue: print("current out")
        case BluetoothCommunication.Settings.Notify.Mode.rawValue: print("raw value")
        case BluetoothCommunication.Settings.Write.Mode.rawValue: print("raw value")
        default:
            print("None found")
        }
        
    }
    
    private func testCharacteristic(from characteristic: CBCharacteristic) -> String {
        
        guard let characteristicData = characteristic.value else { return "nil" }
        
        let byteArray = [UInt8](characteristicData)
        
        if let data = String(bytes: byteArray, encoding: .utf8) {
            return data
        }
        else {
            return "nil"
        }
    }
    
}
