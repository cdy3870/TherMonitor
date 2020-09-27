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
    
    var hours = ["","8am","9am", "10am", "11am", "12pm", "1pm", "2pm", "3pm", "4pm", "5pm"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //barChart.delegate = self
        barChart.rightAxis.enabled = false
        barChart.leftAxis.enabled = false
        barChart.legend.enabled = false
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.xAxis.setLabelCount(9, force: false)
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:hours)
        
        let data = BarChartData(dataSet: set)
        barChart.data = data
    }
}

