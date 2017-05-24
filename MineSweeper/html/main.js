//Map Arrays
var mines = [];
var blankBlockCoords = [];
var numberBlockCoords = [];
var mapBlockCoords = {};
/**
 * Created by fangchenli on 5/23/17.
 */

//Instance Statistics
var clicks = 0;
var checked = 0;
var minesSweeped = 0;
var sweepCorrected = 0;
var sweepNotCorrected = 0;

var ifWin = false;
var stopMove = false;
var ifMaped = false;

//Config
var mineHelper = true;

//TouchEvent
var timeOutEvent = 0;

//POWERUPS
var PO_Mode = "none";

$("#map").nodoubletapzoom();

//Touch Method



//Public

function checkCoordIf(coord, method) {
    var targetArray = [];
    var ifcheck = true;
    switch (method) {
        case "mine":
            targetArray = mines;
            break;
        case "blank":
            targetArray = blankBlockCoords;
            break;
        case "number":
            targetArray = numberBlockCoords;
            break;

        default:
            ifcheck = false;
            if ($(".cell-" + coord).hasClass(method)) {
                return true;
            } else {
                return false;
            }
            break;
    }
    if (ifcheck) {
        //console.log("checking " + method + ".....")
        if (targetArray.indexOf(coord) > -1) {
            return true;
        } else {
            return false
        }
    }

}


//Construct Maps
function constructMap() {
    var DOMObject = "";
    var spbg = "";
    for (var i = 0; i < height; i++) {
        DOMObject += "<tr>";
        for (var j = 0; j < width; j++) {

            if (((i % 2 + j % 2) % 2) == 0) {
                spbg = "spbg"
            } else {
                spbg = ""
            }
            DOMObject += "<td class='cellContainer'><div \
                    class = 'cell cell-" + i + "-" + j + " unchecked " + spbg + " iCoord-" + i + " jCoord-" + j + "' \
                    onclick = 'onClickEvent(" + i + ", " + j + ");'\
                    oncontextmenu = 'onContextMenuEvent(" + i + ", " + j + ");return false;'\
                    ontouchstart= 'longTouchStart(" + i + ", " + j + ",event);'\
                    ontouchmove='longTouchMove(" + i + ", " + j + ");'\
                    ontouchend='longTouchEnd(" + i + ", " + j + ", event);'\
                ></div></td>";

        }
        DOMObject += "</tr>";
    }

    $('#map').html(DOMObject);
}

function reConstructMap() {
    $("#map").html("");
    constructMap()
}

//Construct Blocks

function constructMines(index) {
    if (index < totalMines) {
        var mine = constructSingleMine(width, height);
        if (mines.indexOf(mine) > -1) {
            constructMines(index);


        } else {
            mines.push(mine);
            mapBlockCoords[mine] = -1;
            constructMines(index + 1);
            //console.log(mine);
        }
    } else {
        console.log("Mines Constructed");
        console.log(mines);
    }
}

function constructSingleMine(maxWidth, maxHeight) {
    var mineX = Math.floor(Math.random() * maxWidth + 0);
    var mineY = Math.floor(Math.random() * maxHeight + 0);
    var mineCoord = mineY + "-" + mineX;
    return mineCoord;
}

function constructAllBlockContents() {
    constructMines(0);
    console.log("Constructing Blocks");
    checkMinesArounds(1, 1, 1);

    for (var i = 0; i < height; i++) {
        for (var j = 0; j < width; j++) {
            var cellName = i + "-" + j;

            if (!mapBlockCoords[cellName]) {
                var coordContnet = checkMinesArounds(i, j, 1);
                if (coordContnet == 0) {
                    blankBlockCoords.push(i + "-" + j)
                } else {
                    numberBlockCoords.push(i + "-" + j)
                }
                mapBlockCoords[cellName] = coordContnet;
            }


        }
    }
    /*
     console.log("Blank Blocks:");
     console.log(blankBlockCoords)
     console.log("Number Blocks:");
     console.log(numberBlockCoords);
     console.log("All Blocks:");
     console.log(mapBlockCoords);
     */


}

