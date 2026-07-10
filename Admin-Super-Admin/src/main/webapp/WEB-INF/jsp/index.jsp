<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="form"  uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1" name="viewport" />
<title>Keliri</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
     <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
 
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
 <!--   <script src="https://maps.googleapis.com/maps/api/js?key=${googleMapsApiKey}"></script> -->
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=${googleMapsApiKey}"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js" type="text/javascript"></script>
<!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"> -->

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

<link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap" rel="stylesheet">
  
  
 <!--  <script src="js/jquery-1.7.1.min.js"></script>
<script src="js/bootstrap.js"></script> -->
<style>
html {
    height: 100%;
}
body {
    min-height: 100%;
     background-color: #f1f1f1;
    margin: 0;        /* Remove default margin */
    padding: 0; 
}
* { 
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}
.col-md-6
{
display: flex;
padding: 30px 20px;
align-items: center;
gap: 10px;
border-radius: 20px;
background: #FBFBFB;
margin-left:76px;
margin-top:18px;
}
#col-md-4
{
display: flex;
height: 300px;
padding: 30px;/*30px*/
flex-direction: column;
/*align-items: flex-start;*/
/*gap: 20px;*/
align-self: stretch;
border-radius: 20px;
background: #FFF;
margin-left: 43px;
    margin-top: 18px;
    width: 487px;
    padding-top:10px;
    transition: flex-grow 0.3s ease; 
/*    z-index:18;*/
  position:relative;
}
.col-md-4-spot
{
display: flex;
/*height: 180px;*/
padding: 30px;
flex-direction: column;
align-items: flex-start;
gap: 20px;
align-self: stretch;
border-radius: 20px;
background: #FFF;
margin-left: 43px;
margin-top: 18px;
width: 487px;
margin-bottom:18px;
/*flex-grow:1;*/
overflow:hidden;
/*overflow-x: auto;*/
overflow-y: hidden;
white-space: nowrap;
}
/*.maincontainer
{
display: inline-flex;
align-items: flex-start;
gap: 25px;
}*/
.frame68
{
display: flex;
align-items: flex-start;
gap: 10px;
align-self: stretch;
flex-direction:column;
 transition: flex-grow 0.3s ease; 
}
.frame54
{
display: flex;
width: 658px;
flex-direction: column;
align-items: flex-start;
gap: 20px;
}
.frame57{
display: flex;
height: 44px;
justify-content: center;
align-items: center;
gap: 10px;
flex: 1 0 0;}
 /* .mapcontainer:hover
    {
    height:330px;
    }
    
  /*#map:hover ~ .col-md-4 {
  height: 300px; /* Increased height on hover */
  /*#map:hover
    {
    height:320px;
    }*/
   #map{
   width: 100%;
    height: 150px;
    position: absolute;
    overflow: hidden;
}
.mapcontainer
{
height:160px;
 position: relative;
 display:flex;
 flex-direction:row;
 
}
#panelhead
{
display: flex;
padding: 20px;
align-items: center;
gap: 20px;
align-self: stretch;
background: #FFF;
box-shadow: 0px 4px 4px 0px rgba(0, 0, 0, 0.05);
border-top-left-radius: 100px;
    border-top-right-radius: 100px;
}
#adcards {
    display: flex;
    flex-wrap: wrap;
    flex-direction: column;
    width: 100%;
    box-sizing: border-box;}
    
    
    .panel-default {
 /*  border-color: #ddd;*/
    width: 100%;
    box-sizing: border-box;
    border-radius: 20px;
    background: #FFF;

    border-color: #FFF;
    border: none;
height:300px;
}
#frame20{
display: flex;
flex-direction: column;
align-items: flex-start;
/*gap: 10px;*/
flex: 1 0 0;
}
/*.follow{
display: flex;
padding: 10px 20px;
justify-content: center;
align-items: center;
gap: 10px;
border-radius: 10px;
border: 1px solid #000;

}*/
#followbutton
{
display: -webkit-box;
-webkit-box-orient: vertical;
-webkit-line-clamp: 1;
overflow: hidden;
color: #000;
text-overflow: ellipsis;
font-family: Inter;
font-size: 18px;
font-style: normal;
font-weight: 400;
line-height: normal;
border-radius:11px;
background:#FFF;
}
 #follow-button i {
            margin-right: 8px; /* Space between icon and text */
        }
#publishername
{
color: #000;
font-family: Inter;
font-size: 18px;
font-style: normal;
font-weight: 700;
line-height: normal;
}
#publisherdate
{
display: -webkit-box;
-webkit-box-orient: vertical;
-webkit-line-clamp: 1;
overflow: hidden;
color: #000;
text-overflow: ellipsis;
font-family: Inter;
font-size: 14px;
font-style: normal;
font-weight: 400;
line-height: normal;
}
#Offers
{
display: flex;
flex-direction: column;
justify-content: center;
align-items: flex-start;
align-self: stretch;
border-radius: 20px;
background: #FFF;
}
/*#myCarousel
{
width: 250px;
height: 250px;
flex-shrink: 0;
}*/

.panel-body{
    padding: 0px;
    display: flex;
    flex-direction: row;
    }
    
   
  /* .carousel {
    position: relative;
    width: 250px;
    height: 159px;
    border-radius: 0 0px 0px 20px;
    overflow: hidden;
}*/
.textcontainer
{
display: flex;
padding: 10px 20px;
flex-direction: column;
justify-content: center;
align-items: flex-start;
gap: 1px;/*30px*/
flex: 1 0 0;
align-self: stretch;
}

