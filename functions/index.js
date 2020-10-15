const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();

var current_occupancy;

// Run function for every entry/exit
//exports.get_current_occupancy = functions.pubsub.schedule("* * * * *").onRun((context) => {
exports.get_current_occupancy = functions.database.ref("Events/{EventNum}").onCreate((snapshot,context) => {

    //console.log("hi world");
    // adjust room occupancy based on entry or exit
    var direction_string = snapshot.val()["direction"];

    // get currect occupancy from db
    const ro = admin.database().ref("RoomOccupancy");
    ro.once("value", snapshot => {
      var co = snapshot.val()["room1"];
      console.log(snapshot.val()["room1"]);

      if(direction_string === "entry")
      {
        console.log("entry");
        co++;
      }
      else if(direction_string === "exit")
      {
        console.log("exit");
        co--;
      }

      console.log(co);
      // write back to db updated current occupancy
      ro.set({
        "room1": co
      });
      return 0;
    });

    //console.log("ending function");
    return 0;

  });

// Run function every hour 
exports.generate_daily_occupancy_averages = functions.pubsub.schedule("5 * * * *").onRun((context) => {

    // get currect occupancy from db
    const ro = admin.database().ref("RoomOccupancy");
    ro.once("value", snapshot => {
      var co = snapshot.val()["room1"];
      console.log(snapshot.val()["room1"]);

      // determine current hour
      var today = new Date();
      var time = today.getHours(); // 0-23 
      if (time >= 4){
        time = time - 4;
      }
      else{
        time = time + 20;
      }

      console.log("time: "+time);


      // set save average occupancy to current hour
      const daily_avg = admin.database().ref('DailyHourlyAverages/' +time);
      daily_avg.set(co);

      //String h = time.toString();
      /*daily_avg.update({
        h: co
      });*/

      return 0;

    });

    return 0;
  
  });

// Run function once a day (every day at 23:59PM -> 11:59PM)
exports.generate_weekly_occupancy_averages = functions.pubsub.schedule("19 * * * *").onRun((context) => {

    // figure out current day of the week
    var today = new Date();
    var day_of_week = today.getDay() //0 = Sun, 1 = Mon, etc

    // set up array to temp store averages
    // create 7 days
    var day = new Array(24);
    for(var j = 0; j < day.length; j++)
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
    //String db_loc = '"WeeklyHourlyAverages/' + day_of_week +'"'

    const weekly = admin.database().ref('WeeklyHourlyAverages/'+ day_of_week);

    j = 0;
    
    weekly.once("value", snapshot => {
      snapshot.forEach(data => {

        day[j][0]=data.val()["average"];
        day[j][1]=data.val()["days"];
        console.log("average: "+ day[j][0]);
        console.log("days: "+ day[j][1]);
        j++;
      });



      // get current averages for each hour for that specific day 

      const daily = admin.database().ref("DailyHourlyAverages");

      j = 0;
      
      daily.once("value", snapshot => {
        snapshot.forEach(data => {

          day[j][2]=data.val()["average"];
          console.log("daily average: "+ day[j][2]);

          j++;
        });

        return 0;

      });

      // recalculate average
      var avg = new Array(24);
      var dcount = new Array(24);
      for (var j = 0; j < day[i].length; j++){
        avg[j] = day[j][0]+day[j][2];
        dcount[j] = day[j][1]+1;
        avg[j] = avg[j]/dcount[j];
      }

      return 0;

    });

  

    /*// set new total averages and number of days for each hour
    const w = admin.database.ref("WeeklyHourlyAverages");
    //String weekday = '"' + day_of_week +'"'
    var td = ref.child(weekday.toString())
    td.set({
      "0":{
        "average": avg[0].toString(),
        "days": dcount[0].toString()
      },
      "1":{
        "average": "",
        "days": ""
      },
      "2":{
        "average": "",
        "days": ""
      },
      "3":{
        "average": "",
        "days": ""
      },
      "4":{
        "average": "",
        "days": ""
      }


    });*/

  }); 



