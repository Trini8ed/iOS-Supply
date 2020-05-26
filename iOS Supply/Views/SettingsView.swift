//
//  SettingsView.swift
//  iOS Supply
//
//  Created by Bradley Heenk on 5/16/20.
//  Copyright © 2020 Bradley Heenk. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var selectorMode = 0
    @State private var modeRange = ["Independent", "Series", "Parallel", "Disabled"]
    
    var body: some View {
        VStack {
            HStack {
                Text("Output Operation Mode:")
                    .font(.body)
                Picker("voltageSet", selection: $selectorMode) {
                    ForEach(0 ..< modeRange.count) { index in
                        Text(self.modeRange[index])
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }.padding(.horizontal)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