function checkMinesArounds(i, j, mode) {
    //Mode 1: Mine, Mode 2: Sweeped
    //console.log("Checking i=" + i + ", j=" + j);
    var numberOfMines = 0;
    for (var a = -1; a < 2; a++) {
        for (var b = -1; b < 2; b++) {
            if ((!(a == 0 && b == 0)) && ((i + a) > -1) && ((j + b) > -1) && ((i + a) < height) && ((j + b) < width)) {
                var cellName = (i + a) + "-" + (j + b);
                if (mode == 1) {
                    //console.log("Checking Surrding x=" + a + ", y=" + b);
                    if (checkCoordIf(cellName, "mine")) {
                        numberOfMines++;
                    }
                } else if (mode == 2) {
                    if (checkCoordIf(cellName, "sweeped")) {
                        numberOfMines++;
                    }
                }
            }
        }
    }
    return numberOfMines;
}


function mapBlocks() {
    for (var i = 0; i < height; i++) {
        for (var j = 0; j < width; j++) {
            var cellName = i + "-" + j;
            switch (mapBlockCoords[cellName]) {
                case -1:
                    $(".cell-" + cellName).html("<span><i class='" + mineIcon + "'></i></span>");
                    $(".cell-" + cellName).addClass("mine");
                    break;
                case 0:
                    $(".cell-" + cellName).html("<span></span>")
                    $(".cell-" + cellName).attr("mValue", "")
                    $(".cell-" + cellName).addClass("blank");
                    break;
                default:
                    $(".cell-" + cellName).html("<span>" + mapBlockCoords[cellName] + "</span>")
                    $(".cell-" + cellName).attr("mValue", mapBlockCoords[cellName]);
                    $(".cell-" + cellName).addClass("n" + mapBlockCoords[cellName]);
                    break;
            }
        }
    }
}

function mineHelperChangeMap() {
    resetMapVariables();
    constructAllBlockContents()
    console.log("Map Layout Changed");

}
function gameStart(i, j) {
    console.log("Game Start");
    if (connectSwift) {
        callSwift.postContent("gameStart", "0");
        callSwift.postContent("currentMap", JSON.stringify(mapBlockCoords))
    }
    mapBlocks();
}
function checkMine(i, j) {
    var cellName = i + "-" + j;

    if (!stopMove) {
        console.log("Valid Click");
        if (!(checkCoordIf(cellName, "sweeped"))) {

            if (mineHelper && clicks == 0 && (!(checkCoordIf(cellName, "blank")))) {
                mineHelperChangeMap();
                checkMine(i, j);

            } else {

                if (clicks == 0) {
                    gameStart(i, j)
                }
                clicks++;
                if (checkCoordIf(cellName, "blank")) {

                    openSlot(i, j, true);

                    checkSurroundMine(i, j)


                } else if (checkCoordIf(cellName, "mine")) {

                    openSlot(i, j, false);
                    gameOver();

                } else if (checkCoordIf(cellName, "checked")) {

                    if (checkMinesArounds(i, j, 2) == mapBlockCoords[cellName]) {

                        checkSurroundMine(i, j)
                    }
                } else {
                    openSlot(i, j, true);
                }


                //console.log(clicks);
            }
        }
    }
}

function checkSeconderyMine(i, j) {
    var cellName = i + "-" + j;
    if (!(checkCoordIf(cellName, "sweeped"))) {

        if (checkCoordIf(cellName, "mine")) {
            openSlot(i, j, true);
            gameOver();
        }

        if (!(checkCoordIf(cellName, "checked"))) {
            openSlot(i, j, true);
            if (checkCoordIf(cellName, "blank")) {
                checkSurroundMine(i, j)

            }
        }


    }
}

function checkSurroundMine(i, j) {
    var c = 0;

    for (var a = -1; a < 2; a++) {
        for (var b = -1; b < 2; b++) {
            if ((!(a == 0 && b == 0)) && ((i + a) > -1) && ((j + b) > -1) && ((i + a) < height) && ((j + b) < width)) {
                checkSeconderyMine((i + a), (j + b));
            }
        }
    }
}

