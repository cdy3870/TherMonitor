const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();

var current_occupancy;

// Run function for every entry/exit
exports.get_current_occupancy = functions.database.ref("Events").onCreate((snapshot,context) => {

    // get currect occupancy from db
    const ro = admin.database().ref("RoomOccupancy");
    ro.on("value", function(snapshot){
      current_occupancy=snapshot.val()
    }, function (errorObject){
      console.log("The read failed: " + errorObject.code);
    });

    // adjust room occupancy based on entry or exit
    var direction_string = snapshot.val()["directions"];

    if(direction_string == "entry")
    {
      current_occupancy++;
    }
    else if(direction_string == "exit")
    {
      current_occupancy--;
    }


    // write back to db updated current occupancy
    ro.set({
      "RoomOccupancy": current_occupancy
    });


  });

// Run function every hour 
exports.generate_daily_occupancy_averages = functions.pubsub.schedule("0 * * * *").onRun((context) => {

    // get currect occupancy from db
    const ro = admin.database().ref("RoomOccupancy");
    ro.on("value", function(snapshot){
      current_occupancy=snapshot.val()
    }, function (errorObject){
      console.log("The read failed: " + errorObject.code);
    });

    // determine current hour
    var today = new Date();
    var time = today.getHours(); // 0-23

    String db_loc = '"DailyHourlyAverages/' + time +'"';

    // set save average occupancy to current hour
    const current_hour = admin.database().ref(db_loc);
    
    String h = '"' + time + '"';
    current_hour.set({
      h: current_occupancy
    });


  });

// Run function once a day (every day at 23:59PM -> 11:59PM)
exports.generate_weekly_occupancy_averages = functions.pubsub.schedule("59 23 * * *").onRun((context) => {

    // figure out current day of the week
    var today = new Date();
    var day_of_week = today.getDay() //0 = Sun, 1 = Mon, etc

    // set up array to temp store averages
    // create 7 days
    var day = new Array(24);
    for(var j = 0; j < day[i].length; j++)
    {
      day[j] = new Array(3);
      // current total average
      day[j][0] = 0;

      // how many days this average is based on
      day[j][1] = 0;

      // new average
      day[j][2] = 0;
      
    }

    // get total averages for each hour for that specific day of the week
    String db_loc = '"WeeklyHourlyAverages/' + day_of_week +'"'

    const weekly = admin.database().ref(db_loc);

    var j = 0;
    
    weekly.once("value", snapshot => {
      snapshot.forEach(data => {

        day[j][0]=data.val()["average"];
        day[j][1]=data.val()["ndays"];

        j++;
      });

    });

    // get current averages for each hour for that specific day 

    const daily = admin.database().ref("DailyHourlyAverages");

    j = 0;
    
    daily.once("value", snapshot => {
      snapshot.forEach(data => {

        day[j][2]=data.val()["average"];

        j++;
      });

    });

    // recalculate average
    var avg = new Array(24);
    var dcount = new Array(24);
    for (var j = 0; j < day[i].length; j++){
      avg[j] = day[j][0]+day[j][2];
      dcount[j] = day[j][1]+1;
      avg[j] = avg[j]/dcount[j];
    }

    // set new total averages and number of days for each hour
    const w = admin.database.ref("WeeklyHourlyAverages");
    String weekday = '"' + day_of_week +'"'
    var td = ref.child(weekday)
    td.set({
      0:{
        average: "",
        ndays: ""
      },
      1:{
        average: "",
        ndays: ""
      },
      2:{
        average: "",
        ndays: ""
      }

    });

  });



