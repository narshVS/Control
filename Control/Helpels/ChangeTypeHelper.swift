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
            weekdayString = "Вс"
        case 2:
            weekdayString = "Пн"
        case 3:
            weekdayString = "Вт"
        case 4:
            weekdayString = "Ср"
        case 5:
            weekdayString = "Чт"
        case 6:
            weekdayString = "Пт"
        case 7:
            weekdayString = "Сб"
        default:
            break
        }
        return weekdayString
    }
    
    func weekdayIntToStringLong(weekday: Int) -> String {
        var weekdayString = ""
        
        switch weekday {
        case 1:
            weekdayString = "Воскресенье"
        case 2:
            weekdayString = "Понедельник"
        case 3:
            weekdayString = "Вторник"
        case 4:
            weekdayString = "Среда"
        case 5:
            weekdayString = "Четверг"
        case 6:
            weekdayString = "Пятница"
        case 7:
            weekdayString = "Суббота"
        default:
            break
        }
        return weekdayString
    }
    
    func monthIntToStringLong(month: Int) -> String {
        var monthString = ""
        
        switch month {
        case 1:
            monthString = "Январь"
        case 2:
            monthString = "Февраль"
        case 3:
            monthString = "Март"
        case 4:
            monthString = "Апрель"
        case 5:
            monthString = "Май"
        case 6:
            monthString = "Июнь"
        case 7:
            monthString = "Июль"
        case 8:
            monthString = "Август"
        case 9:
            monthString = "Сентябрь"
        case 10:
            monthString = "Октябрь"
        case 11:
            monthString = "Ноябрь"
        case 12:
            monthString = "Декабрь"
        default:
            break
        }
        return monthString
    }
    
    func monthStringToInd(month: String) -> Int{
        var monthInt = 0
        
        switch month {
        case "Январь":
            monthInt = 1
        case "Февраль":
            monthInt = 2
        case "Март":
            monthInt = 3
        case "Апрель":
            monthInt = 4
        case "Май":
            monthInt = 5
        case "Июнь":
            monthInt = 6
        case "Июль":
            monthInt = 7
        case "Август":
            monthInt = 8
        case "Сентябрь":
            monthInt = 9
        case "Октябрь":
            monthInt = 10
        case "Ноябрь":
            monthInt = 11
        case "Декабрь":
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
