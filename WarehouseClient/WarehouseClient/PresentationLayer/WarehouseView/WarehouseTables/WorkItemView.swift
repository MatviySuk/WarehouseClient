//
//  WorkItemView.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 17.05.2023.
//

import SwiftUI

struct WorkItemView: View {
    let work: FactWorks
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center, spacing: .zero) {
                HStack(alignment: .center, spacing: .zero) {
                    HStack(spacing: .zero) {
                        Text("\(work.startDate.dateTitle) - \(work.endDate.dateTitle)")
                        
                            .frame(width: geo.size.width * 0.20)
                            .lineLimit(2)
                        Text(work.project.name)
                        
                            .frame(width: geo.size.width * 0.12)
                            .lineLimit(3)
                        Text(work.employee.fullName)
                        
                            .frame(width: geo.size.width * 0.12)
                            .lineLimit(3)
                    }
                    
                    HStack(spacing: .zero) {
                        Text("\(work.workedTimeMinutes)")
                        
                            .frame(width: geo.size.width * 0.08)
                        Text("\(work.estimatedTimeMinutes)")
                        
                            .frame(width: geo.size.width * 0.08)
                        Text("\(work.delayedTimeMinutes)")
                        
                            .frame(width: geo.size.width * 0.08)
                        Text("\(work.totalWorksCount)")
                        
                            .frame(width: geo.size.width * 0.08)
                        Text("\(work.successfulWorksCount)")
                        
                            .frame(width: geo.size.width * 0.08)
                        Text("\(work.failedWorksCount)")
                        
                            .frame(width: geo.size.width * 0.08)
                        Text("\(work.delayedWorksCount)")
                        
                            .frame(width: geo.size.width * 0.08)
                    }
                }
                .multilineTextAlignment(.center)
            }
            .frame(minHeight: 50, maxHeight: 100, alignment: .center)
        }
    }
}

struct WorkItemView_Previews: PreviewProvider {
    static var previews: some View {
        WorkItemView(work: .init(
            id: 1,
            project: .init(
                id: 1,
                projectManager: .init(
                    id: 1,
                    role: .init(id: 1, name: "Manager"),
                    fullName: "Name Surname",
                    birthday: "2000-10-10",
                    email: "example@gmail.com",
                    phone: "213-1231"
                ),
                industry: .init(id: 1, name: "Health"),
                name: "Project A",
                description: "Project Description",
                category: "Games"),
            startDate: .init(id: 1, year: 2022, month: 10, day: 10),
            endDate: .init(id: 2, year: 2022, month: 11, day: 10),
            employee: .init(
                id: 1,
                role: .init(id: 1, name: "Manager"),
                fullName: "Name Surname",
                birthday: "2000-10-10",
                email: "example@gmail.com",
                phone: "213-1231"
            ),
            workedTimeMinutes: 100,
            estimatedTimeMinutes: 150,
            delayedTimeMinutes: 50,
            totalWorksCount: 2,
            successfulWorksCount: 1,
            delayedWorksCount: 2,
            failedWorksCount: 1)
        )
    }
}
