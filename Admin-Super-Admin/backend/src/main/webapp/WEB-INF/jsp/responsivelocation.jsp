<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form"  uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="responsiveheaderlocation.jsp" />
<% Boolean currentLocationSetting = (Boolean) session.getAttribute("currentLocationset"); %>
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
 height:700px;/* 530px;*/
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

/*css for bottom sheet start */



.bottom-sheet {
    display: none;
    position: fixed;
    bottom: 0;
    left: 0;
    width: 100%;
    background-color: #fff;
    border-top-left-radius: 20px;
    border-top-right-radius: 20px;
    box-shadow: 0px -3px 10px rgba(0, 0, 0, 0.2);
    overflow: hidden;height:52%;
}

.sheet-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
   /* padding: 10px 20px;*/
    background-color: #fff;
    color: #fff;
}

.drag-handle {
    width: 80px;/*30px;*/
    height: 3px;
    background-color: #bdadad;/*#fff;*/
    border-radius: 10px;
    cursor: grab;
    margin: 0 auto;
}

.close-btn {
    background: none;
    border: none;
    color: #fff;
    font-size: 24px;
    cursor: pointer;
}

.sheet-content {
    padding: 8px;display:flex;flex-direction:column;gap:5px;/*10px;*/
}

.sheet-content h2 {
    font-size: 24px;
    margin-bottom: 10px;
}

.sheet-content p {
    font-size: 16px;
    line-height: 1.5;
}
/*css for bottom sheet start */

.search-filter
{
box-sizing: border-box;display: flex;flex-direction: row;align-items: center;padding: 0px 10px;gap: 10px;
width: 100px;height: 40px;background: #FFFFFF;border: 1px solid #D0D0D0;border-radius: 10px;flex: none;order: 0;flex-grow: 0;
}

.botsheetbutton
{
/*display: flex;flex-direction: row;*/justify-content: center;align-items: center;padding: 5px 10px;gap: 10px;/*width: 116px;*/
/*height: 26px;*/
background: #fff;/* linear-gradient(90deg, #F27C0A 0%, #F2382C 100%), #FFFFFF;*/border-radius: 100px;flex: none;order: 0;flex-grow: 0;
outline: none;border: 1px solid #D6D6D6;
font-family: 'Inter';
font-style: normal;
font-weight: 400;
font-size: 10px;
line-height: 12px;
color: #000000;
flex: none;
order: 1;
flex-grow: 0;
}

.filters-container
{
box-sizing: border-box;
display: flex;
flex-direction: column;
align-items: flex-start;
padding: 14px;
gap: 10px;
isolation: isolate;
width: 100%;
height:  205px;/*145px;*/
overflow-y: scroll;
border: 1px solid #E5E5E5;
border-radius: 10px;
flex: none;
order: 1;
flex-grow: 1;
}

.close-button{
color: #FFFFFF;
cursor:pointer;
}
.filtersappliedinsheet{
display:flex;
flex-direction:row;
gap:5px;flex-shrink: 0;
}

.dynamic-button{
display: flex;    padding: 5px 16px;    justify-content: center;    align-items: center;    gap: 10px;
    border-radius: 100px;    background: linear-gradient(90deg, rgb(242, 124, 10) 0%, rgb(242, 56, 44) 100%), rgb(255, 255, 255);
    color: rgb(255, 255, 255);    font-family: Inter;    font-size: 10px;    font-style: normal;    font-weight: 400;
    line-height: normal;    align-self: start;    outline: none;    border: none;}
    
.dynamic-div
{   display: flex;
    flex-direction: row;
    flex-shrink: 0;
}

#hand{
      width: 341px;      height: 22px;font-family: 'Inter';font-style: normal;font-weight: 600;font-size: 20px;line-height: 20px;
color: #000000;flex: none;order: 0;display:flex;flex-direction:row;gap:10px;align-items: center;
      }

 #reset
 {
 display: flex;
flex-direction: row;
justify-content: center;
align-items: center;
padding: 10px 16px;
gap: 10px;
/*width: 155px;*/
height: 37px;
background: #F4F4F4;
border-radius: 5px;
flex: none;
order: 0;
/*flex-grow: 1;*/
 }  
 
 #apply
 {
box-sizing: border-box;
display: flex;
flex-direction: row;
justify-content: center;
align-items: center;
padding: 10px 16px;
gap: 10px;
/*width: 155px;*/
height: 37px;
border: 1px solid #000000;
border-radius: 5px;
flex: none;
order: 1;
flex-grow: 1; background:white;
 }
 /* css for slider start here*/
 .mapcontainer
{
height:400px;
 position: relative;
 display:flex;
 flex-direction:row; 
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
    background:#FFF;  top:55px;
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
    font-weight: bold;margin-bottom: 10px;display:block;width: 40px;}
    
    #rangeInputId{display:block;position:absolute;}
.markercard-container
{
display:none;
}
#takeme
{
display: flex;
flex-direction: row;
align-items: center;
padding: 5px 14px;
gap: 5px;
isolation: isolate;
width: 100px;
height: 34px;
background: #FFF;
border-radius: 10px;
flex: none;
order: 0;
flex-grow: 0;border:none;outline:none;font-family: 'Inter';font-style: normal;font-weight: 700;
font-size: 12px;line-height: 15px;color: #F27C0A;border: 1px solid var(--Brand-Primary, #F27C0A);
}

/* css for slider end here */


  .close-button{
color: #FFFFFF;
cursor:pointer;
}


#loginModal {
 /*  position: absolute;*/
   top: 58%;
   left: 50%;
   transform: translate(-50%, -50%);width:75%;   
}
#sendotp
{
display: flex;
flex-direction: row;
justify-content: center;
align-items: center;
padding: 6px 10px;
gap: 5px;
background: linear-gradient(90deg, #F27C0A 0%, #F2382C 100%);
border-radius: 5px;
flex: none;
order: 2;
flex-grow: 0;
z-index: 2;font-family: 'Inter';
font-style: normal;
font-weight: 700;
font-size: 12px;
line-height: 15px;
color: #FFFFFF;
}

#otpModal {
 /*  position: absolute;*/
   top: 50%;
   left: 50%;
   transform: translate(-50%, -50%);width:80%;   
}
#login
{
display: flex;
flex-direction: row;
justify-content: center;
align-items: center;
padding: 6px 10px;
gap: 5px;
width: 87px;
height: 36px;
background: linear-gradient(90deg, #F27C0A 0%, #F2382C 100%);
border-radius: 5px;
flex: none;
order: 3;
flex-grow: 0;
z-index: 3;
}

.go-button {
    width: 25px;
    height: 25px;
    border-radius: 50%;
    background-color: #F27C0A;
    border: none;
    color: white;
    font-size: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    transition: background-color 0.3s ease;
}
</style>
</head>
<body>

<div style = "display:flex;flex-direction:row;gap:2px;align-items:center;">
 <div id="noofresults" style ="/*margin-left: 250px;*/font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 13px;line-height: 22px;color: #000000;display: flex;    flex-direction: row;    justify-content: flex-end;    margin-right: 25px;padding: 10px;"></div><!-- </div>-->
 <div style ="display: flex;    flex-direction: row;    gap: 10px;align-items: center; font-family: 'Inter';    font-style: normal;    font-weight: 700;    font-size: 13px;    line-height: 22px;    color: #000000;">Current Radius in KM : <input type="text" id="radius"   size="20" class="form-control input-sm" style = "width:45px;"><button class="go-button" id = "gobutton"><i class="fa fa-arrow-right" aria-hidden="true"></i></button></div>
 </div>
<div class="filter-container" id = "filter-container">
<button  id = "filterbutton" data-toggle="bottom-sheet" data-target="#bottom-sheet" class="show-modal"><i class="fa fa-sliders"></i></button>
<div class="top-filters" style ="display: flex;flex-direction: row;align-items: center;gap: 10px;">
<div id ="hand"><i class="fa fa-hand-o-left" style = "color:#F27C0A;font-size: 20px;"></i><h5 >Click here for categories </h5></div></div>
</div><!-- filter container -->

<div class="ads-container" style ="display: flex;    flex-direction: column;    gap: 20px;background: #f1f1f1;height: 100%;">
<!-- <div class="spotlightlist" id ="spotlightlist" ></div>-->
<!-- <div class="sliderclick" id ="sliderclick"></div><div class= "radius: " id = "radius"> </div>-->
<div class="map-container" style ="/*display: flex;flex-direction: row;*/flex-wrap: wrap;
justify-content: center;align-items: center;align-content: center;padding: 0px;
gap: 10px;isolation: isolate;width: 100%;height: 100%;flex: none;order: 0;align-self: stretch;flex-grow: 1;z-index: 0;">
  
<div id="map2"></div>
<!-- <div id="slider-container" style ="z-index: 1;    position: absolute;   /* width: 212.66px;   */ height: 95px;    left: calc(50% - 190.66px / 2 + 237.33px);
    top: calc(50% - 310px / 2 + 149.5px);    display: flex;    flex-direction: column;    flex: none;    order: 1;    flex-grow: 0;    gap: 20px;"> 
 <output id="rangeOutputId" >0.1 km</output>
<!--   <input type="range" min="1.3" max="5.7" value="1.3" orient="vertical" id ="rangeInputId" step="2.2" oninput="sliderClick()" >  -->
 <!--    <input type="range" min="0.1" max="5.3"  step="0.1" value ="0.1" orient="vertical" id ="rangeInputId"  onchange="sliderClick()" oninput="sliderOninput()">  
  </div>  -->
<div class="markercard-container" id = "markercard-container">
<div class="panel panel-default" style ="/*align-items: flex-start;padding: 0px;gap: 10px;position: absolute;width: 90%;left: 15px;top: 650px;border-radius: 20px;height:175px;*/  position: fixed;
    bottom: 70px;
    left: 50%;
    transform: translateX(-50%);
    -webkit-transform: translateX(-50%);
    -ms-transform: translateX(-50%);
    width: 92%;
    max-width: 420px;
    min-width: 280px;
    background: #fff;
    border-radius: 16px;
    -webkit-border-radius: 16px;
    padding: 12px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.15);
    -webkit-box-shadow: 0 4px 20px rgba(0,0,0,0.15);
    border: none;
    margin: 0;
    height: auto;
    min-height: 172px;
    max-height: 200px;
    overflow: hidden;
    display: -webkit-box;
    display: -ms-flexbox;
    display: flex;
    -webkit-box-orient: vertical;
    -webkit-box-direction: normal;
    -ms-flex-direction: column;
    flex-direction: column;
    transition: all 0.3s ease;
    -webkit-transition: all 0.3s ease;
    -moz-transition: all 0.3s ease;
    -o-transition: all 0.3s ease;
    z-index: 1000;"> 
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
		   <div class="phone" id ="phone" ><i class="fa fa-phone" style = "font-size:20px;"></i></div>
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
<!-- bottom sheet start  -->
<div class="bottom-sheet" id ="bottom-sheet">
        <div class="sheet-header">
            <div class="drag-handle"></div>
            <button class="close-btn">
                &times;
            </button>
        </div>
        <div class="sheet-content">
         <div class="filternsearch" style = " padding: 10px;/* 20px;*/
    display:flex;flex-direction:row;gap:20px;align-items: center;    justify-content: space-between;">
            <h4 style =" font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 18px;line-height: 22px;text-transform: capitalize;
color: #000000;">Filters </h4>
            
    <!--         <div  class="search-filter">
          <input type="text" class="form-control input-sm" id="smallInput" placeholder="Search" style="border:none;padding:6px 1px;">
            <svg width="32" height="32" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect width="24" height="24" rx="12" fill="url(#paint0_linear_1_689)"/>
