//
//  AffairCollectionViewCell.swift
//  ControlApp
//
//  Created by Влад Овсюк on 31.10.2020.
//

import UIKit

final class AffairCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var numberOfDayLabel: UILabel!
    
    static let reusableId = "AffairCollectionViewCell"
    
    func configure(with date: DeteModel) {
        numberOfDayLabel.text = "\(date.numberOfWeek)"
        dayOfWeek(weekday: date.dayOfWeek)
    }
    
    func dayOfWeek(weekday: Int) {
        switch weekday {
        case 1:
            dayOfWeekLabel.text = "Вс"
        case 2:
            dayOfWeekLabel.text = "Пн"
        case 3:
            dayOfWeekLabel.text = "Вт"
        case 4:
            dayOfWeekLabel.text = "Ср"
        case 5:
            dayOfWeekLabel.text = "Чт"
        case 6:
            dayOfWeekLabel.text = "Пт"
        case 7:
            dayOfWeekLabel.text = "Сб"
        default:
            break
        }
    }
}
