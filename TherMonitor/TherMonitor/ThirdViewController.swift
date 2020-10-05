//
//  ThirdViewController.swift
//  TherMonitor
//
//  Created by Alyssa Jordan on 9/20/20.
//  Copyright © 2020 Alyssa Jordan. All rights reserved.
//

import UIKit
import Charts

class ThirdViewController: UIViewController {
    

    @IBOutlet weak var weekBarChart: BarChartView!
    @IBOutlet weak var sun: UIButton!
    @IBOutlet weak var mon: UIButton!
    @IBOutlet weak var tues: UIButton!
    @IBOutlet weak var wed: UIButton!
    @IBOutlet weak var thurs: UIButton!
    @IBOutlet weak var fri: UIButton!
    @IBOutlet weak var sat: UIButton!
    
    var set = BarChartDataSet()
    //var hours = ["","8am","9am", "10am", "11am", "12pm", "1pm", "2pm", "3pm", "4pm", "5pm"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = BarChartData(dataSet: set)
        weekBarChart.data = data
        
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
        set = BarChartDataSet(entries: [
                BarChartDataEntry(x: Double(1),y: Double(5)),
                BarChartDataEntry(x: Double(2),y: Double(4)),
                BarChartDataEntry(x: Double(3),y: Double(2)),
                BarChartDataEntry(x: Double(4),y: Double(1)),
                BarChartDataEntry(x: Double(5),y: Double(7)),
                BarChartDataEntry(x: Double(6),y: Double(2)),
                BarChartDataEntry(x: Double(7),y: Double(7)),
                BarChartDataEntry(x: Double(8),y: Double(3)),
                BarChartDataEntry(x: Double(9),y: Double(9)),
                BarChartDataEntry(x: Double(10),y: Double(4))
            
        ])
        
        makeBarChart(day: sun)
        
    }
    
    @IBAction func monday(_ sender: Any) {
        set = BarChartDataSet(entries: [
                BarChartDataEntry(x: Double(1),y: Double(2)),
                BarChartDataEntry(x: Double(2),y: Double(7)),
                BarChartDataEntry(x: Double(3),y: Double(3)),
                BarChartDataEntry(x: Double(4),y: Double(8)),
                BarChartDataEntry(x: Double(5),y: Double(2)),
                BarChartDataEntry(x: Double(6),y: Double(9)),
                BarChartDataEntry(x: Double(7),y: Double(8)),
                BarChartDataEntry(x: Double(8),y: Double(1)),
                BarChartDataEntry(x: Double(9),y: Double(2)),
                BarChartDataEntry(x: Double(10),y: Double(8))
        ])

        makeBarChart(day: mon)
    }
    
    @IBAction func tuesday(_ sender: Any) {
        set = BarChartDataSet(entries: [
                BarChartDataEntry(x: Double(1),y: Double(2)),
                BarChartDataEntry(x: Double(2),y: Double(5)),
                BarChartDataEntry(x: Double(3),y: Double(3)),
                BarChartDataEntry(x: Double(4),y: Double(4)),
                BarChartDataEntry(x: Double(5),y: Double(1)),
                BarChartDataEntry(x: Double(6),y: Double(3)),
                BarChartDataEntry(x: Double(7),y: Double(8)),
                BarChartDataEntry(x: Double(8),y: Double(3)),
                BarChartDataEntry(x: Double(9),y: Double(3)),
                BarChartDataEntry(x: Double(10),y: Double(9))
        ])
        
        makeBarChart(day: tues)
    }
    
    @IBAction func wednesday(_ sender: Any) {
        set = BarChartDataSet(entries: [
                BarChartDataEntry(x: Double(1),y: Double(7)),
                BarChartDataEntry(x: Double(2),y: Double(7)),
                BarChartDataEntry(x: Double(3),y: Double(8)),
                BarChartDataEntry(x: Double(4),y: Double(3)),
                BarChartDataEntry(x: Double(5),y: Double(5)),
                BarChartDataEntry(x: Double(6),y: Double(2)),
                BarChartDataEntry(x: Double(7),y: Double(4)),
                BarChartDataEntry(x: Double(8),y: Double(8)),
                BarChartDataEntry(x: Double(9),y: Double(1)),
                BarChartDataEntry(x: Double(10),y: Double(2))
        ])

        makeBarChart(day: wed)
    }
    
    @IBAction func thursday(_ sender: Any) {
        set = BarChartDataSet(entries: [
                BarChartDataEntry(x: Double(1),y: Double(2)),
                BarChartDataEntry(x: Double(2),y: Double(7)),
                BarChartDataEntry(x: Double(3),y: Double(4)),
                BarChartDataEntry(x: Double(4),y: Double(1)),
                BarChartDataEntry(x: Double(5),y: Double(7)),
                BarChartDataEntry(x: Double(6),y: Double(9)),
                BarChartDataEntry(x: Double(7),y: Double(8)),
                BarChartDataEntry(x: Double(8),y: Double(6)),
                BarChartDataEntry(x: Double(9),y: Double(2)),
                BarChartDataEntry(x: Double(10),y: Double(2))
        ])

        makeBarChart(day: thurs)
    }
    
    @IBAction func friday(_ sender: Any) {
        set = BarChartDataSet(entries: [
                BarChartDataEntry(x: Double(1),y: Double(9)),
                BarChartDataEntry(x: Double(2),y: Double(7)),
                BarChartDataEntry(x: Double(3),y: Double(6)),
                BarChartDataEntry(x: Double(4),y: Double(8)),
                BarChartDataEntry(x: Double(5),y: Double(2)),
                BarChartDataEntry(x: Double(6),y: Double(4)),
                BarChartDataEntry(x: Double(7),y: Double(8)),
                BarChartDataEntry(x: Double(8),y: Double(1)),
                BarChartDataEntry(x: Double(9),y: Double(8)),
                BarChartDataEntry(x: Double(10),y: Double(2))
        ])
        
        makeBarChart(day: fri)
    }
    
    @IBAction func saturday(_ sender: Any) {
        set = BarChartDataSet(entries: [
                BarChartDataEntry(x: Double(1),y: Double(4)),
                BarChartDataEntry(x: Double(2),y: Double(1)),
                BarChartDataEntry(x: Double(3),y: Double(2)),
                BarChartDataEntry(x: Double(4),y: Double(9)),
                BarChartDataEntry(x: Double(5),y: Double(7)),
                BarChartDataEntry(x: Double(6),y: Double(5)),
                BarChartDataEntry(x: Double(7),y: Double(8)),
                BarChartDataEntry(x: Double(8),y: Double(3)),
                BarChartDataEntry(x: Double(9),y: Double(4)),
                BarChartDataEntry(x: Double(10),y: Double(2))
        ])
        
        makeBarChart(day: sat)
    }
    
}

