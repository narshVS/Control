//
//  AffairModel.swift
//  Control
//
//  Created by Влад Овсюк on 06.11.2020.
//

import Foundation

struct AffairModel {
    let affairTitle: String
    let affairDescription: String
    let affairDate: (day: Int, month: Int, year: Int, hour: Int, minut: Int)
    let affairTime: String
    let affaitIsDone: Bool
}
