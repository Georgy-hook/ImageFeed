//
//  DateFormatter.swift
//  ImageFeed
//
//  Created by Georgy on 28.05.2023.
//

import UIKit
class AppDateFormatter {
    static let shared = AppDateFormatter()
    
    private init() {}
    
    private lazy var dateFormatterToString: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    private lazy var dateFormatterFromJSON: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    func dateToString(with date:Date?) -> String{
        guard let date = date else {return ""}
        return dateFormatterToString.string(from: date)
    }
    
    func stringToDate(with string:String) -> Date?{
        return dateFormatterFromJSON.date(from: string)
    }
}
