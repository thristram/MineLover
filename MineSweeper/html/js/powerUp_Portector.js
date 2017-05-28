/**
 * Created by fangchenli on 5/23/17.
 */

var protectedClicked = {}
var POProtectorLevel = 1;
var POProtectorTime = 1;
var levelAssigment = [
    {"i": 0, "j": 0, "time": 1000},
    {"i": 5, "j": 5, "time": 2000},
    {"i": 13, "j": 8, "time": 3000},
    {"i": 17, "j": 10, "time": 4000},
    {"i": 20, "j": 12, "time": 5000},
    {"i": 100, "j": 100, "time": 6000},

];
var protectorSelectFlag = false;

function setPOProtector(level, time) {
    PO_Mode = "protect";
    POProtectorLevel = level;
    POProtectorTime = time;
    checkLevel()

}
function readyPOProtector() {
    $(".protector").animate({"opacity": "0.01"}, 500);
    setTimeout(function () {
        $(".protector").addClass("protectorActive");
    }, 500);
    setTimeout(function () {
        $(".protector").animate({"opacity": "1"}, 500);
    }, 550);
    swiftBridge("protectorReady", 1);


}

function startPOProtector() {
    /*

     var currentLevelAssigment = levelAssigment[POProtectorTime];
     setTimeout(function () {
     stopPOProtector()

     }, currentLevelAssigment["time"]);
     */
}
function stopPOProtector() {
    if (connectSwift) {
        stopProtector()
        swiftBridge("stopProtector", "1");
    } else {
        stopProtector()
    }
}
function checkLevel() {
    var currentLevelAssigment = levelAssigment[POProtectorLevel];

    if (currentLevelAssigment["i"] >= height && currentLevelAssigment["j"] >= width) {
        $(".cell:not(.squared)").addClass("protector");
        readyPOProtector()
    } else {
        protectorSelectFlag = true;
        setClassSelectionAnimation("cell", "protector")

    }
}
function protectSelectBlock(i, j) {
    protectorSelectFlag = false;
    var currentLevelAssigment = levelAssigment[POProtectorLevel];
    var leftCount, rightCount, topCount, bottomCount;
    if (currentLevelAssigment["i"] % 2 == 1) {
        leftCount = (currentLevelAssigment["i"] - 1) / 2;
        rightCount = leftCount
    } else {
        leftCount = (currentLevelAssigment["i"]) / 2;
        rightCount = leftCount - 1
    }
    if (currentLevelAssigment["j"] % 2 == 1) {
        topCount = (currentLevelAssigment["j"] - 1) / 2;
        bottomCount = topCount
    } else {
        topCount = (currentLevelAssigment["j"]) / 2;
        bottomCount = topCount - 1
    }
    for (var a = (i - leftCount); a < (i + rightCount + 1); a++) {
        for (var b = (j - topCount); b < (j + bottomCount + 1); b++) {
            if ((a > -1) && (b > -1) && (a < (height + 1)) && (b < (width + 1))) {
                $(".cell-" + a + "-" + b + ":not(.squared)").addClass("protector");
            }
        }
    }
    readyPOProtector()
}
function stopProtector() {

    $(".cell").addClass("protectorClicking");


    $(".protector").animate({"opacity": "0.01"}, 500);
    setTimeout(function () {
        $(".protector").removeClass("protectorActive");
        $(".cell").removeClass("protector");
        $(".cell").removeClass("protectorClicking");
        PO_Mode = "none";
    }, 500);
    setTimeout(function () {
        setPONone()
        finishProtector();
        $(".cell").animate({"opacity": "1"}, 500);
    }, 550);


}
function protectBlock(i, j) {
    var cellName = i + "-" + j;
    swiftConsole(cellName, "protected click");
    protectedClicked [cellName] = 1
    if (checkCoordIf(cellName, "protectorActive")) {
        animateBounceEffect(i, j)
    }
}

function animateBounceEffect(i, j) {
    var cellName = i + "-" + j;
    if ((!checkCoordIf(cellName, "protectorClicking")) && (!checkCoordIf(cellName, "squared"))) {

        var time = 100;
        var div_zoom = [1.0, 0.4, 0.6, 0.8, 0.9, 0.95];
        var margin = []
        for (var a = 0; a < div_zoom.length; a++) {
            margin.push((1 - div_zoom[a]) * 50);
        }


        $(".cell-" + cellName).addClass("protectorClicking");
        $(".cell-" + cellName).animate({
            "zoom": div_zoom[1],
            "margin-top": margin[1] + "%",
            "margin-left": margin[1] + "%"
        }, time, function () {
            $(".cell-" + cellName).animate({
                "zoom": div_zoom[0],
                "margin-top": "0%",
                "margin-left": "0%"
            }, time, function () {
                $(".cell-" + cellName).animate({
                    "zoom": div_zoom[2],
                    "margin-top": margin[2] + "%",
                    "margin-left": margin[2] + "%"
                }, time, function () {
                    $(".cell-" + cellName).animate({
                        "zoom": div_zoom[0],
                        "margin-top": "0%",
                        "margin-left": "0%"
                    }, time, function () {
                        $(".cell-" + cellName).animate({
                            "zoom": div_zoom[3],
                            "margin-top": margin[3] + "%",
                            "margin-left": margin[3] + "%"
                        }, time, function () {
                            $(".cell-" + cellName).animate({
                                "zoom": div_zoom[0],
                                "margin-top": "0%",
                                "margin-left": "0%"
                            }, time, function () {
                                $(".cell-" + cellName).animate({
                                    "zoom": div_zoom[4],
                                    "margin-top": margin[4] + "%",
                                    "margin-left": margin[4] + "%"
                                }, time, function () {
                                    $(".cell-" + cellName).animate({
                                        "zoom": div_zoom[0],
                                        "margin-top": "0%",
                                        "margin-left": "0%"
                                    }, time, function () {
                                        $(".cell-" + cellName).animate({
                                            "zoom": div_zoom[5],
                                            "margin-top": margin[5] + "%",
                                            "margin-left": margin[5] + "%"
                                        }, time, function () {
                                            $(".cell-" + cellName).animate({
                                                "zoom": div_zoom[0],
                                                "margin-top": "0%",
                                                "margin-left": "0%"
                                            }, time, function () {
                                                $(".cell-" + cellName).removeClass("protectorClicking");
                                            });

                                        });

                                    });

                                });
                            });

                        });
                    });
                });
            });
        });
    }

}
function finishProtector() {

    for (var key in protectedClicked) {
        swiftConsole(key, "protected perform");
        var coord = key.split("-");
        if ((!checkCoordIf(key, "mine")) && (!checkCoordIf(key, "checked"))) {
            checkMine(coord[0], coord[1])
        }
    }
    protectedClicked = {}
}



