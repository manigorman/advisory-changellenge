//
//  DateFormatter.swift
//  Advisory
//
//  Created by Igor Manakov on 12.11.2022.
//

import Foundation

extension DateFormatter {
    static let mediumFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        return dateFormatter
    }()
    
    static func ruRuLong(_ date: Date) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        switch true {
        case Calendar.current.isDateInToday(date) || Calendar.current.isDateInYesterday(date):
            dateFormatter.doesRelativeDateFormatting = true
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
        case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear):
            dateFormatter.dateFormat = "EEEE hh:mm"
        case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year):
            dateFormatter.dateFormat = "E, d MMM"
        default:
            dateFormatter.dateFormat = "MMM d, yyyy, hh:mm"
        }
        
        return dateFormatter
    }
}
