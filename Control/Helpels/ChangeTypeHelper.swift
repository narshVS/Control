//
//  Metods.swift
//  Control
//
//  Created by Влад Овсюк on 02.11.2020.
//

import Foundation

final class ChangeTypeHelper {
    
    static var changeType: ChangeTypeHelper = {
        return ChangeTypeHelper()
    }()
    
    func weekdayIntToStringShort(weekday: Int) -> String {
        var weekdayString = ""
        
        switch weekday {
        case 1:
            weekdayString = NSLocalizedString("Sun", comment: "WeekdayShort")
        case 2:
            weekdayString = NSLocalizedString("Mon", comment: "WeekdayShort")
        case 3:
            weekdayString = NSLocalizedString("Tue", comment: "WeekdayShort")
        case 4:
            weekdayString = NSLocalizedString("Wed", comment: "WeekdayShort")
        case 5:
            weekdayString = NSLocalizedString("Thu", comment: "WeekdayShort")
        case 6:
            weekdayString = NSLocalizedString("Fri", comment: "WeekdayShort")
        case 7:
            weekdayString = NSLocalizedString("Sat", comment: "WeekdayShort")
        default:
            break
        }
        return weekdayString
    }
    
    func weekdayIntToStringLong(weekday: Int) -> String {
        var weekdayString = ""
        
        switch weekday {
        case 1:
            weekdayString = NSLocalizedString("Sunday", comment: "WeekdayLong")
        case 2:
            weekdayString = NSLocalizedString("Monday", comment: "WeekdayLong")
        case 3:
            weekdayString = NSLocalizedString("Tuesday", comment: "WeekdayLong")
        case 4:
            weekdayString = NSLocalizedString("Wednesday", comment: "WeekdayLong")
        case 5:
            weekdayString = NSLocalizedString("Thursday", comment: "WeekdayLong")
        case 6:
            weekdayString = NSLocalizedString("Friday", comment: "WeekdayLong")
        case 7:
            weekdayString = NSLocalizedString("Saturday", comment: "WeekdayLong")
        default:
            break
        }
        return weekdayString
    }
    
    func monthIntToStringLong(month: Int) -> String {
        var monthString = ""
        
        switch month {
        case 1:
            monthString = NSLocalizedString("January", comment: "Month")
        case 2:
            monthString = NSLocalizedString("February", comment: "Month")
        case 3:
            monthString = NSLocalizedString("March", comment: "Month")
        case 4:
            monthString = NSLocalizedString("April", comment: "Month")
        case 5:
            monthString = NSLocalizedString("May", comment: "Month")
        case 6:
            monthString = NSLocalizedString("June", comment: "Month")
        case 7:
            monthString = NSLocalizedString("July", comment: "Month")
        case 8:
            monthString = NSLocalizedString("August", comment: "Month")
        case 9:
            monthString = NSLocalizedString("September", comment: "Month")
        case 10:
            monthString = NSLocalizedString("October", comment: "Month")
        case 11:
            monthString = NSLocalizedString("November", comment: "Month")
        case 12:
            monthString = NSLocalizedString("December", comment: "Month")
        default:
            break
        }
        return monthString
    }
    
    func monthStringToInd(month: String) -> Int{
        var monthInt = 0
        
        switch month {
        case NSLocalizedString("January", comment: "Month"):
            monthInt = 1
        case NSLocalizedString("February", comment: "Month"):
            monthInt = 2
        case NSLocalizedString("March", comment: "Month"):
            monthInt = 3
        case NSLocalizedString("April", comment: "Month"):
            monthInt = 4
        case NSLocalizedString("May", comment: "Month"):
            monthInt = 5
        case NSLocalizedString("June", comment: "Month"):
            monthInt = 6
        case NSLocalizedString("July", comment: "Month"):
            monthInt = 7
        case NSLocalizedString("August", comment: "Month"):
            monthInt = 8
        case NSLocalizedString("September", comment: "Month"):
            monthInt = 9
        case NSLocalizedString("October", comment: "Month"):
            monthInt = 10
        case NSLocalizedString("November", comment: "Month"):
            monthInt = 11
        case NSLocalizedString("December", comment: "Month"):
            monthInt = 12
        default:
            break
        }
        return monthInt
    }
    
    func hourShortToLong(date: Date) -> String {
        let hour = date.getDateComponents(.hour)
        var hourString: String = ""
        
        switch hour.hour{
        case 0:
            hourString = "00"
        case 1:
            hourString = "01"
        case 2:
            hourString = "02"
        case 3:
            hourString = "03"
        case 4:
            hourString = "04"
        case 5:
            hourString = "05"
        case 6:
            hourString = "06"
        case 7:
            hourString = "07"
        case 8:
            hourString = "08"
        case 9:
            hourString = "09"
        default:
            hourString = "\(hour.hour ?? 0)"
        }
        return hourString
    }
    
    func minuteShortToLong(date: Date) -> String{
        let minute = date.getDateComponents(.minute)
        var minuteString: String = ""
        
        switch minute.minute{
        case 0:
            minuteString = "00"
        case 1:
            minuteString = "01"
        case 2:
            minuteString = "02"
        case 3:
            minuteString = "03"
        case 4:
            minuteString = "04"
        case 5:
            minuteString = "05"
        case 6:
            minuteString = "06"
        case 7:
            minuteString = "07"
        case 8:
            minuteString = "08"
        case 9:
            minuteString = "09"
        default:
            minuteString = "\(minute.minute ?? 0)"
        }
        return minuteString
    }
}
