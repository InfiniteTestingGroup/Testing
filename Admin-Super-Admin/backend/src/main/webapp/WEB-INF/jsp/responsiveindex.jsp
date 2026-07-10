<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="org.jackfruit.keliri.model.ad_campaigns" %>
    <%@ page import="java.util.List" %>
    <%@ page import="com.google.gson.Gson" %>
     <%@ taglib prefix="form"  uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <jsp:include page="responsiveheader.jsp" />
    <%
    // Set a session variable (this is usually done before)
 String latitude= (String)   session.getAttribute("latitude");
String longitude =(String)session.getAttribute("longitude");
List<ad_campaigns> finallist  =(List<ad_campaigns>)session.getAttribute("FinalListOfAds");
Gson gson = new Gson();
String finallistofads1 = gson.toJson(finallist);
String verticalenabledfromsession = (String) session.getAttribute("verticalenabled");
Boolean currentLocationsetfromsession = (Boolean) session.getAttribute("currentLocationset");
String vlogsenabledfromsession = (String)session.getAttribute("vlogsenabled");

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!--<meta content="width=device-width, initial-scale=1.0" name="viewport" />-->
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
     <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
 
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
 <!--   <script src="https://maps.googleapis.com/maps/api/js?key=${googleMapsApiKey}"></script> -->
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=${googleMapsApiKey}" async defer></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js" type="text/javascript"></script>
<!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"> -->

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

