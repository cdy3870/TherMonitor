//
//  ThirdViewController.swift
//  TherMonitor
//
//  Created by Alyssa Jordan on 9/20/20.
//  Copyright © 2020 Alyssa Jordan. All rights reserved.
//

import UIKit
import Charts
import FirebaseDatabase

class ThirdViewController: UIViewController {
    

    @IBOutlet weak var weekBarChart: BarChartView!
    @IBOutlet weak var sun: UIButton!
    @IBOutlet weak var mon: UIButton!
    @IBOutlet weak var tues: UIButton!
    @IBOutlet weak var wed: UIButton!
    @IBOutlet weak var thurs: UIButton!
    @IBOutlet weak var fri: UIButton!
    @IBOutlet weak var sat: UIButton!
    
    
    var databaseHandle: DatabaseHandle?
    var ref: DatabaseReference?
    
    var set = BarChartDataSet()
    var hours = ["","9am", "10am", "11am", "12pm", "1pm", "2pm", "3pm", "4pm", "5pm", "6pm"]
    var dbHours: Array<Double> = Array(repeating: 0, count: 24)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = BarChartData(dataSet: set)
        weekBarChart.data = data
        
        let currentTime = Date()
        var calendar = Calendar.current
        
        if let timeZone = TimeZone(identifier: "EST"){
            calendar.timeZone = timeZone
        }
        

