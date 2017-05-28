/**
 * Created by fangchenli on 5/23/17.
 */

var SQ_increment = 10;
var SQ_totalTime = 36 * 2;
var SQ_sizeFrom = 30;
var SQ_sizeTo = 0;
var SQ_toRadius = 5;

var SQ_rotation = 0;
var SQ_index = 0;

var POSquareLevel = 1;

function setPOSqaure(level){
    PO_Mode = "square";
    POSquareLevel = level
    swiftBridge("startSquare","1")
    setClassSelectionAnimation("unchecked","square")
}


var uncheckedSelectionAlpha = 1.0;
var uncheckedSelectionMin = 0.5;
var uncheckedSelectionIncrement = 0.03;
var currentUncheckedSelectionAlpha = uncheckedSelectionAlpha;
var currentUncheckedSelectionSign = -1
function setClassSelectionAnimation(className, type){
    currentUncheckedSelectionAlpha += (uncheckedSelectionIncrement * currentUncheckedSelectionSign);

    if (currentUncheckedSelectionAlpha <= uncheckedSelectionMin){
        currentUncheckedSelectionSign = +1
    }   else if(currentUncheckedSelectionAlpha >= uncheckedSelectionAlpha)    {
        currentUncheckedSelectionSign = -1
    }

    $("." + className).css({"opacity" : currentUncheckedSelectionAlpha});
    setTimeout(function(){
        if((type == "square") && (PO_Mode != "none")){
            setClassSelectionAnimation(className, "square")
        }
        if((type == "protector") && protectorSelectFlag){
            setClassSelectionAnimation(className, "protector")
        }

    },3)
}


function squareBlock(i,j,level){
    swiftBridge("stopSquareSelection","1")
    setPONone();
    
    var limit = 3;
    switch(level){
        case 1: limit = 3; break;
        case 2: limit = 6; break;
        case 3: limit = 9; break;
        case 4: limit = 15; break;
        case 5: limit = 25; break;
        default: limit = 3;break;
    }
    var blockOrder = [
        ".cell-" + (i) + "-" + (j),
        ".cell-" + (i) + "-" + (j - 1),
        ".cell-" + (i) + "-" + (j + 1),

        ".cell-" + (i - 1) + "-" + (j - 1),
        ".cell-" + (i - 1) + "-" + (j),
        ".cell-" + (i - 1) + "-" + (j + 1),

        ".cell-" + (i + 1) + "-" + (j - 1),
        ".cell-" + (i + 1) + "-" + (j),
        ".cell-" + (i + 1) + "-" + (j + 1),


        ".cell-" + (i - 1) + "-" + (j - 2),
        ".cell-" + (i - 1) + "-" + (j + 2),
        ".cell-" + (i) + "-" + (j - 2),
        ".cell-" + (i) + "-" + (j + 2),
        ".cell-" + (i + 1) + "-" + (j - 2),
        ".cell-" + (i + 1) + "-" + (j + 2),

        ".cell-" + (i - 2) + "-" + (j - 2),
        ".cell-" + (i - 2) + "-" + (j - 1),
        ".cell-" + (i - 2) + "-" + (j),
        ".cell-" + (i - 2) + "-" + (j + 1),
        ".cell-" + (i - 2) + "-" + (j + 2),
        ".cell-" + (i + 2) + "-" + (j - 2),
        ".cell-" + (i + 2) + "-" + (j - 1),
        ".cell-" + (i + 2) + "-" + (j),
        ".cell-" + (i + 2) + "-" + (j + 1),
        ".cell-" + (i + 2) + "-" + (j + 2),
    ];

    for(var index = 0; index  < limit; index ++){
        if(!$(blockOrder[index]).hasClass("checked")){
            $(blockOrder[index]).addClass("squared")

            if($(blockOrder[index]).hasClass("mine")){
                $(blockOrder[index]).html("<span><i class='" + mineIcon + "'></i></span>");
            }
        }

    }
    rotateDiv($(".squared"));

}
function finishSquare(i,j){

    $(".squared").animate({"opacity":"0.01"},1000,function(){
        $(".squared").find("span").show();
        $(".squared").addClass("squaredAlpha")
    });

    setTimeout(function(){
        $(".squared").animate({"opacity":"0.5"},1000);
    },1050);
    setTimeout(function(){
        $(".squared").animate({"opacity":"0.01"},1000);
    },2100);
    setTimeout(function(){
        $(".squared").animate({"opacity":"0.5"},1000);

    },3150);
    setTimeout(function(){
        $(".squared").animate({"opacity":"0.01"},1000,function(){

            $(".squared").removeClass("squaredAlpha")
            $(".squared").animate({"opacity":"1"},1300);
            $(".squared:not(.checked)").find("span").hide();
            swiftBridge("stopSquare", "1");

        });
    },4200)



}


var SQ_halfTime = SQ_totalTime / 2;
var SQ_sizeIntval = SQ_sizeTo - SQ_sizeFrom;
var SQ_eachTimeChangeSize = SQ_sizeIntval / SQ_halfTime;
var SQ_eachTimeChangeRadius = ((SQ_sizeFrom / 2) - SQ_toRadius) / SQ_halfTime;
var SQ_eachTimeChangeMargin = -SQ_eachTimeChangeSize / 2;

var SQ_currentSize = SQ_sizeFrom;
var SQ_currentRadius = SQ_sizeFrom / 2;
var SQ_currentMargin = 0;


function rotateDiv(selector) {
    SQ_rotation += SQ_increment;
    if (SQ_index < SQ_halfTime) {
        SQ_currentSize += SQ_eachTimeChangeSize;
        //SQ_currentRadius -= SQ_eachTimeChangeRadius;
        SQ_currentMargin += SQ_eachTimeChangeMargin;
    } else {
        SQ_currentSize -= SQ_eachTimeChangeSize;
        SQ_currentMargin -= SQ_eachTimeChangeMargin;
    }
    if (SQ_index == SQ_halfTime) {
        selector.addClass("squaredFull")
    }
    SQ_index++;
    selector.css({
        'transform': 'rotate(' + SQ_rotation + 'deg)',
        //"border-radius": SQ_currentRadius + "px",
        "width": SQ_currentSize + "px",
        "height": SQ_currentSize + "px",
        "margin-left": SQ_currentMargin + "px",
        "margin-top": SQ_currentMargin + "px"
    });

    if (SQ_index < SQ_totalTime) {
        setTimeout(function () {
            rotateDiv(selector)
        }, 10)
    } else {
        SQ_increment = 10;
        SQ_totalTime = 36 * 4;
        SQ_sizeFrom = 30;
        SQ_sizeTo = 0;
        SQ_toRadius = 5;

        SQ_rotation = 0;
        SQ_index = 0;

        SQ_halfTime = SQ_totalTime / 2;
        SQ_sizeIntval = SQ_sizeTo - SQ_sizeFrom;
        SQ_eachTimeChangeSize = SQ_sizeIntval / SQ_halfTime;
        SQ_eachTimeChangeRadius = ((SQ_sizeFrom / 2) - SQ_toRadius) / SQ_halfTime;
        SQ_eachTimeChangeMargin = -SQ_eachTimeChangeSize / 2;

        SQ_currentSize = SQ_sizeFrom;
        SQ_currentRadius = SQ_sizeFrom / 2;
        SQ_currentMargin = 0;
        finishSquare()
    }
}