<link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap" rel="stylesheet">
  <script src="https://www.youtube.com/iframe_api"></script>
  
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
.modal { overflow: auto !important; } 
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
padding: 1px 12px;
gap: 10px;
/*width: 155px;*/
height: 25px;
background: #F4F4F4;
border-radius: 5px;
flex: none;
order: 0;
/*flex-grow: 1;*/
border: 1px solid #000000;
 }  
 
 #apply
 {
box-sizing: border-box;
display: flex;
flex-direction: row;
justify-content: center;
align-items: center;
padding: 1px 12px;
gap: 10px;
/*width: 155px;*/
height: 25px;
border: 1px solid #000000;
border-radius: 5px;
flex: none;
order: 1;
flex-grow: 1; background:white;
 }
 .spotlightimg
{
border-radius: 50%;
animation: blink-shadow 1s infinite;
}
 .sp
 {
 width: 100%;/*display:flex;*/
  /*  max-width: 500px;*/
    overflow: hidden;
 /*   position: relative;*/height:150px;padding:10px;
    
   /* border: 2px solid #ddd;*/
    /*border-radius: 10px;*/
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
height: 107px;
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
.panel-default
{
/*display: flex;
flex-direction: column;
justify-content: center;
align-items: flex-start;
/*padding: 15px;*/
width: 100%;
/*height: 460px;*/
background: #FFF;
border-radius: 20px;
flex: none;
order: 0;
align-self: stretch;
flex-grow: 0; z-index: 1; /*margin-left:17px;*/
}
.panel-heading
{
display: flex;
flex-direction: row;
align-items: center;
padding: 16px 14px;
gap: 10px;
width: 100%;
height: 72px;
background: #FFF;
box-shadow: 0px 4px 4px rgba(0, 0, 0, 0.05);
flex: none;
order: 0;
align-self: stretch;
flex-grow: 0;
background-color: white !important;border-top-left-radius: 20px !important;border-top-right-radius: 20px !important;
}
.panel
{
border-radius:20px !important;
}
.panel-footer
{
display: flex; flex-direction: row; align-items: center; padding: 25px 15px !important; gap: 25px;  width: 100%;
height: 34px;  flex: none; order: 2; align-self: stretch;flex-grow: 0; background-color:#FFF !important;border-top:none !important;
border-bottom-left-radius: 20px !important;border-bottom-right-radius: 20px !important;
}
#takeme
{
display: flex;
flex-direction: row;
align-items: center;
padding: 5px 14px;
gap: 5px;
isolation: isolate;
width: 152px;
height: 34px;
background: #F27C0A;
border-radius: 10px;
flex: none;
order: 0;
flex-grow: 0;border:none;outline:none;font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #FFFFFF;
}
.fade.in 
{
    opacity: 1;
    background: initial;
}

/*.modal-backdrop {
  display: none;  /* Hide the backdrop entirely */
/*}*/
/*.modal-dialog {
  display: flex;
  justify-content: center;  /* Horizontally centers the modal */
/*  align-items: center;  /* Vertically centers the modal */
/*  min-height: 100vh;  /* Ensures the modal takes at least the full height of the viewport */
/*  margin: 0;  /* Remove any default margin */
/*  position: relative;  /* Allows precise positioning */
/*  top: 50%;  /* Position the modal in the center vertically */
 /* left: 50%;  /* Position the modal in the center horizontally */
 /* transform: translate(-50%, -50%);  /* Offsets the modal by half its own width and height */
/*}*/

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

@keyframes blink-shadow { 0% { filter: drop-shadow(3px 3px 3px #F27C0A);  } 50% { filter: none; /* No drop-shadow */ } 100% { filter: drop-shadow(3px 3px 3px #F27C0A); /* Back to initial drop-shadow */ } }

.carousel-control.left,
.carousel-control.right {
  background: transparent;
}

#addetailmodaltakeme
{
display: flex;
flex-direction: row;
align-items: center;
padding: 5px 14px;
gap: 5px;
isolation: isolate;
width: 152px;
height: 34px;
background: #F27C0A;
border-radius: 10px;
flex: none;
order: 0;
flex-grow: 0;border:none;outline:none;font-family: 'Inter';font-style: normal;font-weight: 700;
font-size: 12px;line-height: 15px;color: #FFFFFF;
}

/* Body that prevents scrolling */
body.no-scroll {
  overflow: hidden;
}

#locationvendor
{
display: flex;
flex-direction: row;
justify-content: center;
align-items: center;
/*padding: 10px 40px;
gap: 10px;*/
/*border-radius: 0px 5px 5px 0px;*/
flex: none;
order: 1;
flex-grow: 1;color:black;outline:none;border-color:black;
}
#adsvendor
{
display: flex;
flex-direction: row;
justify-content: center;
align-items: center;
/*padding: 10px 40px;
gap: 10px;*/
/*border-radius: 0px 5px 5px 0px;color:black;*/
flex: none;
order: 1;
flex-grow: 1;outline:none;border-color:black;
}

.btn-group .btn.active { /*background: linear-gradient(90deg, #F27C0A 0%, #F2382C 100%), #FFFFFF; /* Color of the active button */
background: linear-gradient(90deg, #F27C0A 0%, #F2382C 100%), #FFFFFF; /* Highlight color for active button */
color: white;
}
 
 .givendorlist
 {
 display: flex;
 flex-direction: row;  
 padding: 10px;gap:10px;
 }
 
 .markercard-container
 {display:none;}
 
 .go-button {
      width: 25px;
      height: 25px;
      border-radius: 50%;
      background-color: #F27C0A; /* Green */
      border: none;
      color: white;
      font-size: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      box-shadow: 0 4px 6px rgba(0,0,0,0.1);
      transition: background-color 0.3s ease;
    }
   .ad-video {
    display: block !important;
    visibility: visible !important;
} 
   .filterbuttons
   {
   /*style ="display: flex;flex-direction: row;align-items: flex-start;padding: 0px;gap: 10px;height: 37px;flex: none;order: 3;align-self: stretch;flex-grow: 0;z-index: 3;justify-content:flex-end;padding-top: 8px;"*/
    height: 63px;              /* fixed height ensures visibility */
    flex-shrink: 0;
    background: #fff;
/*    border-top: 1px solid #ddd;*/
    display: flex;
/*    align-items: center;*/
    justify-content: flex-end;
    padding: 0 14px;
   } 
   
.bottom-sheet{
    position: fixed;
    bottom: -100%;
    left: 0;
    right: 0;
    height: 50vh;
    background: #fff;
    border-radius: 16px 16px 0 0;
    transition: bottom 0.3s ease;
    display: flex;
    flex-direction: column;
    z-index: 9999;
}

.bottom-sheet.active{
    bottom: 0;
}

/* Sheet content */
.sheet-content{
    display: flex;
    flex-direction: column;
    height: 100%;
}
/* Filter header (Filters + Done) */
.filternsearch{
    flex-shrink: 0;
}

.filters-container
{
/*box-sizing: border-box;
display: flex;
flex-direction: column;
align-items: flex-start;
padding: 14px;
gap: 10px;
isolation: isolate;
width: 100%;
height: 205px;
overflow-y: scroll;
border: 1px solid #E5E5E5;
border-radius: 10px;
flex: none;
order: 1;
flex-grow: 1;*/

        flex: 1;
    overflow-y: auto;
    padding: 14px;
    display: flex;
    flex-direction: column;
    gap: 10px;
    
    border: 1px solid #E5E5E5;
border-radius: 10px;
}
</style>
</head>
<body>
<div class=filter-container id = "filter-container">
<button  id = "filterbutton" data-toggle="bottom-sheet" data-target="#bottom-sheet" class="show-modal"><i class="fa fa-sliders"></i></button>
<div class="top-filters" style ="display: flex;flex-direction: row;align-items: center;gap: 10px;">
<div id ="hand"><i class="fa fa-hand-o-left" style = "color:#F27C0A;font-size: 20px;"></i><h5 >Click here for categories </h5></div></div>
</div><!-- filter container -->

<!-- spolight section start here -->
 
<div class="ads-container" style ="display: flex;flex-direction: column;gap: 20px;background: #f1f1f1;height:100%;">
<!-- <div class="spotlightlist" id ="spotlightlist" ></div>-->
 <!-- <div class="test" style ="display:flex;flex-direction:row;gap: 60px;margin-left: 10px;"><div id ="itr"></div><div id ="dis"></div>-->
 <div style = "display:flex;flex-direction:row;gap:2px;align-items:center;">
 <div id="noofresults" style ="/*margin-left: 250px;*/font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 13px;line-height: 22px;color: #000000;display: flex;    flex-direction: row;    justify-content: flex-end;    margin-right: 25px;padding: 10px;"></div><!-- </div>-->
 <div style ="display: flex;    flex-direction: row;    gap: 10px;align-items: center; font-family: 'Inter';    font-style: normal;    font-weight: 700;    font-size: 13px;    line-height: 22px;    color: #000000;">Current Radius in KM : <input type="text" id="radius"   size="20" class="form-control input-sm" style = "width:45px;"><button class="go-button" id = "gobutton"><i class="fa fa-arrow-right" aria-hidden="true"></i></button></div>
 </div>
<!-- <div style ="display:flex;flex-direction:column;gap:20px;">Location Fetched:  <div id = "lf"></div></div>-->
<!-- <div class="current" id = "current"> </div>
<div class="last" id = "last"></div>-->
<div class="ads" style ="padding:0px 20px;background: #f1f1f1; height: auto" id="ads">
</div><!-- ads -->

<!-- spolight section end here -->

</div><!-- ads container -->

<!-- Bottom Modal start  -->
<div class="bottom-sheet" id ="bottom-sheet">
        <div class="sheet-header">
            <div class="drag-handle"></div>
            <button class="close-btn"> &times;
            </button>
        </div>
        <div class="sheet-content">
         <div class="filternsearch" style = " padding: 5px;/* 20px;*/    display:flex;flex-direction:row;gap:20px;align-items: center;    justify-content: space-between;">
            <h4 style =" font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 18px;line-height: 0px;text-transform: capitalize;color: #000000;">Filters             </h4>
      
               <div  class="search-filter2">
         <button  id ="apply">Done</button>
            
            
            </div>
            </div>
         
          <div class="filters-container" >
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
            <div class="filterbuttons" >
            
            
            
<!-- <div><p>p</p></div>-->
<button  id ="reset">RESET</button>
<!--<button >APPLY</button>--></div>
        </div><!-- sheet content -->
        
         </div>
 

<!-- Bottom Modal end  -->
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
<!-- ad detail modal start here -->
 <div id="addetailModal" class="modal fullscreen-modal" role="dialog" >
  <div class="modal-dialog fullscreen-modal-dialog">

   
    <div class="modal-content fullscreen-modal-content">
      <div class="modal-header" style ="justify-content: flex-start;gap:18px;padding:0px;">
  

  <button style ="border: none;  outline: none;   background: #F27C0A;   border-radius: 5px;   font-size: 14px;    color: white;    padding: 4px 4px;" data-dismiss="modal" id ="dismissbutton">Back</button> 
        <img   style="height:30px;width:30px;" alt="User profile" class="spotlightimg" id="companyimg"/>
        <div ><h5  style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;" id="companyname"></h5></div>
        <div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>
      </div>
      <div class="modal-body" style ="height:auto;gap:12px;">
      <div class="carousel-container" style ="height:100%;width:100%;order:1;" id = "addetailModalcarousel-container">
      <div  class="carousel slide" data-ride="carousel" id="addetailcarousel">
     <!--  <ol class="carousel-indicators">
      <li data-target="#carousel1"  data-slide-to="0" class="active"></li>
      <li data-target="#carousel2" data-slide-to="1"></li>
      <li data-target="#carousel3"  data-slide-to="2"></li>
      </ol>
      <div class="carousel-inner">
      <div class="item active">
      <img alt="Image" style ="display: block;max-width: 100%;height: 250px;width: 100%;" id="carousel1">
      </div>
      <div class="item">
      <img  alt="Image" style ="display: block;max-width: 100%;height: 250px;width: 100%;" id="carousel2">
      </div>
      <div class="item">
      <img  alt="Image" style ="display: block;max-width: 100%;height: 250px;width: 100%;" id ="carousel3">
      </div>
      </div>
      <a class="left carousel-control" href="#addetailcarousel" data-slide="prev">
      <span class="glyphicon glyphicon-chevron-left"></span>
      <span class="sr-only">Previous</span>
      </a>
      <a class="right carousel-control" href="#addetailcarousel" data-slide="next">
      <span class="glyphicon glyphicon-chevron-right"></span>
      <span class="sr-only">Next</span>
      </a>-->
      
      <ol class="carousel-indicators" id="carousel-indicators"></ol>
  
  <!-- Dynamic carousel items will be inserted here -->
  <div class="carousel-inner" id="carousel-inner"></div>
  
  <a class="left carousel-control" href="#addetailcarousel" data-slide="prev">
    <span class="glyphicon glyphicon-chevron-left"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="right carousel-control" href="#addetailcarousel" data-slide="next">
    <span class="glyphicon glyphicon-chevron-right"></span>
    <span class="sr-only">Next</span>
  </a>
      </div><!-- carousel slide -->
    
      </div>
      <div class="image-container" style ="display:flex;flex-direction:row;gap:20px;order:2;width:100%" id = "image-container" >
      </div>
         <p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;" id="pexpiry"></p>
         <div class="buttons-container" style ="display:flex;flex-direction:row;gap:35px;justify-content: center;    align-items: center;" id ="buttons-container">
      <div class="phone" id ="phone" data-value="12345" onclick="phonefrommodal();"><i class="fa fa-phone" style="font-size:20px;"></i></div>
      <div class="whatsapp" id ="whatsapp" data-value="12345" onclick="whatsappfrommodal();"><i class="fa fa-whatsapp" style="font-size:20px;"></i></div>
      <div class="email" id ="email"><i class="fa fa-envelope" style="font-size:20px;"></i></div>
      <div class="takeme" ><button  id ="addetailmodaltakeme" data-lat="" data-long ="" style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Take me there</button></div>
            
      </div>
   
      <div class="text-container" id = "addetailModaltext-container">
      
      <div style = "display: flex;flex-direction:row;padding: 10px 0px;">
      <div id="showgivendors" style ="display:none;">
       <button class ="takeme" style = "background: #F27C0A;border-radius: 10px;border: none;padding: 5px 10px;font-size: 700;font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #FFFFFF;outline: none;" id = "showvendors"> Show Vendors</button>         
      </div>
      </div>
      
      <p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;" id="ptitle"></p>
      <p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;" id="pdescription"></p>
          <p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;" id="pfullname"></p>
      <div id ="customtextsection"></div>
   
      </div>
     <div class="line" style = "width: 328px;height: 0px;opacity: 0.1;border: 0.923913px solid #000000;flex: none;/*order: 2;*/align-self: stretch;flex-grow: 0;" id="addetailline"></div>
      <div class="validity-container" style="display: flex;flex-direction: column;justify-content: center;
align-items: flex-start;padding: 20px 16px;gap: 0px;/*width: 328px;height: 113px;*/background: #FFFFFF;flex: none;/*order: 1;*/
align-self: stretch;flex-grow: 0;z-index: 0;" id="validity-container">
<h5 style="font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 14px;line-height: 17px;color: #000000;">Validity</h5>
<div style="display:flex;flex-direction:row;gap:20px;">
<div style="display:flex;flex-direction:column;gap:0px;font-family: 'Inter';font-style: normal;font-weight: 400;font-size: 12px;
line-height: 15px;color: #000000;"><h5>Valid From</h5><h5 id="validfrom"></h5></div>

<div style="display:flex;flex-direction:column;gap:0px;font-family: 'Inter';font-style: normal;font-weight: 400;font-size: 12px;
line-height: 15px;color: #000000;"><h5>Valid Till</h5><h5 id="validtill"></h5></div>

</div>      
      
      </div>
              </div>
     
      </div>
    </div>

  </div>  
  
  
  
  <!-- Modal -->

  
</div>
<!--ad detail modal end here --> 
<!-- Show Vendors Start Here-->

<div id="showvendorsModal" class="modal fullscreen-modal" role="dialog" >
  <div class="modal-dialog fullscreen-modal-dialog">
    <!-- Modal content -->
    <div class="modal-content fullscreen-modal-content">
      <div class="modal-header" style ="justify-content: flex-start;gap:18px;padding:8px;">
     <button style ="border:none;outline:none;"  id ="dismissbutton" data-dismiss="modal"> 
     <svg width="12" height="24" viewBox="0 0 12 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M10 19.438L8.95502 20.5L1.28902 12.71C1.10452 12.5197 1.00134 12.2651 1.00134 12C1.00134 11.7349 1.10452 11.4803 1.28902 11.29L8.95502 3.5L10 4.563L2.68202 12L10 19.438Z" fill="black"/>
</svg>
</button>  

<div class="btn-group" style ="display:flex;flex-direction:row;flex:1;">
    <button type="button" class="btn active" id ="locationvendor" onclick="setActiveButton(this);">Location</button>
    <button type="button" class="btn" id ="adsvendor" onclick="setActiveButton(this);">Ads</button>   
  </div>

 <div class="showvendors-search-button-container" style = "display:none;">
<button style ="border:none;outline:none;background: none;" id = "showvendorssearch">
<svg width="25" height="25" viewBox="0 0 30 30" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect width="30" height="30" rx="15" fill="url(#paint0_linear_450_458)"/>
<path d="M20.25 20.25L17.7166 17.7166M17.7166 17.7166C18.1499 17.2832 18.4937 16.7688 18.7282 16.2026C18.9627 15.6364 19.0835 15.0295 19.0835 14.4167C19.0835 13.8038 18.9627 13.197 18.7282 12.6308C18.4937 12.0646 18.1499 11.5501 17.7166 11.1167C17.2832 10.6834 16.7688 10.3396 16.2026 10.1051C15.6364 9.87059 15.0295 9.74988 14.4167 9.74988C13.8038 9.74988 13.197 9.87059 12.6308 10.1051C12.0646 10.3396 11.5501 10.6834 11.1167 11.1167C10.2416 11.9919 9.74988 13.179 9.74988 14.4167C9.74988 15.6544 10.2416 16.8414 11.1167 17.7166C11.9919 18.5918 13.179 19.0835 14.4167 19.0835C15.6544 19.0835 16.8414 18.5918 17.7166 17.7166Z" stroke="white" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
<defs>
<linearGradient id="paint0_linear_450_458" x1="0" y1="15" x2="30" y2="15" gradientUnits="userSpaceOnUse">
<stop stop-color="#F27C0A"/>
<stop offset="1" stop-color="#F2382C"/>
</linearGradient>
</defs>
</svg>
</button>
</div>  


      </div>
      
      
      <div class="showvendors-search-container" style = " display: flex;flex-direction: row;align-items: center;padding: 8px 12px;gap: 6px;
/*width: 360px;height: 61.74px;*/background: #FFFFFF;flex: none;order: 1;flex-grow: 0;">
<div class="search">
<div id = "showvendorsinputtypes" style ="display:flex;flex-direction:row;gap:10px;">
<input type ="text" style ="border: none;outline: none;width: 90%;" placeholder="Search Spotlight" id="showvendorsinputsearch" >
<!-- <button style ="border:none;background:none;outline:none;">
<svg width="19" height="19" viewBox="0 0 19 19" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_50_3976)">
<path d="M9.05859 7.05774C8.31267 7.05774 7.5973 7.35406 7.06986 7.8815C6.54241 8.40895 6.24609 9.12432 6.24609 9.87024C6.24609 10.6162 6.54241 11.3315 7.06986 11.859C7.5973 12.3864 8.31267 12.6827 9.05859 12.6827C9.80452 12.6827 10.5199 12.3864 11.0473 11.859C11.5748 11.3315 11.8711 10.6162 11.8711 9.87024C11.8711 9.12432 11.5748 8.40895 11.0473 7.8815C10.5199 7.35406 9.80452 7.05774 9.05859 7.05774Z" fill="black"/>
<path fill-rule="evenodd" clip-rule="evenodd" d="M9.05859 1.80774C9.20778 1.80774 9.35085 1.867 9.45634 1.97249C9.56183 2.07798 9.62109 2.22105 9.62109 2.37024V3.33174C11.1615 3.46452 12.6055 4.13678 13.6988 5.23004C14.792 6.32329 15.4643 7.76736 15.5971 9.30774H16.5586C16.7078 9.30774 16.8509 9.367 16.9563 9.47249C17.0618 9.57798 17.1211 9.72106 17.1211 9.87024C17.1211 10.0194 17.0618 10.1625 16.9563 10.268C16.8509 10.3735 16.7078 10.4327 16.5586 10.4327H15.5971C15.4643 11.9731 14.792 13.4172 13.6988 14.5104C12.6055 15.6037 11.1615 16.276 9.62109 16.4087V17.3702C9.62109 17.5194 9.56183 17.6625 9.45634 17.768C9.35085 17.8735 9.20778 17.9327 9.05859 17.9327C8.90941 17.9327 8.76634 17.8735 8.66085 17.768C8.55536 17.6625 8.49609 17.5194 8.49609 17.3702V16.4087C6.95571 16.276 5.51164 15.6037 4.41839 14.5104C3.32514 13.4172 2.65288 11.9731 2.52009 10.4327H1.55859C1.40941 10.4327 1.26634 10.3735 1.16085 10.268C1.05536 10.1625 0.996094 10.0194 0.996094 9.87024C0.996094 9.72106 1.05536 9.57798 1.16085 9.47249C1.26634 9.367 1.40941 9.30774 1.55859 9.30774H2.52009C2.65288 7.76736 3.32514 6.32329 4.41839 5.23004C5.51164 4.13678 6.95571 3.46452 8.49609 3.33174V2.37024C8.49609 2.22105 8.55536 2.07798 8.66085 1.97249C8.76634 1.867 8.90941 1.80774 9.05859 1.80774ZM3.62109 9.87024C3.62109 10.5843 3.76174 11.2914 4.035 11.9511C4.30826 12.6108 4.70878 13.2102 5.2137 13.7151C5.71862 14.2201 6.31804 14.6206 6.97775 14.8938C7.63746 15.1671 8.34453 15.3077 9.05859 15.3077C9.77266 15.3077 10.4797 15.1671 11.1394 14.8938C11.7991 14.6206 12.3986 14.2201 12.9035 13.7151C13.4084 13.2102 13.8089 12.6108 14.0822 11.9511C14.3554 11.2914 14.4961 10.5843 14.4961 9.87024C14.4961 8.42812 13.9232 7.04508 12.9035 6.02535C11.8838 5.00562 10.5007 4.43274 9.05859 4.43274C7.61648 4.43274 6.23343 5.00562 5.2137 6.02535C4.19397 7.04508 3.62109 8.42812 3.62109 9.87024Z" fill="black"/>
</g>
<defs>
<clipPath id="clip0_50_3976">
<rect width="18" height="18" fill="white" transform="translate(0.0585938 0.870239)"/>
</clipPath>
</defs>
</svg></button> -->

<button style ="border:none;background:none;outline:none;">
<svg width="25" height="25" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect x="0.0585938" width="31.9414" height="31.7406" rx="15.8703" fill="#F5F5F5"/>
<path d="M18.5146 16.0774C18.5146 16.7915 18.2528 17.4763 17.7867 17.9813C17.3206 18.4862 16.6885 18.7699 16.0293 18.7699C15.3701 18.7699 14.738 18.4862 14.2719 17.9813C13.8058 17.4763 13.5439 16.7915 13.5439 16.0774V10.6925C13.5439 9.97838 13.8058 9.29354 14.2719 8.7886C14.738 8.28367 15.3701 8 16.0293 8C16.6885 8 17.3206 8.28367 17.7867 8.7886C18.2528 9.29354 18.5146 9.97838 18.5146 10.6925V16.0774Z" stroke="black" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M21 16.285C21 19.0249 18.7747 21.2466 16.0293 21.2466M16.0293 21.2466C13.2839 21.2466 11.0586 19.0249 11.0586 16.2845M16.0293 21.2466V23.7406" stroke="black" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
</button>
<!-- <button style ="border:none;outline:none;background: none;" id = "showvendorssearch">
<svg width="25" height="25" viewBox="0 0 30 30" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect width="30" height="30" rx="15" fill="url(#paint0_linear_450_458)"/>
<path d="M20.25 20.25L17.7166 17.7166M17.7166 17.7166C18.1499 17.2832 18.4937 16.7688 18.7282 16.2026C18.9627 15.6364 19.0835 15.0295 19.0835 14.4167C19.0835 13.8038 18.9627 13.197 18.7282 12.6308C18.4937 12.0646 18.1499 11.5501 17.7166 11.1167C17.2832 10.6834 16.7688 10.3396 16.2026 10.1051C15.6364 9.87059 15.0295 9.74988 14.4167 9.74988C13.8038 9.74988 13.197 9.87059 12.6308 10.1051C12.0646 10.3396 11.5501 10.6834 11.1167 11.1167C10.2416 11.9919 9.74988 13.179 9.74988 14.4167C9.74988 15.6544 10.2416 16.8414 11.1167 17.7166C11.9919 18.5918 13.179 19.0835 14.4167 19.0835C15.6544 19.0835 16.8414 18.5918 17.7166 17.7166Z" stroke="white" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
<defs>
<linearGradient id="paint0_linear_450_458" x1="0" y1="15" x2="30" y2="15" gradientUnits="userSpaceOnUse">
<stop stop-color="#F27C0A"/>
<stop offset="1" stop-color="#F2382C"/>
</linearGradient>
</defs>
</svg>
</button>-->

</div>

</div>

<div><button style ="border:none;outline:none;background:none;" id = "showvendorssearchclose"><i class="fa fa-remove"></i></button></div>

</div><!-- search-container -->
      
      <div class="modal-body" style ="height:100%;/*auto*/;gap:12px;padding:0px;">
      <div id="mapvendor" style ="width: 100%; height:100%;/*700px;*/" class="mapvendor">  </div> 
      <div class="markercard-container" id ="markercard-container" >
<div class="panel panel-default" style ="align-items: flex-start;padding: 0px;gap: 10px;position: absolute;width: 90%;left: 15px;top: 650px;/*585px;*/border-radius: 20px;height:175px;">
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
		   <div class="phone" id ="cardphone" ><i class="fa fa-phone"></i></div>
		     <div class="whatsapp" id ="cardwhatsapp" ><i class="fa fa-whatsapp"></i></div>
		     <div class="email" id ="cardemail"><i class="fa fa-envelope"></i></div>
		     <div class="takeme" ><button  id ="cardtakeme" style = "display: flex;flex-direction: row; align-items: center;    padding: 5px 14px;    gap: 5px;    isolation: isolate;    width: 100px;    height: 34px;    background: #FFF;    border-radius: 10px;    flex: none;    order: 0;    flex-grow: 0;    border: none;    outline: none;    font-family: 'Inter';    font-style: normal;
    font-weight: 700;    font-size: 12px;    line-height: 15px;    color: #F27C0A;  border: 1px solid var(--Brand-Primary, #F27C0A);" >
    <i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Take me there</button></div>
		     </div>
		     </div>
		     </div>
		     <div class="cardimage-container">
		     <img src="<c:url value="''" />"  alt="User profile"  id ="cardthumbnail" style="width:100%;height:85%;"/>		     
		     </div>		     
		     </div><!-- body -->	     
</div>
</div>
      
      
      <div id="adsvendordiv" style ="width: 100%; height:100%;/*700px;*/display:none;" class="adsvendordiv">
      <div class="givendorlist" id ="givendorlist" ></div>
      <div class="advertisementlist" id = "advertisementlist" style ="display:flex;flex-direction:column;gap:10px;padding:15px 20px;background: #f1f1f1; height: auto">      
      </div>
      </div> <!-- adsvendordiv -->
      <div class="text-container" id = "addetailModaltext-container">      
      </div><!-- text-container -->      
      </div><!-- modal body -->
     
      </div>
    </div>

  </div>
<!-- Show Vendors End Here -->


<script type="text/javascript">

var categories=[];var currentAdsData;let noofresults =0;let locationFetched =0;
$(document).ready(function() {	   
	document.title = 'KELIRI :: Home';	
	  function checkForDiv(){
		  var x = $(".dynamic-button").length;
	 if ($(".dynamic-button").length) {
        // console.log("The div exists." +x);
     } else {  
    	// console.log("The div not exists." +x);
    $("#hand").show();     
     }
	 }
	// setInterval(checkForDiv, 1000);	
	 mob="";
	$('.close-button').prop("disabled", true);
	 setInterval(checkForDiv, 1000);
	 $('.carousel').carousel();	 
	 init();
	  $(".showvendors-search-container").hide();
	 
	 
	
});//document.ready


//to show the map start here
 var mvendor;
 function init()
		 {
		 	  mvendor = new google.maps.Map(document.getElementById('mapvendor'), {
		 	         center: { lat: 0, lng: 0 },
		 	         zoom:12
		 	     });	
		 	  
		 	//  console.log('mvendor: ' +mvendor);
		 }

//to show the map end here
//to sort start here
const distancebutton = document.getElementById('distance');
const timebutton =  document.getElementById('time');
const gitagbutton = document.getElementById('gi');
const templebutton = document.getElementById("temple");
const forestbutton = document.getElementById("forest");
const heritagebutton = document.getElementById("heritage");
const hospitalbutton = document.getElementById("hospital");
const busbutton = document.getElementById("bus");
const carbutton = document.getElementById("car");
const rickshawbutton = document.getElementById("rickshaw");
const goodsbutton = document.getElementById("goods");
const vlogsbutton =  document.getElementById('vlogs');
const newsbutton =  document.getElementById('news');
let distance =0; let time =0;
distancebutton.addEventListener('click', function() { 
	//console.log('in distance : ' );
	distancebutton.classList.remove("inactivesort");
	distancebutton.classList.add("activesort");
	timebutton.classList.remove("activesort");
	timebutton.classList.add("inactivesort");
	distance=1;time=0;
	
	let array = currentAdsData;var k=0;
	//console.log("currentAdsData: " +JSON.stringify(currentAdsData));
/*	$.each(array, function (i, myList) {
	var latitude1 = myList.location.lat;
	var longitude1 = myList.location.lng;
	var latitude2 = onesinglelatitude;
	var longitude2 = onesinglelongitude;
	console.log(latitude1+','+longitude1+latitude2+','+longitude2);
	 var calcdistance = getDistanceFromLatLonInKm(latitude1,longitude1,latitude2,longitude2);
	 myList.distance = calcdistance;
	 console.log('myList.distance : ' +  myList.distance +'calc dis' +calcdistance);
	
	});*/
	 //console.log('mylist now : \n'+JSON.stringify(array)+'\n' );
	//console.log('Before sorting with distnace added: ' +JSON.stringify( array));
let sortedArray=	array.sort(function(a, b) { return a.distance - b.distance; });
//let sortedArray=array;
//console.log('After sorting with distnace added: ' +JSON.stringify( array));
document.getElementById("ads").innerHTML = "";
$.each(sortedArray, function (i, myList) {
	  var adsid = myList.id;
	 var phno = myList.phoneNumber;
		var whatsapp = myList.whatsappNumber;
	 var email= myList.emailAddress;
	//console.log('distance : ' +myList.distance +'name : ' +myList.a.title);
	 var publisher_name = myList.a.title;var fullname = myList.fullName;
// 	 console.log(publisher_name);
	 var description = myList.a.description;
	 var dates = myList.dateRange.toDate;
	const date = new Date(dates);
	var companyName='';
	var latitudes=myList.location.lat;
	var longitudes = myList.location.lng;
	var companyLogoUrl = myList.companies.companyLogoPath;
	var thumbnail = myList.a.thumbnail;
	//console.log('companyLogoUrl: ' +companyLogoUrl);
	var banner1="nopreview.jpg";
	var banner2 = "nopreview.jpg";
	var createdBy = myList.createdBy;
	if(myList.a.adType =='64887c11cce361dafc86c23b' ){
	var baners =  myList.a.content.banners;	  
	
// 	console.log('created by : ' + createdBy);
	if(baners !=null )
		{
		 banner1 = baners[0];
	if(baners[1] != undefined ){    			
			 banner2 = baners[1];
		 }
		}
	}
	if(myList.companies==null || myList.companies==undefined){
	companyName=publisher_name;}
	else{	     	 companyName= myList.companies.name;}

// Create a formatter with custom options
const formatter = new Intl.DateTimeFormat('en-GB', {
   day: 'numeric',
   month: 'long',
   year: 'numeric'
});

const formattedDate = formatter.format(date);
//  console.log(formattedDate); // e.g., "29 August 2024"
	//onclick=nextui(this);
	 var img_path = "";
	 k++;
	 var carouselid= 'myCarouselhome'+k;
	 //onclick=nextui(this);


var ad_card='<div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
  +'<div class="panel-heading">'
  +'<img src="<c:url value="'+companyLogoUrl+'" />" style="height:30px;width:30px;" alt="User profile" class="spotlightimg"  loading="lazy"/>'
  +'<div id="frame20"><h5 id="publishername" style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">'+companyName+' </h5></div>'
  +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
  +'<div class="saved"><svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/></svg>'
  +'</div>'
  +'</div>'//heading 
  +'<div class="panel-body" style="padding:0px !important;" >'
  +'<div class="carousel-container">'
  +'<div  class="carousel slide" data-ride="carousel" id="'+carouselid+'">'
  
  
  +'<div class="carousel-inner">'
  +'<div class="item active">'
  +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
  +'</div>'
  +'<div class="item">'
  +'<img src="<c:url value="'+banner1+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
  +'</div>'
  +'<div class="item">'
  +'<img src="<c:url value="'+banner2+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
  +'</div>'
  +'</div>'
  
  
  +'</div>'
  +'</div>'// carousel container 
  +'<div class="text-container">'
  +'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;">'+publisher_name+'</p>'
  +'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+description+'</p>'
  <!--+'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+fullname+'</p>'-->
 <!-- +'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'-->
  +'</div>'
  +'</div>'//<!-- panel body --> 
  +'<div class="line" style ="width: 90%;    margin: 11px 11px;    border-top: 2px solid black;   opacity: 0.1; "></div>'
  +'<div class="panel-footer">'
  +'<div class="phone" id ="phone" onclick=phone('+phno+');><i class="fa fa-phone" style="font-size:20px;"></i></div>'
  +'<div class="whatsapp" id ="whatsapp" onclick=whatsapp('+whatsapp+');><i class="fa fa-whatsapp" style="font-size:20px;"></i></div>'
  +'<div class="email" id ="email"><i class="fa fa-envelope" style="font-size:20px;"></i></div>'
  +'<div class="takeme" ><button  id ="takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+'); style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Take me there</button></div>'
  +'</div>'
  +'</div>'
	 $('.ads').append(ad_card); 
  	  }); //.each

	//console.log('Sorted array Distance: ' + JSON.stringify(array));
/*	for(var i=0;i<sortedArray.length;i++)
		{
		console.log('distance: ' +sortedArray[i].dateRange.fromDate);
		
		}*/
	});


// to sort end here
//to sort based on date and time start here

timebutton.addEventListener('click', function() { 
	let dateTimeArray = currentAdsData;
	var k=0;
	
	timebutton.classList.remove("inactivesort");
	timebutton.classList.add("activesort");
	distancebutton.classList.remove("activesort");
	distancebutton.classList.add("inactivesort");
	//console.log('in times : ' );
	distance=0;time=1;
	let dateTimeArraySorted=dateTimeArray.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
//	console.log('dateTimeArraySorted: ' +JSON.stringify(dateTimeArraySorted));
document.getElementById("ads").innerHTML = "";
//console.log('here '+JSON.stringify(currentAdsData));
$.each(dateTimeArraySorted, function (i, myList) {
	//console.log('i :' +myList.dateRange.fromDate+'Name: '+myList.a.title);
	  var adsid = myList.id;
	 var phno = myList.phoneNumber;
		var whatsapp = myList.whatsappNumber;
	// console.log('phno : ' +phno);
	 var email= myList.emailAddress;
	 var publisher_name = myList.a.title;var fullname = myList.fullName;
// 	 console.log(publisher_name);
	 var description = myList.a.description; 
	// console.log('From Date : ' +myList.dateRange.fromDate);
	 var dates = myList.dateRange.toDate;
	const date = new Date(dates);
	var companyName='';
	var latitudes=myList.location.lat;
	var longitudes = myList.location.lng;
	var companyLogoUrl = myList.companies.companyLogoPath;
	var thumbnail = myList.a.thumbnail;
	//console.log('companyLogoUrl: ' +companyLogoUrl);
	var banner1="nopreview.jpg";
	var banner2 = "nopreview.jpg";
	var createdBy = myList.createdBy;
	if(myList.a.adType =='64887c11cce361dafc86c23b' ){
	var baners =  myList.a.content.banners;	  
	
// 	console.log('created by : ' + createdBy);
	if(baners !=null )
		{
		 banner1 = baners[0];
	if(baners[1] != undefined ){    			
			 banner2 = baners[1];
		 }
		}
	}
	if(myList.companies==null || myList.companies==undefined){
	companyName=publisher_name;}
	else{	     	 companyName= myList.companies.name;}

// Create a formatter with custom options
const formatter = new Intl.DateTimeFormat('en-GB', {
   day: 'numeric',
   month: 'long',
   year: 'numeric'
});

const formattedDate = formatter.format(date);
//  console.log(formattedDate); // e.g., "29 August 2024"
	//onclick=nextui(this);
	 var img_path = "";
	 k++;
	 var carouselid= 'myCarouselhome'+k;
	 //onclick=nextui(this);


var ad_card='<div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
  +'<div class="panel-heading">'
  +'<img src="<c:url value="'+companyLogoUrl+'" />" style="height:30px;width:30px;" alt="User profile" class="spotlightimg" loading="lazy" />'
  +'<div id="frame20"><h5 id="publishername" style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">'+companyName+' </h5></div>'
  +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
  +'<div class="saved"><svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/></svg>'
  +'</div>'
  +'</div>'//heading 
  +'<div class="panel-body" style="padding:0px !important;" >'
  +'<div class="carousel-container">'
  +'<div  class="carousel slide" data-ride="carousel" id="'+carouselid+'">'
  
  
  +'<div class="carousel-inner">'
  +'<div class="item active">'
  +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
  +'</div>'
  +'<div class="item">'
  +'<img src="<c:url value="'+banner1+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
  +'</div>'
  +'<div class="item">'
  +'<img src="<c:url value="'+banner2+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
  +'</div>'
  +'</div>'
  
  
  +'</div>'
  +'</div>'// carousel container 
  +'<div class="text-container">'
  +'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;">'+publisher_name+'</p>'
  +'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+description+'</p>'
  <!--+'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+fullname+'</p>'-->
 <!-- +'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'-->
  +'</div>'
  +'</div>'//<!-- panel body --> 
  +'<div class="line" style ="width: 90%;    margin: 11px 11px;    border-top: 2px solid black;   opacity: 0.1; "></div>'
  +'<div class="panel-footer">'
  +'<div class="phone" id ="phone" onclick=phone('+phno+');><i class="fa fa-phone" style="font-size:20px;"></i></div>'
  +'<div class="whatsapp" id ="whatsapp" onclick=whatsapp('+whatsapp+');><i class="fa fa-whatsapp" style="font-size:20px;"></i></div>'
  +'<div class="email" id ="email"><i class="fa fa-envelope" style="font-size:20px;"></i></div>'
  +'<div class="takeme" ><button  id ="takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+'); style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Take me there</button></div>'
  +'</div>'
  +'</div>'
	 $('.ads').append(ad_card); 
  	  }); //.each

	//console.log('Sorted array Distance: ' + JSON.stringify(array));
	/*for(var i=0;i<dateTimeArraySorted.length;i++)
		{
		console.log('distance: ' +sortedArray[i].dateRange.fromDate);
		
		}*/
	});
//to sort based on date and time end here
/*var users = ${users};
var spotlight="";
var x=0;
// to add spotlight start here
for(var i=0;i<15;i++)
{
	var name =users[i].fullName;
	 var profilepicpath= users[i].profilePicPath;
	var str = name.substring(0, 10);
	var userid = users[i].id;
	 spotlight+='  <div class="spotlightitem" role="button" id = "'+userid+'">'
+'	<img  src="<c:url value="'+profilepicpath+'" />"  alt="User profile" style="width: 37px;height: 39px;" class="spotlightimg"/>'
		+'<div class="companyname">'+str+'</div>'
+' 		</div>';    
	}
 
 $('.spotlightlist').append(spotlight);*/
 
 //to add spotloight end here
 //dragging listener for spotlight starts here 2 
/* 
let currentPage = 1;  // Keep track of the current page of items
let isLoading = false;  // Prevent multiple loads at the same time
const swipeWrapper = document.getElementById('spotlightlist');

// Function to simulate loading items from a server (can be replaced with actual AJAX)
function loadItems(page) {
    if (isLoading) return;  // Prevent loading if already in progress
    isLoading = true;
    
    setTimeout(function() {// Simulate loading by adding 5 new items
        let newItems = [];
        for (let i = 0; i < users.length; i++) {
        	var name =users[i].fullName;
        	console.log('name: ' +users[2].fullName);
   		 var profilepicpath= users[i].profilePicPath;
   			var str = name.substring(0, 10);
   			var userid = users[i].id;
            newItems.push('<div class="spotlightitem" role="button" id = "'+userid+'">'
            		+'	<img  src="<c:url value="'+profilepicpath+'" />"  alt="User profile" style="width: 37px;height: 39px;" class="spotlightimg"/>'
            				+'<div class="companyname">'+str+'</div>'
            		+' 		</div>');
        }

       
        swipeWrapper.innerHTML += newItems.join(''); // Append new items to the swipe-wrapper
        isLoading = false;
    }, 1000);  // Simulate network delay (1 second)
}

// Variables for swipe gesture
let startX = 0;
let currentX = 0;
let offsetX = 0;
let isSwiping = false;
let swipeIndex = 0;


swipeWrapper.addEventListener('touchstart', function(e) {// Detect swipe start
	console.log('TOUCH');
    startX = e.touches[0].clientX;
    isSwiping = true;
});


swipeWrapper.addEventListener('touchmove', function(e) {// Detect swipe movement
    if (!isSwiping) return;

    currentX = e.touches[0].clientX;
    offsetX = currentX - startX;

    swipeWrapper.style.transform = 'translateX(' + (-swipeIndex * 100) + '% + ' + (offsetX / window.innerWidth) * 100 + '%)';
});


swipeWrapper.addEventListener('touchend', function() {// Detect swipe end
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

    
    if (swipeIndex === swipeWrapper.children.length - 1) {// If we reach the last item, load more items
        currentPage++;
        loadItems(currentPage);  // Load the next batch of items
    }

    isSwiping = false;
    startX = 0;
    currentX = 0;
    offsetX = 0;
});
*/
// Initial loading of items
//loadItems(currentPage);
//to drag spotlight end here
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
	const flexItem = document.querySelector('.ads-container');
    bottomSheet.style.display = "block";
    document.body.style.overflow = "hidden";
    //  document.body.classList.add('no-scroll');  
   // flexItem.style.overflow='hidden';
    bottomSheet.style.bottom = "0";
   // const flexItem2 = document.querySelector('.ads');
  //  flexItem2.style.overflow='hidden';
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

//to change the button colour in filter start 
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
         console.log(buttonValue); // Outputs: "Button 1", "Button 2", or "Button 3" based on the clicked span
         const index = categories.indexOf(buttonValue);
         if (index > -1) { // only splice array when item is found
        	 categories.splice(index, 1); // 2nd parameter means remove one item only   
           }      
           
     //        console.log('categories array at top : ' +categories);
         // to update the ad result start here
         
         	 var k=0;
     		 var results =0;
     		 $.ajax({
     		        // Our sample url to make request 
     		        url:"${pageContext.request.contextPath}/categories",
     		        type: "POST",
     		        contentType : 'application/json',
     		        dataType : 'json',
     		        data: JSON.stringify(categories), // Convert array to JSON string 
     		        success: function (data) {
     		          //  let x = JSON.stringify(data);
     		         //   console.log('in categories success : ' +x);
     		            document.getElementById("ads").innerHTML = "";
     		        	//noofresults=data.length;
     		        	noofresults=0;
     		        	if (distancebutton.classList.contains('inactivesort')) {
     		        	    // Remove the class
     		        	    distancebutton.classList.remove('inactivesort');
     		        	    distancebutton.classList.add("activesort");
     		        		distance=1;time=0;
     		        		timebutton.classList.remove("activesort");
     		        		timebutton.classList.add("inactivesort");
     		        	} else {
     		        	    
     		        	}
     			         if(distance===1)
     		 {	
     		 let array = data;
     		 let sortedArray=	array.sort(function(a, b) { return a.distance - b.distance; });
     		 data = sortedArray;

     		 }
     	 if (time===1)
     		 {
     		 
     		    let dateTimeArray = data;
     			let dateTimeArraySorted=dateTimeArray.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
     			data = dateTimeArraySorted;
     			
     		 }
     		        	currentAdsData=data;
     		      
     		    		 $.each(data, function (i, myList) {
    		        		 
    		        						 var adsid = myList.id;
    		     	     	 				 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
    		     	     	
    		     	     					 var email= myList.emailAddress;
    		         		    	     	 var publisher_name = myList.a.title;
    		         		    	  
    		         		    	     	 var description = myList.a.description;var fullname = myList.fullName;
    		         		    	     	 var dates = myList.dateRange.toDate;
    		         		    	     	const date = new Date(dates);
    		         		    	    	var companyName='';
    		         		    	    	var latitudes=myList.location.lat;
    		         		    	    	var longitudes = myList.location.lng;
    		         		    	    	var companyLogoUrl = myList.companies.companyLogoPath;
    		         		    	    	var thumbnail = myList.a.thumbnail;
    		         		    	    
    		         		    	    	var banner1="nopreview.jpg";
    		         		    	    	var banner2 = "nopreview.jpg";	var createdBy = myList.createdBy;
    		         		    	    	if(myList.a.adType =='64887c11cce361dafc86c23b' ){
    		         		    	    	var baners =  myList.a.content.banners;
    		         		    	    		    	
    		         		    	    	if(baners !=null )
    		         		    	    		{
    		         		    	    		 banner1 = baners[0];    		    	    		
    		         		    	    	//console.log('inside if baners!=null');
    		         		    	    		 if(baners[1] != undefined ){  		 	    		
    		         		    	    			 banner2 = baners[1];
    		         		    	    		 }
    		         		    	    		}
    		         		    	    	}
    		         		    	     	if(myList.companies==null || myList.companies==undefined){//console.log('inside if'+publisher_name);
    		         		    	     	companyName=publisher_name;}
    		         		    	     	else{	     	 companyName= myList.companies.name;}
    		         		    			//console.log('company name : '+companyName);
    		         		    	     
    		         		    	     // Create a formatter with custom options
    		         		    	     const formatter = new Intl.DateTimeFormat('en-GB', {
    		         		    	         day: 'numeric',
    		         		    	         month: 'long',
    		         		    	         year: 'numeric'
    		         		    	     });

    		         		    	     const formattedDate = formatter.format(date);
    		         		    	   //  console.log(formattedDate); // e.g., "29 August 2024"
    		         		    	     	
    		         		    	     	 var img_path = ""; k++;
    		         		    	     	 var carouselid= 'myCarouselhome'+k;
    		         		    	     	var ad_card='<div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
    		         		    	            +'<div class="panel-heading">'
    		         		    	            +'<img src="<c:url value="'+companyLogoUrl+'" />"  style="height:30px;width:30px;" alt="User profile" class="spotlightimg" loading="lazy"/>'
    		         		    	            +'<div id="frame20"><h5 id="publishername" style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">'+companyName+' </h5></div>'
    		         		    	            +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
    		         		    	            +'<div class="saved"><svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/></svg>'
    		         		    	            +'</div>'
    		         		    	            +'</div>'//heading 
    		         		    	            +'<div class="panel-body" style="padding:0px !important;">'
    		         		    	            +'<div class="carousel-container">'
    		         		    	            +'<div  class="carousel slide" data-ride="carousel" id="'+carouselid+'">'
    		         		    	            
    		         		    	            
    		         		    	            +'<div class="carousel-inner">'
    		         		    	            +'<div class="item active">'
    		         		    	            +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
    		         		    	            +'</div>'
    		         		    	            +'<div class="item">'
    		         		    	            +'<img src="<c:url value="'+banner1+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy"> '
    		         		    	            +'</div>'
    		         		    	            +'<div class="item">'
    		         		    	            +'<img src="<c:url value="'+banner2+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
    		         		    	            +'</div>'
    		         		    	            +'</div>'
    		         		    	           
    		         		    	            
    		         		    	            +'</div>'
    		         		    	            +'</div>'// carousel container 
    		         		    	            +'<div class="text-container">'
    		         		    	            +'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;">'+publisher_name+'</p>'
    		         		    	            +'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+description+'</p>'
    		         		    	        <!--+'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+fullname+'</p>'-->
    		         		    	         <!--   +'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'-->
    		         		    	            +'</div>'
    		         		    	            +'</div>'//<!-- panel body --> 
    		         		    	            +'<div class="line" style ="width: 90%;    margin: 11px 11px;    border-top: 2px solid black;   opacity: 0.1; "></div>'
    		         		    	            +'<div class="panel-footer">'
    		         		    	            +'<div class="phone" id ="phone" onclick=phone('+phno+');><i class="fa fa-phone" style="font-size:20px;"></i></div>'
    		         		    	            +'<div class="whatsapp" id ="whatsapp" onclick=whatsapp('+whatsapp+');><i class="fa fa-whatsapp" style="font-size:20px;"></i></div>'
    		         		    	            +'<div class="email" id ="email"><i class="fa fa-envelope" style="font-size:20px;"></i></div>'
    		         		    	            +'<div class="takeme" ><button  id ="takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+'); style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Take me there</button></div>'
    		         		    	            +'</div>'
    		         		    	            +'</div>'
    		         		    		     	 $('.ads').append(ad_card); 
    		         		    	            noofresults++;
    		        		  
    		    		 });
     		    		 
     		    	
     		    	 $('#noofresults').html('Results: '+noofresults) ;	 
     		    	        	  
     		        }//success
     		 });//ajax
         
         
         
         // to update the ad result end here
         
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
 //    console.log('contents of categories Array: ' + categories);
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
        console.log('categories array at top : ' +categories);
        // to update the ad result start here
        
        	 var k=0;
    		 var results =0;
    		 $.ajax({
    		        // Our sample url to make request 
    		        url:"${pageContext.request.contextPath}/categories",
    		        type: "POST",
    		        contentType : 'application/json',
    		        dataType : 'json',
    		        data: JSON.stringify(categories), // Convert array to JSON string 
    		        success: function (data) {
    		          //  let x = JSON.stringify(data);
    		         //   console.log('in categories success : ' +x);
    		            document.getElementById("ads").innerHTML = "";
    		        	//noofresults=data.length;
    		        	noofresults=0;
    		        	if (distancebutton.classList.contains('inactivesort')) {
    		        	    // Remove the class
    		        	    distancebutton.classList.remove('inactivesort');
    		        	    distancebutton.classList.add("activesort");
    		        		distance=1;time=0;
    		        		timebutton.classList.remove("activesort");
    		        		timebutton.classList.add("inactivesort");
    		        	} else {
    		        	    
    		        	}
    			         if(distance===1)
    		 {	
    		 let array = data;
    		 let sortedArray=	array.sort(function(a, b) { return a.distance - b.distance; });
    		 data = sortedArray;

    		 }
    	 if (time===1)
    		 {
    		 
    		    let dateTimeArray = data;
    			let dateTimeArraySorted=dateTimeArray.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
    			data = dateTimeArraySorted;
    			
    		 }
    		        	currentAdsData=data;
    		      
    		    		
    		    		 $.each(data, function (i, myList) {
   		        		 
   		        						 var adsid = myList.id;
   		     	     	 				 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
   		     	     	
   		     	     					 var email= myList.emailAddress;
   		         		    	     	 var publisher_name = myList.a.title;
   		         		    	  
   		         		    	     	 var description = myList.a.description;var fullname = myList.fullName;
   		         		    	     	 var dates = myList.dateRange.toDate;
   		         		    	     	const date = new Date(dates);
   		         		    	    	var companyName='';
   		         		    	    	var latitudes=myList.location.lat;
   		         		    	    	var longitudes = myList.location.lng;
   		         		    	    	var companyLogoUrl = myList.companies.companyLogoPath;
   		         		    	    	var thumbnail = myList.a.thumbnail;
   		         		    	    
   		         		    	    	var banner1="nopreview.jpg";
   		         		    	    	var banner2 = "nopreview.jpg";	var createdBy = myList.createdBy;
   		         		    	    	if(myList.a.adType =='64887c11cce361dafc86c23b' ){
   		         		    	    	var baners =  myList.a.content.banners;
   		         		    	    		    	
   		         		    	    	if(baners !=null )
   		         		    	    		{
   		         		    	    		 banner1 = baners[0];    		    	    		
   		         		    	    	//console.log('inside if baners!=null');
   		         		    	    		 if(baners[1] != undefined ){  		 	    		
   		         		    	    			 banner2 = baners[1];
   		         		    	    		 }
   		         		    	    		}
   		         		    	    	}
   		         		    	     	if(myList.companies==null || myList.companies==undefined){//console.log('inside if'+publisher_name);
   		         		    	     	companyName=publisher_name;}
   		         		    	     	else{	     	 companyName= myList.companies.name;}
   		         		    			//console.log('company name : '+companyName);
   		         		    	     
   		         		    	     // Create a formatter with custom options
   		         		    	     const formatter = new Intl.DateTimeFormat('en-GB', {
   		         		    	         day: 'numeric',
   		         		    	         month: 'long',
   		         		    	         year: 'numeric'
   		         		    	     });

   		         		    	     const formattedDate = formatter.format(date);
   		         		    	   //  console.log(formattedDate); // e.g., "29 August 2024"
   		         		    	     	
   		         		    	     	 var img_path = ""; k++;
   		         		    	     	 var carouselid= 'myCarouselhome'+k;
   		         		    	     	var ad_card='<div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
   		         		    	            +'<div class="panel-heading">'
   		         		    	            +'<img src="<c:url value="'+companyLogoUrl+'" />"  style="height:30px;width:30px;" alt="User profile" class="spotlightimg" loading="lazy"/>'
   		         		    	            +'<div id="frame20"><h5 id="publishername" style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">'+companyName+' </h5></div>'
   		         		    	            +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
   		         		    	            +'<div class="saved"><svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/></svg>'
   		         		    	            +'</div>'
   		         		    	            +'</div>'//heading 
   		         		    	            +'<div class="panel-body" style="padding:0px !important;">'
   		         		    	            +'<div class="carousel-container">'
   		         		    	            +'<div  class="carousel slide" data-ride="carousel" id="'+carouselid+'">'
   		         		    	            
   		         		    	            
   		         		    	            +'<div class="carousel-inner">'
   		         		    	            +'<div class="item active">'
   		         		    	            +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
   		         		    	            +'</div>'
   		         		    	            +'<div class="item">'
   		         		    	            +'<img src="<c:url value="'+banner1+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy"> '
   		         		    	            +'</div>'
   		         		    	            +'<div class="item">'
   		         		    	            +'<img src="<c:url value="'+banner2+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
   		         		    	            +'</div>'
   		         		    	            +'</div>'
   		         		    	           
   		         		    	            
   		         		    	            +'</div>'
   		         		    	            +'</div>'// carousel container 
   		         		    	            +'<div class="text-container">'
   		         		    	            +'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;">'+publisher_name+'</p>'
   		         		    	            +'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+description+'</p>'
   		         		    	        <!--+'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+fullname+'</p>'-->
   		         		    	         <!--   +'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'-->
   		         		    	            +'</div>'
   		         		    	            +'</div>'//<!-- panel body --> 
   		         		    	            +'<div class="line" style ="width: 90%;    margin: 11px 11px;    border-top: 2px solid black;   opacity: 0.1; "></div>'
   		         		    	            +'<div class="panel-footer">'
   		         		    	            +'<div class="phone" id ="phone" onclick=phone('+phno+');><i class="fa fa-phone" style="font-size:20px;"></i></div>'
   		         		    	            +'<div class="whatsapp" id ="whatsapp" onclick=whatsapp('+whatsapp+');><i class="fa fa-whatsapp" style="font-size:20px;"></i></div>'
   		         		    	            +'<div class="email" id ="email"><i class="fa fa-envelope" style="font-size:20px;"></i></div>'
   		         		    	            +'<div class="takeme" ><button  id ="takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+'); style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Take me there</button></div>'
   		         		    	            +'</div>'
   		         		    	            +'</div>'
   		         		    		     	 $('.ads').append(ad_card); 
   		         		    	            noofresults++;
   		        		  
   		    		 });
    		    		 
    		    	
    		    	 $('#noofresults').html('Results: '+noofresults) ;	 
    		    	        	  
    		        }//success
    		 });//ajax
        
        
        
        // to update the ad result end here
        
        
        
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


