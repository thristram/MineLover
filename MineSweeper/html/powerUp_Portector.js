/**
 * Created by fangchenli on 5/23/17.
 */

var protectedClicked = {}

function setPOProtector() {
    PO_Mode = "protect";


    $(".cell:not(.squared)").addClass("protector");




    $(".protector").animate({"opacity": "0.01"}, 500);
    setTimeout(function () {
        $(".protector").addClass("protectorActive");
    }, 500);
    setTimeout(function () {
        $(".protector").animate({"opacity": "1"}, 500);
    }, 550);


    setTimeout(function () {
        if (connectSwift) {
            stopProtector()
            swiftBridge("stopProtector", "1");
        } else {
            stopProtector()
        }

    }, 5000);

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
    swiftConsole(cellName,"protected click");
    protectedClicked [cellName] = 1
    if (checkCoordIf(cellName, "protectorActive")) {
        animateBounceEffect(i, j)
    }
}

function animateBounceEffect(i, j) {
    var cellName = i + "-" + j;
    if ((!checkCoordIf(cellName, "protectorClicking")) && (!checkCoordIf(cellName, "squared"))) {

        var time = 100;
        var div_heights = [param_divHeight, 12, 18, 24, 26, 28];
        var div_widths = div_heights;
        var margin_tops = []
        var margin_lefts = []

        for (var i = 0; i < div_heights.length; i++) {
            margin_tops.push((param_tdHeight - div_heights[i]) / 2)
            margin_lefts.push((param_tdWidth - div_widths[i]) / 2)
        }

        $(".cell-" + cellName).addClass("protectorClicking");
        $(".cell-" + cellName).animate({
            "width": div_widths[1] + "px",
            "height": div_heights[1] + "px",
            "margin-top": margin_tops[1] + "px",
            "margin-left": margin_lefts[1] + "px"
        }, time, function () {
            $(".cell-" + cellName).animate({
                "width": div_widths[0] + "px",
                "height": div_heights[0] + "px",
                "margin-top": margin_tops[0] + "px",
                "margin-left": margin_lefts[0] + "px"
            }, time, function () {
                $(".cell-" + cellName).animate({
                    "width": div_widths[2] + "px",
                    "height": div_heights[2] + "px",
                    "margin-top": margin_tops[2] + "px",
                    "margin-left": margin_lefts[2] + "px"
                }, time, function () {
                    $(".cell-" + cellName).animate({
                        "width": div_widths[0] + "px",
                        "height": div_heights[0] + "px",
                        "margin-top": margin_tops[0] + "px",
                        "margin-left": margin_lefts[0] + "px"
                    }, time, function () {
                        $(".cell-" + cellName).animate({
                            "width": div_widths[3] + "px",
                            "height": div_heights[3] + "px",
                            "margin-top": margin_tops[3] + "px",
                            "margin-left": margin_lefts[3] + "px"
                        }, time, function () {
                            $(".cell-" + cellName).animate({
                                "width": div_widths[0] + "px",
                                "height": div_heights[0] + "px",
                                "margin-top": margin_tops[0] + "px",
                                "margin-left": margin_lefts[0] + "px"
                            }, time, function () {
                                $(".cell-" + cellName).animate({
                                    "width": div_widths[4] + "px",
                                    "height": div_heights[4] + "px",
                                    "margin-top": margin_tops[4] + "px",
                                    "margin-left": margin_lefts[4] + "px"
                                }, time, function () {
                                    $(".cell-" + cellName).animate({
                                        "width": div_widths[0] + "px",
                                        "height": div_heights[0] + "px",
                                        "margin-top": margin_tops[0] + "px",
                                        "margin-left": margin_lefts[0] + "px"
                                    }, time, function () {
                                        $(".cell-" + cellName).animate({
                                            "width": div_widths[5] + "px",
                                            "height": div_heights[5] + "px",
                                            "margin-top": margin_tops[5] + "px",
                                            "margin-left": margin_lefts[5] + "px"
                                        }, time, function () {
                                            $(".cell-" + cellName).animate({
                                                "width": div_widths[0] + "px",
                                                "height": div_heights[0] + "px",
                                                "margin-top": margin_tops[0] + "px",
                                                "margin-left": margin_lefts[0] + "px"
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
        swiftConsole(key,"protected perform");
        var coord = key.split("-");
        if ((!checkCoordIf(key, "mine")) && (!checkCoordIf(key, "checked"))) {
            checkMine(coord[0], coord[1])
        }
    }
    protectedClicked = {}
}



