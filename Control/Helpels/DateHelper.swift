//
//  DateHelper.swift
//  Control
//
//  Created by Влад Овсюк on 05.11.2020.
//

import Foundation

final class DateHelper {
    
    static var date: DateHelper = {
        return DateHelper()
    }()
    
    var daySourse: Array<Int> = []
    let monthSourse: Array<String> = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    var yearSourse: Array<Int> = []
    
    func configue() {
        setYearSourseForPicker(year: getTodaysDate().year)
        setDaySourseForPicker(month: getTodaysDate().month, year: getTodaysDate().year)
    }
    
    func getTodaysDate() -> DateModel {
        let date = Date()
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        let retunrDate = DateModel(weekdayInt: weekday, day: day, month: month, year: year, dayIsSelected: true)
        return retunrDate
    }
    
    func firstWeekdayinMonth(month: Int, year: Int) -> Int{
        let dateComponents = NSDateComponents()
        dateComponents.year = year
        dateComponents.month = month
        
        let calendar = NSCalendar.current
        let date = calendar.date(from: dateComponents as DateComponents)!
        
        let firstWeekdayinMonth = calendar.component(.weekday, from: date)
        return firstWeekdayinMonth
    }
    
    func setDaySourseForPicker(month: Int, year: Int) {
        let dateComponents = NSDateComponents()
        dateComponents.year = year
        dateComponents.month = month
        
        let calendar = NSCalendar.current
        let date = calendar.date(from: dateComponents as DateComponents)!
        
        let dayInMonth = calendar.range(of: .day, in: .month, for: date)!
        
        daySourse.removeAll()
        for day in dayInMonth {
            daySourse.append(day)
        }
    }
    
    private func setYearSourseForPicker(year: Int) {
        yearSourse.append(year - 1)
        yearSourse.append(year)
        yearSourse.append(year + 1)
    }
}