var takemelat;var takemelng;var blueMarker;var lastlat,lastlng; var locationset =0; var currentLocationset=false;/*let watchID;*/
var latitudefromsession = <%= latitude%>;//when coming back to home
var longitudefromsession = <%= longitude%>;
var finallistofads = <%= finallistofads1%>;
var verticalenabled = "<%= verticalenabledfromsession %>"; //Wrap the JSP output in quotes so it becomes a proper JavaScript string:
var vlogsenabled = "<%= vlogsenabledfromsession %>";
var currentLocationsetfromsess = <%= currentLocationsetfromsession != null ? currentLocationsetfromsession : false %>;

var vehiclead = Number("${vehiclead}");

var addetails = ${empty addetailsJson ? '[]' : addetailsJson};



//var lati,lngi;
//to fetch the location and load the ads starts here 
document.addEventListener("DOMContentLoaded", function() { 
	
	if(vlogsenabled === "vlogsenabled")
		{
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
	 if(verticalenabled === "gitagenabled")
	 {
		   document.getElementById("filter-container").style.display = "none";
		 gitagbutton.classList.remove("roadinactive");
         gitagbutton.classList.add("roadactive");   
         	 
		 }
	 if(verticalenabled === "templeenabled")
	 {
		   document.getElementById("filter-container").style.display = "none";
		 templebutton.classList.remove("roadinactive");
         templebutton.classList.add("roadactive");   
         
	 }
	 if(verticalenabled === "forestenabled")
	 {
		   document.getElementById("filter-container").style.display = "none";
		 forestbutton.classList.remove("roadinactive");
         forestbutton.classList.add("roadactive");   
         
	 }
	 if(verticalenabled === "heritageenabled")
	 {
		   document.getElementById("filter-container").style.display = "none";
		 heritagebutton.classList.remove("roadinactive");
         heritagebutton.classList.add("roadactive");   
         
	 }
	 if(verticalenabled === "hospitalenabled")
	 {
		   document.getElementById("filter-container").style.display = "none";
		 hospitalbutton.classList.remove("roadinactive");
         hospitalbutton.classList.add("roadactive");   
         
	 }
	 if(verticalenabled === "busenabled")
	 {
		   document.getElementById("filter-container").style.display = "none";
		 busbutton.classList.remove("roadinactive");
         busbutton.classList.add("roadactive");  
         console.log('busenabled from session');
         busenabled =1 ;
         
	 }
	 if(verticalenabled === "carenabled")
	 {
		   document.getElementById("filter-container").style.display = "none";
		 carbutton.classList.remove("roadinactive");
         carbutton.classList.add("roadactive");  
         console.log('carenabled from session');
         carenabled=1;
         
	 }
	 if(verticalenabled === "rickshawenabled")
	 {
		   document.getElementById("filter-container").style.display = "none";
		 rickshawbutton.classList.remove("roadinactive");
         rickshawbutton.classList.add("roadactive");  
         rickshawenabled=1;
         console.log('rickshawenabled from session');
         
	 }
	 if(verticalenabled === "goodsenabled")
	 {
		   document.getElementById("filter-container").style.display = "none";
		 goodsbutton.classList.remove("roadinactive");
         goodsbutton.classList.add("roadactive");
         goodsenabled =1 ;
         console.log('goodsenabled from session');
         
	 }
	 if(verticalenabled === "vlogsenabled")
	 {
		   document.getElementById("filter-container").style.display = "none";
		 vlogsbutton.classList.remove("roadinactive");
         vlogsbutton.classList.add("roadactive");   
         
	 }
	 if(verticalenabled === "newsenabled")
	 {
		   document.getElementById("filter-container").style.display = "none";
		 newsbutton.classList.remove("roadinactive");
        newsbutton.classList.add("roadactive");   
         
	 }
	 if(currentLocationsetfromsess==true)
		 {
		  //document.getElementById("currentlocationbutton").style.background=" #F27C0A";
		//  console.log('************************************************************************************************************************************');
		 document.getElementById("currentlocationbutton").disabled = false;
   	     document.getElementById("pinlocationbutton").disabled = true;
		 }
	 else
		 {
		//  document.getElementById("pinlocationbutton").style.background=" #F27C0A";
	//	console.log('********************************************************************************%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
		 document.getElementById("currentlocationbutton").disabled = true;
   	     document.getElementById("pinlocationbutton").disabled = false;
		 }
    function getLocation() {
    	//console.log('getLocation called');
    	
    	if((latitudefromsession==null || finallistofads==null)&&vehiclead!=1){ 	                                       //***************************************************************************************************************
    	console.log('session new');
         if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(sendLocation,sendDefaultLocation);
        } 	   
        else {
        	
        }
    	}
    	else {
    		if(!(latitudefromsession==null || finallistofads==null) && vehiclead!=1)
    		{
            console.log('in session');
 	        getAdsFromSession();
    		
    		}
    	if(!(latitudefromsession==null || finallistofads==null) && vehiclead===1)
    		
    		{
    		console.log('from vehicle ad ');
    		//showonevehiclead();
    		  getAdsFromSession();
    	//	  console.log('adDetails : ' + JSON.stringify(addetails));
    		 nextui(addetails, addetails.createdBy) ;
    		
    		}
    		}
    
    }        
    
    
    function showonevehiclead()
    {
    	
    	if (distancebutton.classList.contains('inactivesort')) {
    	    // Remove the class
    	    distancebutton.classList.remove('inactivesort');
    	    distancebutton.classList.add("activesort");
    		distance=1;time=0;
    		timebutton.classList.remove("activesort");
    		timebutton.classList.add("inactivesort");
    	} else {
    	    // Add the class
    	    //currentClasses.add('newClass');
    	}
    	 
       // currentAdsData=data;
       // console.log(x);
           document.getElementById("ads").innerHTML = "";
      // 	noofresults=data.length;
       	
       	noofresults=0;
    	 var adsid = addetails.id;
	     	 var phno = addetails.phoneNumber;
	     	var whatsapp = addetails.whatsappNumber;
	     	 var email= addetails.emailAddress;
    	 var publisher_name = addetails.a.title;
  
    	 var description = addetails.a.description; var fullname = addetails.fullName;
    	 var dates = addetails.dateRange.toDate;
    	const date = new Date(dates);
   	var companyName='';
   	var latitudes=addetails.location.lat;
	var longitudes = addetails.location.lng;
   	var companyLogoUrl = addetails.companies.companyLogoPath;
	var thumbnail = addetails.a.thumbnail;

	var banner1="nopreview.jpg";
	var banner2 = "nopreview.jpg";	var createdBy = addetails.createdBy;
	var whatsapp = addetails.whatsappNumber;
	if(addetails.a.adType =='64887c11cce361dafc86c23b' ){
	var baners =  addetails.a.content.banners;
		    	
	if(baners !=null )
		{
		 banner1 = baners[0];
		

		 if(baners[1] != undefined ){
		
			
			 banner2 = baners[1];
		 }
		}
	}
    	if(addetails.companies==null || addetails.companies==undefined){
    	companyName=publisher_name;}
    	else{	     	 companyName= addetails.companies.name;}
	
    const formatter = new Intl.DateTimeFormat('en-GB', {
        day: 'numeric',
        month: 'long',
        year: 'numeric'
    });

    const formattedDate = formatter.format(date);
 
    	
    	 var img_path = "";
   var distance = addetails.distance.toFixed(1);
   console.log('distance' +distance);
 	 var carouselid= 'myCarouselhome';
 	var ad_card='<div class="panel panel-default" role="button" id = '+adsid+' >'
        +'<div class="panel-heading">'
        +'<img src="<c:url value="'+companyLogoUrl+'" />"  style="height:30px;width:30px;" alt="User profile" class="spotlightimg" loading="lazy" />'
        +'<div id="frame20"><h5 id="publishername" style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">'+companyName+' </h5></div>'
        +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
        +'<div class="saved"><svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/></svg>'
        +'</div>'
        +'</div>'//heading 
        +'<div class="panel-body" style="padding:0px !important;">'
        +'<div class="carousel-container">'
        +'<div  class="carousel slide" data-ride="carousel" id="'+carouselid+'">'	           
        
        +'<div class="carousel-inner">'
        +'<div class="item active">'
        +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
        +'</div>'
        +'<div class="item">'
        +'<img src="<c:url value="'+banner1+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
        +'</div>'
        +'<div class="item">'
        +'<img src="<c:url value="'+banner2+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
        +'</div>'
        +'</div>'	          
        
        +'</div>'
        +'</div>'// carousel container 
        +'<div class="text-container">'
        +'<div style="display:flex;justify-content:space-between;align-items:center;font-family:Inter;">'
	       + '<span style="font-weight:700;font-size:16px;">' + publisher_name + '</span>'
	       + '<span style="font-weight:500;font-size:14px;color:#666;">' + distance + '</span>'
	       + '</div>'
        +'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+description+'</p>'
        <!--+'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+fullname+'</p>'-->
      <!--  +'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'-->
        +'</div>'
        +'</div>'//<!-- panel body --> 
        +'<div class="line" style ="width: 90%;    margin: 11px 11px;    border-top: 2px solid black;   opacity: 0.1; "></div>'
        +'<div class="panel-footer">'
        +'<div class="phone" id ="phone" onclick=phone('+phno+');><i class="fa fa-phone" style="font-size:20px;"></i></div>'
        +'<div class="whatsapp" id ="whatsapp" onclick=whatsapp('+whatsapp+');><i class="fa fa-whatsapp" style="font-size:20px;"></i></div>'
        +'<div class="email" id ="email"><i class="fa fa-envelope" style="font-size:20px;"></i></div>'
        +'<div class="takeme" ><button  id ="takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+'); style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Take me there</button></div>'
        +'</div>'
        +'</div>'
     	$('.ads').append(ad_card);
        
        noofresults++;

       
    const lattt =  addetails.location.lat; const longgg= addetails.location.lng ;

var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}

       	 
		 
		 
	$('#noofresults').html('Results: '+noofresults) ;    	 

    }
    var blueMarkers = [];
    function sendDefaultLocation(defaultLocation)
    {
    //	var defaultLocation = {latitude: 13.529271965260616, longitude: 75.36285138756304};
    	var defaultLocation = { coords: { latitude: 13.529271965260616,  longitude: 75.36285138756304 } };
    	//  console.log('send Default Location');
    	sendDefaultLocKoppa(defaultLocation);
    } 
  
    function sendLocation(position) {
    	if((latitudefromsession ==null && longitudefromsession==null)|| finallistofads==null){ //==null checks for both null and undefined
    	//	console.log('latitudefromsession if: ' +latitudefromsession);
   	    var  lat  = position.coords.latitude;
        var lng = position.coords.longitude;	  
    	}
    	else
    		{
    	//	   console.log('latitudefromsession else: ' +latitudefromsession);
    		   var lat  = latitudefromsession;
    	       var lng = longitudefromsession;	     		
    		}
   //    console.log('send Location');
      // const lat = position.lat;
      // const lng = position.lng;
       takemelat = lat;
       takemelng = lng;
      /* lastlat= lat;
       lastlng = lng;*/ //may not be necessary on 21-01-25 
       //console.log('last lat : ' +lat +'and: ' +lng);
     //  displayCurrentLocation(lat, lng);
     document.getElementById("currentlocationbutton").disabled = false;
     document.getElementById("pinlocationbutton").disabled = true;
   //    lat=13.529271965260616;  lng=75.36285138756304 ;
       
       onesinglelatitude=lat;onesinglelongitude = lng;//is this necessary?
       var latt = 13.529271965260616;
        var lngg = 75.36285138756304; 
        var k = 0;
        var results =0;
		fetch('${pageContext.request.contextPath}/location', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ lat, lng }),
        })
        .then(response => response.json())
        .then(data => {        	
        	//noofresults=data.length;
        	noofresults = data?.length || 0;
        	 $('#noofresults').html('Results: '+noofresults) ;
        	   document.getElementById("ads").innerHTML = "";
        	   if (distancebutton.classList.contains('inactivesort')) {
	        	    // Remove the class
	        	    distancebutton.classList.remove('inactivesort');
	        	    distancebutton.classList.add("activesort");
	        		distance=1;time=0;
	        		timebutton.classList.remove("activesort");
	        		timebutton.classList.add("inactivesort");
	        	} else {
	        	    // Add the class
	        	    //currentClasses.add('newClass');
	        	}
		        
        	   if (data?.length > 0) {    
       if(distance===1)
	 {	
	 let array = data;
	 let sortedArray=	array.sort(function(a, b) { return a.distance - b.distance; });
	 data = sortedArray;
	
	 }
 if (time===1)
	 {
	  
	    let dateTimeArray = data;
		let dateTimeArraySorted=dateTimeArray.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
		data = dateTimeArraySorted;
		// console.log('time =1' +JSON.stringify(data));
	 }
 currentAdsData= data;
 var m =0;
 $.each(data, function (i, myList) {
	console.log('in /location');
	
	// if(myList.giTag===1){
		 m++;
	//console.log('m: '+m);
 	 var adsid = myList.id;
 	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
 	//console.log('phno : ' +phno);
 	 var email= myList.emailAddress;
 	 var publisher_name = myList.a.title;var fullname = myList.fullName;
// 	 console.log('date sort: '+myList.dateRange.fromDate+'and : '+publisher_name);
 	 var description = myList.a.description;
 	 var dates = myList.dateRange.toDate;
 	const date = new Date(dates);
	var companyName='';
	var latitudes=myList.location.lat;
	var longitudes = myList.location.lng;
	var companyLogoUrl = myList.companies.companyLogoPath;
	var thumbnail = myList.a.thumbnail;
	//console.log('companyLogoUrl: ' +companyLogoUrl);
	var banner1="nopreview.jpg";
	var banner2 = "nopreview.jpg";
	var createdBy = myList.createdBy;
	if(myList.a.adType =='64887c11cce361dafc86c23b' ){
	var baners =  myList.a.content.banners;	  
	
// 	console.log('created by : ' + createdBy);
	if(baners !=null )
		{
		 banner1 = baners[0];
 	if(baners[1] != undefined ){    			
			 banner2 = baners[1];
		 }
		}
	}
 	if(myList.companies==null || myList.companies==undefined){
 	companyName=publisher_name;}
 	else{	     	 companyName= myList.companies.name;}

 // Create a formatter with custom options
 const formatter = new Intl.DateTimeFormat('en-GB', {
     day: 'numeric',
     month: 'long',
     year: 'numeric'
 });

 const formattedDate = formatter.format(date);
//  console.log(formattedDate); // e.g., "29 August 2024"
 	//onclick=nextui(this);
 	 var img_path = "";
 	 k++;
 	 var carouselid= 'myCarouselhome'+k;
 	 //onclick=nextui(this);

 	 
 	 
 	  var adContent = "";
 	/* if (myList.a.adType == '64887c11cce361dafc86c23c') {
 		   const videoUrl = myList.a.content.videoLink;
console.log('videoURL : ' +videoUrl);
if(videoUrl){
    const youtubeMatch = videoUrl.match(/(?:youtu\.be\/|youtube\.com\/(?:watch\?v=|embed\/))([\w-]+)/);
    if (youtubeMatch){
        const videoId = youtubeMatch[1];
        adContent = '<iframe width="100%" height="300" ' +
                    'src="https://www.youtube.com/embed/' + videoId + '?autoplay=1&mute=1&enablejsapi=1" ' +
                    'frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>';
    } else {
        adContent = '<video class="ad-video" width="100%" height="300" muted controls>' +
                        '<source src="' + videoUrl + '" type="video/mp4">' +
                        'Your browser does not support the video tag.' +
                    '</video>';
    }
} else {
    adContent = '<p>Video not available</p>';
}
 	} */
 	
 	  if (myList.a.adType == '64887c11cce361dafc86c23c') {
          const videoUrl = myList.a.content.videoLink;
          
          if (videoUrl) {
              const youtubeMatch = videoUrl.match(/(?:youtu\.be\/|youtube\.com\/(?:watch\?v=|embed\/))([\w-]+)/);
              
              if (youtubeMatch) {
                  // YOUTUBE VIDEO - CRITICAL: mute=1 for autoplay
                  const videoId = youtubeMatch[1];
                  var youtubePlayerId = 'youtube-player-' + k;
                  
                  adContent = '<iframe class="ad-video" id="' + youtubePlayerId + '" ' +
                              'width="100%" height="300" ' +
                              'src="https://www.youtube.com/embed/' + videoId + '?enablejsapi=1&mute=1&controls=1&rel=0&modestbranding=1" ' +
                              'frameborder="0" ' +
                              'allow="autoplay; encrypted-media" ' +
                              'allowfullscreen>' +
                              '</iframe>';
              } else {
                  // MP4 VIDEO
                  adContent = '<video class="ad-video" ' +
                              'width="100%" height="100%" ' +
                              'playsinline controls>' +
                              '<source src="' + videoUrl + '" type="video/mp4">' +
                              'Your browser does not support the video tag.' +
                              '</video>';
              }
          } else {
              adContent = '<p>Video not available</p>';
          }
      }
 	else {
 	    // Banner ad
 	    
 	   // console.log('banner ad');
 	    var carouselid = 'myCarouselhome' + (i + 1);
 	    var banner1 = myList.a.content.banners ? myList.a.content.banners[0] : 'nopreview.jpg';
 	    var banner2 = myList.a.content.banners ? myList.a.content.banners[1] : 'nopreview.jpg';

 	    adContent = '<div id="' + carouselid + '" class="carousel slide" data-ride="carousel">' +
 	                    '<div class="carousel-inner">' +
 	                        '<div class="item active">' +
 	                            '<img src="' + myList.a.thumbnail + '" style="width:100%; height:300px;" loading="lazy">' +
 	                        '</div>' +
 	                        '<div class="item">' +
 	                            '<img src="' + banner1 + '" style="width:100%; height:300px;" loading="lazy">' +
 	                        '</div>' +
 	                        '<div class="item">' +
 	                            '<img src="' + banner2 + '" style="width:100%; height:300px;" loading="lazy">' +
 	                        '</div>' +
 	                    '</div>' +
 	                    '<a class="left carousel-control" href="#' + carouselid + '" data-slide="prev">' +
 	                        '<span class="glyphicon glyphicon-chevron-left"></span>' +
 	                    '</a>' +
 	                    '<a class="right carousel-control" href="#' + carouselid + '" data-slide="next">' +
 	                        '<span class="glyphicon glyphicon-chevron-right"></span>' +
 	                    '</a>' +
 	                '</div>';
 	}

/* ad_card='<div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
    +'<div class="panel-heading">'
    +'<img src="<c:url value="'+companyLogoUrl+'" />" style="height:30px;width:30px;" alt="User profile" class="spotlightimg" loading="lazy"/>'
    +'<div id="frame20"><h5 id="publishername" style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">'+companyName+' </h5></div>'
    +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
    +'<div class="saved"><svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/></svg>'
    +'</div>'
    +'</div>'//heading 
    +'<div class="panel-body" style="padding:0px !important;" >'
    +'<div class="carousel-container">'
    +'<div  class="carousel slide" data-ride="carousel" id="'+carouselid+'">'      
            
    +'<div class="carousel-inner">'
    +'<div class="item active">'
    +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
    +'</div>'
    +'<div class="item">'
    +'<img src="<c:url value="'+banner1+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy" >'
    +'</div>'
    +'<div class="item">'
    +'<img src="<c:url value="'+banner2+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy" >'
    +'</div>'
    +'</div>'      
    
    +'</div>'
    +'</div>'// carousel container 
    +'<div class="text-container">'
    +'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;">'+publisher_name+'</p>'
    +'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+description+'</p>'
    +'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+fullname+'</p>'
    +'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'
    +'</div>'
    +'</div>'//<!-- panel body --> 
    +'<div class="line" style ="width: 90%;    margin: 11px 11px;    border-top: 2px solid black;   opacity: 0.1; "></div>'
    +'<div class="panel-footer">'
    +'<div class="phone" id ="phone" onclick=phone('+phno+');><i class="fa fa-phone" style="font-size:20px;"></i></div>'
    +'<div class="whatsapp" id ="whatsapp" onclick=whatsapp('+whatsapp+');><i class="fa fa-whatsapp" style="font-size:20px;"></i></div>'
    +'<div class="email" id ="email"><i class="fa fa-envelope" style="font-size:20px;"></i></div>'
    +'<div class="takeme" ><button  id ="takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+'); style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Take me there</button></div>'
    +'</div>'
    +'</div>'   */
    
    
    var ad_card = '<div class="panel panel-default" role="button" id="' + myList.id + '" onclick="nextui(this,\'' + myList.createdBy + '\');">' +
    '<div class="panel-heading">' +
        '<img src="' + myList.companies?.companyLogoPath + '" style="height:30px;width:30px;" alt="User profile" class="spotlightimg" loading="lazy"/>' +
        '<div id="frame20"><h5 style="font-family:Inter;font-weight:700;font-size:12px;">' + (myList.companies?.name || myList.a.title) + '</h5></div>' +
        '<div class="follow">' +
            '<button type="button" class="btn btn-default">Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size:12px;"></i></button>' +
        '</div>' +
        '<div class="saved">' +
            '<svg width="15" height="18" viewBox="0 0 15 18" fill="none">' +
                '<path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/>' +
            '</svg>' +
        '</div>' +
    '</div>' +
    '<div class="panel-body" style="padding:0;">' +
        adContent +
        '<div class="text-container">' +
            '<p style="font-family:Inter;font-weight:700;font-size:16px;">' + myList.a.title + '</p>' +
            '<p style="font-family:Inter;font-weight:400;font-size:12px;">' + myList.a.description + '</p>' +
            <!--'<p style="font-family:Inter;font-weight:400;font-size:12px;">' + myList.fullName + '</p>' +-->
           <!-- '<p style="font-family:Inter;font-weight:400;font-size:12px;color:#FF1515;opacity:0.5;">Expires on ' + new Date(myList.dateRange.toDate).toLocaleDateString('en-GB', { day:'numeric', month:'long', year:'numeric' }) + '</p>' +-->
        '</div>' +
    '</div>' +
    '<div class="line" style="width:90%;margin:11px;border-top:2px solid black;opacity:0.1;"></div>' +
    '<div class="panel-footer">' +
        '<div class="phone" onclick="phone(' + myList.phoneNumber + ');"><i class="fa fa-phone" style="font-size:20px;"></i></div>' +
        '<div class="whatsapp" onclick="whatsapp(' + myList.whatsappNumber + ');"><i class="fa fa-whatsapp" style="font-size:20px;"></i></div>' +
        '<div class="email"><i class="fa fa-envelope" style="font-size:20px;"></i></div>' +
        '<div class="takeme">' +
            '<button id ="takeme" data-lat="' + myList.location.lat + '" data-long="' + myList.location.lng + '" onclick="takeme(' + myList.location.lat + ',' + myList.location.lng + ');" style="font-size:14px;">' +
                '<i class="glyphicon glyphicon-map-marker"></i>Take me there' +
            '</button>' +
        '</div>' +
    '</div>' +
'</div>';
 	 $('.ads').append(ad_card); 

 	 
 <!--	'<div class="takeme" ><button  id ="takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+'); style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Take me there</button></div>'-->
    //onclick=phone('+phno+');
//var dist=getDistanceFromLatLonInKm(myList.location.lat,myList.location.lng,latt,lngg).toFixed(1);
//locations.push(  [myList.location.lat,myList.location.lng,publisher_name,publisher_name]);
//console.log('dist value is :' +dist);
//if(dist<=1.3)	{}	 
results++;
	 //}
    	  }); //.each
    	  
 setTimeout(function() {
	    console.log('Calling observeVideos after delay');
	    observeVideos();
	}, 1500);
    		        	  
     	}//if*/
        	else 
        		{
        		   var contentDiv = document.querySelector(".ads");
                const text = document.createTextNode("No ads in this region. To see advertisements in the nearby area ");// Create the text node

              
                const link = document.createElement("a");  // Create the hyperlink element
               // link.href = "https://www.example.com";  // Set the hyperlink destination
                link.textContent = "Click Here";  // Set the link text
                link.addEventListener("click", function(event) {
                    event.preventDefault(); // Prevent the default action (optional, if you don't want to navigate)
                    var defaultLocation = { coords: { latitude: 13.529271965260616,  longitude: 75.36285138756304 } };
              	  console.log('send Default Location');
              	sendDefaultLocation(defaultLocation);
                    
                });
                
                contentDiv.appendChild(text);// Append the text node and the hyperlink to the div
                contentDiv.appendChild(link);
        		 
        		}
        		
        	
        })//.then
        .catch((error) => {
        	//console.log('in else catch: ' );
     //   	var defaultLocation = {lat: 13.529271965260616, lng: 75.36285138756304};
    //    	sendDefaultLocation(defaultLocation);
      //      console.error("Geolocation is not supported by this browser.");
      
          console.error('Error:', error);
        });
    }
    getLocation();  
 // After appending all ad cards
 
    async function getAdsFromSession()
    {
    	onesinglelatitude=latitudefromsession;onesinglelongitude = longitudefromsession;

		/* if(currentLocationsetfromsess==true)
		 {
			 document.getElementById("currentlocationbutton").disabled = false;
	   	  document.getElementById("pinlocationbutton").disabled = true;
		 }
	 else
		 {
		 document.getElementById("currentlocationbutton").disabled = true;
		  document.getElementById("pinlocationbutton").disabled = false;
		 }*/
    	 const response = await fetch('<%=request.getContextPath()%>/responsivelocationsfromsession');
	        var data = await response.json();
	       // console.log('Data : ' +JSON.stringify(data));
    	  var k = 0;
    	  var results =0;
    	  
    	  var lat  = latitudefromsession;
	       var lng = longitudefromsession;	     		
	
  takemelat = lat;
  takemelng = lng;
 /* lastlat= lat;
  lastlng = lng;*/ //may not be necessary on 21-01-25 
  //console.log('last lat : ' +lat +'and: ' +lng);
  //displayCurrentLocation(lat, lng);
    //	noofresults=data.length;
    noofresults = data?.length || 0;
   	 $('#noofresults').html('Results: '+noofresults) ;
   	   document.getElementById("ads").innerHTML = "";
   	   if (distancebutton.classList.contains('inactivesort')) {
       	    // Remove the class
       	    distancebutton.classList.remove('inactivesort');
       	    distancebutton.classList.add("activesort");
       		distance=1;time=0;
       		timebutton.classList.remove("activesort");
       		timebutton.classList.add("inactivesort");
       	} else {
       	    // Add the class
       	    //currentClasses.add('newClass');
       	}
	        
  // 	if((data.length>0)){
	  if (data?.length > 0) {
  if(distance===1)
{	
let array = data;
let sortedArray=	array.sort(function(a, b) { return a.distance - b.distance; });
data = sortedArray;

}
if (time===1)
{
 
   let dateTimeArray = data;
	let dateTimeArraySorted=dateTimeArray.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
	data = dateTimeArraySorted;
	// console.log('time =1' +JSON.stringify(data));
}
currentAdsData= data;
var m =0;
$.each(data, function (i, myList) {
// console.log('mylist.giTag: ' +JSON.stringify(myList));

//if(myList.giTag===1){
	 m++;
//console.log('m: '+m);
 var adsid = myList.id;
 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
//console.log('phno : ' +phno);
 var email= myList.emailAddress;
 var publisher_name = myList.a.title;var fullname = myList.fullName;var distance = myList.distance.toFixed(2);
// console.log('date sort: '+myList.dateRange.fromDate+'and : '+publisher_name);
 var description = myList.a.description;
 var dates = myList.dateRange.toDate;
const date = new Date(dates);
var companyName='';
var latitudes=myList.location.lat;
var longitudes = myList.location.lng;
var companyLogoUrl = myList.companies.companyLogoPath;
var thumbnail = myList.a.thumbnail;

var banner1="nopreview.jpg";
var banner2 = "nopreview.jpg";
var createdBy = myList.createdBy;
if(myList.a.adType =='64887c11cce361dafc86c23b' ){
var baners =  myList.a.content.banners;	  

//console.log('created by : ' + createdBy);
if(baners !=null )
	{
	 banner1 = baners[0];
if(baners[1] != undefined ){    			
		 banner2 = baners[1];
	 }
	}
}
if(myList.companies==null || myList.companies==undefined){
companyName=publisher_name;}
else{	     	 companyName= myList.companies.name;}

// Create a formatter with custom options
const formatter = new Intl.DateTimeFormat('en-GB', {
day: 'numeric',
month: 'long',
year: 'numeric'
});

const formattedDate = formatter.format(date);
//console.log(formattedDate); // e.g., "29 August 2024"
//onclick=nextui(this);
 var img_path = "";
 k++;
 var carouselid= 'myCarouselhome'+k;
 //onclick=nextui(this);
 
 	 
 	  var adContent = "";
 	  if (myList.a.adType == '64887c11cce361dafc86c23c') {
          const videoUrl = myList.a.content.videoLink;
          
          if (videoUrl) {
              const youtubeMatch = videoUrl.match(/(?:youtu\.be\/|youtube\.com\/(?:watch\?v=|embed\/))([\w-]+)/);
              
              if (youtubeMatch) {
                  // YOUTUBE VIDEO - CRITICAL: mute=1 for autoplay
                  const videoId = youtubeMatch[1];
                  var youtubePlayerId = 'youtube-player-' + k;
                  
                  adContent = '<iframe class="ad-video" id="' + youtubePlayerId + '" ' +
                              'width="100%" height="300" ' +
                              'src="https://www.youtube.com/embed/' + videoId + '?enablejsapi=1&mute=1&controls=1&rel=0&modestbranding=1" ' +
                              'frameborder="0" ' +
                              'allow="autoplay; encrypted-media" ' +
                              'allowfullscreen>' +
                              '</iframe>';
              } else {
                  // MP4 VIDEO
                  adContent = '<video class="ad-video" ' +
                              'width="100%" height="300" ' +
                              'playsinline controls>' +
                              '<source src="' + videoUrl + '" type="video/mp4">' +
                              'Your browser does not support the video tag.' +
                              '</video>';
              }
          } else {
              adContent = '<p>Video not available</p>';
          }
      } else {
 	    // Banner ad
 	    
 	//    console.log('banner ad');
 	    var carouselid = 'myCarouselhome' + (i + 1);
 	    var banner1 = myList.a.content.banners ? myList.a.content.banners[0] : 'nopreview.jpg';
 	    var banner2 = myList.a.content.banners ? myList.a.content.banners[1] : 'nopreview.jpg';

 	    adContent = '<div id="' + carouselid + '" class="carousel slide" data-ride="carousel">' +
 	                    '<div class="carousel-inner">' +
 	                        '<div class="item active">' +
 	                            '<img src="' + myList.a.thumbnail + '" style="width:100%; height:300px;" loading="lazy">' +
 	                        '</div>' +
 	                        '<div class="item">' +
 	                            '<img src="' + banner1 + '" style="width:100%; height:300px;" loading="lazy">' +
 	                        '</div>' +
 	                        '<div class="item">' +
 	                            '<img src="' + banner2 + '" style="width:100%; height:300px;" loading="lazy">' +
 	                        '</div>' +
 	                    '</div>' +
 	                    '<a class="left carousel-control" href="#' + carouselid + '" data-slide="prev">' +
 	                        '<span class="glyphicon glyphicon-chevron-left"></span>' +
 	                    '</a>' +
 	                    '<a class="right carousel-control" href="#' + carouselid + '" data-slide="next">' +
 	                        '<span class="glyphicon glyphicon-chevron-right"></span>' +
 	                    '</a>' +
 	                '</div>';
 	}

/*var ad_card='<div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
+'<div class="panel-heading">'
+'<img src="<c:url value="'+companyLogoUrl+'" />" style="height:30px;width:30px;" alt="User profile" class="spotlightimg" loading="lazy"/>'
+'<div id="frame20"><h5 id="publishername" style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">'+companyName+' </h5></div>'
+'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
+'<div class="saved"><svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/></svg>'
+'</div>'
+'</div>'//heading 
+'<div class="panel-body" style="padding:0px !important;" >'
+'<div class="carousel-container">'
+'<div  class="carousel slide" data-ride="carousel" id="'+carouselid+'">'      
       
+'<div class="carousel-inner">'
+'<div class="item active">'
+'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
+'</div>'
+'<div class="item">'
+'<img src="<c:url value="'+banner1+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy" >'
+'</div>'
+'<div class="item">'
+'<img src="<c:url value="'+banner2+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy" >'
+'</div>'
+'</div>'      

+'</div>'
+'</div>'// carousel container 
+'<div class="text-container">'
+'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;">'+publisher_name+'</p>'
+'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+description+'</p>'
+'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+fullname+'</p>'
+'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'
+'</div>'
+'</div>'//<!-- panel body --> 
+'<div class="line" style ="width: 90%;    margin: 11px 11px;    border-top: 2px solid black;   opacity: 0.1; "></div>'
+'<div class="panel-footer">'
+'<div class="phone" id ="phone" onclick=phone('+phno+');><i class="fa fa-phone" style="font-size:20px;"></i></div>'
+'<div class="whatsapp" id ="whatsapp" onclick=whatsapp('+whatsapp+');><i class="fa fa-whatsapp" style="font-size:20px;"></i></div>'
+'<div class="email" id ="email"><i class="fa fa-envelope" style="font-size:20px;"></i></div>'
+'<div class="takeme" ><button  id ="takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+'); style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Take me there</button></div>'
+'</div>'
+'</div>'*/
if(vehiclead!=1 &&   !( [
    busenabled,
    carenabled,
    rickshawenabled,
    goodsenabled
].some(v => v === 1) )){
var ad_card = '<div class="panel panel-default" role="button" id="' + myList.id + '" onclick="nextui(this,\'' + myList.createdBy + '\');">' +
'<div class="panel-heading">' +
    '<img src="' + myList.companies?.companyLogoPath + '" style="height:30px;width:30px;" alt="User profile" class="spotlightimg" loading="lazy"/>' +
    '<div id="frame20"><h5 style="font-family:Inter;font-weight:700;font-size:12px;">' + (myList.companies?.name || myList.a.title) + '</h5></div>' +
    '<div class="follow">' +
        '<button type="button" class="btn btn-default">Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size:12px;"></i></button>' +
    '</div>' +
    '<div class="saved">' +
        '<svg width="15" height="18" viewBox="0 0 15 18" fill="none">' +
            '<path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/>' +
        '</svg>' +
    '</div>' +
'</div>' +
'<div class="panel-body" style="padding:0;">' +
    adContent +
    '<div class="text-container">' +
        '<p style="font-family:Inter;font-weight:700;font-size:16px;">' + myList.a.title + '</p>' +
        '<p style="font-family:Inter;font-weight:400;font-size:12px;">' + myList.a.description + '</p>' +
        <!--'<p style="font-family:Inter;font-weight:400;font-size:12px;">' + myList.fullName + '</p>' +-->
       <!-- '<p style="font-family:Inter;font-weight:400;font-size:12px;color:#FF1515;opacity:0.5;">Expires on ' + new Date(myList.dateRange.toDate).toLocaleDateString('en-GB', { day:'numeric', month:'long', year:'numeric' }) + '</p>' +-->
    '</div>' +
'</div>' +
'<div class="line" style="width:90%;margin:11px;border-top:2px solid black;opacity:0.1;"></div>' +
'<div class="panel-footer">' +
    '<div class="phone" onclick="phone(' + myList.phoneNumber + ');"><i class="fa fa-phone" style="font-size:20px;"></i></div>' +
    '<div class="whatsapp" onclick="whatsapp(' + myList.whatsappNumber + ');"><i class="fa fa-whatsapp" style="font-size:20px;"></i></div>' +
    '<div class="email"><i class="fa fa-envelope" style="font-size:20px;"></i></div>' +
    '<div class="takeme">' +
        '<button  id ="takeme" data-lat="' + myList.location.lat + '" data-long="' + myList.location.lng + '" onclick="takeme(' + myList.location.lat + ',' + myList.location.lng + ');" style="font-size:14px;">' +
            '<i class="glyphicon glyphicon-map-marker"></i>Take me there' +
        '</button>' +
    '</div>' +
'</div>' +
'</div>';
}
else
	{
	var ad_card = '<div class="panel panel-default" role="button" id="' + myList.id + '" onclick="nextui(this,\'' + myList.createdBy + '\');">' +
	'<div class="panel-heading">' +
	    '<img src="' + myList.companies?.companyLogoPath + '" style="height:30px;width:30px;" alt="User profile" class="spotlightimg" loading="lazy"/>' +
	    '<div id="frame20"><h5 style="font-family:Inter;font-weight:700;font-size:12px;">' + (myList.companies?.name || myList.a.title) + '</h5></div>' +
	    '<div class="follow">' +
	        '<button type="button" class="btn btn-default">Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size:12px;"></i></button>' +
	    '</div>' +
	    '<div class="saved">' +
	        '<svg width="15" height="18" viewBox="0 0 15 18" fill="none">' +
	            '<path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/>' +
	        '</svg>' +
	    '</div>' +
	'</div>' +
	'<div class="panel-body" style="padding:0;">' +
	    adContent +
	    '<div class="text-container">' 
	        <!--'<p style="font-family:Inter;font-weight:700;font-size:16px;">' + myList.a.title + '</p>' +-->
	        +'<div style="display:flex;justify-content:space-between;align-items:center;font-family:Inter;">'
	        + '<span style="font-weight:700;font-size:16px;">' + publisher_name + '</span>'
	        + '<span style="font-weight:500;font-size:14px;color:#666;">' + distance + '</span>'
	        + '</div>'
	        +'<p style="font-family:Inter;font-weight:400;font-size:12px;">' + myList.a.description + '</p>' +
	        <!--'<p style="font-family:Inter;font-weight:400;font-size:12px;">' + myList.fullName + '</p>' +-->
	       <!-- '<p style="font-family:Inter;font-weight:400;font-size:12px;color:#FF1515;opacity:0.5;">Expires on ' + new Date(myList.dateRange.toDate).toLocaleDateString('en-GB', { day:'numeric', month:'long', year:'numeric' }) + '</p>' +-->
	    '</div>' +
	'</div>' +
	'<div class="line" style="width:90%;margin:11px;border-top:2px solid black;opacity:0.1;"></div>' +
	'<div class="panel-footer">' +
	    '<div class="phone" onclick="phone(' + myList.phoneNumber + ');"><i class="fa fa-phone" style="font-size:20px;"></i></div>' +
	    '<div class="whatsapp" onclick="whatsapp(' + myList.whatsappNumber + ');"><i class="fa fa-whatsapp" style="font-size:20px;"></i></div>' +
	    '<div class="email"><i class="fa fa-envelope" style="font-size:20px;"></i></div>' +
	    '<div class="takeme">' +
	        '<button  id ="takeme" data-lat="' + myList.location.lat + '" data-long="' + myList.location.lng + '" onclick="takeme(' + myList.location.lat + ',' + myList.location.lng + ',\'' + myList.id + '\');" style="font-size:14px;">' +
	            '<i class="glyphicon glyphicon-map-marker"></i>Show Location' +
	        '</button>' +
	    '</div>' +
	'</div>' +
	'</div>';
	}
 $('.ads').append(ad_card); 

//onclick=phone('+phno+');
//var dist=getDistanceFromLatLonInKm(myList.location.lat,myList.location.lng,latt,lngg).toFixed(1);
//locations.push(  [myList.location.lat,myList.location.lng,publisher_name,publisher_name]);
//console.log('dist value is :' +dist);
//if(dist<=1.3)	{}	 
results++;
//}
	  }); //.each
	
setTimeout(function() {
    console.log('Calling observeVideos after delay');
    observeVideos();
}, 1500);  
   	}//if
   	else 
   		{
   		   var contentDiv = document.querySelector(".ads");
           const text = document.createTextNode("No ads in this region. To see advertisements in the nearby area ");// Create the text node

         
           const link = document.createElement("a");  // Create the hyperlink element
          // link.href = "https://www.example.com";  // Set the hyperlink destination
           link.textContent = "Click Here";  // Set the link text
           link.addEventListener("click", function(event) {
               event.preventDefault(); // Prevent the default action (optional, if you don't want to navigate)
               var defaultLocation = { coords: { latitude: 13.529271965260616,  longitude: 75.36285138756304 } };
         	  console.log('send Default Location');
         	sendDefaultLocation(defaultLocation);
               
           });
           
           contentDiv.appendChild(text);// Append the text node and the hyperlink to the div
           contentDiv.appendChild(link);
   		 
   		}
    	
    }
    function sendDefaultLocKoppa(position) {
    	    	//	console.log('sendDefaultLocKoppa: ' +latitudefromsession);
   	    var  lat  = position.coords.latitude;
        var lng = position.coords.longitude;	    	
   //    console.log('send Location');
      // const lat = position.lat;
      // const lng = position.lng;
       takemelat = lat;
       takemelng = lng;
      /* lastlat= lat;
       lastlng = lng;*/ //may not be necessary on 21-01-25 
       //console.log('last lat : ' +lat +'and: ' +lng);
   //    displayCurrentLocation(lat, lng);
   //    lat=13.529271965260616;  lng=75.36285138756304 ;
       
       onesinglelatitude=lat;onesinglelongitude = lng;//is this necessary?
       var latt = 13.529271965260616;        var lngg = 75.36285138756304; 
        var k = 0;
        var results =0;
        document.getElementById("currentlocationbutton").disabled = true;
  	  document.getElementById("pinlocationbutton").disabled = false;
		fetch('${pageContext.request.contextPath}/locationkoppa', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ lat, lng }),
        })
        .then(response => response.json())
        .then(data => {        	
        	noofresults=data.length;
        	 $('#noofresults').html('Results: '+noofresults) ;
        	   document.getElementById("ads").innerHTML = "";
        	 //  let dateTimeArraySorted1=data.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
       		//data = dateTimeArraySorted1;
       		
   if (distancebutton.classList.contains('inactivesort')) {
	        	    // Remove the class
	        	    distancebutton.classList.remove('inactivesort');
	        	    distancebutton.classList.add("activesort");
	        		distance=1;time=0;
	        		timebutton.classList.remove("activesort");
	        		timebutton.classList.add("inactivesort");
	        	} else {
	        	    // Add the class
	        	    //currentClasses.add('newClass');
	        	}
		         if(distance===1)
	 {	
	 let array = data;
	 let sortedArray=	array.sort(function(a, b) { return a.distance - b.distance; });
	 data = sortedArray;

	 }
 if (time===1)
	 {
	 
	    let dateTimeArray = data;
		let dateTimeArraySorted=dateTimeArray.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
		data = dateTimeArraySorted;
		
	 }
 currentAdsData= data;
  	  $.each(data, function (i, myList) {	
	     	 var adsid = myList.id;
	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
	     	// console.log('distance : ' +myList.distance +'name : ' +myList.a.title);
	     	 var email= myList.emailAddress;
	     	 var publisher_name = myList.a.title;
	    // 	 console.log('date sort: '+myList.dateRange.fromDate+'and : '+publisher_name);
	     	 var description = myList.a.description; var fullname = myList.fullName;
	     	 var dates = myList.dateRange.toDate;
	     	const date = new Date(dates);
	    	var companyName='';
	    	var latitudes=myList.location.lat;
	    	var longitudes = myList.location.lng;
	    	var companyLogoUrl = myList.companies.companyLogoPath;
	    	var thumbnail = myList.a.thumbnail;
	    	//console.log('companyLogoUrl: ' +companyLogoUrl);
	    	var banner1="nopreview.jpg";
	    	var banner2 = "nopreview.jpg";
	    	var createdBy = myList.createdBy;
	    	if(myList.a.adType =='64887c11cce361dafc86c23b' ){
	    	var baners =  myList.a.content.banners;	  
	    	
	   // 	console.log('created by : ' + createdBy);
	    	if(baners !=null )
	    		{
	    		 banner1 = baners[0];
	     	if(baners[1] != undefined ){    			
	    			 banner2 = baners[1];
	    		 }
	    		}
	    	}
	     	if(myList.companies==null || myList.companies==undefined){
	     	companyName=publisher_name;}
	     	else{	     	 companyName= myList.companies.name;}
		
	     // Create a formatter with custom options
	     const formatter = new Intl.DateTimeFormat('en-GB', {
	         day: 'numeric',
	         month: 'long',
	         year: 'numeric'
	     });

	     const formattedDate = formatter.format(date);
	   //  console.log(formattedDate); // e.g., "29 August 2024"
	     	//onclick=nextui(this);
	     	 var img_path = "";
	     	 k++;
	     	 var carouselid= 'myCarouselhome'+k;
	     	 //onclick=nextui(this);
	 

var ad_card='<div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
            +'<div class="panel-heading">'
            +'<img src="<c:url value="'+companyLogoUrl+'" />" style="height:30px;width:30px;" alt="User profile" class="spotlightimg" loading="lazy"/>'
            +'<div id="frame20"><h5 id="publishername" style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">'+companyName+' </h5></div>'
            +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
            +'<div class="saved"><svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/></svg>'
            +'</div>'
            +'</div>'//heading 
            +'<div class="panel-body" style="padding:0px !important;" >'
            +'<div class="carousel-container">'
            +'<div  class="carousel slide" data-ride="carousel" id="'+carouselid+'">'
            
            
            +'<div class="carousel-inner">'
            +'<div class="item active">'
            +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
            +'</div>'
            +'<div class="item">'
            +'<img src="<c:url value="'+banner1+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy" >'
            +'</div>'
            +'<div class="item">'
            +'<img src="<c:url value="'+banner2+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy" >'
            +'</div>'
            +'</div>'
           
            
            +'</div>'
            +'</div>'// carousel container 
            +'<div class="text-container">'
            +'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;">'+publisher_name+'</p>'
            +'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+description+'</p>'
            <!--+'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+fullname+'</p>'-->
            <!--+'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'-->
            +'</div>'
            +'</div>'//<!-- panel body --> 
            +'<div class="line" style ="width: 90%;    margin: 11px 11px;    border-top: 2px solid black;   opacity: 0.1; "></div>'
            +'<div class="panel-footer">'
            +'<div class="phone" id ="phone" onclick=phone('+phno+');><i class="fa fa-phone" style="font-size:20px;"></i></div>'
            +'<div class="whatsapp" id ="whatsapp" onclick=whatsapp('+whatsapp+');><i class="fa fa-whatsapp" style="font-size:20px;"></i></div>'
            +'<div class="email" id ="email"><i class="fa fa-envelope" style="font-size:20px;"></i></div>'
            +'<div class="takeme" ><button  id ="takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+'); style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Take me there</button></div>'
            +'</div>'
            +'</div>'
	     	 $('.ads').append(ad_card); 
	
            //onclick=phone('+phno+');
//var dist=getDistanceFromLatLonInKm(myList.location.lat,myList.location.lng,latt,lngg).toFixed(1);
//locations.push(  [myList.location.lat,myList.location.lng,publisher_name,publisher_name]);
//console.log('dist value is :' +dist);
//if(dist<=1.3)	{}	 
results++;
	        	  }); //.each
		
        	
        })//.then
        .catch((error) => {
        	//console.log('in else catch: ' );
     //   	var defaultLocation = {lat: 13.529271965260616, lng: 75.36285138756304};
    //    	sendDefaultLocation(defaultLocation);
      //      console.error("Geolocation is not supported by this browser.");
      
          console.error('Error:', error);
        });
    }
})//dom
//to fetch the location and load the ads end here
//on click of reset starts here
$( '#reset' ).on( "click", function(e) {
    		// console.log('on reset');
    		 //$("#hand").show();
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
  		         
  		            
  		        }
  		        
  		 });
              const b = document.querySelectorAll('.dynamic-button');
              b.forEach(button => button.remove());
              categories=[];
             // categories=null;
    		 
    	 });