<path d="M18 18L15.1047 15.1047M15.1047 15.1047C15.5999 14.6094 15.9928 14.0215 16.2608 13.3744C16.5289 12.7273 16.6668 12.0338 16.6668 11.3333C16.6668 10.6329 16.5289 9.9394 16.2608 9.29232C15.9928 8.64523 15.5999 8.05727 15.1047 7.56202C14.6094 7.06676 14.0215 6.6739 13.3744 6.40586C12.7273 6.13783 12.0338 5.99988 11.3333 5.99988C10.6329 5.99988 9.9394 6.13783 9.29232 6.40586C8.64523 6.6739 8.05727 7.06676 7.56202 7.56202C6.5618 8.56224 5.99988 9.91882 5.99988 11.3333C5.99988 12.7479 6.5618 14.1045 7.56202 15.1047C8.56224 16.1049 9.91882 16.6668 11.3333 16.6668C12.7479 16.6668 14.1045 16.1049 15.1047 15.1047Z" stroke="white" stroke-linecap="round" stroke-linejoin="round"/>
<defs>
<linearGradient id="paint0_linear_1_689" x1="0" y1="12" x2="24" y2="12" gradientUnits="userSpaceOnUse">
<stop stop-color="#F27C0A"/>
<stop offset="1" stop-color="#F2382C"/>
</linearGradient>
</defs>
</svg>
            
            </div>--><!-- search filter -->
            <div  class="search-filter2">
         <button  id ="apply">Done</button>
            
            
            </div>
            </div>
         
          <div class="filters-container">
          <div class= "Foodheader" style ="font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">Food</div>
          <div class="Food" style ="display: flex;    flex-direction: row;    flex-wrap: wrap;    gap: 10px;">         
          <button class="botsheetbutton" value ="64887cc6cce361dafc86c313">Veg Food<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
           <button class="botsheetbutton" value="64887cc6cce361dafc86c314">Non-Veg Food<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
            <button class="botsheetbutton" value = "64887cc6cce361dafc86c31c">Fruits,Flowers & Veggies<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
             <button class="botsheetbutton" value="64887cc6cce361dafc86c31f">Ice Creams & Milk Products<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
          </div>
          <div class= "Vehicleheader" style ="font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">Vehicle & Transport</div>
           <div class="Vehicle&Transport" style ="display: flex;    flex-direction: row;    flex-wrap: wrap;    gap: 10px;">
           <button class="botsheetbutton" value ="64887cc6cce361dafc86c315">Vehicles & Rentals<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
           <button class="botsheetbutton" value ="64887cc6cce361dafc86c320">Fuel Stations<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
            <button class="botsheetbutton" value="64887cc6cce361dafc86c323">Tours & Travels<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
             <button class="botsheetbutton" value="64887cc6cce361dafc86c324" >Vehicle Sales & Services<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
          </div>
           <div class= "Travelheader" style ="font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">Travel & Accomodation</div>
           <div class="Travel&Accomodation" style ="display: flex;    flex-direction: row;    flex-wrap: wrap;    gap: 10px;">
          <button class="botsheetbutton" value="64887cc6cce361dafc86c316">Hotels & Rooms<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
           <button class="botsheetbutton" value="64887cc6cce361dafc86c31b">Places of Interest<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
            <button class="botsheetbutton" value="64887cc6cce361dafc86c31d">Temples<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
           </div>
            <div class= "Storeheader" style ="font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">Store Front</div>
           <div class="StoreFront" style ="display: flex;    flex-direction: row;    flex-wrap: wrap;    gap: 10px;" >
          <button class="botsheetbutton" value = "64887cc6cce361dafc86c319" >Stores,Groceries & Supermarket<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
           <button class="botsheetbutton" value="64887cc6cce361dafc86c31a">Clothes & Dresses<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
            <button class="botsheetbutton" value="64887cc6cce361dafc86c31e">Banks & ATMs<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
             <button class="botsheetbutton" value="64887cc6cce361dafc86c326">Saloon & SPA<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
           <button class="botsheetbutton" value="64887cc6cce361dafc86c328">Home Appliances<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
            <button class="botsheetbutton" value="64887cc6cce361dafc86c329">Construction & Building Materials<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
          </div>
           <div class= "Healthheader" style ="font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">Health Care</div>
           <div class="HealthCare" style ="display: flex;    flex-direction: row;    flex-wrap: wrap;    gap: 10px;">
           <button class="botsheetbutton" value = "64887cc6cce361dafc86c321">Pharmacy/Medical Shops<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
           <button class="botsheetbutton" value="64887cc6cce361dafc86c322">Hospitals, Clinics & Labs<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
            <button class="botsheetbutton" value="64887cc6cce361dafc86c325">Emergency Services & Help<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
          </div>
          <div class= "Servicesheader" style ="font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">Services & Information</div>
           <div class="Services&Information" style ="display: flex;    flex-direction: row;    flex-wrap: wrap;    gap: 10px;">
          <button class="botsheetbutton" value = "64887cc6cce361dafc86c327">Real Estate<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
           <button class="botsheetbutton" value="64887cc6cce361dafc86c32a">Professional & Labour Services<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
            <button class="botsheetbutton" value="64887cc6cce361dafc86c32b">Venues & Events<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
             <button class="botsheetbutton" value="64887cc6cce361dafc86c32d">Agricultural Products & Nursery<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
           <button class="botsheetbutton" value="64887cc6cce361dafc86c32e">Public Notice<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
            <button class="botsheetbutton" value="64887cc6cce361dafc86c317">Jobs<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
            <br>
            <br>
          </div>
           
          </div>
         
            <!-- Add your content here -->
            <div class="filterbuttons" style ="display: flex;flex-direction: row;align-items: flex-start;padding: 0px;gap: 10px;height: 37px;flex: none;order: 3;align-self: stretch;flex-grow: 0;z-index: 3;justify-content:flex-end;">
<button  id ="reset">RESET</button>
<!-- <button  id ="apply">APPLY</button>--></div>
        </div><!-- sheet content -->
        
         </div>
 
<!-- bottom sheet end -->
<!-- Login Modal start -->
  <div class="modal fade" id="loginModal" role="dialog" style ="z-index:1076;">
    <div class="modal-dialog modal-sm">
      <div class="modal-content" style ="border-radius:10px;">
        <div class="modal-body" style ="display:flex;flex-direction:column;height:150px;border-radius:10px;">
        <div style ="display:flex;flex-direction:row;/*gap: 165px;*/justify-content: space-between;width:100%; "><h4 style ="font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 18px;line-height: 22px;color: #000000;">Login </h4><button type="button" class="close" data-dismiss="modal" id="loginModalClose">&times;</button></div>
        <div><p style="font-family: 'Inter';font-style: normal;font-weight: 400;font-size: 14px;line-height: 17px;color: #000000;opacity: 0.5;">Enter Your Phone Number</div>
         <div style =" border-bottom: 2px solid #ccc;width:100%;padding: 10px;"> <input type ="number" placeholder="Enter your phone number" style ="border:none;outline:none;font-family: 'Inter';
font-style: normal;font-weight: 400;font-size: 14px;line-height: 17px;color: #000000;opacity: 0.5;" id ="mobilenumber"autocomplete="off"></div>
        </div>
        <div class="modal-footer" style ="border-top:none;">
          <button type="button" class="btn btn-default" data-dismiss="modal" id="sendotp">Send OTP<svg width="13" height="14" viewBox="0 0 13 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M11.9959 0.909464C11.9459 0.359448 11.4595 -0.0458946 10.9095 0.00410676L1.94643 0.818928C1.39641 0.868929 0.991068 1.35534 1.04107 1.90536C1.09107 2.45537 1.57748 2.86072 2.1275 2.81071L10.0946 2.08643L10.8189 10.0536C10.8689 10.6036 11.3553 11.0089 11.9054 10.9589C12.4554 10.9089 12.8607 10.4225 12.8107 9.8725L11.9959 0.909464ZM1.76822 13.6402L11.7682 1.64018L10.2318 0.359816L0.231779 12.3598L1.76822 13.6402Z" fill="white"/>
</svg>
          </button>
        </div>
      </div>
    </div>
  </div>
<!-- Login Modal end -->
<!-- Otp Modal start -->
<div class="modal fade" id="otpModal" role="dialog" style ="z-index:1076;">
    <div class="modal-dialog modal-sm">
      <div class="modal-content" style ="border-radius:10px;">
        <div class="modal-body" style ="display:flex;flex-direction:column;height:250px;border-radius:10px;">
        <div style ="display:flex;flex-direction:row;/*gap: 165px;*/justify-content: space-between;width:100%; "><h4 style ="font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 18px;line-height: 22px;color: #000000;">OTP </h4><button type="button" class="close" data-dismiss="modal" id="otpModalClose">&times;</button></div>
        <div style ="display:flex;flex-direction:row;"><p style="font-family: 'Inter';font-style: normal;font-weight: 400;font-size: 14px;line-height: 17px;color: #000000;opacity: 0.5;">Enter the OTP &nbsp; </p></div>
     <div style ="display:flex;flex-direction:row;">  <p style ="font-family: 'Inter';font-style: normal;font-weight: 400;font-size: 14px;line-height: 17px;color: #000000;opacity: 0.5;" id ="otpno"></p>
       <p style ="font-family: 'Inter';font-style: normal;font-weight: 400;font-size: 14px;line-height: 17px;color: #000000;opacity: 0.5;">&nbsp;sent to your mobile no.</p></div>
              
        <div><p id="minotp"></p></div> 
         <div style =" border-bottom: 2px solid #ccc;width:100%;padding: 10px;"> <input type ="number" placeholder="Enter OTP" style ="border:none;outline:none;font-family: 'Inter';
font-style: normal;font-weight: 400;font-size: 14px;line-height: 17px;color: #000000;opacity: 0.5;" id ="otp" autocomplete="off"></div>
<div style ="display: flex;flex-direction: row;"><a style = "color: #010a12; text-decoration: none;margin-left:100px" id = "resendotp">Resend OTP in &nbsp;</a>
<div id="countdownotp" class="timer"></div>

</div>
</div><!-- modal body -->
        
        <div class="modal-footer" style ="border-top:none;">
          <button type="button" class="btn btn-default" data-dismiss="modal" id="login">Login<svg width="13" height="14" viewBox="0 0 13 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M11.9959 0.909464C11.9459 0.359448 11.4595 -0.0458946 10.9095 0.00410676L1.94643 0.818928C1.39641 0.868929 0.991068 1.35534 1.04107 1.90536C1.09107 2.45537 1.57748 2.86072 2.1275 2.81071L10.0946 2.08643L10.8189 10.0536C10.8689 10.6036 11.3553 11.0089 11.9054 10.9589C12.4554 10.9089 12.8607 10.4225 12.8107 9.8725L11.9959 0.909464ZM1.76822 13.6402L11.7682 1.64018L10.2318 0.359816L0.231779 12.3598L1.76822 13.6402Z" fill="white"/>
</svg>
          </button>
        </div>
        </div>
      </div>
    </div>
 <!--  </div>-->
<!-- OTP Modal End -->
<script type="text/javascript">
var markercarddata;var markersData =[];let map3;   //var marker,png;
var verticalenabledinlocation;
$(document).ready(function() {	
	  function checkForDiv(){
		  var x = $(".dynamic-button").length;
	 if ($(".dynamic-button").length) {
        // console.log("The div exists." +x);
     } else {  
    	// console.log("The div not exists." +x);
    $("#hand").show();  
    
     }
	 }
	  $('.close-button').prop("disabled", true);
		 setInterval(checkForDiv, 1000);
		 
		 function init()
		 {
		 	  map3 = new google.maps.Map(document.getElementById('map2'), {
		 	         center: { lat: 13.529271965260616, lng: 75.36285138756304 },
		 	         zoom:12
		 	     });
		 	  
		 	  
		/* 	 google.maps.event.addListener(map3, 'zoom_changed', function () {
		 	    userZoomLevel = map3.getZoom();
		 	});

		 	google.maps.event.addListener(map3, 'idle', function () {
		 	    userCenter = map3.getCenter();
		 	});*/
		 	
		 	
		 	 google.maps.event.addListener(map3, 'zoom_changed', function () {
		         userZoomLevel = map3.getZoom();
		     });

		     // Track center changes
		     google.maps.event.addListener(map3, 'center_changed', function () {
		         userCenter = map3.getCenter();
		     });

		 }init();

		 if(verticalenabled === "gitagenabled")
		 {
			 verticalenabledinlocation = "gitagenabled";
			 document.getElementById("filter-container").style.display = "none";
			 gitagbutton.classList.remove("roadinactive");
	         gitagbutton.classList.add("roadactive");   
	         globalpng = {
				      url: "/gitagicon3.png", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    }; 	
	         	 
			 }
		 if(verticalenabled === "templeenabled")
		 {
			 verticalenabledinlocation = "templeenabled";
			 document.getElementById("filter-container").style.display = "none";
			 templebutton.classList.remove("roadinactive");
	         templebutton.classList.add("roadactive");
	         globalpng = {
				      url: "/temple.png", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    };
	         
		 }
		 if(verticalenabled === "forestenabled")
		 {
			 verticalenabledinlocation = "forestenabled";
			 document.getElementById("filter-container").style.display = "none";
			 forestbutton.classList.remove("roadinactive");
	         forestbutton.classList.add("roadactive"); 
	         globalpng = {
				      url: "/national-park.png", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    };
	         
		 }
		 if(verticalenabled === "heritageenabled")
		 {
			 verticalenabledinlocation = "heritageenabled";
			 document.getElementById("filter-container").style.display = "none";
			 heritagebutton.classList.remove("roadinactive");
	         heritagebutton.classList.add("roadactive");
	         globalpng = {
				      url: "/hampiheritage4.jpg", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    };
	         
		 }
		 if(verticalenabled === "hospitalenabled")
		 {
			 verticalenabledinlocation = "hospitalenabled";
			 document.getElementById("filter-container").style.display = "none";
			 hospitalbutton.classList.remove("roadinactive");
	         hospitalbutton.classList.add("roadactive"); 
	         globalpng = {
				      url: "/hospital.png", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    };
	         
		 }
		 if(verticalenabled === "busenabled")
		 {
			 verticalenabledinlocation = "busenabled";
			 document.getElementById("filter-container").style.display = "none";
			 busbutton.classList.remove("roadinactive");
	         busbutton.classList.add("roadactive"); 
	         globalpng = {
				      url: "/bus.png", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    };
	         busenabled=1;
	         
		 }
		 if(verticalenabled === "carenabled")
		 {
			 verticalenabledinlocation = "carenabled";
			 document.getElementById("filter-container").style.display = "none";
			 carbutton.classList.remove("roadinactive");
	         carbutton.classList.add("roadactive");   
	         globalpng = {
				      url: "/car.png", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    };
	         carenabled = 1;
		 }
		 if(verticalenabled === "rickshawenabled")
		 {
			 verticalenabledinlocation = "rickshawenabled";
			 document.getElementById("filter-container").style.display = "none";
			 rickshawbutton.classList.remove("roadinactive");
	         rickshawbutton.classList.add("roadactive");   
	         globalpng = {
				      url: "/rickshaw.png", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    };
	         rickshawenabled =1;
		 }
		 if(verticalenabled === "goodsenabled")
		 {
			 verticalenabledinlocation = "goodsenabled";
			 document.getElementById("filter-container").style.display = "none";
			 goodsbutton.classList.remove("roadinactive");
	         goodsbutton.classList.add("roadactive");   
	         globalpng = {
				      url: "/transport.png", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    };
	         goodsenabled =1 ;
		 }
		 
		 if(verticalenabled === "vlogsenabled")
		 {
			 verticalenabledinlocation = "vlogsenabled";
			 document.getElementById("filter-container").style.display = "none";
			 goodsbutton.classList.remove("roadinactive");
	         goodsbutton.classList.add("roadactive");   
	         globalpng = {
				      url: "http://maps.google.com/mapfiles/ms/icons/red-dot.png", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    };
		 }
		 
		 
		 if(verticalenabled === "newsenabled")
		 {
			 verticalenabledinlocation = "newsenabled";
			 document.getElementById("filter-container").style.display = "none";
			 goodsbutton.classList.remove("roadinactive");
	         goodsbutton.classList.add("roadactive");   
	         globalpng = {
				      url: "http://maps.google.com/mapfiles/ms/icons/red-dot.png", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    };
		 }
		 
	/*	 globalpng = {
			      url: "http://maps.google.com/mapfiles/ms/icons/red-dot.png", // relative to your app’s static path
			      scaledSize: new google.maps.Size(20, 20), // adjust as needed
			      anchor: new google.maps.Point(20, 20),
			    };*/
});

