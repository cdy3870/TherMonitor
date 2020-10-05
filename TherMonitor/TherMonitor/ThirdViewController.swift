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
    var hours = ["","8am","9am", "10am", "11am", "12pm", "1pm", "2pm", "3pm", "4pm", "5pm"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        weekBarChart.rightAxis.enabled = false
        weekBarChart.leftAxis.enabled = false
        weekBarChart.legend.enabled = false
        weekBarChart.xAxis.labelPosition = .bottom
        weekBarChart.xAxis.drawGridLinesEnabled = false
        weekBarChart.xAxis.setLabelCount(9, force: false)
        weekBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:hours)
        
        let data = BarChartData(dataSet: set)
        weekBarChart.data = data
        
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
        
        let data = BarChartData(dataSet: set)
        weekBarChart.data = data
        self.sun.backgroundColor = UIColor.lightGray
        self.mon.backgroundColor = UIColor.white
        self.tues.backgroundColor = UIColor.white
        self.wed.backgroundColor = UIColor.white
        self.thurs.backgroundColor = UIColor.white
        self.fri.backgroundColor = UIColor.white
        self.sat.backgroundColor = UIColor.white
        
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
        
        
        let data = BarChartData(dataSet: set)
        weekBarChart.data = data
        self.mon.backgroundColor = UIColor.lightGray
        self.sun.backgroundColor = UIColor.white
        self.tues.backgroundColor = UIColor.white
        self.wed.backgroundColor = UIColor.white
        self.thurs.backgroundColor = UIColor.white
        self.fri.backgroundColor = UIColor.white
        self.sat.backgroundColor = UIColor.white
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
        
        
        let data = BarChartData(dataSet: set)
        weekBarChart.data = data
        self.tues.backgroundColor = UIColor.lightGray
        self.sun.backgroundColor = UIColor.white
        self.mon.backgroundColor = UIColor.white
        self.wed.backgroundColor = UIColor.white
        self.thurs.backgroundColor = UIColor.white
        self.fri.backgroundColor = UIColor.white
        self.sat.backgroundColor = UIColor.white
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
        
        
        let data = BarChartData(dataSet: set)
        weekBarChart.data = data
        self.wed.backgroundColor = UIColor.lightGray
        self.sun.backgroundColor = UIColor.white
        self.mon.backgroundColor = UIColor.white
        self.tues.backgroundColor = UIColor.white
        self.thurs.backgroundColor = UIColor.white
        self.fri.backgroundColor = UIColor.white
        self.sat.backgroundColor = UIColor.white
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
        
        
        let data = BarChartData(dataSet: set)
        weekBarChart.data = data
        self.thurs.backgroundColor = UIColor.lightGray
        self.sun.backgroundColor = UIColor.white
        self.mon.backgroundColor = UIColor.white
        self.tues.backgroundColor = UIColor.white
        self.wed.backgroundColor = UIColor.white
        self.fri.backgroundColor = UIColor.white
        self.sat.backgroundColor = UIColor.white
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
        
        
        let data = BarChartData(dataSet: set)
        weekBarChart.data = data
        self.fri.backgroundColor = UIColor.lightGray
        self.sun.backgroundColor = UIColor.white
        self.mon.backgroundColor = UIColor.white
        self.tues.backgroundColor = UIColor.white
        self.wed.backgroundColor = UIColor.white
        self.thurs.backgroundColor = UIColor.white
        self.sat.backgroundColor = UIColor.white
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
        
        
        let data = BarChartData(dataSet: set)
        weekBarChart.data = data
        self.sat.backgroundColor = UIColor.lightGray
        self.sun.backgroundColor = UIColor.white
        self.mon.backgroundColor = UIColor.white
        self.tues.backgroundColor = UIColor.white
        self.wed.backgroundColor = UIColor.white
        self.thurs.backgroundColor = UIColor.white
        self.fri.backgroundColor = UIColor.white
    }
    
}

