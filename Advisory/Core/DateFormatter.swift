//
//  DateFormatter.swift
//  Advisory
//
//  Created by Igor Manakov on 12.11.2022.
//

import Foundation

extension DateFormatter {
    static let mediumFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateStyle = .medium
      return formatter
    }()
}