//window.onload = init;
//init();
//to show the card on marker click start here

// Hide card if clicked outside
document.addEventListener("click", function(event) {
    var card = document.getElementById("markercard-container"); 
    // If the click is outside the card and the button, hide the card
    if (card && !card.contains(event.target) ) {
        card.style.display = "none";  // Hide the card
    }
});
function showCard(userData)
{
	//  console.log('userData' +JSON.stringify(userData.companyName));
	  document.getElementById("cardtitle").textContent = userData.title;
	  document.getElementById("cardcompanyurl").src = '<c:url value="'+userData.companyLogoUrl+'" />';
	  document.getElementById("cardpublishername").textContent = userData.companyName;
	 // "cardcompanyurl"
	  //document.getElementById("cardpublishername").textContent = userData.companyName;
	 
	 document.getElementById("cardthumbnail").src = '<c:url value="'+userData.thumbnail+'" />';
	var phonebutton = document.getElementById("phone");
	phonebutton.setAttribute("onclick", "phone('"+userData.phno+"')");
		var whatsappbutton = document.getElementById("whatsapp");
		whatsappbutton.setAttribute("onclick", "whatsapp('"+userData.whatsapp+"')");
			var takemetherebutton = document.getElementById("takeme");
			takemetherebutton.setAttribute("onclick", "takeme('"+userData.lat+"','"+userData.lng+"')");
	 const cardContainer = document.getElementById('markercard-container');
	 cardContainer.style.display='block';
	}

function showCardforvehicles(userData)
{
	  // set image
	    document.getElementById("cardthumbnail").src = userData.thumbnail;
console.log('UserData : ' + userData.adsid);
	    // hide left section
	    var left = document.querySelector(".leftcontainer");
	    if(left){
	        left.style.display = "none";
	    }

	    // expand image
	    var imgContainer = document.querySelector(".cardimage-container");
	    if(imgContainer){
	        imgContainer.style.width = "100%";
	        imgContainer.style.height = "160px";
	    }

	    var img = document.getElementById("cardthumbnail");
	    img.style.width = "100%";
	    img.style.height = "100%";
	    img.style.objectFit = "cover";

	    // make card clickable
	    var card = document.getElementById("markercard-container");
	    card.style.cursor = "pointer";
	card.onclick = function () {
		    window.location.href = "/vehicleDetails?id=" + userData.adsid;
		//window.location.href = "/fromvehicle";
		};

	    // show card
	    card.style.display = "block";
	}
//to show the card on marker click end here

    

