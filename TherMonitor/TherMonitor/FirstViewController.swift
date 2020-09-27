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

//    var ref:FIRDatabaseReference?
    
//    var postData = [String]()

//    var databaseHandle:FIRDatabaseHandle?

//    var total_room_ocupancy = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
   
//	ref = FIRDatabase.database().reference()

//	databaseHandle = ref?.child("Events").observe(.childAdded, with: { (snapshot) in 

		// code to execute when a child is added under "Events"

		// take the value from the snapshot and add it to an array
		
		// so here snapshot will contain the information from the database under
		// Events

		// i think what we want to do is something like
		// if snapshot.child direction.value = "entry" => self.total_room_occupancy++
		// else if snapshot.child direction.value = "exit" => self.total_room_occupancy--

		
		// here we use our new room occupancy data as the variable for the View
		// we are going to need to refresh
		
		

//	})
     }


    
}

