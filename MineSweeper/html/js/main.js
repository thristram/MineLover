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
var gameMode = "normal"

$("#map").nodoubletapzoom();

//Touch Method



//Public


function swiftBridge(name, value){
    try{
        callSwift.postContent(name, value);
    } catch(exception){

    }
}

function swiftConsole(value, type){
    if (type){
        type = "[" + type.toUpperCase() + "]";
    }   else    {
        type = "";
    }
    if(connectSwift){

        swiftBridge("console", "--- JS Bridge Console --- " + type + " " + value);
    }
    console.log(type + " " + value)
}

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
        //swiftConsole("checking " + method + ".....")
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
            //swiftConsole(mine);
        }
    } else {
        swiftConsole("Mines Constructed");
        swiftConsole(mines);
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
    swiftConsole("Constructing Blocks");
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
     swiftConsole("Blank Blocks:");
     swiftConsole(blankBlockCoords)
     swiftConsole("Number Blocks:");
     swiftConsole(numberBlockCoords);
     swiftConsole("All Blocks:");
     swiftConsole(mapBlockCoords);
     */


}

function checkMinesArounds(i, j, mode) {
    //Mode 1: Mine, Mode 2: Sweeped
    //swiftConsole("Checking i=" + i + ", j=" + j);
    var numberOfMines = 0;
    for (var a = -1; a < 2; a++) {
        for (var b = -1; b < 2; b++) {
            if ((!(a == 0 && b == 0)) && ((i + a) > -1) && ((j + b) > -1) && ((i + a) < height) && ((j + b) < width)) {
                var cellName = (i + a) + "-" + (j + b);
                if (mode == 1) {
                    //swiftConsole("Checking Surrding x=" + a + ", y=" + b);
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
                    if(mapBlockCoords[cellName] >= gemContentLimit){
                        if(Math.random() <= gemProbability){
                            $(".cell-" + cellName).addClass("gem");
                            $(".cell-" + cellName).addClass("gem_n" + mapBlockCoords[cellName]);
                        }
                    }
                    break;
            }
        }
    }
}

function mineHelperChangeMap() {
    resetMapVariables();
    constructAllBlockContents()
    swiftConsole("Map Layout Changed");

}
function gameStart(i, j) {
    swiftConsole("Game Start");
    if (connectSwift) {
        swiftBridge("gameStart", "0");
        swiftBridge("currentMap", JSON.stringify(mapBlockCoords))
    }
    mapBlocks();
}
function checkMine(i, j) {
    var cellName = i + "-" + j;

    if (!stopMove) {
        //swiftConsole("Valid Click");
        if (!(checkCoordIf(cellName, "sweeped"))) {

            //Map Not Valid
            if (mineHelper && clicks == 0 && (!(checkCoordIf(cellName, "blank")))) {
                mineHelperChangeMap();
                checkMine(i, j);

            } else {

                //Map Valid and Game Start
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

                        if(tempGemSurround > 0){
                            swiftBridge("gemDetected",tempGemSurround);
                            tempGemSurround = 0;
                            /*
                            setTimeout(function(){
                                swiftBridge("gemDetected",tempGemSurround);
                                tempGemSurround = 0;
                            },100)
                            */
                        }

                    }
                } else {
                    checkGem(i, j)
                    openSlot(i, j, true);



                }


                //swiftConsole(clicks);
            }
        }
    }
}
var tempGemSurround = 0;
function checkGem(i, j){
    var cellName = i + "-" + j;
    if(checkCoordIf(cellName, "gem")){
        $(".cell-" + cellName).addClass("gemActive");
        swiftBridge("gemDetected",1)
    }
}
function countGem(i,j){
    if(clicks > 1){
        var cellName = i + "-" + j;
        if(checkCoordIf(cellName, "gem") && (!checkCoordIf(cellName, "checked"))){
            $(".cell-" + cellName).addClass("gemActive");
            tempGemSurround ++;
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
            countGem(i, j)
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
            swiftBridge("mines", totalMines - minesSweeped)
        }



    }

}
function gameOver() {
    if (connectSwift) {
        swiftBridge("gameStop", "0");
        swiftBridge("sweepCorrected", sweepCorrected);
        swiftBridge("sweepNotCorrected", sweepNotCorrected);
        swiftBridge("gameover", checked);
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
                swiftConsole("Wrong Marked");
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
                swiftBridge("mines", 0);
                swiftBridge("sweepCorrected", totalMines);
                swiftBridge("sweepNotCorrected", "0");
                swiftBridge("sweeped", totalMines);
            } else {
                $('#minesLeft').html(0)
            }

            setTimeout(function () {
                if(ifReadLove){
                    if (connectSwift) {
                        swiftBridge("win", 0);
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

            swiftConsole("Checked Block: " + checked);
            if (connectSwift) {
                swiftBridge("checked", checked);
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
        swiftConsole("Sweep Correct");
        sweepCorrected++;
        minesSweeped++;
    } else {
        $(".cell-" + i + "-" + j).addClass("sweepWrong");
        if(PO_Mode = "correct"){
            correctSlot(i,j)

        }   else{
            swiftConsole("Sweep Wrong");
            sweepNotCorrected++;
            minesSweeped++;
        }
    }
    minesSweeped++;
    if (connectSwift) {
        swiftBridge("sweepCorrected", sweepCorrected);
        swiftBridge("sweepNotCorrected", sweepNotCorrected);
        swiftBridge("sweeped", minesSweeped);
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
        swiftBridge("sweepCorrected", sweepCorrected);
        swiftBridge("sweepNotCorrected", sweepNotCorrected);
        swiftBridge("sweeped", minesSweeped);
    }
}

function restartGame() {
    PO_Mode = "none"
    resetAllVariables();
    constructAllBlockContents()

    if (connectSwift) {
        swiftBridge("mines", totalMines);
    }

    cleanMap();

}

function cleanMap() {


    $('.centerTitle').html('<span><i class="fa fa-smile-o fa-3x normal"></i></span>')
    var mapWidth = width * 32
    $("#map").parent().css({"width": mapWidth});
    $("#loveText").css({"width": width * 32, "height": height * 32})
    
    $(".cell").html("<span></span>");


    var workingClasses = ["checked", "mine", "sweeped", "sweepCorrect", "sweepWrong", "bombBlowed", "squared", "squaredFull","squaredAlpha", "gem", "gemActive", "protectorActive", "protector", "protectorClicking", "win", "n1", "n2", "n3", "n4", "n5", "n6", "n7", "n8", "gem_n1", "gem_n2", "gem_n3", "gem_n4", "gem_n5", "gem_n6", "gem_n7", "gem_n8", "corrector", "correctorActive"]
    for (var i = 0; i < workingClasses.length; i ++){
        $(".cell").removeClass(workingClasses[i]);
    }
    $(".cell").addClass("unchecked");
    $(".cell").attr("style","");
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
        swiftConsole("Mine Helper Disabled")
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

function fillGradientColor(startColor, endColor, step, protectorStartColor, protectorEndColor) {
    swiftConsole(startColor);
    var gradient = new gradientColor(startColor, endColor, step);
    var gradientProtector = new gradientColor(protectorStartColor, protectorEndColor, step);
    swiftConsole(gradient);
    var css = "<style id='additionalGrandientColor'>";
    for (var i = 0; i <= step; i++) {
        css += ".iCoord-" + i + "{background-color:" + gradient[i] + "}"
        css += "#map .iCoord-" + i + ".protectorActive, #map .iCoord-" + i + ".protectorSelection {background:" + gradientProtector[i] + "!important;border-radius:15px}"
    }
    css += "</style>";
    swiftConsole(css);
    $("#head").append(css);
}




function sendMapInfoToSwift() {
    if (connectSwift) {
        swiftBridge("gameWidth", width);
        swiftBridge("gameHeight", height);
        swiftBridge("gameTotalMines", totalMines);

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
        case 26:
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
    fillGradientColor("#c42935", "#7f4291", height, "#801ecc" ,"#16009e");
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
function setGameModeSweep(){
    gameMode = "sweep";
}
function setGameModeNormal(){
    gameMode = "normal";
}

$(document).ready(function () {

    if(!connectSwift){
        resetGame(width, height, totalMines, defaultScale, "yes", "2.0", "1.0", param_marginTop, param_marginLeft, param_tdWidth, param_tdHeight, param_divWidth, param_divHeight, param_fontSize, param_iconFontSize)
        setTimeout(function(){
            //setPOProtector();
        },3000)

        setTimeout(function(){
            //stopPOProtector();
        },8000)


    }   else {
        swiftConsole("init");
        sendMapInfoToSwift();
        swiftBridge("gameInit", width);
    }


});






