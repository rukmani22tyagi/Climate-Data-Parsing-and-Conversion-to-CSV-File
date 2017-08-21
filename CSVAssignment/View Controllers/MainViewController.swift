//
//  MainViewController.swift
//  CSVAssignment
//
//  Created by Rukmani  on 18/08/17.
//  Copyright © 2017 rukmani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var initialView: UIView!
    
    //MARK: Properties
    var pathName = URL(string: "")

    var dictData = [DataModel]()
    var listOfTextFiles = [[String]]()
    var controller = Controller()
    
    
    //MARK: UIController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isHidden = true
        self.initialView.isHidden = false
        self.controller.delegate = self as CompletionHandler
        self.controller.getListOfTextFiles()
    }
    
    //MARK: IBActions
    @IBAction func readCSVButtonTapped(_ sender: UIButton) {
        readCSVFile(fileName: "weather")
    }
    
    @IBAction func createCSVButtonTapped(_ sender: UIButton) {
        createCSVFile(file: "weather")
        self.initialView.isHidden  = true
        self.tableView.isHidden = false
    }
}

//Table View Methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dictData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            return UITableViewCell()
        }
        let data = dictData[indexPath.row]
        cell.textLabel?.text = "\(data.regionCode), \(data.weatherParam), \(data.year), \(data.key), \(data.value)"
        return cell
    }
}

//Delegate Method
extension ViewController: CompletionHandler {
    func onGettingTextFileLinks(links: [[String]]) {
        self.listOfTextFiles = links
        
        var weatherParam = WeatherParam.Tmax
        for region in 0..<4 {
            for weather_param in 0..<self.listOfTextFiles.count {
                let url = self.listOfTextFiles[weather_param][region]
                if url.contains("Tmax") {
                    weatherParam = WeatherParam.Tmax
                } else if url.contains("Tmin") {
                    weatherParam = WeatherParam.Tmin
                } else if url.contains("Tmean") {
                    weatherParam = WeatherParam.Tmean
                } else if url.contains("Sunshine") {
                    weatherParam = WeatherParam.Sunshine
                } else if url.contains("Rainfall") {
                    weatherParam = WeatherParam.Rainfall
                }
                
                self.controller.getDataOfTextFile(url: url, weatherParam : getWeatherParam(type: weatherParam) , completed: { dictData in
                    self.dictData = dictData
                })
            }
        }
    }
}
