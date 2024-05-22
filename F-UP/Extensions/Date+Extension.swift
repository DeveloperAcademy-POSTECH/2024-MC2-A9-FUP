//
//  Date+Extension.swift
//  F-UP
//
//  Created by namdghyun on 5/22/24.
//

import Foundation

extension Date {
    func dateToString() -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_kr")
        df.dateFormat = "YYYY-MM-dd"
        
        return df.string(from: self)
    }
}
