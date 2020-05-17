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
    @State private var voltageRange = ["1V", "0.1V", "10mV", "1mV"]
    @State private var currentRange = ["1A", "0.1A", "10mA", "1mA"]
    
    var body: some View {
		VStack (spacing: 10) {
			VStack {
				HStack {
					Text("Channel 1:").bold()
						.font(.largeTitle)
					Spacer()
					Text("Power:")
						.font(.title)
					Button(action: {}) {
						Text("On")
							.frame(width: 100, height: 45)
							.foregroundColor(Color.white)
							.background(Color.green)
							.cornerRadius(10)
							
					}
					Button(action: {}) {
						Text("Off")
							.frame(width: 100, height: 45)
							.foregroundColor(Color.white)
							.background(Color.red)
							.cornerRadius(10)
					}
				}.padding(.horizontal)
			}.padding()
			HStack {
				VStack (alignment: .leading, spacing: 10) {
					HStack {
						Text("Voltage")
							.font(.title)
						Spacer()
						HStack {
							Text("C.V")
								.font(.headline)
							Circle()
								.frame(width: 16, height: 16)
								.foregroundColor(Color.red)

						}
					}
					HStack {
                        Text("5.000")
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
							Text("C.C")
								.font(.headline)
							Circle()
								.frame(width: 16, height: 16)
								.foregroundColor(Color.green)

						}
					}
                    HStack {
                        Text("1.000")
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
                                    Text(self.voltageRange[index])
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                        }
                        HStack {
							Text("Change Voltage Limit")
								.font(.body)
                            Stepper(onIncrement: {}, onDecrement: {}) {
								Text("")
                            }
							.frame(width: 100, height: 40, alignment: .leading)
							Spacer()
							Text("5.000 V")
								.font(.headline)
						}
					}.padding()
                    VStack {
                        HStack {
                            Text("Current Inc:")
                            Picker("currentSet", selection: $selectorCurrent) {
                                ForEach(0 ..< currentRange.count) { index in
                                    Text(self.currentRange[index])
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                        }
                        HStack {
							Text("Change Current Limit")
							.font(.body)
                            Stepper(onIncrement: {}, onDecrement: {}) {
								Text("")
                            }
							.frame(width: 100, height: 40, alignment: .leading)
							Spacer()
							Text("1.000 A")
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
        ChannelView()
    }
}
