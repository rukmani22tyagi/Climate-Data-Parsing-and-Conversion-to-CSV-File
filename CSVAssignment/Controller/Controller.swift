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
    
    var delegate: CompletionHandler?
    private var maxTempTextLinks = [String]()
    private var minTempTextLinks = [String]()
    private var meanTempTextLinks = [String]()
    private var sunshineTextLinks = [String]()
    private var rainfallTextLinks = [String]()
    
    private var links = [[String]]()
    private var dictData = [DataModel]()
    
    public func getListOfTextFiles() {
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
                            print("error: ", error.localizedDescription)
                        }
                    }
                } catch {
                    print("error: ", error.localizedDescription)
                }
            } catch {
                print("error: ", error.localizedDescription)
            }
            self.links = [self.maxTempTextLinks, self.minTempTextLinks, self.meanTempTextLinks, self.sunshineTextLinks, self.rainfallTextLinks]
            self.delegate?.onGettingTextFileLinks(links: self.links)
        }
    }
    
    public func getDataOfTextFile(url: String, weatherParam: String, completed: @escaping GetDataCompletion) {
        do {
            let textFileData = try NSString(contentsOf: URL(string: url)!, encoding: String.Encoding.utf8.rawValue)
            let lines = textFileData.components(separatedBy: "\n")
            
            let regionCode = (lines[0].components(separatedBy: " ")).first
            var keys = [String]()
            var values = [String]()

            for index in 7..<lines.count-1 {
                let line = lines[index]
                var word = ""
                var spaceCount = 0
                
                for ch in 0..<line.characters.count {
                    if line[ch] != " " {
                        word.append(line[ch])
                        spaceCount = 0
                    } else {
                        spaceCount += 1
                        let emptyvalues = spaceCount/7 //Assuming gap between two consecutive values
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
                    let diff = keys.count - values.count
                    if diff > 0 {
                        for _ in 1...diff {
                            values.append("N/A")
                        }
                    }
                    for i in 1..<keys.count {
                        if values[i] == "---" {
                            values[i] = "N/A"
                        }
                        let dictClassElement = DataModel(_regionCode: regionCode!, _weatherParam: weatherParam, _year: values[0], _key: keys[i], _value: values[i])
                        self.dictData.append(dictClassElement)
                    }
                    values.removeAll()
                }
            }
        } catch {
            print("error: ", error.localizedDescription)
        }
        completed(self.dictData)
    }
}
