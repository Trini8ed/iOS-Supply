//
//  MainView.swift
//  iOS Supply
//
//  Created by Bradley Heenk on 5/16/20.
//  Copyright © 2020 Bradley Heenk. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    //initalize our bluetooth controll
    //var ble = BluetoothController()
    var ch1 = ChannelView()
    var ch2 = ChannelView()
    
    //initialize our viewmodels
    @ObservedObject var settingsVM = SettingsViewModel()
    
//    init() {
//        ble.testingBluetooth()
//    }
    
    var body: some View {
        VStack (spacing: 10) {
            HStack {
              Text("Settings:").bold()
                .font(.largeTitle)
                Spacer()
            
                }.padding(.horizontal)
                .padding(.horizontal)
            SettingsView().padding(.horizontal)
            HStack {
              Text("Channel 1:").bold()
                .font(.largeTitle)
                Spacer()
            
                }.padding(.horizontal)
                .padding(.horizontal)
            ch1
            HStack {
              Text("Channel 2:").bold()
                .font(.largeTitle)
                Spacer()
            }.padding(.horizontal)
            .padding(.horizontal)
            ch2
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
