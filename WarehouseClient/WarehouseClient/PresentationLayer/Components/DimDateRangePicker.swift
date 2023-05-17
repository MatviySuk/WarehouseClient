//
//  DimDateRangePicker.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 17.05.2023.
//

import SwiftUI

struct DimDateRangePicker: View {
    let title: String
    let limit: ClosedRange<Int>
    @Binding var dates: [DimDate]
    @Binding var range: ClosedRange<Int>
    
    var body: some View {
        VStack {
            VStack {
                Section(header: Text(title).padding()) {
                    Stepper(
                        "From: \(dates[range.lowerBound].dateTitle)",
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
                        "To: \(dates[range.upperBound].dateTitle)",
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

struct DimDateRangePicker_Previews: PreviewProvider {
    static var previews: some View {
        @State var range: ClosedRange<Int> = 0...10
        DimDateRangePicker(title: "Total Works", limit: 0...10, dates: .constant([]), range: $range)
    }
}
