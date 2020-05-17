//
//  MainView.swift
//  iOS Supply
//
//  Created by Bradley Heenk on 5/16/20.
//  Copyright © 2020 Bradley Heenk. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("iOS Power Supply")
                .font(.largeTitle)
            SettingsView()
            ChannelView()
            ChannelView()
            Spacer()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