//on click of reset end here 

//on click of apply start here 
$( '#apply' ).on( "click", function(e) {
    		
    		  bottomSheet.classList.remove("show");
	            setTimeout(function() {
	                bottomSheet.style.display = "none";
	            }, 100); // Wait for the animation to finish before hiding
    		 var k=0;
    		 var results =0;
    		 $.ajax({
    		        // Our sample url to make request 
    		        url:"${pageContext.request.contextPath}/categories",
    		        type: "POST",
    		        contentType : 'application/json',
    		        dataType : 'json',
    		        data: JSON.stringify(categories), // Convert array to JSON string 
    		        success: function (data) {
    		          //  let x = JSON.stringify(data);
    		         //   console.log('in categories success : ' +x);
    		            document.getElementById("ads").innerHTML = "";
    		        	//noofresults=data.length;
    		        	noofresults=0;
    		        	if (distancebutton.classList.contains('inactivesort')) {
    		        	    // Remove the class
    		        	    distancebutton.classList.remove('inactivesort');
    		        	    distancebutton.classList.add("activesort");
    		        		distance=1;time=0;
    		        		timebutton.classList.remove("activesort");
    		        		timebutton.classList.add("inactivesort");
    		        	} else {
    		        	    
    		        	}
    			         if(distance===1)
    		 {	
    		 let array = data;
    		 let sortedArray=	array.sort(function(a, b) { return a.distance - b.distance; });
    		 data = sortedArray;

    		 }
    	 if (time===1)
    		 {
    		 
    		    let dateTimeArray = data;
    			let dateTimeArraySorted=dateTimeArray.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
    			data = dateTimeArraySorted;
    			
    		 }
    		        	currentAdsData=data;
    		        	//console.log('noofresults: ' +noofresults);
    		        	 //$('#noofresults').html('Results: '+noofresults) ;
    		         /*   for (var i = 0; i < markers.length; i++) {
    		 	   markers[i].setMap(null); // Remove marker from the map
    		 	 
    		 	  // locations[i]=null;
    		       }
    		    locations = []; // Clear the array of markers
    		    circles.forEach(circle => {
    		        circle.setMap(null); // Remove circle from the map
    		    });
    		    circles.length = 0; // Clear the array
    		  /*  var dist=getDistanceFromLatLonInKm(myList.location.lat,myList.location.lng,lat,lng).toFixed(1);
    		    //console.log('dist value is :' +dist);   
    		    if(dist<=1.3)
    		    	{	locations.push(  [myList.location.lat,myList.location.lng,publisher_name,publisher_name,dist]);}*/
    		    	/* if(gitagenabled===1){
    		             $.each(data, function (i, myList) {
    		   	     	//  console.log('data in current location: ' +data);

    		    	
    		    	 else{*/
    		    		 
    		    		
    		    		 $.each(data, function (i, myList) {
   		        		 
   		        						 var adsid = myList.id;
   		     	     	 				 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
   		     	     	
   		     	     					 var email= myList.emailAddress;
   		         		    	     	 var publisher_name = myList.a.title;
   		         		    	  
   		         		    	     	 var description = myList.a.description;var fullname = myList.fullName;
   		         		    	     	 var dates = myList.dateRange.toDate;
   		         		    	     	const date = new Date(dates);
   		         		    	    	var companyName='';
   		         		    	    	var latitudes=myList.location.lat;
   		         		    	    	var longitudes = myList.location.lng;
   		         		    	    	var companyLogoUrl = myList.companies.companyLogoPath;
   		         		    	    	var thumbnail = myList.a.thumbnail;
   		         		    	    
   		         		    	    	var banner1="nopreview.jpg";
   		         		    	    	var banner2 = "nopreview.jpg";	var createdBy = myList.createdBy;
   		         		    	    	if(myList.a.adType =='64887c11cce361dafc86c23b' ){
   		         		    	    	var baners =  myList.a.content.banners;
   		         		    	    		    	
   		         		    	    	if(baners !=null )
   		         		    	    		{
   		         		    	    		 banner1 = baners[0];    		    	    		
   		         		    	    	//console.log('inside if baners!=null');
   		         		    	    		 if(baners[1] != undefined ){  		 	    		
   		         		    	    			 banner2 = baners[1];
   		         		    	    		 }
   		         		    	    		}
   		         		    	    	}
   		         		    	     	if(myList.companies==null || myList.companies==undefined){//console.log('inside if'+publisher_name);
   		         		    	     	companyName=publisher_name;}
   		         		    	     	else{	     	 companyName= myList.companies.name;}
   		         		    			//console.log('company name : '+companyName);
   		         		    	     
   		         		    	     // Create a formatter with custom options
   		         		    	     const formatter = new Intl.DateTimeFormat('en-GB', {
   		         		    	         day: 'numeric',
   		         		    	         month: 'long',
   		         		    	         year: 'numeric'
   		         		    	     });

   		         		    	     const formattedDate = formatter.format(date);
   		         		    	   //  console.log(formattedDate); // e.g., "29 August 2024"
   		         		    	     	
   		         		    	     	 var img_path = ""; k++;
   		         		    	     	 var carouselid= 'myCarouselhome'+k;
   		         		    	     	var ad_card='<div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
   		         		    	            +'<div class="panel-heading">'
   		         		    	            +'<img src="<c:url value="'+companyLogoUrl+'" />"  style="height:30px;width:30px;" alt="User profile" class="spotlightimg" loading="lazy"/>'
   		         		    	            +'<div id="frame20"><h5 id="publishername" style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">'+companyName+' </h5></div>'
   		         		    	            +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
   		         		    	            +'<div class="saved"><svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/></svg>'
   		         		    	            +'</div>'
   		         		    	            +'</div>'//heading 
   		         		    	            +'<div class="panel-body" style="padding:0px !important;">'
   		         		    	            +'<div class="carousel-container">'
   		         		    	            +'<div  class="carousel slide" data-ride="carousel" id="'+carouselid+'">'
   		         		    	            
   		         		    	            
   		         		    	            +'<div class="carousel-inner">'
   		         		    	            +'<div class="item active">'
   		         		    	            +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
   		         		    	            +'</div>'
   		         		    	            +'<div class="item">'
   		         		    	            +'<img src="<c:url value="'+banner1+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy"> '
   		         		    	            +'</div>'
   		         		    	            +'<div class="item">'
   		         		    	            +'<img src="<c:url value="'+banner2+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
   		         		    	            +'</div>'
   		         		    	            +'</div>'
   		         		    	           
   		         		    	            
   		         		    	            +'</div>'
   		         		    	            +'</div>'// carousel container 
   		         		    	            +'<div class="text-container">'
   		         		    	            +'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;">'+publisher_name+'</p>'
   		         		    	            +'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+description+'</p>'
   		         		    	        <!--+'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+fullname+'</p>'-->
   		         		    	         <!--   +'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'-->
   		         		    	            +'</div>'
   		         		    	            +'</div>'//<!-- panel body --> 
   		         		    	            +'<div class="line" style ="width: 90%;    margin: 11px 11px;    border-top: 2px solid black;   opacity: 0.1; "></div>'
   		         		    	            +'<div class="panel-footer">'
   		         		    	            +'<div class="phone" id ="phone" onclick=phone('+phno+');><i class="fa fa-phone" style="font-size:20px;"></i></div>'
   		         		    	            +'<div class="whatsapp" id ="whatsapp" onclick=whatsapp('+whatsapp+');><i class="fa fa-whatsapp" style="font-size:20px;"></i></div>'
   		         		    	            +'<div class="email" id ="email"><i class="fa fa-envelope" style="font-size:20px;"></i></div>'
   		         		    	            +'<div class="takeme" ><button  id ="takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+'); style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Take me there</button></div>'
   		         		    	            +'</div>'
   		         		    	            +'</div>'
   		         		    		     	 $('.ads').append(ad_card); 
   		         		    	            noofresults++;
   		        		  
   		    		 });
    		    		 
    		    	
    		    	 $('#noofresults').html('Results: '+noofresults) ;	 
    		    	        	  
    		        }//success
    		 });//ajax
});
//on click of apply end here 

