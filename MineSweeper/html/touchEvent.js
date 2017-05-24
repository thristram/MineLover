/**
 * Created by fangchenli on 5/23/17.
 */



function longTouchStart(i, j, e) {
    console.log("Touch started")
    if (e.touches.length == 1) {
        timeOutEvent = setTimeout(function () {
            console.log("Long Touch triggered")
            switch (PO_Mode){
                case "square":
                    sqareBlock(i,j);
                    break;
                case "protect":
                    protectBlock(i,j);
                    break;
                default:
                    sweepMine(i, j);
                    break;
            }

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
    console.log("Long Touch Moved")
    timeOutEvent = 0;
    return false;
}
function longTouchEnd(i, j,e) {
    clearTimeout(timeOutEvent);
    if (timeOutEvent != 0) {
        console.log("Long Touch Filed, this is a short touch");

        e.preventDefault();
        switch (PO_Mode){
            case "square":
                sqareBlock(i,j);
                break;
            case "protect":
                protectBlock(i,j);
                break;
            default:
                checkMine(i, j);
                break;
        }

    }
    return false;
}
function onClickEvent(i, j) {
    if (!ifAgentIsTouch) {
        console.log("clicked");
        switch (PO_Mode){
            case "square":
                checkMine(i, j);
                break;
            case "protect":
                protectBlock(i,j);
                break;
            default:
                checkMine(i, j);
                break;
        }

    }
    return false
}
function onContextMenuEvent(i, j) {
    console.log("Right clicked");
    switch (PO_Mode){
        case "square":
            sqareBlock(i,j);
            break;
        case "protect":
            protectBlock(i,j);
            break;
        default:
            sweepMine(i, j)
            break;
    }
    return false;
}