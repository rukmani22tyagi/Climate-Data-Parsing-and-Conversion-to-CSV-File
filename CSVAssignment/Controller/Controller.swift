//
//  Controller.swift
//  CSVAssignment
//
//  Created by Rukmani  on 18/08/17.
//  Copyright © 2017 rukmani. All rights reserved.
//


import Foundation
import Alamofire
import SwiftSoup

class Controller {
    
    var maxTempTextLinks = [String]()
    var minTempTextLinks = [String]()
    var meanTempTextLinks = [String]()
    var sunshineTextLinks = [String]()
    var rainfallTextLinks = [String]()
    
    var dictData = [DictData]()
    
    func getListOfTextFiles(completed: @escaping GetAllDataCompletion) {
        let url = StaticURL.url
        
        Alamofire.request(url).response { response in
            let string = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
            
            do {
                let doc = try SwiftSoup.parse(string! as String)
                do {
                    let textLinks = try doc.select("a").array()
                    for link in textLinks {
                        do {
                            let text = try link.attr("href")
                            if text.contains("/date/") && (text.contains("/UK.txt") || text.contains("/England.txt") || text.contains("/Wales.txt") || text.contains("/Scotland.txt")) {
                                if text.contains("/Tmax/") {
                                    self.maxTempTextLinks.append(text)
                                }
                                if text.contains("/Tmin/") {
                                    self.minTempTextLinks.append(text)
                                }
                                if text.contains("/Tmean/") {
                                    self.meanTempTextLinks.append(text)
                                }
                                if text.contains("/Sunshine/") {
                                    self.sunshineTextLinks.append(text)
                                }
                                if text.contains("/Rainfall/") {
                                    self.rainfallTextLinks.append(text)
                                }
                            }
                        } catch {
                        }
                    }
                } catch {
                }
            } catch {
            }
            completed(self.maxTempTextLinks, self.minTempTextLinks, self.meanTempTextLinks, self.sunshineTextLinks, self.rainfallTextLinks)
        }
    }
    
    func getDataOfTextFile(url: String) {
        
        do {
            let textFileData = try NSString(contentsOf: URL(string: url)!, encoding: String.Encoding.utf8.rawValue)
            let lines = textFileData.components(separatedBy: "\n")
            
            var keys = [String]()
            var values = [String]()
            
            //            for index in 7..<lines.count-2 {
            //                let line = lines[index] + " "
            //                var word = ""
            //
            //                for ch in 0..<line.characters.count {
            //                    if line[ch] != " " {
            //                        word.append(line[ch])
            //                    } else if word != "" {
            //                        if index == 7 {
            //                            keys.append(word)
            //                        } else {
            //                            values.append(word)
            //                        }
            //                        word = ""
            //                    }
            //                }
            //                if index>7 {
            //                    for i in 1..<keys.count {
            //                        let dictClassElement = DictData(_regionCode: "", _weatherParam: "", _year: values[0], _key: keys[i], _value: values[i])
            //                        self.dictData.append(dictClassElement)
            //                    }
            //                    values.removeAll()
            //                }
            //            }
            
            for index in 7..<lines.count {
                let line = lines[index] + ""
                var word = ""
                var spaceCount = 0
                
                for ch in 0..<line.characters.count {
                    if line[ch] != " " {
                        word.append(line[ch])
                        spaceCount = 0
                    } else {
                        spaceCount += 1
                        let emptyvalues = spaceCount/6
                        if emptyvalues > 0 {
                            spaceCount = 0
                            for _ in 1...emptyvalues {
                                if index == 7 {
                                    keys.append("N/A")
                                } else {
                                    values.append("N/A")
                                }
                            }
                        }
                        if index == 7 && word != "" {
                            keys.append(word)
                        } else if word != "" {
                            values.append(word)
                        }
                        word = ""
                    }
                }
                if index == 7 {
                    keys.append(word)
                } else {
                    values.append(word)
                }
                
                if index>7 {
                    for i in 1..<keys.count {
                        let dictClassElement = DictData(_regionCode: "", _weatherParam: "", _year: values[0], _key: keys[i], _value: values[i])
                        self.dictData.append(dictClassElement)
                    }
                    values.removeAll()
                }
            }
            
            
        } catch {
        }
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}
