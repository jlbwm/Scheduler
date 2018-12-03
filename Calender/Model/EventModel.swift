//
//  EventModel.swift
//  Calender
//
//  Created by Jesse Li on 11/28/18.
//  Copyright © 2018 Jesse Li. All rights reserved.
//

import Foundation

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

struct Event {
    var frequence: Frequence = .None
    var week: [Week]
    var date: Date
    var startTime: Date
    var endTime: Date
    var location: String
    var category: Category
    var title: String
    var isNotification: Bool
    var notifyTime: Date
    var notes: String
}

enum Category {
    case school
    case work
    case social
    case fitness
    case rest
    case other
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
    case saturdays
}

