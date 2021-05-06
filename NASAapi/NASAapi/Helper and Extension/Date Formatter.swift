//
//  Date Formatter.swift
//  NASAapi
//
//  Created by Tiffany Sakaguchi on 5/5/21.
//

import Foundation

extension DateFormatter {
    
    static func formatDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
}