.description
{
display: -webkit-box;
-webkit-box-orient: vertical;
-webkit-line-clamp: 3;
align-self: stretch;
overflow: hidden;
color: #000;
text-overflow: ellipsis;
font-family: Inter;
font-size: 16px;
font-style: normal;
font-weight: 400;
line-height: normal;
}
.expires
{
display: -webkit-box;
-webkit-box-orient: vertical;
-webkit-line-clamp: 1;
overflow: hidden;
color: #FF1515;
text-overflow: ellipsis;
font-family: Inter;
font-size: 16px;
font-style: normal;
font-weight: 400;
line-height: normal;
opacity: 0.5;
}
.button-group
{
display: flex;
align-items: center;
gap: 20px;
align-self: stretch;

}
#takeme
{
display: flex;
padding: 9px 14px;
align-items: center;
gap: 5px;
align-self: stretch;
border-radius: 10px;
border: 1px solid var(--Brand-Primary, #F27C0A);
background: #FFF;
outline:none;
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
    background:#FFF;
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
#rangeOutputId{position:relative;margin-left:-8px;z-index:10;background: #FFF;
    font-weight: bold;margin-bottom: 10px;display:none;}
    
    #rangeInputId{display:none;}
    
  .spotlightsearch{
display: flex;
height: 50px;
padding: 10px 15px;
align-items: center;
gap: 200px;
align-self: stretch;
border-radius: 10px;
border: 1px solid #BDBDBD;
}
.spotlightlist
{
display: flex;
align-items: flex-start;
gap: 20px;
/*align-self: stretch;
overflow:hidden;*/

/*min-width:420px;*/
user-select: none;
/*cursor:pointer*/
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
background: #FFF;
}
.dropdown-menu1
{
display: flex;
width: 427px;
padding: 20px 16px 16px 16px;
flex-direction: row;
justify-content: center;
align-items: center;
gap: 0px;/*20px*/
border-radius: 10px;
background: #FFF;
/*box-shadow: 0px 0px 3px 0px rgba(0, 0, 0, 0.25);*/
}
.frame61
{
display: flex;
padding: 10px;
align-items: flex-start;
gap: 20px;
align-self: stretch;
border: 1px solid #F4F4F4;
}
.vertical-line{
width: 1px;
    height: 274px;
    background-color: #000000;
    opacity: 0.1;
}
ul,li
{
list-style-type: none; /* Remove bullets */
padding:10px;
}
.dropdown-item
{
border:none;
outline:none;
background:none;
}
.dropdown-item-right
{
display: flex;
padding: 5px 16px;
justify-content: center;
align-items: center;
gap: 0px;
border-radius: 100px;
border: 1px solid #D6D6D6;
background: #FFFFFF;
color: #000;
font-family: Inter;
font-size: 12px;
font-style: normal;
font-weight: 400;
line-height: normal;
cursor: pointer;
}

.dropdown-item-right button
{
outline:none;border:none;background:none;

}
.close {
    float: right;
    font-size: 19px;
    font-weight: 700;
    line-height: 1;
    color: #FFF;  
    /* opacity: .2; */
}

.category{
display: flex;
    flex-direction: column;
    gap: 5px;
    align-items: flex-start;}
 /* Style the tab */
.tab {
  float: left;
  border: 1px solid #ccc;
/*  background-color: #f1f1f1;*/
  width: 50%;
  height: 300px;
  padding-left:5px;
  border-right:none;
  padding-top:5px;
}

/* Style the buttons inside the tab */
.tab button {
  display: block;
  background-color: inherit;
  color: black;
  padding: 22px 16px;
  width: 94%;
  border: none;
  outline: none;
  text-align: left;
  cursor: pointer;
  transition: 0.3s;
 flex: 1 0 0;
 color: #000;
font-family: Inter;
font-size: 14px;
font-style: normal;
font-weight: 400;
line-height: normal;
}

/* Change background color of buttons on hover */
.tab button:hover {
 /* background-color: #ddd;*/
}

/* Create an active/current "tab button" class */
.tab button.active {
  display: flex;
padding: 10px;
align-items: center;
gap: 10px;
align-self: stretch;
background: #F6F6F6;
}

/* Style the tab content */
.tabcontent {
  float: left;
  padding: 0px 12px;
  border: 1px solid #ccc;
  width: 70%;
  border-left: none;
  height: 300px;
}
.tab button
{
padding: 6px 3px;
}
.close-button{
color: #FFFFFF;
cursor:pointer;
/*cursor: not-allowed; 
pointer-events: none;
*/

}
.dynamic-button{
display: flex;
    padding: 5px 16px;
    justify-content: center;
    align-items: center;
    gap: 10px;
    border-radius: 100px;
    background: linear-gradient(90deg, rgb(242, 124, 10) 0%, rgb(242, 56, 44) 100%), rgb(255, 255, 255);
    color: rgb(255, 255, 255);
    font-family: Inter;
    font-size: 12px;
    font-style: normal;
    font-weight: 700;
    line-height: normal;
    align-self: start;
    outline: none;
    border: none;}
    
.reset
{
display: flex;
padding: 10px 16px;
justify-content: center;
align-items: center;
gap: 10px;
flex: 1 0 0;
border-radius: 5px;
background: #F4F4F4;
outline:none;
border:none;
}
.apply
{
display: flex;
padding: 10px 16px;
justify-content: center;
align-items: center;
gap: 10px;
flex: 1 0 0;
border-radius: 5px;
border: 1px solid #000;
outline:none;

}
.tab span
{
display: flex;
width: 24px;
height: 24px;
justify-content: center;
align-items: center;
gap: 10px;
border-radius: 30px;
background: var(--Brand-Primary, linear-gradient(90deg, #F27C0A 0%, #F2382C 100%));
}

.dynamic-div
{
display: flex;
    flex-direction: row;
  /*  flex-grow: 1;*/
    flex-shrink: 0;
}

/* #myModalforphone  .modal-dialog {
            display: inline-flex;
padding: 30px;
flex-direction: column;
justify-content: center;
align-items: flex-start;
gap: 30px;
border-radius: 20px;
background: #FFF;
        }*/
        
      #myModalforphone  .modal-content
      {
      display: inline-flex;
padding: 15px;/*30px*/
flex-direction: column;
justify-content: center;
align-items: flex-start;
/*gap: 30px;*/
border-radius: 20px;
background: #FFF;
width: 430px;
    height: 286px;
      
      }
        
    #myModalforphone .modal-header
    {
    display: flex;
flex-direction: column;
align-items: flex-start;
gap: 16px;
align-self: stretch;
    }

.phonemodalheader
{

display: flex;
    flex-direction: row;
   
    gap: 290px;
}

 .modal-open #myModalforphone
{
margin-left: 200px;
    margin-top: 175px;
}

#phonesendotp :hover
{
background: linear-gradient(90deg, #F27C0A 0%, #F2382C 100%), #FFF;
}
 .modal-open #myModalforphoneenterotp
{
margin-left: 200px;
    margin-top: 65px;
}

 #myModalforphoneenterotp  .modal-content
      {
      display: inline-flex;
padding: 20px;/*30px*/
flex-direction: column;
justify-content: flex-start;
align-items: flex-start;
gap: 23px;
border-radius: 20px;
background: #FFF;
width: 430px;
    height: 362px;
      
      }
      
      
      .modal-open #showphno
{
margin-left: 0px;
    margin-top: 230px;
}

 #showphno  .modal-content
      {
      display: inline-flex;
padding: 20px;/*30px*/
flex-direction: column;
justify-content: flex-start;
align-items: flex-start;
/*gap: 23px;*/	
border-radius: 20px;
background: #FFF;
width: 200px;
    height: 100px;
      
      }
/*      
@media only screen and (min-width: 768px) {
.col-md-6 {
        width: 50%;

}
@media only screen and (min-width: 768px) {
.frame54 {
        width: 100%;

}
@media only screen and (min-width: 768px) {
.headercontent {
       width:65%;

}
/*.search-container
{
 width:50%;
}
.header
{
padding: 17px 21px;
}*/
.panel-body :hover
{
 background-color: #f1f1f1;
}
.panel-body :hover button
{
 background-color: white;
}

/*img {
  border-radius: 50%;
}*/

.carousel-control.left,
.carousel-control.right {
  background: transparent;
}

/*.carousel-control.left, .carousel-control.right {
  left: 0;
  z-index: 1;
}*/

.spotlightimg
{
border-radius: 50%;
}

@media (min-width: 992px) and (max-width: 1025px){
    .col-md-6 {
        width: 66%;
    }
}


 .custom-info-content {
        font-size: 16px;
        padding: 10px;
        width: 200px; /* Set the desired width */
        max-width: 300px; /* Set a maximum width */
      }
      #hand{
      width: 341px;
      height: 22px;
font-family: 'Inter';
font-style: normal;
font-weight: 600;
font-size: 20px;
line-height: 20px;
color: #000000;
flex: none;
order: 0;
/*align-self: stretch;*/

display:flex;
flex-direction:row;
gap:10px;

  
      }
</style>
</head>

<body>
<!--  <div class="container">-->
<div class="row">

<div class="col-md-6">
<div class="frame54">
<div class ="inbetween">
<div class="frame57">
<!--<form>-->
<div class ="button-containertop" id = "button-containertop" style ="width:600px;overflow:hidden;display:flex;flex-direction:row;height:75px;padding-top:10px;">
  <div class="button-container" id = "button-container"style =" display: flex;flex-direction: row;gap:5px;align-items: center;"><p id ="hand">Click here for categories <i class="fa fa-hand-o-right" style = "color:#F27C0A"></i></p></div>
</div>
  <div class="dropdown">
  <button  class = "btn btn-default" type="button" data-toggle="dropdown" style ="border-radius: 5px;border: 2px solid var(--Brand-Primary, #F27C0A);
background: #FFF;outline:none;" id ="dropdownMenuButton">
  <i class="fa fa-sliders fa-rotate-90" ></i>
  </button>
  
  <div class="dropdown-menu" role="menu" aria-labelledby="dropdownMenuButton" style ="padding: 0px 0;border-radius:10px;right:0;left:unset;" >
  <div class= "dropdown-menu1">
  <div class="tab">
  <button class="tablinks" onclick="openCity(event, 'Food')" id="defaultOpen" style="display:flex;flex-direction:row;gap: 10px;justify-content:space-between;" >Food <span  class = "Food"  >0</span></button>
  <button class="tablinks" onclick="openCity(event, 'vehicle')" style="display:flex;flex-direction:row;gap: 10px;justify-content:space-between;">Vehicle & Transport<span  class = "vehicle"  >0</span></button>
  <button class="tablinks" onclick="openCity(event, 'travel')" style="display:flex;flex-direction:row;gap: 10px;justify-content:space-between;">Travel & Accomodation<span  class = "travel"  >0</span></button>
  <button class="tablinks" onclick="openCity(event, 'store')" style="display:flex;flex-direction:row;gap: 10px;justify-content:space-between;">Store Front<span  class = "store"  >0</span></button>
  <button class="tablinks" onclick="openCity(event, 'health')" style="display:flex;flex-direction:row;gap: 10px;justify-content:space-between;">Health Care<span  class = "health"  >0</span></button>
  <button class="tablinks" onclick="openCity(event, 'services')" style="display:flex;flex-direction:row;gap: 10px;justify-content:space-between;">Services & Information<span  class = "services" >0</span></button>
</div>
 <div class ="vertical-line"></div>
<div id="Food" class="tabcontent">
<div class="foods" style ="display: flex;    flex-direction: column;    gap: 10px;    align-items: flex-start;padding:5px;">
<button class = "dropdown-item-right"  value ="64887cc6cce361dafc86c313"  >Veg Food <span class="close-button" onclick="closeAlert(event)"  >&times;</span></button>
<button class = "dropdown-item-right" value="64887cc6cce361dafc86c314" >Non-veg Food<span class="close-button" onclick="closeAlert(event)" >&times;</span></button>
<button class = "dropdown-item-right" value = "64887cc6cce361dafc86c31c"  >Fruits,Flower & Veggies<span class="close-button" onclick="closeAlert(event)" >&times;</span></button>
<button class = "dropdown-item-right" value="64887cc6cce361dafc86c31f"  >Ice Creams & Milk Products<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
</div>
</div>

<div id="vehicle" class="tabcontent">
<div class="vehicles" style ="display: flex;    flex-direction: column;    gap: 10px;    align-items: flex-start;padding:5px;">
  <button class = "dropdown-item-right" value ="64887cc6cce361dafc86c315"  >Vehicle Rentals<span class="close-button" onclick="closeAlert(event)" >&times;</span></button>
<button class = "dropdown-item-right"  value ="64887cc6cce361dafc86c320">Fuel Stations<span class="close-button" onclick="closeAlert(event)" >&times;</span></button>
<button class = "dropdown-item-right" value="64887cc6cce361dafc86c323" >Tours and Travels<span class="close-button" onclick="closeAlert(event)" >&times;</span></button>
<button class = "dropdown-item-right" value="64887cc6cce361dafc86c324" >Vehicle Sales & Services <span class="close-button" onclick="closeAlert(event)" >&times;</span></button>
</div>
</div>

<div id="travel" class="tabcontent">
<div class="travels" style ="display: flex;    flex-direction: column;    gap: 10px;    align-items: flex-start;padding:5px;">
  <button class = "dropdown-item-right" value="64887cc6cce361dafc86c316"  >Hotels and Rooms<span class="close-button" onclick="closeAlert(event)" >&times;</span></button>
   <button class = "dropdown-item-right" value="64887cc6cce361dafc86c31b" >Places of Interest<span class="close-button" onclick="closeAlert(event)" >&times;</span></button>
    <button class = "dropdown-item-right" value="64887cc6cce361dafc86c31d" >Temples<span class="close-button" onclick="closeAlert(event)" >&times;</span></button>
    </div>
</div>
  
  <div id="store" class="tabcontent">
  <div class="stores" style ="display: flex;    flex-direction: column;    gap: 10px;    align-items: flex-start;padding:5px;">
  <button class = "dropdown-item-right" value = "64887cc6cce361dafc86c319" >Stores, Groceries & Supermarket<span class="close-button" onclick="closeAlert(event)" >&times;</span></button>
   <button class = "dropdown-item-right" value="64887cc6cce361dafc86c31a" >Cloths and Dresses<span class="close-button" onclick="closeAlert(event)" >&times;</span></button>
    <button class = "dropdown-item-right" value="64887cc6cce361dafc86c31e" >Banks & ATMs <span class="close-button" onclick="closeAlert(event)" >&times;</span></button>
     <button class = "dropdown-item-right" value="64887cc6cce361dafc86c326" >Saloon & SPA<span class="close-button" onclick="closeAlert(event)" >&times;</span></button>
     <button class = "dropdown-item-right" value="64887cc6cce361dafc86c328" >Construction & Building Materials<span class="close-button" onclick="closeAlert(event)" >&times;</span></button>
     <button class = "dropdown-item-right" value="64887cc6cce361dafc86c329"  >Home Appliances<span class="close-button" onclick="closeAlert(event)" >&times;</span></button>
     </div>
</div>

<div id="health" class="tabcontent">
<div class="healths" style ="display: flex;    flex-direction: column;    gap: 10px;    align-items: flex-start;padding:5px;">
  <button class = "dropdown-item-right"  value = "64887cc6cce361dafc86c321" >Pharmacy/Medical Shops<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
   <button class = "dropdown-item-right" value="64887cc6cce361dafc86c322" >Hospital, Clinics & Labs<span class="close-button" onclick="closeAlert(event)" >&times;</span></button>
    <button class = "dropdown-item-right" value="64887cc6cce361dafc86c325" >Emergency Services & Help<span class="close-button" onclick="closeAlert(event)" >&times;</span></button>
    </div>
</div>

<div id="services" class="tabcontent">
<div class="servicess" style ="display: flex;    flex-direction: column;    gap: 10px;    align-items: flex-start;padding:5px;">
  <button class = "dropdown-item-right" value = "64887cc6cce361dafc86c327" >Real Estate<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
   <button class = "dropdown-item-right" value="64887cc6cce361dafc86c32a" >Professional & labour Services<span class="close-button"  onclick="closeAlert(event)">&times;</span></button>
    <button class = "dropdown-item-right" value="64887cc6cce361dafc86c32b" >Venues and Events<span class="close-button" onclick="closeAlert(event)" >&times;</span></button>
    <button class = "dropdown-item-right" value="64887cc6cce361dafc86c32d" >Agricultural Products  & Nursery<span class="close-button" onclick="closeAlert(event)" >&times;</span> </button>
    <button class = "dropdown-item-right" value="64887cc6cce361dafc86c32e" >Public Notice<span class="close-button" onclick="closeAlert(event)" >&times;</span></button>
      <button class = "dropdown-item-right" value="64887cc6cce361dafc86c317"  >Jobs<span class="close-button" onclick="closeAlert(event)" >&times;</span></button>
      </div>
</div>
  
 
  </div><!-- dropdownmenu1 -->
  
   <div class="button-grp" style = "display: flex;align-items: flex-start;gap: 20px;align-self: stretch;padding: 4px;margin-left: 13px;
    margin-right: 12px;margin-bottom: 10px;">
  <button class= "reset">RESET</button>
  <button  class="apply">APPLY </button>
  </div>
  
      </div>  
  </div>
<!--    </form>-->
</div>
</div>
<svg xmlns="http://www.w3.org/2000/svg" width="658" height="2" viewBox="0 0 658 2" fill="none">
<path opacity="0.2" d="M0 1H658" stroke="black"/>
</svg>
<div class="offers" style = "color: #000;font-family: Inter;font-size: 18px;font-style: normal;font-weight: 700;line-height: normal;opacity: 0.5; display:flex;flex-direction:row;gap:270px;">
<p id = "locationflag"></p>
<p id = "results"></p>

</div>
<div id="latlng"> </div>
<!-- <div class="container"> -->
 <div  id ="adcards">
  <!-- From Here -->
  <!-- Till Here -->
   </div><!-- adcards -->
<!--  </div>-->
</div>

</div>

<div class="frame68" >
<div class = "col-md-4" id = "col-md-4">

 <div class="mapwithicon" style ="margin-right: 0px;margin-left: 0px;padding-bottom:10px;">
 
 <h3 style="color: #000;font-family: Inter;font-size: 24px;font-style: normal;font-weight: 700;line-height: normal;text-transform: capitalize;">Services Near You</h3>
 <h5 style ="color: #000;font-family: Inter;font-size: 14px;font-style: normal;font-weight: 400;line-height: normal;">Hover to select the radius you wish to view</h5>
 </div>
 
  <div class="mapcontainer" >
 <div id="slider-container" style="margin-top:120px;padding:10px;margin-left:40px;"> 
 <output id="rangeOutputId" >1.3 km</output>
  <input type="range" min="1.3" max="5.7" value="1.3" orient="vertical" id ="rangeInputId" step="2.2" oninput="sliderClick()" >
   
  
  </div>  
 <div  id="map"></div>
       </div>


</div>
<div class = "col-md-4-spot" >
<div style="display:flex;flex-direction:row;align-items: center;gap: 20px;align-self: stretch;">
<h5 style ="color: #000;font-family: Inter;font-size: 24px;font-style: normal;font-weight: 700;line-height: normal;flex: 1 0 0;">Spotlights</h5>
<form action="/spotlights"><button style = "color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;border:none;background:none;outline:none;">View all</button></form></div>
<div class="spotlightsearch">
 <input type="text" placeholder="Search.." name="search" style ="border: none;outline: none;"  id="spotlytsearch">
      <button type="submit" style ="border: none;outline: none;background: #FFF;"><i class="fa fa-search" ></i></button>

</div>
  <div class="sp" style="overflow:hidden;display:flex;flex-grow:1;width:420px;cursor:move;" >
<div class="spotlightlist" id ="spotlightlist">
<!--  <div class="spotlightitem">
<img  src="<c:url value='/Default_pfp.jpg' />"  alt="User profile" style="width: 37px;height: 39px;" />
<div class="companyname">Comapny Name</div>
-->

</div>

</div>


</div>
</div>
	
</div>


<!-- login modal start here center -->
<div id="myModalforphone" class="modal" role="dialog">
  <div class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header" style ="border-bottom: none; display: flex;    flex-direction: column;">
      <div class ="phonemodalheader">
     <h4 class="modal-title" style = "align-self: stretch;color: #000;font-family: Inter;
font-size: 25px;font-style: normal;font-weight: 700;line-height: normal;">Login</h4>
   <span id="closeButtonheaderphone" class="close"  >&times;</span>
        </div>
         <h5 class="modal-title" style = "align-self: stretch;color: #000;
font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">Enter your mobile no.</h5>
      
      </div>
      <div class="modal-body" style ="border-bottom: none; ">
      <div style = "display: flex;
width: 370px;
flex-direction: column;
align-items: flex-start;
gap: 10px;">
<div style ="display: flex;padding: 20px 10px;align-items: center;gap: 10px;align-self: stretch;border-bottom: 1px solid #B9B9B9;">
      <input type = "text" style ="border:none;outline:none;color: #000;
font-family: Inter;font-size: 14px;font-style: normal;font-weight: 400;line-height: normal;opacity: 0.5;" placeholder="Enter your mobile no." id = "phonemobilenumber" autocomplete="off">

    </div>  
      </div>
      </div>
      <div class="modal-footer" style ="border-top:none;">
       <button class= "sendotp" id = "phonesendotp">
Send OTP
<svg xmlns="http://www.w3.org/2000/svg" width="25" height="24" viewBox="0 0 25 24" fill="none">
  <path d="M18.4959 5.90946C18.4459 5.35945 17.9595 4.95411 17.4095 5.00411L8.44643 5.81893C7.89641 5.86893 7.49107 6.35534 7.54107 6.90536C7.59107 7.45537 8.07748 7.86072 8.6275 7.81071L16.5946 7.08643L17.3189 15.0536C17.3689 15.6036 17.8553 16.0089 18.4054 15.9589C18.9554 15.9089 19.3607 15.4225 19.3107 14.8725L18.4959 5.90946ZM8.26822 18.6402L18.2682 6.64018L16.7318 5.35982L6.73178 17.3598L8.26822 18.6402Z" fill="black"/>
</svg>
</button>
      </div>
    </div>

  </div>
</div>




<!-- login modal end here center -->
	<!-- phone enter otp start here -->
<div id="myModalforphoneenterotp" class="modal" role="dialog">
  <div class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header" style ="border-bottom: none; ">
      <div class ="phonemodalheader">
     <h4 class="modal-title" style = "align-self: stretch;color: #000;font-family: Inter;
font-size: 25px;font-style: normal;font-weight: 700;line-height: normal;">OTP</h4>
   <span id="phonecloseButtonheaderotp" class="close" style ="color:black;">&times;</span>
        </div>
       <div style ="display:flex;flex-direction:row;">
<p  style = "align-self: stretch;color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;opacity: 0.5;" id="potp">Enter the OTP &nbsp;</p>
<div id="photpno" style ="color:#d94228;font-size:16px;" ></div>
<p style = "align-self: stretch;color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;opacity: 0.5;">&nbsp; below:</p>
</div>
      </div>
      <div class="modal-body" style ="border-bottom: none;">
      <div style = "display: flex;width: 370px;flex-direction: column;align-items: flex-start;gap: 10px;">
<div style ="display: flex;padding: 20px 10px;align-items: center;gap: 10px;align-self: stretch;border-bottom: 1px solid #B9B9B9;">
      <input type = "text" style ="border:none;outline:none;color: #000;
font-family: Inter;font-size: 14px;font-style: normal;font-weight: 400;line-height: normal;opacity: 0.5;" placeholder="Enter OTP." id = "phonemobilenumberotp" autocomplete="off">

    </div>  
    <div style ="display: flex;flex-direction: row;"><a style = "color: #010a12; text-decoration: none;margin-left:180px" id = "resendotp"> Resend OTP in &nbsp;</a> 
   <div id="countdownotp" class="timer"></div>

</div>
      </div>
      </div>
      <div class="modal-footer" style ="border-top:none;">
       <button class= "sendotp" id = "phonesendotpp">
LOGIN
<svg xmlns="http://www.w3.org/2000/svg" width="25" height="24" viewBox="0 0 25 24" fill="none">
  <path d="M18.4959 5.90946C18.4459 5.35945 17.9595 4.95411 17.4095 5.00411L8.44643 5.81893C7.89641 5.86893 7.49107 6.35534 7.54107 6.90536C7.59107 7.45537 8.07748 7.86072 8.6275 7.81071L16.5946 7.08643L17.3189 15.0536C17.3689 15.6036 17.8553 16.0089 18.4054 15.9589C18.9554 15.9089 19.3607 15.4225 19.3107 14.8725L18.4959 5.90946ZM8.26822 18.6402L18.2682 6.64018L16.7318 5.35982L6.73178 17.3598L8.26822 18.6402Z" fill="black"/>
</svg>
</button>
      </div>
    </div>

  </div>
</div>


<!-- phone enter otp end here -->

<!-- login modal success start here center -->
 <div class="modal" id="showphno" role="dialog">
    <div class="modal-dialog modal-sm">
      <div class="modal-content">
        <div class="modal-header" style ="padding: 0px; border-bottom: none;display: flex;flex-direction: row;">
          
        <h4 class="modal-title">Call us at: </h4><button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        <div class="modal-body" style ="padding:0px;">
          <div id = "callme">  </div>
          
        </div>
       
      </div>
    </div>
  </div>
<!-- login modal success end here center -->
<!--  </div>--><!-- container -->

    <script type="text/javascript">
 
    var categories=[];
//    console.log('categories arry: ' +categories);
    $(document).ready(function() {	   
    	document.title = 'KELIRI :: Home';	
    	  function checkForDiv(){
    	 if ($(".dynamic-button").length) {
            // console.log("The div exists.");
         } else {        	 
        $("p#hand").show();       
         }}
    	 setInterval(checkForDiv, 1000);
    	$('.carousel').carousel({
      interval: 2000
    })
    	 mob="";
    	$('.tab span').hide();
    	$('.close-button').prop("disabled", true);
    	/*select categories*/
		   $('.dropdown-item-right ').click(function(e) {
			   e.stopPropagation();			  
			  	   const buttonText = $(this).contents().filter(function() {
                   return this.nodeType === 3; // Filter for text nodes only
               }).text().trim(); // Get the text and trim whitespace
			   const splitText = buttonText.split(' '); 
	//console.log('value is : '+$(this).val());
	categories.push($(this).val());
//	console.log('categories on colur red: ' +categories);
	
	            $(this).css({	            	
	            	'display': 'flex',
	            	'padding':'5px 16px',
	            	'justify-content': 'center',
	            	'align-items': 'center',
	            	'gap': '10px',
	            	'border-radius': '100px',
	            	'background': 'linear-gradient(90deg, #F27C0A 0%, #F2382C 100%), #FFF',
	            	'color': '#FFF',
	           		'font-family':' Inter',
	            	'font-size':' 12px',
	           		'font-style': 'normal',
	            	'font-weight': '700',
	            	'line-height':' normal',
	           		'align-self':'start'
	            });
	            // Create a new button element
	           // console.log("button value : " +$(this).val());
	            btnval = $(this).val();
	               const newButton = $('<div class="dynamic-div" draggable="true" ><button class="dynamic-button" value = '+btnval+' >'+buttonText+'<span class="close-button" onclick="closeAlerttop(event)" >&times;</span> </button></div>');
	             
	               // Append the new button to the container
	               $("p#hand").hide();
	               $('.button-container').append(newButton);
	            $(this).siblings('.close-button').show();
	            $(this).siblings('.close-button').prop("disabled", false);
	            const button = event.currentTarget; // This refers to the button that was clicked
	            button.disabled = true; // Disable the button after click
	            
	            const parentId = button.closest('.tabcontent').id; // Get the ID of the nearest parent with class 'tab'
	           // console.log('Parent Tab ID:', parentId); // Log the parent ID
	            var counter = $('.'+parentId).text();
	            counter = Number(counter)+1;
	            $('.'+parentId).text(counter);
	            console.log('counter as int: ' +counter);
	            $('.'+parentId).show();
	        }); 
    	
    	/*slect categories */ 
		  // const dropdownButton = document.getElementById('dropdownMenuButton');
		   //to search spotlight start here
		    $('.spotlightlist').on('click', '.spotlightitem', function() {
		   var y =  $(this).attr('id') ;
var x = $(this).val();
var z = $(this).usrphno;
console.log('y : ' +y);

$.ajax({
    url: '${pageContext.request.contextPath}/aspotlight', // Sample API endpoint
    method: 'POST',
    contentType: 'text/plain',
    data: y,
    success: function(response) {
    	console.log('data : ' +response);
   
    	window.location.href ='${pageContext.request.contextPath}/aspotlightdetail' ;
    }
    
});
		    });	   
		   
		   //to search spotlight end here
		   //to drag top start here
		/*   const containerfilter = document.querySelector('.button-containertop');
	 let isDownfilter = false;
	 let startXfilter;
	 let scrollLeftfilter;

	 containerfilter.addEventListener('mousedown', (e) => {
		 isDownfilter = true;
	   containerfilter.classList.add('active');
	   startXfilter = e.pageX - containerfilter.offsetLeft;
	   scrollLeftfilter = containerfilter.scrollLeftfilter;
	 });

	 containerfilter.addEventListener('mouseleave', () => {
	   isDownfilter = false;
	   containerfilter.classList.remove('active');
	 });

	 containerfilter.addEventListener('mouseup', () => {
	   isDownfilter = false;
	   containerfilter.classList.remove('active');
	 });

	 containerfilter.addEventListener('mousemove', (e) => {
		 console.log('mousemove : category'  );
	   if (!isDownfilter) return;
	   e.preventDefault();
	   const x = e.pageX - containerfilter.offsetLeft;
	   const walk = (x - startXfilter) * 3; //scroll-fast
	   containerfilter.scrollLeftfilter = scrollLeftfilter - walk;
	 });
		   */
		   
		   // to drag top end here
		   
		   
    });//document.ready
              
          

    /*to show filter options */
    function openCity(evt, cityName) {
    	 evt.stopPropagation();
    	  var i, tabcontent, tablinks;
    	  tabcontent = document.getElementsByClassName("tabcontent");
    	  for (i = 0; i < tabcontent.length; i++) {
    	    tabcontent[i].style.display = "none";
    	  }
    	  tablinks = document.getElementsByClassName("tablinks");
    	  for (i = 0; i < tablinks.length; i++) {
    	    tablinks[i].className = tablinks[i].className.replace(" active", "");
    	  }
    	  document.getElementById(cityName).style.display = "block";
    	  evt.currentTarget.className += " active";
    	}

    	// Get the element with id="defaultOpen" and click on it
    	document.getElementById("defaultOpen").click();
    	
    	/*till here filter options*/
    	//array of  categories starts here
    	
    	 $( '.reset' ).on( "click", function(e) {
    		 console.log('on reset'); e.stopPropagation();
    		 
    		  const buttons = document.querySelectorAll('.dropdown-item-right');
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
          	$('.tab span').hide();
          	$('.tab span').text(0);
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
    		 
    	 });
    	
    	 $( '.apply' ).on( "click", function(e) {
    		 //console.log('aray of categories : ' +categories);
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
    		            let x = JSON.stringify(data);
    		         //   console.log('in categories success : ' +x);
    		            document.getElementById("adcards").innerHTML = "";
    		            for (var i = 0; i < markers.length; i++) {
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
    		             $.each(data, function (i, myList) {
    		   	     	//  console.log('data in current location: ' +data);
    		   	     	 var adsid = myList.id;
	     	 var phno = myList.phoneNumber;
	     	// console.log('phno : ' +phno);
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
    		    	    	var thumbnail = myList.a.thumbnail;
    		    	    	//console.log('companyLogoUrl: ' +companyLogoUrl);
    		    	    	var banner1="nopreview.jpg";
    		    	    	var banner2 = "nopreview.jpg";
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
    		    	     	 var carouselid= 'myCarousel'+k;
    		    	   var ad_card=	'<div class="panel panel-default "   role = "button" >'
    		    	     	 +'<div class="panel-heading" id ="panelhead"   >'
    		    	     	 +'  <img src="<c:url value="'+companyLogoUrl+'" />"  alt="User profile" style="width: 37px;height: 39px;" class="spotlightimg" />' 
    		    	     	 +'  <div id="frame20"><h5 id="publishername">'+companyName+' </h5><div id ="publisherdate">'+formattedDate+'</div></div>'
    		    	     	 +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
    		    	     	 +'<div><svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 40 40" fill="none"> <path d="M11.5 28.6801V10H28V28.7634L20.1668 21.7548L19.4817 21.1418L18.8134 21.773L11.5 28.6801Z" stroke="black" stroke-width="2"/></svg></div>'
    		    	     	 + '</div>'
    		    	     	 +'<div class="panel-body" style = "display:flex;flex-direction:row;">'
    		    	     	 +'<div class="carousel-container">'    		    	     	 
    		    	     	 +'<div id="'+carouselid+'" class="carousel slide" data-ride="carousel">'
    		    	     	 +'<ol class="carousel-indicators"><li data-target="#'+carouselid+'" data-slide-to="0" class="active"></li><li data-target="#'+carouselid+'" data-slide-to="1"></li><li data-target="#'+carouselid+'" data-slide-to="2"></li></ol>'
    		                 +'<div class="carousel-inner"><div class="item active"><img src="<c:url value="'+thumbnail+'" />" alt="Los Angeles" style ="height:200px;width:200px;border-bottom-left-radius:20px;"></div>'
    		                 +'<div class="item"><img src="<c:url value="'+thumbnail+'" />" alt="Chicago" style ="height:200px;width:200px;border-bottom-left-radius:20px;"></div><div class="item"><img src="<c:url value="'+thumbnail+'" />" alt="New York" style ="height:200px;width:200px;border-bottom-left-radius:20px;"></div></div>'
    		                 +' <a class="left carousel-control" href="#'+carouselid+'" data-slide="prev"><span class="glyphicon glyphicon-chevron-left"></span><span class="sr-only">Previous</span></a>'
    		                 +' <a class="right carousel-control" href="#'+carouselid+'" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span><span class="sr-only">Next</span></a></div>'
    		                 +'</div>'
    		                 +'<div class= "textcontainer" id = '+adsid+' onclick=nextui(this);> <p style="color: #000;font-family: Inter;font-size: 18px;font-style: normal;font-weight: 700;line-height: normal;align-self: stretch;">'+publisher_name+'</p><p class="description">'+description+'<h5 class="expires"> Expires on '+dates+'</h5>'
    		                 +'  <div class ="button-group"><button style = "outline: none;background-color: white;border: none;" onclick=phone('+phno+');>  <i class="fa fa-phone" aria-hidden="true"></i></button>'
    		                 +'<button style = "outline: none;background-color: white;border: none;" onclick=whatsapp('+phno+');><i class="fa fa-whatsapp" aria-hidden="true"></i></button><button style = "outline: none;background-color: white;border: none;"><i class="fa fa-envelope"></i></button>'
    		                 +'<button type="button" class="btn btn-default" id = "takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+');><i class="fa fa-map-marker" aria-hidden="true" style = "font-size:17px;color: #F27C0A;">&nbsp;Take me there</i></button></div>';

    		    	     	 $('#adcards').append(ad_card); 
    		    	 //  console.log('ad_card: '+ad_card);
    		    	     var  latt = 13.529271965260616;
    		 	        var lngg = 75.36285138756304; 
    		 	      
    		 /*   var dist=getDistanceFromLatLonInKm(myList.location.lat,myList.location.lng,lat,lng).toFixed(1);
    		    //console.log('dist value is :' +dist);
    		   
    		    
    		    if(dist<=1.3)
    		    	{	}*/
    		 	   locations.push(  [myList.location.lat,myList.location.lng,publisher_name,publisher_name]);
    		    	
    		    	 results++;
    		    	        	  }); //.each
    		 //for map from here
    		 var zoom_val=0;

    		 var infowindow = new google.maps.InfoWindow();

    		 //var marker, i ,png;
    		 png='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
    		 for (i = 0; i < locations.length; i++) {		 
    		     		marker = new google.maps.Marker({
    		     	        position: new google.maps.LatLng(locations[i][0], locations[i][1]),
    		     	        map: map,
    		     	        icon:png
    		     	      });
    		     		map.setZoom(12);
    		             map.panTo(marker.position);    	
    		     	      google.maps.event.addListener(marker, 'mouseover', (function(marker, i) {
    		     	        return function() {
    		     	         // infowindow.setContent('<b>Name:</b>&nbsp;'+ locations[i][2]+'.<br>'+'<b>:</b>&nbsp;'+ locations[i][3]+'<b>dist:</b>&nbsp;'+locations[i][4]);
    		     	          infowindow.setContent('<b>Name:</b>&nbsp;'+ locations[i][2]);
    		     	          infowindow.open(map, marker);
    		     	        }
    		     	      })(marker, i));
    		     	      markers.push(marker);
    		     	      
    		 }//for
    		 if(locations.length>0){
//    		 	console.log('length of markers array : ' +markers.length);
    		 	//console.log('length of locations array : ' +locations.length);
    		 const circle = new google.maps.Circle({
    		     map: map,
    		     radius: 2600, // Radius in meters
    		     fillColor: '#FFF', // Red fill color
    		     fillOpacity: 0.35, // Fill opacity
    		     strokeColor: '#F27C0A', // Red stroke color
    		     strokeOpacity: 0.8, // Stroke opacity
    		     strokeWeight: 2, // Stroke weight
    		     center: marker.getPosition() // Center the circle around the marker   	        
    		   });      

    		 circles.push(circle);
    		 }//if(locations.length>0)

    		 	//displayCurrentLocation(lat, lng);   		 	
    		 //        },//success
    		        $('#results').html('Results: ' +results);  		              		            
    		        }
    		        
    		 });	
    	 });
    	 
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
       //  console.log('removed category : ' +categories);
         
         button.disabled=false;
         console.log('applying style on click of close' +button.value);
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
         button.style.fontSize='12px';
         button.style.fontStyle='normal';
         button.style.fontWeight='400';
         button.style.lineHeight='normal';
         button.style.cursor='pointer';
         /*to decrement the counter*/
         const parentId = button.closest('.tabcontent').id; // Get the ID of the nearest parent with class 'tab'
      //   console.log('Parent Tab ID:', parentId); // Log the parent ID
         var counter = $('.'+parentId).text();
         counter = Number(counter)-1;
         $('.'+parentId).text(counter);
     //    console.log('counter as int: ' +counter);
         $('.'+parentId).show();
         
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
	}
    	
    	
