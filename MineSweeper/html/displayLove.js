/**
 * Created by fangchenli on 5/23/17.
 */

//Display Love
var ifReadLove = false;

function readLove(){
    ifReadLove = true;
}

function displayLove(){
    var myDate = new Date();
    var currentDate = myDate.getMonth() + "-" + myDate.getDate();
    console.log(currentDate);
    if(currentDate == "4-20"){
        ifReadLove = true;
        if (connectSwift) {
            callSwift.postContent("readLove", "1");
        }
        $.ajax({
            url: "http://ha.applicationclick.com/index.php/index/check520",
            crossDomain: true,
            type: "GET",
            //contentType: 'application/json',
            success: function (data) {
                if(data != "111"){
                    console.log(data);
                    $(".loveTextContent").html(data);
                    startAnimation();
                }   else    {
                    if (connectSwift) {
                        callSwift.postContent("win", 0);
                    }
                }
            },
            error: function(){
                console.log("Connection Failed");
                if (connectSwift) {
                    callSwift.postContent("win", 0);
                }
                //startAnimation();
                //alert("Cannot get data");
            }
        });
    }   else    {
        if (connectSwift) {
            callSwift.postContent("win", 0);
        }

    }
}
function startAnimation() {
    var inTime = 3000;
    var duringTime = 50000;
    $("#loveText").fadeIn(inTime, function () {
        $(".loveTextContent").animate({"margin-top": "-750px"}, duringTime, "linear", function () {
            $("#loveText").fadeOut(inTime, function () {
                animateLoveShape();
            })
        });
    })


}
var loveArray = [
    "4-7", "3-8", "2-9", "2-10", "2-11", "3-12", "4-13", "5-13", "6-13", "7-13", "8-12", "9-11", "10-10", "11-9", "12-8", "13-7", "12-6", "11-5", "10-4", "9-3", "8-2", "7-1", "6-1", "5-1",
    "4-1", "3-2", "2-3", "2-4", "2-5", "3-6", "15-0", "16-0", "17-0", "18-0", "19-0", "19-1", "19-2", "15-4", "15-5", "16-6", "17-6", "18-6", "19-5", "19-4",
    "18-3", "17-3", "16-3", "15-8", "16-8", "17-8", "18-8", "19-9", "18-10", "17-10", "16-10", "15-10", "15-12", "16-12", "17-12", "18-12", "19-12", "19-13",
    "19-14", "15-13", "15-14", "17-13", "17-14", "21-1", "22-1", "23-1", "23-2", "23-3", "22-3", "21-3", "24-2", "25-2", "21-6", "21-7", "22-8", "23-8", "24-8",
    "25-7", "25-6", "24-5", "23-5", "22-5", "21-10", "22-10", "23-10", "24-10", "25-11", "25-12", "24-13", "23-13", "22-13", "21-13"
];
var generateLoveShapeSpeed = 100;
function animateLoveShape() {
    resetGame(16, 28, 90, "0.80", "yes", "2.0", "1.0");
    startAnimateLoveShape(0);


}
function startAnimateLoveShape(i){
    if(i < loveArray.length){
        setTimeout(function(){
            var tempCell = loveArray[i].split("-");
            console.log(tempCell);
            sweepMine(tempCell[0],tempCell[1]);
            i ++;
            startAnimateLoveShape(i);
        },generateLoveShapeSpeed);
    }   else    {
        if (connectSwift) {
            callSwift.postContent("win", 0);
        }
    }
}