function sweepMine(i, j) {
    var cellName = i + "-" + j;

    //If the first click is a sweep, start timer and start game
    if (clicks == 0) {
        gameStart(i, j);
    }
    clicks++;

    //If game is not over
    if (!stopMove) {

        if (checkCoordIf(cellName, "unchecked")) {
            if (checkCoordIf(cellName, "sweeped")) {
                unsweepSlot(i, j)
            } else {
                sweepSlot(i, j);
            }
        } else {
            if (checkCoordIf(cellName, "sweeped")) {
                unsweepSlot(i, j)
            }
        }
        if (connectSwift) {
            callSwift.postContent("mines", totalMines - minesSweeped)
        }


    }

}
function gameOver() {
    if (connectSwift) {
        callSwift.postContent("gameStop", "0");
        callSwift.postContent("sweepCorrected", sweepCorrected);
        callSwift.postContent("sweepNotCorrected", sweepNotCorrected);
        callSwift.postContent("gameover", checked);
    }

    stopMove = true;
    showAllMines(true);


}
function showAllMines(ifLose) {

    for (var i = 0; i < height; i++) {
        for (var j = 0; j < width; j++) {
            var cellName = i + "-" + j;
            if (checkCoordIf(cellName, "mine")) {
                if (ifLose) {
                    $(".cell-" + cellName).addClass("bombBlowed");

                    if (!(checkCoordIf(cellName, "sweeped"))) {
                        $(".cell-" + cellName).html("<span><i class='" + mineIcon + "'></i></span>");
                    }

                } else {
                    $(".cell-" + cellName).addClass("win");
                    $(".cell-" + cellName).addClass("checked");


                    $(".cell-" + cellName).html("<span><i class='" + flagIcon + "'></i></span>");
                }

                $(".cell-" + cellName).show();
            } else if (ifLose && checkCoordIf(cellName, "sweepWrong")) {
                console.log("Wrong Marked");
                $(".cell-" + cellName).html("<span><i class='" + wrongIcon + "'></i></span>");
                $(".cell-" + cellName).show();
            }


        }

    }

}
function checkWin() {


    if (checked == (width * height - totalMines)) {

        if (!ifWin) {
            ifWin = true;
            stopMove = true;
            showAllMines(false);


            if (connectSwift) {
                callSwift.postContent("mines", 0);
                callSwift.postContent("sweepCorrected", totalMines);
                callSwift.postContent("sweepNotCorrected", "0");
                callSwift.postContent("sweeped", totalMines);
            } else {
                $('#minesLeft').html(0)
            }

            setTimeout(function () {
                if(ifReadLove){
                    if (connectSwift) {
                        callSwift.postContent("win", 0);
                    }
                }   else    {
                    displayLove();
                }

                /*

                 */

            }, 300)


        }

    }
}
function openSlot(i, j, ifCount) {
    var cellName = i + "-" + j;

    if (ifCount) {


        if ((checkCoordIf(cellName, "unchecked")) && (!(checkCoordIf(cellName, "checked"))) && (!(checkCoordIf(cellName, "mine"))) && (!checkCoordIf(cellName, "sweeped"))) {
            checked++;

            console.log("Checked Block: " + checked);
            if (connectSwift) {
                callSwift.postContent("checked", checked);
            }

            checkWin();
        }
    }
    $(".cell-" + cellName).removeClass("unchecked");
    $(".cell-" + cellName).addClass("checked");
    $(".cell-" + cellName).find("span").show();


}
function sweepSlot(i, j) {
    $(".cell-" + i + "-" + j).removeClass("unchecked");
    $(".cell-" + i + "-" + j).addClass("checked");
    $(".cell-" + i + "-" + j).addClass("sweeped");
    $(".cell-" + i + "-" + j).html("<span><i class='" + flagIcon + "'></i></span>");

    if ($(".cell-" + i + "-" + j).hasClass("mine")) {
        $(".cell-" + i + "-" + j).addClass("sweepCorrect");
        sweepCorrected++;
    } else {
        $(".cell-" + i + "-" + j).addClass("sweepWrong");
        sweepNotCorrected++;
    }
    minesSweeped++;
    if (connectSwift) {
        callSwift.postContent("sweepCorrected", sweepCorrected);
        callSwift.postContent("sweepNotCorrected", sweepNotCorrected);
        callSwift.postContent("sweeped", minesSweeped);
    }
}
function unsweepSlot(i, j) {
    $(".cell-" + i + "-" + j).addClass("unchecked");
    $(".cell-" + i + "-" + j).removeClass("checked");
    $(".cell-" + i + "-" + j).removeClass("sweeped");
    $(".cell-" + i + "-" + j).removeClass("sweepCorrect");
    $(".cell-" + i + "-" + j).removeClass("sweepWrong")
    $(".cell-" + i + "-" + j).html("<span>" + $(".cell-" + i + "-" + j).attr("mValue") + "</span>");
    if ($(".cell-" + i + "-" + j).hasClass("mine")) {

        sweepCorrected--;
    } else {

        sweepNotCorrected--;
    }
    minesSweeped--;
    if (connectSwift) {
        callSwift.postContent("sweepCorrected", sweepCorrected);
        callSwift.postContent("sweepNotCorrected", sweepNotCorrected);
        callSwift.postContent("sweeped", minesSweeped);
    }
}

