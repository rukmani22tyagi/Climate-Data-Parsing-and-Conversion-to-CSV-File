//
//  MainViewController.swift
//  CSVAssignment
//
//  Created by Rukmani  on 18/08/17.
//  Copyright © 2017 rukmani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var listOfTextFiles = [[String]]()
    var dictData = [DictData]()
    let controller = Controller()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller.getListOfTextFiles(completed: { maxTempList, minTempList, meanTempList, sunshineList, rainfallList in
            self.listOfTextFiles = [maxTempList, minTempList, meanTempList, sunshineList, rainfallList]
            //            print(maxTempList.count)
            //            print(minTempList.count)
            //            print(meanTempList.count)
            //            print(sunshineList.count)
            //            print(rainfallList.count)

            self.controller.getDataOfTextFile(url: (self.listOfTextFiles.first?.first)!)
        })
    }
}
