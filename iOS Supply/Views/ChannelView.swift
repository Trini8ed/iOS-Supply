//
//  ChannelView.swift
//  iOS Supply
//
//  Created by Bradley Heenk on 5/16/20.
//  Copyright © 2020 Bradley Heenk. All rights reserved.
//

import SwiftUI
import UIKit

struct ChannelView: View {
	
	@State private var selectorCurrent = 0
	@State private var selectorVoltage = 0
	
	private var voltageRange = ["1V", "0.1V", "10mV", "1mV"]
	private var currentRange = ["1A", "0.1A", "10mA", "1mA"]
	
	private var increment:[Double] = [1.0, 0.1, 0.01, 0.001]
	
	@ObservedObject var channelVM: ChannelViewModel
	
	init(channelVM: ChannelViewModel) {
		self.channelVM = channelVM
	}
	
	var body: some View {
		VStack (spacing: 10) {
			VStack {
				HStack {
					Text("State: ")
						.font(.title)
					Text(channelVM.active ? "On" : "Off").bold()
						.font(.title)
					Spacer()
					Text("Power: ")
					.font(.title)
					Button(action: {self.channelVM.active = false}) {
						Text("Off")
							.frame(width: 100, height: 45)
							.foregroundColor(Color.white)
							.background(channelVM.active ? Color.red : Color.gray)
							.cornerRadius(10)
						}.disabled(!self.channelVM.active)
					Button(action: {self.channelVM.active = true}) {
						Text("On")
							.frame(width: 100, height: 45)
							.foregroundColor(Color.white)
							.background(channelVM.active ? Color.gray : Color.green)
							.cornerRadius(10)
					}.disabled(self.channelVM.active)
				}.padding(.horizontal)
			}.padding()
			HStack {
				VStack (alignment: .leading, spacing: 10) {
					HStack {
						Text("Voltage")
							.font(.title)
						Spacer()
						HStack {
							if(!channelVM.limited) {
								Text("C.V")
									.font(.headline)
								Circle()
									.frame(width: 16, height: 16)
									.foregroundColor(Color.red)
							}
						}
					}
					HStack {
						Text(String(format: "%.3f", channelVM.voltage))
							.font(.largeTitle)
						Spacer()
						Text("V")
							.font(.largeTitle)
					}
					.padding()
					.frame(width: 350, height: 100, alignment: .trailing)
					.background(Color(#colorLiteral(red: 0.9467981458, green: 0.9469191432, blue: 0.9499695897, alpha: 1)))
					.cornerRadius(10)
				}
				.padding(.horizontal)
				Spacer()
				VStack (alignment: .leading, spacing: 10) {
					HStack {
						Text("Current")
							.font(.title)
						Spacer()
						HStack {
							if(channelVM.limited) {
								Text("C.C")
									.font(.headline)
								Circle()
									.frame(width: 16, height: 16)
									.foregroundColor(Color.green)
							}
						}
					}
					HStack {
						Text(String(format: "%.3f", channelVM.current))
							.font(.largeTitle)
						Spacer()
						Text("A")
							.font(.largeTitle)
					}
					.padding()
					.frame(width: 350, height: 100, alignment: .trailing)
					.background(Color(#colorLiteral(red: 0.9467981458, green: 0.9469191432, blue: 0.9499695897, alpha: 1)))
					.cornerRadius(10)
				}
				.padding(.horizontal)
			}
			.padding(.horizontal)
			HStack {
				HStack {
					VStack (alignment: .center) {
						HStack {
							Text("Voltage Inc:")
							Picker("voltageSet", selection: $selectorVoltage) {
								ForEach(0 ..< voltageRange.count) { index in
									Text(self.voltageRange[index]).tag(index)
								}
							}.pickerStyle(SegmentedPickerStyle())
						}
						HStack {
							Text("Voltage Limit")
								.font(.body)
							Stepper(value: $channelVM.voltageSet, in: 0...24, step: increment[selectorVoltage]) {
								Text("")
							}
							.frame(width: 100, height: 40, alignment: .leading)
							Spacer()
							Text(String(format: "%.3f", channelVM.voltageSet) + " V")
								.font(.headline)
						}
					}.padding()
					VStack {
						HStack {
							Text("Current Inc:")
							Picker("currentSet", selection: $selectorCurrent) {
								ForEach(0 ..< currentRange.count) { index in
									Text(self.currentRange[index]).tag(index)
								}
							}.pickerStyle(SegmentedPickerStyle())
						}
						HStack {
							Text("Current Limit")
								.font(.body)
							Stepper(value: $channelVM.currentSet, in: 0...3, step: increment[selectorCurrent]) {
								Text("")
								}
							.frame(width: 100, height: 40, alignment: .leading)
							Spacer()
							Text(String(format: "%.3f", channelVM.currentSet) + " A")
								.font(.headline)
						}
					}.padding()
				}
			}.padding(.horizontal)
		}
	}
	
}

struct ChannelView_Previews: PreviewProvider {
	static var previews: some View {
		ChannelView(channelVM: ChannelViewModel())
	}
}
