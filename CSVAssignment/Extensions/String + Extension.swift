//
//  String + Extension.swift
//  CSVAssignment
//
//  Created by Rukmani  on 21/08/17.
//  Copyright © 2017 rukmani. All rights reserved.
//

import Foundation

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}