//to load markers on map start here 
 var markers=[];const circles = []; var locations=[];/*var blueMarker;*/let circle;
 // let bounds = new google.maps.LatLngBounds();
  

  //to LoadMarkers start here
 document.addEventListener("DOMContentLoaded", function() { 
	//console.log(' latitudefromsession' +latitudefromsession);
	 if(verticalenabled === "gitagenabled")
		 {
		 verticalenabledinlocation = "gitagenabled"; 
			 document.getElementById("filter-container").style.display = "none";
			 gitagbutton.classList.remove("roadinactive");
	         gitagbutton.classList.add("roadactive");   
	         globalpng = {
				      url: "/gitagicon3.png", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    }; 	
	         	 
			 }
		 if(verticalenabled === "templeenabled")
		 {
			 verticalenabledinlocation = "templeenabled";
			 document.getElementById("filter-container").style.display = "none";
			 templebutton.classList.remove("roadinactive");
	         templebutton.classList.add("roadactive");
	         globalpng = {
				      url: "/temple.png", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    };
	         
		 }
		 if(verticalenabled === "forestenabled")
		 {
			 verticalenabledinlocation = "forestenabled";
			 document.getElementById("filter-container").style.display = "none";
			 forestbutton.classList.remove("roadinactive");
	         forestbutton.classList.add("roadactive"); 
	         globalpng = {
				      url: "/national-park.png", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    };
	         
		 }
		 if(verticalenabled === "heritageenabled")
		 {
			 verticalenabledinlocation = "heritageenabled";
			 document.getElementById("filter-container").style.display = "none";
			 heritagebutton.classList.remove("roadinactive");
	         heritagebutton.classList.add("roadactive");
	         globalpng = {
				      url: "/hampiheritage4.jpg", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    };
	         
		 }
		 if(verticalenabled === "hospitalenabled")
		 {
			 verticalenabledinlocation = "hospitalenabled";
			 document.getElementById("filter-container").style.display = "none";
			 hospitalbutton.classList.remove("roadinactive");
	         hospitalbutton.classList.add("roadactive"); 
	         globalpng = {
				      url: "/hospital.png", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    };
	         
		 }
		 if(verticalenabled === "busenabled")
		 {
			 verticalenabledinlocation = "busenabled";
			 document.getElementById("filter-container").style.display = "none";
			 busbutton.classList.remove("roadinactive");
	         busbutton.classList.add("roadactive"); 
	         globalpng = {
				      url: "/bus.png", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    };
	         busenabled = 1;
	         
		 }
		 if(verticalenabled === "carenabled")
		 {
			 verticalenabledinlocation = "carenabled";
			 document.getElementById("filter-container").style.display = "none";
			 carbutton.classList.remove("roadinactive");
	         carbutton.classList.add("roadactive");   
	         globalpng = {
				      url: "/car.png", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    };
	         carenabled =1 ;
		 }
		 if(verticalenabled === "rickshawenabled")
		 {
			 verticalenabledinlocation = "rickshawenabled";
			 document.getElementById("filter-container").style.display = "none";
			 rickshawbutton.classList.remove("roadinactive");
	         rickshawbutton.classList.add("roadactive");   
	         globalpng = {
				      url: "/rickshaw.png", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    };
	         
	         rickshawenabled = 1;
		 }
		 if(verticalenabled === "goodsenabled")
		 {
			 verticalenabledinlocation = "goodsenabled";
			 document.getElementById("filter-container").style.display = "none";
			 goodsbutton.classList.remove("roadinactive");
	         goodsbutton.classList.add("roadactive");   
	         globalpng = {
				      url: "/transport.png", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    };
	         
	         goodsenabled = 1;
		 }
		 
			if(vlogsenabled === "vlogsenabled")
			{
				// verticalenabledinlocation = "vlogsenabled";
				 document.getElementById("filter-container").style.display = "none";
			 vlogsbutton.classList.remove("roadinactive");
	         vlogsbutton.classList.add("roadactive");     
			}
		if(vlogsenabled === "newsenabled")
		{
			 document.getElementById("filter-container").style.display = "none";
		 newsbutton.classList.remove("roadinactive");
	     newsbutton.classList.add("roadactive");     
		}
		
		if(verticalenabled === "vlogsenabled")
		 {
			 verticalenabledinlocation = "vlogsenabled";
			 document.getElementById("filter-container").style.display = "none";
			 goodsbutton.classList.remove("roadinactive");
	         goodsbutton.classList.add("roadactive");   
	         globalpng = {
				      url: "http://maps.google.com/mapfiles/ms/icons/red-dot.png", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    };
		 }
		 
		 
		 if(verticalenabled === "newsenabled")
		 {
			 verticalenabledinlocation = "newsenabled";
			 document.getElementById("filter-container").style.display = "none";
			 goodsbutton.classList.remove("roadinactive");
	         goodsbutton.classList.add("roadactive");   
	         globalpng = {
				      url: "http://maps.google.com/mapfiles/ms/icons/red-dot.png", // relative to your app’s static path
				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
				      anchor: new google.maps.Point(20, 20),
				    };
		 }
		 
		 
		/* globalpng = {
			      url: "http://maps.google.com/mapfiles/ms/icons/red-dot.png", // relative to your app’s static path
			      scaledSize: new google.maps.Size(20, 20), // adjust as needed
			      anchor: new google.maps.Point(20, 20),
			    };*/
		 
	function toLoadMarkers(){
		 var lat,lng;
		// console.log('final list of ads : ' + finallistofads);
	//	 return new Promise((resolve, reject) => {
		 if(latitudefromsession==null || finallistofads == null)
			 {
			// console.log('inside if');
			// const position = await new Promise((resolve, reject) => {
			// if (navigator.geolocation) {
		            navigator.geolocation.getCurrentPosition(
		                function(position) {		              
		                    lat = position.coords.latitude;
		                     lng = position.coords.longitude;
		                 /*   const lat = latitudefromsession;
		                    const lng = longitudefromsession;*/
		                    currentlatforblue=lat;currentlngforblue=lng;
		                  	//console.log('to fetch lat lng'+lat +'and: ' +lng);
		                   
		                    toLoadMarkers2(lat,lng);
		                    //console.log('to fetch2'); 
		                },
		                function(error) {		              
		                    var defaultLocation = { coords: { latitude: 13.529271965260616,  longitude: 75.36285138756304 } };
		                 	 lat = defaultLocation.coords.latitude;
		                     lng = defaultLocation.coords.longitude;
		             //       displayCurrentLocation(lat, lng);
		             
		 document.getElementById("currentlocationbutton").disabled = true;
   	     document.getElementById("pinlocationbutton").disabled = false;
	
		                }
		            );
		       // }// if (navigator.geolocation)
			 //});//promise
			 }
			 else {
		        	lat = latitudefromsession;
		        	lng = longitudefromsession;	
		        //	toLoadMarkers2(lat,lng);
		        	toLoadMarkersFromSession();
		        }
		// });//promise
		
	//	 console.log('latlng' +lat +lng);
	}
	function toLoadMarkers2(lat,lng){
		
		console.log('toLoadMarkers2');
		
		 if(currentLocationsetfromsess==true)
		 {
		  document.getElementById("currentlocationbutton").disabled = false;
	   	  document.getElementById("pinlocationbutton").disabled = true;
		 }
	 else
		 {
		  document.getElementById("currentlocationbutton").disabled = false;
		  document.getElementById("pinlocationbutton").disabled = true;
		 }
	//	 displayCurrentLocation(lat, lng);
	 $.ajax({
	        // Our sample url to make request 
	        url:"${pageContext.request.contextPath}/responsivelocations",
	        type: "POST",
	        contentType : 'application/json',// Set content type to JSON
	        dataType : 'json',// Expect a JSON response
	        data:JSON.stringify({lat,lng}), // Convert the JavaScript object to JSON
	        aysnc:false,
	        success: function (data) {	
      
	        	noofresults=data.length;     		   
     			 $('#noofresults').html('Results: '+noofresults) ;
	          const bounds = new google.maps.LatLngBounds();//to create a bounding box that encompasses all the markers.
	//          LatLngBounds is an object that represents a rectangular geographical area defined by a pair of coordinates: southwest and northeast corners.
	          
	          var center;/*const bounds1 = new google.maps.LatLngBounds(); var center1;*/
	       for (var i = 0; i < markers.length; i++) {
		   markers[i].setMap(null); // Remove marker from the map
		   }
	   locations = []; // Clear the array of markers
	   markers=[];
	   circles.forEach(circle => {
	       circle.setMap(null); // Remove circle from the map
	   });
	   circles.length = 0; // Clear the array
	   
	// Remove the previous circle if it exists 
	if (circle) { circle.setMap(null); }
	 //to add blue marker start from here
	// blueMarker.setMap(null);
	 
	//console.log('for Blue : ' +currentlatforblue);
   	 blueMarker = new google.maps.Marker({
	        position: new google.maps.LatLng(currentlatforblue,currentlngforblue),
	        map: map3,
	        icon:{
	           	path: google.maps.SymbolPath.CIRCLE,
	        	fillColor: 'blue',  // Color of the marker
	            fillOpacity: 1,
	            scale: 10,  // Size of the marker
	            strokeColor: 'white',  // Border color of the marker
	            strokeWeight: 1  // Border width
	        }
	      });
   	bounds.extend(blueMarker.position);
 //  	center1 = bounds1.getCenter();
   	
		//   map3.setZoom(12);
  //   map3.panTo(blueMarker.position); 
     //blueMarkers.push(blueMarker);
var text='You are here';
// Create an InfoWindow
infoWindow = new google.maps.InfoWindow({ 	  
//  content: '<div class="custom-info-content"><h3>Custom InfoWindow</h3><p>This is a custom InfoWindow with a specific size.</p></div>',
maxWidth: 200 // Set the maximum width of the InfoWindow 

});	  
  // Add hover event to show InfoWindow 
  google.maps.event.addListener(blueMarker, 'mouseover', function() {
  	infoWindow.setContent(text); 
  	infoWindow.open(map3, blueMarker); 
  	}); 
  // Add mouseout event to close InfoWindow 
  	google.maps.event.addListener(blueMarker, 'mouseout', function() { 
  		infoWindow.close(); 
  		});
  	
  //blue marker tracking start here
	   $.each(data, function (i, myList) {
		  
		     var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
	     	// console.log('phno : ' +phno);
	     	 var email= myList.emailAddress;
	     	 var publisher_name = myList.a.title;
	    // 	 console.log(publisher_name);
	     	 var description = myList.a.description;
	     	 var companyLogoUrl = myList.companies.companyLogoPath;
	     	 var thumbnail = myList.a.thumbnail; var description = myList.a.description;
	     	var companyName='';
	     	if(myList.companies==null || myList.companies==undefined){
		     	companyName=publisher_name;}
		     	else{	     	 companyName= myList.companies.name;}
	   
	
	   	//for map from here
	var zoom_val=0;
	var infowindow = new google.maps.InfoWindow();
	//var marker, i ,png;
	png='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
	//console.log('myList.location.lat: ' +myList.location.lat );
	
	var l = Number(myList.location.lat) + 0.0001;
		const lattt =  Number(l); const longgg= Number(myList.location.lng );
	//	console.log( 'lattt: ' +lattt +'longg: ' +longgg);
	    	//here
	  //  	locations.push([lattt,longgg]);  	
	    	
	    	
const marker = new google.maps.Marker({
	    	     //  position: new google.maps.LatLng(locations[i][0],locations[i][1]),
	    	    //  position: new google.maps.LatLng(locations[j][0], locations[j][1]),
	    	   // position:{ lat: JSON.parse(locations[j][0]), lng:JSON.parse(locations[j][1] )},	    	   
	    	 //  position:{ lat: parseFloat(locations[j][0]), lng:parseFloat(locations[j][1] )},
	    	  position:{ lat:lattt, lng:longgg},
	    	        map: map3,
	    	        icon:globalpng
	    	      });
		         
	  var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
		marker.addListener('click', function() {
		
			setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
			});
		 
	  const position = { lat: lattt, lng: longgg };
		  markers.push(marker);
		  bounds.extend(marker.position);
		  //We then extend the LatLngBounds object with bounds.extend(marker.getPosition()). This will expand the bounds to include the current marker's position.
		  map3.fitBounds(bounds);  ////to center the map where the markers are placed.,to adjust the map’s view to fit all markers.
		 // center = bounds.getCenter();		  
		  //The getCenter() method on the LatLngBounds object will return the center point of the bounds. This point will be the center of the circle we want to draw on the map.
		  //The center is a LatLng object representing a geographical location (latitude and longitude).
	   });///each  
	 
//	if(locations.length>0){
		/*const circle = new google.maps.Circle({
	    map: map3,
	    radius: 2600, // Radius in meters
	    fillColor: '#FFF', // Red fill color
	    fillOpacity: 0.35, // Fill opacity
	    strokeColor: '#F27C0A', // Red stroke color
	    strokeOpacity: 0.8, // Stroke opacity
	    strokeWeight: 2, // Stroke weight
	    center: marker.getPosition() // Center the circle around the marker
	  });      
	    circles.push(circle);*/
	//}//if
	    	//here
	    	// Fit the map to the bounds 
	    	// Get the center of the bounds 
	    	  //drawCircle(bounds, markers);
	//console.log(center);
	let maxDistance = 0; center = bounds.getCenter();//console.log('center is : ' +center);
			      $.each(data, function (i, myList) {
			    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
			    		const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
			    		//console.log('blueMarker.lat, blueMarker.lng : ' +blueMarker.getPosition().lat() +blueMarker.getPosition().lng());
			    		 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
			    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
			    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
			    		
			    		if (distance > maxDistance) { maxDistance = distance; }
			    		//console.log('maxdistance : ' +maxDistance/1000);
			    		//The radius of the circle is set to the maximum distance between the blue marker and any red marker, ensuring the circle covers all the markers.
			      });//2nd each
			     //The circle needs to cover all markers, so the largest distance from the center to any marker determines the radius. This way, the circle will encompass all the markers.
			      // Draw the circle
			      
			  //    $('#radius').empty().append(""+maxDistance/1000);
			/*     circle=    new google.maps.Circle({
			             center: blueMarker.getPosition(),//center,
			             radius: maxDistance, // In meters
			             map: map3,
			             fillColor: '#00000000', // transparent color
				       	    fillOpacity: 0,         // fully transparent
			             strokeColor: "#F27C0A",
			             strokeOpacity: 0.8,
			             strokeWeight: 2
			         });
			     circles.push(circle);*/
		            }//success
		            
	  
	        });//ajax
	  //  console.log(markers);
	 }//function
	 toLoadMarkers();
   
      
	 const markerHighlightAdsId = "<%= request.getParameter("adsId") != null ? request.getParameter("adsId") : "" %>";
	 let highlightCircle = null;
	 var markerMap = {}; // already needed
	 let activeBounceMarker = null;
	// var currentHighlightedMarker = null;
	 async function toLoadMarkersFromSession()    // await
	 //function toLoadMarkersFromSession()
	 {
		 console.log('toLoadMarkersFromSession');
		 if(currentLocationsetfromsess==true)
		 {
			 document.getElementById("currentlocationbutton").disabled = false;
	   	  document.getElementById("pinlocationbutton").disabled = true;
		 }
	 else
		 {
		 document.getElementById("currentlocationbutton").disabled = true;
		  document.getElementById("pinlocationbutton").disabled = false;
		 }
		 
		 const response =  await fetch('<%=request.getContextPath()%>/responsivelocationsfromsession');
	        var data =  await response.json();  // automatically parses JSON
	    	noofresults=data.length;
 		   
 			 $('#noofresults').html('Results: '+noofresults) ;
	        var lat,lng;
	        lat = latitudefromsession;
        	lng = longitudefromsession;
        	//displayCurrentLocation(lat, lng);
	        const bounds = new google.maps.LatLngBounds();//to create a bounding box that encompasses all the markers.
	    	//          LatLngBounds is an object that represents a rectangular geographical area defined by a pair of coordinates: southwest and northeast corners.
	    	          
	    	          var center;/*const bounds1 = new google.maps.LatLngBounds(); var center1;*/
	    	       for (var i = 0; i < markers.length; i++) {
	    		   markers[i].setMap(null); // Remove marker from the map
	    		   }
	    	   locations = []; // Clear the array of markers
	    	   markers=[];
	    	   circles.forEach(circle => {
	    	       circle.setMap(null); // Remove circle from the map
	    	   });
	    	   circles.length = 0; // Clear the array
	    	   
	    	// Remove the previous circle if it exists 
	    	if (circle) { circle.setMap(null); }
	    	 //to add blue marker start from here
	    	// blueMarker.setMap(null);
	    	 
	    	//console.log('for Blue : ' +currentlatforblue);
	       	 blueMarker = new google.maps.Marker({
	    	        position: new google.maps.LatLng(currentlatforblue,currentlngforblue),
	    	        map: map3,
	    	        icon:{
	    	           	path: google.maps.SymbolPath.CIRCLE,
	    	        	fillColor: 'blue',  // Color of the marker
	    	            fillOpacity: 1,
	    	            scale: 10,  // Size of the marker
	    	            strokeColor: 'white',  // Border color of the marker
	    	            strokeWeight: 1  // Border width
	    	        }
	    	      });
	       	bounds.extend(blueMarker.position);
	     //  	center1 = bounds1.getCenter();
	       	
	    		//   map3.setZoom(12);
	      //   map3.panTo(blueMarker.position); 
	         //blueMarkers.push(blueMarker);
	    var text='You are here';
	    // Create an InfoWindow
	    infoWindow = new google.maps.InfoWindow({ 	  
	    //  content: '<div class="custom-info-content"><h3>Custom InfoWindow</h3><p>This is a custom InfoWindow with a specific size.</p></div>',
	    maxWidth: 200 // Set the maximum width of the InfoWindow 

	    });	  
	      // Add hover event to show InfoWindow 
	      google.maps.event.addListener(blueMarker, 'mouseover', function() {
	      	infoWindow.setContent(text); 
	      	infoWindow.open(map3, blueMarker); 
	      	}); 
	      // Add mouseout event to close InfoWindow 
	      	google.maps.event.addListener(blueMarker, 'mouseout', function() { 
	      		infoWindow.close(); 
	      		});
	      	
	      //blue marker tracking start here
	  // store markers by adsid
	    	   $.each(data, function (i, myList) {
	    		  // console.log('adsid: ' +adsid +'**** ' +markerHighlightAdsId);
	    		   var adsid = myList.id;
	    		     var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
	    	     	// console.log('phno : ' +phno);
	    	     	 var email= myList.emailAddress;
	    	     	 var publisher_name = myList.a.title;
	    	    // 	 console.log(publisher_name);
	    	     	 var description = myList.a.description;
	    	     	 var companyLogoUrl = myList.companies.companyLogoPath;
	    	     	 var thumbnail = myList.a.thumbnail; var description = myList.a.description;
	    	     	var companyName='';
	    	     	if(myList.companies==null || myList.companies==undefined){
	    		     	companyName=publisher_name;}
	    		     	else{	     	 companyName= myList.companies.name;}
	    	   
	    	
	    	   	//for map from here
	    	var zoom_val=0;
	    	var infowindow = new google.maps.InfoWindow();
	    	//var marker, i ,png;
	    	png='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
	    	//console.log('myList.location.lat: ' +myList.location.lat );
	    	
	    	var l = Number(myList.location.lat) + 0.0001;
	    		const lattt =  Number(l); const longgg= Number(myList.location.lng );
	    	//	console.log( 'lattt: ' +lattt +'longg: ' +longgg);
	    	    	//here
	    	  //  	locations.push([lattt,longgg]);
	   /* const marker = new google.maps.Marker({
	    	    	     //  position: new google.maps.LatLng(locations[i][0],locations[i][1]),
	    	    	    //  position: new google.maps.LatLng(locations[j][0], locations[j][1]),
	    	    	   // position:{ lat: JSON.parse(locations[j][0]), lng:JSON.parse(locations[j][1] )},	    	   
	    	    	 //  position:{ lat: parseFloat(locations[j][0]), lng:parseFloat(locations[j][1] )},
	    	    	  position:{ lat:lattt, lng:longgg},
	    	    	        map: map3,
	    	    	        icon:globalpng
	    	    	      });
	    		         */
	    		         
	    		         let marker;
	    		      // 🔥 If marker already exists, reuse it
	    		         if (markerMap[adsid]) {
	    		             marker = markerMap[adsid];
	    		         } else {
	    		             // ✅ Create new marker only if not exists
	    		             marker = new google.maps.Marker({
	    		                 position: { lat: lattt, lng: longgg },
	    		                 map: map3,
	    		                 icon: globalpng
	    		             });

	    		             markerMap[adsid] = marker; // store marker
	    		         }
	    		      
	    		         if (["busenabled", "carenabled", "goodsenabled", "rickshawenabled"].includes(verticalenabledinlocation) || busenabled ===1 || carenabled ===1 || rickshawenabled ===1 || goodsenabled ===1)
	    		         {
	    		        	 console.log('in stop bounce');
	    		         var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp,adsid:adsid}
	    		     
	    		         		marker.addListener('click', function() {	
	    		         			setTimeout(() => { showCardforvehicles(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card
	    		         				    		});
	    		         
	    		          // stopBounce(); 
	    		         }
	    		         else
	    		         		{
	    		         var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
	    		        
	    		         	marker.addListener('click', function() {
	    		         //console.log('marker clicked');
	    		         		setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card
	    		         		});
	    		         		}
	    		      
	    	
	    		      
	    	  //var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp,adsid:adsid};
	    /*		marker.addListener('click', function() {
	    			
	    			setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
	    			});*/
	    		 
	    			
	    		/*	marker.addListener('click', function () {

	    			    stopBounce(); // 🔴 ONLY STOP

	    			    setTimeout(() => {
	    			        showCard(markerDetails);
	    			    }, 500);
	    			});*/
	    	  const position = { lat: lattt, lng: longgg };
	    		  markers.push(marker);
	    		  bounds.extend(marker.position);
	    		  //We then extend the LatLngBounds object with bounds.extend(marker.getPosition()). This will expand the bounds to include the current marker's position.
	    		  map3.fitBounds(bounds);  ////to center the map where the markers are placed.,to adjust the map’s view to fit all markers.
	    		 // center = bounds.getCenter();		  
	    		  //The getCenter() method on the LatLngBounds object will return the center point of the bounds. This point will be the center of the circle we want to draw on the map.
	    		  //The center is a LatLng object representing a geographical location (latitude and longitude).
if (markerHighlightAdsId && String(adsid) === String(markerHighlightAdsId)) {

    console.log('Auto highlight marker', adsid);

    map3.setCenter(marker.getPosition());

    // 🔥 START continuous bounce
    startContinuousBounce(marker);

    marker.setZIndex(google.maps.Marker.MAX_ZINDEX + 1);

    marker.setIcon({
        url: globalpng,
        scaledSize: new google.maps.Size(40, 40)
    });

    setTimeout(() => {
        showCardforvehicles(markerDetails);
    }, 800);
}	 
	    		  
	    	   });///each  
	    	 
//	    	if(locations.length>0){
	    		/*const circle = new google.maps.Circle({
	    	    map: map3,
	    	    radius: 2600, // Radius in meters
	    	    fillColor: '#FFF', // Red fill color
	    	    fillOpacity: 0.35, // Fill opacity
	    	    strokeColor: '#F27C0A', // Red stroke color
	    	    strokeOpacity: 0.8, // Stroke opacity
	    	    strokeWeight: 2, // Stroke weight
	    	    center: marker.getPosition() // Center the circle around the marker
	    	  });      
	    	    circles.push(circle);*/
	    	//}//if
	    	    	//here
	    	    	// Fit the map to the bounds 
	    	    	// Get the center of the bounds 
	    	    	  //drawCircle(bounds, markers);
	    	//console.log(center);
	    	let maxDistance = 0; center = bounds.getCenter();//console.log('center is : ' +center);
	    			      $.each(data, function (i, myList) {
	    			    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	    			    		const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	    			    		//console.log('blueMarker.lat, blueMarker.lng : ' +blueMarker.getPosition().lat() +blueMarker.getPosition().lng());
	    			    		 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	    			    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	    			    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	    			    		
	    			    		if (distance > maxDistance) { maxDistance = distance; }
	    			    		//console.log('maxdistance : ' +maxDistance/1000);
	    			    		//The radius of the circle is set to the maximum distance between the blue marker and any red marker, ensuring the circle covers all the markers.
	    			      });//2nd each
	    			     //The circle needs to cover all markers, so the largest distance from the center to any marker determines the radius. This way, the circle will encompass all the markers.
	    			      // Draw the circle
	    			      
	    			  //    $('#radius').empty().append(""+maxDistance/1000);
	    			   /*  circle=    new google.maps.Circle({
	    			             center: blueMarker.getPosition(),//center,
	    			             radius: maxDistance, // In meters
	    			             map: map3,
	    			             fillColor: '#00000000', // transparent color
	    				       	    fillOpacity: 0,         // fully transparent
	    			             strokeColor: "#F27C0A",
	    			             strokeOpacity: 0.8,
	    			             strokeWeight: 2
	    			         });

	    			     circles.push(circle);*/
	 }
	 
	// toLoadMarkersFromSession();
  //   } 
	 if(currentLocationsetfromsess==true)
	 {
		 document.getElementById("currentlocationbutton").disabled = false;
   	     document.getElementById("pinlocationbutton").disabled = true;
	 }
 else
	 {
	 document.getElementById("currentlocationbutton").disabled = true;
	  document.getElementById("pinlocationbutton").disabled = false;
	 }
	 
	 
	 
	 google.maps.event.addListener(map3, 'click', function () {
		    if (currentHighlightedMarker) {
		        currentHighlightedMarker.setAnimation(null);
		        currentHighlightedMarker = null;
		    }
		});
	 
	 function startContinuousBounce(marker) {

		    // Stop previous bounce first
		    if (activeBounceMarker && activeBounceMarker !== marker) {
		        activeBounceMarker.setAnimation(null);
		    }

		    activeBounceMarker = marker;

		    // Continuous bounce (no timeout stop)
		    marker.setAnimation(google.maps.Animation.BOUNCE);
		}
	 function stopBounce() {
		    if (activeBounceMarker) {
		        activeBounceMarker.setAnimation(null);
		        activeBounceMarker = null;
		    }
		}
 });//dom
 //window.onload =toLoadMarkers ;
 //toLoadMarkers();
 

//to load markers on map end here
//to load spotlights start here
/*var users = ${users};
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
 $('.spotlightlist').append(spotlight);*/
 
//to load spotlights end here
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

//bottom sheet end here //to change the button colour in filter start 
var categories=[];
$('.botsheetbutton').click(function(e) {
	 $("#hand").hide();
	 categories.push($(this).val());
	$(this).css({	            	
    	'display': 'flex',
    	'padding':'8px 16px',
    	'justify-content': 'center',
    	'align-items': 'center',
    	'gap': '10px',
    	'border-radius': '100px',
    	'background': 'linear-gradient(90deg, #F27C0A 0%, #F2382C 100%), #FFF',
    	'color': '#FFF',
   		'font-family':' Inter',
    	'font-size':' 10px',
   		'font-style': 'normal',
    	'font-weight': '400',
    	'line-height':' normal',
   		'align-self':'start','border':'none'
    });
	e.stopPropagation();			  
	   const buttonText = $(this).contents().filter(function() {
                           return this.nodeType === 3; // Filter for text nodes only
                           }).text().trim(); // Get the text and trim whitespace
       btnval = $(this).val();
	   const newButton = $('<div class="dynamic-div" draggable="true" ><button class="dynamic-button" value = '+btnval+' >'+buttonText+'<span class="close-button" onclick="closeAlerttop(event)" >&times;</span> </button></div>');
	   $('.top-filters').append(newButton);
	   const button = event.currentTarget; // This refers to the button that was clicked
       button.disabled = true; // Disable the button after click 	   
});

//to change the button colour in filter end 
function closeAlert(event)
{    
     if (event.target.tagName === 'SPAN') {
         // Get the closest button element
         $(this).siblings('.close-button').prop("disabled", true);
         const button = event.target.closest('button');
         
         // Get the button value
         const buttonValue = button.value; // or button.innerText for the button's text
        // console.log(buttonValue); // Outputs: "Button 1", "Button 2", or "Button 3" based on the clicked span
         const index = categories.indexOf(buttonValue);
         if (index > -1) { // only splice array when item is found
        	 categories.splice(index, 1); // 2nd parameter means remove one item only   
           }   
         
         //categories
         
         
         var k=0;
var results =0;
	 $.ajax({
// Our sample url to make request
		        url:"${pageContext.request.contextPath}/categories",
		        type: "POST",
		        contentType : 'application/json',
		        dataType : 'json',
		        data: JSON.stringify(categories), // Convert array to JSON string
		        success: function (data) {
		            let x = JSON.stringify(data);    		
		        	noofresults=data.length;
	        		   $('#noofresults').html('Results: '+noofresults) ;
const bounds = new google.maps.LatLngBounds();var center;
for (var i = 0; i < markers.length; i++) {
		 	   markers[i].setMap(null); // Remove marker from the map
	   		       }
		    locations = []; // Clear the array of markers
		    circles.forEach(circle => {
		        circle.setMap(null); // Remove circle from the map
		    });
		    circles.length = 0; // Clear the array
// Remove the previous circle if it exists
if (circle) { circle.setMap(null); }
		 blueMarker.setMap(null);
		 blueMarker = new google.maps.Marker({
		        position: new google.maps.LatLng(currentlatforblue,currentlngforblue),
		        map: map3,
		        icon:{
		           	path: google.maps.SymbolPath.CIRCLE,
		        	fillColor: 'blue', // Color of the marker
		            fillOpacity: 1,
		            scale: 10, // Size of the marker
		            strokeColor: 'white', // Border color of the marker
		            strokeWeight: 1 // Border width
		        }
		      });
		 bounds.extend(blueMarker.position);
		             $.each(data, function (i, myList) {    		   	     	
var adsid = myList.id;
var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
var email= myList.emailAddress;
var publisher_name = myList.a.title;
// 	 console.log(publisher_name);
var description = myList.a.description;
var dates = myList.dateRange.toDate;
const date = new Date(dates);
var companyName='';
var latitudes=myList.location.lat;
var longitudes = myList.location.lng;
//	console.log('latitudes : ' +latitudes +'longitudes : ' +longitudes);
var companyLogoUrl = myList.companies.companyLogoPath;
var thumbnail = myList.a.thumbnail;
//console.log('companyLogoUrl: ' +companyLogoUrl);
var banner1="nopreview.jpg";
var banner2 = "nopreview.jpg";
		    	    	png='http://maps.google.com/mapfiles/ms/icons/red-dot.png';	    	    		    	
if(myList.companies==null || myList.companies==undefined){//console.log('inside if'+publisher_name);
		    	     	companyName=publisher_name;}
else{	     	 companyName= myList.companies.name;}
//$.each(JSON.parse(data), function (i, myList) {
		    	      	   locations.push(  [myList.location.lat,myList.location.lng]);
//	   console.log('in eror');
//for map from here
var zoom_val=0;
const lattt =  Number(myList.location.lat); const longgg=Number( myList.location.lng) ;
const		 marker = new google.maps.Marker({
//   position: new google.maps.LatLng(myList.location.lat,myList.location.lng),
//  position: new google.maps.LatLng(locations[j][0], locations[j][1]),
// position:{ lat: JSON.parse(locations[j][0]), lng:JSON.parse(locations[j][1] )},
//  position:{ lat: parseFloat(locations[j][0]), lng:parseFloat(locations[j][1] )},
//  position:{ lat:lattt, lng:longgg},
		    	      	    	position:new google.maps.LatLng(lattt, longgg),
		    	      	    	        map: map3,
		    	      	    	        icon:globalpng
		    	      	    	      });
//  	 markers.push(marker);	
var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
		    	   		marker.addListener('click', function() {
//console.log('marker clicked');// Delay of 0.5 seconds before showing the card
		    	   			setTimeout(() => { showCard(markerDetails); }, 500);
		    	   			});//listener
const position = { lat:lattt, lng:longgg};
		    			  markers.push(marker);
		    			  bounds.extend(marker.position);
		    		      map3.fitBounds(bounds);   		    			
	    		    	        	  }); //.each

	        let maxDistance = 0;center = bounds.getCenter();
	    	$.each(data, function (i, myList) {
const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng );
const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2));
var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
if (distance > maxDistance) { maxDistance = distance; }
//	console.log('maxdistance : ' +maxDistance/1000);
	    		    	});//2nd each
// $('#radius').empty().append(""+maxDistance/1000);
/*        circle = new google.maps.Circle({
		         	    map: map3,
		         	    radius: maxDistance, // Radius in meters
		         	   fillColor: '#00000000', // transparent color
				       	    fillOpacity: 0,         // fully transparent
		         	    strokeColor: '#F27C0A', // Red stroke color
		         	    strokeOpacity: 0.8, // Stroke opacity
		         	    strokeWeight: 2, // Stroke weight
		         	    center:blueMarker.getPosition()//center// marker.getPosition() // Center the circle around the marker
		         	  });
		         	    circles.push(circle);*/
		        }//success
		 });//ajax
         
         
         
         button.disabled=false;
     //    console.log('applying style on click of close' +button.value);
         button.style.display= 'flex';
         button.style.padding=' 5px 16px';
         button.style.justifycontent=' center';
         button.style.alignitems= 'center';
         button.style.gap= '0px';
         button.style.borderRadius= '100px';
         button.style.border='1px solid #D6D6D6';
         button.style.background='#FFFFFF';
         button.style.color=' #000';
         button.style.fontFamily='Inter';
         button.style.fontSize='10px';
         button.style.fontStyle='normal';
         button.style.fontWeight='400';
         button.style.lineHeight='normal';
         button.style.cursor='pointer';
         /*to decrement the counter*/
             
         /*top buttons*/
           const buttonsToRemove = document.querySelectorAll('.dynamic-button');

            // Iterate through the buttons and remove those with the specified value
            buttonsToRemove.forEach(button => {
                if (button.value === buttonValue) {
                    button.remove(); // Remove the button from the DOM
                }
            });
                /*top buttons*/
     }//if     
  //   console.log('contents of categories Array: ' + categories);
	}
	
