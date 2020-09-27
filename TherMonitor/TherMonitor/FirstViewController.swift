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

        databaseHandle = ref?.child("Test").observe(.childAdded, with: { (snapshot) in
            
            
            // code to execute when a child is added under "Events"

            // take the value from the snapshot and add it to an array
            
            // so here snapshot will contain the information from the database under
            // Events

            let post = snapshot.value as? String
            // i think what we want to do is something like
            if (post == "entry") {
                self.total_room_occupancy+=1
            }
            else if (post == "exit"){
                self.total_room_occupancy-=1
            }
            // else if snapshot.child direction.value = "exit" => self.total_room_occupancy--

            
            // here we use our new room occupancy data as the variable for the View
            // we are going to need to refresh
            
            self.currentRoomCap.text = String(self.total_room_occupancy)

        })
        
        //currentRoomCap.text = String(total_room_occupancy)
     }


}

