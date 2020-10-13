const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
//
//
//

class Hour
{
	constructor()
	{
		this.average_occupancy = 0;

		// also initialize an empty list for room occupancies;
    var occupancy_list = [];
	}

  addOccupancy(occupancy_update){
    occupancy_list.push(occupancy_update);
  }
}

// day object
class Day
{
	constructor()
	{

  }
	// array of 24 hours

}




// hour object


// array of 7 days
// each day has an array of 24 hours
// each hour has a list of doubles
// each hour also has a variable for the average room occupancy


//var current_occupancy;

//
// sudo code
// for event in events:
//   based on weekday
//   based on hour
//   append to list of room occupancies
//
// once this process is over
// 	average up the weekday's hour's list of room occupancies
// 	this will be
//
//
//
//
//
//
//

// create 7 days
var days = new Array(7)
for(var i = 0; i < days.length; i++)
{
  // create an array with 24 slots for every day
  days[i] = new Array(24);
  for(var j = 0; j < days[i].length; j++)
  {
    days[i][j] = new Array(2);
    // list of current occupancies
    days[i][j][0] = new Array();

    // location of average
    days[i][j][1] = 0;
  }
}

function get_string_path(day, hour)
{
  var days = ["Sunday","Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
  var hours ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]


}

exports.generate_occupancy_averages = functions.pubsub.schedule("* * * * *").onRun((context) => {

  //console.log("inside of the scheduled function");
  const testRef = admin.database().ref("Events")



  var event_data = [[],[]]
  var current_occupancy = 0

  testRef.once("value", snapshot => {

      snapshot.forEach(data => {

          console.log(data.val()["direction"])
          console.log(data.val()["timestamp"])
          event_data[0].push(data.val()["direction"])
          event_data[1].push(data.val()["timestamp"])
          var direction_string = data.val()["direction"]

          if(direction_string == "entry")
          {
            current_occupancy++;
          }
          else if(direction_string == "exit")
          {
            current_occupancy--;
          }
         // i might want to sort the data by time

         // convert timestamp to weekday and hour of day
         var event_date = new Date(data.val()["timestamp"]);

         // weekday as a number from 0-6, can be used as index
         var day = event_date.getDay();

         // hour as a number from 0-23, can be used as index
         var hour = event_date.getHours();

         // append current occupancy to the list
         days[day][hour][0].push(current_occupancy);

         return false;
      });

      for(var i = 0; i < days.length; i++)
      {
        for(var j = 0; j < days[i].length; j++)
        {
          var total = 0;
          for(var z = 0; z < days[i][j][0].length; z++)
          {
            total+=days[i][j][0][z];
          }
          days[i][j][1] = total/days[i][j][0].length;
          get_string_path(i,j);
          // update the singular average for each hour of the 7 days

        }
      }

  })

  return console.log("ending function");

});
