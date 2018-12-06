//
//  EventModel.swift
//  Calender
//
//  Created by Jesse Li on 11/28/18.
//  Copyright © 2018 Jesse Li. All rights reserved.
//

import Foundation

class EventModel {
    struct User {
        var weekdayStartTime: Date
        var weekdayEndTime: Date
        var weekendStartTime: Date
        var weekendEndTime: Date
        var isMorningPerson: Bool
        var advanceDate: Int
        var isSplit: Bool
        var isDifficult: Bool
    }
    
    struct ReoccuringEvent {
        var title: String
        var location: String
        var startDate: Date
        var endDate: Date
        var startTime: Date
        var endTime: Date
        var category: Category
        var week: [Week]
    }
    
    struct StandAloneEvent{
        var title: String
        var location: String
        var startDate: Date
        var StartTime: Date
        var EndTime: Date
        var category: Category
    }
    
    struct Tasks{
        var title: String
        var location: String
        var deadline: Date
        var isSplittable: Bool
        var category: Category
        var Priority: Int
        var Difficult: Int
        //var ExpectedAllocatedTime: TimeEnum
    }
    
    enum Category: String {
        case school = "School"
        case work = "Work"
        case social = "Social"
        case fitness = "Fitness"
        case other = "Other"
    }
    
    enum Frequence {
        case Daily
        case Weekly
        case Monthly
        case None
    }
    
    enum Week: String {
        case sunday
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
    }
}