//to close bottom on outside touch start here
//var modal = document.getElementById("bottom-sheet");
//var modal = document.getElementsByClassName("bottom-sheet");
/*window.onclick = function(event) {
	console.log('window1');
    if (event.target == modal) {
    	console.log('window');
        modal.style.display = "none";
    }*/
    
   /* $(document).click(function(event) {
        if (!$(event.target).closest("#bottom-sheet").length) {
        	console.log('window1');
            $("#bottom-sheet").hide();
        }
    });
*/
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
var phoneorwhatsapp=0;var telphno;
function phone(phno)
		{
	//var  e = encodeURIComponent(phno);
		
		//	console.log('phone number is : '+phno);
			telphno =phno;
			//console.log('value of mob on phone click: ' +mob);
		    event.stopPropagation(); 
		    phoneorwhatsapp=1;// to keep track of whether phone or whatsapp is clicked
			$.ajax({
                url: '${pageContext.request.contextPath}/getSessionVariable',
                method: 'GET',
                async:false,
                success: function(data) {
                 //   alert(data); // Outputs the session variable value
                // console.log('in success');
                 mob=data;
            //	 getsessionvalue(mob);
                 //console.log("mob1");
                },
                error: function(xhr, status, error) {
                   // console.error("Error fetching session variable: ", error);
                }
            });
			if(mob=="")
				{
			//console.log('console.log("mob2"); ' +mob);
				$('#loginModal').modal('show');	
				}
			else
				{
			  /*  const div = document.getElementById('callme');
			    div.textContent = phno;
				$('#showphno').modal('show');	*/
				//console.log("mob3");
				//phno ='+91'+phno;
				//console.log('phone number is : '+phno);
				window.location.href = "tel:" + phno;
				}			
		}	
		
function takeme(lats,lngs)
{
	
	 event.stopPropagation();

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
   // console.log('originLat: ' +originLat +','+originLng+','+destinationLat+','+destinationLng);
    var mapsUrl = 'https://www.google.com/maps/dir/?api=1&origin='+originLat+','+originLng+'&destination='+destinationLat+','+destinationLng+'&travelmode=driving'; 
    var appUrl = 'geo:' + originLat + ',' + originLng + '?q=' + destinationLat + ',' + destinationLng;
    window.location.href = appUrl; // Fallback to the web URL in case the app is not installed 
    setTimeout(() => { window.location.href = mapsUrl; }, 500);
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
//     timerDisplay.textContent = "OTP expired!";
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
					//	console.log('profile pic path : ' +data.profileImagePath);
						$('#footerprofilepic').attr("src", data.profileImagePath);
					//console.log('data success or failure : '+data);
						$('#otpModal').modal('hide');
						if( phoneorwhatsapp=1)
							{
							//console.log('phoneorwhatsapp : ' +phoneorwhatsapp);
							//window.location.href = "tel:" + mobilenumber;
							
							window.location.href = "tel:" + telphno;
							}
						else if( phoneorwhatsapp=2)
							{
							// var whatsappUrl = "https://api.whatsapp.com/send?phone=" + mobilenumber;
							 var whatsappUrl = "https://api.whatsapp.com/send?phone=" + telphno;
				             window.location.href = whatsappUrl;								
							}
					}
					}).fail(function(xhr, textStatus, errorThrown) {
						
					})
					
				});//login click

				var span = document.getElementById("loginModalClose");
				span.onclick = function() {
					//modal.style.display = "none";
					//console.log('span');
					$('#loginModal').modal('hide');
					}
				
				var cl = document.getElementById("otpModalClose");
				cl.onclick = function() { 	
					//console.log('span');
				$('#otpModal').modal('hide');
					}

				function whatsapp(phno)
				{
					 phoneorwhatsapp=2;telphno = phno;
				    event.stopPropagation(); 
				    $.ajax({
		                url: '${pageContext.request.contextPath}/getSessionVariable',
		                method: 'GET',
		                async:false,
		                success: function(data) {
		                 //   alert(data); // Outputs the session variable value
		                // console.log('in success');
		                 mob=data;
		               //  console.log("mob1");
		            //	 getsessionvalue(mob);
		             
		                },
		                error: function(xhr, status, error) {
		                   // console.error("Error fetching session variable: ", error);
		                }
		            });
				if(mob=="")
					{
					//console.log("mob2");					
					$('#loginModal').modal('show');
					}
				else{	
					
					//console.log("mob3");
		           	 //var whatsappUrl = 'https://wa.me/' + phno;
		           	 //phno ='+91'+phno;
		           	 	 var whatsappUrl = "https://api.whatsapp.com/send?phone=" + phno;
		             //window.open(whatsappUrl, '_blank');
		           	 	window.location.href = whatsappUrl;
		                    	  }
		                   
				}

let selectedMode = null;

setInterval(currentLocationsetcheck, 30000); //check location for every 30 sec start here
function  currentLocationsetcheck(){
	   locationset++;  
 	//if(currentLocationset==true || busenabled ==1 || carenabled ===1 ||rickshawenabled ===1 || goodsenabled ===1)  // Set variable to true after 2 seconds
 	
 		//if(currentLocationset==true || currentLocationsetfromsess==true || gitagenabled=0||templeenabled =0||forestenabled=0||heritageenabled =0||hospitalenabled =0||newsenabled=0||vlogsenabledd=0||goodsenabled=0||busenabled=0||carenabled=0||rickshawenabled=0||roadenabled =0)
 	/*		
 			if (
    (currentLocationset || currentLocationsetfromsess) &&
    gitagenabled === 0 &&
    templeenabled === 0 &&
    forestenabled === 0 &&
    heritageenabled === 0 &&
    hospitalenabled === 0 &&
    newsenabled === 0 &&
    vlogsenabledd === 0 &&
    goodsenabled === 0 &&
    busenabled === 0 &&
    carenabled === 0 &&
    rickshawenabled === 0 &&
    roadenabled === 0
)*/
 		/*	if (
    (currentLocationset || currentLocationsetfromsess) &&
    [
        gitagenabled,
        templeenabled,
        forestenabled,
        heritageenabled,
        hospitalenabled,
        newsenabled,
        vlogsenabledd,
        goodsenabled,
        busenabled,
        carenabled,
        rickshawenabled,
        roadenabled
    ].every(v => v === 0)
)*/

//if(vehiclead!=1){
if (
	    (
	        (currentLocationset || currentLocationsetfromsess) &&
	       ( [
	            gitagenabled,
	            templeenabled,
	            forestenabled,
	            heritageenabled,
	            hospitalenabled,
	            newsenabled,
	            vlogsenabledd,
	            goodsenabled
	        ].every(v => v === 0)) )
	    
	    ||
	   ( [
	        busenabled,
	        carenabled,
	        rickshawenabled,
	        goodsenabled
	    ].some(v => v === 1) ) 
	)

  { 
  
	  currentlocationglobal++;
  console.log('Every 30 sec: ' +busenabled +" " +carenabled +' ' +rickshawenabled + ' ' +goodsenabled +' '+currentLocationset +' '+currentLocationsetfromsess); //$('#itr').html('CItr: '+currentlocationglobal) ;
 /* selectedMode =
	  busenabled === 1 ? "bus" :
	  carenabled === 1 ? "car" :
	  rickshawenabled === 1 ? "rickshaw" :
	  goodsenabled === 1 ? "goods" :
	  null;*/
getLocationContinuous();
   }        
   else
 	  {
 	      	 // $("#locationflag").html('Current Location Not Set : ' +locationset );
 	  }

}
function getLocationContinuous()
{
	if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(sendLocationContinuous,function(error) {
            // On error, log the error message
            console.error("Error fetching location: ", error.message);
         
        },
        {
            // Optional options
            enableHighAccuracy: true,  // Use the best possible accuracy
            //timeout: 5000,             // Timeout after 5 seconds
            maximumAge: 0              // Don't use a cached location
        }
        );
    } 	   
    else {
           console.error("Geolocation is not supported by this browser.in get location else ");
    }
}

function sendLocationContinuous(position) {
	   	   const lat  = position.coords.latitude;
	       const lng = position.coords.longitude;	       
	       
	      var dist=getDistanceFromLatLonInKm(lastlat,lastlng,lat,lng).toFixed(4);
	      currentdistanceglobal=dist;
	  
	  	 var detectLocation = { coords: {latitude: position.coords.latitude, longitude: position.coords.longitude} };
	  	
	//  	displayCurrentLocation(lat, lng);
	
	  document.getElementById("currentlocationbutton").disabled = false;
	          	  document.getElementById("pinlocationbutton").disabled = true;
	  /*	$.each(currentAdsData, function (i, myList) {
      		var latitude1 = myList.location.lat;
      		var longitude1 = myList.location.lng;
      		var latitude2 = onesinglelatitude;
      		var longitude2 = onesinglelongitude;
      		 var calcdistance = getDistanceFromLatLonInKm(latitude1,longitude1,latitude2,longitude2);
      		 myList.distance = calcdistance;
      	//	 console.log('mylist now : '+JSON.stringify(myList) );
      		});*/
	     // if(dist>=0.01)
	    	  {
	    	 // console.log('distance : ' +dist);		    	  
	    	//  var detectLocation = { coords: {  latitude: 13.529271965260616,  longitude: 75.36285138756304 } };
	    	//updateMarkerPosition(position);
	    	 sendLocationDetect(detectLocation);
	    	 // sendLocation(detectLocation);
	    	 lastlat=lat;
	    	 lastlng =lng;
	    	  }
	/*      if(lastlat == lat && lastlng == lng)
	    	  {
	    	  $("#latlng").html('Lat Long Not Changed );
	    	  }*/
	    	  
	    	   locationFetched++;
	        //    document.getElementById("lf").textContent = locationFetched;
}
function sendLocationDetect(position)
{
	    //  console.log('in send location detect 30 secs' +position.coords.latitude);
	   //sendLocation(position);
	   var lat = position.coords.latitude;
	   var lng = position.coords.longitude;
	   /*lat = onesinglelatitude;
	   lng = onesinglelongitude;*/
	   onesinglelatitude=lat;//current
	   onesinglelongitude=lng;
	   var k = 0;
	   //displayCurrentLocation(lat, lng);
	    document.getElementById("currentlocationbutton").disabled = false;
        document.getElementById("pinlocationbutton").disabled=true;
  var results =0;
//FIX 2: convert null/undefined selectedMode to empty string
  let modeParam = selectedMode ?? "";
 
  $.ajax({
      // Our sample url to make request 
      url:"${pageContext.request.contextPath}/currentlocation?mode="+modeParam,
      type: "POST",
      contentType : 'application/json',
      dataType : 'json',
      data:JSON.stringify({lat,lng}), 
      success: function (data) {
      //    let x = JSON.stringify(data);  
       
      if (distancebutton.classList.contains('inactivesort')) {
	        	    // Remove the class
	        	    distancebutton.classList.remove('inactivesort');
	        	    distancebutton.classList.add("activesort");
	        		distance=1;time=0;
	        		timebutton.classList.remove("activesort");
	        		timebutton.classList.add("inactivesort");
	        	} else {
	        	    // Add the class
	        	    //currentClasses.add('newClass');
	        	}
		       
    /*    $.each(data, function (i, myList) {
      		var latitude1 = myList.location.lat;
      		var longitude1 = myList.location.lng;
      		var latitude2 = onesinglelatitude;
      		var longitude2 = onesinglelongitude;
      		 var calcdistance = getDistanceFromLatLonInKm(latitude1,longitude1,latitude2,longitude2);
      		 myList.distance = calcdistance;
      		 //console.log('mylist now : '+JSON.stringify(myList) );
      		});*/
             document.getElementById("ads").innerHTML = "";
         	 noofresults=data.length;
       	     $('#noofresults').html('Results: '+noofresults) ;
       	     currentAdsData = data;
    /*     for (var i = 0; i < markers.length; i++) {
	   markers[i].setMap(null); // Remove marker from the map
	 
	  // locations[i]=null;
    }
 locations = []; // Clear the array of markers
 circles.forEach(circle => {
     circle.setMap(null); // Remove circle from the map
 });
 circles.length = 0; // Clear the array
 
 
/*var   pinmarker = new google.maps.Marker({
     position: new google.maps.LatLng(lat,lng),
     map: map,
     icon:png
   });
	map.setZoom(12);
 map.panTo(pinmarker.position);  */
 
 /*var newLocation = {lat,lng}; // 
 map.setCenter(newLocation); 
 map.setZoom(12); */
 if(distance===1)
	 {
	// console.log('before sorting: ' + data);
//	 let array = currentAdsData;
	 let array = data;
	 let sortedArray=	array.sort(function(a, b) { return a.distance - b.distance; });
	 data = sortedArray;
	// console.log('distance =1' );
	 }
 if (time===1)
	 {
	  //  let dateTimeArray = currentAdsData;
	    let dateTimeArray = data;
		let dateTimeArraySorted=dateTimeArray.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
		data = dateTimeArraySorted;
		// console.log('time =1' +JSON.stringify(data));
	 }
 
 
 
 /*if(selectedMode === "rickshaw")
	 {
	 
	 $.each(data, function (i, myList) { 		  
    
		 if(myList.phoneNumber ===  "9482761331" || myList.phoneNumber === "9481152676" || myList.phoneNumber === "7022179266" || myList.phoneNumber === "9483057689" || myList.phoneNumber ==="9481751910" || myList.phoneNumber === "9611694857"){
     	  var adsid = myList.id;
	     	 var phno = myList.phoneNumber;
	     	
	     	 var email= myList.emailAddress;
     	 var publisher_name = myList.a.title;var fullname = myList.fullName;
     	console.log('at last : ' + myList.distance );
     	var d = myList.distance.toFixed(4);
    // 	 console.log(publisher_name);
     	 var description = myList.a.description;
     	 var dates = myList.dateRange.toDate;
     	const date = new Date(dates);
    	var companyName='';
    	var latitudes=myList.location.lat;
   	var longitudes = myList.location.lng;
    	var companyLogoUrl = myList.companies.companyLogoPath;
   	var thumbnail = myList.a.thumbnail;
   	//console.log('companyLogoUrl: ' +companyLogoUrl);
   	var banner1="nopreview.jpg";
   	var banner2 = "nopreview.jpg";	var createdBy = myList.createdBy;
   	if(myList.a.adType =='64887c11cce361dafc86c23b' ){
   	var baners =  myList.a.content.banners;
   		    	
   	if(baners !=null )
   		{
   		 banner1 = baners[0];
   		
   	//console.log('inside if baners!=null');
   		 if(baners[1] != undefined ){ 	    		
   			 banner2 = baners[1];
   		 }
   		}
   	}
     	if(myList.companies==null || myList.companies==undefined){//console.log('inside if'+publisher_name);
     	companyName=publisher_name;}
     	else{	     	 companyName= myList.companies.name;}
		//console.log('company name : '+companyName);
     
     // Create a formatter with custom options
     const formatter = new Intl.DateTimeFormat('en-GB', {
         day: 'numeric',
         month: 'long',
         year: 'numeric'
     });

     const formattedDate = formatter.format(date);
   //  console.log(formattedDate); // e.g., "29 August 2024"
     	
     	 var img_path = "";
      		k++;
    	 var carouselid= 'myCarouselhome'+k;
     	var ad_card='<div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
           +'<div class="panel-heading">'
           +'<img src="<c:url value="'+companyLogoUrl+'" />"  style="height:30px;width:30px;" alt="User profile" class="spotlightimg" loading="lazy" />'
           +'<div id="frame20"><h5 id="publishername" style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">'+companyName+' </h5></div>'
           +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
           +'<div class="saved"><svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/></svg>'
           +'</div>'
           +'</div>'//heading 
           +'<div class="panel-body" style="padding:0px !important;">'
           +'<div class="carousel-container">'
           +'<div  class="carousel slide" data-ride="carousel" id="'+carouselid+'">'	            
           
           +'<div class="carousel-inner">'
           +'<div class="item active">'
           +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
           +'</div>'
           +'<div class="item">'
           +'<img src="<c:url value="'+banner1+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
           +'</div>'
           +'<div class="item">'
           +'<img src="<c:url value="'+banner2+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
           +'</div>'
           +'</div>'	            
           
           +'</div>'
           +'</div>'// carousel container 
           +'<div class="text-container">'
           +'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;">'+publisher_name+'</p>'
           +'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+description+'</p>'
           +'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+fullname+'</p>'
           +'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'
           +'</div>'
           +'</div>'//<!-- panel body --> 
           +'<div class="line" style ="width: 90%;    margin: 11px 11px;    border-top: 2px solid black;   opacity: 0.1; "></div>'
           +'<div class="panel-footer">'
           +'<div class="phone" id ="phone" onclick=phone('+phno+');><i class="fa fa-phone" style="font-size:20px;"></i></div>'
           +'<div class="whatsapp" id ="whatsapp" onclick=whatsapp('+phno+');><i class="fa fa-whatsapp" style="font-size:20px;"></i></div>'
           +'<div class="email" id ="email"><i class="fa fa-envelope" style="font-size:20px;"></i></div>'
           +'<div class="takeme" ><button  id ="takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+'); style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Take me there</button></div>'
           +'</div>'
           +'</div>'
	        $('.ads').append(ad_card); 

        var  latt = 13.529271965260616;
       var lngg = 75.36285138756304; 
     
 		results++;
 
		 }
          }); //.each
	 
	 }
      
      
      else
    	  {*/
    	  
    	  
    	  if (
    			    [
    			        busenabled,
    			        carenabled,
    			        rickshawenabled,
    			        roadenabled
    			    ].some(v => v === 1))
    		{	    
    			    
    			    
    			     $.each(data, function (i, myList) { 		  
        	 
          	  var adsid = myList.id;
   	     	 var phno = myList.phoneNumber;
   	  	var whatsapp = myList.whatsappNumber;
   	     	 var email= myList.emailAddress;
 	     	 var publisher_name = myList.a.title;var fullname = myList.fullName;var distance = myList.distance.toFixed(2);;
 	    // 	console.log('at last : ' + myList.distance );
 	     	var d = myList.distance.toFixed(4);
 	    // 	 console.log(publisher_name);
 	     	 var description = myList.a.description;
 	     	 var dates = myList.dateRange.toDate;
 	     	const date = new Date(dates);
 	    	var companyName='';
 	    	var latitudes=myList.location.lat;
	    	var longitudes = myList.location.lng;
 	    	var companyLogoUrl = myList.companies.companyLogoPath;
	    	var thumbnail = myList.a.thumbnail;
	    	//console.log('companyLogoUrl: ' +companyLogoUrl);
	    	var banner1="nopreview.jpg";
	    	var banner2 = "nopreview.jpg";	var createdBy = myList.createdBy;
	    	if(myList.a.adType =='64887c11cce361dafc86c23b' ){
	    	var baners =  myList.a.content.banners;
	    		    	
	    	if(baners !=null )
	    		{
	    		 banner1 = baners[0];
	    		
	    	//console.log('inside if baners!=null');
	    		 if(baners[1] != undefined ){ 	    		
	    			 banner2 = baners[1];
	    		 }
	    		}
	    	}
 	     	if(myList.companies==null || myList.companies==undefined){//console.log('inside if'+publisher_name);
 	     	companyName=publisher_name;}
 	     	else{	     	 companyName= myList.companies.name;}
 			//console.log('company name : '+companyName);
 	     
 	     // Create a formatter with custom options
 	     const formatter = new Intl.DateTimeFormat('en-GB', {
 	         day: 'numeric',
 	         month: 'long',
 	         year: 'numeric'
 	     });

 	     const formattedDate = formatter.format(date);
 	   //  console.log(formattedDate); // e.g., "29 August 2024"
 	     	
 	     	 var img_path = "";
 	      		k++;
	     	 var carouselid= 'myCarouselhome'+k;
	      	var ad_card='<div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
	            +'<div class="panel-heading">'
	            +'<img src="<c:url value="'+companyLogoUrl+'" />"  style="height:30px;width:30px;" alt="User profile" class="spotlightimg" loading="lazy" />'
	            +'<div id="frame20"><h5 id="publishername" style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">'+companyName+' </h5></div>'
	            +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
	            +'<div class="saved"><svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/></svg>'
	            +'</div>'
	            +'</div>'//heading 
	            +'<div class="panel-body" style="padding:0px !important;">'
	            +'<div class="carousel-container">'
	            +'<div  class="carousel slide" data-ride="carousel" id="'+carouselid+'">'	            
	            
	            +'<div class="carousel-inner">'
	            +'<div class="item active">'
	            +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
	            +'</div>'
	            +'<div class="item">'
	            +'<img src="<c:url value="'+banner1+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
	            +'</div>'
	            +'<div class="item">'
	            +'<img src="<c:url value="'+banner2+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
	            +'</div>'
	            +'</div>'	            
	            
	            +'</div>'
	            +'</div>'// carousel container 
	            +'<div class="text-container">'
	            <!--+'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;">'+publisher_name+'</p>'-->
	            +'<div style="display:flex;justify-content:space-between;align-items:center;font-family:Inter;">'
	 	       + '<span style="font-weight:700;font-size:16px;">' + publisher_name + '</span>'
	 	       + '<span style="font-weight:500;font-size:14px;color:#666;">' + distance + '</span>'
	 	       + '</div>'
	            +'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+description+'</p>'
	            <!--+'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+fullname+'</p>'-->
	            
	        <!--    +'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'-->
	            +'</div>'
	            +'</div>'//<!-- panel body --> 
	            +'<div class="line" style ="width: 90%;    margin: 11px 11px;    border-top: 2px solid black;   opacity: 0.1; "></div>'
	            +'<div class="panel-footer">'
	            +'<div class="phone" id ="phone" onclick=phone('+phno+');><i class="fa fa-phone" style="font-size:20px;"></i></div>'
	            +'<div class="whatsapp" id ="whatsapp" onclick=whatsapp('+whatsapp+');><i class="fa fa-whatsapp" style="font-size:20px;"></i></div>'
	            +'<div class="email" id ="email"><i class="fa fa-envelope" style="font-size:20px;"></i></div>'
	            +'<div class="takeme" ><button  id ="takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takemefromvehicle('+latitudes+','+longitudes+',\''+adsid+'\'); style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Show Location</button></div>'
	            +'</div>'
	            +'</div>'
		        $('.ads').append(ad_card); 
 	
 	        var  latt = 13.529271965260616;
	        var lngg = 75.36285138756304; 
	      
 	 		results++;
 	 
        
 	          }); //.each
    		}
    	  else
    		  {
    			
          $.each(data, function (i, myList) { 		  
        	 
          	  var adsid = myList.id;
   	     	 var phno = myList.phoneNumber;
   	  	var whatsapp = myList.whatsappNumber;
   	     	 var email= myList.emailAddress;
 	     	 var publisher_name = myList.a.title;var fullname = myList.fullName;
 	    // 	console.log('at last : ' + myList.distance );
 	     	var d = myList.distance.toFixed(4);
 	    // 	 console.log(publisher_name);
 	     	 var description = myList.a.description;
 	     	 var dates = myList.dateRange.toDate;
 	     	const date = new Date(dates);
 	    	var companyName='';
 	    	var latitudes=myList.location.lat;
	    	var longitudes = myList.location.lng;
 	    	var companyLogoUrl = myList.companies.companyLogoPath;
	    	var thumbnail = myList.a.thumbnail;
	    	//console.log('companyLogoUrl: ' +companyLogoUrl);
	    	var banner1="nopreview.jpg";
	    	var banner2 = "nopreview.jpg";	var createdBy = myList.createdBy;
	    	if(myList.a.adType =='64887c11cce361dafc86c23b' ){
	    	var baners =  myList.a.content.banners;
	    		    	
	    	if(baners !=null )
	    		{
	    		 banner1 = baners[0];
	    		
	    	//console.log('inside if baners!=null');
	    		 if(baners[1] != undefined ){ 	    		
	    			 banner2 = baners[1];
	    		 }
	    		}
	    	}
 	     	if(myList.companies==null || myList.companies==undefined){//console.log('inside if'+publisher_name);
 	     	companyName=publisher_name;}
 	     	else{	     	 companyName= myList.companies.name;}
 			//console.log('company name : '+companyName);
 	     
 	     // Create a formatter with custom options
 	     const formatter = new Intl.DateTimeFormat('en-GB', {
 	         day: 'numeric',
 	         month: 'long',
 	         year: 'numeric'
 	     });

 	     const formattedDate = formatter.format(date);
 	   //  console.log(formattedDate); // e.g., "29 August 2024"
 	     	
 	     	 var img_path = "";
 	      		k++;
	     	 var carouselid= 'myCarouselhome'+k;
	      	var ad_card='<div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
	            +'<div class="panel-heading">'
	            +'<img src="<c:url value="'+companyLogoUrl+'" />"  style="height:30px;width:30px;" alt="User profile" class="spotlightimg" loading="lazy" />'
	            +'<div id="frame20"><h5 id="publishername" style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">'+companyName+' </h5></div>'
	            +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
	            +'<div class="saved"><svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/></svg>'
	            +'</div>'
	            +'</div>'//heading 
	            +'<div class="panel-body" style="padding:0px !important;">'
	            +'<div class="carousel-container">'
	            +'<div  class="carousel slide" data-ride="carousel" id="'+carouselid+'">'	            
	            
	            +'<div class="carousel-inner">'
	            +'<div class="item active">'
	            +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
	            +'</div>'
	            +'<div class="item">'
	            +'<img src="<c:url value="'+banner1+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
	            +'</div>'
	            +'<div class="item">'
	            +'<img src="<c:url value="'+banner2+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
	            +'</div>'
	            +'</div>'	            
	            
	            +'</div>'
	            +'</div>'// carousel container 
	            +'<div class="text-container">'
	            +'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;">'+publisher_name+'</p>'
	            +'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+description+'</p>'
	            <!--+'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+fullname+'</p>'-->
	            
	        <!--    +'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'-->
	            +'</div>'
	            +'</div>'//<!-- panel body --> 
	            +'<div class="line" style ="width: 90%;    margin: 11px 11px;    border-top: 2px solid black;   opacity: 0.1; "></div>'
	            +'<div class="panel-footer">'
	            +'<div class="phone" id ="phone" onclick=phone('+phno+');><i class="fa fa-phone" style="font-size:20px;"></i></div>'
	            +'<div class="whatsapp" id ="whatsapp" onclick=whatsapp('+whatsapp+');><i class="fa fa-whatsapp" style="font-size:20px;"></i></div>'
	            +'<div class="email" id ="email"><i class="fa fa-envelope" style="font-size:20px;"></i></div>'
	            +'<div class="takeme" ><button  id ="takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+'); style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Take me there</button></div>'
	            +'</div>'
	            +'</div>'
		        $('.ads').append(ad_card); 
 	
 	        var  latt = 13.529271965260616;
	        var lngg = 75.36285138756304; 
	      
 	 		results++;
 	 
        
 	          }); //.each
 	          
    		  }//e;se
//for map from here

//displayCurrentLocation(lat, lng);
//$('#results').html('Results: ' +results);

//  }//else
      },

      // Error handling 
      error: function (error) {
          console.log(`Error ${error}`);
      }
  });  	   
}

