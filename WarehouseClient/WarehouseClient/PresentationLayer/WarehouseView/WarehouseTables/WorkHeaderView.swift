//
//  WorkHeaderView.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 17.05.2023.
//

import SwiftUI

struct WorkHeaderView: View {
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: .zero) {
                Spacer()
                
                HStack(alignment: .center, spacing: .zero) {
                    HStack(spacing: .zero) {
                        Text("Time Period")
                            .padding(4)
                            .frame(width: geo.size.width * 0.2)
                        Text("Project Name")
                            .padding(4)
                            .frame(width: geo.size.width * 0.12)
                        Text("Employee")
                            .padding(4)
                            .frame(width: geo.size.width * 0.12)
                    }
                    
                    HStack(spacing: .zero) {
                        Text("Total Time Mins")
                            .padding(4)
                            .frame(width: geo.size.width * 0.08)
                        Text("Estimated Time Mins")
                            .padding(4)
                            .frame(width: geo.size.width * 0.08)
                        Text("Delayed Time Mins")
                            .padding(4)
                            .frame(width: geo.size.width * 0.08)
                        Text("Total Works")
                            .padding(4)
                            .frame(width: geo.size.width * 0.08)
                        Text("Successful Works")
                            .padding(4)
                            .frame(width: geo.size.width * 0.08)
                        Text("Failed Works")
                            .padding(4)
                            .frame(width: geo.size.width * 0.08)
                        Text("Delayed Works")
                            .padding(4)
                            .frame(width: geo.size.width * 0.08)
                    }
                }
                .multilineTextAlignment(.center)
                .foregroundColor(.accentColor)
                .bold()
                
                Spacer()
            }
        }
    }
}

struct WorkHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        WorkHeaderView()
    }
}
