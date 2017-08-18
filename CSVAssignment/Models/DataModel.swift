//
//  DataModel.swift
//  CSVAssignment
//
//  Created by Rukmani  on 18/08/17.
//  Copyright © 2017 rukmani. All rights reserved.
//

import Foundation

class DictData {
    var regionCode: String
    var weatherParam: String
    var year: String
    var key: String
    var value: String
    
    init(_regionCode: String, _weatherParam: String, _year: String, _key: String, _value: String) {
        self.regionCode = _regionCode
        self.weatherParam = _weatherParam
        self.year = _year
        self.key = _key
        self.value = _value
    }
}
