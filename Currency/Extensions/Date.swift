//
//  Date.swift
//  Currency
//
//  Created by Ali Murad on 30/11/2022.
//

import Foundation

extension Date {
    
    func getCurrentDate() -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        return dateformat.string(from: self)
    }
    
    func getThreeDaysBeforeDate() -> String {
        var dayComponent    = DateComponents()
        dayComponent.day    = -3
        let theCalendar     = Calendar.current
        let nextDate        = theCalendar.date(byAdding: dayComponent, to: Date())
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        return dateformat.string(from: nextDate ?? self)
    }
}
