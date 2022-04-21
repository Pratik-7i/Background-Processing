
//
//  Date+Extension.swift
//  AQI
//
//  Created by Pratik on 14/12/21.
//

import Foundation

extension Date
{
    func timeAgo() -> String
    {
        let interval = Calendar.current.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: self, to: Date())

        if let year = interval.year, year > 0 {
            return year == 1 ? "last year" : "\(year)" + " years ago"
        }
        else if let month = interval.month, month > 0 {
            return month == 1 ? "last month" : "\(month)" + " months ago"
        }
        else if let weekOfYear = interval.weekOfYear, weekOfYear > 0 {
            return weekOfYear == 1 ? "last week" : "\(weekOfYear)" + " weeks ago"
        }
        else if let day = interval.day, day > 0 {
            return day == 1 ? "Yesterday" : "\(day)" + " days ago"
        }
        else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "an hour ago" : "\(self.readable(format: "h:mm a"))"
        }
        else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "a minute ago" : "\(minute)" + " mins ago"
        }
        else if let second = interval.second, second > 2 {
            return "a few seconds ago"
        }
        else {
            return "just now"
        }
    }
    
    func readable(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
