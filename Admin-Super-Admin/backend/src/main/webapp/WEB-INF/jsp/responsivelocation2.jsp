<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form"  uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="responsiveheaderlocation.jsp" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
     <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
 
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
 
  <!--  <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=${googleMapsApiKey}"></script> -->
    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js" type="text/javascript"></script>
<!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"> -->

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

<link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap" rel="stylesheet">
  <script src="https://maps.googleapis.com/maps/api/js?key=${googleMapsApiKey}&libraries=geometry"></script>
  
  
<style>
html {
    height: 100%;
     overflow-x: hidden;
     max-width:100%;
}
body {
    min-height: 100%;
     background-color: white;
   /*   background-color: #f1f1f1;*/
    margin: 0;        /* Remove default margin */
    padding: 0; 
     overflow-x: hidden;
     max-width:100%;
}
* { 
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}
.filter-container
{
display: flex;flex-direction: row;align-items: center;padding: 10px 16px;gap: 10px;width: 100%;background: #FFFFFF;
flex: none;order: 1;align-self: stretch;flex-grow: 0;}
#filterbutton
{
box-sizing: border-box;width: 34px;height: 34px;background: #FFFFFF;border-radius: 5px;flex: none;order: 0;flex-grow: 0;
border: 2px solid var(--Brand-Primary, #F27C0A);
}
#hand{
      width: 341px;      height: 22px;font-family: 'Inter';font-style: normal;font-weight: 600;font-size: 20px;line-height: 20px;
color: #000000;flex: none;order: 0;display:flex;flex-direction:row;gap:10px;align-items: center;
      }
       .spotlightlist
{
/*display: flex;flex-direction:row;    transition: transform 0.3s ease-in-out; gap:20px;align-items:center;justify-content:center;  */
display: flex;
flex-direction: row;
align-items: flex-start;
padding: 16px;
gap: 17px;
width: 360px;
height: 132px;
/*overflow-x: scroll;*/
flex: none;
order: 0;
align-self: stretch;
flex-grow: 0;
}
.spotlightitem
{
display: flex;
padding: 16px 0px;
flex-direction: column;
justify-content: center;
align-items: center;
gap: 0px;
border-radius: 10px;
/*background: #FFF;*/
}
.spotlightimg
{
border-radius: 50%;
}
#map2
{
 width: 100%;
 height: 530px;
}
input[type=range][orient=vertical] {
    writing-mode: vertical-lr;
    direction: rtl;
    appearance: slider-vertical;
    width: 3px;
    vertical-align: bottom;
    z-index:10;
    position:relative;
    -webkit-appearance: none; 
    background:#FFF;  top:35px;
}

 /* Styling for the slider thumb */
    input[type="range"]::-webkit-slider-thumb {
      -webkit-appearance: none; /* Remove default styling for WebKit browsers */
      width: 20px; /* Width of the slider thumb */
      height: 20px; /* Height of the slider thumb */
      background: #F27C0A; /* Color of the slider thumb */
      cursor: pointer; /* Pointer cursor on hover */
      border-radius: 50%; /* Round shape for the thumb */
     /* border: 2px solid #333; /* Border color and thickness */
    }

    input[type="range"]::-moz-range-thumb {
      width: 20px; /* Width of the slider thumb */
      height: 20px; /* Height of the slider thumb */
      background: #4CAF50; /* Color of the slider thumb */
      cursor: pointer; /* Pointer cursor on hover */
      border-radius: 50%; /* Round shape for the thumb */
      border: 2px solid #333; /* Border color and thickness */
    }

    input[type="range"]::-ms-thumb {
      width: 20px; /* Width of the slider thumb */
      height: 20px; /* Height of the slider thumb */
      background: #4CAF50; /* Color of the slider thumb */
      cursor: pointer; /* Pointer cursor on hover */
      border-radius: 50%; /* Round shape for the thumb */
      border: 2px solid #333; /* Border color and thickness */
    }

    /* Optional: Change track color when slider is active */
    input[type="range"]:active {
      background: #bbb; /* Color of the slider track when active */
    }