        // Do any additional setup after loading the view.
        weekBarChart.rightAxis.enabled = false
        weekBarChart.leftAxis.enabled = false
        weekBarChart.legend.enabled = false
        weekBarChart.xAxis.labelPosition = .bottom
        weekBarChart.xAxis.drawGridLinesEnabled = false
        weekBarChart.xAxis.setLabelCount(9, force: false)
        weekBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:hours)
        
        
        
    }
    
    func makeBarChart(day: UIButton){
        self.set.colors = ChartColorTemplates.liberty() 
        let data = BarChartData(dataSet: set)
        weekBarChart.data = data
        self.sun.backgroundColor = UIColor.white
        self.mon.backgroundColor = UIColor.white
        self.tues.backgroundColor = UIColor.white
        self.wed.backgroundColor = UIColor.white
        self.thurs.backgroundColor = UIColor.white
        self.fri.backgroundColor = UIColor.white
        self.sat.backgroundColor = UIColor.white
        day.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func sunday(_ sender: Any) {
    
        let cDay = String(0)
        // Database Stuff
        ref = Database.database().reference()
        databaseHandle = ref?.child("WeeklyHourlyAverages").child(cDay).observe(.value, with: { [self](snapshot) in
            var i = 0
            for cDay in snapshot.children.allObjects as![DataSnapshot]{
                //print("i: \(i)")
                let hourObj = cDay.value as? [String: Any]
                let hourAvg = hourObj?["average"]
                self.dbHours[i] = hourAvg as! Double
                //print("db hour \(self.dbHours[i])")
                i+=1
                
                //print("Hour Object: \(hourObj)")
                
            }
            
            self.set = BarChartDataSet(entries: [
                    BarChartDataEntry(x: Double(1),y: self.dbHours[9]),
                    BarChartDataEntry(x: Double(2),y: self.dbHours[10]),
                    BarChartDataEntry(x: Double(3),y: self.dbHours[11]),
                    BarChartDataEntry(x: Double(4),y: self.dbHours[12]),
                    BarChartDataEntry(x: Double(5),y: self.dbHours[13]),
                    BarChartDataEntry(x: Double(6),y: self.dbHours[14]),
                    BarChartDataEntry(x: Double(7),y: self.dbHours[15]),
                    BarChartDataEntry(x: Double(8),y: self.dbHours[16]),
                    BarChartDataEntry(x: Double(9),y: self.dbHours[17]),
                    BarChartDataEntry(x: Double(10),y: self.dbHours[18])
              ], label: "Hour")
        
            self.makeBarChart(day: sun)
        })
        
    }
    
    @IBAction func monday(_ sender: Any) {
        let cDay = String(1)
        // Database Stuff
        ref = Database.database().reference()
        databaseHandle = ref?.child("WeeklyHourlyAverages").child(cDay).observe(.value, with: { [self](snapshot) in
            var i = 0
            for cDay in snapshot.children.allObjects as![DataSnapshot]{
                //print("i: \(i)")
                let hourObj = cDay.value as? [String: Any]
                let hourAvg = hourObj?["average"]
                self.dbHours[i] = hourAvg as! Double
                //print("db hour \(self.dbHours[i])")
                i+=1
                
                //print("Hour Object: \(hourObj)")
                
            }
            
            self.set = BarChartDataSet(entries: [
                BarChartDataEntry(x: Double(1),y: self.dbHours[9]),
                BarChartDataEntry(x: Double(2),y: self.dbHours[10]),
                BarChartDataEntry(x: Double(3),y: self.dbHours[11]),
                BarChartDataEntry(x: Double(4),y: self.dbHours[12]),
                BarChartDataEntry(x: Double(5),y: self.dbHours[13]),
                BarChartDataEntry(x: Double(6),y: self.dbHours[14]),
                BarChartDataEntry(x: Double(7),y: self.dbHours[15]),
                BarChartDataEntry(x: Double(8),y: self.dbHours[16]),
                BarChartDataEntry(x: Double(9),y: self.dbHours[17]),
                BarChartDataEntry(x: Double(10),y: self.dbHours[18])
              ], label: "Hour")
        
            self.makeBarChart(day: mon)
        })
    }
    
    @IBAction func tuesday(_ sender: Any) {
        let cDay = String(2)
        // Database Stuff
        ref = Database.database().reference()
        databaseHandle = ref?.child("WeeklyHourlyAverages").child(cDay).observe(.value, with: { [self](snapshot) in
            var i = 0
            for cDay in snapshot.children.allObjects as![DataSnapshot]{
                let hourObj = cDay.value as? [String: Any]
                let hourAvg = hourObj?["average"]
                self.dbHours[i] = hourAvg as! Double
                i+=1
            
            }
            
            self.set = BarChartDataSet(entries: [
                BarChartDataEntry(x: Double(1),y: self.dbHours[9]),
                BarChartDataEntry(x: Double(2),y: self.dbHours[10]),
                BarChartDataEntry(x: Double(3),y: self.dbHours[11]),
                BarChartDataEntry(x: Double(4),y: self.dbHours[12]),
                BarChartDataEntry(x: Double(5),y: self.dbHours[13]),
                BarChartDataEntry(x: Double(6),y: self.dbHours[14]),
                BarChartDataEntry(x: Double(7),y: self.dbHours[15]),
                BarChartDataEntry(x: Double(8),y: self.dbHours[16]),
                BarChartDataEntry(x: Double(9),y: self.dbHours[17]),
                BarChartDataEntry(x: Double(10),y: self.dbHours[18])
              ], label: "Hour")
        
            self.makeBarChart(day: tues)
        })
    }
    
    @IBAction func wednesday(_ sender: Any) {
        let cDay = String(3)
        // Database Stuff
        ref = Database.database().reference()
        databaseHandle = ref?.child("WeeklyHourlyAverages").child(cDay).observe(.value, with: { [self](snapshot) in
            var i = 0
            for cDay in snapshot.children.allObjects as![DataSnapshot]{
                let hourObj = cDay.value as? [String: Any]
                let hourAvg = hourObj?["average"]
                self.dbHours[i] = hourAvg as! Double
                i+=1
            
            }
            
            self.set = BarChartDataSet(entries: [
                BarChartDataEntry(x: Double(1),y: self.dbHours[9]),
                BarChartDataEntry(x: Double(2),y: self.dbHours[10]),
                BarChartDataEntry(x: Double(3),y: self.dbHours[11]),
                BarChartDataEntry(x: Double(4),y: self.dbHours[12]),
                BarChartDataEntry(x: Double(5),y: self.dbHours[13]),
                BarChartDataEntry(x: Double(6),y: self.dbHours[14]),
                BarChartDataEntry(x: Double(7),y: self.dbHours[15]),
                BarChartDataEntry(x: Double(8),y: self.dbHours[16]),
                BarChartDataEntry(x: Double(9),y: self.dbHours[17]),
                BarChartDataEntry(x: Double(10),y: self.dbHours[18])
              ], label: "Hour")
        
            self.makeBarChart(day: wed)
        })
    }
    
    @IBAction func thursday(_ sender: Any) {
        let cDay = String(4)
        // Database Stuff
        ref = Database.database().reference()
        databaseHandle = ref?.child("WeeklyHourlyAverages").child(cDay).observe(.value, with: { [self](snapshot) in
            var i = 0
            for cDay in snapshot.children.allObjects as![DataSnapshot]{
                let hourObj = cDay.value as? [String: Any]
                let hourAvg = hourObj?["average"]
                self.dbHours[i] = hourAvg as! Double
                i+=1
            
            }
            
            self.set = BarChartDataSet(entries: [
                BarChartDataEntry(x: Double(1),y: self.dbHours[9]),
                BarChartDataEntry(x: Double(2),y: self.dbHours[10]),
                BarChartDataEntry(x: Double(3),y: self.dbHours[11]),
                BarChartDataEntry(x: Double(4),y: self.dbHours[12]),
                BarChartDataEntry(x: Double(5),y: self.dbHours[13]),
                BarChartDataEntry(x: Double(6),y: self.dbHours[14]),
                BarChartDataEntry(x: Double(7),y: self.dbHours[15]),
                BarChartDataEntry(x: Double(8),y: self.dbHours[16]),
                BarChartDataEntry(x: Double(9),y: self.dbHours[17]),
                BarChartDataEntry(x: Double(10),y: self.dbHours[18])
              ], label: "Hour")
        
            self.makeBarChart(day: thurs)
        })
    }
    
    @IBAction func friday(_ sender: Any) {
        let cDay = String(5)
        // Database Stuff
        ref = Database.database().reference()
        databaseHandle = ref?.child("WeeklyHourlyAverages").child(cDay).observe(.value, with: { [self](snapshot) in
            var i = 0
            for cDay in snapshot.children.allObjects as![DataSnapshot]{
                let hourObj = cDay.value as? [String: Any]
                let hourAvg = hourObj?["average"]
                self.dbHours[i] = hourAvg as! Double
                i+=1
            
            }
            
            self.set = BarChartDataSet(entries: [
                BarChartDataEntry(x: Double(1),y: self.dbHours[9]),
                BarChartDataEntry(x: Double(2),y: self.dbHours[10]),
                BarChartDataEntry(x: Double(3),y: self.dbHours[11]),
                BarChartDataEntry(x: Double(4),y: self.dbHours[12]),
                BarChartDataEntry(x: Double(5),y: self.dbHours[13]),
                BarChartDataEntry(x: Double(6),y: self.dbHours[14]),
                BarChartDataEntry(x: Double(7),y: self.dbHours[15]),
                BarChartDataEntry(x: Double(8),y: self.dbHours[16]),
                BarChartDataEntry(x: Double(9),y: self.dbHours[17]),
                BarChartDataEntry(x: Double(10),y: self.dbHours[18])
              ], label: "Hour")
        
            self.makeBarChart(day: fri)
        })
    }
    
    @IBAction func saturday(_ sender: Any) {
        let cDay = String(6)
        // Database Stuff
        ref = Database.database().reference()
        databaseHandle = ref?.child("WeeklyHourlyAverages").child(cDay).observe(.value, with: { [self](snapshot) in
            var i = 0
            for cDay in snapshot.children.allObjects as![DataSnapshot]{
                let hourObj = cDay.value as? [String: Any]
                let hourAvg = hourObj?["average"]
                self.dbHours[i] = hourAvg as! Double
                i+=1
            
            }
            
            self.set = BarChartDataSet(entries: [
                BarChartDataEntry(x: Double(1),y: self.dbHours[9]),
                BarChartDataEntry(x: Double(2),y: self.dbHours[10]),
                BarChartDataEntry(x: Double(3),y: self.dbHours[11]),
                BarChartDataEntry(x: Double(4),y: self.dbHours[12]),
                BarChartDataEntry(x: Double(5),y: self.dbHours[13]),
                BarChartDataEntry(x: Double(6),y: self.dbHours[14]),
                BarChartDataEntry(x: Double(7),y: self.dbHours[15]),
                BarChartDataEntry(x: Double(8),y: self.dbHours[16]),
                BarChartDataEntry(x: Double(9),y: self.dbHours[17]),
                BarChartDataEntry(x: Double(10),y: self.dbHours[18])
              ], label: "Hour")
        
            self.makeBarChart(day: sat)
        })
    }
    
}

