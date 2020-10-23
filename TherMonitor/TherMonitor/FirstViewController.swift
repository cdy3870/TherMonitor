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
        /*databaseHandle = ref?.child("RoomOccupancy").child("room1").observe(.value, with: { (snapshot) in
            let values = snapshot.value as? String
            
            self.currentRoomCap.text = values
        })*/
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
            //self.currentRoomCap.text = values

        })


     }


}