function closeAlerttop(event)
{
     if (event.target.tagName === 'SPAN') {
         // Get the closest button element
        // $(this).siblings('.close-button').prop("disabled", true);
         const button = event.target.closest('button');          
         // Get the button value
         const buttonValue = button.value; // or button.innerText for the button's text
       // console.log('button value in top' +buttonValue); // Outputs: "Button 1", "Button 2", or "Button 3" based on the clicked span
         const index = categories.indexOf(buttonValue);
         if (index > -1) { // only splice array when item is found
        	 categories.splice(index, 1); // 2nd parameter means remove one item only   
           } 
         var k=0;
         var results =0;
         	 $.ajax({
         // Our sample url to make request
         		        url:"${pageContext.request.contextPath}/categories",
         		        type: "POST",
         		        contentType : 'application/json',
         		        dataType : 'json',
         		        data: JSON.stringify(categories), // Convert array to JSON string
         		        success: function (data) {
         		            let x = JSON.stringify(data);    		
         		        	noofresults=data.length;
         	        		   $('#noofresults').html('Results: '+noofresults) ;
         const bounds = new google.maps.LatLngBounds();var center;
         for (var i = 0; i < markers.length; i++) {
         		 	   markers[i].setMap(null); // Remove marker from the map
         	   		       }
         		    locations = []; // Clear the array of markers
         		    circles.forEach(circle => {
         		        circle.setMap(null); // Remove circle from the map
         		    });
         		    circles.length = 0; // Clear the array
         // Remove the previous circle if it exists
         if (circle) { circle.setMap(null); }
         		 blueMarker.setMap(null);
         		 blueMarker = new google.maps.Marker({
         		        position: new google.maps.LatLng(currentlatforblue,currentlngforblue),
         		        map: map3,
         		        icon:{
         		           	path: google.maps.SymbolPath.CIRCLE,
         		        	fillColor: 'blue', // Color of the marker
         		            fillOpacity: 1,
         		            scale: 10, // Size of the marker
         		            strokeColor: 'white', // Border color of the marker
         		            strokeWeight: 1 // Border width
         		        }
         		      });
         		 bounds.extend(blueMarker.position);
         		             $.each(data, function (i, myList) {    		   	     	
         var adsid = myList.id;
         var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
         var email= myList.emailAddress;
         var publisher_name = myList.a.title;
//          	 console.log(publisher_name);
         var description = myList.a.description;
         var dates = myList.dateRange.toDate;
         const date = new Date(dates);
         var companyName='';
         var latitudes=myList.location.lat;
         var longitudes = myList.location.lng;
//         	console.log('latitudes : ' +latitudes +'longitudes : ' +longitudes);
         var companyLogoUrl = myList.companies.companyLogoPath;
         var thumbnail = myList.a.thumbnail;
         //console.log('companyLogoUrl: ' +companyLogoUrl);
         var banner1="nopreview.jpg";
         var banner2 = "nopreview.jpg";
         		    	    	png='http://maps.google.com/mapfiles/ms/icons/red-dot.png';	    	    		    	
         if(myList.companies==null || myList.companies==undefined){//console.log('inside if'+publisher_name);
         		    	     	companyName=publisher_name;}
         else{	     	 companyName= myList.companies.name;}
         //$.each(JSON.parse(data), function (i, myList) {
         		    	      	   locations.push(  [myList.location.lat,myList.location.lng]);
//         	   console.log('in eror');
         //for map from here
         var zoom_val=0;
         const lattt =  Number(myList.location.lat); const longgg=Number( myList.location.lng) ;
         const		 marker = new google.maps.Marker({
         //   position: new google.maps.LatLng(myList.location.lat,myList.location.lng),
         //  position: new google.maps.LatLng(locations[j][0], locations[j][1]),
         // position:{ lat: JSON.parse(locations[j][0]), lng:JSON.parse(locations[j][1] )},
         //  position:{ lat: parseFloat(locations[j][0]), lng:parseFloat(locations[j][1] )},
         //  position:{ lat:lattt, lng:longgg},
         		    	      	    	position:new google.maps.LatLng(lattt, longgg),
         		    	      	    	        map: map3,
         		    	      	    	        icon:globalpng
         		    	      	    	      });
//           	 markers.push(marker);	
         var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
         		    	   		marker.addListener('click', function() {
         //console.log('marker clicked');// Delay of 0.5 seconds before showing the card
         		    	   			setTimeout(() => { showCard(markerDetails); }, 500);
         		    	   			});//listener
         const position = { lat:lattt, lng:longgg};
         		    			  markers.push(marker);
         		    			  bounds.extend(marker.position);
         		    		      map3.fitBounds(bounds);   		    			
         	    		    	        	  }); //.each

         	        let maxDistance = 0;center = bounds.getCenter();
         	    	$.each(data, function (i, myList) {
         const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng );
         const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2));
         var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
         //const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
         const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
         if (distance > maxDistance) { maxDistance = distance; }
//         	console.log('maxdistance : ' +maxDistance/1000);
         	    		    	});//2nd each
         // $('#radius').empty().append(""+maxDistance/1000);
         /*        circle = new google.maps.Circle({
         		         	    map: map3,
         		         	    radius: maxDistance, // Radius in meters
         		         	   fillColor: '#00000000', // transparent color
         				       	    fillOpacity: 0,         // fully transparent
         		         	    strokeColor: '#F27C0A', // Red stroke color
         		         	    strokeOpacity: 0.8, // Stroke opacity
         		         	    strokeWeight: 2, // Stroke weight
         		         	    center:blueMarker.getPosition()//center// marker.getPosition() // Center the circle around the marker
         		         	  });
         		         	    circles.push(circle);*/
         		        }//success
         		 });//ajax
         
         
         
        // console.log('categories array at top : ' +categories);
          //get the button based on the value
       const buttons = document.querySelectorAll('.botsheetbutton');
      for (const buton of buttons) {
      if (buton.value === buttonValue) {
          buton.style.display= 'flex';
          buton.style.padding=' 5px 16px';
          buton.style.justifycontent=' center';
          buton.style.alignitems= 'center';
          buton.style.gap= '0px';
          buton.style.borderRadius= '100px';
          buton.style.border='1px solid #D6D6D6';
          buton.style.background='#FFFFFF';
          buton.style.color=' #000';
          buton.style.fontFamily='Inter';
          buton.style.fontSize='12px';
          buton.style.fontStyle='normal';
          buton.style.fontWeight='400';
          buton.style.lineHeight='normal';
          buton.style.cursor='pointer';
          /*to decrement the counter*/
       //   const parentId = buton.closest('.tabcontent').id; // Get the ID of the nearest parent with class 'tab'
         // console.log('Parent Tab ID:', parentId); // Log the parent ID
          buton.disabled=false;
          //still to disable close
      }           
    }                
         /*top buttons*/
            button.remove();
                /*top buttons*/
     }//if   	
}

