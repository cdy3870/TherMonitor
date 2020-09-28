//
//  SecondViewController.swift
//  TherMonitor
//
//  Created by Alyssa Jordan on 9/20/20.
//  Copyright © 2020 Alyssa Jordan. All rights reserved.
//

import UIKit
import Charts

class SecondViewController: UIViewController {
    
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var curDay: UILabel!
    
    
    var set = BarChartDataSet(entries: [
            BarChartDataEntry(x: Double(1),y: Double(5)),
            BarChartDataEntry(x: Double(2),y: Double(4)),
            BarChartDataEntry(x: Double(3),y: Double(3)),
            BarChartDataEntry(x: Double(4),y: Double(1)),
            BarChartDataEntry(x: Double(5),y: Double(7)),
            BarChartDataEntry(x: Double(6),y: Double(2)),
            BarChartDataEntry(x: Double(7),y: Double(7)),
            BarChartDataEntry(x: Double(8),y: Double(3)),
            BarChartDataEntry(x: Double(9),y: Double(9)),
            BarChartDataEntry(x: Double(10),y: Double(4))
    ], label: "Hour")
    
    //var hours = ["","8am","9am", "10am", "11am", "12pm", "1pm", "2pm", "3pm", "4pm", "5pm"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        
        let data = BarChartData(dataSet: set)
        barChart.data = data
        
        let currentDate = Date()
        //let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy-MM-dd"
        //formatter.timeStyle = .medium
        //formatter.dateStyle = .long
        //let dateTimeString = formatter.string(from: currentDateTime)
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
        
        let hours = Array(allHours[curHour-6...curHour+4])
        
        
        //barChart.delegate = self
        barChart.rightAxis.enabled = false
        barChart.leftAxis.enabled = false
        barChart.legend.enabled = false
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.xAxis.setLabelCount(9, force: false)
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:hours)

        
    }
    
    
}

