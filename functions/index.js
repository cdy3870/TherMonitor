const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();

var current_occupancy;

// https://firebase.google.com/docs/database/admin/save-data#node.js_4

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

    // temporary code to set a random room occupancy every hour
    var random_occupancy = Math.floor(Math.random() * Math.floor(20));
    ro.set({
        "room1": random_occupancy
    });
    return 0;
  
  });

// Run function once a day (every day at 23:59PM -> 11:59PM
exports.generate_weekly_occupancy_averages = functions.pubsub.schedule("45 23 * * *").timeZone('America/New_York').onRun((context) => {

    // figure out current day of the week
    var today = new Date();
    var day_of_week = today.getDay(); //0 = Sun, 1 = Mon, etc

    if (day_of_week === 0) {
      day_of_week = 6;
    }
    else{
      day_of_week = day_of_week-1;
    }
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
        console.log("average: "+ day[j][0] + " days: "+ day[j][1]);
        j++;
      });



      // get current averages for each hour for that specific day 

      const daily = admin.database().ref("DailyHourlyAverages");

      j = 0;
      
      daily.once("value", snapshot => {
        snapshot.forEach(data => {

          day[j][2]=data.val();
          console.log("daily average: "+ day[j][2]);

          j++;
        });

        // recalculate average
        var avg = new Array(24);
        var dcount = new Array(24);
        for (var i = 0;  i < day.length; i++){
          avg[i] = day[i][0]*day[i][1]+day[i][2];
          dcount[i] = day[i][1]+1;
          avg[i] = avg[i]/dcount[i];
          console.log("i: " +i+ " new average: "+ avg[i] + " new days: "+ dcount[i]);
        }

        // set new total averages and number of days for each hour
        //const w = admin.database.ref("WeeklyHourlyAverages");
        //String weekday = '"' + day_of_week +'"'
        //var td = ref.child(weekday.toString())
        weekly.update({
          "0":{
            "average": avg[0],
            "days": dcount[0]
          },
          "1":{
            "average": avg[1],
            "days": dcount[1]
          },
          "2":{
            "average": avg[2],
            "days": dcount[2]
          },
          "3":{
            "average": avg[3],
            "days": dcount[3]
          },
          "4":{
            "average": avg[4],
            "days": dcount[4]
          },
          "5":{
            "average": avg[5],
            "days": dcount[5]
          },
          "6":{
            "average": avg[6],
            "days": dcount[6]
          },
          "7":{
            "average": avg[7],
            "days": dcount[7]
          },
          "8":{
            "average": avg[8],
            "days": dcount[8]
          },
          "9":{
            "average": avg[9],
            "days": dcount[9]
          },
          "10":{
            "average": avg[10],
            "days": dcount[10]
          },
          "11":{
            "average": avg[11],
            "days": dcount[11]
          },
          "12":{
            "average": avg[12],
            "days": dcount[12]
          },
          "13":{
            "average": avg[13],
            "days": dcount[13]
          },
          "14":{
            "average": avg[14],
            "days": dcount[14]
          },
          "15":{
            "average": avg[15],
            "days": dcount[15]
          },
          "16":{
            "average": avg[16],
            "days": dcount[16]
          },
          "17":{
            "average": avg[17],
            "days": dcount[17]
          },
          "18":{
            "average": avg[18],
            "days": dcount[18]
          },
          "19":{
            "average": avg[19],
            "days": dcount[19]
          },
          "20":{
            "average": avg[20],
            "days": dcount[20]
          },
          "21":{
            "average": avg[21],
            "days": dcount[21]
          },
          "22":{
            "average": avg[22],
            "days": dcount[22]
          },
          "23":{
            "average": avg[23],
            "days": dcount[23]
          }


        });

        return 0;

      });

      

      return 0;

    });

  



    return 0;

  }); 



