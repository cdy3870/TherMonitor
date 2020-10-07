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

    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var curDay: UILabel!

    var databaseHandle: DatabaseHandle?
    var ref: DatabaseReference?

	// y value is the occupancy for that given hour
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

        var occupancy_per_hour: Array<Double> = Array(repeating: 0, count: 24)
        var occupancies_shown: Array<Double> = Array(repeating: 0, count: 10)


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

        let data = BarChartData(dataSet: set)

        // extract data from database
        databaseHandle = ref?.child("Events").observe(.childAdded, with: { (snapshot) in

            let values = snapshot.value as? NSDictionary
            var event_timestamp = values!["timestamp"]
            let event_date = NSDate(timeIntervalSince1970: event_timestamp as! TimeInterval)

            // from this timestamp, we can get the time of day, the day, the month
            //let current_date = Date()
            let calendar = Calendar.current
            let event_components = calendar.dateComponents([.year, .month, .weekday, .hour], from: event_date as Date)
            //let event_year = event_components.year
            //let event_month = event_components.month
            let event_day = event_components.weekday
            let event_hour = event_components.hour

            // here is where the logic will be to append values to the daily and weekly traffic analysis

            // check if the event day matches the current day
            if(event_day == weekDay)
            {
                // the event occured during this day, now update the room occupancy for the associated hour
                if (values!["direction"] as! String == "entry") {
                    occupancy_per_hour[event_hour!]+=1
                }
                else if (values!["direction"] as! String == "exit"){
                    occupancy_per_hour[event_hour!]-=1
                }

            }

            occupancies_shown = Array(occupancy_per_hour[curHour-6...curHour+4])

            var updated_set = BarChartDataSet(entries: [
                      BarChartDataEntry(x: Double(1),y: occupancies_shown[0]),
                      BarChartDataEntry(x: Double(2),y: occupancies_shown[1]),
                      BarChartDataEntry(x: Double(3),y: occupancies_shown[2]),
                      BarChartDataEntry(x: Double(4),y: occupancies_shown[3]),
                      BarChartDataEntry(x: Double(5),y: occupancies_shown[4]),
                      BarChartDataEntry(x: Double(6),y: occupancies_shown[5]),
                      BarChartDataEntry(x: Double(7),y: occupancies_shown[6]),
                      BarChartDataEntry(x: Double(8),y: occupancies_shown[7]),
                      BarChartDataEntry(x: Double(9),y: occupancies_shown[8]),
                      BarChartDataEntry(x: Double(10),y: occupancies_shown[9])
              ], label: "Hour")

              self.barChart.data = BarChartData(dataSet: updated_set)


        })

        barChart.data = data

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