//to close bottom on outside touch start here

document.addEventListener("DOMContentLoaded", function() {
	    var openButton = document.getElementById("filterbutton");
	    document.addEventListener("click", function(event) {
	        if (!bottomSheet.contains(event.target) && !openButton.contains(event.target)) {
	            // Only close if the click is outside of the bottom sheet and the open button
	            bottomSheet.classList.remove("show");
	            setTimeout(function() {
	                bottomSheet.style.display = "none";
	            }, 100); // Wait for the animation to finish before hiding
	        }
	    });
});

//to close bottom on outside touch end here
//on click of reset starts here
$( '#reset' ).on( "click", function(e) {
    	//	 console.log('on reset');
    		 //$("#hand").show();
    		   	globalpng ='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
    		  const buttons = document.querySelectorAll('.botsheetbutton');
              buttons.forEach(button => {
            //	  console.log('inside for each');
                  button.style.display = 'flex'; // Reset background color
                  button.style.padding = '5px 16px'; // Reset text color
                  button.style.justifycontent = 'center'; // Reset font size                  
                  button.style.alignitems = 'center'; // Reset background color
                  button.style.gap = '0px'; // Reset text color
                  button.style.borderRadius = '100px'; // Reset font size               
                  button.style.border = '1px solid #D6D6D6'; // Reset background color
                  button.style.background = '#FFFFFF'; // Reset text color
                  button.style.color = '#000';
                  button.style.fontFamily = 'Inter'; // Reset background color
                  button.style.fontSize = '12px'; // Reset text color
                  button.style.fontStyle = 'normal';
                  button.style.fontWeight = '100';
                  button.style.lineHeight = 'normal';
                  button.style.cursor = 'pointer';
                  button.disabled= false;
              });
              
          	$('.close-button').prop("disabled", true);
         
              $.ajax({
  		        // Our sample url to make request 
  		        url:"${pageContext.request.contextPath}/reset",
  		        type: "POST",
  		        contentType : 'application/json',
  		        dataType : 'json',
  		        data: JSON.stringify(categories), // Convert array to JSON string 
  		        success: function (data) {
  		            let x = JSON.stringify(data);
  		            //console.log('in categories success : ' +x);
  		        }
  		        
  		 });
              const b = document.querySelectorAll('.dynamic-button');
              b.forEach(button => button.remove());
              categories=[];
          //    categories=null;
    		 
    	 });
//on click of reset end here 

//on click of apply start here 
$( '#apply' ).on( "click", function(e) {
    		 //console.log('aray of categories : ' +categories);
    		 var k=0;
    		 var results =0;
    		  	globalpng ='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
    		 bottomSheet.classList.remove("show");
	            setTimeout(function() {
	                bottomSheet.style.display = "none";
	            }, 100); // Wait for the animation to finish before hiding
    		 $.ajax({
    		        // Our sample url to make request 
    		        url:"${pageContext.request.contextPath}/categories",
    		        type: "POST",
    		        contentType : 'application/json',
    		        dataType : 'json',
    		        data: JSON.stringify(categories), // Convert array to JSON string 
    		        success: function (data) {
    		            let x = JSON.stringify(data);    		
    		        	noofresults=data.length;
 	        		   $('#noofresults').html('Results: '+noofresults) ;
    		       	 const bounds = new google.maps.LatLngBounds();var center;
    		         for (var i = 0; i < markers.length; i++) {
    		 	   markers[i].setMap(null); // Remove marker from the map
    	   		       }
    		    locations = []; // Clear the array of markers
    		    circles.forEach(circle => {
    		        circle.setMap(null); // Remove circle from the map
    		    });
    		    circles.length = 0; // Clear the array   
  		    
    		 // Remove the previous circle if it exists
    		 if (circle) { circle.setMap(null); }
    		 blueMarker.setMap(null);
    		 blueMarker = new google.maps.Marker({
    		        position: new google.maps.LatLng(currentlatforblue,currentlngforblue),
    		        map: map3,
    		        icon:{
    		           	path: google.maps.SymbolPath.CIRCLE,
    		        	fillColor: 'blue',  // Color of the marker
    		            fillOpacity: 1,
    		            scale: 10,  // Size of the marker
    		            strokeColor: 'white',  // Border color of the marker
    		            strokeWeight: 1  // Border width
    		        }
    		      });
    		 bounds.extend(blueMarker.position);
    		             $.each(data, function (i, myList) {    		   	     	
    		   	     	 	var adsid = myList.id;
	     	 				var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
	         				var email= myList.emailAddress;
    		    	     	 var publisher_name = myList.a.title;
    		    	    // 	 console.log(publisher_name);
    		    	     	 var description = myList.a.description;
    		    	     	 var dates = myList.dateRange.toDate;
    		    	     	const date = new Date(dates);
    		    	    	var companyName='';
    		    	    	var latitudes=myList.location.lat;
    		    	    	var longitudes = myList.location.lng;
    		    	    //	console.log('latitudes : ' +latitudes +'longitudes : ' +longitudes);
    		    	    	var companyLogoUrl = myList.companies.companyLogoPath;
    		    	    	var thumbnail = myList.a.thumbnail;
    		    	    	//console.log('companyLogoUrl: ' +companyLogoUrl);
    		    	    	var banner1="nopreview.jpg";
    		    	    	var banner2 = "nopreview.jpg";
    		    	    	png='http://maps.google.com/mapfiles/ms/icons/red-dot.png';	    	    		    	
    		    	    	
    		    	     	if(myList.companies==null || myList.companies==undefined){//console.log('inside if'+publisher_name);
    		    	     	companyName=publisher_name;}
    		    	     	else{	     	 companyName= myList.companies.name;}
    		    	     	 //$.each(JSON.parse(data), function (i, myList) {
    		    	      	   locations.push(  [myList.location.lat,myList.location.lng]);
    		    	      //	   console.log('in eror');
    		    	      	   	//for map from here
    		    	      	var zoom_val=0;
    		    	      
    		    	      		const lattt =  Number(myList.location.lat); const longgg=Number( myList.location.lng) ;
    		    	      	    const		 marker = new google.maps.Marker({
    		    	      	    	    //   position: new google.maps.LatLng(myList.location.lat,myList.location.lng),
    		    	      	    	    //  position: new google.maps.LatLng(locations[j][0], locations[j][1]),
    		    	      	    	   // position:{ lat: JSON.parse(locations[j][0]), lng:JSON.parse(locations[j][1] )},
    		    	      	    	   
    		    	      	    	 //  position:{ lat: parseFloat(locations[j][0]), lng:parseFloat(locations[j][1] )},
    		    	      	    	//  position:{ lat:lattt, lng:longgg},
    		    	      	    	position:new google.maps.LatLng(lattt, longgg),
    		    	      	    	        map: map3,
    		    	      	    	        icon:globalpng
    		    	      	    	      });
    		    	    //  	 markers.push(marker);	
    		    	      	 var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
    		    	   		marker.addListener('click', function() {
    		    	   			//console.log('marker clicked');// Delay of 0.5 seconds before showing the card
    		    	   			setTimeout(() => { showCard(markerDetails); }, 500);  
    		   		
    		    	   			});//listener
    		    	      	 const position = { lat:lattt, lng:longgg};
    		    			  markers.push(marker);
    		    			  bounds.extend(marker.position);
    		    		      map3.fitBounds(bounds);   		    			    
    		    	     	
    	    		    	        	  }); //.each

    	        let maxDistance = 0;center = bounds.getCenter();
    	    	$.each(data, function (i, myList) {
    	    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
    	    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
    	    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
    				    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
    				    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
    	    		    	if (distance > maxDistance) { maxDistance = distance; }
    	    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
    	    		    	});//2nd each 
    	    		    	
    	    		    	// $('#radius').empty().append(""+maxDistance/1000);
    		    /*        circle = new google.maps.Circle({
    		         	    map: map3,
    		         	    radius: maxDistance, // Radius in meters
    		         	   fillColor: '#00000000', // transparent color
				       	    fillOpacity: 0,         // fully transparent
    		         	    strokeColor: '#F27C0A', // Red stroke color
    		         	    strokeOpacity: 0.8, // Stroke opacity
    		         	    strokeWeight: 2, // Stroke weight
    		         	    center:blueMarker.getPosition()//center// marker.getPosition() // Center the circle around the marker
    		         	  });      
    		         	    circles.push(circle);*/
    		    	        	  
    		        }//success
    		 });//ajax
    		 
    		 
    		 
    		
});//apply
//on click of apply end here 
//dragging listener for spotlight starts here 2 
/*let currentPage = 1;  // Keep track of the current page of items
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
	//console.log('TOUCH');
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

// Initial loading of items*/
//swipe spotlight end here

