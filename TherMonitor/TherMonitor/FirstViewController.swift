//
//  FirstViewController.swift
//  TherMonitor
//
//  Created by Alyssa Jordan on 9/20/20.
//  Copyright © 2020 Alyssa Jordan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import UserNotifications

class FirstViewController: UIViewController {

    @IBOutlet weak var currentRoomCap: UILabel!
    @IBOutlet weak var maxRoomCap: UILabel!
    
    var ref:DatabaseReference?

    var postData = [String]()

    var databaseHandle:DatabaseHandle?
    var databaseHandle2:DatabaseHandle?

    var total_room_occupancy = 0
    var max_capacity = 0
    var showedAlert = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        ref = Database.database().reference()
        
        var seen = false
        let center = UNUserNotificationCenter.current()
        
        // ask for permission
        center.requestAuthorization(options: [.alert,.sound]) { (granted, error) in
            // error
            //print("error 1")
        }
        
        databaseHandle = ref?.child("Events").observe(.childAdded, with: { (snapshot) in

            let values = snapshot.value as? NSDictionary
            // i think what we want to do is something like
            if (values!["direction"] as! String == "entry") {
                self.total_room_occupancy+=1
            }
            else if (values!["direction"] as! String == "exit"){
                self.total_room_occupancy-=1
            }
            // here we use our new room occupancy data as the variable for the View
            // we are going to need to refresh

            self.currentRoomCap.text = String(self.total_room_occupancy)
            
            // Max Capacity from DB
            self.databaseHandle2 = self.ref?.child("MaxCapacity").observe(.value, with: {(snapshot) in
                    var roomArr: Array<Double> = Array(repeating: 0, count: 10)
                    var i = 0
                    for r in snapshot.children.allObjects as![DataSnapshot]{
                        let roomObj = r.value as? [String: Any]
                        let roomOcc = roomObj?["max"]
                        roomArr[i] = roomOcc as! Double
                        i+=1
                    }
                    self.max_capacity = Int(roomArr[0])
                    self.maxRoomCap.text = String(format: "%g", roomArr[0])
                
                //print(self.total_room_occupancy)
                //print(self.max_capacity)
                if self.total_room_occupancy >= self.max_capacity && seen == false {
                    seen = true
                    print("inside")
                    
                    // create notification content
                    let content = UNMutableNotificationContent()
                    content.title = "Max Capacity Alert"
                    content.body = "The room has reached capacity."
                    
                    
                    let date = Date().addingTimeInterval(5)
                    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    
                    // create request
                    let uuidString = UUID().uuidString
                    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                    
                    // register request
                    center.add(request) { (error) in
                        // check error
                        //print("error 2")
                    }
                    
                }
                    
                    
            })

        })
        

        
    }
    


}