function getDistanceFromLatLonInKm(lat1,lon1,lat2,lon2) {
//	console.log('inside distance calculator: '+lat2+'Longi: '+lon2);
		  var R = 6371; // Radius of the earth in km
		  var dLat = deg2rad(lat2-lat1);  // deg2rad below
		  var dLon = deg2rad(lon2-lon1); 
		  var a = Math.sin(dLat/2)*Math.sin(dLat/2)+Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.sin(dLon/2) * Math.sin(dLon/2); 
		  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
		  var d = R * c; // Distance in km
		  return d;
		/*  const lat1Rad = toRadians(lat1);
		    const lon1Rad = toRadians(lon1);
		    const lat2Rad = toRadians(lat2);
		    const lon2Rad = toRadians(lon2);
		    
		    // Differences in coordinates
		    const dLat = lat2Rad - lat1Rad;
		    const dLon = lon2Rad - lon1Rad;
		    
		    // Haversine formula
		    const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
		              Math.cos(lat1Rad) * Math.cos(lat2Rad) * 
		              Math.sin(dLon/2) * Math.sin(dLon/2);
		    
		    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
		    
		    // Calculate distance
		    const distance = R * c;
		    
		    return        distance;*/
		       
		}
		
function deg2rad(deg) {
		  return deg * (Math.PI/180)
		}


//check location for every 30 sec end here
//to show the ad in more detail start here
var adIdShowVendors ;var showvendorscreatedby ="";
function nextui(element, createdBy) {
    // campaign Id
    const adId = element.id;
    var k = 0;
    adIdShowVendors = adId;
    showvendorscreatedby = createdBy;
    
    let divElementimagecontainer = document.getElementById('image-container');
    // Clear all elements inside the div 
    divElementimagecontainer.innerHTML = '';
    
    let divElementtextcontainer = document.getElementById('addetailModaltext-container');
    // Clear all elements inside the div 
    
    document.getElementById('ptitle').innerHTML = '';
    document.getElementById('pdescription').innerHTML = '';
    document.getElementById('pfullname').innerHTML = '';
    document.getElementById('companyname').innerHTML = '';
    document.getElementById("customtextsection").innerHTML = '';
    document.getElementById('pexpiry').innerHTML = '';
    document.getElementById('validfrom').innerHTML = '';
    document.getElementById('validtill').innerHTML = '';
    
    $.ajax({
        url: '${pageContext.request.contextPath}/otheradsbypubli',
        method: 'GET',
        async: false,
        data: {adId: adId, createdBy: createdBy},
        success: function(response) {
            
            document.getElementById('ptitle').innerHTML = response.onead.a.title;
            document.getElementById('pdescription').innerHTML = response.onead.a.description;
            document.getElementById('pfullname').innerHTML = response.onead.fullName;
            document.getElementById('companyname').innerHTML = response.onead.companies.name;
            
            let imgElement4 = document.getElementById('companyimg');
            // Set the src attribute 
            imgElement4.src = response.onead.companies.companyLogoPath;
            
            let buttonElement1 = document.getElementById('phone');
            buttonElement1.setAttribute("data-value", response.onead.phoneNumber);
            
            let buttonElement2 = document.getElementById('whatsapp');
            buttonElement2.setAttribute("data-value", response.onead.whatsappNumber);
            
            var publisherlat = response.onead.location.lat;
            var publisherlong = response.onead.location.lng;
            
            var addetailtakeme = document.getElementById("addetailmodaltakeme");
            addetailtakeme.setAttribute("onclick", "takeme('" + publisherlat + "','" + publisherlong + "')");
            
            // Custom text section
            for (let i = 0; i < response.onead.a.customTextSection.length; i++) {
                // Create a new p element
                let p = document.createElement("p");
                // Set the text content of the p element
                var customTextSection = response.onead.a.customTextSection[i].title.replace(/<([^>]+)>/g, '<strong>$1</strong>').replace(/\n/g, "<br/>");
                p.innerHTML = customTextSection;
                
                // Find the div element
                let p2 = document.createElement("p");
                
                let safeDescription = response.onead.a.customTextSection[i].description;
                safeDescription = formatText(safeDescription);
                
                // Set HTML content
                p2.innerHTML = safeDescription;
                
                let div = document.getElementById("customtextsection");
                // Append the p element to the div 
                div.appendChild(p);
                div.appendChild(p2);
            }
            
            // Date formatting
            var dates = response.onead.dateRange.toDate;
            const date = new Date(dates);
            const formatter = new Intl.DateTimeFormat('en-GB', {
                day: 'numeric',
                month: 'long',
                year: 'numeric'
            });
            const formattedDate = formatter.format(date);
            document.getElementById('pexpiry').innerHTML = 'Expires on ' + formattedDate;
            
            var fromdates = response.onead.dateRange.fromDate;
            const fromdate = new Date(fromdates);
            const fromformatter = new Intl.DateTimeFormat('en-GB', {
                day: 'numeric',
                month: 'long',
                year: 'numeric'
            });
            const fromformattedDate = fromformatter.format(fromdate);
            
            document.getElementById('validfrom').innerHTML = fromformattedDate;
            document.getElementById('validtill').innerHTML = formattedDate;
            
            // VIDEO AD TYPE
         /*   if (response.onead.a.adType == '64887c11cce361dafc86c23c') {          	
            	 console.log('video ad');
                var targetDiv = document.getElementById('image-container');
                var videolink = response.onead.a.content.videoLink;
                
                let dynamicDiv = document.createElement('div');
                dynamicDiv.className = 'video-container';
                dynamicDiv.style.width = '100%';
                
                let iframe = document.createElement('iframe');
                iframe.src = videolink;
                iframe.width = '100%';
                iframe.height = '250px';
                iframe.frameBorder = '0';
                iframe.id = 'videoframe';
                iframe.setAttribute('allowfullscreen', '');
                iframe.setAttribute('allow', 'accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture');
                
                dynamicDiv.appendChild(iframe);
                
                let container = document.getElementById('image-container');
                container.appendChild(dynamicDiv);
                container.style.order = 1;
                
                let container2 = document.getElementById('addetailModalcarousel-container');
                container2.style.order = 2;
                container2.style.display = 'none'; // Hide carousel for video
                
                let container3 = document.getElementById('customtextsection');
                container3.style.order = 5;
                
                let container4 = document.getElementById('pexpiry');
                container4.style.order = 3;
                
                let container5 = document.getElementById('buttons-container');
                container5.style.order = 4;
                
                let container6 = document.getElementById('addetailModaltext-container');
                container6.style.order = 6;
                
                let container8 = document.getElementById('validity-container');
                container8.style.order = 8;
                
                let container7 = document.getElementById('addetailline');
                container7.style.order = 7;
            }*/
            
            // BANNER AD TYPE
         /*   if (response.onead.a.adType == '64887c11cce361dafc86c23b') {
               
                
                console.log('banner ad' +response.onead.a.content.banners.length);
                document.getElementById('addetailModalcarousel-container').style.display = 'block';
                
                
                let carouselIndicators = document.getElementById('carousel-indicators');
                let carouselInner = document.getElementById('carousel-inner');
                
                if (carouselIndicators) carouselIndicators.innerHTML = '';
                if (carouselInner) carouselInner.innerHTML = '';
                
                
                let container = document.getElementById('image-container');
                container.style.order = 2;
                
                let container2 = document.getElementById('addetailModalcarousel-container');
                container2.style.order = 1;
                
                let container3 = document.getElementById('customtextsection');
                container3.style.order = 5;
                
                let container4 = document.getElementById('pexpiry');
                container4.style.order = 3;
                
                let container5 = document.getElementById('buttons-container');
                container5.style.order = 4;
                
                let container6 = document.getElementById('addetailModaltext-container');
                container6.style.order = 6;
                
                let container8 = document.getElementById('validity-container');
                container8.style.order = 8;
                
                let container7 = document.getElementById('addetailline');
                container7.style.order = 7;
                
               
                let banners = response.onead.a.content.banners;
                if (!banners || banners.length === 0) {
                    banners = [response.onead.a.thumbnail];
                }
                for (let j = 0; j < banners.length; j++) {
                   
                    if (carouselIndicators) {
                        let indicator = document.createElement('li');
                        indicator.setAttribute('data-target', '#addetailcarousel');
                        indicator.setAttribute('data-slide-to', j);
                        if (j === 0) {
                            indicator.className = 'active';
                        }
                        carouselIndicators.appendChild(indicator);
                    }
                    
                   
                    if (carouselInner) {
                        let carouselItem = document.createElement('div');
                        carouselItem.className = j === 0 ? 'item active' : 'item';
                        
                        let img = document.createElement('img');
                        img.src = banners[j];
                        img.alt = 'Image';
                        img.style.cssText = 'display: block;max-width: 100%;height: 250px;width: 100%;object-fit: cover;';
                        
                        carouselItem.appendChild(img);
                        carouselInner.appendChild(carouselItem);
                    }
                    
                    
                    let targetDiv = document.getElementById('image-container');
                    targetDiv.innerHTML += '<img src="' + banners[j] + '" alt="Image" style="display: block;max-width: 80px;height:70px;object-fit: cover;">';
                }
                
               
                setTimeout(function() {
                    var $carousel = $('#addetailcarousel');
                    
                   
                    $carousel.carousel('pause');
                    $carousel.removeData('bs.carousel');
                    $carousel.off('.carousel');
                    
                   
                    $carousel.find('.carousel-inner .item').removeClass('next prev left right');
                    $carousel.find('.carousel-indicators li').removeClass('active');
                    
                    
                    $carousel.find('.carousel-inner .item:first').addClass('active');
                    $carousel.find('.carousel-indicators li:first').addClass('active');
                    
                    
                    $carousel.carousel({
                        interval: 2000,  // Auto-slide every 3 seconds
                        pause: 'hover',
                        wrap: true
                    });
                    
                   
                    $carousel.carousel('cycle');
                    
                }, 150);
            }*/
            
          /*  if(response.onead.a.adType=='64887c11cce361dafc86c23d'){
	     		 
	     		 console.log('simple text');
	     	 
	    		 let container = document.getElementById('image-container'); 								     	
			     	container.style.order=2;
			     	let container2 = document.getElementById('addetailModalcarousel-container'); 
			     	container2.style.order=1;
			     	
			     	let container3 = document.getElementById('customtextsection'); 
			     	container3.style.order=5;
			     	let container4 = document.getElementById('pexpiry'); 
			     	container4.style.order=3;		
			     
			     	let container5 = document.getElementById('buttons-container'); 
			     	container5.style.order=4;	
			     	let container6 = document.getElementById('addetailModaltext-container');
			     	container6.style.order=6;
			     	let container8 = document.getElementById('validity-container');
			     	container8.style.order=8;
			     
			     	let container7 = document.getElementById('addetailline');
			     	container7.style.order=7; 
	    	     console.log('simple text ad : ' +response.onead.a.content.AdText);
	    		 var targetDiv = document.getElementById('image-container');
	    		 targetDiv.innerHTML +='<p>'+response.onead.a.content.adText+'</p>';
	    	 }*/
	     	
	    	// VIDEO AD TYPE
	    	 if (response.onead.a.adType == '64887c11cce361dafc86c23c') {
	    	     console.log('video ad');
	    	     
	    	     // Show carousel with thumbnail
	    	     document.getElementById('addetailModalcarousel-container').style.display = 'block';
	    	     
	    	     // Clear carousel content
	    	     let carouselIndicators = document.getElementById('carousel-indicators');
	    	     let carouselInner = document.getElementById('carousel-inner');
	    	     if (carouselIndicators) carouselIndicators.innerHTML = '';
	    	     if (carouselInner) carouselInner.innerHTML = '';
	    	     
	    	     // Add thumbnail to carousel
	    	     let indicator = document.createElement('li');
	    	     indicator.setAttribute('data-target', '#addetailcarousel');
	    	     indicator.setAttribute('data-slide-to', '0');
	    	     indicator.className = 'active';
	    	     carouselIndicators.appendChild(indicator);
	    	     
	    	     let carouselItem = document.createElement('div');
	    	     carouselItem.className = 'item active';
	    	     
	    	     let carouselImg = document.createElement('img');
	    	     carouselImg.src = response.onead.a.thumbnail;
	    	     carouselImg.alt = 'Image';
	    	     carouselImg.style.cssText = 'display: block;max-width: 100%;height: 250px;width: 100%;object-fit: cover;';
	    	     
	    	     carouselItem.appendChild(carouselImg);
	    	     carouselInner.appendChild(carouselItem);
	    	     
	    	     // Add video to image-container
	    	     var targetDiv = document.getElementById('image-container');
	    	     var videolink = response.onead.a.content.videoLink;

	    	     let dynamicDiv = document.createElement('div');
	    	     dynamicDiv.className = 'video-container';
	    	     dynamicDiv.style.width = '100%';

	    	     let iframe = document.createElement('iframe');
	    	     iframe.src = videolink;
	    	     iframe.width = '100%';
	    	     iframe.height = '250px';
	    	     iframe.frameBorder = '0';
	    	     iframe.id = 'videoframe';
	    	     iframe.setAttribute('allowfullscreen', '');
	    	     iframe.setAttribute('allow', 'accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture');

	    	     dynamicDiv.appendChild(iframe);

	    	     let container = document.getElementById('image-container');
	    	     container.appendChild(dynamicDiv);
	    	     container.style.order = 1;

	    	     let container2 = document.getElementById('addetailModalcarousel-container');
	    	     container2.style.order = 2;

	    	     let container3 = document.getElementById('customtextsection');
	    	     container3.style.order = 5;

	    	     let container4 = document.getElementById('pexpiry');
	    	     container4.style.order = 3;

	    	     let container5 = document.getElementById('buttons-container');
	    	     container5.style.order = 4;

	    	     let container6 = document.getElementById('addetailModaltext-container');
	    	     container6.style.order = 6;

	    	     let container8 = document.getElementById('validity-container');
	    	     container8.style.order = 8;

	    	     let container7 = document.getElementById('addetailline');
	    	     container7.style.order = 7;
	    	     
	    	     // No need to reinitialize carousel for single image
	    	 }

	    	 // SIMPLE TEXT AD TYPE
	    	 if (response.onead.a.adType == '64887c11cce361dafc86c23d') {
	    	     console.log('simple text');
	    	     
	    	     // Show carousel with thumbnail
	    	     document.getElementById('addetailModalcarousel-container').style.display = 'block';
	    	     
	    	     // Clear carousel content
	    	     let carouselIndicators = document.getElementById('carousel-indicators');
	    	     let carouselInner = document.getElementById('carousel-inner');
	    	     if (carouselIndicators) carouselIndicators.innerHTML = '';
	    	     if (carouselInner) carouselInner.innerHTML = '';
	    	     
	    	     // Add thumbnail to carousel
	    	     let indicator = document.createElement('li');
	    	     indicator.setAttribute('data-target', '#addetailcarousel');
	    	     indicator.setAttribute('data-slide-to', '0');
	    	     indicator.className = 'active';
	    	     carouselIndicators.appendChild(indicator);
	    	     
	    	     let carouselItem = document.createElement('div');
	    	     carouselItem.className = 'item active';
	    	     
	    	     let carouselImg = document.createElement('img');
	    	     carouselImg.src = response.onead.a.thumbnail;
	    	     carouselImg.alt = 'Image';
	    	     carouselImg.style.cssText = 'display: block;max-width: 100%;height: 250px;width: 100%;object-fit: cover;';
	    	     
	    	     carouselItem.appendChild(carouselImg);
	    	     carouselInner.appendChild(carouselItem);

	    	     let container = document.getElementById('image-container');
	    	     container.style.order = 2;
	    	     
	    	     let container2 = document.getElementById('addetailModalcarousel-container');
	    	     container2.style.order = 1;

	    	     let container3 = document.getElementById('customtextsection');
	    	     container3.style.order = 5;
	    	     
	    	     let container4 = document.getElementById('pexpiry');
	    	     container4.style.order = 3;

	    	     let container5 = document.getElementById('buttons-container');
	    	     container5.style.order = 4;
	    	     
	    	     let container6 = document.getElementById('addetailModaltext-container');
	    	     container6.style.order = 6;
	    	     
	    	     let container8 = document.getElementById('validity-container');
	    	     container8.style.order = 8;

	    	     let container7 = document.getElementById('addetailline');
	    	     container7.style.order = 7;
	    	     
	    	   //  console.log('simple text ad : ' + response.onead.a.content.adText);
	    	     var targetDiv = document.getElementById('image-container');
	    	     targetDiv.innerHTML += '<p style="font-family: Inter; font-size: 14px; line-height: 1.5; color: #000000;">' + response.onead.a.content.adText + '</p>';
	    	     
	    	     // No need to reinitialize carousel for single image
	    	 }

	    	 // BANNER AD TYPE
	    	 if (response.onead.a.adType == '64887c11cce361dafc86c23b') {
	    	     // Show carousel for banner ads
	    	     document.getElementById('addetailModalcarousel-container').style.display = 'block';
	    	     
	    	     // Clear existing carousel content
	    	     let carouselIndicators = document.getElementById('carousel-indicators');
	    	     let carouselInner = document.getElementById('carousel-inner');
	    	     
	    	     if (carouselIndicators) carouselIndicators.innerHTML = '';
	    	     if (carouselInner) carouselInner.innerHTML = '';
	    	     
	    	     // Set container orders
	    	     let container = document.getElementById('image-container');
	    	     container.style.order = 2;
	    	     
	    	     let container2 = document.getElementById('addetailModalcarousel-container');
	    	     container2.style.order = 1;
	    	     
	    	     let container3 = document.getElementById('customtextsection');
	    	     container3.style.order = 5;
	    	     
	    	     let container4 = document.getElementById('pexpiry');
	    	     container4.style.order = 3;
	    	     
	    	     let container5 = document.getElementById('buttons-container');
	    	     container5.style.order = 4;
	    	     
	    	     let container6 = document.getElementById('addetailModaltext-container');
	    	     container6.style.order = 6;
	    	     
	    	     let container8 = document.getElementById('validity-container');
	    	     container8.style.order = 8;
	    	     
	    	     let container7 = document.getElementById('addetailline');
	    	     container7.style.order = 7;
	    	     
	    	     // **CHECK IF BANNERS ARRAY IS EMPTY OR NULL**
	    	     let banners = response.onead.a.content.banners;
	    	     
	    	     // If banners array is empty or null, use thumbnail instead
	    	     if (!banners || banners.length === 0) {
	    	         banners = [response.onead.a.thumbnail];
	    	     }
	    	     
	    	     // Populate carousel with banners (or thumbnail if empty)
	    	     for (let j = 0; j < banners.length; j++) {
	    	         // Create indicator
	    	         if (carouselIndicators) {
	    	             let indicator = document.createElement('li');
	    	             indicator.setAttribute('data-target', '#addetailcarousel');
	    	             indicator.setAttribute('data-slide-to', j);
	    	             if (j === 0) {
	    	                 indicator.className = 'active';
	    	             }
	    	             carouselIndicators.appendChild(indicator);
	    	         }
	    	         
	    	         // Create carousel item
	    	         if (carouselInner) {
	    	             let carouselItem = document.createElement('div');
	    	             carouselItem.className = j === 0 ? 'item active' : 'item';
	    	             
	    	             let img = document.createElement('img');
	    	             img.src = banners[j];
	    	             img.alt = 'Image';
	    	             img.style.cssText = 'display: block;max-width: 100%;height: 250px;width: 100%;object-fit: cover;';
	    	             
	    	             carouselItem.appendChild(img);
	    	             carouselInner.appendChild(carouselItem);
	    	         }
	    	         
	    	         // Also add thumbnail to image-container
	    	         let targetDiv = document.getElementById('image-container');
	    	         targetDiv.innerHTML += '<img src="' + banners[j] + '" alt="Image" style="display: block;max-width: 80px;height:70px;object-fit: cover;">';
	    	     }
	    	     
	    	     // **BOOTSTRAP 3 CAROUSEL INITIALIZATION - Only for banner ads with multiple images**
	    	     if (banners.length > 1) {
	    	         setTimeout(function() {
	    	             var $carousel = $('#addetailcarousel');
	    	             
	    	             // Destroy any existing carousel instance
	    	             $carousel.carousel('pause');
	    	             $carousel.removeData('bs.carousel');
	    	             $carousel.off('.carousel');
	    	             
	    	             // Clean up classes
	    	             $carousel.find('.carousel-inner .item').removeClass('next prev left right');
	    	             $carousel.find('.carousel-indicators li').removeClass('active');
	    	             
	    	             // Set first item and indicator as active
	    	             $carousel.find('.carousel-inner .item:first').addClass('active');
	    	             $carousel.find('.carousel-indicators li:first').addClass('active');
	    	             
	    	             // Reinitialize carousel
	    	             $carousel.carousel({
	    	                 interval: 3000,  // Auto-slide every 3 seconds
	    	                 pause: 'hover',
	    	                 wrap: true
	    	             });
	    	             
	    	             // Explicitly start cycling
	    	             $carousel.carousel('cycle');
	    	             
	    	         }, 150);
	    	     }
	    	 }
            // GI TAG
            if (response.onead.giTag === 1) {
                // for gi ads
                const button = document.createElement("button");
                button.textContent = "Show Vendors";
                console.log('show vendors');
                document.getElementById("showgivendors").style.display = "block";
                gitagnumber = response.onead.a.gitagnumber;
            }
            
        },
        error: function(xhr, status, error) {
            console.error('Error loading ad details:', error);
        }
    });
    
    $('#addetailModal').modal('show');
}
 function nextuii(element,createdBy)
 { //campaign Id
			const adId = element.id; var k = 0;adIdShowVendors =adId;showvendorscreatedby = createdBy;
			let divElementimagecontainer = document.getElementById('image-container'); // Clear all elements inside the div 
			divElementimagecontainer.innerHTML = '';		
			let divElementtextcontainer = document.getElementById('addetailModaltext-container'); // Clear all elements inside the div 
		
			document.getElementById('ptitle').innerHTML ='';
            document.getElementById('pdescription').innerHTML ='';
            document.getElementById('pfullname').innerHTML ='';
            
            document.getElementById('companyname').innerHTML ='';
            document.getElementById("customtextsection").innerHTML ='';
            document.getElementById('pexpiry').innerHTML ='';
            document.getElementById('validfrom').innerHTML ='';
	     	document.getElementById('validtill').innerHTML ='';
	     	
							 $.ajax({
					                url: '${pageContext.request.contextPath}/otheradsbypubli',
					                method: 'GET',
					                async:false,
					                data:{adId:adId, createdBy:createdBy},
					                success: function(response) {
					              
					                  
					                  document.getElementById('ptitle').innerHTML =response.onead.a.title;
					                  document.getElementById('pdescription').innerHTML =response.onead.a.description;
					                  document.getElementById('pfullname').innerHTML =response.onead.fullName;
					                  document.getElementById('companyname').innerHTML =response.onead.companies.name;
					                  
					               // Find the img element by its id 
					               let imgElement1 = document.getElementById('carousel1'); // Set the src attribute 
					               imgElement1.src = response.onead.a.thumbnail; 
					               let imgElement2 = document.getElementById('carousel2'); // Set the src attribute 
					               imgElement2.src = response.onead.a.thumbnail;
					               let imgElement3 = document.getElementById('carousel3'); // Set the src attribute 
					               imgElement3.src = response.onead.a.thumbnail;
					               
					               let imgElement4 = document.getElementById('companyimg'); // Set the src attribute 
					               imgElement4.src = response.onead.companies.companyLogoPath;
					               
					               let buttonElement1 =  document.getElementById('phone');
					               buttonElement1.setAttribute("data-value", response.onead.phoneNumber);
					               
					               let buttonElement2 =  document.getElementById('whatsapp');
					               buttonElement2.setAttribute("data-value", response.onead.whatsappNumber);
					            	   
					               var publisherlat=response.onead.location.lat ;
					               var publisherlong =response.onead.location.lng;
					              
					               var addetailtakeme = document.getElementById("addetailmodaltakeme");
					               addetailtakeme.setAttribute("onclick", "takeme('"+ publisherlat + "','"+publisherlong+"')");
					               
					             /*  addetailtakeme.addEventListener("click", function() {
					            	      takeme(publisherlat, publisherlong);
					            	    });*/
					                  for (let i = 0; i < response.onead.a.customTextSection.length; i++) 
					                  { 					               
					               // Create a new p element
					               let p = document.createElement("p"); // Set the text content of the p element
					               var customTextSection=response.onead.a.customTextSection[i].title.replace(/<([^>]+)>/g, '<strong>$1</strong>').replace(/\n/g, "<br/>");
					         //      p.textContent = customTextSection;
					               
					               p.innerHTML = customTextSection;

					               // Convert newlines to <br/>
					              // Find the div element
					               let p2 = document.createElement("p"); // Set the text content of the p element
					               //p2.textContent = response.onead.a.customTextSection[i].description.replace(/\n/g, "<br/>"); // Find the div element
					               //p2.innerHTML = response.onead.a.customTextSection[i].description.replace(/\n/g, "<br/>");
					               
					               
	let safeDescription = response.onead.a.customTextSection[i].description;
    // First, escape all HTML special characters to avoid injection
 /* .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")*/
safeDescription = formatText(safeDescription);

    // Replace &lt;text&gt; with <b>text</b> (removing brackets)
   // .replace(/&lt;([^<>]+)&gt;/g, "<b>$1</b>")
/*.replace(/<([^>]+)>/g, '<b>$1</b>')

    // Convert newlines to <br/>
   .replace(/\n/g, "<br/>");

   */
//Set HTML content
p2.innerHTML = safeDescription;
					               
					               
					               let div = document.getElementById("customtextsection"); // Append the p element to the div 
					               div.appendChild(p);
					               div.appendChild(p2);
					                  
					                  }
					                  var dates = response.onead.dateRange.toDate;
						     	      const date = new Date(dates);
						     	      const formatter = new Intl.DateTimeFormat('en-GB', {
							     	         day: 'numeric',
							     	         month: 'long',
							     	         year: 'numeric'
							     	  });
							     	    const formattedDate = formatter.format(date);
							     	    document.getElementById('pexpiry').innerHTML ='Expires on ' +formattedDate;
							     	    
							     	   var fromdates = response.onead.dateRange.fromDate;
						     	       const fromdate = new Date(fromdates);
						     	       const fromformatter = new Intl.DateTimeFormat('en-GB', {
							     	         day: 'numeric',
							     	         month: 'long',
							     	         year: 'numeric'
							     	     });
							     	   const fromformattedDate = fromformatter.format(fromdate);				     	   
							     	   
							     	 document.getElementById('validfrom').innerHTML =fromformattedDate;
							     	 document.getElementById('validtill').innerHTML =formattedDate;
							     	 if(response.onead.a.adType=='64887c11cce361dafc86c23c'){  //video 
							     		 console.log('video link: ' +response.onead.a.content.videoLink);
							     	var targetDiv = document.getElementById('image-container');
							     	var videolink =  response.onead.a.content.videoLink;
							     	//var videolink='https://keliri.s3.ap-south-1.amazonaws.com/media/ae45e5ac-1113-4ea9-92ea-2326b7bb2f58.mp4';
							     	/*let iframe = document.getElementById('videoframe'); // Set the src attribute using setAttribute method
							     	iframe.setAttribute('src', videolink);*/
							     	let dynamicDiv = document.createElement('div'); 
							     	dynamicDiv.className = 'video-container'; dynamicDiv.style.width='100%';
							     	let iframe = document.createElement('iframe'); 
							     	iframe.src = videolink; // Replace with your URL 
							     	iframe.width = '100%;'; iframe.height = '250px'; iframe.frameBorder = '0';iframe.id='videoframe'; // Append the iframe to the div
							     	iframe.setAttribute('allowfullscreen', ''); iframe.setAttribute('allow','accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture'); 
							     	dynamicDiv.appendChild(iframe); // Append the div to the container 
							     	let container = document.getElementById('image-container');//video 
							     	container.appendChild(dynamicDiv);
							     	container.style.order=1;
							     	let container2 = document.getElementById('addetailModalcarousel-container'); 
							     	container2.style.order=2;
							     	let container3 = document.getElementById('customtextsection'); 
							     	container3.style.order=5;
							     	let container4 = document.getElementById('pexpiry'); 
							     	container4.style.order=3;		
							     
							     	let container5 = document.getElementById('buttons-container'); 
							     	container5.style.order=4;	
							     	let container6 = document.getElementById('addetailModaltext-container');
							     	container6.style.order=6;
							     	let container8 = document.getElementById('validity-container');
							     	container8.style.order=8;
							     
							     	let container7 = document.getElementById('addetailline');
							     	container7.style.order=7;
							     	 }
							     // Set the src attribute directly iframe.src = 'https://www.example.com';
							/*     if(response.onead.a.adType=='64887c11cce361dafc86c23b'){  //banner ad
							    	 let container = document.getElementById('image-container'); 								     	
								     	container.style.order=2;
								     	let container2 = document.getElementById('addetailModalcarousel-container'); 
								     	container2.style.order=1;
								     	
								     	let container3 = document.getElementById('customtextsection'); 
								     	container3.style.order=5;
								     	let container4 = document.getElementById('pexpiry'); 
								     	container4.style.order=3;		
								     
								     	let container5 = document.getElementById('buttons-container'); 
								     	container5.style.order=4;	
								     	let container6 = document.getElementById('addetailModaltext-container');
								     	container6.style.order=6;
								     	let container8 = document.getElementById('validity-container');
								     	container8.style.order=8;
								     
								     	let container7 = document.getElementById('addetailline');
								     	container7.style.order=7;
							     
							    	 for(let j=0;j<response.onead.a.content.banners.length;j++)
							    		 {
							    		// console.log('banners[i] : ' +response.onead.a.content.banners[j]);
							    		 var targetDiv = document.getElementById('image-container');
							    		 targetDiv.innerHTML += ' <img src="<c:url value="'+response.onead.a.content.banners[j]+'"/>" alt="Image" style ="display: block;max-width: 80px;height:70px;">';
							    		 //targetDiv.innerHTML += ' <img src="<c:url value="https://keliri.s3.ap-south-1.amazonaws.com/media/12f49934-89a0-498e-a8b2-b50e60b47985.png"/>" alt="Image" style ="display: block;max-width: 80px;height:70px;">';
				   		
					   		 }}*/
					
						//	     console.log('response.onead.giTag===1: ' +response.onead.giTag);
							     
							     	 if(response.onead.a.adType=='64887c11cce361dafc86c23d'){
							     		 
							     		 console.log('simple text');
							     	 
							    		 let container = document.getElementById('image-container'); 								     	
									     	container.style.order=2;
									     	let container2 = document.getElementById('addetailModalcarousel-container'); 
									     	container2.style.order=1;
									     	
									     	let container3 = document.getElementById('customtextsection'); 
									     	container3.style.order=5;
									     	let container4 = document.getElementById('pexpiry'); 
									     	container4.style.order=3;		
									     
									     	let container5 = document.getElementById('buttons-container'); 
									     	container5.style.order=4;	
									     	let container6 = document.getElementById('addetailModaltext-container');
									     	container6.style.order=6;
									     	let container8 = document.getElementById('validity-container');
									     	container8.style.order=8;
									     
									     	let container7 = document.getElementById('addetailline');
									     	container7.style.order=7; 
							    	     console.log('simple text ad : ' +response.onead.a.content.AdText);
							    		 var targetDiv = document.getElementById('image-container');
							    		 targetDiv.innerHTML +='<p>'+response.onead.a.content.adText+'</p>';
							    	 }
							     	
					   		

							    	 if(response.onead.giTag===1){ //for gi ads
							    		 
							    		 const button = document.createElement("button");
							    		  button.textContent = "Show Vendors";
							    		 // document.getElementById("showgivendors").appendChild(button);
							    		 console.log('show vendors');
							    		 document.getElementById("showgivendors").style.display = "block";
							    		 gitagnumber = response.onead.a.gitagnumber;
							    		 
							    	 }

					                },
					                error: function(xhr, status, error) {
					                   
					                }
					            });
							 
							 $('#addetailModal').modal('show');
							 	 }