function restartGame() {

    resetAllVariables();
    constructAllBlockContents()

    if (connectSwift) {
        callSwift.postContent("mines", totalMines);
    }

    cleanMap();

}

function cleanMap() {


    $('.centerTitle').html('<span><i class="fa fa-smile-o fa-3x normal"></i></span>')
    var mapWidth = width * 32
    $("#map").parent().css({"width": mapWidth});
    $("#loveText").css({"width": width * 32, "height": height * 32})
    $(".squared").attr("style","");
    $(".cell").html("<span></span>");
    $(".cell").removeClass("checked");
    $(".cell").removeClass("mine");
    $(".cell").removeClass("sweeped");
    $(".cell").removeClass("sweepCorrect");
    $(".cell").removeClass("sweepWrong");
    $(".cell").removeClass("win");
    $(".cell").removeClass("n1");
    $(".cell").removeClass("n2");
    $(".cell").removeClass("n3");
    $(".cell").removeClass("n4");
    $(".cell").removeClass("n5");
    $(".cell").removeClass("n6");
    $(".cell").removeClass("n7");
    $(".cell").removeClass("n8");
    $(".cell").removeClass("bombBlowed");
    $(".cell").addClass("unchecked");
    $(".cell").removeClass("squared");
    $(".cell").removeClass("squaredFull");
    $(".cell").removeClass("squaredAlpha");

}


function checkValid() {
    var maxHeight = 40;
    var maxWidth = 40;
    var minHeight = 8;
    var minWidth = 8;
    var maxMine = width * height - 1;

    if (!height) height = 16;
    if (!width) width = 16;
    if (!totalMines) totalMines = 10;

    if ((width * height / totalMines < 4) || width < 8 || height < 8) {
        mineHelper = false;
        console.log("Mine Helper Disabled")
    }
    if (width < minWidth) {
        alert("Width Must Greater than " + minWidth);
        width = minWidth
    }
    if (height < minHeight) {
        alert("Height Must Greater than " + minHeight);
        height = minHeight
    }
    if (width > maxWidth) {
        alert("Width Must Less than " + maxWidth);
        width = maxWidth
    }
    if (height > maxHeight) {
        alert("Height Must Less than " + maxHeight);
        height = maxHeight
    }
    if (totalMines > maxMine) {
        alert("Mines Must Less than " + maxMine);
        totalMines = maxMine
    }

}

function fillGradientColor(startColor, endColor, step) {
    console.log(startColor);
    var gradient = new gradientColor(startColor, endColor, step);
    console.log(gradient);
    var css = "<style id='additionalGrandientColor'>";
    for (var i = 0; i <= step; i++) {
        css += ".iCoord-" + i + "{background-color:" + gradient[i] + "}"
        css += "#map .iCoord-" + i + ".protectorActive{background-color:" + gradient[i] + "!important}"
    }
    css += "</style>";
    console.log(css);
    $("#head").append(css);
}




