//
//  FirstViewController.swift
//  TherMonitor
//
//  Created by Alyssa Jordan on 9/20/20.
//  Copyright © 2020 Alyssa Jordan. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FirstViewController: UIViewController {

    @IBOutlet weak var currentRoomCap: UILabel!

    var ref:DatabaseReference?

    var postData = [String]()

    var databaseHandle:DatabaseHandle?

    var total_room_occupancy = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        ref = Database.database().reference()

        databaseHandle = ref?.child("Events").observe(.childAdded, with: { (snapshot) in

            let values = snapshot.value as? String
            // i think what we want to do is something like
            if (values["direction"] == "entry") {
                self.total_room_occupancy+=1
            }
            else if (values["direction"] == "exit"){
                self.total_room_occupancy-=1
            }


	    // based on timestamp, update the weekly traffic analysis

	    // get the current day, month, year, time


	    var event_timestamp = values["timestamp"]

	    let event_date = NSDate(timeIntervalSince1970: event_timestamp)

	    // from this timestamp, we can get the time of day, the day, the month
	    let current_date = Date()

            let calendar = Calendar.current
            let current_components = calendar.dateComponents([.year, .month, .day, .hour], from: current_date)

            let current_year = current_components.year
	    let current_month = current_components.month
	    let current_day = current_components.day
            let current_hour = current_components.hour

            let event_components = calendar.dateComponents([.year, .month, .day, .hour], from: event_date)

	    let event_year = event_components.year
	    let event_month = event_components.month
	    let event_day = event_components.day
	    let event_hour = event_components.hour


            // here is where the logic will be to append values to the daily and weekly traffic analysis


            // here we use our new room occupancy data as the variable for the View
            // we are going to need to refresh

            self.currentRoomCap.text = String(self.total_room_occupancy)

        })


     }


}
