//
//  RangePickerView.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 17.05.2023.
//

import SwiftUI

struct RangePickerView: View {
    let title: String
    let limit: ClosedRange<Int>
    @Binding var range: ClosedRange<Int>
    
    var body: some View {
        VStack {
            VStack {
                Section(header: Text(title).padding()) {
                    Stepper(
                        "Min: \(range.lowerBound)",
                        onIncrement: {
                            if range.lowerBound + 1 < range.upperBound {
                                range = (range.lowerBound + 1)...range.upperBound
                            }
                        }, onDecrement: {
                            if range.lowerBound > limit.lowerBound {
                                range = (range.lowerBound - 1)...range.upperBound
                            }
                        })
                    
                    Stepper(
                        "Max: \(range.upperBound)",
                        onIncrement: {
                            if range.upperBound < limit.upperBound {
                                range = range.lowerBound...(range.upperBound + 1)
                            }
                        }, onDecrement: {
                            if range.lowerBound < range.upperBound - 1 {
                                range = range.lowerBound...(range.upperBound - 1)
                            }
                        })
                }
            }.padding()
            
            Divider()
                .padding()
        }
    }
}

struct RangePickerView_Previews: PreviewProvider {
    static var previews: some View {
        @State var range: ClosedRange<Int> = 0...10
        RangePickerView(title: "Total Works", limit: 0...10, range: $range)
    }
}
