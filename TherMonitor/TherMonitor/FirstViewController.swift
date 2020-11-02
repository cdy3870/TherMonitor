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
        
        databaseHandle = ref?.child("Rooms").observe(.value, with: {(snapshot) in
            var roomArr: Array<Double> = Array(repeating: 0, count: 10)
            var i = 0
            for r in snapshot.children.allObjects as![DataSnapshot]{
                let roomObj = r.value as? [String: Any]
                let roomOcc = roomObj?["currentOccupancy"]
                roomArr[i] = roomOcc as! Double
                i+=1
            }
            self.currentRoomCap.text = String(format: "%g", roomArr[0])
            
        })
        
        /*databaseHandle = ref?.child("Rooms").observe(.value, with: { (snapshot) in
            
            for r in snapshot.children.allObjects as![DataSnapshot]{
                let rD = r.value as? [String: Any]
                let val = rD?["currentOccupancy"]
                self.currentRoomCap.text = val as! String
            }
            
            
            //let r = snapshot.value as![DataSnapshot]
            //let rD = snapshot.value as? [String: Any]
            
            //let values = rD?["currentOccupancy"]
            
            
            
            
            
            
            
            /*for r in snapshot.children. as![DataSnapshot]{
                let rNum = r.value as? [String
                self.currentRoomCap.text = rNum
            }*/
            
        })*/
        /*databaseHandle = ref?.child("Events").observe(.childAdded, with: { (snapshot) in

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
            //self.currentRoomCap.text = values

        })*/


     }


}
