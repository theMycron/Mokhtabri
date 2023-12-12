//
//  HelperFunctions.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 12/12/2023.
//

import Foundation


func dateComponentsToDate(_ dateComponents: DateComponents) -> Date? {
    guard let _ = dateComponents.year,
          let _ = dateComponents.month,
          let _ = dateComponents.day
    else {return nil}
    let calendar = Calendar.current
    let date = calendar.date(from: dateComponents)
    return date
}


func dateComponentsToTime(_ dateComponents: DateComponents) -> String? {
    guard let _ = dateComponents.hour,
          let _ = dateComponents.minute
    else {return nil}
    let calendar = Calendar.current
    let date = calendar.date(from: dateComponents)
    return date?.formatted(date: Date.FormatStyle.DateStyle.omitted, time: Date.FormatStyle.TimeStyle.shortened)
    
}