function sendMapInfoToSwift() {
    if (connectSwift) {
        callSwift.postContent("gameWidth", width);
        callSwift.postContent("gameHeight", height);
        callSwift.postContent("gameTotalMines", totalMines);

    }
}
function setViewPoint(setScale, setScaleable, setMaxScale, setMinScale) {
    var viewPoint = {
        "width": "device-width",
        "initial-scale": "1",
        "shrink-to-fit": "no",
        "user-scalable": "yes",
        "maximum-scale": "2.0",
        "minimum-scale": "1"
    }
    switch (height) {
        case 28:
            $("#map").css({"margin-top": "10px"});
            $("td").css({"height": "30px"});
            viewPoint["user-scalable"] = setScaleable;
            viewPoint["maximum-scale"] = setMaxScale;
            viewPoint["minimum-scale"] = setMinScale;
            break;
        case 18:
            $("#map").css({"margin-top": "0px"});
            $("td").css({"height": "29px"});

            break;
        default:
            $("#map").css({"margin-top": "0px"});
            $("td").css({"height": "30px"});
            viewPoint["user-scalable"] = "1.6";
            break;

    }

    var viewPoints = []
    for (key in viewPoint) {
        viewPoints.push(key + "=" + viewPoint[key]);
    }
    $("#viewPoint").attr("content", viewPoints.join(","));
}

function resetGame(setWidth, setHeight, setMines, setScale, setScaleable, setMaxScale, setMinScale, marginTop, marginLeft, tdWidth, tdHeight, divWidth, divHeight, fontSize, iconFontSize) {

    width = parseInt(setWidth);
    height = parseInt(setHeight);
    totalMines = parseInt(setMines);
    param_marginTop = parseInt(marginTop);
    param_marginLeft = parseInt(marginLeft);
    param_tdWidth = parseInt(tdWidth);
    param_tdHeight = parseInt(tdHeight);
    param_divWidth = parseInt(divHeight);
    param_divHeight = parseInt(divHeight);
    param_fontSize = fontSize;
    param_iconFontSize = iconFontSize;
    sendMapInfoToSwift();
    if (width > 15) {
        setViewPoint(setScale, setScaleable, setMaxScale, setMinScale)
    }

    var mapWidth = width * 32

    $("body").css({"zoom": setScale})

    $("#map").parent().css({
        "width"         : mapWidth,
        "margin-top"    : marginTop + "px",
        "margin-left"   : marginLeft + "px",
    });
    var css = "#map td.cellContainer {width: " + tdWidth + "px; height: " + tdHeight + "px} " +
        "#map div.cell {width: " + divWidth + "px; height: " + divHeight + "px} " +
        "#map span {font-size: " + fontSize + "} ";
    $("#customizedCSS").html(css);



    $("#loveText").css({"width": width * 32, "height": height * 32})
    $("#additionalGrandientColor").remove();

    defaultScale = setScale;

    reConstructMap();
    fillGradientColor("#c42935", "#7f4291", height);
    restartGame();

    /*
     $(".cellContainer").css({
     "width"         : tdWidth + "px",
     "height"        : tdHeight + "px",
     });
     $(".cell").css({
     "width"         : divWidth + "px",
     "height"        : divHeight + "px",
     });
     $("#map span").css({
     "font-size"     : fontSize,
     });
     */


}


function resetMapVariables() {
    mines = [];
    blankBlockCoords = [];
    numberBlockCoords = [];
    mapBlockCoords = {};
}
function resetInstanceStatistics() {
    clicks = 0;
    checked = 0;
    minesSweeped = 0;
    sweepCorrected = 0;
    sweepNotCorrected = 0;
}


function resetAllVariables() {

    resetMapVariables();
    resetInstanceStatistics();
    ifWin = false;
    stopMove = false;
    timeOutEvent = 0;


}






function setPONone(){
    PO_Mode = "none";
    $(".unchecked").css({"opacity":"1"});
}


$(document).ready(function () {

    if(!connectSwift){
        resetGame(width, height, totalMines, defaultScale, "yes", "2.0", "1.0", param_marginTop, param_marginLeft, param_tdWidth, param_tdHeight, param_divWidth, param_divHeight, param_fontSize, param_iconFontSize)
        setTimeout(function(){
            setPOProtector();
        },3000)

        setTimeout(function(){
            stopPOProtector();
        },8000)


    }   else {
        console.log("init");
        sendMapInfoToSwift();
        callSwift.postContent("gameInit", width);
    }






});