#rangeOutputId{position:absolute;margin-left:-8px;z-index:10;background: #FFF;
    font-weight: bold;margin-bottom: 10px;display:block;}
    
    #rangeInputId{display:block;position:absolute;}
.markercard-container
{
display:none;
}
</style>
</head>
<body>
<div class=filter-container>
<button  id = "filterbutton" data-toggle="bottom-sheet" data-target="#bottom-sheet" class="show-modal"><i class="fa fa-sliders"></i></button>
<div class="top-filters" style ="display: flex;flex-direction: row;align-items: center;gap: 10px;">
<div id ="hand"><i class="fa fa-hand-o-left" style = "color:#F27C0A;font-size: 20px;"></i><h5 >Click here for categories </h5></div></div>
</div>

<div class="ads-container" style ="display: flex; flex-direction: column;gap: 20px;background:#f1f1f1;height: 100%;">
<div class="spotlightlist" id ="spotlightlist" ></div>
<div class="map-container" style ="display: flex;flex-direction: row;flex-wrap: wrap;
justify-content: center;align-items: center;align-content: center;padding: 0px;
gap: 10px;isolation: isolate;width: 100%;/*height: 529px;*/flex: none;order: 0;align-self: stretch;flex-grow: 1;z-index: 0;">
  
<div id="map2"></div>
<div id="slider-container" style ="z-index: 1;    position: absolute;    width: 212.66px;    height: 95px;    left: calc(50% - 190.66px / 2 + 237.33px);
    top: calc(50% - 310px / 2 + 149.5px);    display: flex;    flex-direction: column;    flex: none;    order: 1;    flex-grow: 0;    gap: 20px;"> 
 <output id="rangeOutputId" >1.3 km</output>
  <input type="range" min="1.3" max="5.7" value="1.3" orient="vertical" id ="rangeInputId" step="2.2" oninput="sliderClick()" >  
  </div>  
<div class="markercard-container" id = "markercard-container">
<div class="panel panel-default" style ="align-items: flex-start;padding: 0px;gap: 10px;position: absolute;width: 90%;left: 15px;top: 585px;border-radius: 20px;height:175px;">
		     <div class="panel-body" style = "display:flex;flex-direction:row;width:100%;">
		     <div class="leftcontainer" style ="width:75%;">
		   <div class="cardcol" style ="display: flex;flex-direction: column;align-items: flex-start;padding: 0px;gap: 10px;
width: 208px;height: 100px;flex: none;order: 0;align-self: stretch;flex-grow: 1;">
		    <div style="display:flex;flex-direction:row;gap:10px;"> 
		    <img src="<c:url value="''" />"  alt="User profile" class="spotlightimg" id ="cardcompanyurl" style="width:50px;height:50px;"/>
		     <div id="frame20"><h5 id="cardpublishername"></h5></div>
		     </div>
		    <div class="" style ="width:100%;"><div class="text-container">
		     <p id ="cardtitle"></p>
		    <!--  <p id ="carddescription"></p>-->
		     </div><!-- body -->
		     </div>
		   <div class="button-cont" style="display:flex;flex-direction:row;gap: 20px;">
		   <div class="phone" id ="phone" ><i class="fa fa-phone"></i></div>
		     <div class="whatsapp" id ="whatsapp" ><i class="fa fa-whatsapp"></i></div>
		     <div class="email" id ="email"><i class="fa fa-envelope"></i></div>
		     <div class="takeme" ><button  id ="takeme"  ><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Take me there</button></div>
		     </div>
		     </div>
		      </div>
		     <div class="cardimage-container">
		     <img src="<c:url value="''" />"  alt="User profile"  id ="cardthumbnail" style="width:100%;height:85%;"/>
		     
		     </div>
		     
		     </div><!-- body -->
		     


</div>
</div>
<!-- spolight section end here -->

</div><!-- map-container -->

</div><!-- ads container -->