function closeAlerttop(event)
{
     if (event.target.tagName === 'SPAN') {
         // Get the closest button element
        // $(this).siblings('.close-button').prop("disabled", true);
         const button = event.target.closest('button');          
         // Get the button value
         const buttonValue = button.value; // or button.innerText for the button's text
        console.log('button value in top' +buttonValue); // Outputs: "Button 1", "Button 2", or "Button 3" based on the clicked span
         const index = categories.indexOf(buttonValue);
         if (index > -1) { // only splice array when item is found
        	 categories.splice(index, 1); // 2nd parameter means remove one item only   
           }     
        // console.log('categories array at top : ' +categories);
          //get the button based on the value
       const buttons = document.querySelectorAll('.dropdown-item-right');
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
          const parentId = buton.closest('.tabcontent').id; // Get the ID of the nearest parent with class 'tab'
         // console.log('Parent Tab ID:', parentId); // Log the parent ID
          var counter = $('.'+parentId).text();
          counter = Number(counter)-1;
          $('.'+parentId).text(counter);
         // console.log('counter as int: ' +counter);
          $('.'+parentId).show();
          buton.disabled=false;
          //still to disable close
      }           
    }                
         /*top buttons*/
            button.remove();
                /*top buttons*/
     }//if   
     var k=0;
     $.ajax({
	        // Our sample url to make request 
	        url:"${pageContext.request.contextPath}/categories",
	        type: "POST",
	        contentType : 'application/json',
	        dataType : 'json',
	        data: JSON.stringify(categories), // Convert array to JSON string 
	        success: function (data) {
	            let x = JSON.stringify(data);
	         //   console.log('in categories success : ' +x);
	            document.getElementById("adcards").innerHTML = "";
	            for (var i = 0; i < markers.length; i++) {
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
	    	var results =0;
	             $.each(data, function (i, myList) {
	   	     	//  console.log('data in current location: ' +data);
	   	     	 var adsid = myList.id;
	 var phno = myList.phoneNumber;
	// console.log('phno : ' +phno);
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
	    	    	var thumbnail = myList.a.thumbnail;
	    	    	//console.log('companyLogoUrl: ' +companyLogoUrl);
	    	    	var banner1="nopreview.jpg";
	    	    	var banner2 = "nopreview.jpg";
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
	    	     	 var carouselid= 'myCarousel'+k;
	    	   var ad_card=	'<div class="panel panel-default "   role = "button" >'
	    	     	 +'<div class="panel-heading" id ="panelhead"   >'
	    	     	 +'  <img src="<c:url value="'+companyLogoUrl+'" />"  alt="User profile" style="width: 37px;height: 39px;" class="spotlightimg" />' 
	    	     	 +'  <div id="frame20"><h5 id="publishername">'+companyName+' </h5><div id ="publisherdate">'+formattedDate+'</div></div>'
	    	     	 +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
	    	     	 +'<div><svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 40 40" fill="none"> <path d="M11.5 28.6801V10H28V28.7634L20.1668 21.7548L19.4817 21.1418L18.8134 21.773L11.5 28.6801Z" stroke="black" stroke-width="2"/></svg></div>'
	    	     	 + '</div>'
	    	     	 +'<div class="panel-body" style = "display:flex;flex-direction:row;">'
	    	     	 +'<div class="carousel-container">'    		    	     	 
	    	     	 +'<div id="'+carouselid+'" class="carousel slide" data-ride="carousel">'
	    	     	 +'<ol class="carousel-indicators"><li data-target="#'+carouselid+'" data-slide-to="0" class="active"></li><li data-target="#'+carouselid+'" data-slide-to="1"></li><li data-target="#'+carouselid+'" data-slide-to="2"></li></ol>'
	                 +'<div class="carousel-inner"><div class="item active"><img src="<c:url value="'+thumbnail+'" />" alt="Los Angeles" style ="height:200px;width:200px;border-bottom-left-radius:20px;"></div>'
	                 +'<div class="item"><img src="<c:url value="'+thumbnail+'" />" alt="Chicago" style ="height:200px;width:200px;border-bottom-left-radius:20px;"></div><div class="item"><img src="<c:url value="'+thumbnail+'" />" alt="New York" style ="height:200px;width:200px;border-bottom-left-radius:20px;"></div></div>'
	                 +' <a class="left carousel-control" href="#'+carouselid+'" data-slide="prev"><span class="glyphicon glyphicon-chevron-left"></span><span class="sr-only">Previous</span></a>'
	                 +' <a class="right carousel-control" href="#'+carouselid+'" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span><span class="sr-only">Next</span></a></div>'
	                 +'</div>'
	                 +'<div class= "textcontainer" id = '+adsid+' onclick=nextui(this); > <p style="color: #000;font-family: Inter;font-size: 18px;font-style: normal;font-weight: 700;line-height: normal;align-self: stretch;">'+publisher_name+'</p><p class="description">'+description+'<h5 class="expires"> Expires on '+dates+'</h5>'
	                 +'  <div class ="button-group"><button style = "outline: none;background-color: white;border: none;" onclick=phone('+phno+');>  <i class="fa fa-phone" aria-hidden="true"></i></button>'
	                 +'<button style = "outline: none;background-color: white;border: none;" onclick=whatsapp('+phno+');><i class="fa fa-whatsapp" aria-hidden="true"></i></button><button style = "outline: none;background-color: white;border: none;"><i class="fa fa-envelope"></i></button>'
	                 +'<button type="button" class="btn btn-default" id = "takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+');><i class="fa fa-map-marker" aria-hidden="true" style = "font-size:17px;color: #F27C0A;">&nbsp;Take me there</i></button></div>';

	    	     	 $('#adcards').append(ad_card); 
	    	 //  console.log('ad_card: '+ad_card);
	    	     var  latt = 13.529271965260616;
	 	        var lngg = 75.36285138756304; 
	 	      
	 /*   var dist=getDistanceFromLatLonInKm(myList.location.lat,myList.location.lng,lat,lng).toFixed(1);
	    //console.log('dist value is :' +dist);
	   
	    
	    if(dist<=1.3)
	    	{	}*/
	 	   locations.push(  [myList.location.lat,myList.location.lng,publisher_name,publisher_name]);
	    	
	    	 results++;
	    	        	  }); //.each
	 //for map from here
	 var zoom_val=0;

	 var infowindow = new google.maps.InfoWindow();

	 //var marker, i ,png;
	 png='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
	 for (i = 0; i < locations.length; i++) {		 
	     		marker = new google.maps.Marker({
	     	        position: new google.maps.LatLng(locations[i][0], locations[i][1]),
	     	        map: map,
	     	        icon:png
	     	      });
	     		map.setZoom(12);
	             map.panTo(marker.position);    	
	     	      google.maps.event.addListener(marker, 'mouseover', (function(marker, i) {
	     	        return function() {
	     	         // infowindow.setContent('<b>Name:</b>&nbsp;'+ locations[i][2]+'.<br>'+'<b>:</b>&nbsp;'+ locations[i][3]+'<b>dist:</b>&nbsp;'+locations[i][4]);
	     	          infowindow.setContent('<b>Name:</b>&nbsp;'+ locations[i][2]);
	     	          infowindow.open(map, marker);
	     	        }
	     	      })(marker, i));
	     	      markers.push(marker);
	     	      
	 }//for
	 if(locations.length>0){
//	 	console.log('length of markers array : ' +markers.length);
	 	//console.log('length of locations array : ' +locations.length);
	 const circle = new google.maps.Circle({
	     map: map,
	     radius: 2600, // Radius in meters
	     fillColor: '#FFF', // Red fill color
	     fillOpacity: 0.35, // Fill opacity
	     strokeColor: '#F27C0A', // Red stroke color
	     strokeOpacity: 0.8, // Stroke opacity
	     strokeWeight: 2, // Stroke weight
	     center: marker.getPosition() // Center the circle around the marker
	    
	      
	   });      

	 circles.push(circle);
	 }//if(locations.length>0)

	 	//displayCurrentLocation(lat, lng);	
	 //        },//success
           
	 $('#results').html('Results: ' +results);    	            
	        }
	        
	 });	   
	}

    	// array of categories ends here
    	
    	// to drag filter options starts here
    	/*document.addEventListener('DOMContentLoaded', () =>{
  const containerfilter = document.querySelector('.button-containertop');
	 let isDownfilter = false;
	 let startXfilter;
	 let scrollLeftfilter;

	 containerfilter.addEventListener('mousedown', (e) => {
		 isDownfilter = true;
	   containerfilter.classList.add('active');
	   startXfilter = e.pageX - containerfilter.offsetLeft;
	   scrollLeftfilter = containerfilter.scrollLeftfilter;
	 });

	 containerfilter.addEventListener('mouseleave', () => {
	   isDownfilter = false;
	   containerfilter.classList.remove('active');
	 });

	 containerfilter.addEventListener('mouseup', () => {
	   isDownfilter = false;
	   containerfilter.classList.remove('active');
	 });

	 containerfilter.addEventListener('mousemove', (e) => {
		 console.log('mousemove : category'  );
	   if (!isDownfilter) return;
	   e.preventDefault();
	   const x = e.pageX - containerfilter.offsetLeft;
	   const walk = (x - startXfilter) * 3; //scroll-fast
	   containerfilter.scrollLeftfilter = scrollLeftfilter - walk;
	 });
	 });
	 
   /* 	
    	let mouseDownf = false;
    	let startXf, scrollLeftf;
    	const sliderf = document.querySelector('.button-containertop');

    	const startDraggingf = (e) => {
    	  mouseDownf = true;
    	  startXf = e.pageX - sliderf.offsetLeft;
    	  scrollLeftf = sliderf.scrollLeftf;
    	}

    	const stopDraggingf = (e) => {
    	  mouseDownf = false;
    	}

    	const move = (e) => {
    	  e.preventDefault();
    	  if(!mouseDownf) { return; }
    	  const x = e.pageX - sliderf.offsetLeft;
    	  const scroll = x - startXf;
    	  sliderf.scrollLeftf = scrollLeftf - scroll;
    	}

    	// Add the event listeners
    	sliderf.addEventListener('mousemove', move, false);
    	sliderf.addEventListener('mousedown', startDraggingf, false);
    	sliderf.addEventListener('mouseup', stopDraggingf, false);
    	sliderf.addEventListener('mouseleave', stopDraggingf, false);*/
    	//to drag filter options starts here
    var users = ${users};
    var spotlight="";
    var x=0;
   
    for(var i=0;i<users.length;i++)
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
	 $('.spotlightlist').append(spotlight);
	 //to filter
	
	// document.getElementById('spotlytsearch').addEventListener('input', filterItems);
	// Event listener for input changes
	//serch in spotlight starts from here 1
	 document.getElementById('spotlytsearch').addEventListener('input', function() {
	     const query = this.value;
	     //console.log('input : '+query);
	     const resultsContainer = document.getElementById('spotlightlist');
		    resultsContainer.innerHTML = ""; // Clear previous results
	     const filteredResults = filterArray(query);
	 //    console.log('filtered results: '+JSON.stringify(filteredResults));
	     displayResults(filteredResults);
	 });
	 function filterArray(query) {
		    const lowerCaseQuery = query.toLowerCase();
		    return users.filter(users => 
		        users.fullName.toLowerCase().includes(lowerCaseQuery) 
		       // item.category.toLowerCase().includes(lowerCaseQuery)
		    );
		}
	 
	 function displayResults(results) {
		 var spotlightt="";
		    const resultsContainer = document.getElementsByClassName('spotlightlist');
		    resultsContainer.innerHTML = ''; // Clear previous results
//console.log('inside display results: ' +resultsContainer);
		    for(var i=0;i<results.length;i++)
		    {
		    	//console.log('indise for');
		    	var name =results[i].fullName;
		    	 var profilepicpath= results[i].profilePicPath;
		    	var str = name.substring(0, 10);
		    	var userid = results[i].id;
		    	 spotlightt+='  <div class="spotlightitem" role="button" id = "'+userid+'">'
		    +'	<img  src="<c:url value="'+profilepicpath+'" />"  alt="User profile" style="width: 37px;height: 39px;"  class="spotlightimg"/>'
		    		+'<div class="companyname">'+str+'</div>'
			+' 		</div>';		    
		    	}		     
			 $('.spotlightlist').append(spotlightt);
		}
	 
	 //end here 1
	 //dragging listener for spotlight starts here 2 
	 const container = document.querySelector('.sp');
	 let isDown = false;
	 let startX;
	 let scrollLeft;

	 container.addEventListener('mousedown', (e) => {
	   isDown = true;
	   container.classList.add('active');
	   startX = e.pageX - container.offsetLeft;
	   scrollLeft = container.scrollLeft;
	 });

	 container.addEventListener('mouseleave', () => {
	   isDown = false;
	   container.classList.remove('active');
	 });

	 container.addEventListener('mouseup', () => {
	   isDown = false;
	   container.classList.remove('active');
	 });

	 container.addEventListener('mousemove', (e) => {
	   if (!isDown) return;
	   e.preventDefault();
	   const x = e.pageX - container.offsetLeft;
	   const walk = (x - startX) * 3; //scroll-fast
	   container.scrollLeft = scrollLeft - walk;
	 });

	 //end here 2
    //let marker;
    let map;
  
    let map2;
    var currentMarker;  // Variable to keep track of the current marker
    var locationn;
    var locations=[];
    var marker, i ,png; var maploc;
    function initMap() {
        // Initialize the map and set default properties
         map = new google.maps.Map(document.getElementById('map'), {
            center: { lat: 13.529271965260616, lng: 75.36285138756304 },
            zoom:12
        });      
         map2 = new google.maps.Map(document.getElementById('maploc'), {
             center: { lat: 13.529271965260616, lng: 75.36285138756304 },
             zoom:8
         });          
     
        google.maps.event.addListener(map2,'click',function(event) {
        //	console.log('in listener'+event.latLng);
        	if (currentMarker){
        		currentMarker.setMap(null);}
        	 handleMapClick(event.latLng, map2);
        	});
    }
    
 var markers=[];const circles = []; // Array to store circle references
    function handleMapClick(location, map) {
        // Place a marker at the clicked location
        var maph=map;
 //       console.log('in handle');
   /*     if ( currentMarker ) {
        	currentMarker.setPosition(location);
          }
        else{*/
        	  currentMarker= new google.maps.Marker({
            position: location,
            map: maph
           // title: `Lat: ${location.lat()}, Lng: ${location.lng()}`,
        });
        //  }
     //   console.log('marker value: '+currentMarker.getPosition().lat()+'and : ' +currentMarker.getPosition().lat());     
    }
    $( "#setlocation" ).on( "click", function() {
    	  //alert( "Handler for `click` called." ); 
    	//  console.log('value of locationn on ajax : ' +marker.getPosition().lat());
    	currentLocationset=false;
    	  var lat =currentMarker.getPosition().lat();
    	  var lng = currentMarker.getPosition().lng();
    	  var k = 0;
    	  
    //	  var locations=[];
    var results =0;
    $.ajax({
        // Our sample url to make request 
        url:"${pageContext.request.contextPath}/pinlocation",
        type: "POST",
        contentType : 'application/json',
        dataType : 'json',
        data:JSON.stringify({lat,lng}), 
        success: function (data) {
            let x = JSON.stringify(data);   
           // console.log(x);
               document.getElementById("adcards").innerHTML = "";
           for (var i = 0; i < markers.length; i++) {
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
   
   var newLocation = {lat,lng}; // 
   map.setCenter(newLocation); 
   map.setZoom(12); //
            $.each(data, function (i, myList) {
            	
            	  var adsid = myList.id;
     	     	 var phno = myList.phoneNumber;
     	     	// console.log('phno : ' +phno);
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
	    	var thumbnail = myList.a.thumbnail;
	    	//console.log('companyLogoUrl: ' +companyLogoUrl);
	    	var banner1="nopreview.jpg";
	    	var banner2 = "nopreview.jpg";
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
	     	 var carouselid= 'myCarousel'+k;
   	   var ad_card=	'<div class="panel panel-default "   role = "button"     >'
   	     	 +'<div class="panel-heading" id ="panelhead">'
   	     	 +'  <img src="<c:url value="'+companyLogoUrl+'" />"  alt="User profile" style="width: 37px;height: 39px;" class="spotlightimg" />' 
   	     	 +'  <div id="frame20"><h5 id="publishername">'+companyName+' </h5><div id ="publisherdate">'+formattedDate+'</div></div>'
   	     	 +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
   	     	 +'<div><svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 40 40" fill="none"> <path d="M11.5 28.6801V10H28V28.7634L20.1668 21.7548L19.4817 21.1418L18.8134 21.773L11.5 28.6801Z" stroke="black" stroke-width="2"/></svg></div>'
   	     	 + '</div>'
   	     	 +'<div class="panel-body" style = "display:flex;flex-direction:row;">'
	     	 +'<div class="carousel-container">'   	     	 
   	     	 
   	     	 +'<div id="'+carouselid+'" class="carousel slide" data-ride="carousel">'
   	     	 +'<ol class="carousel-indicators"><li data-target="#'+carouselid+'" data-slide-to="0" class="active"></li><li data-target="#'+carouselid+'" data-slide-to="1"></li><li data-target="#'+carouselid+'" data-slide-to="2"></li></ol>'
                +'<div class="carousel-inner"><div class="item active"><img src="<c:url value="'+thumbnail+'" />" alt="Los Angeles" style ="height:200px;width:200px;border-bottom-left-radius:20px;"></div>'
                +'<div class="item"><img src="<c:url value="'+thumbnail+'" />" alt="Chicago" style ="height:200px;width:200px;border-bottom-left-radius:20px;"></div><div class="item"><img src="<c:url value="'+thumbnail+'" />" alt="New York" style ="height:200px;width:200px;border-bottom-left-radius:20px;"></div></div>'
                +' <a class="left carousel-control" href="#'+carouselid+'" data-slide="prev"><span class="glyphicon glyphicon-chevron-left"></span><span class="sr-only">Previous</span></a>'
                +' <a class="right carousel-control" href="#'+carouselid+'" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span><span class="sr-only">Next</span></a></div>'
                +'</div>'
                +'<div class= "textcontainer" id = '+adsid+' onclick=nextui(this); > <p style="color: #000;font-family: Inter;font-size: 18px;font-style: normal;font-weight: 700;line-height: normal;align-self: stretch;">'+publisher_name+'</p><p class="description">'+description+'<h5 class="expires"> Expires on '+dates+'</h5>'
                +'  <div class ="button-group"><button style = "outline: none;background-color: white;border: none;" onclick=phone('+phno+');>  <i class="fa fa-phone" aria-hidden="true"></i></button>'
                +'<button style = "outline: none;background-color: white;border: none;" onclick=whatsapp('+phno+');><i class="fa fa-whatsapp" aria-hidden="true"></i></button><button style = "outline: none;background-color: white;border: none;"><i class="fa fa-envelope"></i></button>'
                +'<button type="button" class="btn btn-default" id = "takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+');><i class="fa fa-map-marker" aria-hidden="true" style = "font-size:17px;color: #F27C0A;">&nbsp;Take me there</i></button></div>';

   	     	 $('#adcards').append(ad_card); 
   	 //  console.log('ad_card: '+ad_card);
   	        var  latt = 13.529271965260616;
	        var lngg = 75.36285138756304; 
	      
 /*  var dist=getDistanceFromLatLonInKm(myList.location.lat,myList.location.lng,lat,lng).toFixed(1);
   //console.log('dist value is :' +dist);   
   if(dist<=1.3)
   	{}*/	
	   locations.push(  [myList.location.lat,myList.location.lng,publisher_name,publisher_name]);
   	
   	 results++;
   	        	  }); //.each
//for map from here
var zoom_val=0;

var infowindow = new google.maps.InfoWindow();

//var marker, i ,png;
png='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
for (i = 0; i < locations.length; i++) {		 
    		marker = new google.maps.Marker({
    	        position: new google.maps.LatLng(locations[i][0], locations[i][1]),
    	        map: map,
    	        icon:png
    	      });
    		map.setZoom(12);
            map.panTo(marker.position);    	
    	      google.maps.event.addListener(marker, 'mouseover', (function(marker, i) {
    	        return function() {
    	         // infowindow.setContent('<b>Name:</b>&nbsp;'+ locations[i][2]+'.<br>'+'<b>:</b>&nbsp;'+ locations[i][3]+'<b>dist:</b>&nbsp;'+locations[i][4]);
    	          infowindow.setContent('<b>Name:</b>&nbsp;'+ locations[i][2]);
    	          infowindow.open(map, marker);
    	        }
    	      })(marker, i));
    	      markers.push(marker);
    	      
}
if(locations.length>0){
	//console.log('length of markers array : ' +locations.length);
const circle = new google.maps.Circle({
    map: map,
    radius: 2600, // Radius in meters
    fillColor: '#FFF', // Red fill color
    fillOpacity: 0.35, // Fill opacity
    strokeColor: '#F27C0A', // Red stroke color
    strokeOpacity: 0.8, // Stroke opacity
    strokeWeight: 2, // Stroke weight
    center: marker.getPosition() // Center the circle around the marker
  });      

circles.push(circle);
}

displayCurrentLocation(lat, lng);
$('#results').html('Results: ' +results);
        },

        // Error handling 
        error: function (error) {
            console.log(`Error ${error}`);
        }
    });
    
    });//jqueery onclick
  //on chNGE OF SLIDER VALUE starts here
  function sliderClick(){
 	   var slider = document.getElementById('rangeOutputId');
        var sliderValue = document.getElementById('rangeInputId');
        slider.value = sliderValue.value;
       // console.log('slider value: '+sliderValue.value);
      //   console.log('marker value: '+currentMarker.getPosition().lat()+'and : ' +currentMarker.getPosition().lng());
         var lat = currentMarker.getPosition().lat();
         var lng = currentMarker.getPosition().lng();
       //  var data ={"lat":lat,"lng":lng,"kilometers":sliderValue.value};
    //   console.log(+lat +'and : '+lng);
       var s = sliderValue.value;
      // console.log('s: '+s);
      var k =0;
        $.ajax({
            url: '${pageContext.request.contextPath}/combined',
            type: "POST",
            //contentType: 'application/json',
            data:{slidervalue:s},
            success: function(response) {
               // console.log('Success:', response);
                let x = JSON.stringify(response);                
                //console.log(x);
                document.getElementById("adcards").innerHTML = "";
               for (var i = 0; i < markers.length; i++) {
    	   markers[i].setMap(null); // Remove marker from the map
    	 
    	  // locations[i]=null;
          }
       locations = []; // Clear the array of markers
       circles.forEach(circle => {
           circle.setMap(null); // Remove circle from the map
       });
       circles.length = 0; // Clear the array
       
       var newLocation = {lat,lng}; // 
       map.setCenter(newLocation); 
       map.setZoom(12); //
       var results=0;
                $.each(JSON.parse(response), function (i, myList) {
      	     	//  console.log('data in current location: ' +data);
      	     	  var adsid = myList.id;
	     	 var phno = myList.phoneNumber;
	     	// console.log('phno : ' +phno);
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
    	    	var thumbnail = myList.a.thumbnail;
    	    	//console.log('companyLogoUrl: ' +companyLogoUrl);
    	    	var banner1="nopreview.jpg";
    	    	var banner2 = "nopreview.jpg";
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
   	     	 var carouselid= 'myCarousel'+k;
       	   var ad_card=	'<div class="panel panel-default "   role = "button" >'
       	     	 +'<div class="panel-heading" id ="panelhead"   >'
       	     	 +'  <img src="<c:url value="'+companyLogoUrl+'" />"  alt="User profile" style="width: 37px;height: 39px;" class="spotlightimg"  />' 
       	     	 +'  <div id="frame20"><h5 id="publishername">'+companyName+' </h5><div id ="publisherdate">'+formattedDate+'</div></div>'
       	     	 +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
       	     	 +'<div><svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 40 40" fill="none"> <path d="M11.5 28.6801V10H28V28.7634L20.1668 21.7548L19.4817 21.1418L18.8134 21.773L11.5 28.6801Z" stroke="black" stroke-width="2"/></svg></div>'
       	     	 + '</div>'
       	     	 +'<div class="panel-body" style = "display:flex;flex-direction:row;">'
       	     	+'<div class="carousel-container">'
       	     	 
       	     	 +'<div id="'+carouselid+'" class="carousel slide" data-ride="carousel">'
       	     	 +'<ol class="carousel-indicators"><li data-target="#'+carouselid+'" data-slide-to="0" class="active"></li><li data-target="#'+carouselid+'" data-slide-to="1"></li><li data-target="#'+carouselid+'" data-slide-to="2"></li></ol>'
                    +'<div class="carousel-inner"><div class="item active"><img src="<c:url value="'+thumbnail+'" />" alt="Los Angeles" style ="height:200px;width:200px;border-bottom-left-radius:20px;"></div>'
                    +'<div class="item"><img src="<c:url value="'+banner1+'" />" alt="Chicago" style ="height:200px;width:200px;border-bottom-left-radius:20px;"></div><div class="item"><img src="<c:url value="'+banner2+'" />" alt="New York" style ="height:200px;width:200px;border-bottom-left-radius:20px;"></div></div>'
                    +' <a class="left carousel-control" href="#'+carouselid+'" data-slide="prev"><span class="glyphicon glyphicon-chevron-left"></span><span class="sr-only">Previous</span></a>'
                    +' <a class="right carousel-control" href="#'+carouselid+'" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span><span class="sr-only">Next</span></a></div>'
                    +'</div>'
                    +'<div class= "textcontainer" id = '+adsid+' onclick=nextui(this);> <p style="color: #000;font-family: Inter;font-size: 18px;font-style: normal;font-weight: 700;line-height: normal;align-self: stretch;">'+publisher_name+'</p><p class="description">'+description+'<h5 class="expires"> Expires on '+dates+'</h5>'
                    +'  <div class ="button-group"><button style = "outline: none;background-color: white;border: none;" onclick=phone('+phno+');>  <i class="fa fa-phone" aria-hidden="true"></i></button>'
                    +'<button style = "outline: none;background-color: white;border: none;" onclick=whatsapp('+phno+');><i class="fa fa-whatsapp" aria-hidden="true"></i></button><button style = "outline: none;background-color: white;border: none;"><i class="fa fa-envelope"></i></button>'
                    +'<button type="button" class="btn btn-default" id = "takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+');><i class="fa fa-map-marker" aria-hidden="true" style = "font-size:17px;color: #F27C0A;">&nbsp;Take me there</i></button></div>';

       	     	 $('#adcards').append(ad_card); 
       	 //  console.log('ad_card: '+ad_card);
       	     var  latt = 13.529271965260616;
    	        var lngg = 75.36285138756304; 
    	      
     /*  var dist=getDistanceFromLatLonInKm(myList.location.lat,myList.location.lng,lat,lng).toFixed(1);
       //console.log('dist value is :' +dist);
         if(dist<=s)
       	{	}*/
    	   locations.push(  [myList.location.lat,myList.location.lng,publisher_name,publisher_name]);
       	
       	 results++;
       	        	  }); //.each
    //for map from here
    var zoom_val=0;

    var infowindow = new google.maps.InfoWindow();

    //var marker, i ,png;
    png='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
    for (i = 0; i < locations.length; i++) {		 
        		marker = new google.maps.Marker({
        	        position: new google.maps.LatLng(locations[i][0], locations[i][1]),
        	        map: map,
        	        icon:png
        	      });
        		map.setZoom(12);
                map.panTo(marker.position);    	
        	      google.maps.event.addListener(marker, 'mouseover', (function(marker, i) {
        	        return function() {
        	         // infowindow.setContent('<b>Name:</b>&nbsp;'+ locations[i][2]+'.<br>'+'<b>:</b>&nbsp;'+ locations[i][3]+'<b>dist:</b>&nbsp;'+locations[i][4]);
        	          infowindow.setContent('<b>Name:</b>&nbsp;'+ locations[i][2]);
        	          infowindow.open(map, marker);
        	        }
        	      })(marker, i));
        	      markers.push(marker);
        	      
    }//for
    if(locations.length>0){
    	var radi = s*2*1000;
//    	console.log('length of markers array : ' +markers.length);
    //	console.log('length of locations array : ' +locations.length);
    const circle = new google.maps.Circle({
        map: map,
        radius: radi, // Radius in meters
        fillColor: '#FFF', // Red fill color
        fillOpacity: 0.35, // Fill opacity
        strokeColor: '#F27C0A', // Red stroke color
        strokeOpacity: 0.8, // Stroke opacity
        strokeWeight: 2, // Stroke weight
        center: marker.getPosition() // Center the circle around the marker
        });      

    circles.push(circle);
    }//if(locations.length>0)

    	displayCurrentLocation(lat, lng);
    	$('#results').html('Results: ' +results);

            },
            error: function(xhr, status, error) {
                console.error('Error:', error);
            }
        });

        
     	
     }
  // on change of slider value ends here
    
    //on click of current location start here
   //cut till here
  
    function getCurrentLocations(){
    	//console.log('in get current locations()');
 //watchLocation();
    	  if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                function(position) {
                //	console.log('to fetch lat lng');
                  const   lat = position.coords.latitude;
                  const   lng = position.coords.longitude;
                //  navigator.geolocation.watchPosition(currentLocation, showError, { enableHighAccuracy: true, timeout: 60000 });
                	watchID = navigator.geolocation.watchPosition(updateMarkerPosition, showError, { enableHighAccuracy: true, timeout: 30000, maximumAge: 10000,  distanceFilter: 10 });
              currentLocation(position);
                },
                function(error) {
                    console.error('Error getting location by :', error);
                    document.getElementById('location').innerText = 'Error getting location.';
                }
            );
        } else {
            document.getElementById('location').innerText = 'Geolocation is not supported by this browser.';
        }
    	 // console.log('lat and lng : '+ lat +lng);
    }
    function currentLocation(position){
    //	console.log('current location got successfully from watch');
    	currentLocationset=true;
    	locationset++;
   // 	 $("#locationflag").html('Current Location Set : ' +locationset );
    	 var lat = position.coords.latitude;
    	 var lng = position.coords.longitude;
    var k=0;
    var results=0;
  /*  if (navigator.geolocation) 
    { 
    	watchID = navigator.geolocation.watchPosition(updateMarkerPosition, showError, { enableHighAccuracy: true, timeout: 60000, maximumAge: 0, });
    	} 
    else { alert("Geolocation is not supported by this browser."); }*/
    
    	$.ajax({
        // Our sample url to make request 
        url:"${pageContext.request.contextPath}/currentlocation",
        type: "POST",
        contentType : 'application/json',
        dataType : 'json',
        data:JSON.stringify({lat,lng}), 
        success: function (data) {
            let x = JSON.stringify(data);
            
       //     console.log(x);
            document.getElementById("adcards").innerHTML = "";
           for (var i = 0; i < markers.length; i++) {
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
   	
    var newLocation = {lat,lng}; // 
    map.setCenter(newLocation); 
    map.setZoom(12); //
    
            $.each(data, function (i, myList) {
  	     	//  console.log('data in current location: ' +data);
  	     	 var adsid = myList.id;
	     	 var phno = myList.phoneNumber;
	     	// console.log('phno : ' +phno);
	     	 var email= myList.emailAddress;
   	     	 var publisher_name = myList.a.title;
   	   
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
	     	 var carouselid= 'myCarousel'+k;
   	   var ad_card=	'<div class="panel panel-default "   role = "button"  >'
   	     	 +'<div class="panel-heading" id ="panelhead"   >'
   	     	 +'  <img src="<c:url value="'+companyLogoUrl+'" />"  alt="User profile" style="width: 37px;height: 39px;" class="spotlightimg"  />' 
   	     	 +'  <div id="frame20"><h5 id="publishername">'+companyName+' </h5><div id ="publisherdate">'+formattedDate+'</div></div>'
   	     	 +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
   	     	 +'<div><svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 40 40" fill="none"> <path d="M11.5 28.6801V10H28V28.7634L20.1668 21.7548L19.4817 21.1418L18.8134 21.773L11.5 28.6801Z" stroke="black" stroke-width="2"/></svg></div>'
   	     	 + '</div>'
   	     	 +'<div class="panel-body" style = "display:flex;flex-direction:row;">'
   	     	+'<div class="carousel-container">'
   	     	 
   	     	 +'<div id="'+carouselid+'" class="carousel slide" data-ride="carousel">'
   	     	 +'<ol class="carousel-indicators"><li data-target="#'+carouselid+'" data-slide-to="0" class="active"></li><li data-target="#'+carouselid+'" data-slide-to="1"></li><li data-target="#'+carouselid+'" data-slide-to="2"></li></ol>'
                +'<div class="carousel-inner"><div class="item active"><img src="<c:url value="'+thumbnail+'" />" alt="Los Angeles" style ="height:200px;width:200px;border-bottom-left-radius:20px;"></div>'
                +'<div class="item"><img src="<c:url value="'+banner1+'" />" alt="Chicago" style ="height:200px;width:200px;border-bottom-left-radius:20px;"></div><div class="item"><img src="<c:url value="'+banner2+'" />" alt="New York" style ="height:200px;width:200px;border-bottom-left-radius:20px;"></div></div>'
                +' <a class="left carousel-control" href="#'+carouselid+'" data-slide="prev"><span class="glyphicon glyphicon-chevron-left"></span><span class="sr-only">Previous</span></a>'
                +' <a class="right carousel-control" href="#'+carouselid+'" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span><span class="sr-only">Next</span></a></div>'
                +'</div>'
                +'<div class= "textcontainer" id = '+adsid+' onclick=nextui(this);> <p style="color: #000;font-family: Inter;font-size: 18px;font-style: normal;font-weight: 700;line-height: normal;align-self: stretch;">'+publisher_name+'</p><p class="description">'+description+'<h5 class="expires"> Expires on '+dates+'</h5>'
                +'  <div class ="button-group"><button style = "outline: none;background-color: white;border: none;" onclick=phone('+phno+');>  <i class="fa fa-phone" aria-hidden="true"></i></button>'
                +'<button style = "outline: none;background-color: white;border: none;" onclick=whatsapp('+phno+');><i class="fa fa-whatsapp" aria-hidden="true"></i></button><button style = "outline: none;background-color: white;border: none;"><i class="fa fa-envelope"></i></button>'
                +'<button type="button" class="btn btn-default" id = "takeme" onclick=takeme('+latitudes+','+longitudes+');><i class="fa fa-map-marker" aria-hidden="true" style = "font-size:17px;color: #F27C0A;">&nbsp;Take me there</i></button></div>';

   	     	 $('#adcards').append(ad_card); 
   	 //  console.log('ad_card: '+ad_card);
   	     var  latt = 13.529271965260616;
	        var lngg = 75.36285138756304; 
	      
/*   var dist=getDistanceFromLatLonInKm(myList.location.lat,myList.location.lng,lat,lng).toFixed(1);
   //console.log('dist value is :' +dist);
  
   
   if(dist<=1.3)
   	{	}*/
	   locations.push(  [myList.location.lat,myList.location.lng,publisher_name,publisher_name]);
   	results++;
   	 
   	        	  }); //.each
//for map from here
var zoom_val=0;

var infowindow = new google.maps.InfoWindow();

//var marker, i ,png;
png='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
for (i = 0; i < locations.length; i++) {		 
    		marker = new google.maps.Marker({
    	        position: new google.maps.LatLng(locations[i][0], locations[i][1]),
    	        map: map,
    	        icon:png
    	      });
    		map.setZoom(12);
            map.panTo(marker.position);    	
    	      google.maps.event.addListener(marker, 'mouseover', (function(marker, i) {
    	        return function() {
    	         // infowindow.setContent('<b>Name:</b>&nbsp;'+ locations[i][2]+'.<br>'+'<b>:</b>&nbsp;'+ locations[i][3]+'<b>dist:</b>&nbsp;'+locations[i][4]);
    	          infowindow.setContent('<b>Name:</b>&nbsp;'+ locations[i][2]);
    	          infowindow.open(map, marker);
    	        }
    	      })(marker, i));
    	      markers.push(marker);
    	      
}//for
if(locations.length>0){
//	console.log('length of markers array : ' +markers.length);
	//console.log('length of locations array : ' +locations.length);
const circle = new google.maps.Circle({
    map: map,
    radius: 2600, // Radius in meters
    fillColor: '#FFF', // Red fill color
    fillOpacity: 0.35, // Fill opacity
    strokeColor: '#F27C0A', // Red stroke color
    strokeOpacity: 0.8, // Stroke opacity
    strokeWeight: 2, // Stroke weight
    center: marker.getPosition() // Center the circle around the marker      
  });      

circles.push(circle);
}//if(locations.length>0)

	displayCurrentLocation(lat, lng);
	$('#results').html('Results: ' +results);
        },//success

        // Error handling 
        error: function (error) {
            console.log(`Error ${error}`);
        }
    });
    
    } //currentLocation()

    // moving blue marker start here 
     function updateMarkerPosition(position) 
	    { 
    	console.log('updateMarker: ' +position.coords.latitude);
	    
	    	const lat = position.coords.latitude; const lng = position.coords.longitude; //position.coords.latitude
	    	const newPosition = new google.maps.LatLng(lat, lng); // Update the marker's position 
	    	blueMarker.setPosition(newPosition); // Center the map on the new position 
	    	map.setCenter(newPosition);
	    	$('#locationflag').html('current location set : ' +locationset++);
	    	console.log('watch ID: ' +watchID);
	    	/*   var dist=getDistanceFromLatLonInKm(lastlat,lastlng,lat,lng).toFixed(1);
	    	 var detectLocation = { coords: {latitude: position.coords.latitude, longitude: position.coords.longitude} };
	   	      if(dist>0.2)
	   	    	  {
	   	    	 // console.log('distance : ' +dist);		    	  
	   	    	//  var detectLocation = { coords: {  latitude: 13.529271965260616,  longitude: 75.36285138756304 } };
	   	    	//updateMarkerPosition(position);
	   	    	 sendLocationDetect(detectLocation);
	   	    	 // sendLocation(detectLocation);
	   	    	 
	   	    	  }*/
	    } // Function to handle errors 
	    	function showError(error) { switch (error.code) { case error.PERMISSION_DENIED: alert("User denied the request for Geolocation."); break; case error.POSITION_UNAVAILABLE: alert("Location information is unavailable."); break; case error.TIMEOUT: alert("The request to get user location timed out."); break; case error.UNKNOWN_ERROR: alert("An unknown error occurred."); break; } }
	  //moving blue marker end here  
    // current location ends here
    // to show the address from here
    function getCurrentLocation() {
    //	console.log('in get current location');
    
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                function(position) {
                //	console.log('to fetch lat lng');
                    const lat = position.coords.latitude;
                    const lng = position.coords.longitude;
                //  	console.log('to fetch lat lng'+lat +'and: ' +lng);
                    displayLocation(lat, lng);
                },
                function(error) {
               //     console.error('Error getting location:', error);
                    //document.getElementById('location').innerText = 'Error getting location.';
                    var defaultLocation = { coords: { latitude: 13.529271965260616,  longitude: 75.36285138756304 } };
                 	 const lat = defaultLocation.coords.latitude;
                    const lng = defaultLocation.coords.longitude;
                    displayLocation(lat, lng);
                }
            );
        } else {
        	
        }
    }
    function displayCurrentLocation(lat, lng) {
        const API_KEY = '${googleMapsApiKey}';
    	// Optionally use reverse geocoding to get address   	
        //const url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=12.9299961,77.5698116&key=${googleMapsApiKey}';      
    	const url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng='+lat+','+lng+'&key='+API_KEY;    	
        fetch(url)
            .then(response => response.json())
            .then(data => {
            	//console.log('to fetch address' +JSON.stringify(data));
                if (data.status === 'OK' && data.results.length > 0) {
                	 const address = data.results[0].formatted_address;
                 //  console.log("data in reverse geolocation: " +address);
                //   console.log('on click event');
                   //document.getElementById('address').innerHTML  = address;
                   const inputField = document.getElementById('address');
                   // Set the value of the input field to the variable's value
                   inputField.value = address;
                   
                   const inputField2 = document.getElementById('locationintext');
                   inputField2.value = address;
                   
                   const location = { lat: lat, lng: lng };
                   // Create a map centered at the location
             /*     const maploc = new google.maps.Map(document.getElementById('maploc'), {
                       zoom: 12,
                       center: location
                   });*/
                   if (currentMarker){
               		currentMarker.setMap(null);}
                   currentMarker = new google.maps.Marker({
                       position: location,
                       map: map2,
                       title: address
                   });
                } else {
                //    document.getElementById('location').innerText = 'Unable to reverse geocode location.';
                }
            })
            .catch(error => {
                console.error('Error with reverse geocoding:', error);
                //document.getElementById('location').innerText = 'Error with reverse geocoding.';
            });
    }

    function displayLocation(lat, lng) {
        const API_KEY = '${googleMapsApiKey}';
    	// Optionally use reverse geocoding to get address
     
    	lat = 13.529271965260616;
    	lng = 75.36285138756304
        //const url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=12.9299961,77.5698116&key=${googleMapsApiKey}';
        
    	const url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng='+lat+','+lng+'&key='+API_KEY;
    	

        fetch(url)
            .then(response => response.json())
            .then(data => {
            	//console.log('to fetch address' +JSON.stringify(data));
                if (data.status === 'OK' && data.results.length > 0) {
                	 const address = data.results[0].formatted_address;
                 //  console.log("data in reverse geolocation: " +address);
                //   console.log('on click event');
                   //document.getElementById('address').innerHTML  = address;
                   const inputField = document.getElementById('address');
                   // Set the value of the input 	field to the variable's value
                   inputField.value = address;                   
                   const inputField2 = document.getElementById('locationintext');
                   inputField2.value = address;
                   
                   var location = { lat: lat, lng: lng };
                   // Create a map centered at the location
               /*  maploc = new google.maps.Map(document.getElementById('maploc'), {
                       zoom: 8,
                       center: location
                   });*/
                  
                   if (currentMarker){
               		currentMarker.setMap(null);}
                  currentMarker = new google.maps.Marker({
                       position: location,
                       map: map2,
                       title: address
                   });
                } else {
                //    document.getElementById('location').innerText = 'Unable to reverse geocode location.';
                }
            })
            .catch(error => {
                console.error('Error with reverse geocoding:', error);
                //document.getElementById('location').innerText = 'Error with reverse geocoding.';
            });
    }

    // Initialize and fetch current location when the page loads
    window.onload = getCurrentLocation;
    getCurrentLocation();
    
    //to show the address till here 
      // to pin location till here
    

    // Initialize the map after the page has loaded
    window.onload = initMap;
    initMap();

    
    
    document.addEventListener('DOMContentLoaded', () => {//console.log('in map');
    	  const map = document.querySelector('.mapcontainer');
    	  const outerContainer = document.querySelector('.col-md-4');
    	    const sliderContainerinput = document.getElementById('rangeInputId');
    	    const sliderContaineroutput = document.getElementById('rangeOutputId');
const sliderContainer= document.getElementById('.slider-container');
const maps= document.getElementById('map');

    	  map.addEventListener('mouseover', () => {
    	    outerContainer.style.height = '450px'; // Increase height on hover
    	    sliderContainerinput.style.display='block';
    	    sliderContaineroutput.style.display='block';
    	    map.style.height='300px';
    	    maps.style.height='320px';
    	  });

    	  map.addEventListener('mouseout', () => {
    	    outerContainer.style.height = '300px'; // Reset height when not hovering
    	    sliderContainerinput.style.display='none';
   	    sliderContaineroutput.style.display='none';
    	    map.style.height='430px';
    	    maps.style.height='159px';
    	  });
    	});	
    
 
 var takemelat;var takemelng;var blueMarker;var lastlat,lastlng; var locationset =0; var currentLocationset=false;let watchID;
    document.addEventListener("DOMContentLoaded", function() {   
	    function getLocation() {
	    //	console.log('in get location:  polling');
	  //  	position = {lat: 13.529271965260616, lng: 75.36285138756304};
	  //  sendLocation(position);
	       if (navigator.geolocation) {
	            navigator.geolocation.getCurrentPosition(sendLocation,sendDefaultLocation);
	        } 	   
	        else {
	        	
	        }
	    }        
	    var blueMarkers = [];
	    function sendDefaultLocation(defaultLocation)
	    {
	    //	var defaultLocation = {latitude: 13.529271965260616, longitude: 75.36285138756304};
	    	var defaultLocation = { coords: { latitude: 13.529271965260616,  longitude: 75.36285138756304 } };
	    //	console.log('def: ' +defaultLocation);
	    	console.log('in default location: ' +defaultLocation.lat);
	    	sendLocation(defaultLocation);
	    }
	    	   
	    function sendLocation(position) {
	   	   var lat  = position.coords.latitude;
	       var lng = position.coords.longitude;	       
	      // const lat = position.lat;
	      // const lng = position.lng;
	       takemelat = lat;
	       takemelng = lng;
	       lastlat= lat;
	       lastlng = lng;
	       lat=13.529271965260616;  lng=75.36285138756304 ;
	      //console.log('in send loc take me lat when dist is 0: ' +takemelat +'take me long: ' +takemelng);
	    
	 /*    blueMarker = new google.maps.Marker({
   	        position: new google.maps.LatLng(takemelat,takemelng),
   	        map: map,
   	        icon:{
   	           	path: google.maps.SymbolPath.CIRCLE,
   	        	fillColor: 'blue',  // Color of the marker
   	            fillOpacity: 1,
   	            scale: 10,  // Size of the marker
   	            strokeColor: 'white',  // Border color of the marker
   	            strokeWeight: 2  // Border width
   	        }
   	      });
   		   map.setZoom(12);
           map.panTo(blueMarker.position); 
           blueMarkers.push(blueMarker);
     var text='You are here';
  // Create an InfoWindow
  infoWindow = new google.maps.InfoWindow({ 
	  
	//  content: '<div class="custom-info-content"><h3>Custom InfoWindow</h3><p>This is a custom InfoWindow with a specific size.</p></div>',
	  maxWidth: 200 // Set the maximum width of the InfoWindow 
  
	  });
  
        // Add hover event to show InfoWindow 
        google.maps.event.addListener(blueMarker, 'mouseover', function() {
        	infoWindow.setContent(text); 
        	infoWindow.open(map, blueMarker); 
        	}); 
        // Add mouseout event to close InfoWindow 
        	google.maps.event.addListener(blueMarker, 'mouseout', function() { 
        		infoWindow.close(); 
        		});
        	*/             		    
	        var latt = 13.529271965260616;
	        var lngg = 75.36285138756304; 
	        var k = 0;
	        var results =0;
			//console.log('latitude: ' +position.coords.latitude);
			//console.log('longitude: ' +position.coords.longitude);
	        fetch('${pageContext.request.contextPath}/location', {
	            method: 'POST',
	            headers: {
	                'Content-Type': 'application/json',
	            },
	            body: JSON.stringify({ lat, lng }),
	        })
	        .then(response => response.json())
	        .then(data => {
	        	
	        	//to add blue marker start from here
		     	 blueMarker = new google.maps.Marker({
	   	        position: new google.maps.LatLng(takemelat,takemelng),
	   	        map: map,
	   	        icon:{
	   	           	path: google.maps.SymbolPath.CIRCLE,
	   	        	fillColor: 'blue',  // Color of the marker
	   	            fillOpacity: 1,
	   	            scale: 5,  // Size of the marker
	   	            strokeColor: 'white',  // Border color of the marker
	   	            strokeWeight: 1  // Border width
	   	        }
	   	      });
	   		   map.setZoom(12);
	           map.panTo(blueMarker.position); 
	           blueMarkers.push(blueMarker);
	     var text='You are here';
	  // Create an InfoWindow
	  infoWindow = new google.maps.InfoWindow({ 	  
		//  content: '<div class="custom-info-content"><h3>Custom InfoWindow</h3><p>This is a custom InfoWindow with a specific size.</p></div>',
		  maxWidth: 200 // Set the maximum width of the InfoWindow 
	  
		  });	  
	        // Add hover event to show InfoWindow 
	        google.maps.event.addListener(blueMarker, 'mouseover', function() {
	        	infoWindow.setContent(text); 
	        	infoWindow.open(map, blueMarker); 
	        	}); 
	        // Add mouseout event to close InfoWindow 
	        	google.maps.event.addListener(blueMarker, 'mouseout', function() { 
	        		infoWindow.close(); 
	        		});
	        	
	        //blue marker tracking start here
	    /*    if (navigator.geolocation) 
	        { 
	        	watchID = navigator.geolocation.watchPosition(updateMarkerPosition, showError, { enableHighAccuracy: true, timeout: 60000, maximumAge: 0, });
	        	} 
	        else { alert("Geolocation is not supported by this browser."); }*/
	        
	        
	        //blue marger tracking end here 
	        	//to add blue marker end here
	   
	        	  $.each(data, function (i, myList) {
	
	     	  var adsid = myList.id;
	     	 var phno = myList.phoneNumber;
	     	// console.log('phno : ' +phno);
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
	    	var thumbnail = myList.a.thumbnail;
	    	//console.log('companyLogoUrl: ' +companyLogoUrl);
	    	var banner1="nopreview.jpg";
	    	var banner2 = "nopreview.jpg";
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
	     	if(myList.companies==null || myList.companies==undefined){
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
	     	//onclick=nextui(this);
	     	 var img_path = "";
	     	 k++;
	     	 var carouselid= 'myCarousel'+k;
	     	 //onclick=nextui(this);
	   var ad_card=	'<div class="panel panel-default"   role = "button"    >'
	     	 +'<div class="panel-heading"  id ="panelhead"  >'
	     	 +'  <img src="<c:url value="'+companyLogoUrl+'" />"  alt="User profile" style="width: 37px;height: 39px;" class="spotlightimg" />' 
	     	 +'  <div id="frame20"><h5 id="publishername">'+companyName+' </h5><div id ="publisherdate">'+formattedDate+'</div></div>'
	     	 +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
	     	 +'<div><svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 40 40" fill="none"> <path d="M11.5 28.6801V10H28V28.7634L20.1668 21.7548L19.4817 21.1418L18.8134 21.773L11.5 28.6801Z" stroke="black" stroke-width="2"/></svg></div>'
	     	 + '</div>'
	     	 +'<div class="panel-body" style = "display:flex;flex-direction:row;">'
	     	 +'<div class="carousel-container">'
	     	 +'<div id="'+carouselid+'" class="carousel slide" data-ride="carousel">'
	     	 +'<ol class="carousel-indicators"><li data-target="#'+carouselid+'" data-slide-to="0" class="active"></li><li data-target="#'+carouselid+'" data-slide-to="1"></li><li data-target="#'+carouselid+'" data-slide-to="2"></li></ol>'
             +'<div class="carousel-inner"><div class="item active">'
             +'<img src="<c:url value="'+thumbnail+'" />" alt="Los Angeles" style ="height:200px;width:200px;border-bottom-left-radius:20px;"></div>'
             +'<div class="item">'
             
             +'<img src="<c:url value="'+banner1+'" />" alt="Chicago" style ="height:200px;width:200px;border-bottom-left-radius:20px;"></div>'
             +'<div class="item"><img src="<c:url value="'+banner2+'" />" alt="New York" style ="height:200px;width:200px;border-bottom-left-radius:20px;"></div></div>'
             +' <a class="left carousel-control" href="#'+carouselid+'" data-slide="prev" ><span class="glyphicon glyphicon-chevron-left"></span><span class="sr-only">Previous</span></a>'
             +' <a class="right carousel-control" href="#'+carouselid+'" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span><span class="sr-only">Next</span></a></div>'
             
             +'</div>'
             +'<div class= "textcontainer" id = '+adsid+'  onclick=nextui(this); > <p style="color: #000;font-family: Inter;font-size: 18px;font-style: normal;font-weight: 700;line-height: normal;align-self: stretch;">'+publisher_name+'</p><p class="description">'+description+'<h5 class="expires"> Expires on '+dates+'</h5>'
             +'  <div class ="button-group"><button style = "outline: none;background-color: white;border: none;width: 25px; border-radius: 5px;" onclick=phone('+phno+');>  <i class="fa fa-phone" aria-hidden="true"> </i></button>'
             +'<button style = "outline: none;background-color: white;border: none;width: 25px;border-radius: 5px;" onclick=whatsapp('+phno+');><i class="fa fa-whatsapp" aria-hidden="true"></i></button><button style = "outline: none;background-color: white;border: none;width: 25px;border-radius: 5px;"><i class="fa fa-envelope"></i></button>'
             +'<button type="button" class="btn btn-default" id = "takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+');><i class="fa fa-map-marker" aria-hidden="true" style = "font-size:17px;color: #F27C0A;">&nbsp;Take me there</i></button></div>';
              //onclick=takeme('+latitudes+','+longitudes+');
	     	 $('#adcards').append(ad_card); 
	
	
//var dist=getDistanceFromLatLonInKm(myList.location.lat,myList.location.lng,latt,lngg).toFixed(1);
locations.push(  [myList.location.lat,myList.location.lng,publisher_name,publisher_name]);
//console.log('dist value is :' +dist);
//if(dist<=1.3)	{}	 
results++;
	        	  }); //.each
	        	  
	        	 console.log("location array : " +locations); 
	        	  $('#results').html('Results: '+results) ;
var zoom_val=0;

var infowindow = new google.maps.InfoWindow();

//var marker, i ,png;
png='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
for (i = 0; i < locations.length; i++) {		 
    		marker = new google.maps.Marker({
    	        position: new google.maps.LatLng(locations[i][0], locations[i][1]),
    	        map: map,
    	        icon:png
    	      });
    		map.setZoom(12);
            map.panTo(marker.position);    	
    	     /* google.maps.event.addListener(marker, 'mouseover', (function(marker, i) {
    	        return function() {
    	         // infowindow.setContent('<b>Name:</b>&nbsp;'+ locations[i][2]+'.<br>'+'<b>:</b>&nbsp;'+ locations[i][3]+'<b>dist:</b>&nbsp;'+locations[i][4]);
    	          infowindow.setContent('<b>Publisher Name:</b>&nbsp;'+ locations[i][2]);
    	          infowindow.open(map, marker);
    	        }
    	      })(marker, i));
    	      markers.push(marker);*/
    	  //    console.log('marker aray :  ' +markers);
}
const circle = new google.maps.Circle({
    map: map,
    radius: 2600, // Radius in meters
   // fillColor: '#FF0000', // Red fill color
    fillOpacity: 0.35, // Fill opacity
    strokeColor: '#FF0000', // Red stroke color
    strokeOpacity: 0.8, // Stroke opacity
    strokeWeight: 2, // Stroke weight
    center: marker.getPosition() // Center the circle around the marker
  });
circles.push(circle);
	        })//.then
	        .catch((error) => {
	        	//console.log('in else catch: ' );
	     //   	var defaultLocation = {lat: 13.529271965260616, lng: 75.36285138756304};
	    //    	sendDefaultLocation(defaultLocation);
	      //      console.error("Geolocation is not supported by this browser.");
	      
	          console.error('Error:', error);
	        });
	    }
	 // 	 $('#adcards').append(ad_card);
	    // Get and send location data when the page is loaded
	   getLocation();
	  
	/*   function watchLocation() {
		   if (navigator.geolocation) 
		   { navigator.geolocation.watchPosition(updateLocation, showError, { maximumAge: 0, timeout: 60000 });
}
		   else { alert("Geolocation is not supported by this browser."); } }
	   }
	     setInterval(currentLocationsetcheck, 30000);
	 function updateLocation(position) 
	 { 
		 var lat = position.coords.latitude; 	 
	    var lon = position.coords.longitude; 
	     var accuracy = position.coords.accuracy;
	 }*/
	 setInterval(currentLocationsetcheck, 30000);
	    function  currentLocationsetcheck(){
	   	   locationset++;  
	     	if(currentLocationset==true)  // Set variable to true after 2 seconds
	       
	      { //$("#locationflag").html('Current Location Set : ' +locationset );       	       
	       getLocationContinuous();}     
	       
	       else
	     	  {
	     	      	  $("#locationflag").html('Current Location Not Set : ' +locationset );
	     	  }
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
	   	      var dist=getDistanceFromLatLonInKm(lastlat,lastlng,lat,lng).toFixed(1);
	   	    //  console.log('dist: ' +dist);
	   	    //  console.log('lastlat: ' +lastlat +'lastlng: ' +lastlng);
	   	    //  console.log('currentlat: ' +lat +'currentlng: ' +lng);
	   	  	//var defaultLocation = { coords: { latitude: 13.529271965260616,  longitude: 75.36285138756304 } };
	   	  	 var detectLocation = { coords: {latitude: position.coords.latitude, longitude: position.coords.longitude} };
	   	      if(dist>0.2)
	   	    	  {
	   	    	 // console.log('distance : ' +dist);		    	  
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
	   //	   console.log('in send location detect' +position.coords.latitude);
	   	   //sendLocation(position);
	   	   var lat = position.coords.latitude;
	   	   var lng = position.coords.longitude;
	   	   var k = 0;
    	 
	      var results =0;
	      $.ajax({
	          // Our sample url to make request 
	          url:"${pageContext.request.contextPath}/currentlocation",
	          type: "POST",
	          contentType : 'application/json',
	          dataType : 'json',
	          data:JSON.stringify({lat,lng}), 
	          success: function (data) {
	              let x = JSON.stringify(data);   
	             // console.log(x);
	                 document.getElementById("adcards").innerHTML = "";
	             for (var i = 0; i < markers.length; i++) {
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
	     
	     var newLocation = {lat,lng}; // 
	     map.setCenter(newLocation); 
	     map.setZoom(12); //
	              $.each(data, function (i, myList) {
	              	
	              	  var adsid = myList.id;
	       	     	 var phno = myList.phoneNumber;
	       	     	// console.log('phno : ' +phno);
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
	  	    	var thumbnail = myList.a.thumbnail;
	  	    	//console.log('companyLogoUrl: ' +companyLogoUrl);
	  	    	var banner1="nopreview.jpg";
	  	    	var banner2 = "nopreview.jpg";
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
	  	     	 var carouselid= 'myCarousel'+k;
	     	   var ad_card=	'<div class="panel panel-default "   role = "button"     >'
	     	     	 +'<div class="panel-heading" id ="panelhead">'
	     	     	 +'  <img src="<c:url value="'+companyLogoUrl+'" />"  alt="User profile" style="width: 37px;height: 39px;" class="spotlightimg" />' 
	     	     	 +'  <div id="frame20"><h5 id="publishername">'+companyName+' </h5><div id ="publisherdate">'+formattedDate+'</div></div>'
	     	     	 +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
	     	     	 +'<div><svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 40 40" fill="none"> <path d="M11.5 28.6801V10H28V28.7634L20.1668 21.7548L19.4817 21.1418L18.8134 21.773L11.5 28.6801Z" stroke="black" stroke-width="2"/></svg></div>'
	     	     	 + '</div>'
	     	     	 +'<div class="panel-body" style = "display:flex;flex-direction:row;">'
	  	     	 +'<div class="carousel-container">'   	     	 
	     	     	 
	     	     	 +'<div id="'+carouselid+'" class="carousel slide" data-ride="carousel">'
	     	     	 +'<ol class="carousel-indicators"><li data-target="#'+carouselid+'" data-slide-to="0" class="active"></li><li data-target="#'+carouselid+'" data-slide-to="1"></li><li data-target="#'+carouselid+'" data-slide-to="2"></li></ol>'
	                  +'<div class="carousel-inner"><div class="item active"><img src="<c:url value="'+thumbnail+'" />" alt="Los Angeles" style ="height:200px;width:200px;border-bottom-left-radius:20px;"></div>'
	                  +'<div class="item"><img src="<c:url value="'+thumbnail+'" />" alt="Chicago" style ="height:200px;width:200px;border-bottom-left-radius:20px;"></div><div class="item"><img src="<c:url value="'+thumbnail+'" />" alt="New York" style ="height:200px;width:200px;border-bottom-left-radius:20px;"></div></div>'
	                  +' <a class="left carousel-control" href="#'+carouselid+'" data-slide="prev"><span class="glyphicon glyphicon-chevron-left"></span><span class="sr-only">Previous</span></a>'
	                  +' <a class="right carousel-control" href="#'+carouselid+'" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span><span class="sr-only">Next</span></a></div>'
	                  +'</div>'
	                  +'<div class= "textcontainer" id = '+adsid+' onclick=nextui(this); > <p style="color: #000;font-family: Inter;font-size: 18px;font-style: normal;font-weight: 700;line-height: normal;align-self: stretch;">'+publisher_name+'</p><p class="description">'+description+'<h5 class="expires"> Expires on '+dates+'</h5>'
	                  +'  <div class ="button-group"><button style = "outline: none;background-color: white;border: none;" onclick=phone('+phno+');>  <i class="fa fa-phone" aria-hidden="true"></i></button>'
	                  +'<button style = "outline: none;background-color: white;border: none;" onclick=whatsapp('+phno+');><i class="fa fa-whatsapp" aria-hidden="true"></i></button><button style = "outline: none;background-color: white;border: none;"><i class="fa fa-envelope"></i></button>'
	                  +'<button type="button" class="btn btn-default" id = "takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+');><i class="fa fa-map-marker" aria-hidden="true" style = "font-size:17px;color: #F27C0A;">&nbsp;Take me there</i></button></div>';

	     	     	 $('#adcards').append(ad_card); 
	     	 //  console.log('ad_card: '+ad_card);
	     	        var  latt = 13.529271965260616;
	  	        var lngg = 75.36285138756304; 
	  	      
	   /*  var dist=getDistanceFromLatLonInKm(myList.location.lat,myList.location.lng,lat,lng).toFixed(1);
	     //console.log('dist value is :' +dist);   
	     if(dist<=1.3)
	     	{}*/	
	  	   locations.push(  [myList.location.lat,myList.location.lng,publisher_name,publisher_name]);
	     	
	     	 results++;
	     	        	  }); //.each
	  //for map from here
	  var zoom_val=0;

	  var infowindow = new google.maps.InfoWindow();

	  //var marker, i ,png;
	  png='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
	  for (i = 0; i < locations.length; i++) {		 
	      		marker = new google.maps.Marker({
	      	        position: new google.maps.LatLng(locations[i][0], locations[i][1]),
	      	        map: map,
	      	        icon:png
	      	      });
	      		map.setZoom(12);
	              map.panTo(marker.position);    	
	      	      google.maps.event.addListener(marker, 'mouseover', (function(marker, i) {
	      	        return function() {
	      	         // infowindow.setContent('<b>Name:</b>&nbsp;'+ locations[i][2]+'.<br>'+'<b>:</b>&nbsp;'+ locations[i][3]+'<b>dist:</b>&nbsp;'+locations[i][4]);
	      	          infowindow.setContent('<b>Name:</b>&nbsp;'+ locations[i][2]);
	      	          infowindow.open(map, marker);
	      	        }
	      	      })(marker, i));
	      	      markers.push(marker);
	      	      
	  }
	  if(locations.length>0){
	  	//console.log('length of markers array : ' +locations.length);
	  const circle = new google.maps.Circle({
	      map: map,
	      radius: 2600, // Radius in meters
	      fillColor: '#FFF', // Red fill color
	      fillOpacity: 0.35, // Fill opacity
	      strokeColor: '#F27C0A', // Red stroke color
	      strokeOpacity: 0.8, // Stroke opacity
	      strokeWeight: 2, // Stroke weight
	      center: marker.getPosition() // Center the circle around the marker
	    });      

	  circles.push(circle);
	  }

	  displayCurrentLocation(lat, lng);
	  $('#results').html('Results: ' +results);
	          },

	          // Error handling 
	          error: function (error) {
	              console.log(`Error ${error}`);
	          }
	      });

	   	   
	   	   
	   	   
	    }
	});//dom
        // Get the location as soon as the page is loaded
      //  window.onload = getLocation;

function getDistanceFromLatLonInKm(lat1,lon1,lat2,lon2) {
//	console.log('inside distance calculator: '+lat2+'Longi: '+lon2);
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

		var mob;
		document.getElementById('profiledr').addEventListener('click', function() {
			console.log('initial value of mob'+ mob);
			
			 $.ajax({
	                url: '${pageContext.request.contextPath}/getSessionVariable',
	                method: 'GET',
	                async:false,
	                success: function(data) {
	                 //   alert(data); // Outputs the session variable value
	                 console.log('in success');
	                 mob=data;
	            	 getsessionvalue(mob);
	                },
	                error: function(xhr, status, error) {
	                    console.error("Error fetching session variable: ", error);
	                }
	            });
		
			
		});
		function getsessionvalue(mob)
		{
			console.log('value of mob in fn: '+mob);
			if(mob=="")
				{
		     document.getElementById('profiledrop').style.display = 'block';
			 document.getElementById('profiledrop').style.zIndex = 18;
			 document.getElementById('col-md-4').style.zIndex=-18;
			/*	document.getElementById('profiledrop').style.display = 'block';
				document.getElementById('profiledrop').style.position = 'absolute';*/
				}
			else
				{
				 document.getElementById('loginsuccess').style.display = 'block';
				 document.getElementById('loginsuccess').style.zIndex = 18;
				 document.getElementById('col-md-4').style.zIndex=-18;
				}
		}
		
		document.getElementById('closeButtonheader').addEventListener('click', function() {
			
		//	console.log('hmm');
			  document.getElementById('profiledrop').style.display = 'none';
			  document.getElementById('profiledrop').style.zIndex=-18;
			 document.getElementById('col-md-4').style.zIndex=18;
			 
			
		   //  const dropdown = document.getElementById('component2');
		  //  const isDropdownVisible = dropdown.style.display === 'none';
		//	  $('.component2').hide();
			
	/*	  const box1 = document.querySelector('.dropdown-content');
    const box2 = document.querySelector('.col-md-4');

    // Get current z-index values
    const zIndex1 = parseInt(window.getComputedStyle(box1).zIndex);
    const zIndex2 = parseInt(window.getComputedStyle(box2).zIndex);
    console.log(+zIndex1+ ' '+zIndex2);
    // Swap z-index values
    box1.style.zIndex = zIndex2; // Set box1's z-index to box2's current z-index
    box2.style.zIndex = zIndex1; // Set box2's z-index to box1's current z-index*/
		});

		
		
		$('#sendotp').click(function()
		{
			var mobilenumber = $('#mobilenumber').val();
			//console.log('mobile number  is : ' + mobilenumber);
		//	clearInterval(countdown); // Clear any existing countdown
		  //  timerDisplay.textContent = ""; // Clear previous timer display
		  //  resendBtn.style.display = 'none'; // Hide the resend button
		  //  startCountdown(60);
			
			$.post("${pageContext.request.contextPath}/sendOtp.htm", {
				
				mobilenumber : mobilenumber,	
		}, function(data) {
		}).done(function(data) {
			//			console.log('Otp is data : '+ data);
			const myDiv = document.getElementById('otpno');
			 myDiv.innerHTML = data;
			//$('#otpno').val(data);
			$('#profiledroplogin').show();
			$('#profiledrop').hide();
			document.getElementById('profiledrop').style.zIndex = -18;
			 document.getElementById('profiledroplogin').style.zIndex = 18;
			 //document.getElementById('col-md-4').style.zIndex=-18;
			let countdown;
const timerDisplay = document.getElementById('countdown');
const resendBtn = document.getElementById('resend');

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
			
		});
		
		
		$('#closeButtonlogin').click(function()
		{
		document.getElementById('profiledroplogin').style.display = 'none';
		document.getElementById('profiledroplogin').style.zIndex = -18;
		document.getElementById('col-md-4').style.zIndex=18;
		});
		
		$('#loginotp').click(function()
		{
			var mobilenumber = $('#mobilenumber').val();
		//	const myDiv = document.getElementById('phonemobilenumberotp');
			const myDiv = document.getElementById('otpnumber');
		//	var otp =  myDiv.innerHTML ;
		//	var otp =  myDiv.val();
			//var otp = $('#otpno').val();
		var otp =	$('#otpnumber').val();
			console.log('entered otp: ' +otp);
			document.getElementById('profiledroplogin').style.display = 'none';
			 document.getElementById('profiledroplogin').style.zIndex = -18;
			 document.getElementById('col-md-4').style.zIndex=18;
			 $.post("${pageContext.request.contextPath}/verifyOtp.htm", {
					
					mobilenumber : mobilenumber,	
					otp:otp,
					
			}, function(data) {
			}).done(function(data) {
				
			}).fail(function(xhr, textStatus, errorThrown) {
				
			})
			
		});
		
		function takeme(lats,lngs)
		{
			console.log(lats+'and :'+lngs);
			 event.stopPropagation();
			console.log(takemelat+'current loc :'+takemelng);
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
           console.log('destination lat : ' +destinationLat  +'deatination lng: ' +destinationLng);
           console.log('original lat :  ' +originLat +'original lng: ' +originLng);
           const url = 'https://www.google.com/maps/dir/?api=1&origin='+originLat+','+originLng+'&destination='+destinationLat+','+destinationLng+'&travelmode=driving';
            window.open(url, '_blank');
		}
		function phone(phno)
		{
			//console.log('phone number is : '+phno);
			//console.log('value of mob on phone click: ' +mob);
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
			$('#myModalforphone').modal('show');
				}
			else
				{
			    const div = document.getElementById('callme');
			    div.textContent = phno;
				$('#showphno').modal('show');			
				}			
		}	
		
		$('#phonesendotp').click(function()
				{
			
	var mobilenumber = 		$('#phonemobilenumber').val();
		$.post("${pageContext.request.contextPath}/sendOtp.htm", {
			
			mobilenumber : mobilenumber,	
	}, function(data) {
	}).done(function(data) {
		//			console.log('Otp is data : '+ data);
		/*const myDiv = document.getElementById('phoneotpno');
		 myDiv.innerHTML = data;*/
		//$('#otpno').val(data);
		 $('#myModalforphone').modal('hide');
		$('#myModalforphoneenterotp').modal('show');
		const myDiv = document.getElementById('photpno');
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

				});//phone send otp
		
				$('#phonesendotpp').click(function()
						{			
							var mobilenumber = $('#phonemobilenumber').val();
												
							const myDiv = document.getElementById('phonemobilenumberotp');
							var otp =  $('#phonemobilenumberotp').val() ;
							
							 $.post("${pageContext.request.contextPath}/verifyOtp.htm", {
									
									mobilenumber : mobilenumber,	
									otp:otp,
									
							}, function(data) {
							}).done(function(data) {
								$('#myModalforphoneenterotp').modal('hide');
							}).fail(function(xhr, textStatus, errorThrown) {
								
							})
							
						});
							
				var span = document.getElementById("closeButtonheaderphone");
				span.onclick = function() { 
					
			
					//modal.style.display = "none"; 
					$('#myModalforphone').modal('hide');
					}
				
			
				var cl = document.getElementById("phonecloseButtonheaderotp");
				cl.onclick = function() { 
			
					$('#myModalforphoneenterotp').modal('hide');
					}
							function whatsapp(phno)
							{
								
							    event.stopPropagation(); 
							if(mob=="")
								{
								$('#myModalforphone').modal('show');
								}
							else{						
					           	 var whatsappUrl = 'https://wa.me/' + phno;
					             window.open(whatsappUrl, '_blank');
					                    	  }
					                   
							}
							 
							 function nextui(element)
							 {
								 const buttonId = element.id;
							 //console.log('in nextui');
							 console.log(buttonId);			
							 $.ajax({
					                url: '${pageContext.request.contextPath}/adDetails',
					                method: 'POST',
					                async:false,
					                data:{buttonId:buttonId},
					                success: function(response) {
					                  console.log(response); 
					                  
					                  window.location.href = "/adDetailsview?data=";
					                },
					                error: function(xhr, status, error) {
					                   
					                }
					            });
							 	 }
							 
							 
							 
$('.spotlightitem').on('click', function() {					             
var y =  $(this).attr('id') ;
var x = $(this).val();
var z = $(this).usrphno;
console.log('y : ' +y);

$.ajax({
    url: '${pageContext.request.contextPath}/aspotlight', // Sample API endpoint
    method: 'POST',
    contentType: 'text/plain',
    data: y,
    success: function(response) {
    	console.log('data : ' +response);
   
    	window.location.href ='${pageContext.request.contextPath}/aspotlightdetail' ;
    }
    
});
});			
//window.onload = watchLocation;
  /* function watchLocation() 
   {
if (navigator.geolocation) 
{ navigator.geolocation.watchPosition(updateLocation, showError, { maximumAge: 0, timeout: 60000 });
}else 
{ console.log('Geolocation is not supported by this browser.'); 
} 
}
//    (currentLocationsetcheck, 30000);
function updateLocation(position) 
{ 
var lat = position.coords.latitude; 	 
var lon = position.coords.longitude; 
var accuracy = position.coords.accuracy;
locationset++;
$("#locationflag").html('Current Location Set : ' +locationset );
console.log('latitude on load when current location is set: ' +lat +'longitude: ' +lon +'accuracy : ' +accuracy);
}
function showError(error) { switch (error.code) { case error.PERMISSION_DENIED: alert("User denied the request for Geolocation."); break; case error.POSITION_UNAVAILABLE: alert("Location information is unavailable."); break; case error.TIMEOUT: alert("The request to get user location timed out."); break; case error.UNKNOWN_ERROR: alert("An unknown error occurred."); break; } }
*/
  // Stop the function from executing (optional) by setting isRunning to false
   </script>  




<jsp:include page="footer.jsp" /> 
</body>
</html>