//to show the ad in more detail end here

function formatText(safeDescription)
{
	
	let safeDescription2 = safeDescription
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");

// Now safely convert &lt;text&gt; to <b>text</b>
safeDescription2 = safeDescription2.replace(/&lt;([^<>]+)&gt;/g, "<b>$1</b>");

// Convert newlines to <br/>
safeDescription2 = safeDescription2.replace(/\n/g, "<br/>");

return safeDescription2;
}
//button clicks from addetails modal start here

//button clicks from addetail modal end hhere
function phonefrommodal()
{
	var div = document.getElementById("phone");
	var dataValue = div.getAttribute("data-value");//or var dataValue = div.dataset.value;	
	//console.log('in addetail button click : ' +dataValue);
	phoneorwhatsapp=1;
	phone(dataValue);
}
function whatsappfrommodal()
{
	var div = document.getElementById("whatsapp");
	var dataValue = div.getAttribute("data-value");//or var dataValue = div.dataset.value;	
	//console.log('in addetail button click : ' +dataValue);
	phoneorwhatsapp=2;
	whatsapp(dataValue);
}
//to enable the scroll after login modal is closed starts here
// Add an event listener for when any modal is closed
document.addEventListener('hidden.bs.modal', function (event) {
    // Check if any modal is still open
    //console.log('to scroll');
    if (document.querySelectorAll('.modal.show').length > 0) {
        // Add the modal-open class back to the body
        document.body.classList.add('modal-open');
    }
});
$(document).on('hidden.bs.modal', function () {
	 console.log('to scroll');

    if ($('.modal.show').length > 0) {
        $('body').addClass('modal-open');
    }
});
//to enable the scroll after login modal is closed end here


$('#dismissbutton').on('click', function () {
	 //   console.log('Dismiss button clicked!');
	    // Run your function before modal hides
	   
      //pauseVideo();
      var iframe = document.getElementById("videoframe");
      iframe.src = ""; // This unloads the video
  
	  });	
	var player	;
		

  function onYouTubeIframeAPIReady() {
	    player = new YT.Player('videoframe', {
	        events: {
	            'onReady': onPlayerReady
	        }
	    });
	}

	function onPlayerReady(event) {
	    //console.log("Player is ready");
	}

	// Call this function to pause the video
	function pauseVideo() {
		
	//	 console.log("Player is readyyy");
	    if (player) {
	    //	 console.log("Player is ready");
	   
	        player.pauseVideo();
	    }
	}
	
	 var givendor="";
	 var x=0;var givendorId; let markers = []; // Array to keep track of markers	
	 var gitagnumber =0 ; 
	 var showvendorsspotlights = "";
document.getElementById("showvendors").addEventListener("click", function() {
	    //console.log("Button clicked!");
	  /*  var divshowvendors = document.getElementsByClassName(".showvendors-search-container");
        divshowvendors.style.display = "none";*/
        
       /* var div = document.querySelector(".adsvendordiv");//change here
		div.style.display='none';
		var div3 = document.querySelector(".mapvendor");
		  div3.style.display='block';
		  var div4 = document.querySelector(".showvendors-search-button-container");
		  div4.style.display= " none";*/

	/*	 var div =  document.getElementById("locationvendor");
		  div.classList.add('active')
		    var div3 = document.getElementById("adsvendor");
		    div3.classList.remove('active');*/
	    //ajax call to get the vendor last known location, spotlight  and their ads
	    
	      var iframe = document.getElementById("videoframe");
      iframe.src = ""; // This unloads the video
	    fetch('${pageContext.request.contextPath}/showvendors', {
  method: 'PUT', // or 'POST', 'PUT', etc.
  headers: {
    'Content-Type': 'application/json'
  },
  body: /*JSON.stringify({
	     gitagnumber
	  })*/
	  gitagnumber
})
.then(response => {
  if (!response.ok) {
    throw new Error('Network response was not ok');
  }
  return response.json(); // or response.text(), response.blob(), etc.
})
.then(response => {
 // console.log('Success:', response);
  
 
 // to clear the previous content start here 
  for (let i = 0; i < markers.length; i++) {
      markers[i].setMap(null);
    }
  
  markers = [];
  
  document.getElementById("givendorlist").innerHTML = "";
  document.getElementById("advertisementlist").innerHTML = "";
  givendor="";
  // to sort the advertisemnts based on nearest first start here
  
   let array = response.advertisementlist;
	 let sortedArray=	array.sort(function(a, b) { return a.distance - b.distance; });
	 response.advertisementlist = sortedArray;
	//console.log('SORTED: ' +response.advertisementlist);
  // to sort the advertisemnts based on nearest first end here
//to clear the previous content end here 
showvendorsspotlights = response.GISpotlights;
  for(var i=0;i<response.GISpotlights.length;i++)
  {  
	  if(response.GISpotlights[i].id != showvendorscreatedby){
	givendorId = response.GISpotlights[i].id;
  	var name =response.GISpotlights[i].fullName;
  	console.log('response.GISpotlights[i].fullName: ' +name);
  	var profilepicpath= response.GISpotlights[i].profilePicPath;
  	var str = name.substring(0, 10);
  	var userid = response.GISpotlights[i].id;
  	givendor+='<div class="spotlightitem" role="button" id = "'+userid+'" onclick="toaddevent(this);" >'
  +'	<img  src="<c:url value="'+profilepicpath+'" />"  alt="User profile" style="width: 37px;height: 39px;" class="spotlightimg"/>'
  		+'<div class="companyname">'+str+'</div>'
  +'</div>';
  
	  }
  } 
   $('.givendorlist').append(givendor);
   
   //to append GI advertisement start here
   var k,m=0;let showvendorsbounds = new google.maps.LatLngBounds();

    $.each(response.advertisementlist, function (i, myList) {
	// console.log('mylist.giTag: ' +JSON.stringify(myList));
	
	 //if(myList.giTag===1){
		 if(myList.id !=adIdShowVendors){
		 m++;
	//console.log('m: '+m);
 	 var adsid = myList.id;
 	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
 	//console.log('phno : ' +phno);
 	 var email= myList.emailAddress;
 	 var publisher_name = myList.a.title;var fullname =myList.fullName;
// 	 console.log('date sort: '+myList.dateRange.fromDate+'and : '+publisher_name);
 	 var description = myList.a.description;
 	 var dates = myList.dateRange.toDate;
 	const date = new Date(dates);
	var companyName='';
	var latitudes=myList.location.lat;
	var longitudes = myList.location.lng;
	var companyLogoUrl = myList.companies.companyLogoPath;
	var thumbnail = myList.a.thumbnail;
	//console.log('companyLogoUrl: ' +companyLogoUrl);
	var banner1="nopreview.jpg";
	var banner2 = "nopreview.jpg";
	var createdBy = myList.createdBy;
	if(myList.a.adType =='64887c11cce361dafc86c23b' ){
	var baners =  myList.a.content.banners;	  
	
// 	console.log('created by : ' + createdBy);
	if(baners !=null )
		{
		 banner1 = baners[0];
 	if(baners[1] != undefined ){    			
			 banner2 = baners[1];
		 }
		}
	}
 	if(myList.companies==null || myList.companies==undefined){
 	companyName=publisher_name;}
 	else{	     	 companyName= myList.companies.name;}

 // Create a formatter with custom options
 const formatter = new Intl.DateTimeFormat('en-GB', {
     day: 'numeric',
     month: 'long',
     year: 'numeric'
 });

 const formattedDate = formatter.format(date);
//  console.log(formattedDate); // e.g., "29 August 2024"
 	//onclick=nextui(this);
 	 var img_path = "";
 	 k++;
 	 var carouselid= 'myCarouselhome'+k;
 	 //onclick=nextui(this);

 var lattt = parseFloat(myList.location.lat);
    var lnggg = parseFloat(myList.location.lng);
    //console.log('lattt and lnggg : ' + lattt +' ' +lnggg);
    
var ad_card='<div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
    +'<div class="panel-heading">'
    +'<img src="<c:url value="'+companyLogoUrl+'" />" style="height:30px;width:30px;" alt="User profile" class="spotlightimg" loading="lazy"/>'
    +'<div id="frame20"><h5 id="publishername" style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">'+companyName+' </h5></div>'
    +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
    +'<div class="saved"><svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/></svg>'
    +'</div>'
    +'</div>'//heading 
    +'<div class="panel-body" style="padding:0px !important;" >'
    +'<div class="carousel-container">'
    +'<div  class="carousel slide" data-ride="carousel" id="'+carouselid+'">'      
            
    +'<div class="carousel-inner">'
    +'<div class="item active">'
    +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
    +'</div>'
    +'<div class="item">'
    +'<img src="<c:url value="'+banner1+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy" >'
    +'</div>'
    +'<div class="item">'
    +'<img src="<c:url value="'+banner2+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy" >'
    +'</div>'
    +'</div>'      
    
    +'</div>'
    +'</div>'// carousel container 
    +'<div class="text-container">'
    +'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;">'+publisher_name+'</p>'
    +'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+description+'</p>'
    <!--+'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+fullname+'</p>'-->
   <!-- +'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'-->
    +'</div>'
    +'</div>'//<!-- panel body --> 
    +'<div class="line" style ="width: 90%;    margin: 11px 11px;    border-top: 2px solid black;   opacity: 0.1; "></div>'
    +'<div class="panel-footer">'
    +'<div class="phone" id ="phone" onclick=phone('+phno+');><i class="fa fa-phone" style="font-size:20px;"></i></div>'
    +'<div class="whatsapp" id ="whatsapp" onclick=whatsapp('+whatsapp+');><i class="fa fa-whatsapp" style="font-size:20px;"></i></div>'
    +'<div class="email" id ="email"><i class="fa fa-envelope" style="font-size:20px;"></i></div>'
    +'<div class="takeme" ><button  id ="takeme" data-lat='+lattt+' data-long='+lnggg+' onclick=takeme('+lattt+','+lnggg+'); style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Take me there</button></div>'
    +'</div>'
    +'</div>'
 	 $('.advertisementlist').append(ad_card); 

    const location = { lat: lattt, lng: lnggg}; 
   // mvendor.setCenter(location);
    const marker = new google.maps.Marker({
        position: location,
        map: mvendor,
        title: "!!!!!!",
      });
   // const showvendorsposition = new google.maps.LatLng(location.lat, location.lng);

    showvendorsbounds.extend(marker.position);
   // mvendor.fitBounds(showvendorsbounds);

    markers.push(marker);
    
    //on click for each marker start here
   
    var markerDetails ={lat:lattt,lng:lnggg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}
    marker.addListener('click', function() {
  			//console.log('marker clicked');
  			setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
  			});
    
    //on click for each marker end here
		 }//if
    	  }); //.each
    	  
    	  mvendor.fitBounds(showvendorsbounds);

   //to append GI advertisement end here
})
.catch(error => {
  console.error('Error:', error);
});	    
	    $('#showvendorsModal').modal('show');
   
	  });
	const swipeWrapper = document.getElementById('givendorlist');
	//document.addEventListener("DOMContentLoaded", function() {
		//function swipe(){
	//dragging listener for spotlight starts here 2 
	let currentPage = 1;  // Keep track of the current page of items
	let isLoading = false;  // Prevent multiple loads at the same time

	const swipeContainer = document.querySelector('.givendorlists');
	//const swipeWrapper = document.querySelector('.sp');

	// Variables for swipe gesture
	let startX = 0;
	let currentX = 0;
	let offsetX = 0;
	let isSwiping = false;
	let swipeIndex = 0;
	let totalItems = swipeWrapper.children.length;
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
	    
	 // Check if we're at the start or end of the items and prevent further movement
	    if ((swipeIndex === 0 && offsetX > 0) || (swipeIndex === totalItems - 1 && offsetX < 0)) {
	    	console.log('disable swipe');
	        return;  // Disable swipe if we're at the first or last item
	    }
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
	     // loadItems(currentPage);  // Load the next batch of items
	    }

	    isSwiping = false;
	    startX = 0;
	    currentX = 0;
	    offsetX = 0;
	});	
	function showCard(userData)
	{
		 //console.log('userData' +JSON.stringify(userData));
		//console.log('show CARD : ' +document.getElementById("cardtitle").textContent);
		  document.getElementById("cardtitle").textContent = userData.title;
		  document.getElementById("cardcompanyurl").src = '<c:url value="'+userData.companyLogoUrl+'" />';
		  document.getElementById("cardpublishername").textContent = userData.companyName;
		 // "cardcompanyurl"
		  document.getElementById("cardpublishername").textContent = userData.companyName;
		 
		 document.getElementById("cardthumbnail").src = '<c:url value="'+userData.thumbnail+'" />';
		var phonebutton = document.getElementById("cardphone");
		phonebutton.setAttribute("onclick", "phone('"+userData.phno+"')");
			var whatsappbutton = document.getElementById("cardwhatsapp");
			whatsappbutton.setAttribute("onclick", "whatsapp('"+userData.phno+"')");
				var takemetherebutton = document.getElementById("cardtakeme");
				takemetherebutton.setAttribute("onclick", "takeme('"+userData.lat+"','"+userData.lng+"')");
		 const cardContainer = document.getElementById('markercard-container');
		 cardContainer.style.display='block';
		}

	
	document.addEventListener("click", function(event) {
	    var card = document.getElementById("markercard-container"); 
	    // If the click is outside the card and the button, hide the card
	    if (card && !card.contains(event.target) ) {
	        card.style.display = "none";  // Hide the card
	    }
	});
	
	function setActiveButton(button) {	 
	    const buttons = button.parentNode.querySelectorAll('.btn');// Remove 'active' class from all buttons in the group
	    buttons.forEach(btn => btn.classList.remove('active'));    
	    button.classList.add('active');// Add 'active' class to the clicked button
	    var buttonId = button.id;

	    if (buttonId=="locationvendor"){
	    var div = document.querySelector(".adsvendordiv");//change here
		div.style.display='none';
		var div3 = document.querySelector(".mapvendor");
		  div3.style.display='block';
		  var div4 = document.querySelector(".showvendors-search-button-container");
		  div4.style.display= " none";
		  
		}    
	    if (buttonId=="adsvendor"){ 
	    	  var div3 = document.querySelector(".mapvendor");
	    	  div3.style.display='none'; 
	    	  var div2 = document.querySelector(".adsvendordiv");
	    	  div2.style.display='block';
	    	  var div5 = document.querySelector(".showvendors-search-button-container");
			  div5.style.display= " block";
	    	  
	    }
	}
	
	
	//show vendors search start here
	
	
//serch in spotlight starts from here 1

 document.getElementById('showvendorsinputsearch').addEventListener('input', function() {
     const query =$('#showvendorsinputsearch').val(); //this.value;
     //console.log('input is : '+query);
  //   const swipeWrapper = document.getElementById('spotlightlist');
     swipeWrapper.style.transform='';
    // console.log('input : '+query);
     const resultsContainer = document.getElementById('givendorlist');
	    resultsContainer.innerHTML = ""; // Clear previous results
     const filteredResults = filterArray(query);
     displayResults(filteredResults);
 });
 
 function filterArray(query) {
	    const lowerCaseQuery = query.toLowerCase();
	    return showvendorsspotlights.filter(showvendorsspotlights => 	    
	    showvendorsspotlights.fullName.toLowerCase().includes(lowerCaseQuery) 
	       // item.category.toLowerCase().includes(lowerCaseQuery)
	    );
	}
 function displayResults(results) {
	 var spotlightt="";
	    const resultsContainer = document.getElementsByClassName('givendorlist');
	    resultsContainer.innerHTML = ''; // Clear previous results
        
	    for(var i=0;i<results.length;i++)
	    {
	    	var name =results[i].fullName;
	    	var profilepicpath= results[i].profilePicPath;
	    	var str = name.substring(0, 10);
	    	var usrphno = results[i].phoneNumber.dialNumber;
	    	var userid = results[i].id;
	    	 spotlightt+='<div class="spotlightitem" role="button" id="'+userid+'" onclick="toaddevent(this);">'
	    +'	<img  src="<c:url value="'+profilepicpath+'" />"  alt="User profile" style="width: 37px;height: 39px;" class="spotlightimg"  />'
	    		+'<div class="cn">'+str+'</div>'
		+' 		</div>';		    
	    	}	
	 //  console.log('tt: ' +spotlightt);
		 $('.givendorlist').append(spotlightt);
	}
 
 
 var button = document.getElementById("showvendorssearch");

//Attach an event listener to the button
button.addEventListener("click", function() {
$(".showvendors-search-container").show();
$(".showvendors-search-button-container").hide();
const input = document.getElementById('usr');
input.style.width = '100%';
});

var searchclosebutton =  document.getElementById("showvendorssearchclose");
searchclosebutton.addEventListener("click", function() {
	$(".showvendors-search-container").hide();
	 $(".showvendors-search-button-container").show();
});
 //}
 
 //end here 1
//search spotlight end here
	//show vendors search end here
	
	