//on chNGE OF SLIDER VALUE starts here
function sliderOninput()
{
	 var slider = document.getElementById('rangeOutputId');
     var sliderValue = document.getElementById('rangeInputId');
     slider.value = sliderValue.value;
}
  function sliderClick(){
 	   var slider = document.getElementById('rangeOutputId');
        var sliderValue = document.getElementById('rangeInputId');
        slider.value = sliderValue.value;
    //console.log('slider value is : ' +slider.value);
         var lat = currentMarker.getPosition().lat();
         var lng = currentMarker.getPosition().lng();
         globalpng = {
   			  url: imageMap[verticalenabledinlocation] || "http://maps.google.com/mapfiles/ms/icons/red-dot.png",
   			  scaledSize: new google.maps.Size(25, 25), // common size
   			  anchor: new google.maps.Point(12, 12)
   			};
       var s = sliderValue.value;
       var k =0;
  
        $.ajax({
            url: '${pageContext.request.contextPath}/combined',
            type: "POST",
            //contentType: 'application/json',
            data:{slidervalue:s},
            success: function(data) {
            	 const bounds = new google.maps.LatLngBounds();var center;
      	       for (var i = 0; i < markers.length; i++) {
      		   markers[i].setMap(null); // Remove marker from the map
      		   }
      	   locations = []; // Clear the array of markers
      	   markers=[];
      	   circles.forEach(circle => {
      	       circle.setMap(null); // Remove circle from the map
      	   });
      	   circles.length = 0; // Clear the array
       
     /*  var newLocation = {lat,lng}; // 
       map.setCenter(newLocation); 
       map.setZoom(12); */
       
    // Remove the previous circle if it exists
    if (circle) { circle.setMap(null); }
       bounds.extend(blueMarker.position);
       var results=0;
       $.each(JSON.parse(data), function (i, myList) {
    	 	var zoom_val=0;
    	var adsid = myList.id;
    	locations.push([myList.location.lat,myList.location.lng])
			var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
			var email= myList.emailAddress;
     	 var publisher_name = myList.a.title;
    // 	 console.log(publisher_name);
     	 var description = myList.a.description;
     	 var dates = myList.dateRange.toDate;
     	const date = new Date(dates);
    	var companyName='';
    	var latitudes=myList.location.lat;
    	var longitudes = myList.location.lng;
    	var companyLogoUrl = myList.companies.companyLogoPath;
    	var thumbnail = myList.a.thumbnail;png='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
    	if(myList.companies==null || myList.companies==undefined){//console.log('inside if'+publisher_name);
	     	companyName=publisher_name;}
	     	else{	     	 companyName= myList.companies.name;}	               		          
    		const lattt = Number( myList.location.lat); const longgg=Number(myList.location.lng) ;
    	    const		 marker = new google.maps.Marker({
    	    	    //   position: new google.maps.LatLng(myList.location.lat,myList.location.lng),
    	    	    //  position: new google.maps.LatLng(locations[j][0], locations[j][1]),
    	    	   // position:{ lat: JSON.parse(locations[j][0]), lng:JSON.parse(locations[j][1] )},
    	    	   
    	    	 //  position:{ lat: parseFloat(locations[j][0]), lng:parseFloat(locations[j][1] )},
    	    	 // position:{ lat:lattt, lng:longgg},
    	    	position:new google.maps.LatLng(lattt, longgg),
    	    	        map: map3,
    	    	        icon:globalpng
    	    	      });
    	// markers.push(marker);	
    	 var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
 		marker.addListener('click', function() {
 			//console.log('marker clicked');
 			setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
 			});
    	
    	// console.log('locations array : ' +myList.location.lat+','+myList.location.lng);
    	 const position = { lat:lattt, lng:longgg};
		  markers.push(marker);
		  bounds.extend(marker.position);
	 map3.fitBounds(bounds);  
		    //center = bounds.getCenter();
		   
    	   });///each
    		let maxDistance = 0;   center = bounds.getCenter();
    	//	console.log('center is : ' +center);
    	   $.each(JSON.parse(data), function (i, myList) {
	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	    		const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	    		 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
		    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
		    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	    		if (distance > maxDistance) { maxDistance = distance; }
	    	//	console.log('maxdistance : ' +maxDistance/1000);
	      });//2nd each
	      
	    //  $("#radius").innerHTML = "";
	    //  $("#radius").empty().append(" " + maxDistance/1000);
	     
	      // Draw the circle
	     /*  circle=    new google.maps.Circle({
	             center: blueMarker.getPosition(),//center,
	             radius: maxDistance, // In meters
	             map: map3,
	             fillColor: '#00000000', // transparent color
		       	    fillOpacity: 0,         // fully transparent
	             strokeColor: "#F27C0A",
	             strokeOpacity: 0.8,
	             strokeWeight: 2
	         });
	       circles.push(circle);*/
              },
            error: function(xhr, status, error) {
                console.error('Error:', error);
            }
        });

        
     	
     }
  // on change of slider value ends here
