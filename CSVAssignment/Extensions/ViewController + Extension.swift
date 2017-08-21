//
//  ViewController + Extension.swift
//  CSVAssignment
//
//  Created by Rukmani  on 21/08/17.
//  Copyright © 2017 rukmani. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    enum WeatherParam {
        case Tmax
        case Tmin
        case Tmean
        case Sunshine
        case Rainfall
    }
    
    func getWeatherParam(type: WeatherParam) -> String{
        switch type {
        case .Tmax: return "Max Temp"
        case .Tmin: return "Min Temp"
        case .Tmean: return "Mean Temp"
        case .Sunshine: return "Sunshine"
        case .Rainfall: return "Rainfall"
        }
    }
    
    func createCSVFile(file: String) {
        let fileName = file + ".csv"
        var csvText = "region_code,weather_param,year,key,value\n"
        
        for data in dictData {
            let newLine = "\(data.regionCode),\(data.weatherParam),\(data.year),\(data.key),\(data.value)\n"
            csvText.append(newLine)
        }
        
        do {
            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let path = dir?.appendingPathComponent(fileName)
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            print("path : ",path!)
            self.pathName = path!
            
        } catch {
            print("csv file cannot be created")
        }
        readCSVFile(fileName: "weather")
    }
    
    func readCSVFile(fileName: String) {
        do {
            let content = try String(contentsOf: self.pathName!, encoding: String.Encoding.utf8)
            dictData.removeAll()
            var lines = content.components(separatedBy: "\n")
            lines.removeLast()
            for line in lines {
                let columns = line.components(separatedBy: ",")
                let dict = DataModel(_regionCode: columns[0], _weatherParam: columns[1], _year: columns[2], _key: columns[3], _value: columns[4])
                self.dictData.append(dict)
            }
        } catch {
            print("error: ", error.localizedDescription)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
