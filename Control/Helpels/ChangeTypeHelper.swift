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
            weekdayString = "Sun"
        case 2:
            weekdayString = "Mon"
        case 3:
            weekdayString = "Tue"
        case 4:
            weekdayString = "Wed"
        case 5:
            weekdayString = "Thu"
        case 6:
            weekdayString = "Fri"
        case 7:
            weekdayString = "Sat"
        default:
            break
        }
        return weekdayString
    }
    
    func weekdayIntToStringLong(weekday: Int) -> String {
        var weekdayString = ""
        
        switch weekday {
        case 1:
            weekdayString = "Sunday"
        case 2:
            weekdayString = "Monday"
        case 3:
            weekdayString = "Tuesday"
        case 4:
            weekdayString = "Wednesday"
        case 5:
            weekdayString = "Thursday"
        case 6:
            weekdayString = "Friday"
        case 7:
            weekdayString = "Saturday"
        default:
            break
        }
        return weekdayString
    }
    
    func monthIntToStringLong(month: Int) -> String {
        var monthString = ""
        
        switch month {
        case 1:
            monthString = "January"
        case 2:
            monthString = "February"
        case 3:
            monthString = "March"
        case 4:
            monthString = "April"
        case 5:
            monthString = "May"
        case 6:
            monthString = "June"
        case 7:
            monthString = "July"
        case 8:
            monthString = "August"
        case 9:
            monthString = "September"
        case 10:
            monthString = "October"
        case 11:
            monthString = "November"
        case 12:
            monthString = "December"
        default:
            break
        }
        return monthString
    }
    
    func monthStringToInd(month: String) -> Int{
        var monthInt = 0
        
        switch month {
        case "January":
            monthInt = 1
        case "February":
            monthInt = 2
        case "March":
            monthInt = 3
        case "April":
            monthInt = 4
        case "May":
            monthInt = 5
        case "June":
            monthInt = 6
        case "July":
            monthInt = 7
        case "August":
            monthInt = 8
        case "September":
            monthInt = 9
        case "October":
            monthInt = 10
        case "November":
            monthInt = 11
        case "December":
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
