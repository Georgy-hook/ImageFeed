//
//  DateFormatter.swift
//  ImageFeed
//
//  Created by Georgy on 28.05.2023.
//

import UIKit
private var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()
extension Date {
    var dateString: String { dateFormatter.string(from: self) }
}
