//
//  Date++.swift
//  DevilIsland
//
//  Created by Apple on 7/2/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

extension Date {
    func getConvert() -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        dateFormatter.locale = Locale.ReferenceType.system
        dateFormatter.timeZone = TimeZone.ReferenceType.system
        let dateFormatString: String = dateFormatter.string(from: self)
        return dateFormatString
    }
    func getConvert2() -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        dateFormatter.locale = Locale.ReferenceType.system
        dateFormatter.timeZone = TimeZone.ReferenceType.system
        let dateFormatString: String = dateFormatter.string(from: self)
        return dateFormatString
    }
}
