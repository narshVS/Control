//
//  DateHelper.swift
//  Control
//
//  Created by Влад Овсюк on 05.11.2020.
//

import Foundation

final class DateHelper {
    
    // MARK: - Static Properties
    
    static var date: DateHelper = {
        return DateHelper()
    }()
    
    // MARK: - Public Properties
    
    let monthSourse: Array<String> = [NSLocalizedString("January", comment: "Month"),
                                      NSLocalizedString("February", comment: "Month"),
                                      NSLocalizedString("March", comment: "Month"),
                                      NSLocalizedString("April", comment: "Month"),
                                      NSLocalizedString("May", comment: "Month"),
                                      NSLocalizedString("June", comment: "Month"),
                                      NSLocalizedString("July", comment: "Month"),
                                      NSLocalizedString("August", comment: "Month"),
                                      NSLocalizedString("September", comment: "Month"),
                                      NSLocalizedString("October", comment: "Month"),
                                      NSLocalizedString("November", comment: "Month"),
                                      NSLocalizedString("December", comment: "Month")]
    var yearSourse: Array<Int> = []

    // MARK: - Public Metod
    
    func configue() {
        setYearSourseForPicker(year: getTodaysDate().year)
    }
    
    func getTodaysDate() -> DateModel {
        let date = Date()
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        
        let retunrDate = DateModel(weekdayInt: weekday, day: day, month: month, year: year, hour: hour, minute: minute, dayIsSelected: true)
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
    
    // MARK: - Private metod
    
    private func setYearSourseForPicker(year: Int) {
        yearSourse.append(year - 1)
        yearSourse.append(year)
        yearSourse.append(year + 1)
    }
}