//on click of each spotlight start here
var spotlightId;
function toaddevent(button){
	//$('.spotlightitem').on('click', function() {//for dynamic 
		//const flexItems = document.querySelectorAll('.spotlightitem'); 
	 //    console.log('You clicked ' );
		 //var y =  $(this).attr('id') ;
		 var y =  button.id ;
		 spotlightId =y;
		 //console.log('spotlightId : ' +spotlightId);
		 var k=0;
		 var div5 = document.querySelector(".advertisementlist");
		 div5.innerHTML ="";
		 const removeactive = button.parentNode.querySelectorAll('.spotlightitem');// spotlight bckground
		 removeactive.forEach(btn => {
		 btn.style.background= 'none';});
		 const selectedSpotlyt = document.getElementById(y);
		 selectedSpotlyt.style.width= '73px';
		 selectedSpotlyt.style.height='95px';
		 selectedSpotlyt.style.background= 'linear-gradient(90deg, rgba(242, 124, 10, 0.1) 0%, rgba(242, 56, 44, 0.1) 100%)';
		
		 $.ajax({
			 url: '${pageContext.request.contextPath}/showvendorsspotlight', // Sample API endpoint
			 method: 'POST',
			// contentType: 'text/plain',
			 data: {
				    spotlightId: spotlightId,
				    gitagnumber: gitagnumber
				  },


			 success: function(data) {
			 // Clear previous data // Iterate through the data and display it
			 $.each(data, function (i, myList) {
			 var adsid = myList.id;
			 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
			 var email= myList.emailAddress;
			 var publisher_name = myList.a.title;
			 var publisherName= myList.fullName;
			 var description = myList.a.description;var fullname = myList.fullName;
			 var dates = myList.dateRange.toDate;
			 const date = new Date(dates);
			 var companyName='';
			 var latitudes=myList.location.lat;
			 var longitudes = myList.location.lng;
			 var companyLogoUrl = myList.companies.companyLogoPath;
			 var thumbnail = myList.a.thumbnail;
			 var banner1="nopreview.jpg";
			 var banner2 = "nopreview.jpg";
			 var nooffol = myList.noOfFollow;
			 var noofcam = myList.noOfCampaigns;
			 var profilepic= myList.profilePicturePath;var createdBy = myList.createdBy;
			 if(myList.a.adType =='64887c11cce361dafc86c23b'){
			 var baners = myList.a.content.banners;
			 if(baners !=null )
			 {
			 banner1 = baners[0];
			 if(baners[1] != undefined ){
			 banner2 = baners[1];
			 }
			 }
			 }
			 // banner1="nopreview.jpg";
			 // banner2 = "nopreview.jpg";
			 if(myList.companies==null || myList.companies==undefined){//console.log('inside if'+publisher_name);
			 companyName=publisher_name;}
			 else{ companyName= myList.companies.name;}
			 //console.log('company name : '+companyName);
			 // Create a formatter with custom options
			 const formatter = new Intl.DateTimeFormat('en-GB', {
			 day: 'numeric',
			 month: 'long',
			 year: 'numeric'
			 });

			 const formattedDate = formatter.format(date);
			 // console.log(formattedDate); // e.g., "29 August 2024"
			 //onclick=nextui(this);
			 var img_path = "";
			 k++;
			 var carouselid= 'myCarouselspotlyt'+k;
			 //onclick=nextui(this);
			 
			 var lattt = parseFloat(myList.location.lat);
    		 var lnggg = parseFloat(myList.location.lng);
    	//	 console.log('fullname : ' +fullname);
			 var ad_card='<div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
			    +'<div class="panel-heading">'
			    +'<img src="<c:url value="'+companyLogoUrl+'" />" style="height:30px;width:30px;" alt="User profile" class="spotlightimg" loading="lazy"/>'
			    +'<div id="frame20"><h5 id="publishername" style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">'+companyName+' </h5></div>'
			    +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
			    +'<div class="saved"><svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/></svg>'
			    +'</div>'
			    +'</div>'//heading 
			    +'<div class="panel-body" style="padding:0px !important;" >'
			    +'<div class="carousel-container">'
			    +'<div  class="carousel slide" data-ride="carousel" id="'+carouselid+'">'      
			            
			    +'<div class="carousel-inner">'
			    +'<div class="item active">'
			    +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
			    +'</div>'
			    +'<div class="item">'
			    +'<img src="<c:url value="'+banner1+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy" >'
			    +'</div>'
			    +'<div class="item">'
			    +'<img src="<c:url value="'+banner2+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy" >'
			    +'</div>'
			    +'</div>'      
			    
			    +'</div>'
			    +'</div>'// carousel container 
			    +'<div class="text-container">'
			    +'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;">'+publisher_name+'</p>'
			    +'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+description+'</p>'
			    <!--+'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+fullname+'</p>'-->
			  <!--  +'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'-->
			    +'</div>'
			    +'</div>'//<!-- panel body --> 
			    +'<div class="line" style ="width: 90%;    margin: 11px 11px;    border-top: 2px solid black;   opacity: 0.1; "></div>'
			    +'<div class="panel-footer">'
			    +'<div class="phone" id ="phone" onclick=phone('+phno+');><i class="fa fa-phone" style="font-size:20px;"></i></div>'
			    +'<div class="whatsapp" id ="whatsapp" onclick=whatsapp('+whatsapp+');><i class="fa fa-whatsapp" style="font-size:20px;"></i></div>'
			    +'<div class="email" id ="email"><i class="fa fa-envelope" style="font-size:20px;"></i></div>'
			    +'<div class="takeme" ><button  id ="takeme" data-lat='+lattt+' data-long='+lnggg+' onclick=takeme('+lattt+','+lnggg+'); style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Take me there</button></div>'
			    +'</div>'
			    +'</div>'
			 	 $('.advertisementlist').append(ad_card); 			 });
			 }
		 });
	}


//on click of each spotlight end here
var currentradiusfromsession = <%= session.getAttribute("slider") == null ? "null" : session.getAttribute("slider") %>;
if(currentradiusfromsession != null){
console.log('currentradiusfromsession if: ' +currentradiusfromsession);	

document.getElementById("radius").value = Number(currentradiusfromsession).toFixed(1);

}
else
	{
	document.getElementById("radius").value = (2.0).toFixed(1);
	}


document.getElementById("gobutton").addEventListener("click", function() {
	
	  const inputRadius1 = document.getElementById("radius");	  
	  const inputRadius = parseFloat(inputRadius1.value);
	//  console.log('inputRadius: ' +inputRadius);		 
	  var k=0;
	  $.ajax({
          url: '${pageContext.request.contextPath}/combined',
          type: "POST",
          //contentType: 'application/json',
          data:{slidervalue:inputRadius},
          success: function(data) {
        	  
          data = JSON.parse(data);
          //console.log('data: ' +data);
 if (distancebutton.classList.contains('inactivesort')) {
		    distancebutton.classList.remove('inactivesort');
		    distancebutton.classList.add("activesort");
			distance=1;time=0;
			timebutton.classList.remove("activesort");
			timebutton.classList.add("inactivesort");
		} else {
		    // Add the class
		    //currentClasses.add('newClass');
		}
		 if(distance===1)
		 {	
		 let array = data;
		 let sortedArray=	array.sort(function(a, b) { return a.distance - b.distance; });
		 data = sortedArray;
//		 console.log('distance =1' );
		 }
	 if (time===1)
		 {
		  //  let dateTimeArray = currentAdsData;
		    let dateTimeArray = data;
			let dateTimeArraySorted=dateTimeArray.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
			data = dateTimeArraySorted;
			// console.log('time =1' +JSON.stringify(data));
		 }
	    currentAdsData=data;
	   
	       document.getElementById("ads").innerHTML = "";
	   	noofresults=data.length;
	   	//console.log("NO OF RESULTS : " +noofresults);
		 $('#noofresults').html('Results: '+noofresults) ;
		 
 $.each(data, function (i, myList) {
    	
    	     var adsid = myList.id;
	     	 var phno = myList.phoneNumber;
	     	var whatsapp = myList.whatsappNumber;
	     	 var email= myList.emailAddress;var distance = myList.distance.toFixed(2);
    	 var publisher_name = myList.a.title;
   
    	 var description = myList.a.description; var fullname = myList.fullName;
    	 var dates = myList.dateRange.toDate;
    	const date = new Date(dates);
   	var companyName='';
   	var latitudes=myList.location.lat;
	var longitudes = myList.location.lng;
   	var companyLogoUrl = myList.companies.companyLogoPath;
	var thumbnail = myList.a.thumbnail;
	
	var banner1="nopreview.jpg";
	var banner2 = "nopreview.jpg";	var createdBy = myList.createdBy;
	if(myList.a.adType =='64887c11cce361dafc86c23b' ){
	var baners =  myList.a.content.banners;
		    	
	if(baners !=null )
		{
		 banner1 = baners[0];
		
	
		 if(baners[1] != undefined ){
		
			
			 banner2 = baners[1];
		 }
		}
	}
    	if(myList.companies==null || myList.companies==undefined){
    	companyName=publisher_name;}
    	else{	     	 companyName= myList.companies.name;}
	
    const formatter = new Intl.DateTimeFormat('en-GB', {
        day: 'numeric',
        month: 'long',
        year: 'numeric'
    });

    const formattedDate = formatter.format(date);
 
    	
    	 var img_path = "";
     k++;
 	 var carouselid= 'myCarouselhome'+k;
 	 
 	 if	 ( [
	        busenabled,
	        carenabled,
	        rickshawenabled,
	        roadenabled
	    ].some(v => v === 1) ) 
 	 {
 	 var ad_card='<div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
         +'<div class="panel-heading">'
         +'<img src="<c:url value="'+companyLogoUrl+'" />"  style="height:30px;width:30px;" alt="User profile" class="spotlightimg" loading="lazy" />'
         +'<div id="frame20"><h5 id="publishername" style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">'+companyName+' </h5></div>'
         +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
         +'<div class="saved"><svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/></svg>'
         +'</div>'
         +'</div>'//heading 
         +'<div class="panel-body" style="padding:0px !important;">'
         +'<div class="carousel-container">'
         +'<div  class="carousel slide" data-ride="carousel" id="'+carouselid+'">'	           
         
         +'<div class="carousel-inner">'
         +'<div class="item active">'
         +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
         +'</div>'
         +'<div class="item">'
         +'<img src="<c:url value="'+banner1+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
         +'</div>'
         +'<div class="item">'
         +'<img src="<c:url value="'+banner2+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
         +'</div>'
         +'</div>'	          
         
         +'</div>'
         +'</div>'// carousel container 
         +'<div class="text-container">'
       <!--  +'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;">'+publisher_name+'</p>'-->
       +'<div style="display:flex;justify-content:space-between;align-items:center;font-family:Inter;">'
	       + '<span style="font-weight:700;font-size:16px;">' + publisher_name + '</span>'
	       + '<span style="font-weight:500;font-size:14px;color:#666;">' + distance + '</span>'
	       + '</div>'
         +'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+description+'</p>'
         <!--+'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+fullname+'</p>'-->
       <!--  +'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'-->
         +'</div>'
         +'</div>'//<!-- panel body --> 
         +'<div class="line" style ="width: 90%;    margin: 11px 11px;    border-top: 2px solid black;   opacity: 0.1; "></div>'
         +'<div class="panel-footer">'
         +'<div class="phone" id ="phone" onclick=phone('+phno+');><i class="fa fa-phone" style="font-size:20px;"></i></div>'
         +'<div class="whatsapp" id ="whatsapp" onclick=whatsapp('+whatsapp+');><i class="fa fa-whatsapp" style="font-size:20px;"></i></div>'
         +'<div class="email" id ="email"><i class="fa fa-envelope" style="font-size:20px;"></i></div>'
         +'<div class="takeme" ><button  id ="takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takemefromvehicle('+latitudes+','+longitudes+',\''+adsid+'\'); style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Show location</button></div>'
         +'</div>'
         +'</div>'
 	 }
 	 else
 		 {
 	var ad_card='<div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
        +'<div class="panel-heading">'
        +'<img src="<c:url value="'+companyLogoUrl+'" />"  style="height:30px;width:30px;" alt="User profile" class="spotlightimg" loading="lazy" />'
        +'<div id="frame20"><h5 id="publishername" style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">'+companyName+' </h5></div>'
        +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
        +'<div class="saved"><svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/></svg>'
        +'</div>'
        +'</div>'//heading 
        +'<div class="panel-body" style="padding:0px !important;">'
        +'<div class="carousel-container">'
        +'<div  class="carousel slide" data-ride="carousel" id="'+carouselid+'">'
       
        
        +'<div class="carousel-inner">'
        +'<div class="item active">'
        +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
        +'</div>'
        +'<div class="item">'
        +'<img src="<c:url value="'+banner1+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
        +'</div>'
        +'<div class="item">'
        +'<img src="<c:url value="'+banner2+'" />" alt="Image" style ="display: block;max-width: 100%;height: 300px;width: 100%;" loading="lazy">'
        +'</div>'
        +'</div>'
      
        
        +'</div>'
        +'</div>'// carousel container 
        +'<div class="text-container">'
        +'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;">'+publisher_name+'</p>'
        +'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+description+'</p>'
        <!--+'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+fullname+'</p>'-->
      <!--  +'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'-->
        +'</div>'
        +'</div>'//<!-- panel body --> 
        +'<div class="line" style ="width: 90%;    margin: 11px 11px;    border-top: 2px solid black;   opacity: 0.1; "></div>'
        +'<div class="panel-footer">'
        +'<div class="phone" id ="phone" onclick=phone('+phno+');><i class="fa fa-phone" style="font-size:20px;"></i></div>'
        +'<div class="whatsapp" id ="whatsapp" onclick=whatsapp('+whatsapp+');><i class="fa fa-whatsapp" style="font-size:20px;"></i></div>'
        +'<div class="email" id ="email"><i class="fa fa-envelope" style="font-size:20px;"></i></div>'
        +'<div class="takeme" ><button  id ="takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+'); style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Take me there</button></div>'
        +'</div>'
        +'</div>'
 		 }
     	 $('.ads').append(ad_card);

       var  latt = 13.529271965260616;    var lngg = 75.36285138756304; 
  
    const lattt =  myList.location.lat; const longgg= myList.location.lng ;

var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}
  	  }); //.each
  	  
          }
	  });
});

/*
function handleVideoAutoplay() {
	 var videos = document.querySelectorAll('.ad-video');

	    if (!('IntersectionObserver' in window)) return;

	    var observer = new IntersectionObserver(function (entries) {

	        entries.forEach(function (entry) {
	            var video = entry.target;

	            if (entry.isIntersecting) {

	                // pause & mute all OTHER videos
	                videos.forEach(function (v) {
	                    if (v !== video) {
	                        v.pause();
	                        v.currentTime = 0;
	                        v.muted = true;
	                    }
	                });

	                // play current video (muted)
	                video.play().catch(function () {});

	            } else {
	                // out of viewport → stop
	                video.pause();
	                video.currentTime = 0;
	            }
	        });

	    }, {
	        threshold: 0.6
	    });

	    videos.forEach(function (video) {
	        observer.observe(video);
	    });

}
 
 handleVideoAutoplay();
  
 document.addEventListener('click', function (e) {

	 if (e.target.tagName === 'VIDEO') {

	        var clickedVideo = e.target;

	        document.querySelectorAll('.ad-video').forEach(function (video) {
	            if (video !== clickedVideo) {
	                video.muted = true;
	                video.pause();
	                video.currentTime = 0;
	            }
	        });

	        clickedVideo.muted = false;
	    }
	});
*/
/*function handleScrollAutoplay() {
    const videoElems = Array.from(document.querySelectorAll('.ad-video'));

    // Helper to get visibility % of element in viewport
    function getVisibilityPercent(el) {
        const rect = el.getBoundingClientRect();
        const h = rect.height;
        const visible = Math.max(0, Math.min(rect.bottom, window.innerHeight) - Math.max(rect.top, 0));
        return visible / h;
    }

    // YouTube players map
    const ytPlayers = {};

    // Initialize YouTube iframe players
    videoElems.forEach(el => {
        if (el.tagName === 'IFRAME' && el.src.includes('youtube.com')) {
            const id = el.id || ('yt-' + Math.random().toString(36).substr(2, 9));
            el.id = id;
            ytPlayers[id] = new YT.Player(id, { events: { onReady: () => {} } });
        }
    });

    function playMostVisible() {
        let mostVisible = null;
        let maxPercent = 0;

        videoElems.forEach(el => {
            const percent = getVisibilityPercent(el);
            if (percent > maxPercent) {
                maxPercent = percent;
                mostVisible = el;
            }
        });

        videoElems.forEach(el => {
            if (el === mostVisible) {
                if (el.tagName === 'VIDEO') {
                    el.play().catch(() => {});
                } else if (el.tagName === 'IFRAME' && ytPlayers[el.id]) {
                    ytPlayers[el.id].playVideo();
                }
            } else {
                if (el.tagName === 'VIDEO') {
                    el.pause();
                } else if (el.tagName === 'IFRAME' && ytPlayers[el.id]) {
                    ytPlayers[el.id].pauseVideo();
                }
            }
        });
    }

    window.addEventListener('scroll', playMostVisible);
    window.addEventListener('resize', playMostVisible);
    playMostVisible(); // Initial check
}

// Wait until YouTube API is ready
function onYouTubeIframeAPIReady() {
    handleScrollAutoplay();
}
*/
//Store YouTube players
<!-- YouTube iframe API -->


// ============================================
// VIDEO AUTO-PLAY/PAUSE SYSTEM - FIXED UNMUTE
// ============================================

var youtubePlayers = {};
var playerIdCounter = 0;
var youtubeAPIReady = false;
var videoObserver = null;
var currentlyPlayingVideo = null;
var isPlayingLocked = false;
var userUnmutedVideos = new Set(); // Track user-unmuted videos

// ============================================
// YOUTUBE API INITIALIZATION
// ============================================

function onYouTubeIframeAPIReady() {
    //console.log('✅ YouTube API Ready');
    youtubeAPIReady = true;
}

function createYouTubePlayer(iframeId, retryCount) {
    retryCount = retryCount || 0;
    
    if (!youtubeAPIReady && retryCount < 10) {
        setTimeout(function() {
            createYouTubePlayer(iframeId, retryCount + 1);
        }, 500);
        return;
    }
    
    if (!youtubeAPIReady) {
      //  console.error('❌ YouTube API failed to load');
        return;
    }
    
    try {
        //console.log('🎬 Creating player: ' + iframeId);
        youtubePlayers[iframeId] = new YT.Player(iframeId, {
            events: {
                'onReady': function(event) {
                 //   console.log('✅ Player ready: ' + iframeId);
                    // Only mute on ready, user can unmute later
                    event.target.mute();
                },
                'onStateChange': function(event) {
                    var iframe = document.getElementById(iframeId);
                    
                    // YT.PlayerState.PLAYING = 1
                    if (event.data === 1) {
                        currentlyPlayingVideo = iframe;
                        stopAllOtherVideos(iframe);
                       // console.log('▶️ YouTube now playing: ' + iframeId);
                    }
                    
                    // Detect user unmute
                    if (event.data === 1) {
                        try {
                            if (!event.target.isMuted()) {
                                userUnmutedVideos.add(iframeId);
                               // console.log('👤 User unmuted YouTube: ' + iframeId);
                            }
                        } catch(e) {}
                    }
                }
            }
        });
    } catch(e) {
      //  console.error('❌ Error creating player:', e);
    }
}

// ============================================
// STOP ALL OTHER VIDEOS
// ============================================

function stopAllOtherVideos(currentVideo) {
    var allVideos = document.querySelectorAll('.ad-video');
    
    allVideos.forEach(function(video) {
        // Skip the currently playing video
        if (video === currentVideo) {
            return;
        }
        
        // Stop and mute ALL other videos
        if (video.tagName === 'VIDEO') {
            if (!video.paused) {
                video.pause();
                console.log('⏹️ Stopped MP4');
            }
            // Only mute if user hasn't unmuted it
            var videoIndex = Array.from(document.querySelectorAll('.ad-video')).indexOf(video);
            if (!userUnmutedVideos.has('mp4-' + videoIndex)) {
                video.muted = true;
            }
        } 
        else if (video.tagName === 'IFRAME') {
            var playerId = video.id;
            if (youtubePlayers[playerId]) {
                try {
                    var playerState = youtubePlayers[playerId].getPlayerState();
                    if (playerState === 1) { // Only if playing
                        youtubePlayers[playerId].stopVideo();
                        // Only mute if user hasn't unmuted it
                        if (!userUnmutedVideos.has(playerId)) {
                            youtubePlayers[playerId].mute();
                        }
                       // console.log('⏹️ Stopped YouTube: ' + playerId);
                    }
                } catch(e) {
                   // console.error('Error stopping YouTube:', e);
                }
            }
        }
    });
}

// ============================================
// INTERSECTION OBSERVER SETUP
// ============================================

function initVideoObserver() {
    if (videoObserver) {
        return;
    }
    
    var options = {
        root: null,
        rootMargin: '0px',
        threshold: 0.5
    };

    var callback = function(entries, observer) {
        entries.forEach(function(entry) {
            var videoElement = entry.target;
            var videoId = videoElement.id || 'unknown';
            
            if (entry.isIntersecting) {
                //console.log('👁️ Video IN viewport: ' + videoId);
                setTimeout(function() {
                    playVideoSafe(videoElement);
                }, 100);
            } else {
              //  console.log('👁️ Video OUT of viewport: ' + videoId);
                pauseVideoSafe(videoElement);
            }
        });
    };

    videoObserver = new IntersectionObserver(callback, options);
   // console.log('✅ Observer initialized');
}

// ============================================
// VIDEO PLAY FUNCTIONS
// ============================================

function playVideoSafe(element) {
    if (isPlayingLocked) {
     //   console.log('⏳ Play locked, waiting...');
        return;
    }
    
    isPlayingLocked = true;
    
    // Stop all other videos FIRST
    stopAllOtherVideos(element);
    
    setTimeout(function() {
        if (element.tagName === 'VIDEO') {
            playMP4Video(element);
        } else if (element.tagName === 'IFRAME') {
            playYouTubeVideoSafe(element);
        }
        
        isPlayingLocked = false;
    }, 200);
}

function playMP4Video(element) {
   // console.log('▶️ Attempting MP4 play');
    
    var videoIndex = Array.from(document.querySelectorAll('.ad-video')).indexOf(element);
    var videoKey = 'mp4-' + videoIndex;
    
    // Only mute if user hasn't unmuted it before
    if (!userUnmutedVideos.has(videoKey)) {
        element.muted = true;
    }
    
    // Don't force volume to 0 - let user control it
    
    var playPromise = element.play();
    
    if (playPromise !== undefined) {
        playPromise.then(function() {
         //   console.log('✅ MP4 playing (muted: ' + element.muted + ')');
            currentlyPlayingVideo = element;
        }).catch(function(error) {
       //     console.error('❌ MP4 autoplay blocked:', error.message);
            isPlayingLocked = false;
        });
    }
}

function playYouTubeVideoSafe(element) {
    var playerId = element.id;
  //  console.log('▶️ Attempting YouTube play: ' + playerId);
    
    if (!youtubePlayers[playerId]) {
       // console.log('⚠️ Player not found, creating: ' + playerId);
        createYouTubePlayer(playerId);
        
        setTimeout(function() {
            playYouTubeVideo(playerId);
        }, 1500);
    } else {
        playYouTubeVideo(playerId);
    }
}

function playYouTubeVideo(playerId) {
    if (youtubePlayers[playerId]) {
        try {
            // Only mute if user hasn't unmuted it before
            if (!userUnmutedVideos.has(playerId)) {
                youtubePlayers[playerId].mute();
            }
            
            if (typeof youtubePlayers[playerId].playVideo === 'function') {
                youtubePlayers[playerId].playVideo();
              //  console.log('✅ YouTube playing: ' + playerId);
                currentlyPlayingVideo = document.getElementById(playerId);
            }
        } catch(e) {
           // console.error('❌ Error playing YouTube:', e.message);
        }
    }
}

// ============================================
// VIDEO PAUSE FUNCTIONS
// ============================================

function pauseVideoSafe(element) {
    if (element.tagName === 'VIDEO') {
        //console.log('⏸️ Pausing MP4');
        element.pause();
        
        // Only mute if user hasn't unmuted it
        var videoIndex = Array.from(document.querySelectorAll('.ad-video')).indexOf(element);
        var videoKey = 'mp4-' + videoIndex;
        if (!userUnmutedVideos.has(videoKey)) {
            element.muted = true;
        }
    } 
    else if (element.tagName === 'IFRAME') {
        var playerId = element.id;
       // console.log('⏸️ Pausing YouTube: ' + playerId);
        
        if (youtubePlayers[playerId]) {
            try {
                youtubePlayers[playerId].stopVideo();
                
                // Only mute if user hasn't unmuted it
                if (!userUnmutedVideos.has(playerId)) {
                    youtubePlayers[playerId].mute();
                }
               // console.log('✅ YouTube stopped: ' + playerId);
            } catch(e) {
               // console.error('❌ Error pausing YouTube:', e.message);
            }
        }
    }
    
    if (currentlyPlayingVideo === element) {
        currentlyPlayingVideo = null;
    }
}

// ============================================
// MAIN OBSERVATION FUNCTION
// ============================================

function observeVideos() {
   // console.log('🔍 observeVideos called');
    
    if (!videoObserver) {
        initVideoObserver();
    }
    
    var allVideos = document.querySelectorAll('.ad-video');
    //console.log('📹 Found ' + allVideos.length + ' total videos');
    
    if (allVideos.length === 0) {
        console.warn('⚠️ No videos found!');
        return;
    }
    
    allVideos.forEach(function(video, index) {
        var tagName = video.tagName;
        
        if (tagName === 'IFRAME') {
            // YouTube video
            if (!video.id) {
                video.id = 'youtube-player-' + (playerIdCounter++);
            }
            
            if (!youtubePlayers[video.id]) {
                createYouTubePlayer(video.id);
            }
        } 
        else if (tagName === 'VIDEO') {
            // MP4 video
            video.muted = true; // Initial mute
            video.setAttribute('playsinline', '');
            
            var videoKey = 'mp4-' + index;
            
            // Listen for manual play
            video.addEventListener('play', function(e) {
                if (currentlyPlayingVideo !== video) {
                    console.log('👤 User manually played MP4');
                    stopAllOtherVideos(video);
                    currentlyPlayingVideo = video;
                }
            });
            
            // Listen for manual unmute
            video.addEventListener('volumechange', function(e) {
                if (!video.muted) {
                    userUnmutedVideos.add(videoKey);
                    console.log('👤 User unmuted MP4');
                }
            });
        }
        
        // Observe the video
        videoObserver.observe(video);
        //console.log('👁️ Observing: ' + (video.id || 'MP4-' + index));
    });
    
  //  console.log('✅ All videos observed');
}

// ============================================
// INITIALIZE ON PAGE LOAD
// ============================================

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
  //      console.log('📄 DOM Ready');
        initVideoObserver();
    });
} else {
    //console.log('📄 DOM Already Ready');
    initVideoObserver();
}

// Periodic check - only stops OTHER videos, doesn't re-mute current
setInterval(function() {
    if (currentlyPlayingVideo) {
        var allVideos = document.querySelectorAll('.ad-video');
        allVideos.forEach(function(video) {
            if (video !== currentlyPlayingVideo) {
                if (video.tagName === 'VIDEO' && !video.paused) {
                    video.pause();
                } else if (video.tagName === 'IFRAME') {
                    var playerId = video.id;
                    if (youtubePlayers[playerId]) {
                        try {
                            var state = youtubePlayers[playerId].getPlayerState();
                            if (state === 1) { // Playing
                                youtubePlayers[playerId].pauseVideo();
                            }
                        } catch(e) {}
                    }
                }
            }
        });
    }
}, 2000);

function takemefromvehicle(lats,lngs,adsid)
{
	 event.stopPropagation();
//console.log('In TAKE ME ');
var takemelatlocal ;
var takemelnglocal ;	
	$.ajax({
url: '${pageContext.request.contextPath}/getSessionVariableLocation',
method: 'GET',
async:false,
success: function(data) {
	takemelatlocal = data.lat;
	takemelnglocal = data.lng;
},
error: function(xhr, status, error) {
console.error("Error fetching session variable: ", error);
}
});
const originLat = takemelatlocal; //
const originLng = takemelnglocal; //
const destinationLat = lats;
const destinationLng = lngs;

var url = "<%=request.getContextPath()%>/vehicleRoute?adsId=" + encodeURIComponent(adsid);
  window.location.href = url;
}


</script>
<jsp:include page="responsivefooter.jsp" /> 
</body>
</html>
