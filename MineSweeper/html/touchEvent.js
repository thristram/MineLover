/**
 * Created by fangchenli on 5/23/17.
 */



function longTouchStart(i, j, e) {
    //swiftConsole("Touch started")
    if (e.touches.length == 1) {
        timeOutEvent = setTimeout(function () {
            //swiftConsole("Long Touch triggered")
            reverseTouchEvent(i, j)

        }, 500);
    }
    var t2 = e.timeStamp
        , t1 = $(this).data('lastTouch') || t2
        , dt = t2 - t1
        , fingers = e.originalEvent.touches.length;
    $(this).data('lastTouch', t2);
    if (!dt || dt > 500 || fingers > 1) return; // not double-tap

    e.preventDefault(); // double tap - prevent the zoom
    // also synthesize click events we just swallowed up

    return false;
}
function longTouchMove(i, j) {
    clearTimeout(timeOutEvent);
    //swiftConsole("Long Touch Moved")
    timeOutEvent = 0;
    return false;
}
function longTouchEnd(i, j,e) {
    clearTimeout(timeOutEvent);
    if (timeOutEvent != 0) {
        //swiftConsole("Long Touch Filed, this is a short touch");

        e.preventDefault();
        touchEvent(i, j);

    }
    return false;
}
function onClickEvent(i, j) {
    if (!ifAgentIsTouch) {
        swiftConsole("clicked");
        touchEvent(i, j)
    }
    return false
}
function onContextMenuEvent(i, j) {
    swiftConsole("Right clicked");
    reverseTouchEvent(i, j)
    return false;
}

function touchEvent(i, j){
    var cellName = i + "-" + j;
    switch (PO_Mode){
        case "square":
            checkMine(i, j);
            break;
        case "protect":
            protectBlock(i,j);
            break;
        default:
            if(gameMode == "sweep"){
                if(checkCoordIf(cellName,"checked") && (!checkCoordIf(cellName,"sweeped")) && (!checkCoordIf(cellName,"unchecked"))){
                    checkMine(i, j);
                }   else    {
                    sweepMine(i,j);
                }

            }   else    {
                checkMine(i, j);
            }
            break;
    }
}
function reverseTouchEvent(i, j){
    var cellName = i + "-" + j;
    switch (PO_Mode){
        case "square":
            sqareBlock(i,j);
            break;
        case "protect":
            protectBlock(i,j);
            break;
        default:
            if(gameMode == "sweep"){
                checkMine(i,j);
            }   else    {
                sweepMine(i, j);
            }
            break;
    }
}