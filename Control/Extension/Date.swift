//
//  Date.swift
//  Control
//
//  Created by Влад Овсюк on 05.11.2020.
//

import Foundation

extension Date {
    func getDateComponents(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func getDateInt(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func setDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date{
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let userCalendar = Calendar.current // user calendar
        let date = userCalendar.date(from: dateComponents)!
        return date
    }
}