<script type="text/javascript">
//to load spotlights start here
var users = ${users};
var spotlight="";
var x=0;
for(var i=0;i<users.length;i++)
{
	var name =users[i].fullName;
	var profilepicpath= users[i].profilePicPath;
	var str = name.substring(0, 10);
	var userid = users[i].id;
	spotlight+='<div class="spotlightitem" role="button" id = "'+userid+'">'
+'	<img  src="<c:url value="'+profilepicpath+'" />"  alt="User profile" style="width: 37px;height: 39px;" class="spotlightimg"/>'
		+'<div class="companyname">'+str+'</div>'
+'</div>';    
} 
 $('.spotlightlist').append(spotlight);
 
//to load spotlights end here
//dragging listener for spotlight starts here 2 
let currentPage = 1;  // Keep track of the current page of items
let isLoading = false;  // Prevent multiple loads at the same time
const swipeWrapper = document.getElementById('spotlightlist');



// Variables for swipe gesture
let startX = 0;
let currentX = 0;
let offsetX = 0;
let isSwiping = false;
let swipeIndex = 0;

// Detect swipe start
swipeWrapper.addEventListener('touchstart', function(e) {
	console.log('TOUCH');
    startX = e.touches[0].clientX;
    isSwiping = true;
});

// Detect swipe movement
swipeWrapper.addEventListener('touchmove', function(e) {
    if (!isSwiping) return;

    currentX = e.touches[0].clientX;
    offsetX = currentX - startX;

    swipeWrapper.style.transform = 'translateX(' + (-swipeIndex * 100) + '% + ' + (offsetX / window.innerWidth) * 100 + '%)';
});

// Detect swipe end
swipeWrapper.addEventListener('touchend', function() {
    if (!isSwiping) return;

    if (Math.abs(offsetX) > 50) {
        if (offsetX > 0 && swipeIndex > 0) {
            swipeIndex--;  // Swipe left, move to the previous item
        } else if (offsetX < 0 && swipeIndex < swipeWrapper.children.length - 1) {
            swipeIndex++;  // Swipe right, move to the next item
        }
    }

    swipeWrapper.style.transition = 'transform 0.3s ease-in-out';
    swipeWrapper.style.transform = 'translateX(-' + swipeIndex * 100 + '%)';

    // If we reach the last item, load more items
    if (swipeIndex === swipeWrapper.children.length - 1) {
        currentPage++;
        loadItems(currentPage);  // Load the next batch of items
    }

    isSwiping = false;
    startX = 0;
    currentX = 0;
    offsetX = 0;
});

// Initial loading of items
//swipe spotlight end here

//bottom sheet start here
var btn = document.getElementById("filterbutton");
var modal = document.getElementById("bottomSheetModal");
//bottom sheet start here 
const showModalBtn =
    document.querySelector(".show-modal");
const bottomSheet =
    document.querySelector(".bottom-sheet");
const dragHandle =
    document.querySelector(".drag-handle");
const closeBtn =
    document.querySelector(".close-btn");

let isDragging = false;
let startY, startBottom;

showModalBtn.addEventListener("click", () => {
    bottomSheet.style.display = "block";
    document.body.style.overflow = "hidden";
    bottomSheet.style.bottom = "0";
});

dragHandle
    .addEventListener("mousedown", startDragging);
closeBtn
    .addEventListener("click", hideBottomSheet);

function startDragging(e) {
    e.preventDefault();
    isDragging = true;
    startY = e.clientY;
    startBottom =
        parseInt(getComputedStyle(bottomSheet).bottom);
    document.addEventListener("mousemove", drag);
    document.addEventListener("mouseup", stopDragging);
}

function drag(e) {
    if (!isDragging) return;
    const deltaY =
        e.clientY - startY;
    bottomSheet.style.bottom =
        Math.max(startBottom - deltaY, 0) + "px";
}

function stopDragging() {
    isDragging = false;
    document
        .removeEventListener("mousemove", drag);
    document
        .removeEventListener("mouseup", stopDragging);
}

function hideBottomSheet() {
    bottomSheet.style.display = "none";
    document.body.style.overflow = "auto";
    bottomSheet.style.bottom = "-100%";
}

//bottom sheet end here

</script>
<jsp:include page="responsivefooter.jsp" /> 
</body>
</html>