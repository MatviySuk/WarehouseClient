//
//  WorkDetailedView.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 17.05.2023.
//

import SwiftUI

struct WorkDetailedView: View {
    let work: FactWorks
    
    var body: some View {
        Form {
            Section("Work") {
                Text("Start Date: \(work.startDate.dateTitle)")
                Text("End Date: \(work.endDate.dateTitle)")
                
                Text("Total Time Minutes: \(work.workedTimeMinutes)")
                Text("Estimated Time Minutes: \(work.estimatedTimeMinutes)")
                Text("Delayed Time Minutes: \(work.delayedTimeMinutes)")
                Text("Total Works Number: \(work.totalWorksCount)")
                Text("Successful Works Number: \(work.successfulWorksCount)")
                Text("Failed Works Number: \(work.failedWorksCount)")
                Text("Delayed Works Number: \(work.delayedWorksCount)")
            }
            
            Section("Project") {
                Text("Name: \(work.project.name)")
                Text("Description: \(work.project.description)")
                Text("Category: \(work.project.category)")
            }
            
            Section("Industry") {
                Text("Name: \(work.project.industry.name)")
            }
            
            Section("Project Manager") {
                Text("Full Name: \(work.project.projectManager.fullName)")
                Text("Birthday: \(work.project.projectManager.birthday)")
                Text("Email: \(work.project.projectManager.email)")
                Text("Phone: \(work.project.projectManager.phone)")
            }
            
            Section("Employee") {
                Text("Full Name: \(work.employee.fullName)")
                Text("Birthday: \(work.employee.birthday)")
                Text("Email: \(work.employee.email)")
                Text("Phone: \(work.employee.phone)")
            }
        }
    }
}

struct WorkDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        WorkDetailedView(work: .init(
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
