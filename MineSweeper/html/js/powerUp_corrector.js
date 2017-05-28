/**
 * Created by fangchenli on 5/25/17.
 */

var correctorCurrent = 5;

function setPOCorrector(limit){

    correctorCurrent = limit;
    PO_Mode = "corrector";
    swiftBridge("correctStart", correctorCurrent)
}

function correctSlot(i,j){
    if(correctorCurrent > 0){
        correctorCurrent--;
        swiftBridge("correctActivated", correctorCurrent)
        swiftConsole("Corrector Active");
        swiftConsole("Corrector Remaining: " + correctorCurrent)


        //$(".cell-" + i + "-" + j).removeClass("unchecked");
        //$(".cell-" + i + "-" + j).addClass("checked");
        $(".cell-" + i + "-" + j).addClass("corrector");
        $(".cell-" + i + "-" + j).addClass("correctorActive");
        $(".cell-" + i + "-" + j).removeClass("sweeped");
        $(".cell-" + i + "-" + j).html("<span><i class='" + wrongIcon + "'></i></span>");
        $(".cell-" + i + "-" + j).removeClass("sweepWrong");
        animateWrongSlot(i,j)
    }   else    {
        stopCorrector();
    }

    
}

function animateWrongSlot(i,j){
    animateBounceEffect(i, j)
    setTimeout(function(){
        animateBounceEffect(i, j)
    }, 600)
    setTimeout(function(){
        $(".cell-" + i + "-" + j).addClass("unchecked");
        $(".cell-" + i + "-" + j).removeClass("checked");
        $(".cell-" + i + "-" + j).removeClass("corrector");
        $(".cell-" + i + "-" + j).removeClass("correctorActive");
        $(".cell-" + i + "-" + j).removeClass("sweeped");
        $(".cell-" + i + "-" + j).html("<span>" +  $(".cell-" + i + "-" + j).attr("mValue") + "</span>");
        $(".cell-" + i + "-" + j).removeClass("sweepWrong");
    }, 1000)
    
    
    
}

function stopCorrector(){
    PO_Mode = "none";
    correctorCurrent = 0;
    swiftBridge("correctStop",0)
}
