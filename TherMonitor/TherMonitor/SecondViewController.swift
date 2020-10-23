//
//  SecondViewController.swift
//  TherMonitor
//
//  Created by Alyssa Jordan on 9/20/20.
//  Copyright © 2020 Alyssa Jordan. All rights reserved.
//

import UIKit
import Charts
import FirebaseDatabase

class SecondViewController: UIViewController {
    
    /*class graphData{
        var cHr: String?
        var cAvg: Double?
        
        init(cHr:String?, cAvg:Double?){
            self.cHr = cHr;
            self.cAvg = cAvg;
        }
    }*/

    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var curDay: UILabel!

    var databaseHandle: DatabaseHandle?
    var ref: DatabaseReference?

    // y value is the occupancy for that given hour
    var set = BarChartDataSet(entries: [
                BarChartDataEntry(x: Double(1),y: Double(0)),
                BarChartDataEntry(x: Double(2),y: Double(0)),
                BarChartDataEntry(x: Double(3),y: Double(0)),
                BarChartDataEntry(x: Double(4),y: Double(0)),
                BarChartDataEntry(x: Double(5),y: Double(0)),
                BarChartDataEntry(x: Double(6),y: Double(0)),
                BarChartDataEntry(x: Double(7),y: Double(0)),
                BarChartDataEntry(x: Double(8),y: Double(0)),
                BarChartDataEntry(x: Double(9),y: Double(0)),
                BarChartDataEntry(x: Double(10),y: Double(0))
        ], label: "Hour")
    
    var dbHours: Array<Double> = Array(repeating: 0, count: 24)


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    // Get the Current Day of the Week
        let currentDate = Date()
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: currentDate)

        var currentDay = ""
        switch weekDay {
        case 1:
            currentDay = "Sunday"
            break
        case 2:
            currentDay = "Monday"
            break
        case 3:
            currentDay = "Tuesday"
            break
        case 4:
            currentDay = "Wednesday"
            break
        case 5:
            currentDay = "Thursday"
            break
        case 6:
            currentDay = "Friday"
            break
        case 7:
            currentDay = "Saturday"
            break
        default:
            currentDay = ""
        }

        curDay.text = currentDay

    // Get the Current Time
        let currentTime = Date()
        var calendar = Calendar.current

        if let timeZone = TimeZone(identifier: "EST"){
            calendar.timeZone = timeZone
        }

        let hour = calendar.component(.hour, from: currentTime)
        let minute = calendar.component(.minute, from: currentTime)

        var curHour = 0

        if (minute < 30){
            curHour = hour
        }
        else{
            curHour = hour + 1
        }
        
        let allHours = ["1am","2am","3am","4am","5am","6am","7am","8am","9am", "10am", "11am", "12pm", "1pm", "2pm", "3pm", "4pm", "5pm", "6pm", "7pm", "8pm", "9pm", "10pm", "11pm","12am"]
        //let intHours = [curHour-6...curHour+4]
        //let hours = Array(allHours[curHour-6...curHour+4])
    
        let cDay = String(weekDay-1)
    // Database Stuff
        ref = Database.database().reference()
        databaseHandle = ref?.child("WeeklyHourlyAverages").child(cDay).observe(.value, with: {(snapshot) in
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
                    BarChartDataEntry(x: Double(1),y: self.dbHours[0]),
                    BarChartDataEntry(x: Double(2),y: self.dbHours[1]),
                    BarChartDataEntry(x: Double(3),y: self.dbHours[2]),
                    BarChartDataEntry(x: Double(4),y: self.dbHours[3]),
                    BarChartDataEntry(x: Double(5),y: self.dbHours[4]),
                    BarChartDataEntry(x: Double(6),y: self.dbHours[5]),
                    BarChartDataEntry(x: Double(7),y: self.dbHours[6]),
                    BarChartDataEntry(x: Double(8),y: self.dbHours[7]),
                    BarChartDataEntry(x: Double(9),y: self.dbHours[8]),
                    BarChartDataEntry(x: Double(10),y: self.dbHours[9])
              ], label: "Hour")
            
            let data = BarChartData(dataSet: self.set)
            

            self.barChart.data = data
            
        })
        
        barChart.rightAxis.enabled = false
        barChart.leftAxis.enabled = false
        barChart.legend.enabled = false
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.xAxis.setLabelCount(9, force: false)
        //barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:hours)


    }


}
