//
//  MainView.swift
//  iOS Supply
//
//  Created by Bradley Heenk on 5/16/20.
//  Copyright © 2020 Bradley Heenk. All rights reserved.
//

import SwiftUI

struct MainView: View {

    var bluetoothController = BluetoothController()
    
    //initialize our viewmodels
    @ObservedObject var settingsVM = SettingsViewModel()
    @ObservedObject var channel1VM = ChannelViewModel()
    @ObservedObject var channel2VM = ChannelViewModel()
    
    init() {
        channel1VM.id = 0
        channel2VM.id = 1
        bluetoothController.ch1NotifyDelegate = channel1VM
        bluetoothController.ch2NotifyDelegate = channel2VM
        channel1VM.channelWriteDelegate = bluetoothController
        channel2VM.channelWriteDelegate = bluetoothController
    }
    
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
            ChannelView(channelVM: channel1VM)
            HStack {
              Text("Channel 2:").bold()
                .font(.largeTitle)
                Spacer()
            }.padding(.horizontal)
            .padding(.horizontal)
            ChannelView(channelVM: channel2VM)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