//check location for every 30 sec start here
let userZoomLevel = null;
let userCenter = null;
let isFirstLoad = true;


  setInterval(currentLocationsetcheck, 30000); let trackingIntervalId = null;let selectedMode = null;
  var locationset =0;
  var currentLocationSetting = <%= currentLocationSetting %>;var lastlat,lastlng;
  function  currentLocationsetcheck(){
  	   locationset++;  
  	 //  console.log('currentLocationset: ' +currentLocationSetting);
  	 currentLocationset=currentLocationSetting;
  	 
  	 if (trackingIntervalId !== null) {
         console.log("Tracking already started.");
         return; // prevent multiple intervals
       }
   	//if((currentLocationset===true || currentLocationsetfromsess === true) && verticalenabledinlocation === "")  // Set variable to true after 2 seconds   
   		if (
    (currentLocationset || currentLocationsetfromsess) ||
    ["busenabled", "carenabled", "goodsenabled", "rickshawenabled"]
        .includes(verticalenabledinlocation) || busenabled ===1 || carenabled ===1 || rickshawenabled ===1 || goodsenabled ===1)

   			
    {      	       
    console.log('Every 30 sec: '+currentLocationset +','+verticalenabledinlocation+ busenabled + carenabled + rickshawenabled + goodsenabled  );
     getLocationContinuous();
 //    trackingIntervalId = setInterval(getLocationContinuous, 30000);
     
   /*  trackingIntervalId = setInterval(() => {
         getLocationContinuous();
       }, 30000);*/
     }        
    /* else
   	  {
   	      	 // $("#locationflag").html('Current Location Not Set : ' +locationset );
   	  }*/
  }
  function getLocationContinuous()
  {
  	if (navigator.geolocation) {
          navigator.geolocation.getCurrentPosition(sendLocationContinuous);
      } 	   
      else {
             console.error("Geolocation is not supported by this browser.in get location else ");
      }
  }

  function sendLocationContinuous(position) {
  	   	   const lat  = position.coords.latitude;
  	       const lng = position.coords.longitude;	       
  	      // const lat = position.lat;
  	      // const lng = position.lng;		   
  	    //  var dist=getDistanceFromLatLonInKm(lastlat,lastlng,lat,lng).toFixed(1);  	  
  	  	 var detectLocation = { coords: {latitude: position.coords.latitude, longitude: position.coords.longitude} };
  	     // if(dist>0.2)
  	    	  {	    	  
  	    	//  var detectLocation = { coords: {  latitude: 13.529271965260616,  longitude: 75.36285138756304 } };
  	    	//updateMarkerPosition(position);
  	    	 sendLocationDetect(detectLocation);
  	    	 // sendLocation(detectLocation);
  	    	 
  	    	  }
  	/*      if(lastlat == lat && lastlng == lng)
  	    	  {
  	    	  $("#latlng").html('Lat Long Not Changed );
  	    	  }*/
  }
  function sendLocationDetect(position)
  {

  	   var lat = position.coords.latitude;
  	   var lng = position.coords.longitude;
  	   var k = 0;     var results =0;
  	 globalpng = {
			  url: imageMap[verticalenabledinlocation] || "http://maps.google.com/mapfiles/ms/icons/red-dot.png",
			  scaledSize: new google.maps.Size(25, 25), // common size
			  anchor: new google.maps.Point(12, 12)
			};
  	////  	globalpng ='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
  	  let modeParam = selectedMode ?? "";
    $.ajax({
        // Our sample url to make request 
        url:"${pageContext.request.contextPath}/currentlocation?mode="+modeParam,
        type: "POST",
        contentType : 'application/json',
        dataType : 'json',
        data:JSON.stringify({lat,lng}), 
        success: function (data) {
           
              currentlatforblue=lat;currentlngforblue=lng;
              const bounds = new google.maps.LatLngBounds(); var center;
          for (var i = 0; i < markers.length; i++) {
  	   markers[i].setMap(null); // Remove marker from the map
      }
   locations = []; // Clear the array of markers
   circles.forEach(circle => {
       circle.setMap(null); // Remove circle from the map
   });
   circles.length = 0; // Clear the array
   
  
   blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
     bounds.extend(blueMarker.position);
     const startTime = performance.now();
     requestAnimationFrame(() => {
         updateMapMarkers(data);
     });
    
     const endTime = performance.now();
     const diffTime = endTime - startTime;
 //    console.log("Time taken: " + diffTime.toFixed(3) + " ms");
       
        },
        // Error handling 
        error: function (error) {
            console.log(`Error ${error}`);
        }
    });  	   
  }
  
  function updateMapMarkers(data) {

	    const bounds = new google.maps.LatLngBounds();

	    // Clear old markers
	    markers.forEach(m => m.setMap(null));
	    markers.length = 0;

	    // Clear circles
	    circles.forEach(c => c.setMap(null));
	    circles.length = 0;

	    // Include blue marker in bounds
	    bounds.extend(blueMarker.getPosition());

	    $.each(data, function (i, myList) {

	        const lattt = parseFloat(myList.location.lat);
	        const longgg = parseFloat(myList.location.lng);
var adsid = myList.id;
	        const marker = new google.maps.Marker({
	            position: { lat: lattt, lng: longgg },
	            map: map3,
	            icon: globalpng
	        });

	        markers.push(marker);
	        if (
	        		["busenabled", "carenabled", "goodsenabled", "rickshawenabled"]
	        		.includes(verticalenabledinlocation) || busenabled ===1 || carenabled ===1 || rickshawenabled ===1 || goodsenabled ===1)
	        		{
	        	const markerDetails = {
	    	            lat: lattt,
	    	            lng: longgg,
	    	            title: myList.a.title,
	    	            email: myList.emailAddress,
	    	            phno: myList.phoneNumber,
	    	            description: myList.a.description,
	    	            companyName: myList.companies?.name || myList.a.title,
	    	            companyLogoUrl: myList.companies?.companyLogoPath || "",
	    	            thumbnail: myList.a.thumbnail,
	    	            whatsapp: myList.whatsappNumber,adsid:adsid
	    	        };
	        	
	        	marker.addListener('click', function() {	
	        		setTimeout(() => { showCardforvehicles(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card
	        			    		});
	        		}
	        else{
	        const markerDetails = {
	            lat: lattt,
	            lng: longgg,
	            title: myList.a.title,
	            email: myList.emailAddress,
	            phno: myList.phoneNumber,
	            description: myList.a.description,
	            companyName: myList.companies?.name || myList.a.title,
	            companyLogoUrl: myList.companies?.companyLogoPath || "",
	            thumbnail: myList.a.thumbnail,
	            whatsapp: myList.whatsappNumber
	        };

	        marker.addListener("click", () => {
	            setTimeout(() => showCard(markerDetails), 300);
	        });
	        }
	        bounds.extend(marker.getPosition());
	    });

	    // ✅ Fit bounds ONCE
	    if (isFirstLoad) {
	        map3.fitBounds(bounds);
	        isFirstLoad = false;
	    } else {
	        if (userCenter) map3.setCenter(userCenter);
	        if (userZoomLevel !== null) map3.setZoom(userZoomLevel);
	    }
	}


  function getDistanceFromLatLonInKm(lat1,lon1,lat2,lon2) {
//  	console.log('inside distance calculator: '+lat2+'Longi: '+lon2);
  		  var R = 6371; // Radius of the earth in km
  		  var dLat = deg2rad(lat2-lat1);  // deg2rad below
  		  var dLon = deg2rad(lon2-lon1); 
  		  var a = Math.sin(dLat/2)*Math.sin(dLat/2)+Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.sin(dLon/2) * Math.sin(dLon/2); 
  		  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
  		  var d = R * c; // Distance in km
  		  return d;
  		}

  		function deg2rad(deg) {
  		  return deg * (Math.PI/180)
  		}


  //check location for every 30 sec end here
 mob="";
function takeme(lats,lngs)
{
	 event.stopPropagation();
	//console.log(takemelat+'current loc :'+takemelng);
	var takemelatlocal ;
	var takemelnglocal ;	
	$.ajax({
        url: '${pageContext.request.contextPath}/getSessionVariableLocation',
        method: 'GET',
        async:false,
        success: function(data) {
          //  alert(data); // Outputs the session variable value
        //  console.log('data : ' +data);
        	takemelatlocal = data.lat;
        	takemelnglocal = data.lng;
        	//console.log('takemelatlocal: ' +takemelatlocal);
        },
        error: function(xhr, status, error) {
            console.error("Error fetching session variable: ", error);
        }
    });
	const originLat = takemelatlocal; // 
    const originLng = takemelnglocal; // 
    const destinationLat = lats; 
    const destinationLng = lngs; 
    var mapsUrl = 'https://www.google.com/maps/dir/?api=1&origin='+originLat+','+originLng+'&destination='+destinationLat+','+destinationLng+'&travelmode=driving'; 
    var appUrl = 'geo:' + originLat + ',' + originLng + '?q=' + destinationLat + ',' + destinationLng;
    window.location.href = appUrl; // Fallback to the web URL in case the app is not installed 
    setTimeout(() => { window.location.href = mapsUrl; }, 500);
}

var phoneorwhatsapp=0;var telphno;
function whatsapp(phno)
{
//	console.log('phno from whats app : ' +phno);
	 phoneorwhatsapp=2;telphno= phno;
    event.stopPropagation(); 
    $.ajax({
        url: '${pageContext.request.contextPath}/getSessionVariable',
        method: 'GET',
        async:false,
        success: function(data) {
         //   alert(data); // Outputs the session variable value
        // console.log('in success');
         mob=data;
     
    //	 getsessionvalue(mob);
     
        },
        error: function(xhr, status, error) {
           // console.error("Error fetching session variable: ", error);
        }
    });
if(mob=="")
	{
	//$('#loginModal').modal('show');
	$('#loginModal').modal('show');
	}
else{						
	 var whatsappUrl = "https://api.whatsapp.com/send?phone=" + phno;
     //window.open(whatsappUrl, '_blank');
   	 	window.location.href = whatsappUrl;
            	  }
           
}

function phone(phno)
{

    event.stopPropagation(); phoneorwhatsapp=1; 
    telphno =phno;
	$.ajax({
        url: '${pageContext.request.contextPath}/getSessionVariable',
        method: 'GET',
        async:false,
        success: function(data) {
         //   alert(data); // Outputs the session variable value
        // console.log('in success');
         mob=data;
    //	 getsessionvalue(mob);
        },
        error: function(xhr, status, error) {
           // console.error("Error fetching session variable: ", error);
        }
    });
	if(mob=="")
		{
	//console.log('value of mob: ' +mob);
		$('#loginModal').modal('show');
		}
	else
		{
	  /*  const div = document.getElementById('callme');
	    div.textContent = phno;
		$('#showphno').modal('show');	*/
		window.location.href = "tel:" + phno;
		}			
}	

$('#sendotp').click(function()
		{	
		var mobilenumber = $('#mobilenumber').val();
		$.post("${pageContext.request.contextPath}/sendOtp.htm", {
			
			mobilenumber : mobilenumber,	
		}, function(data) {
		}).done(function(data) {

		 $('#loginModal').modal('hide');
		$('#otpModal').modal('show');
		const minotp=document.getElementById('minotp');
		minotp.innerHTML = mobilenumber;
		const myDiv = document.getElementById('otpno');
		 myDiv.innerHTML = data;

		let countdown;
		const timerDisplay = document.getElementById('countdownotp');
		const resendBtn = document.getElementById('resendotp');

		//function startCountdown(duration) {
		let timeRemaining = 20;

		countdown = setInterval(() => {
		const minutes = Math.floor(timeRemaining / 60);
		const seconds = timeRemaining % 60;
		//console.log('in timer : ' +seconds);
		timerDisplay.textContent ='00:'+seconds;

		if (timeRemaining <= 0) {
		clearInterval(countdown);
//		     timerDisplay.textContent = "OTP expired!";
		//resendBtn.style.display = 'block'; // Show the resend button
		}

		timeRemaining--;
		}, 1000);
		//}
		}).fail(function(xhr, textStatus, errorThrown) {

		})

				});//#sendOTP click
				
				$('#login').click(function()
						{	
					const minotp=document.getElementById('minotp');		
							var mobilenumber = minotp.innerHTML;										
							const myDiv = document.getElementById('otp');
							var otp =  $('#otp').val() ;
							//console.log('login click' +otp +' and ' +mobilenumber);
							 $.post("${pageContext.request.contextPath}/verifyOtp.htm", {		
									mobilenumber : mobilenumber,	
									otp:otp,
									
							}, function(data) {
							}).done(function(data) {
								
							if(data.status == "Success"){
								$('#footerprofilepic').attr("src", data.profileImagePath);
							//console.log('data success or failure : '+data);
								$('#otpModal').modal('hide');
								if( phoneorwhatsapp=1)
									{
									//window.location.href = "tel:" + mobilenumber;
									window.location.href = "tel:" +telphno;
									}
								else if( phoneorwhatsapp=2)
									{
									// var whatsappUrl = "https://api.whatsapp.com/send?phone=" + mobilenumber;
									 var whatsappUrl = "https://api.whatsapp.com/send?phone=" +telphno;
									 
						             window.location.href = whatsappUrl;	
									
									}
							}
							}).fail(function(xhr, textStatus, errorThrown) {
								
							})
							
						});//login click

						var span = document.getElementById("loginModalClose");
						span.onclick = function() {
							//modal.style.display = "none";
							console.log('span');
							$('#loginModal').modal('hide');
							}
						
						var cl = document.getElementById("otpModalClose");
						cl.onclick = function() { 	
							console.log('span');
						$('#otpModal').modal('hide');
							}
						

var currentradiusfromsession = <%= session.getAttribute("slider") == null ? "null" : session.getAttribute("slider") %>;
if(currentradiusfromsession != null){
console.log('currentradiusfromsession if: ' +currentradiusfromsession);	
document.getElementById("radius").value = currentradiusfromsession;	
}
else
{
	document.getElementById("radius").value = 2.0;
}	



document.getElementById("gobutton").addEventListener("click", function() {
	
	  const inputRadius1 = document.getElementById("radius");	  
	  const inputRadius = parseFloat(inputRadius1.value);
	//  console.log('inputRadius: ' +inputRadius);
	globalpng = {
    			  url: imageMap[verticalenabledinlocation] || "http://maps.google.com/mapfiles/ms/icons/red-dot.png",
    			  scaledSize: new google.maps.Size(25, 25), // common size
    			  anchor: new google.maps.Point(12, 12)
    			};
	  var k=0;
	  $.ajax({
        url: '${pageContext.request.contextPath}/combined',
        type: "POST",
        //contentType: 'application/json',
        data:{slidervalue:inputRadius},
        success: function(data) {      	  
        dataparse = JSON.parse(data);
         	noofresults=dataparse.length;
	    	   //	console.log('No of Results: ' +noofresults);
	    		 $('#noofresults').html('Results: '+noofresults) ;

    	 const bounds = new google.maps.LatLngBounds();var center;
	       for (var i = 0; i < markers.length; i++) {
		   markers[i].setMap(null); // Remove marker from the map
		   }
	   locations = []; // Clear the array of markers
	   markers=[];
	   circles.forEach(circle => {
	       circle.setMap(null); // Remove circle from the map
	   });
	   circles.length = 0; // Clear the array
 
/*  var newLocation = {lat,lng}; // 
 map.setCenter(newLocation); 
 map.setZoom(12); */
 
// Remove the previous circle if it exists
if (circle) { circle.setMap(null); }
 bounds.extend(blueMarker.position);
 var results=0;
 $.each(JSON.parse(data), function (i, myList) {
	 	var zoom_val=0;
	var adsid = myList.id;
	locations.push([myList.location.lat,myList.location.lng])
		var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
		var email= myList.emailAddress;
	 var publisher_name = myList.a.title;
// 	 console.log(publisher_name);
	 var description = myList.a.description;
	 var dates = myList.dateRange.toDate;
	const date = new Date(dates);
	var companyName='';
	var latitudes=myList.location.lat;
	var longitudes = myList.location.lng;
	var companyLogoUrl = myList.companies.companyLogoPath;
	var thumbnail = myList.a.thumbnail;png='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
	if(myList.companies==null || myList.companies==undefined){//console.log('inside if'+publisher_name);
   	companyName=publisher_name;}
   	else{	     	 companyName= myList.companies.name;}	               		          
		const lattt = Number( myList.location.lat); const longgg=Number(myList.location.lng) ;
	    const		 marker = new google.maps.Marker({
	    	    //   position: new google.maps.LatLng(myList.location.lat,myList.location.lng),
	    	    //  position: new google.maps.LatLng(locations[j][0], locations[j][1]),
	    	   // position:{ lat: JSON.parse(locations[j][0]), lng:JSON.parse(locations[j][1] )},
	    	   
	    	 //  position:{ lat: parseFloat(locations[j][0]), lng:parseFloat(locations[j][1] )},
	    	 // position:{ lat:lattt, lng:longgg},
	    	position:new google.maps.LatLng(lattt, longgg),
	    	        map: map3,
	    	        icon:globalpng
	    	      });
	// markers.push(marker);	
	/* var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
	marker.addListener('click', function() {
		
		setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
		});*/
	
		if (["busenabled", "carenabled", "goodsenabled", "rickshawenabled"].includes(verticalenabledinlocation) || busenabled ===1 || carenabled ===1 || rickshawenabled ===1 || goodsenabled ===1)
		{
		var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp,adsid:adsid}
				marker.addListener('click', function() {	
					setTimeout(() => { showCardforvehicles(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card
						    		});
		}
		else
				{
		var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
			marker.addListener('click', function() {
		//console.log('marker clicked');
				setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card
				});
				}
	// console.log('locations array : ' +myList.location.lat+','+myList.location.lng);
	 const position = { lat:lattt, lng:longgg};
	  markers.push(marker);
	  bounds.extend(marker.position);
map3.fitBounds(bounds);  
	    //center = bounds.getCenter();
	   
	   });///each
		let maxDistance = 0;   center = bounds.getCenter();
	//	console.log('center is : ' +center);
	   $.each(JSON.parse(data), function (i, myList) {
  		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
  		const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
  		 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
  		if (distance > maxDistance) { maxDistance = distance; }
  	//	console.log('maxdistance : ' +maxDistance/1000);
    });//2nd each
    
  //  $("#radius").innerHTML = "";
  //  $("#radius").empty().append(" " + maxDistance/1000);
   
    // Draw the circle
    /* circle=    new google.maps.Circle({
           center: blueMarker.getPosition(),//center,
           radius: maxDistance, // In meters
           map: map3,
           fillColor: '#00000000', // transparent color
      	    fillOpacity: 0,         // fully transparent
           strokeColor: "#F27C0A",
           strokeOpacity: 0.8,
           strokeWeight: 2
       });
	 
     circles.push(circle);*/
        }
	  });
});
						
</script>
<jsp:include page="responsivefooter.jsp" /> 
</body>
</html>