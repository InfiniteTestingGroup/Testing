<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="org.jackfruit.keliri.model.ad_campaigns" %>
    <%@ page import="java.util.List" %>
    <%@ page import="com.google.gson.Gson" %>
      <%@ taglib prefix="form"  uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  
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
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<title>Keliri</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
     <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
 
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

   <script src="https://maps.googleapis.com/maps/api/js?key=${googleMapsApiKey}&libraries=geometry"></script>
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
     overflow-x: hidden;
     max-width:100%;
}
body {
    min-height: 100%;
     background-color: white;
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
.responsiveheader-container
{
display: flex;
flex-direction: row;
align-items: center;
padding: 15px;
width: 100%;/*360px;*/
height: 72px;
flex: none;
order: 0;
align-self: stretch;
flex-grow: 0;
/*justify-content: space-between;*/gap:15px;overflow-x: hidden;
}
.map-container2
{
display:flex;
flex-direction:row;
justify-content: center;
align-items: center;
/*border-bottom: 1px solid #000;*/
}
.logo-image{width: 20%; /* Adjust the width as needed */ height: auto; /* Maintain aspect ratio */}
#usr{border: none;outline: none;box-shadow: none;}
.bell-icon{position: relative; display: inline-block;}
.badge{position: absolute; top: -10px; right: -5px; background-color: red; color: white;padding: 2px 3px;}
.fa-2x {    font-size: 1.25em;}

.bell-iconmap{position: relative; display: inline-block;}

.modal-header
{
display: flex;flex-direction: row;justify-content: center;align-items: center;
padding: 16px;/*gap: 15px;*/width: 100%;/*360px;*/height: 56px;background: #FFFFFF;
box-shadow: 0px 0px 4px rgba(0, 0, 0, 0.25);backdrop-filter: blur(5px);flex: none;
order: 0;align-self: stretch;flex-grow: 0;z-index: 1;
}
.modal.fullscreen-modal { top: 0; right: 0; bottom: 0; left: 0; position: fixed; overflow: hidden; }

 .modal-dialog.fullscreen-modal-dialog { width: 100%; height: 100%; margin: 0; padding: 0; }
 
  .modal-content.fullscreen-modal-content { height: 100%; border-radius: 0; }
  
  .searchloc{box-sizing: border-box;display: flex;flex-direction: row;justify-content:/* flex-start;*/space-between;align-items: center;
padding: 5px 10px;gap: 10px;width:100%;/*height: 40px;*/border: 1px solid #BDBDBD;border-radius: 10px;flex: none;
order: 0;align-self: stretch;flex-grow: 0;  }

.modal-body{display: flex;flex-direction: column;justify-content: center;align-items: flex-start;padding: 16px;
gap: 6px;width:100%;height: 243px;background: #FFFFFF;flex: none;order: 1;align-self: stretch;flex-grow: 0;z-index: 0;}

.pinloc{display: flex;flex-direction: row;justify-content: center;align-items: center;padding: 0px;gap: 10px;
width:100%;/* 328px;*/flex: none;order: 2;flex-grow: 0;}

#map { height: 350px; width: 100%; }

.search-container{display: flex;flex-direction: row;align-items: center;padding: 0px 12px;gap: 6px;
/*width: 360px;height: 61.74px;*/background: #FFFFFF;flex: none;order: 1;flex-grow: 0;}

.search {box-sizing: border-box;/*display: flex;flex-direction: row;*/justify-content: flex-start;align-items: center;padding:2px 10px;
gap: 10px;/*width: 306px;height: 41.74px;*/border: 1px solid #BDBDBD;border-radius: 10px;flex: none;order: 0;
align-self: stretch;flex-grow: 0;width: 95%;}


@media (max-width: 480px) {
 .responsiveheader-container{
 /*width:90%;*/
 max-width: 100%;
 overflow-x: hidden;
 }
}

@media (min-width: 481px) and (max-width: 768px) {
.responsiveheader-container{
/* width:100%;*/
max-width: 100%;
 overflow-x: hidden;
 }

}

/*from here*/
/*
.roadinactive
{
background:none;
outline:none;
width:20px;border-color: #F27C0A;border: 1px solid #F27C0A;
}

.roadactive
{
   border: none;
    background: #F27C0A;    
    color: white;
    width: 20px;
}
*/

.roadinactive
{
background:none;
outline:none;
width:19%;
border-color: #FFF;border: #FFF;
flex:  0 0 0;/* 0 0 24%; *//*0 1 calc(25% - 16px); /* 4 items per row, minus gap */
box-sizing: border-box;
}

.roadactive
{
  border: none;
  background: none /*#F27C0A*/;    
  /*  color: white;*/
  width: 19%; flex:  0 0 0;
  border-bottom: 2px solid #F27C0A;;
}
.inactivesort
{
background:none;
outline:none;
width:19%;
/*border-color: #F27C0A;border: 1px solid #F27C0A;*/
border-color: #FFF;border: #FFF;
}
.activesort{
	border: none;
    background: #F27C0A;
  
    color: white;
    width: 19%;}
/*from here*/
.giactive
{
background:#F27C0A;
outline:none;
width:19%;border-color: #F27C0A;border: 1px solid #F27C0A;

}
.giinactive{
	border: none;
    background: #F27C0A;  
    color: white;
    width: 19%;
    border-color: #FFF;border: #FFF;     
    }
#currentlocationbutton:disabled img {
    opacity: 0.4;             /* makes image faded */
    filter: grayscale(100%);  /* turns image gray */
    cursor: not-allowed;      /* shows disabled cursor */
  }
   #currentlocationbutton img {
    transition: 0.3s; /* smooth transition when enabling/disabling */
  }
  
  #pinlocationbutton:disabled img {
    opacity: 0.4;             /* makes image faded */
    filter: grayscale(100%);  /* turns image gray */
    cursor: not-allowed;      /* shows disabled cursor */
  }
   #pinlocationbutton img {
    transition: 0.3s; /* smooth transition when enabling/disabling */
  }
</style>
</head>
<body>
<div class="responsiveheader-container">
<div class = "logo-container"  style = "width:35%;">
<!-- <img loading="lazy" src="/logo.png" class="logo-image" alt="Company Logo" /> -->
<img src = "/logo-full.png" style = "width:100%;">

</div>
<div class="map-container">
<div class="map-container2">
<!-- <input type="text" class="form-control" id="usr">-->
<div class = "locationbuttons" style = "display:flex;flex-direction:row;gap:10px;justify-content:space-evenly; align-items:center; width:100%;">
<button style="border:none;outline:none;background:none;flex:1; text-align:center;" id="currentlocationbutton"><img src = "/currentlocation.png" style = "height:25px;"></button>
<div><button style="border:none;outline:none;background:none;flex:1; text-align:center;" id = "pinlocationbutton"><img src = "/google-maps.png" style = "height:25px;"></button></div>

</div>
<button data-toggle="modal" data-target="#myModal" style ="border:none;outline:none;background:none;padding:10px;">
<svg width="9" height="9" viewBox="0 0 9 9" fill="none" xmlns="http://www.w3.org/2000/svg" id = "mapdrop">
<path d="M4.54635 5.75013L7.5645 2.73603C7.5938 2.70657 7.62871 2.6833 7.66717 2.66758C7.70563 2.65187 7.74685 2.64403 7.78839 2.64453C7.82993 2.64504 7.87095 2.65387 7.90902 2.67051C7.94708 2.68716 7.98142 2.71127 8.01 2.74143C8.06855 2.8031 8.10074 2.88518 8.09973 2.97022C8.09872 3.05526 8.0646 3.13655 8.0046 3.19683L4.76325 6.43368C4.73417 6.46296 4.69954 6.48615 4.66139 6.50189C4.62324 6.51763 4.58233 6.52561 4.54106 6.52536C4.49979 6.52511 4.45898 6.51663 4.42103 6.50043C4.38307 6.48422 4.34873 6.46061 4.32 6.43098L0.992251 3.02403C0.933356 2.96303 0.90044 2.88156 0.90044 2.79678C0.90044 2.71199 0.933356 2.63052 0.992251 2.56953C1.02119 2.53972 1.05582 2.51603 1.09408 2.49986C1.13234 2.48368 1.17346 2.47534 1.215 2.47534C1.25654 2.47534 1.29766 2.48368 1.33592 2.49986C1.37418 2.51603 1.40881 2.53972 1.43775 2.56953L4.54635 5.75013Z" fill="black"/>
</svg>
</button>
</div><!-- map-container2 -->
</div>
 <div class="bell-icon" style ="display: flex;    flex-direction: row;    gap: 5px;">
 <!-- <i class="fa fa-bell-o fa-2x"></i> <span class="badge">5</span> -->
 <!-- <button id ="road" class="roadinactive"> <span class="glyphicon glyphicon-road"></span>  </button>-->
 
 
<!--  <button id ="distance" class="activesort"><span class="glyphicon glyphicon-resize-vertical"></span>  </button>
   <button id ="time" class="inactivesort"> <i class="material-icons" style="font-size:18px">access_time</i>  </button>
   <button id ="road" class="roadinactive"> <span class="glyphicon glyphicon-road"></span>  </button>
   <button id = "gi" class="roadinactive" onclick="giads()"><img src="gitagicon2.png" style = "width: 20px;   border: none;
   /*border-color: #F27C0A;border: 1px solid #F27C0A;*/border-color: #FFF;border: #FFF;outline: none;background: #F27C0A;height: 25px;"></button> -->
   
   <button style = "background: none; outline: none;    border: none;" id = "menuicon"><img src = "menu-icon.png"></button>
</div>
<button id = "vlogs" onclick = "vlogs()" class="roadinactive" ><img src= "vlogs.png" style = "width:20px;"></button>
<button id = "news" onclick = "news()"  class="roadinactive" ><img src = "news.png" style = "width:20px;"></button>
<div class="search-button-container">
<button style ="border:none;outline:none;background: none;" id = "searchbutton1">
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


</div> <!-- responsive container -->




<div class="search-container">
<div class="search">
<div id = "inputtypes" style ="display:flex;flex-direction:row;gap:10px;">
<input type ="text" style ="border: none;outline: none;width: 70%;" placeholder="Search" id ="searchinput">
<button style ="border:none;background:none;outline:none;"><svg width="19" height="19" viewBox="0 0 19 19" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_50_3976)">
<path d="M9.05859 7.05774C8.31267 7.05774 7.5973 7.35406 7.06986 7.8815C6.54241 8.40895 6.24609 9.12432 6.24609 9.87024C6.24609 10.6162 6.54241 11.3315 7.06986 11.859C7.5973 12.3864 8.31267 12.6827 9.05859 12.6827C9.80452 12.6827 10.5199 12.3864 11.0473 11.859C11.5748 11.3315 11.8711 10.6162 11.8711 9.87024C11.8711 9.12432 11.5748 8.40895 11.0473 7.8815C10.5199 7.35406 9.80452 7.05774 9.05859 7.05774Z" fill="black"/>
<path fill-rule="evenodd" clip-rule="evenodd" d="M9.05859 1.80774C9.20778 1.80774 9.35085 1.867 9.45634 1.97249C9.56183 2.07798 9.62109 2.22105 9.62109 2.37024V3.33174C11.1615 3.46452 12.6055 4.13678 13.6988 5.23004C14.792 6.32329 15.4643 7.76736 15.5971 9.30774H16.5586C16.7078 9.30774 16.8509 9.367 16.9563 9.47249C17.0618 9.57798 17.1211 9.72106 17.1211 9.87024C17.1211 10.0194 17.0618 10.1625 16.9563 10.268C16.8509 10.3735 16.7078 10.4327 16.5586 10.4327H15.5971C15.4643 11.9731 14.792 13.4172 13.6988 14.5104C12.6055 15.6037 11.1615 16.276 9.62109 16.4087V17.3702C9.62109 17.5194 9.56183 17.6625 9.45634 17.768C9.35085 17.8735 9.20778 17.9327 9.05859 17.9327C8.90941 17.9327 8.76634 17.8735 8.66085 17.768C8.55536 17.6625 8.49609 17.5194 8.49609 17.3702V16.4087C6.95571 16.276 5.51164 15.6037 4.41839 14.5104C3.32514 13.4172 2.65288 11.9731 2.52009 10.4327H1.55859C1.40941 10.4327 1.26634 10.3735 1.16085 10.268C1.05536 10.1625 0.996094 10.0194 0.996094 9.87024C0.996094 9.72106 1.05536 9.57798 1.16085 9.47249C1.26634 9.367 1.40941 9.30774 1.55859 9.30774H2.52009C2.65288 7.76736 3.32514 6.32329 4.41839 5.23004C5.51164 4.13678 6.95571 3.46452 8.49609 3.33174V2.37024C8.49609 2.22105 8.55536 2.07798 8.66085 1.97249C8.76634 1.867 8.90941 1.80774 9.05859 1.80774ZM3.62109 9.87024C3.62109 10.5843 3.76174 11.2914 4.035 11.9511C4.30826 12.6108 4.70878 13.2102 5.2137 13.7151C5.71862 14.2201 6.31804 14.6206 6.97775 14.8938C7.63746 15.1671 8.34453 15.3077 9.05859 15.3077C9.77266 15.3077 10.4797 15.1671 11.1394 14.8938C11.7991 14.6206 12.3986 14.2201 12.9035 13.7151C13.4084 13.2102 13.8089 12.6108 14.0822 11.9511C14.3554 11.2914 14.4961 10.5843 14.4961 9.87024C14.4961 8.42812 13.9232 7.04508 12.9035 6.02535C11.8838 5.00562 10.5007 4.43274 9.05859 4.43274C7.61648 4.43274 6.23343 5.00562 5.2137 6.02535C4.19397 7.04508 3.62109 8.42812 3.62109 9.87024Z" fill="black"/>
</g>
<defs>
<clipPath id="clip0_50_3976">
<rect width="18" height="18" fill="white" transform="translate(0.0585938 0.870239)"/>
</clipPath>
</defs>
</svg></button>
<button style ="border:none;background:none;outline:none;">
<svg width="25" height="25" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect x="0.0585938" width="31.9414" height="31.7406" rx="15.8703" fill="#F5F5F5"/>
<path d="M18.5146 16.0774C18.5146 16.7915 18.2528 17.4763 17.7867 17.9813C17.3206 18.4862 16.6885 18.7699 16.0293 18.7699C15.3701 18.7699 14.738 18.4862 14.2719 17.9813C13.8058 17.4763 13.5439 16.7915 13.5439 16.0774V10.6925C13.5439 9.97838 13.8058 9.29354 14.2719 8.7886C14.738 8.28367 15.3701 8 16.0293 8C16.6885 8 17.3206 8.28367 17.7867 8.7886C18.2528 9.29354 18.5146 9.97838 18.5146 10.6925V16.0774Z" stroke="black" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M21 16.285C21 19.0249 18.7747 21.2466 16.0293 21.2466M16.0293 21.2466C13.2839 21.2466 11.0586 19.0249 11.0586 16.2845M16.0293 21.2466V23.7406" stroke="black" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
</button>
<button style ="border:none;background:none;outline:none;" id = "searchmagnifier">
<svg width="25" height="25" viewBox="0 0 30 31" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect y="0.870239" width="30" height="30" rx="15" fill="url(#paint0_linear_50_3949)"/>
<path d="M20.25 21.1202L17.7166 18.5868M17.7166 18.5868C18.1499 18.1535 18.4937 17.639 18.7282 17.0728C18.9627 16.5066 19.0835 15.8998 19.0835 15.2869C19.0835 14.6741 18.9627 14.0672 18.7282 13.501C18.4937 12.9348 18.1499 12.4203 17.7166 11.987C17.2832 11.5536 16.7688 11.2099 16.2026 10.9754C15.6364 10.7408 15.0295 10.6201 14.4167 10.6201C13.8038 10.6201 13.197 10.7408 12.6308 10.9754C12.0646 11.2099 11.5501 11.5536 11.1167 11.987C10.2416 12.8622 9.74988 14.0492 9.74988 15.2869C9.74988 16.5246 10.2416 17.7116 11.1167 18.5868C11.9919 19.462 13.179 19.9537 14.4167 19.9537C15.6544 19.9537 16.8414 19.462 17.7166 18.5868Z" stroke="white" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
<defs>
<linearGradient id="paint0_linear_50_3949" x1="0" y1="15.8702" x2="30" y2="15.8702" gradientUnits="userSpaceOnUse">
<stop stop-color="#F27C0A"/>
<stop offset="1" stop-color="#F2382C"/>
</linearGradient>
</defs>
</svg>
</button>

</div>

</div>

<div><button style ="border:none;outline:none;background:none;" id = "searchclose"><i class="fa fa-remove"></i></button></div>

</div><!-- search-container -->

<!--modal start here -->
<div id="myModal" class="modal fullscreen-modal" role="dialog">
  <div class="modal-dialog fullscreen-modal-dialog">

    <!-- Modal content-->
    <div class="modal-content fullscreen-modal-content">
      <div class="modal-header" >
     <button style ="border:none;outline:none;" data-dismiss="modal"> <svg width="12" height="24" viewBox="0 0 12 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M10 19.438L8.95502 20.5L1.28902 12.71C1.10452 12.5197 1.00134 12.2651 1.00134 12C1.00134 11.7349 1.10452 11.4803 1.28902 11.29L8.95502 3.5L10 4.563L2.68202 12L10 19.438Z" fill="black"/>
</svg></button>  
        <h4 class="modal-title" style ="width: 262px;height: 17px;font-family: 'Inter';font-style: normal;font-weight: 700;
font-size: 14px;line-height: 17px;text-align: center;color: #000000;flex: none;/*order: 1;*/flex-grow: 1;">Choose Location </h4>
  <!--       <div class="bell-iconmap">
 <i class="fa fa-bell-o fa-2x"></i> <span class="badge">5</span> 
</div>-->
      </div>
      <div class="modal-body">
        <div class="searchloc">
        <input type ="text" placeholder="Search your location" style = "border:none;outline:none;background:none;" id = "searchlocationinput">
         <button style ="border:none;background:none;outline:none;" id = "searchmagnifierlocation" type = "button">
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
        <div class = "currentloc" style = "display: flex;flex-direction: row;justify-content: flex-start;align-items: center;padding: 0px;
gap: 10px;width: 100%;/*height: 35px;*/flex: none;order: 0;flex-grow: 0;">
        <svg width="18" height="17" viewBox="0 0 18 17" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M9 0.4375C9.14918 0.4375 9.29226 0.496763 9.39775 0.602252C9.50324 0.707742 9.5625 0.850816 9.5625 1V1.9615C11.1029 2.09429 12.547 2.76655 13.6402 3.8598C14.7335 4.95305 15.4057 6.39712 15.5385 7.9375H16.5C16.6492 7.9375 16.7923 7.99676 16.8977 8.10225C17.0032 8.20774 17.0625 8.35082 17.0625 8.5C17.0625 8.64918 17.0032 8.79226 16.8977 8.89775C16.7923 9.00324 16.6492 9.0625 16.5 9.0625H15.5385C15.4057 10.6029 14.7335 12.047 13.6402 13.1402C12.547 14.2335 11.1029 14.9057 9.5625 15.0385V16C9.5625 16.1492 9.50324 16.2923 9.39775 16.3977C9.29226 16.5032 9.14918 16.5625 9 16.5625C8.85082 16.5625 8.70774 16.5032 8.60225 16.3977C8.49676 16.2923 8.4375 16.1492 8.4375 16V15.0385C6.89712 14.9057 5.45305 14.2335 4.3598 13.1402C3.26655 12.047 2.59429 10.6029 2.4615 9.0625H1.5C1.35082 9.0625 1.20774 9.00324 1.10225 8.89775C0.996763 8.79226 0.9375 8.64918 0.9375 8.5C0.9375 8.35082 0.996763 8.20774 1.10225 8.10225C1.20774 7.99676 1.35082 7.9375 1.5 7.9375H2.4615C2.59429 6.39712 3.26655 4.95305 4.3598 3.8598C5.45305 2.76655 6.89712 2.09429 8.4375 1.9615V1C8.4375 0.850816 8.49676 0.707742 8.60225 0.602252C8.70774 0.496763 8.85082 0.4375 9 0.4375ZM3.5625 8.5C3.5625 9.21406 3.70315 9.92113 3.9764 10.5808C4.24966 11.2405 4.65019 11.84 5.15511 12.3449C5.66003 12.8498 6.25945 13.2503 6.91916 13.5236C7.57887 13.7969 8.28594 13.9375 9 13.9375C9.71406 13.9375 10.4211 13.7969 11.0808 13.5236C11.7405 13.2503 12.34 12.8498 12.8449 12.3449C13.3498 11.84 13.7503 11.2405 14.0236 10.5808C14.2969 9.92113 14.4375 9.21406 14.4375 8.5C14.4375 7.05789 13.8646 5.67484 12.8449 4.65511C11.8252 3.63538 10.4421 3.0625 9 3.0625C7.55789 3.0625 6.17484 3.63538 5.15511 4.65511C4.13538 5.67484 3.5625 7.05789 3.5625 8.5Z" fill="black"/>
</svg>
<div style ="display: flex;flex-direction: column;align-items: flex-start;padding: 0px;gap: 0px;/*width: 179px;height: 35px;*/flex: none;
/*order: 1;*/flex-grow: 1;">
<p style ="font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">Detect Current Location</p>
<p style ="font-family: 'Inter';font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">Using GPS</p>
</div>
<div>
<button style = "display: flex;flex-direction: row;justify-content: center;align-items: center;padding: 5px 10px;
gap: 5px;/*width:100%;/*99px*//*;height: 26px;*/border: 1px solid #BBBBBB;border-radius: 5px;flex: none;border: 2;flex-grow: 0;background:none;outline:none;" onclick="getCurrentLocations()" data-dismiss="modal">Set Location
<svg width="9" height="9" viewBox="0 0 9 9" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M7.8313 0.454732C7.8063 0.179724 7.5631 -0.0229473 7.28809 0.00205338L2.80657 0.409464C2.53156 0.434465 2.32889 0.67767 2.35389 0.952678C2.37889 1.22769 2.6221 1.43036 2.8971 1.40536L6.88068 1.04321L7.24282 5.02679C7.26782 5.3018 7.51102 5.50447 7.78603 5.47947C8.06104 5.45447 8.26371 5.21126 8.23871 4.93625L7.8313 0.454732ZM1.0508 8.82009L7.71747 0.820092L6.94924 0.179908L0.282576 8.17991L1.0508 8.82009Z" fill="black"/>
</svg>


</button>
</div>
        
        </div><!-- currentloc -->
        <div><p style ="text-align:center;">OR</div>
        <div class= "pinloc">
       <svg width="18" height="21" viewBox="0 0 18 21" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M9.00001 21L2.67301 13.5382C2.58509 13.4262 2.49809 13.3135 2.41201 13.2C1.33179 11.776 0.747994 10.0373 0.750005 8.25C0.750005 6.06196 1.6192 3.96354 3.16637 2.41637C4.71355 0.869194 6.81197 0 9.00001 0C11.188 0 13.2865 0.869194 14.8336 2.41637C16.3808 3.96354 17.25 6.06196 17.25 8.25C17.2517 10.0365 16.6682 11.7743 15.5888 13.1978L15.588 13.2C15.588 13.2 15.363 13.4955 15.3293 13.5353L9.00001 21ZM3.60976 12.2963C3.60976 12.2963 3.78451 12.5272 3.82426 12.5767L9.00001 18.681L14.1825 12.5685C14.2155 12.5272 14.391 12.2948 14.3918 12.294C15.2747 11.1309 15.7518 9.71028 15.75 8.25C15.75 6.45979 15.0388 4.7429 13.773 3.47703C12.5071 2.21116 10.7902 1.5 9.00001 1.5C7.20979 1.5 5.49291 2.21116 4.22703 3.47703C2.96116 4.7429 2.25001 6.45979 2.25001 8.25C2.24815 9.71122 2.72584 11.1327 3.60976 12.2963Z" fill="#FF3636"/>
</svg>

        <div style ="display: flex;flex-direction: column;align-items: flex-start;padding: 0px;gap: 0px;
/*width: 100%;*//*185px;*//*height: 35px;*/flex: none;/*order: 1;*/flex-grow: 1;">
        <p style ="font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;"> Set Location Manually </p>
        <p style ="font-family: 'Inter';font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">Move to your location </p>  
          </div>
           <button style = "display: flex;flex-direction: row;justify-content: center;align-items: center;padding: 5px 10px;
gap: 5px;/*width:100%;/*99px*/;height: 26px;border: 1px solid #BBBBBB;border-radius: 5px;flex: none;border: 2;flex-grow: 0;background:none;outline:none;" id = "setlocation" data-dismiss="modal">Set Location
<svg width="9" height="9" viewBox="0 0 9 9" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M7.8313 0.454732C7.8063 0.179724 7.5631 -0.0229473 7.28809 0.00205338L2.80657 0.409464C2.53156 0.434465 2.32889 0.67767 2.35389 0.952678C2.37889 1.22769 2.6221 1.43036 2.8971 1.40536L6.88068 1.04321L7.24282 5.02679C7.26782 5.3018 7.51102 5.50447 7.78603 5.47947C8.06104 5.45447 8.26371 5.21126 8.23871 4.93625L7.8313 0.454732ZM1.0508 8.82009L7.71747 0.820092L6.94924 0.179908L0.282576 8.17991L1.0508 8.82009Z" fill="black"/>
</svg>
</button>
        </div>
      </div>
      <div class="modal-footer">
        <div id="map"></div>
      </div>
    </div>

  </div>
</div>
<!-- modal end here --> 
<!-- bottom sheet start -->


<!-- bottom sheet end -->


<!-- vertical start -->

<div class="dropdown-menu-dots" id="dropdownMenu"
style ="display:none;position: absolute;  background-color: #f9f9f9;  min-width: 160px;  box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);  z-index: 1;/*margin-top: 46%;*/margin-top: 0;
    margin-left: 24%;    margin-right: 17%;  ">
<div style="padding: 10px; /*flex-direction: row;*/    display: flex;    flex-wrap: wrap;    gap: 14px;    justify-content: space-between;">
     <button id ="distance" class="activesort"><span class="glyphicon glyphicon-resize-vertical"></span>  </button>
   <button id ="time" class="inactivesort"> <i class="material-icons" style="font-size:18px">access_time</i>  </button>
   <button id ="road" class="roadinactive"> <span class="glyphicon glyphicon-road"></span>  </button>
   <button id = "gi" class="roadinactive" onclick="giads()" style ="width:30px;height: 35px;"><img src="gitagicon3.png" style = "width: 23px;   border: none;
   /*border-color: #F27C0A;border: 1px solid #F27C0A;*/border-color: #FFF;border: #FFF;outline: none;/*background: #F27C0A;*/height: 25px;"></button>
   
  <button id="temple" class="roadinactive" onclick="templeads()" style = "width:35px;"><img src ="/temple.png" style ="height: 23px;    width: 30px;"></button>
  <button id = "forest" class = "roadinactive" style = "width:35px;" onclick = "forestads()"><img src = "/national-park.png" style ="height: 28px;    width: 28px;"></button>
  <button id = "heritage" class = "roadinactive" style = "width:35px;" onclick = "heritageads()"><img src = "/hampiheritage4.jpg" style ="height: 28px;    width: 28px;border-radius: 50%;"></button>
    <button id = "hospital" class = "roadinactive" style = "width:35px;" onclick = "hospitalads()"><img src = "/hospital.png" style ="height: 28px;    width: 28px;"></button>
  <button id = "bus" class = "roadinactive" style = "width:35px;" onclick = "busads()"><img src = "/bus.png" style ="height: 28px;    width: 28px;"></button>
  <button id = "car" class = "roadinactive" style = "width:35px;" onclick = "carads()"><img src = "/car.png" style ="height: 28px;    width: 28px;"></button>
  <button id = "rickshaw" class = "roadinactive" style = "width:35px;" onclick = "rickshawads()"><img src = "/rickshaw.png" style ="height: 28px;    width: 28px;"></button>
  <button id = "goods" class = "roadinactive" style = "width:35px;" onclick = "goodsads()"><img src = "/transport.png" style ="height: 28px;    width: 28px;"></button>
   
  
   </div> 
   
   
  </div>
<!-- vertical end -->
<script type="text/javascript">
var verticalenabled ="<%= verticalenabledfromsession %>";
var currentLocationsetfromsess = <%= currentLocationsetfromsession != null ? currentLocationsetfromsession : false %>;
$(document).ready(function() {
	$(".search-container").hide();
	
});
let map;var blueMarker; var blueMarkers = [];var currentMarker; var currentLocationset=false; // Variable to keep track of the current marker
//let circle;
function initMap() {
    // Initialize the map and set default properties
     map = new google.maps.Map(document.getElementById('map'), {
        center: { lat: 13.529271965260616, lng: 75.36285138756304 },
        zoom:12        
    });
    
     google.maps.event.addListener(map,'click',function(event) {
       
         	if (currentMarker){
         		currentMarker.setMap(null);}
         	 handleMapClick(event.latLng, map);
         	});
     
}
function handleMapClick(location, map) {
    // Place a marker at the clicked location
          var maph=map;
    	  currentMarker= new google.maps.Marker({
          position: location,
          map: maph
       // title: `Lat: ${location.lat()}, Lng: ${location.lng()}`,
    });
        
}
//window.onload = initMap;
//initMap();
let searchmarker;
function placeMarker(lat, lng) {
    if (currentMarker) currentMarker.setMap(null);
    currentMarker = new google.maps.Marker({
        position: { lat: lat, lng: lng },
        map: map
    });
    map.setCenter({ lat: lat, lng: lng });
    map.setZoom(13);
}

document.getElementById("searchmagnifierlocation").addEventListener("click", function () {
    let place = document.getElementById("searchlocationinput").value.trim();
    if (!place) {
        alert("Please enter a location");
        return;
    }

    fetch("/searchPlaceAjax?place=" + encodeURIComponent(place))
        .then(response => response.json())
        .then(data => {
            if (data.status === "OK") {
                placeMarker(data.lat, data.lng);
            } else {
                alert("Location not found");
            }
        })
        .catch(err => console.error(err));
});
$('#myModal').on('shown.bs.modal', function () { initMap(); });
//on lcick of search orange icon start here 
var button = document.getElementById("searchbutton1");

//Attach an event listener to the button
button.addEventListener("click", function() {
 $(".search-container").show();
 $(".search-button-container").hide();
 //const input = document.getElementById('usr');
 //input.style.width = '100%';
});

var searchclosebutton =  document.getElementById("searchclose");
searchclosebutton.addEventListener("click", function() {
	$(".search-container").hide();
	 $(".search-button-container").show();
	 document.getElementById("searchinput").value = "";
	 var k=0;
	 const requestId = generateRequestId();
		latestRequestId = requestId;
	//fetch('/removegiads?requestId=' + requestId, {
		fetch('/removesearch?requestId=' + requestId, {
        method: 'POST'
    }).then(response => {
   	 
   	 if (!response.ok) {
   	        throw new Error("Network response was not ok");
   	    }
   	 
   	 return response.json(); // ✅ Parse the JSON body
    })
   	 .then(data => {
   		 	noofresults=data.length;
   		 	//console.log('remove search');
   		   $('#noofresults').html('Results: '+noofresults) ;
   		 
     	  globalpng = {
     			  url: imageMap[verticalenabledinlocation] || "http://maps.google.com/mapfiles/ms/icons/red-dot.png",
     			  scaledSize: new google.maps.Size(25, 25), // common size
     			  anchor: new google.maps.Point(12, 12)
     			};
   		 	// Check if a specific class exists
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
   		    currentAdsData=data;
   		   
   		      // document.getElementById("ads").innerHTML = "";
   		   	noofresults=data.length;
   		   //	console.log('No of Results: ' +noofresults);
   			 $('#noofresults').html('Results: '+noofresults) ;

   	         let x = JSON.stringify(data); 
   	         //console.log('x length : ' +data.length);
   	         const bounds = new google.maps.LatLngBounds();var center;    
   	        for (var i = 0; i < markers.length; i++) {
   		   markers[i].setMap(null); // Remove marker from the map
   		
   	   }
   	locations = []; // Clear the array of markers
   	circles.forEach(circle => {
   	    circle.setMap(null); // Remove circle from the map
   	});
   	circles.length = 0; // Clear the array
   	//Remove the previous circle if it exists
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
   		     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
   	         $.each(data, function (i, myList) {
   	         	
   	         	  var adsid = myList.id;
   	  	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
   		    
   		        const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
   	 		const marker = new google.maps.Marker({	        	 			 
   	 	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
   	 	        map: map3,
   	 	        icon:globalpng
   	 	      });
   	markers.push(marker);	

   	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
   		marker.addListener('click', function() {	
   			setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
   			});
   	bounds.extend(marker.position);
   		        	  }); //.each
   	         map3.fitBounds(bounds);
   		        	  
   	         center = bounds.getCenter();let maxDistance=0;
   		    	$.each(data, function (i, myList) {
   		    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
   		    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
   		    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
   					    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
   					    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
   		    		    	if (distance > maxDistance) { maxDistance = distance; }
   		    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
   		    		    	});//2nd each 
   	      //   $('#radius').empty().append(""+maxDistance/1000);
   	    /*      circle = new google.maps.Circle({
   	   		     map: map3,
   	   		     radius: maxDistance, // Radius in meters
   	   		fillColor: '#00000000', // transparent color
   	     fillOpacity: 0,         // fully transparent
   	   		     strokeColor: '#F27C0A', // Red stroke color
   	   		     strokeOpacity: 0.8, // Stroke opacity
   	   		     strokeWeight: 2, // Stroke weight
   	   		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
   	   		   });  
   	       circles.push(circle);*/
    });//.then
	 
});

//on lcick of search orange icon end here 
//to show the address start here
var currentlatforblue;var currentlngforblue;
//to get the latitude and longitude stored in session
 var latitudefromsession = <%= latitude%>;
 var longitudefromsession = <%= longitude%>;
 var finallistofads = <%= finallistofads1 %>
 currentlatforblue=latitudefromsession;currentlngforblue=longitudefromsession;//toget blue marker as soon as the page is loaded
 var globalpng ;
 const imageMap = {
		 roadenabled:"http://maps.google.com/mapfiles/ms/icons/red-dot.png",
		  gitagenabled: "/gitagicon3.png",
		  templeenabled: "/temple.png",
		  forestenabled: "/national-park.png",
			  heritageenabled: "/hampiheritage4.jpg",
			  hospitalenabled: "/hospital.png",
			  busenabled: "/bus.png",
				 carenabled: "/car.png",
				  rickshawenabled: "/rickshaw.png",
				  goodsenabled: "/transport.png",vlogsenabled:"http://maps.google.com/mapfiles/ms/icons/red-dot.png",newsenabled:"http://maps.google.com/mapfiles/ms/icons/red-dot.png"
		};
 //document.addEventListener('DOMContentLoaded', function() {
function getCurrentLocation() { // as soon as the page is loaded
    	//console.log('in get current location');    
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                function(position) {
                //	console.log('to fetch lat lng');
                   /* const lat = position.coords.latitude;
                    const lng = position.coords.longitude;*/
                    const lat = latitudefromsession;
                    const lng = longitudefromsession;
                    currentlatforblue=lat;currentlngforblue=lng;
                //  	console.log('to fetch lat lng'+lat +'and: ' +lng);
                   // displayCurrentLocation(lat, lng);
                },
                function(error) {
               //     console.error('Error getting location:', error);
                    //document.getElementById('location').innerText = 'Error getting location.';
                    var defaultLocation = { coords: { latitude: 13.529271965260616,  longitude: 75.36285138756304 } };
                 	 const lat = defaultLocation.coords.latitude;
                    const lng = defaultLocation.coords.longitude;
                  //  displayCurrentLocation(lat, lng);
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
               const inputField = document.getElementById('usr');
               inputField.value = address;  // Set the value of the input field to the variable's value
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
                   map: map,
                  title: address
               });
            } else {
            }
        
        })//.then
        .catch(error => {
            console.error('Error with reverse geocoding:', error);
            //document.getElementById('location').innerText = 'Error with reverse geocoding.';
        });
}
window.onload = getCurrentLocation;
getCurrentLocation();
// to show the address end here

//current location start here 
let watchID;
//moving blue marker start here 
function updateMarkerPosition(position) 
   { 
//	console.log('updateMarker: ' +position.coords.latitude);   
   	const lat = position.coords.latitude; const lng = position.coords.longitude; //position.coords.latitude
   	const newPosition = new google.maps.LatLng(lat, lng); // Update the marker's position 
   	blueMarker.setPosition(newPosition); // Center the map on the new position 
   	map3.setCenter(newPosition);
      	//console.log('watch ID: ' +watchID);
   	   var dist=getDistanceFromLatLonInKm(lastlat,lastlng,lat,lng).toFixed(1);
   	 var detectLocation = { coords: {latitude: position.coords.latitude, longitude: position.coords.longitude} };
  	      if(dist>0.2)
  	    	  {
  	    	 // console.log('distance : ' +dist);		    	  
  	    	//  var detectLocation = { coords: {  latitude: 13.529271965260616,  longitude: 75.36285138756304 } };
  	    	//updateMarkerPosition(position);
  	    	 sendLocationDetect(detectLocation);
  	    	 // sendLocation(detectLocation);
  	    	 
  	    	  }
   } // Function to handle errors 
   	function showError(error) { switch (error.code) { case error.PERMISSION_DENIED: alert("User denied the request for Geolocation."); break; case error.POSITION_UNAVAILABLE: alert("Location information is unavailable."); break; case error.TIMEOUT: alert("The request to get user location timed out."); break; case error.UNKNOWN_ERROR: alert("An unknown error occurred."); break; } }
   
 //moving blue marker end here
 
 
 function getCurrentLocations(){
	 
 
    		  if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                function(position) {
                //	console.log('to fetch lat lng');
                  const   lat = position.coords.latitude;
                  const   lng = position.coords.longitude;
                  currentlatforblue=lat;currentlngforblue=lng;
                //  navigator.geolocation.watchPosition(currentLocation, showError, { enableHighAccuracy: true, timeout: 60000 });
                	//watchID = navigator.geolocation.watchPosition(updateMarkerPosition, showError, { enableHighAccuracy: true, timeout: 30000, maximumAge: 10000,  distanceFilter: 10 });
                //	watchID = navigator.geolocation.watchPosition(updateMarkerPosition, showError, { enableHighAccuracy: true, timeout: 30000, maximumAge: 10000,  distanceFilter: 10 });
              currentLocation(position);
                },
                function(error) {
                    console.error('Error getting location by :', error);
              //      document.getElementById('location').innerText = 'Error getting location.';
                }
            );
        } else {
            //document.getElementById('location').innerText = 'Geolocation is not supported by this browser.';
        }
    	 // console.log('lat and lng : '+ lat +lng);
    }
    function currentLocation(position){
    //	console.log('current location got successfully from watch');
    	currentLocationset=true;//declared in index
    	currentLocationSetting=true;
    	document.getElementById("currentlocationbutton").disabled = false;
    	  document.getElementById("pinlocationbutton").disabled = true;
    	
    	  globalpng = {
    			  url: imageMap[verticalenabledinlocation] || "http://maps.google.com/mapfiles/ms/icons/red-dot.png",
    			  scaledSize: new google.maps.Size(25, 25), // common size
    			  anchor: new google.maps.Point(12, 12)
    			};
    	locationset++;//declared in index
  
    	 var lat = position.coords.latitude;
    	 var lng = position.coords.longitude;
    var k=0;
    var results=0;
  /*  if (navigator.geolocation) 
    { 
    	watchID = navigator.geolocation.watchPosition(updateMarkerPosition, showError, { enableHighAccuracy: true, timeout: 60000, maximumAge: 0, });
    	} 
    else { alert("Geolocation is not supported by this browser."); }*/
   // displayCurrentLocation(lat, lng);
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
      //blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
    
    	$.ajax({
        // Our sample url to make request 
        url:"${pageContext.request.contextPath}/currentlocation",
        type: "POST",
        contentType : 'application/json',
        dataType : 'json',
        data:JSON.stringify({lat,lng}), 
        success: function (data) {
            let x = JSON.stringify(data);
        	 const bounds = new google.maps.LatLngBounds();var center;    
       //     console.log(x);
         //   document.getElementById("ads").innerHTML = "";
           for (var i = 0; i < markers.length; i++) {
	   markers[i].setMap(null); // Remove marker from the map
	 
	  // locations[i]=null;
      }
   locations = []; // Clear the array of markers
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
            $.each(data, function (i, myList) {
  	     	//  console.log('data in current location: ' +data);
  	     	 var adsid = myList.id;
	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	    	var banner1="nopreview.jpg";
	    	var banner2 = "nopreview.jpg";
	    	
   	     	if(myList.companies==null || myList.companies==undefined){//console.log('inside if'+publisher_name);
   	     	companyName=publisher_name;}
   	     	else{	     	 companyName= myList.companies.name;}
   	     	 var img_path = "";
   	     	k++;
	 
   	        var  latt = 13.529271965260616;
	        var lngg = 75.36285138756304; 
	      
	        const lattt =  Number(myList.location.lat); const longgg= Number(myList.location.lng) ;
    		const marker = new google.maps.Marker({
    	    //   position: new google.maps.LatLng(myList.location.lat,myList.location.lng),
    	    //  position: new google.maps.LatLng(locations[j][0], locations[j][1]),
    	   // position:{ lat: JSON.parse(locations[j][0]), lng:JSON.parse(locations[j][1] )},
    	   
    	 //  position:{ lat: parseFloat(locations[j][0]), lng:parseFloat(locations[j][1] )},
    	//  position:{ lat:lattt, lng:longgg},
    	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
    	        map: map3,
    	        icon:globalpng
    	      });
 markers.push(marker);	
	if (["busenabled", "carenabled", "goodsenabled", "rickshawenabled"].includes(verticalenabledinlocation) || busenabled ===1 || carenabled ===1 || rickshawenabled ===1 || goodsenabled ===1)
{
		
		var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp,adsid:adsid}
		marker.addListener('click', function() {	
			setTimeout(() => { showCardforvehicles(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card
				    		});
}
	else
		{
 var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
	marker.addListener('click', function() {
		//console.log('marker clicked');
		setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
		});
		}
   	results++;
   	bounds.extend(marker.position);
   	        	  }); //.each
            map3.fitBounds(bounds);
   	        	  
            center = bounds.getCenter();	let maxDistance = 0;   
	    	$.each(data, function (i, myList) {
	    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
				    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
				    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	    		    	if (distance > maxDistance) { maxDistance = distance; }
	    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	    		    	});//2nd each 
   	        	  
          //  $('#radius').empty().append(""+maxDistance/1000);  
       /*      circle = new google.maps.Circle({
   		     map: map3,
   		     radius: maxDistance, // Radius in meters
   		  fillColor: '#00000000', // transparent color
   	    fillOpacity: 0,         // fully transparent
   		     strokeColor: '#F27C0A', // Red stroke color
   		     strokeOpacity: 0.8, // Stroke opacity
   		     strokeWeight: 2, // Stroke weight
   		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
   		   }); 
             
             circles.push(circle);*/
        }//success
    	});//ajax
    	
        }
// current location end here

//pin location start here
$( "#setlocation" ).on( "click", function() {
    	  //alert( "Handler for `click` called." ); 
    	//  console.log('value of locationn on ajax : ' +marker.getPosition().lat());
    	currentLocationset=false;currentLocationsetfromsess == false;
    	  var lat =currentMarker.getPosition().lat();
    	  var lng = currentMarker.getPosition().lng();
    	  var k = 0;
    	  currentlatforblue=lat;
    	  currentlngforblue=lng;
    	  globalpng = {
    			  url: imageMap[verticalenabledinlocation] || "http://maps.google.com/mapfiles/ms/icons/red-dot.png",
    			  scaledSize: new google.maps.Size(25, 25), // common size
    			  anchor: new google.maps.Point(12, 12)
    			};
    	/*  blueMarker.setMap(null);
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
    	      });*/
    	//  displayCurrentLocation(lat, lng);
    //	  var locations=[];
    document.getElementById("currentlocationbutton").disabled = true;
    	  document.getElementById("pinlocationbutton").disabled = false;
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
            //console.log('x length : ' +data.length);
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
	     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
            $.each(data, function (i, myList) {
            	
            	  var adsid = myList.id;
     	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	     	
	     	
   	 //  console.log('ad_card: '+ad_card);
   	        var  latt = 13.529271965260616;
	        var lngg = 75.36285138756304; 
	      
	        const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
    		const marker = new google.maps.Marker({
    	    //   position: new google.maps.LatLng(myList.location.lat,myList.location.lng),
    	    //  position: new google.maps.LatLng(locations[j][0], locations[j][1]),
    	   // position:{ lat: JSON.parse(locations[j][0]), lng:JSON.parse(locations[j][1] )},
    	   
    	 //  position:{ lat: parseFloat(locations[j][0]), lng:parseFloat(locations[j][1] )},
    	//  position:{ lat:lattt, lng:longgg},
    	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
    	        map: map3,
    	        icon:globalpng
    	      });
 markers.push(marker);	
 
 if (["busenabled", "carenabled", "goodsenabled", "rickshawenabled"].includes(verticalenabledinlocation) || busenabled ===1 || carenabled ===1 || rickshawenabled ===1 || goodsenabled ===1)
 {
 		
 		var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp,adsid:adsid}
 		marker.addListener('click', function() {	
 			setTimeout(() => { showCardforvehicles(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card
 				    		});
 }
 	else
 		{
  var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
 	marker.addListener('click', function() {
 		//console.log('marker clicked');
 		setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
 		});
 		}
 bounds.extend(marker.position);
   	        	  }); //.each
            map3.fitBounds(bounds);
   	        	  
            center = bounds.getCenter();let maxDistance=0;
	    	$.each(data, function (i, myList) {
	    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
				    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
				    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	    		    	if (distance > maxDistance) { maxDistance = distance; }
	    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	    		    	});//2nd each 
         //   $('#radius').empty().append(""+maxDistance/1000);
           /*  circle = new google.maps.Circle({
      		     map: map3,
      		     radius: maxDistance, // Radius in meters
      		   fillColor: '#00000000', // transparent color
      		    fillOpacity: 0,         // fully transparent
      		     strokeColor: '#F27C0A', // Red stroke color
      		     strokeOpacity: 0.8, // Stroke opacity
      		     strokeWeight: 2, // Stroke weight
      		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
      		   });  
             
             circles.push(circle);*/
        }//success
    });//ajax
});
//pin location end here

//search start here

 $('#searchmagnifier').click(function()
{		 
	 var keywordvalue = $('#searchinput').val();var k=0;
//	 console.log('keyword value : ' +keywordvalue);
 // 	globalpng ='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
   globalpng = {
    			  url: imageMap[verticalenabledinlocation] || "http://maps.google.com/mapfiles/ms/icons/red-dot.png",
    			  scaledSize: new google.maps.Size(25, 25), // common size
    			  anchor: new google.maps.Point(12, 12)
    			};
	 fetch('${pageContext.request.contextPath}/keyword', {
		    method: 'POST',
		    headers: {
		        'Content-Type': 'application/json'
		    },
		    body: keywordvalue
		})
		    .then(response => {
		        if (!response.ok) {
		            throw new Error('Network response was not ok');
		        }
		        return response.json(); // Parsing the JSON response
		    })
		    .then(data => {
		     //   console.log('search result: '+data.length); // Handling the data
		        currentAdsData= data;
		    	noofresults=data.length;
     		   $('#noofresults').html('Results: '+noofresults) ;
		        //var lat = currentMarker.getPosition().lat();
		      //   var lng = currentMarker.getPosition().lng();
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
		       var results=0;
		       $.each(data, function (i, myList) {
		    	 	var zoom_val=0;
		    	var adsid = myList.id;
		    	locations.push([myList.location.lat,myList.location.lng])
					var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
					var email= myList.emailAddress;
		     	 var publisher_name = myList.a.title;
		  
		     	 var description = myList.a.description;
		     	 var dates = myList.dateRange.toDate;
		     	const date = new Date(dates);
		    	var companyName='';
		    	var latitudes=myList.location.lat;
		    	var longitudes = myList.location.lng;
		   // 	console.log(adsid +'and: ' +longitudes);
		    	var companyLogoUrl = myList.companies.companyLogoPath;
		    	var thumbnail = myList.a.thumbnail;png='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
		    	if(myList.companies==null || myList.companies==undefined){
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
		    	 /*var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
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
				   // center = bounds.getCenter();
				   
		    	   });///each
		    
		    	   let maxDistance = 0;  center = bounds.getCenter();
		    	   $.each(data, function (i, myList) {
			    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
			    		const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
			    		 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
				    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
				    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
			    		if (distance > maxDistance) { maxDistance = distance; }
			    	//	console.log('maxdistance : ' +maxDistance/1000);
			      });//2nd each
			      
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
	          
		    })
		    .catch(error => {
		        console.error('Fetch error:', error); // Handling errors
		    });

 
 
});
// search end here

//tracking continuous location start here
 const roadbutton = document.getElementById("road");
/*document.getElementById("road").addEventListener("click", function() {
	     console.log('road clicked');
            // Toggle the 'clicked' class on button click
          //  this.classList.toggle("roadactive");
            if (roadbutton.classList.contains("roadactive")) {       //when clicked
                
                roadbutton.classList.remove("roadactive");     // If 'active' class is already present, remove it
                roadbutton.classList.add("roadinactive");
                
                if (watchID !== undefined) {
                    navigator.geolocation.clearWatch(watchID); 
                }
                    console.log('watch Id : ' +watchID);
                
            } else {
                // If 'active' class is not present, add it
                roadbutton.classList.remove("roadinactive");
                roadbutton.classList.add("roadactive");  
                
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(
                        function(position) {
                        //	console.log('to fetch lat lng');
                          const   lat = position.coords.latitude;
                          const   lng = position.coords.longitude;
                       /*   onesinglelatitude =lat;
                          onesinglelongitude = lng;*/
                   /*
                   lastlat= lat;
                          lastlng = lng;
                        //  navigator.geolocation.watchPosition(currentLocation, showError, { enableHighAccuracy: true, timeout: 60000 });
                        	watchID = navigator.geolocation.watchPosition(updateMarkerPosition, showError, { enableHighAccuracy: true, timeout: 30000, maximumAge: 10000,  distanceFilter: 10 });
                      //  	watchID = navigator.geolocation.watchPosition(updateMarkerPosition, showError, { enableHighAccuracy: true, timeout: 30000, maximumAge: 10000,  distanceFilter: 10 });
                     // currentLocation(position);//?????????                     
                        },
                        function(error) {
                            console.error('Error getting location by :', error);
                            document.getElementById('location').innerText = 'Error getting location.';
                        }
                    );
                } else {
                    document.getElementById('location').innerText = 'Geolocation is not supported by this browser.';
                }
               
            }
           
        });*/
        
function updateMarkerPosition(position) 
{ 
	const lat = position.coords.latitude; const lng = position.coords.longitude; //position.coords.latitude
	const newPosition = new google.maps.LatLng(lat, lng); // Update the marker's position 
//	blueMarker.setPosition(newPosition); // Center the map on the new position 
	//map3.setCenter(newPosition);
   	console.log('watch ID: ' +watchID);
     var dist=getDistanceFromLatLonInKm(lastlat,lastlng,lat,lng).toFixed(4);
	 var detectLocation = { coords: {latitude: position.coords.latitude, longitude: position.coords.longitude} };
	 /*lastlat=lat;
	 lastlng=lng;*/
	 
	/* currentdistanceglobal=dist;
	currentlocationglobal++;*/
 console.log('Every 30 sec: '); //$('#itr').html('CItr: '+currentlocationglobal) ;
//   $('#dis').html('dist: '+currentdistanceglobal) ;
//  $('#current').html('current '+lat.toFixed(4) +'and : ' +lng.toFixed(4)) ;
//  $('#last').html('last '+lastlat.toFixed(4) +'and : ' +lastlng.toFixed(4)) ;
 // displayCurrentLocation(lat, lng);
	      if(dist>0.02)
	    	  {
	    	 // console.log('distance : ' +dist);		    	  
	    	//  var detectLocation = { coords: {  latitude: 13.529271965260616,  longitude: 75.36285138756304 } };
	    	//updateMarkerPosition(position);
	    	 sendLocationDetect(detectLocation);
	    	 lastlat=lat;
	     	 lastlng=lng;
	    	 // sendLocation(detectLocation);
	    	 
	    	  }
} // Function to handle errors 
	function showError(error) { switch (error.code) { case error.PERMISSION_DENIED: alert("User denied the request for Geolocation."); break; case error.POSITION_UNAVAILABLE: alert("Location information is unavailable."); break; case error.TIMEOUT: alert("The request to get user location timed out."); break; case error.UNKNOWN_ERROR: alert("An unknown error occurred."); break; } }
//tracking continuous location end here

document.getElementById("menuicon").addEventListener("click", () => {
	 // console.log("Clicked using arrow function!");
	  //$('#dropdownMenu').show();
	//  document.getElementById("dropdownMenu").style.display = "block";
	 document.getElementById("dropdownMenu").classList.toggle("show"); 	  
	 
	 
	/* display: flex;
	    flex-wrap: wrap;
	    gap: 16px;
	    justify-content: space-between;*/
	});
	
	/*document.addEventListener('click', function () {
	const dropdown = document.getElementById('dropdownMenu');
	  if (!dropdown.contains(event.target)) {

	dropdown.style.display = "none";
	  }
	});*/
	
	window.addEventListener("click", function(event) {
	    if (!(document.getElementById("menuicon").contains(event.target)) && !(document.getElementById("dropdownMenu").contains(event.target))) {
	    	document.getElementById("dropdownMenu").classList.remove("show");
	    }
	  });

	//const roadbutton = document.getElementById("road");
	document.getElementById("road").addEventListener("click", function() {
//		console.log('road clicked');
	            // Toggle the 'clicked' class on button click
	          //  this.classList.toggle("roadactive");
	              globalpng = {
    			  url: imageMap[verticalenabledinlocation] || "http://maps.google.com/mapfiles/ms/icons/red-dot.png",
    			  scaledSize: new google.maps.Size(25, 25), // common size
    			  anchor: new google.maps.Point(12, 12)
    			};
	            if (roadbutton.classList.contains("roadactive")) {       //when clicked
	                // If 'active' class is already present, remove it
	                roadbutton.classList.remove("roadactive");
	                roadbutton.classList.add("roadinactive");
	                
	                if (watchID !== undefined) {
	                    navigator.geolocation.clearWatch(watchID); 
	                }                
	                document.getElementById("currentlocationbutton").disabled = false;
	          	  document.getElementById("pinlocationbutton").disabled = true;
	          	verticalenabledinlocation="";
	            } else {
	                // If 'active' class is not present, add it
	                document.getElementById("currentlocationbutton").disabled = false;
    	            document.getElementById("pinlocationbutton").disabled = true;
	                roadbutton.classList.remove("roadinactive");
	                roadbutton.classList.add("roadactive");  
	            	verticalenabledinlocation = "roadenabled";
	                if (navigator.geolocation) {
	                    navigator.geolocation.getCurrentPosition(
	                        function(position) {
	                        //	console.log('to fetch lat lng');
	                          const   lat = position.coords.latitude;
	                          const   lng = position.coords.longitude;
	                          onesinglelatitude =lat;
	                          onesinglelongitude = lng;
	                          lastlat= lat;
	                          lastlng = lng;
	                        //  navigator.geolocation.watchPosition(currentLocation, showError, { enableHighAccuracy: true, timeout: 60000 });
	                        	watchID = navigator.geolocation.watchPosition(updateMarkerPosition, showError, { enableHighAccuracy: true, timeout: 30000, maximumAge: 10000,  distanceFilter: 10 });
	                      //  	watchID = navigator.geolocation.watchPosition(updateMarkerPosition, showError, { enableHighAccuracy: true, timeout: 30000, maximumAge: 10000,  distanceFilter: 10 });
	                     // currentLocation(position);//?????????
	                      
	                  //    $('#itr').html('CItr: '+currentlocationglobal) ;
	                      
	                        },
	                        function(error) {
	                            console.error('Error getting location by :', error);
	                          //  document.getElementById('location').innerText = 'Error getting location.';
	                        }
	                    );
	                } else {
	                    //document.getElementById('location').innerText = 'Geolocation is not supported by this browser.';
	                }
	               
	            }
	            
	             if(gitagbutton.classList.contains("roadactive"))  { //when clicked
	                // If 'active' class is already present, remove it
	              //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	                gitagbutton.classList.remove("roadactive");
	                gitagbutton.classList.add("roadinactive");  
	            } 
	             
	             if(templebutton.classList.contains("roadactive"))  { //when clicked
	                 // If 'active' class is already present, remove it
	               //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	                 templebutton.classList.remove("roadactive");
	                 templebutton.classList.add("roadinactive");  
	             } 
	           
	           //for heritage, hostpital, bus, car, goods, rickashaw
	             if(forestbutton.classList.contains("roadactive"))  { //when clicked
	                 // If 'active' class is already present, remove it
	               //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	                 forestbutton.classList.remove("roadactive");
	                 forestbutton.classList.add("roadinactive");  
	             }
	           
	             if(heritagebutton.classList.contains("roadactive"))  { //when clicked
	                 // If 'active' class is already present, remove it
	               //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	            	 heritagebutton.classList.remove("roadactive");
	            	 heritagebutton.classList.add("roadinactive");  
	             }
	             
	             
	             if(hospitalbutton.classList.contains("roadactive"))  { //when clicked
	                 // If 'active' class is already present, remove it
	               //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	            	 hospitalbutton.classList.remove("roadactive");
	            	 hospitalbutton.classList.add("roadinactive");  
	             }

	             
	             if(carbutton.classList.contains("roadactive"))  { //when clicked
	                 // If 'active' class is already present, remove it
	               //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	            	 carbutton.classList.remove("roadactive");
	            	 carbutton.classList.add("roadinactive");  
	             }
	             
	             
	             if(busbutton.classList.contains("roadactive"))  { //when clicked
	                 // If 'active' class is already present, remove it
	               //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	            	 busbutton.classList.remove("roadactive");
	            	 busbutton.classList.add("roadinactive");  
	             }

	             
	             if(goodsbutton.classList.contains("roadactive"))  { //when clicked
	                 // If 'active' class is already present, remove it
	               //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	            	goodsbutton.classList.remove("roadactive");
	            	 goodsbutton.classList.add("roadinactive");  
	             }
	             
	             
	             if(rickshawbutton.classList.contains("roadactive"))  { //when clicked
	                 // If 'active' class is already present, remove it
	               //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	            	rickshawbutton.classList.remove("roadactive");
	            	 rickshawbutton.classList.add("roadinactive");  
	             }
	             
	             if(vlogsbutton.classList.contains("roadactive"))  { //when clicked
	                 // If 'active' class is already present, remove it
	               //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	            	vlogsbutton.classList.remove("roadactive");
	            	 vlogsbutton.classList.add("roadinactive");  
	             }
	             
	             if(newsbutton.classList.contains("roadactive"))  { //when clicked
	                 // If 'active' class is already present, remove it
	               //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	            	newsbutton.classList.remove("roadactive");
	            	 newsbutton.classList.add("roadinactive");  
	             }
	        });
	//tracking continuous location end here

	var gitagenabled=0;
	const gitagbutton = document.getElementById('gi');
	const templebutton = document.getElementById("temple");
	const forestbutton = document.getElementById("forest");
	const heritagebutton = document.getElementById("heritage");
	const hospitalbutton = document.getElementById("hospital");
	const busbutton = document.getElementById("bus");
	const carbutton = document.getElementById("car");
	const rickshawbutton = document.getElementById("rickshaw");
	const goodsbutton = document.getElementById("goods");
	const distancebutton = document.getElementById('distance');
	const timebutton =  document.getElementById('time');
	const vlogsbutton =  document.getElementById('vlogs');
	const newsbutton =  document.getElementById('news');
	let distance =0; let time =0;/*let noofresults =0;*/var noofresults =0;
	var vlogsenabled = "<%= vlogsenabledfromsession %>";
	//console.log('vlogsenabled : ' + vlogsenabled);
	var vlogsenabledd =0;
	function vlogs()
	{
			gitagenabled=0;templeenabled =0;forestenabled=0;heritageenabled =0;hospitalenabled =0;vlogsenabledd=1;newsenabled=0;
			globalpng ='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
	var k=0;
	
	/*currentRequestId++;
	let requestId = currentRequestId;*/
	
	const requestId = generateRequestId();
	latestRequestId = requestId;
	if (watchID !== undefined) {
        navigator.geolocation.clearWatch(watchID); 
    }

		
		 if (vlogsbutton.classList.contains("roadactive")) {       //when clicked to remove
			 vlogsbutton.classList.remove("roadactive");
			 vlogsbutton.classList.add("roadinactive");  
	         
	         
	         document.getElementById("filter-container").style.display = "flex";
	         
	         //gitagenabled=0;
	         vlogsenabledd=0;
	     	verticalenabledinlocation = "";
	     
	         fetch('/removegiads?requestId=' + requestId, {
	             method: 'POST'
	         }).then(response => {
	        	 
	        	 if (!response.ok) {
	        	        throw new Error("Network response was not ok");
	        	    }
	        	 
	        	 return response.json(); // ✅ Parse the JSON body
	         })
	        	 .then(data => {
	        		/* if (requestId !== currentRequestId) return;	*/
	        		if (requestId !== latestRequestId) return;
	        		 noofresults=data.length;
	        		   $('#noofresults').html('Results: '+noofresults) ;
	        			
	        		 	// Check if a specific class exists
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
	        		    currentAdsData=data;
	        		   
	        		      // document.getElementById("ads").innerHTML = "";
	        		   	noofresults=data.length;
	        		   //	console.log('No of Results: ' +noofresults);
	        			 $('#noofresults').html('Results: '+noofresults) ;

	        	         let x = JSON.stringify(data); 
	        	         //console.log('x length : ' +data.length);
	        	         const bounds = new google.maps.LatLngBounds();var center;    
	        	        for (var i = 0; i < markers.length; i++) {
	        		   markers[i].setMap(null); // Remove marker from the map
	        		
	        	   }
	        	locations = []; // Clear the array of markers
	        	circles.forEach(circle => {
	        	    circle.setMap(null); // Remove circle from the map
	        	});
	        	circles.length = 0; // Clear the array
	        	//Remove the previous circle if it exists
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
	        		     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
	        	         $.each(data, function (i, myList) {
	        	         	
	        	         	  var adsid = myList.id;
	        	  	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	        		    
	        		        const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	        	 		const marker = new google.maps.Marker({	        	 			 
	        	 	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
	        	 	        map: map3,
	        	 	        icon:globalpng
	        	 	      });
	        	markers.push(marker);	

	        	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
	        		marker.addListener('click', function() {	
	        			setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
	        			});
	        	bounds.extend(marker.position);
	        		        	  }); //.each
	        	         map3.fitBounds(bounds);
	        		        	  
	        	         center = bounds.getCenter();let maxDistance=0;
	        		    	$.each(data, function (i, myList) {
	        		    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	        		    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	        		    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	        					    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	        					    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	        		    		    	if (distance > maxDistance) { maxDistance = distance; }
	        		    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	        		    		    	});//2nd each 
	        	      //   $('#radius').empty().append(""+maxDistance/1000);
	        	       /*   circle = new google.maps.Circle({
	        	   		     map: map3,
	        	   		     radius: maxDistance, // Radius in meters
	        	   		  fillColor: '#00000000', // transparent color
	        	   	    fillOpacity: 0,         // fully transparent
	        	   		     strokeColor: '#F27C0A', // Red stroke color
	        	   		     strokeOpacity: 0.8, // Stroke opacity
	        	   		     strokeWeight: 2, // Stroke weight
	        	   		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
	        	   		   });  
	        	          circles.push(circle);*/
	         });//.then
	     } //if else 
		
		 else{
			 vlogsbutton.classList.remove("roadinactive");
	         vlogsbutton.classList.add("roadactive");   
	     	verticalenabledinlocation = "vlogsenabled";
	         document.getElementById("filter-container").style.display = "none";
	         if (roadbutton.classList.contains("roadactive")) {       //when clicked
	             // If 'active' class is already present, remove it
	             roadbutton.classList.remove("roadactive");
	             roadbutton.classList.add("roadinactive");
	         }
	         
	         if (gitagbutton.classList.contains("roadactive")) {       //when clicked
	             // If 'active' class is already present, remove it
	             gitagbutton.classList.remove("roadactive");
	             gitagbutton.classList.add("roadinactive");
	         }
	         if (newsbutton.classList.contains("roadactive")) {       //when clicked
	             // If 'active' class is already present, remove it
	             newsbutton.classList.remove("roadactive");
	             newsbutton.classList.add("roadinactive");
	         }
	         if (templebutton.classList.contains("roadactive")) {       //when clicked
	             // If 'active' class is already present, remove it
	             templebutton.classList.remove("roadactive");
	             templebutton.classList.add("roadinactive");
	         }
	         
	         if (forestbutton.classList.contains("roadactive")) {       //when clicked
	             // If 'active' class is already present, remove it
	             forestbutton.classList.remove("roadactive");
	             forestbutton.classList.add("roadinactive");
	         }
	         
	         
	         
	         if(heritagebutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 heritagebutton.classList.remove("roadactive");
	        	 heritagebutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(hospitalbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 hospitalbutton.classList.remove("roadactive");
	        	 hospitalbutton.classList.add("roadinactive");  
	         }

	         
	         if(carbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 carbutton.classList.remove("roadactive");
	        	 carbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(busbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 busbutton.classList.remove("roadactive");
	        	 busbutton.classList.add("roadinactive");  
	         }

	         
	         if(goodsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	goodsbutton.classList.remove("roadactive");
	        	 goodsbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(rickshawbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	rickshawbutton.classList.remove("roadactive");
	        	 rickshawbutton.classList.add("roadinactive");  
	         }
	         
	         //for heritage, hostpital, bus, car, goods, rickashaw
		$.ajax({
	        // Our sample url to make request 
	        url:"${pageContext.request.contextPath}/vlogs?requestId=" + requestId,
	        type: "GET",
	        contentType : 'application/json',
	        dataType : 'json',
	        //data:JSON.stringify({lat,lng}), 
	        success: function (data) {
	        	/*if (requestId !== currentRequestId) return;*/
	        	if (requestId !== latestRequestId) return;
	 	// Check if a specific class exists
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
	    currentAdsData=data;
	   
	      // document.getElementById("ads").innerHTML = "";
	   	noofresults=data.length;
	   //	console.log('No of Results: ' +noofresults);
		 $('#noofresults').html('Results: '+noofresults) ;

         let x = JSON.stringify(data); 
         //console.log('x length : ' +data.length);
         const bounds = new google.maps.LatLngBounds();var center;    
        for (var i = 0; i < markers.length; i++) {
	   markers[i].setMap(null); // Remove marker from the map
	
   }
locations = []; // Clear the array of markers
circles.forEach(circle => {
    circle.setMap(null); // Remove circle from the map
});
circles.length = 0; // Clear the array
//Remove the previous circle if it exists
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
	     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
         $.each(data, function (i, myList) {
         	
         	  var adsid = myList.id;
  	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	     	
	      
	 
	      
	        const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	        const marker = new google.maps.Marker({ 	   
 	               position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
 	               map: map3,
 	               icon:globalpng
 	      });
markers.push(marker);	

var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
	marker.addListener('click', function() {	
		setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
		});
bounds.extend(marker.position);
	        	  }); //.each
         map3.fitBounds(bounds);
	        	  
         center = bounds.getCenter();let maxDistance=0;
	    	$.each(data, function (i, myList) {
	    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
				    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
				    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	    		    	if (distance > maxDistance) { maxDistance = distance; }
	    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	    		    	});//2nd each 
      //   $('#radius').empty().append(""+maxDistance/1000);
       /*   circle = new google.maps.Circle({
   		     map: map3,
   		     radius: maxDistance, // Radius in meters
   		  fillColor: '#00000000', // transparent color
   	    fillOpacity: 0,         // fully transparent
   		     strokeColor: '#F27C0A', // Red stroke color
   		     strokeOpacity: 0.8, // Stroke opacity
   		     strokeWeight: 2, // Stroke weight
   		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
   		   });  
          circles.push(circle);*/
	        }//success
		
	})//ajax

		 }
	}
var newsenabled =0;
	function news()
	{
			gitagenabled=0;templeenabled =0;forestenabled=0;heritageenabled =0;hospitalenabled =0;newsenabled = 1;vlogsenabledd=0;
			globalpng ='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
	var k=0;
	
	/*currentRequestId++;
	let requestId = currentRequestId;*/
	
	const requestId = generateRequestId();
	latestRequestId = requestId;
	if (watchID !== undefined) {
        navigator.geolocation.clearWatch(watchID); 
    }

		
		 if (newsbutton.classList.contains("roadactive")) {       //when clicked to remove
			 newsbutton.classList.remove("roadactive");
			 newsbutton.classList.add("roadinactive");  
	         
	         
	         document.getElementById("filter-container").style.display = "flex";
	         
	         newsenabled =0;
	     	verticalenabledinlocation = "";
	     	
	         fetch('/removegiads?requestId=' + requestId, {
	             method: 'POST'
	         }).then(response => {
	        	 
	        	 if (!response.ok) {
	        	        throw new Error("Network response was not ok");
	        	    }
	        	 
	        	 return response.json(); // ✅ Parse the JSON body
	         })
	        	 .then(data => {
	        		/* if (requestId !== currentRequestId) return;*/
	        		if (requestId !== latestRequestId) return;
	        		 noofresults=data.length;
	        		   $('#noofresults').html('Results: '+noofresults) ;
	        			
	        		 	// Check if a specific class exists
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
	        		    currentAdsData=data;
	        		   
	        		      // document.getElementById("ads").innerHTML = "";
	        		   	noofresults=data.length;
	        		   //	console.log('No of Results: ' +noofresults);
	        			 $('#noofresults').html('Results: '+noofresults) ;

	        	         let x = JSON.stringify(data); 
	        	         //console.log('x length : ' +data.length);
	        	         const bounds = new google.maps.LatLngBounds();var center;    
	        	        for (var i = 0; i < markers.length; i++) {
	        		   markers[i].setMap(null); // Remove marker from the map
	        		
	        	   }
	        	locations = []; // Clear the array of markers
	        	circles.forEach(circle => {
	        	    circle.setMap(null); // Remove circle from the map
	        	});
	        	circles.length = 0; // Clear the array
	        	//Remove the previous circle if it exists
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
	        		     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
	        	         $.each(data, function (i, myList) {
	        	         	
	        	         	  var adsid = myList.id;
	        	  	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	        		    
	        		        const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	        	 		const marker = new google.maps.Marker({	        	 			 
	        	 	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
	        	 	        map: map3,
	        	 	        icon:globalpng
	        	 	      });
	        	markers.push(marker);	

	        	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
	        		marker.addListener('click', function() {	
	        			setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
	        			});
	        	bounds.extend(marker.position);
	        		        	  }); //.each
	        	         map3.fitBounds(bounds);
	        		        	  
	        	         center = bounds.getCenter();let maxDistance=0;
	        		    	$.each(data, function (i, myList) {
	        		    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	        		    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	        		    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	        					    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	        					    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	        		    		    	if (distance > maxDistance) { maxDistance = distance; }
	        		    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	        		    		    	});//2nd each 
	        	      //   $('#radius').empty().append(""+maxDistance/1000);
	        	     /*     circle = new google.maps.Circle({
	        	   		     map: map3,
	        	   		     radius: maxDistance, // Radius in meters
	        	   		  fillColor: '#00000000', // transparent color
	        	   	    fillOpacity: 0,         // fully transparent
	        	   		     strokeColor: '#F27C0A', // Red stroke color
	        	   		     strokeOpacity: 0.8, // Stroke opacity
	        	   		     strokeWeight: 2, // Stroke weight
	        	   		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
	        	   		   });  
	        	          
	        	          circles.push(circle);*/

	         });//.then
	     } //if else 
		
		 else{
			 newsbutton.classList.remove("roadinactive");
	         newsbutton.classList.add("roadactive");   
	     	verticalenabledinlocation = "newsenabled";
	         document.getElementById("filter-container").style.display = "none";
	         if (roadbutton.classList.contains("roadactive")) {       //when clicked
	             // If 'active' class is already present, remove it
	             roadbutton.classList.remove("roadactive");
	             roadbutton.classList.add("roadinactive");
	         }
	         
	         if (gitagbutton.classList.contains("roadactive")) {       //when clicked
	             // If 'active' class is already present, remove it
	             gitagbutton.classList.remove("roadactive");
	             gitagbutton.classList.add("roadinactive");
	         }
	         if (vlogsbutton.classList.contains("roadactive")) {       //when clicked
	             // If 'active' class is already present, remove it
	             vlogsbutton.classList.remove("roadactive");
	             vlogsbutton.classList.add("roadinactive");
	         }
	         if (templebutton.classList.contains("roadactive")) {       //when clicked
	             // If 'active' class is already present, remove it
	             templebutton.classList.remove("roadactive");
	             templebutton.classList.add("roadinactive");
	         }
	         
	         if (forestbutton.classList.contains("roadactive")) {       //when clicked
	             // If 'active' class is already present, remove it
	             forestbutton.classList.remove("roadactive");
	             forestbutton.classList.add("roadinactive");
	         }
	         
	         
	         
	         if(heritagebutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 heritagebutton.classList.remove("roadactive");
	        	 heritagebutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(hospitalbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 hospitalbutton.classList.remove("roadactive");
	        	 hospitalbutton.classList.add("roadinactive");  
	         }

	         
	         if(carbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 carbutton.classList.remove("roadactive");
	        	 carbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(busbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 busbutton.classList.remove("roadactive");
	        	 busbutton.classList.add("roadinactive");  
	         }

	         
	         if(goodsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	goodsbutton.classList.remove("roadactive");
	        	 goodsbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(rickshawbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	rickshawbutton.classList.remove("roadactive");
	        	 rickshawbutton.classList.add("roadinactive");  
	         }
	         
	         //for heritage, hostpital, bus, car, goods, rickashaw
		$.ajax({
	        // Our sample url to make request 
	        url:"${pageContext.request.contextPath}/news?requestId=" + requestId,
	        type: "GET",
	        contentType : 'application/json',
	        dataType : 'json',
	        //data:JSON.stringify({lat,lng}), 
	        success: function (data) {
	        	/*if (requestId !== currentRequestId) return;*/
	        	if (requestId !== latestRequestId) return;
	 	// Check if a specific class exists
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
	    currentAdsData=data;
	   
	      // document.getElementById("ads").innerHTML = "";
	   	noofresults=data.length;
	   //	console.log('No of Results: ' +noofresults);
		 $('#noofresults').html('Results: '+noofresults) ;

         let x = JSON.stringify(data); 
         //console.log('x length : ' +data.length);
         const bounds = new google.maps.LatLngBounds();var center;    
        for (var i = 0; i < markers.length; i++) {
	   markers[i].setMap(null); // Remove marker from the map
	
   }
locations = []; // Clear the array of markers
circles.forEach(circle => {
    circle.setMap(null); // Remove circle from the map
});
circles.length = 0; // Clear the array
//Remove the previous circle if it exists
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
	     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
         $.each(data, function (i, myList) {
         	
         	  var adsid = myList.id;
  	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	     	
	        const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	        const marker = new google.maps.Marker({ 	   
 	               position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
 	               map: map3,
 	               icon:globalpng
 	      });
markers.push(marker);	

var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
	marker.addListener('click', function() {	
		setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
		});
bounds.extend(marker.position);
	        	  }); //.each
         map3.fitBounds(bounds);
	        	  
         center = bounds.getCenter();let maxDistance=0;
	    	$.each(data, function (i, myList) {
	    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
				    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
				    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	    		    	if (distance > maxDistance) { maxDistance = distance; }
	    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	    		    	});//2nd each 
      //   $('#radius').empty().append(""+maxDistance/1000);
    /*      circle = new google.maps.Circle({
   		     map: map3,
   		     radius: maxDistance, // Radius in meters
   		     fillColor: '#00000000', // transparent color
   	         fillOpacity: 0,         // fully transparent
   		     strokeColor: '#F27C0A', // Red stroke color
   		     strokeOpacity: 0.8, // Stroke opacity
   		     strokeWeight: 2, // Stroke weight
   		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
   		   });  
          
          circles.push(circle);*/
	        }//success
		
	})//ajax

		 }
	}

	
	function giads()
	{
			templeenabled=0;gitagenabled=1;;forestenabled=0;heritageenabled =0;hospitalenabled =0;vlogsenabledd =0; newsenabled =0;
		
		var k=0;
		/*currentRequestId++;
		let requestId = currentRequestId;*/
		
		const requestId = generateRequestId();
		latestRequestId = requestId;
		 if (gitagbutton.classList.contains("roadactive")) {       //when clicked to remove
			 gitagbutton.classList.remove("roadactive");
			 gitagbutton.classList.add("roadinactive");  
	         
	         document.getElementById("filter-container").style.display = "flex";
	         if (watchID !== undefined) {
	             navigator.geolocation.clearWatch(watchID); 
	         }
	         gitagenabled=0;
	         verticalenabledinlocation = "";
		     	globalpng ='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
	         fetch('/removegiads?requestId=' + requestId, {
	             method: 'POST'
	         }).then(response => {
	        	 
	        	 if (!response.ok) {
	        	        throw new Error("Network response was not ok");
	        	    }
	        	 
	        	 return response.json(); // ✅ Parse the JSON body
	         })
	        	 .then(data => {
	        		 /*if (requestId !== currentRequestId) return;	*/
	        		 if (requestId !== latestRequestId) return;
	        		 noofresults=data.length;
	        		  $('#noofresults').html('Results: '+noofresults) ;
	        			
	        		 	// Check if a specific class exists
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
	        		    currentAdsData=data;
	        		   
	        		      // document.getElementById("ads").innerHTML = "";
	        		   	noofresults=data.length;
	        		   //	console.log('No of Results: ' +noofresults);
	        			 $('#noofresults').html('Results: '+noofresults) ;

	        	         let x = JSON.stringify(data); 
	        	         //console.log('x length : ' +data.length);
	        	         const bounds = new google.maps.LatLngBounds();var center;    
	        	        for (var i = 0; i < markers.length; i++) {
	        		   markers[i].setMap(null); // Remove marker from the map
	        		
	        	   }
	        	locations = []; // Clear the array of markers
	        	circles.forEach(circle => {
	        	    circle.setMap(null); // Remove circle from the map
	        	});
	        	circles.length = 0; // Clear the array
	        	//Remove the previous circle if it exists
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
	        		     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
	        	         $.each(data, function (i, myList) {
	        	         	
	        	         	  var adsid = myList.id;
	        	  	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	        		     	
	        		    const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	        	 		const marker = new google.maps.Marker({
	        	 	   
	        	 	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
	        	 	        map: map3,
	        	 	        icon:globalpng
	        	 	      });
	        	markers.push(marker);	

	        	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
	        		marker.addListener('click', function() {	
	        			setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
	        			});
	        	bounds.extend(marker.position);
	        		        	  }); //.each
	        	         map3.fitBounds(bounds);
	        		        	  
	        	         center = bounds.getCenter();let maxDistance=0;
	        		    	$.each(data, function (i, myList) {
	        		    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	        		    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	        		    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	        					    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	        					    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	        		    		    	if (distance > maxDistance) { maxDistance = distance; }
	        		    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	        		    		    	});//2nd each 
	        	      //   $('#radius').empty().append(""+maxDistance/1000);
	        	       /*   circle = new google.maps.Circle({
	        	   		     map: map3,
	        	   		     radius: maxDistance, // Radius in meters
	        	   		  fillColor: '#00000000', // transparent color
	        	   	    fillOpacity: 0,         // fully transparent
	        	   		     strokeColor: '#F27C0A', // Red stroke color
	        	   		     strokeOpacity: 0.8, // Stroke opacity
	        	   		     strokeWeight: 2, // Stroke weight
	        	   		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
	        	   		   });  
	            	
	        	          circles.push(circle);*/
	             
	         });
	     } 
		
		 else{
			 gitagbutton.classList.remove("roadinactive");
		     gitagbutton.classList.add("roadactive");  	 
		 	verticalenabledinlocation = "gitagenabled";
		     document.getElementById("filter-container").style.display = "none";
		     if (templebutton.classList.contains("roadactive")) {  
			 templebutton.classList.add("roadinactive");
	         templebutton.classList.remove("roadactive");   
	       
		     }
	         if (roadbutton.classList.contains("roadactive")) {       //when clicked
	            
	            roadbutton.classList.remove("roadactive");
	             roadbutton.classList.add("roadinactive");
	         }
	         
	         if (forestbutton.classList.contains("roadactive")) {  
	    		 forestbutton.classList.add("roadinactive");
	             forestbutton.classList.remove("roadactive");   
	           
	    	     }
	         
	         //for heritage, hostpital, bus, car, goods, rickashaw
	         
	         
	             
	         if(heritagebutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 heritagebutton.classList.remove("roadactive");
	        	 heritagebutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(hospitalbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 hospitalbutton.classList.remove("roadactive");
	        	 hospitalbutton.classList.add("roadinactive");  
	         }

	         
	         if(carbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 carbutton.classList.remove("roadactive");
	        	 carbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(busbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 busbutton.classList.remove("roadactive");
	        	 busbutton.classList.add("roadinactive");  
	         }

	         
	         if(goodsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	goodsbutton.classList.remove("roadactive");
	        	 goodsbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(rickshawbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	rickshawbutton.classList.remove("roadactive");
	        	 rickshawbutton.classList.add("roadinactive");  
	         }
	         
	         if(vlogsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	vlogsbutton.classList.remove("roadactive");
	        	 vlogsbutton.classList.add("roadinactive");  
	         }
	         
	         if(newsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	newsbutton.classList.remove("roadactive");
	        	 newsbutton.classList.add("roadinactive");  
	         }
		$.ajax({
	        // Our sample url to make request 
	        url:"${pageContext.request.contextPath}/giads?requestId=" + requestId,
	        type: "GET",
	        contentType : 'application/json',
	        dataType : 'json',
	        //data:JSON.stringify({lat,lng}), 
	        success: function (data) {
	        /*	if (requestId !== currentRequestId) return;*/
	        
	        if (requestId !== latestRequestId) return;
	        	// Check if a specific class exists
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
	    	    currentAdsData=data;
	    	   
	    	      // document.getElementById("ads").innerHTML = "";
	    	   	noofresults=data.length;
	    	   //	console.log('No of Results: ' +noofresults);
	    		 $('#noofresults').html('Results: '+noofresults) ;

	             let x = JSON.stringify(data); 
	             //console.log('x length : ' +data.length);
	             const bounds = new google.maps.LatLngBounds();var center;    
	            for (var i = 0; i < markers.length; i++) {
	    	   markers[i].setMap(null); // Remove marker from the map
	    	
	       }
	    locations = []; // Clear the array of markers
	    circles.forEach(circle => {
	        circle.setMap(null); // Remove circle from the map
	    });
	    circles.length = 0; // Clear the array
	    //Remove the previous circle if it exists
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
	    	     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
	             $.each(data, function (i, myList) {
	             	
	             	  var adsid = myList.id;
	      	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	    	     	
	    	      globalpng = {
					      url: "/gitagicon3.png", // relative to your app’s static path
					      scaledSize: new google.maps.Size(20, 20), // adjust as needed
					      anchor: new google.maps.Point(20, 20),
					    };
	    	 
	    	      
	    	        const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	     		const marker = new google.maps.Marker({	     	   
	     	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
	     	        map: map3,
	     	        icon:globalpng
	     	      });
	    markers.push(marker);	

	    var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
	    	marker.addListener('click', function() {	
	    		setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
	    		});
	    bounds.extend(marker.position);
	    	        	  }); //.each
	             map3.fitBounds(bounds);
	    	        	  
	             center = bounds.getCenter();let maxDistance=0;
	    	    	$.each(data, function (i, myList) {
	    	    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	    	    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	    	    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	    				    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	    				    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	    	    		    	if (distance > maxDistance) { maxDistance = distance; }
	    	    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	    	    		    	});//2nd each 
	          //   $('#radius').empty().append(""+maxDistance/1000);
	           /*   circle = new google.maps.Circle({
	       		     map: map3,
	       		     radius: maxDistance, // Radius in meters
	       		  fillColor: '#00000000', // transparent color
	       	    fillOpacity: 0,         // fully transparent
	       		     strokeColor: '#F27C0A', // Red stroke color
	       		     strokeOpacity: 0.8, // Stroke opacity
	       		     strokeWeight: 2, // Stroke weight
	       		  fillOpacity: 0,
	       		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
	       		   });  
	              
	              circles.push(circle);*/
	        }//success
		
	})//ajax
		 }
		 }

	var templeenabled = 0;
	function templeads()
	{
			templeenabled=1;gitagenabled=0;;forestenabled=0;heritageenabled =0;hospitalenabled =0;vlogsenabledd =0; newsenabled =0;
			/*currentRequestId++;
			let requestId = currentRequestId;*/
			const requestId = generateRequestId();
			latestRequestId = requestId;
		var k=0;

		 if (templebutton.classList.contains("roadactive")) {       //when clicked to remove
	         templebutton.classList.remove("roadactive");
	         templebutton.classList.add("roadinactive");  
	         
	         document.getElementById("filter-container").style.display = "flex";
	         if (watchID !== undefined) {
	             navigator.geolocation.clearWatch(watchID); 
	         }
	         templeenabled=0;
	         verticalenabledinlocation = "";
		     	globalpng ='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
	         fetch('/removegiads?requestId=' + requestId, {
	             method: 'POST'
	         }).then(response => {
	        	 
	        	 if (!response.ok) {
	        	        throw new Error("Network response was not ok");
	        	    }
	        	 
	        	 return response.json(); // ✅ Parse the JSON body
	         })
	        	 .then(data => {
	        		 /*if (requestId !== currentRequestId) return;*/
	        		 if (requestId !== latestRequestId) return;
	        		 noofresults=data.length;
	        		  $('#noofresults').html('Results: '+noofresults) ;
	        			
	        		 	// Check if a specific class exists
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
	        		    currentAdsData=data;
	        		   
	        		      // document.getElementById("ads").innerHTML = "";
	        		   	noofresults=data.length;
	        		   //	console.log('No of Results: ' +noofresults);
	        			 $('#noofresults').html('Results: '+noofresults) ;

	        	         let x = JSON.stringify(data); 
	        	         //console.log('x length : ' +data.length);
	        	         const bounds = new google.maps.LatLngBounds();var center;    
	        	        for (var i = 0; i < markers.length; i++) {
	        		   markers[i].setMap(null); // Remove marker from the map
	        		
	        	   }
	        	locations = []; // Clear the array of markers
	        	circles.forEach(circle => {
	        	    circle.setMap(null); // Remove circle from the map
	        	});
	        	circles.length = 0; // Clear the array
	        	//Remove the previous circle if it exists
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
	        		     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
	        	         $.each(data, function (i, myList) {
	        	         	
	        	         	  var adsid = myList.id;
	        	  	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	        		     	
	        		     	
	        		 
	        		      
	        		        const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	        	 		const marker = new google.maps.Marker({
	        	 	   
	        	 	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
	        	 	        map: map3,
	        	 	        icon:globalpng
	        	 	      });
	        	markers.push(marker);	

	        	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
	        		marker.addListener('click', function() {	
	        			setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
	        			});
	        	bounds.extend(marker.position);
	        		        	  }); //.each
	        	         map3.fitBounds(bounds);
	        		        	  
	        	         center = bounds.getCenter();let maxDistance=0;
	        		    	$.each(data, function (i, myList) {
	        		    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	        		    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	        		    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	        					    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	        					    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	        		    		    	if (distance > maxDistance) { maxDistance = distance; }
	        		    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	        		    		    	});//2nd each 
	        	      //   $('#radius').empty().append(""+maxDistance/1000);
	        	   /*       circle = new google.maps.Circle({
	        	   		     map: map3,
	        	   		     radius: maxDistance, // Radius in meters
	        	   		  fillColor: '#00000000', // transparent color
	        	   	    fillOpacity: 0,         // fully transparent
	        	   		     strokeColor: '#F27C0A', // Red stroke color
	        	   		     strokeOpacity: 0.8, // Stroke opacity
	        	   		     strokeWeight: 2, // Stroke weight
	        	   		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
	        	   		   });  
	            	
	        	          circles.push(circle);*/
	             
	         });
	     } 
		
		 else{
			 templebutton.classList.remove("roadinactive");
		     templebutton.classList.add("roadactive");  	 
		 	verticalenabledinlocation = "templeenabled";
		     document.getElementById("filter-container").style.display = "none";
		     if (gitagbutton.classList.contains("roadactive")) {  
			 gitagbutton.classList.add("roadinactive");
	         gitagbutton.classList.remove("roadactive");   
	       
		     }
	         if (roadbutton.classList.contains("roadactive")) {       //when clicked
	            
	            roadbutton.classList.remove("roadactive");
	             roadbutton.classList.add("roadinactive");
	         }
	         
	         if (forestbutton.classList.contains("roadactive")) {  
	    		 forestbutton.classList.add("roadinactive");
	             forestbutton.classList.remove("roadactive");   
	           
	    	     }
	         
	         //for heritage, hostpital, bus, car, goods, rickashaw
	         
	         
	             
	         if(heritagebutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 heritagebutton.classList.remove("roadactive");
	        	 heritagebutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(hospitalbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 hospitalbutton.classList.remove("roadactive");
	        	 hospitalbutton.classList.add("roadinactive");  
	         }

	         
	         if(carbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 carbutton.classList.remove("roadactive");
	        	 carbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(busbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 busbutton.classList.remove("roadactive");
	        	 busbutton.classList.add("roadinactive");  
	         }

	         
	         if(goodsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	goodsbutton.classList.remove("roadactive");
	        	 goodsbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(rickshawbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	rickshawbutton.classList.remove("roadactive");
	        	 rickshawbutton.classList.add("roadinactive");  
	         }
	         
	         if(vlogsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	vlogsbutton.classList.remove("roadactive");
	        	 vlogsbutton.classList.add("roadinactive");  
	         }
	         
	         if(newsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	newsbutton.classList.remove("roadactive");
	        	 newsbutton.classList.add("roadinactive");  
	         }
		$.ajax({
	        // Our sample url to make request 
	        url:"${pageContext.request.contextPath}/templeads?requestId=" + requestId,
	        type: "GET",
	        contentType : 'application/json',
	        dataType : 'json',
	        //data:JSON.stringify({lat,lng}), 
	        success: function (data) {
	        	
	        	
	        	/*if (requestId !== currentRequestId) return;*/
	        	if (requestId !== latestRequestId) return;
	        	// Check if a specific class exists
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
	    	    currentAdsData=data;
	    	   
	    	      // document.getElementById("ads").innerHTML = "";
	    	   	noofresults=data.length;
	    	   //	console.log('No of Results: ' +noofresults);
	    		 $('#noofresults').html('Results: '+noofresults) ;

	             let x = JSON.stringify(data); 
	             //console.log('x length : ' +data.length);
	             const bounds = new google.maps.LatLngBounds();var center;    
	            for (var i = 0; i < markers.length; i++) {
	    	   markers[i].setMap(null); // Remove marker from the map
	    	
	       }
	    locations = []; // Clear the array of markers
	    circles.forEach(circle => {
	        circle.setMap(null); // Remove circle from the map
	    });
	    circles.length = 0; // Clear the array
	    //Remove the previous circle if it exists
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
	    	     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
	             $.each(data, function (i, myList) {
	             	
	             	  var adsid = myList.id;
	      	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	    	     	
	    	      globalpng = {
					      url: "/temple.png", // relative to your app’s static path
					      scaledSize: new google.maps.Size(20, 20), // adjust as needed
					      anchor: new google.maps.Point(20, 20),
					    };
	    	 
	    	      
	    	        const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	     		const marker = new google.maps.Marker({	     	   
	     	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
	     	        map: map3,
	     	        icon:globalpng
	     	      });
	    markers.push(marker);	

	    var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
	    	marker.addListener('click', function() {	
	    		setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
	    		});
	    bounds.extend(marker.position);
	    	        	  }); //.each
	             map3.fitBounds(bounds);
	    	        	  
	             center = bounds.getCenter();let maxDistance=0;
	    	    	$.each(data, function (i, myList) {
	    	    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	    	    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	    	    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	    				    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	    				    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	    	    		    	if (distance > maxDistance) { maxDistance = distance; }
	    	    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	    	    		    	});//2nd each 
	          //   $('#radius').empty().append(""+maxDistance/1000);
	          /*    circle = new google.maps.Circle({
	       		     map: map3,
	       		     radius: maxDistance, // Radius in meters
	       		  fillColor: '#00000000', // transparent color
	       	    fillOpacity: 0,         // fully transparent
	       		     strokeColor: '#F27C0A', // Red stroke color
	       		     strokeOpacity: 0.8, // Stroke opacity
	       		     strokeWeight: 2, // Stroke weight
	       		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
	       		   });  
	              
	              circles.push(circle);*/
	        }//success
		
	})//ajax
		 }
		 }

	var forestenabled=0;
	function forestads()
	{
			forestenabled=1;     gitagenabled=0;templeenabled =0;heritageenabled =0;hospitalenabled =0;vlogsenabledd =0; newsenabled =0;
		
		var k=0;
		/*currentRequestId++;
		let requestId = currentRequestId;*/
		
		const requestId = generateRequestId();
		latestRequestId = requestId;

		 if (forestbutton.classList.contains("roadactive")) {       //when clicked to remove
			 forestbutton.classList.remove("roadactive");
			 forestbutton.classList.add("roadinactive");  
			 
			  document.getElementById("filter-container").style.display = "flex";
	         
	         if (watchID !== undefined) {
	             navigator.geolocation.clearWatch(watchID); 
	         }
	         forestenabled=0;
	         verticalenabledinlocation = "";
		     	globalpng ='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
	         
	         fetch('/removegiads?requestId=' + requestId, {
	             method: 'POST'
	         }).then(response => {
	        	 
	        	 if (!response.ok) {
	        	        throw new Error("Network response was not ok");
	        	    }
	        	 
	        	 return response.json(); // ✅ Parse the JSON body
	         })
	        	 .then(data => {
	        	/*	 if (requestId !== currentRequestId) return;*/
	        	if (requestId !== latestRequestId) return;
	        		 noofresults=data.length;
	        		  $('#noofresults').html('Results: '+noofresults) ;
	        			
	        		 	// Check if a specific class exists
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
	        		    currentAdsData=data;
	        		   
	        		      // document.getElementById("ads").innerHTML = "";
	        		   	noofresults=data.length;
	        		   //	console.log('No of Results: ' +noofresults);
	        			 $('#noofresults').html('Results: '+noofresults) ;

	        	         let x = JSON.stringify(data); 
	        	         //console.log('x length : ' +data.length);
	        	         const bounds = new google.maps.LatLngBounds();var center;    
	        	        for (var i = 0; i < markers.length; i++) {
	        		   markers[i].setMap(null); // Remove marker from the map
	        		
	        	   }
	        	locations = []; // Clear the array of markers
	        	circles.forEach(circle => {
	        	    circle.setMap(null); // Remove circle from the map
	        	});
	        	circles.length = 0; // Clear the array
	        	//Remove the previous circle if it exists
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
	        		     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
	        	         $.each(data, function (i, myList) {
	        	         	
	        	         	  var adsid = myList.id;
	        	  	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	        		     	
	        		        const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	        	 		const marker = new google.maps.Marker({
	        	 	   
	        	 	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
	        	 	        map: map3,
	        	 	        icon:globalpng
	        	 	      });
	        	markers.push(marker);	

	        	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
	        		marker.addListener('click', function() {	
	        			setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
	        			});
	        	bounds.extend(marker.position);
	        		        	  }); //.each
	        	         map3.fitBounds(bounds);
	        		        	  
	        	         center = bounds.getCenter();let maxDistance=0;
	        		    	$.each(data, function (i, myList) {
	        		    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	        		    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	        		    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	        					    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	        					    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	        		    		    	if (distance > maxDistance) { maxDistance = distance; }
	        		    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	        		    		    	});//2nd each 
	        	      //   $('#radius').empty().append(""+maxDistance/1000);
	        	        /*  circle = new google.maps.Circle({
	        	   		     map: map3,
	        	   		     radius: maxDistance, // Radius in meters
	        	   		  fillColor: '#00000000', // transparent color
	        	   	    fillOpacity: 0,         // fully transparent
	        	   		     strokeColor: '#F27C0A', // Red stroke color
	        	   		     strokeOpacity: 0.8, // Stroke opacity
	        	   		     strokeWeight: 2, // Stroke weight
	        	   		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
	        	   		   });  
	            	
	        	          circles.push(circle);	*/
	            	    
	         });//.then

	     } 
		
		 else{
			 forestbutton.classList.remove("roadinactive");
			 forestbutton.classList.add("roadactive");  	 
				verticalenabledinlocation = "forestenabled";
			  document.getElementById("filter-container").style.display = "none";
		     if (gitagbutton.classList.contains("roadactive")) {  
			 gitagbutton.classList.add("roadinactive");
	         gitagbutton.classList.remove("roadactive");   
	       
		     }
	         if (roadbutton.classList.contains("roadactive")) {       //when clicked
	            
	            roadbutton.classList.remove("roadactive");
	             roadbutton.classList.add("roadinactive");
	         }
	         
	         if (templebutton.classList.contains("roadactive")) {       //when clicked
	             
	             templebutton.classList.remove("roadactive");
	              templebutton.classList.add("roadinactive");
	          }
	         
	         //for heritage, hostpital, bus, car, goods, rickashaw
	             
	         if(heritagebutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 heritagebutton.classList.remove("roadactive");
	        	 heritagebutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(hospitalbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 hospitalbutton.classList.remove("roadactive");
	        	 hospitalbutton.classList.add("roadinactive");  
	         }

	         
	         if(carbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 carbutton.classList.remove("roadactive");
	        	 carbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(busbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 busbutton.classList.remove("roadactive");
	        	 busbutton.classList.add("roadinactive");  
	         }

	         
	         if(goodsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	goodsbutton.classList.remove("roadactive");
	        	 goodsbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(rickshawbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	rickshawbutton.classList.remove("roadactive");
	        	 rickshawbutton.classList.add("roadinactive");  
	         }
	         
	         if(vlogsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	vlogsbutton.classList.remove("roadactive");
	        	 vlogsbutton.classList.add("roadinactive");  
	         }
	         
	         if(newsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	newsbutton.classList.remove("roadactive");
	        	 newsbutton.classList.add("roadinactive");  
	         }
		$.ajax({
	        // Our sample url to make request 
	        url:"${pageContext.request.contextPath}/forestads?requestId=" + requestId,
	        type: "GET",
	        contentType : 'application/json',
	        dataType : 'json',
	        //data:JSON.stringify({lat,lng}), 
	        success: function (data) {
	        	/*if (requestId !== currentRequestId) return;*/
	        	if (requestId !== latestRequestId) return;
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
	    	    currentAdsData=data;
	    	   
	    	      // document.getElementById("ads").innerHTML = "";
	    	   	noofresults=data.length;
	    	   //	console.log('No of Results: ' +noofresults);
	    		 $('#noofresults').html('Results: '+noofresults) ;

	             let x = JSON.stringify(data); 
	             //console.log('x length : ' +data.length);
	             const bounds = new google.maps.LatLngBounds();var center;    
	            for (var i = 0; i < markers.length; i++) {
	    	   markers[i].setMap(null); // Remove marker from the map
	    	
	       }
	    locations = []; // Clear the array of markers
	    circles.forEach(circle => {
	        circle.setMap(null); // Remove circle from the map
	    });
	    circles.length = 0; // Clear the array
	    //Remove the previous circle if it exists
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
	    	     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
	             $.each(data, function (i, myList) {
	             	
	             	  var adsid = myList.id;
	      	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	    	      globalpng = {
					      url: "/forest.png", // relative to your app’s static path
					      scaledSize: new google.maps.Size(20, 20), // adjust as needed
					      anchor: new google.maps.Point(20, 20),
					    };
	    	     	
	    	 
	    	      
	    	        const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	     		const marker = new google.maps.Marker({
	     	   
	     	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
	     	        map: map3,
	     	        icon:globalpng
	     	      });
	    markers.push(marker);	

	    var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
	    	marker.addListener('click', function() {	
	    		setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
	    		});
	    bounds.extend(marker.position);
	    	        	  }); //.each
	             map3.fitBounds(bounds);
	    	        	  
	             center = bounds.getCenter();let maxDistance=0;
	    	    	$.each(data, function (i, myList) {
	    	    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	    	    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	    	    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	    				    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	    				    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	    	    		    	if (distance > maxDistance) { maxDistance = distance; }
	    	    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	    	    		    	});//2nd each 
	          //   $('#radius').empty().append(""+maxDistance/1000);
	       /*       circle = new google.maps.Circle({
	       		     map: map3,
	       		     radius: maxDistance, // Radius in meters
	       		  fillColor: '#00000000', // transparent color
	       	    fillOpacity: 0,         // fully transparent
	       		     strokeColor: '#F27C0A', // Red stroke color
	       		     strokeOpacity: 0.8, // Stroke opacity
	       		     strokeWeight: 2, // Stroke weight
	       		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
	       		   });  
	
	              circles.push(circle);*/
	        }//success
		
	})//ajax
		 }
		 }


	var heritageenabled = 0;
	function heritageads()
	{
		heritageenabled=1;     gitagenabled=0;templeenabled =0;forestenabled=0;hospitalenabled=0;vlogsenabledd = 0; newsenabled =0; 
		
		var k=0;
		const requestId = generateRequestId();
		latestRequestId = requestId;
		 if (heritagebutton.classList.contains("roadactive")) {       //when clicked to remove
			 heritagebutton.classList.remove("roadactive");
			 heritagebutton.classList.add("roadinactive");  
			 
			  document.getElementById("filter-container").style.display = "flex";
	         
	         if (watchID !== undefined) {
	             navigator.geolocation.clearWatch(watchID); 
	         }
	         heritageenabled=0;
	         verticalenabledinlocation = "";
		     	globalpng ='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
	         fetch('/removegiads?requestId=' + requestId, {
	             method: 'POST'
	         }).then(response => {
	        	 
	        	 if (!response.ok) {
	        	        throw new Error("Network response was not ok");
	        	    }
	        	 
	        	 return response.json(); // ✅ Parse the JSON body
	         })
	        	 .then(data => {
	        		 if (requestId !== latestRequestId) return;
	        		 noofresults=data.length;
	        		  $('#noofresults').html('Results: '+noofresults) ;
	        			
	        		 	// Check if a specific class exists
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
	        		    currentAdsData=data;
	        		   
	        		      // document.getElementById("ads").innerHTML = "";
	        		   	noofresults=data.length;
	        		   //	console.log('No of Results: ' +noofresults);
	        			 $('#noofresults').html('Results: '+noofresults) ;

	        	         let x = JSON.stringify(data); 
	        	         //console.log('x length : ' +data.length);
	        	         const bounds = new google.maps.LatLngBounds();var center;    
	        	        for (var i = 0; i < markers.length; i++) {
	        		   markers[i].setMap(null); // Remove marker from the map
	        		
	        	   }
	        	locations = []; // Clear the array of markers
	        	circles.forEach(circle => {
	        	    circle.setMap(null); // Remove circle from the map
	        	});
	        	circles.length = 0; // Clear the array
	        	//Remove the previous circle if it exists
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
	        		     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
	        	         $.each(data, function (i, myList) {
	        	         	
	        	         	  var adsid = myList.id;
	        	  	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	     
	        		        const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	        	 		const marker = new google.maps.Marker({
	        	 	   
	        	 	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
	        	 	        map: map3,
	        	 	        icon:globalpng
	        	 	      });
	        	markers.push(marker);	

	        	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
	        		marker.addListener('click', function() {	
	        			setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
	        			});
	        	bounds.extend(marker.position);
	        		        	  }); //.each
	        	         map3.fitBounds(bounds);
	        		        	  
	        	         center = bounds.getCenter();let maxDistance=0;
	        		    	$.each(data, function (i, myList) {
	        		    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	        		    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	        		    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	        					    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	        					    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	        		    		    	if (distance > maxDistance) { maxDistance = distance; }
	        		    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	        		    		    	});//2nd each 
	        	      //   $('#radius').empty().append(""+maxDistance/1000);
	        	     /*     circle = new google.maps.Circle({
	        	   		     map: map3,
	        	   		     radius: maxDistance, // Radius in meters
	        	   		  fillColor: '#00000000', // transparent color
	        	   	    fillOpacity: 0,         // fully transparent
	        	   		     strokeColor: '#F27C0A', // Red stroke color
	        	   		     strokeOpacity: 0.8, // Stroke opacity
	        	   		     strokeWeight: 2, // Stroke weight
	        	   		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
	        	   		   });  
	        	          circles.push(circle);*/
	         });

	     } 
		
		 else{
			 heritagebutton.classList.remove("roadinactive");
			 heritagebutton.classList.add("roadactive");  	 
				verticalenabledinlocation = "heritageenabled";
			  document.getElementById("filter-container").style.display = "none";
		     if (gitagbutton.classList.contains("roadactive")) {  
			 gitagbutton.classList.add("roadinactive");
	         gitagbutton.classList.remove("roadactive");   
	       
		     }
	         if (roadbutton.classList.contains("roadactive")) {       //when clicked
	            
	            roadbutton.classList.remove("roadactive");
	             roadbutton.classList.add("roadinactive");
	         }
	         
	         if (templebutton.classList.contains("roadactive")) {       //when clicked
	             
	             templebutton.classList.remove("roadactive");
	              templebutton.classList.add("roadinactive");
	          }
	         
	         //for heritage, hostpital, bus, car, goods, rickashaw
	         
	             
	         if(forestbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 forestbutton.classList.remove("roadactive");
	        	 forestbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(hospitalbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 hospitalbutton.classList.remove("roadactive");
	        	 hospitalbutton.classList.add("roadinactive");  
	         }

	         
	         if(carbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 carbutton.classList.remove("roadactive");
	        	 carbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(busbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 busbutton.classList.remove("roadactive");
	        	 busbutton.classList.add("roadinactive");  
	         }

	         
	         if(goodsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	goodsbutton.classList.remove("roadactive");
	        	 goodsbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(rickshawbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	rickshawbutton.classList.remove("roadactive");
	        	 rickshawbutton.classList.add("roadinactive");  
	         }
	         
	         if(vlogsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	vlogsbutton.classList.remove("roadactive");
	        	 vlogsbutton.classList.add("roadinactive");  
	         }
	         
	         if(newsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	newsbutton.classList.remove("roadactive");
	        	 newsbutton.classList.add("roadinactive");  
	         }
		$.ajax({
	        // Our sample url to make request 
	        url:"${pageContext.request.contextPath}/heritageads?requestId=" + requestId,
	        type: "GET",
	        contentType : 'application/json',
	        dataType : 'json',
	        //data:JSON.stringify({lat,lng}), 
	        success: function (data) {
	        	if (requestId !== latestRequestId) return;
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
	    	    currentAdsData=data;
	    	   
	    	      // document.getElementById("ads").innerHTML = "";
	    	   	noofresults=data.length;
	    	   //	console.log('No of Results: ' +noofresults);
	    		 $('#noofresults').html('Results: '+noofresults) ;

	             let x = JSON.stringify(data); 
	             //console.log('x length : ' +data.length);
	             const bounds = new google.maps.LatLngBounds();var center;    
	            for (var i = 0; i < markers.length; i++) {
	    	   markers[i].setMap(null); // Remove marker from the map
	    	
	       }
	    locations = []; // Clear the array of markers
	    circles.forEach(circle => {
	        circle.setMap(null); // Remove circle from the map
	    });
	    circles.length = 0; // Clear the array
	    //Remove the previous circle if it exists
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
	    	     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
	             $.each(data, function (i, myList) {
	             	
	             	  var adsid = myList.id;
	      	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	    	     	
	    	 globalpng = {
					      url: "/hampiheritage4.jpg", // relative to your app’s static path
					      scaledSize: new google.maps.Size(20, 20), // adjust as needed
					      anchor: new google.maps.Point(20, 20),
					    };
	    	 
	    	      
	    	        const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	     		const marker = new google.maps.Marker({
	     	   
	     	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
	     	        map: map3,
	     	        icon:globalpng
	     	      });
	    markers.push(marker);	

	    var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
	    	marker.addListener('click', function() {	
	    		setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
	    		});
	    bounds.extend(marker.position);
	    	        	  }); //.each
	             map3.fitBounds(bounds);
	    	        	  
	             center = bounds.getCenter();let maxDistance=0;
	    	    	$.each(data, function (i, myList) {
	    	    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	    	    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	    	    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	    				    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	    				    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	    	    		    	if (distance > maxDistance) { maxDistance = distance; }
	    	    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	    	    		    	});//2nd each 
	          //   $('#radius').empty().append(""+maxDistance/1000);
	        /*      circle = new google.maps.Circle({
	       		     map: map3,
	       		     radius: maxDistance, // Radius in meters
	       		  fillColor: '#00000000', // transparent color
	       	    fillOpacity: 0,         // fully transparent
	       		     strokeColor: '#F27C0A', // Red stroke color
	       		     strokeOpacity: 0.8, // Stroke opacity
	       		     strokeWeight: 2, // Stroke weight
	       		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
	       		   });  
	     

	              circles.push(circle);*/

	        }//success
		
	})//ajax
		 }
		 }
		 
		 
		 //hospital
		 
		 var hospitalenabled = 0;
	function hospitalads()
	{
		hospitalenabled=1; gitagenabled=0;templeenabled =0;forestenabled=0;heritageenabled =0;vlogsenabledd =0;newsenabled =0;
		
		var k=0;
		const requestId = generateRequestId();
		latestRequestId = requestId;
		 if (hospitalbutton.classList.contains("roadactive")) {       //when clicked to remove
			 hospitalbutton.classList.remove("roadactive");
			 hospitalbutton.classList.add("roadinactive");  
	         
			 
			  document.getElementById("filter-container").style.display = "flex";
	         if (watchID !== undefined) {
	             navigator.geolocation.clearWatch(watchID); 
	         }
	         hospitalenabled=0;
	         verticalenabledinlocation = "";
		     	globalpng ='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
	         
	         fetch('/removegiads?requestId=' + requestId, {
	             method: 'POST'
	         }).then(response => {
	        	 
	        	 if (!response.ok) {
	        	        throw new Error("Network response was not ok");
	        	    }
	        	 
	        	 return response.json(); // ✅ Parse the JSON body
	         })
	        	 .then(data => {
	        		 if (requestId !== latestRequestId) return;
	        		 noofresults=data.length;
	        		  $('#noofresults').html('Results: '+noofresults) ;
	        			
	        		 	// Check if a specific class exists
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
	        		    currentAdsData=data;
	        		   
	        		      // document.getElementById("ads").innerHTML = "";
	        		   	noofresults=data.length;
	        		   //	console.log('No of Results: ' +noofresults);
	        			 $('#noofresults').html('Results: '+noofresults) ;

	        	         let x = JSON.stringify(data); 
	        	         //console.log('x length : ' +data.length);
	        	         const bounds = new google.maps.LatLngBounds();var center;    
	        	        for (var i = 0; i < markers.length; i++) {
	        		   markers[i].setMap(null); // Remove marker from the map
	        		
	        	   }
	        	locations = []; // Clear the array of markers
	        	circles.forEach(circle => {
	        	    circle.setMap(null); // Remove circle from the map
	        	});
	        	circles.length = 0; // Clear the array
	        	//Remove the previous circle if it exists
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
	        		     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
	        	         $.each(data, function (i, myList) {
	        	         	
	        	         	  var adsid = myList.id;
	        	  	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
	        	  	     	// console.log('phno : ' +phno);	var whatsapp = myList.whatsappNumber;
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
	        		     	
	        		     	
	        		 
	        		      
	        		        const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	        	 		const marker = new google.maps.Marker({
	        	 	   
	        	 	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
	        	 	        map: map3,
	        	 	        icon:globalpng
	        	 	      });
	        	markers.push(marker);	

	        	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
	        		marker.addListener('click', function() {	
	        			setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
	        			});
	        	bounds.extend(marker.position);
	        		        	  }); //.each
	        	         map3.fitBounds(bounds);
	        		        	  
	        	         center = bounds.getCenter();let maxDistance=0;
	        		    	$.each(data, function (i, myList) {
	        		    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	        		    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	        		    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	        					    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	        					    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	        		    		    	if (distance > maxDistance) { maxDistance = distance; }
	        		    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	        		    		    	});//2nd each 
	        	      //   $('#radius').empty().append(""+maxDistance/1000);
	        	        /*  circle = new google.maps.Circle({
	        	   		     map: map3,
	        	   		     radius: maxDistance, // Radius in meters
	        	   		  fillColor: '#00000000', // transparent color
	        	   	    fillOpacity: 0,         // fully transparent
	        	   		     strokeColor: '#F27C0A', // Red stroke color
	        	   		     strokeOpacity: 0.8, // Stroke opacity
	        	   		     strokeWeight: 2, // Stroke weight
	        	   		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
	        	   		   });           	
	        	          circles.push(circle);*/
	             
	         });

	     } 
		
		 else{
			 hospitalbutton.classList.remove("roadinactive");
			 hospitalbutton.classList.add("roadactive");  	 
				verticalenabledinlocation = "hospitalenabled";
			  document.getElementById("filter-container").style.display = "none";
		     if (gitagbutton.classList.contains("roadactive")) {  
			 gitagbutton.classList.add("roadinactive");
	         gitagbutton.classList.remove("roadactive");   
	       
		     }
	         if (roadbutton.classList.contains("roadactive")) {       //when clicked
	            
	            roadbutton.classList.remove("roadactive");
	             roadbutton.classList.add("roadinactive");
	         }
	         
	         if (templebutton.classList.contains("roadactive")) {       //when clicked
	             
	             templebutton.classList.remove("roadactive");
	              templebutton.classList.add("roadinactive");
	          }
	         
	         //for heritage, hostpital, bus, car, goods, rickashaw
	         
	               
	         if(forestbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 forestbutton.classList.remove("roadactive");
	        	 forestbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(heritagebutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 heritagebutton.classList.remove("roadactive");
	        	 heritagebutton.classList.add("roadinactive");  
	         }

	         
	         if(carbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 carbutton.classList.remove("roadactive");
	        	 carbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(busbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 busbutton.classList.remove("roadactive");
	        	 busbutton.classList.add("roadinactive");  
	         }

	         
	         if(goodsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	goodsbutton.classList.remove("roadactive");
	        	 goodsbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(rickshawbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	rickshawbutton.classList.remove("roadactive");
	        	 rickshawbutton.classList.add("roadinactive");  
	         }
	         
	         if(vlogsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	vlogsbutton.classList.remove("roadactive");
	        	 vlogsbutton.classList.add("roadinactive");  
	         }
	         
	         if(newsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	newsbutton.classList.remove("roadactive");
	        	 newsbutton.classList.add("roadinactive");  
	         }
		$.ajax({
	        // Our sample url to make request 
	        url:"${pageContext.request.contextPath}/hospitalads?requestId=" + requestId,
	        type: "GET",
	        contentType : 'application/json',
	        dataType : 'json',
	        //data:JSON.stringify({lat,lng}), 
	        success: function (data) {
	        	if (requestId !== latestRequestId) return;
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
	    	    currentAdsData=data;
	    	   
	    	      // document.getElementById("ads").innerHTML = "";
	    	   	noofresults=data.length;
	    	   //	console.log('No of Results: ' +noofresults);
	    		 $('#noofresults').html('Results: '+noofresults) ;

	             let x = JSON.stringify(data); 
	             //console.log('x length : ' +data.length);
	             const bounds = new google.maps.LatLngBounds();var center;    
	            for (var i = 0; i < markers.length; i++) {
	    	   markers[i].setMap(null); // Remove marker from the map
	    	
	       }
	    locations = []; // Clear the array of markers
	    circles.forEach(circle => {
	        circle.setMap(null); // Remove circle from the map
	    });
	    circles.length = 0; // Clear the array
	    //Remove the previous circle if it exists
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
	    	     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
	             $.each(data, function (i, myList) {
	             	
	             	  var adsid = myList.id;
	      	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	    	     	
	    	    globalpng = {
					      url: "/hospital.png", // relative to your app’s static path
					      scaledSize: new google.maps.Size(20, 20), // adjust as needed
					      anchor: new google.maps.Point(20, 20),
					    };
	    	 
	    	      
	    	        const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	     		const marker = new google.maps.Marker({
	     	   
	     	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
	     	        map: map3,
	     	        icon:globalpng
	     	      });
	    markers.push(marker);	

	    var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
	    	marker.addListener('click', function() {	
	    		setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
	    		});
	    bounds.extend(marker.position);
	    	        	  }); //.each
	             map3.fitBounds(bounds);
	    	        	  
	             center = bounds.getCenter();let maxDistance=0;
	    	    	$.each(data, function (i, myList) {
	    	    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	    	    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	    	    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	    				    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	    				    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	    	    		    	if (distance > maxDistance) { maxDistance = distance; }
	    	    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	    	    		    	});//2nd each 
	          //   $('#radius').empty().append(""+maxDistance/1000);
	   /*           circle = new google.maps.Circle({
	       		     map: map3,
	       		     radius: maxDistance, // Radius in meters
	       		  fillColor: '#00000000', // transparent color
	       	    fillOpacity: 0,         // fully transparent
	       		     strokeColor: '#F27C0A', // Red stroke color
	       		     strokeOpacity: 0.8, // Stroke opacity
	       		     strokeWeight: 2, // Stroke weight
	       		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
	       		   });  
	     
	              circles.push(circle);*/
	        }//success
		
	})//ajax
		 }
		 }
		 
		 
		 //hospital ends

		 
	//bus start	 
		 
		  var busenabled = 0;
	function busads()
	{
		busenabled=1;carenabled=0; rickshawenabled=0;goodsenabled=0;vlogsenabledd =0; newsenabled = 0;
		
		var k=0;

		const requestId = generateRequestId();
		latestRequestId = requestId;
		 if (busbutton.classList.contains("roadactive")) {       //when clicked to remove
			 busbutton.classList.remove("roadactive");
			busbutton.classList.add("roadinactive");  
			
			  document.getElementById("filter-container").style.display = "flex";
	         
	         if (watchID !== undefined) {
	             navigator.geolocation.clearWatch(watchID); 
	         }
	         busenabled=0;
	         verticalenabledinlocation = "";
		     	globalpng ='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
	         fetch('/removegiads?requestId=' + requestId, {
	             method: 'POST'
	         }).then(response => {
	        	 
	        	 if (!response.ok) {
	        	        throw new Error("Network response was not ok");
	        	    }
	        	 
	        	 return response.json(); // ✅ Parse the JSON body
	         })
	        	 .then(data => {
	        		 if (requestId !== latestRequestId) return;
	        		 noofresults=data.length;
	        		  $('#noofresults').html('Results: '+noofresults) ;
	        			
	        		 	// Check if a specific class exists
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
	        		    currentAdsData=data;
	        		   
	        		      // document.getElementById("ads").innerHTML = "";
	        		   	noofresults=data.length;
	        		   //	console.log('No of Results: ' +noofresults);
	        			 $('#noofresults').html('Results: '+noofresults) ;

	        	         let x = JSON.stringify(data); 
	        	         //console.log('x length : ' +data.length);
	        	         const bounds = new google.maps.LatLngBounds();var center;    
	        	        for (var i = 0; i < markers.length; i++) {
	        		   markers[i].setMap(null); // Remove marker from the map
	        		
	        	   }
	        	locations = []; // Clear the array of markers
	        	circles.forEach(circle => {
	        	    circle.setMap(null); // Remove circle from the map
	        	});
	        	circles.length = 0; // Clear the array
	        	//Remove the previous circle if it exists
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
	        		     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
	        	         $.each(data, function (i, myList) {
	        	         	
	        	         	  var adsid = myList.id;
	        	  	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	        		     	
	        		     	
	        		 
	        		      
	        		        const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	        	 		const marker = new google.maps.Marker({
	        	 	   
	        	 	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
	        	 	        map: map3,
	        	 	        icon:globalpng
	        	 	      });
	        	markers.push(marker);	

	        	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
	        		marker.addListener('click', function() {	
	        			setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
	        			});
	        	bounds.extend(marker.position);
	        		        	  }); //.each
	        	         map3.fitBounds(bounds);
	        		        	  
	        	         center = bounds.getCenter();let maxDistance=0;
	        		    	$.each(data, function (i, myList) {
	        		    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	        		    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	        		    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	        					    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	        					    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	        		    		    	if (distance > maxDistance) { maxDistance = distance; }
	        		    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	        		    		    	});//2nd each 
	        	      //   $('#radius').empty().append(""+maxDistance/1000);
	        	      /*    circle = new google.maps.Circle({
	        	   		     map: map3,
	        	   		     radius: maxDistance, // Radius in meters
	        	   		  fillColor: '#00000000', // transparent color
	        	   	    fillOpacity: 0,         // fully transparent
	        	   		     strokeColor: '#F27C0A', // Red stroke color
	        	   		     strokeOpacity: 0.8, // Stroke opacity
	        	   		     strokeWeight: 2, // Stroke weight
	        	   		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
	        	   		   });           	        
	        	          circles.push(circle);*/
	         });

	     } 
		
		 else{
			 busbutton.classList.remove("roadinactive");
			 busbutton.classList.add("roadactive");  	 
				verticalenabledinlocation = "busenabled";
			  document.getElementById("filter-container").style.display = "none";
		     if (gitagbutton.classList.contains("roadactive")) {  
			 gitagbutton.classList.add("roadinactive");
	         gitagbutton.classList.remove("roadactive");   
	       
		     }
	         if (roadbutton.classList.contains("roadactive")) {       //when clicked
	            
	            roadbutton.classList.remove("roadactive");
	             roadbutton.classList.add("roadinactive");
	         }
	         
	         if (templebutton.classList.contains("roadactive")) {       //when clicked
	             
	             templebutton.classList.remove("roadactive");
	              templebutton.classList.add("roadinactive");
	          }
	         
	         //for heritage, hostpital, bus, car, goods, rickashaw
	         
	          if(forestbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 forestbutton.classList.remove("roadactive");
	        	 forestbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(heritagebutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 heritagebutton.classList.remove("roadactive");
	        	 heritagebutton.classList.add("roadinactive");  
	         }

	         
	         if(carbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 carbutton.classList.remove("roadactive");
	        	 carbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(hospitalbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 hospitalbutton.classList.remove("roadactive");
	        	 hospitalbutton.classList.add("roadinactive");  
	         }

	         
	         if(goodsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	goodsbutton.classList.remove("roadactive");
	        	 goodsbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(rickshawbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	rickshawbutton.classList.remove("roadactive");
	        	 rickshawbutton.classList.add("roadinactive");  
	         }
	         
	         if(vlogsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	vlogsbutton.classList.remove("roadactive");
	        	 vlogsbutton.classList.add("roadinactive");  
	         }
	         
	         if(newsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	newsbutton.classList.remove("roadactive");
	        	 newsbutton.classList.add("roadinactive");  
	         }
		$.ajax({
	        // Our sample url to make request 
	        url:"${pageContext.request.contextPath}/busads?requestId=" + requestId,
	        type: "GET",
	        contentType : 'application/json',
	        dataType : 'json',
	        //data:JSON.stringify({lat,lng}), 
	        success: function (data) {
	        	if (requestId !== latestRequestId) return;
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
	    	    currentAdsData=data;
	    	   
	    	      // document.getElementById("ads").innerHTML = "";
	    	   	noofresults=data.length;
	    	   //	console.log('No of Results: ' +noofresults);
	    		 $('#noofresults').html('Results: '+noofresults) ;

	             let x = JSON.stringify(data); 
	             //console.log('x length : ' +data.length);
	             const bounds = new google.maps.LatLngBounds();var center;    
	            for (var i = 0; i < markers.length; i++) {
	    	   markers[i].setMap(null); // Remove marker from the map
	    	
	       }
	    locations = []; // Clear the array of markers
	    circles.forEach(circle => {
	        circle.setMap(null); // Remove circle from the map
	    });
	    circles.length = 0; // Clear the array
	    //Remove the previous circle if it exists
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
	    	     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
	             $.each(data, function (i, myList) {
	             	
	             	  var adsid = myList.id;
	      	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	    	     	
	    	     	
	    	       globalpng = {
					      url: "/bus.png", // relative to your app’s static path
					      scaledSize: new google.maps.Size(20, 20), // adjust as needed
					      anchor: new google.maps.Point(20, 20),
					    };
	    	      
	    	    const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	     		const marker = new google.maps.Marker({
	     	   
	     	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
	     	        map: map3,
	     	        icon:globalpng
	     	      });
	    markers.push(marker);	

	    var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp,adsid:adsid}
	    marker.addListener('click', function() {	
    		setTimeout(() => { showCardforvehicles(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
    		});
	    bounds.extend(marker.position);
	    	        	  }); //.each
	             map3.fitBounds(bounds);
	    	        	  
	             center = bounds.getCenter();let maxDistance=0;
	    	    	$.each(data, function (i, myList) {
	    	    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	    	    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	    	    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	    				    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	    				    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	    	    		    	if (distance > maxDistance) { maxDistance = distance; }
	    	    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	    	    		    	});//2nd each 
	          //   $('#radius').empty().append(""+maxDistance/1000);
	            /*  circle = new google.maps.Circle({
	       		     map: map3,
	       		     radius: maxDistance, // Radius in meters
	       		  fillColor: '#00000000', // transparent color
	       	    fillOpacity: 0,         // fully transparent
	       		     strokeColor: '#F27C0A', // Red stroke color
	       		     strokeOpacity: 0.8, // Stroke opacity
	       		     strokeWeight: 2, // Stroke weight
	       		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
	       		   });  

	              circles.push(circle);*/
	        }//success
		
	})//ajax
		 }
		 }
		 

		 
		 //bus end
		 
		 //car start
		 	 
		  var carenabled = 0;
	function carads()
	{
		carenabled=1;
		busenabled=0;rickshawenabled=0;goodsenabled=0;vlogsenabledd =0; newsenabled =0;
		var k=0;
		const requestId = generateRequestId();
		latestRequestId = requestId;

		 if (carbutton.classList.contains("roadactive")) {       //when clicked to remove
			 carbutton.classList.remove("roadactive");
			 carbutton.classList.add("roadinactive");  
			 
			  document.getElementById("filter-container").style.display = "flex";
	         
	         if (watchID !== undefined) {
	             navigator.geolocation.clearWatch(watchID); 
	         }
	         carenabled=0;
	         verticalenabledinlocation = "";
		     	globalpng ='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
	         
	         fetch('/removegiads?requestId=' + requestId, {
	             method: 'POST'
	         }).then(response => {
	        	 
	        	 if (!response.ok) {
	        	        throw new Error("Network response was not ok");
	        	    }
	        	 
	        	 return response.json(); // ✅ Parse the JSON body
	         })
	        	 .then(data => {
	        		 if (requestId !== latestRequestId) return;
	        		 noofresults=data.length;
	        		  $('#noofresults').html('Results: '+noofresults) ;
	        			
	        		 	// Check if a specific class exists
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
	        		    currentAdsData=data;
	        		   
	        		      // document.getElementById("ads").innerHTML = "";
	        		   	noofresults=data.length;
	        		   //	console.log('No of Results: ' +noofresults);
	        			 $('#noofresults').html('Results: '+noofresults) ;

	        	         let x = JSON.stringify(data); 
	        	         //console.log('x length : ' +data.length);
	        	         const bounds = new google.maps.LatLngBounds();var center;    
	        	        for (var i = 0; i < markers.length; i++) {
	        		   markers[i].setMap(null); // Remove marker from the map
	        		
	        	   }
	        	locations = []; // Clear the array of markers
	        	circles.forEach(circle => {
	        	    circle.setMap(null); // Remove circle from the map
	        	});
	        	circles.length = 0; // Clear the array
	        	//Remove the previous circle if it exists
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
	        		     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
	        	         $.each(data, function (i, myList) {
	        	         	
	        	         	  var adsid = myList.id;
	        	  	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	        		     	
	        		     	
	        		 
	        		      
	        		        const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	        	 		const marker = new google.maps.Marker({
	        	 	   
	        	 	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
	        	 	        map: map3,
	        	 	        icon:globalpng
	        	 	      });
	        	markers.push(marker);	

	        	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
	        		marker.addListener('click', function() {	
	        			setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
	        			});
	        	bounds.extend(marker.position);
	        		        	  }); //.each
	        	         map3.fitBounds(bounds);
	        		        	  
	        	         center = bounds.getCenter();let maxDistance=0;
	        		    	$.each(data, function (i, myList) {
	        		    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	        		    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	        		    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	        					    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	        					    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	        		    		    	if (distance > maxDistance) { maxDistance = distance; }
	        		    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	        		    		    	});//2nd each 
	        	      //   $('#radius').empty().append(""+maxDistance/1000);
	        	    /*      circle = new google.maps.Circle({
	        	   		     map: map3,
	        	   		     radius: maxDistance, // Radius in meters
	        	   		  fillColor: '#00000000', // transparent color
	        	   	    fillOpacity: 0,         // fully transparent
	        	   		     strokeColor: '#F27C0A', // Red stroke color
	        	   		     strokeOpacity: 0.8, // Stroke opacity
	        	   		     strokeWeight: 2, // Stroke weight
	        	   		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
	        	   		   });           	        

	        	          circles.push(circle);*/

	             
	         });

	     } 
		
		 else{
			 carbutton.classList.remove("roadinactive");
			 carbutton.classList.add("roadactive");  	 
				verticalenabledinlocation = "carenabled";
			  document.getElementById("filter-container").style.display = "none";
		     if (gitagbutton.classList.contains("roadactive")) {  
			 gitagbutton.classList.add("roadinactive");
	         gitagbutton.classList.remove("roadactive");   
	       
		     }
	         if (roadbutton.classList.contains("roadactive")) {       //when clicked
	            
	            roadbutton.classList.remove("roadactive");
	             roadbutton.classList.add("roadinactive");
	         }
	         
	         if (templebutton.classList.contains("roadactive")) {       //when clicked
	             
	             templebutton.classList.remove("roadactive");
	              templebutton.classList.add("roadinactive");
	          }
	         
	         //for heritage, hostpital, bus, car, goods, rickashaw
	         if(forestbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 forestbutton.classList.remove("roadactive");
	        	 forestbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(heritagebutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 heritagebutton.classList.remove("roadactive");
	        	 heritagebutton.classList.add("roadinactive");  
	         }

	         
	         if(busbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	busbutton.classList.remove("roadactive");
	        	busbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(hospitalbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 hospitalbutton.classList.remove("roadactive");
	        	 hospitalbutton.classList.add("roadinactive");  
	         }

	         
	         if(goodsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	goodsbutton.classList.remove("roadactive");
	        	 goodsbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(rickshawbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	rickshawbutton.classList.remove("roadactive");
	        	 rickshawbutton.classList.add("roadinactive");  
	         }
	         
	         if(vlogsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	vlogsbutton.classList.remove("roadactive");
	        	 vlogsbutton.classList.add("roadinactive");  
	         }
	         
	         if(newsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	newsbutton.classList.remove("roadactive");
	        	 newsbutton.classList.add("roadinactive");  
	         }
		$.ajax({
	        // Our sample url to make request 
	        url:"${pageContext.request.contextPath}/carads?requestId=" + requestId,
	        type: "GET",
	        contentType : 'application/json',
	        dataType : 'json',
	        //data:JSON.stringify({lat,lng}), 
	        success: function (data) {
	        	
	        	if (requestId !== latestRequestId) return;
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
	    	    currentAdsData=data;
	    	   
	    	      // document.getElementById("ads").innerHTML = "";
	    	   	noofresults=data.length;
	    	   //	console.log('No of Results: ' +noofresults);
	    		 $('#noofresults').html('Results: '+noofresults) ;

	             let x = JSON.stringify(data); 
	             //console.log('x length : ' +data.length);
	             const bounds = new google.maps.LatLngBounds();var center;    
	            for (var i = 0; i < markers.length; i++) {
	    	   markers[i].setMap(null); // Remove marker from the map
	    	
	       }
	    locations = []; // Clear the array of markers
	    circles.forEach(circle => {
	        circle.setMap(null); // Remove circle from the map
	    });
	    circles.length = 0; // Clear the array
	    //Remove the previous circle if it exists
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
	    	     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
	             $.each(data, function (i, myList) {
	             	
	             	  var adsid = myList.id;
	      	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	    	     	
	    	      globalpng = {
					      url: "/car.png", // relative to your app’s static path
					      scaledSize: new google.maps.Size(20, 20), // adjust as needed
					      anchor: new google.maps.Point(20, 20),
					    };  	
	    	 
	    	      
	    	    const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	     		const marker = new google.maps.Marker({
	     	   
	     	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
	     	        map: map3,
	     	        icon:globalpng
	     	      });
	    markers.push(marker);	

	    var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp,adsid:adsid}
	    marker.addListener('click', function() {	
    		setTimeout(() => { showCardforvehicles(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
    		});
	    bounds.extend(marker.position);
	    	        	  }); //.each
	             map3.fitBounds(bounds);
	    	        	  
	             center = bounds.getCenter();let maxDistance=0;
	    	    	$.each(data, function (i, myList) {
	    	    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	    	    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	    	    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	    				    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	    				    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	    	    		    	if (distance > maxDistance) { maxDistance = distance; }
	    	    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	    	    		    	});//2nd each 
	          //   $('#radius').empty().append(""+maxDistance/1000);
	       /*       circle = new google.maps.Circle({
	       		     map: map3,
	       		     radius: maxDistance, // Radius in meters
	       		  fillColor: '#00000000', // transparent color
	       	    fillOpacity: 0,         // fully transparent
	       		     strokeColor: '#F27C0A', // Red stroke color
	       		     strokeOpacity: 0.8, // Stroke opacity
	       		     strokeWeight: 2, // Stroke weight
	       		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
	       		   });  
	              circles.push(circle);*/
		

	        }//success
		
	})//ajax
		 }
		 }
		 
	 
		 // car end
		 
		 
		 // rickshaw start
		 
		 	 
		  var rickshawenabled = 0;let currentRequestId = 0;
		  let latestRequestId = null;

		  function generateRequestId() {
		      return Date.now() + '_' + Math.random().toString(36).substring(2, 10);
		  }
	function rickshawads()
	{
		rickshawenabled=1;
		busenabled=0;carenabled=0;  goodsenabled=0;newsenabled =0; vlogsenabledd =0;
		
		/*currentRequestId++;
		let requestId = currentRequestId;*/
		
		const requestId = generateRequestId();
	    latestRequestId = requestId;
		var k=0;

		 if (rickshawbutton.classList.contains("roadactive")) {       //when clicked to remove
			 rickshawbutton.classList.remove("roadactive");
			 rickshawbutton.classList.add("roadinactive");  
	         
			  document.getElementById("filter-container").style.display = "flex";
	         if (watchID !== undefined) {
	             navigator.geolocation.clearWatch(watchID); 
	         }
	         rickshawenabled=0;
	         
	         verticalenabledinlocation = "";
		     	globalpng ='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
		     	
	         fetch('/removegiads?requestId=' + requestId, {
	             method: 'POST'
	         }).then(response => {
	        	 
	        	 if (!response.ok) {
	        	        throw new Error("Network response was not ok");
	        	    }
	        	 
	        	 return response.json(); // ✅ Parse the JSON body
	         })
	        	 .then(data => {
	        		/* if (requestId !== currentRequestId) return;*/
	        		if (requestId !== latestRequestId) return;
	        		 noofresults=data.length;
	        		  $('#noofresults').html('Results: '+noofresults) ;
	        			
	        		 	// Check if a specific class exists
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
	        		    currentAdsData=data;
	        		   
	        		      // document.getElementById("ads").innerHTML = "";
	        		   	noofresults=data.length;
	        		   //	console.log('No of Results: ' +noofresults);
	        			 $('#noofresults').html('Results: '+noofresults) ;

	        	         let x = JSON.stringify(data); 
	        	         //console.log('x length : ' +data.length);
	        	         const bounds = new google.maps.LatLngBounds();var center;    
	        	        for (var i = 0; i < markers.length; i++) {
	        		   markers[i].setMap(null); // Remove marker from the map
	        		
	        	   }
	        	locations = []; // Clear the array of markers
	        	circles.forEach(circle => {
	        	    circle.setMap(null); // Remove circle from the map
	        	});
	        	circles.length = 0; // Clear the array
	        	//Remove the previous circle if it exists
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
	        		     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
	        	         $.each(data, function (i, myList) {
	        	         	
	        	         	  var adsid = myList.id;
	        	  	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	        		
	        		        const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	        	 		const marker = new google.maps.Marker({
	        	 	   
	        	 	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
	        	 	        map: map3,
	        	 	        icon:globalpng
	        	 	      });
	        	markers.push(marker);	

	        	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
	        		marker.addListener('click', function() {	
	        			setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
	        			});
	        	bounds.extend(marker.position);
	        		        	  }); //.each
	        	         map3.fitBounds(bounds);
	        		        	  
	        	         center = bounds.getCenter();let maxDistance=0;
	        		    	$.each(data, function (i, myList) {
	        		    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	        		    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	        		    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	        					    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	        					    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	        		    		    	if (distance > maxDistance) { maxDistance = distance; }
	        		    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	        		    		    	});//2nd each 
	        	      //   $('#radius').empty().append(""+maxDistance/1000);
	        	      /*    circle = new google.maps.Circle({
	        	   		     map: map3,
	        	   		     radius: maxDistance, // Radius in meters
	        	   		  fillColor: '#00000000', // transparent color
	        	   	    fillOpacity: 0,         // fully transparent
	        	   		     strokeColor: '#F27C0A', // Red stroke color
	        	   		     strokeOpacity: 0.8, // Stroke opacity
	        	   		     strokeWeight: 2, // Stroke weight
	        	   		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
	        	   		   });           	        
	        	          circles.push(circle);*/
	             
	         });

	     } 
		
		 else{
			rickshawbutton.classList.remove("roadinactive");
			rickshawbutton.classList.add("roadactive");  	
			verticalenabledinlocation = "rickshawenabled";
			  document.getElementById("filter-container").style.display = "none";
		
		     if (gitagbutton.classList.contains("roadactive")) {  
			 gitagbutton.classList.add("roadinactive");
	         gitagbutton.classList.remove("roadactive");   
	       
		     }
	         if (roadbutton.classList.contains("roadactive")) {       //when clicked
	            
	            roadbutton.classList.remove("roadactive");
	             roadbutton.classList.add("roadinactive");
	         }
	         
	         if (templebutton.classList.contains("roadactive")) {       //when clicked
	             
	             templebutton.classList.remove("roadactive");
	              templebutton.classList.add("roadinactive");
	          }
	         
	         //for heritage, hostpital, bus, car, goods, rickashaw
	         
	         
	         
	         if(forestbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 forestbutton.classList.remove("roadactive");
	        	 forestbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(heritagebutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 heritagebutton.classList.remove("roadactive");
	        	 heritagebutton.classList.add("roadinactive");  
	         }

	         
	         if(carbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 carbutton.classList.remove("roadactive");
	        	 carbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(hospitalbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 hospitalbutton.classList.remove("roadactive");
	        	 hospitalbutton.classList.add("roadinactive");  
	         }

	         
	         if(goodsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	goodsbutton.classList.remove("roadactive");
	        	 goodsbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(busbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	busbutton.classList.remove("roadactive");
	        	 busbutton.classList.add("roadinactive");  
	         }
	         
	         if(vlogsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	vlogsbutton.classList.remove("roadactive");
	        	 vlogsbutton.classList.add("roadinactive");  
	         }
	         
	         if(newsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	newsbutton.classList.remove("roadactive");
	        	 newsbutton.classList.add("roadinactive");  
	         }
		$.ajax({
	        // Our sample url to make request 
	        url:"${pageContext.request.contextPath}/rickshawads?requestId=" + requestId,
	        type: "GET",
	        contentType : 'application/json',
	        dataType : 'json',
	        //data:JSON.stringify({lat,lng}), 
	        success: function (data) {
	        	
	        	if (requestId !== latestRequestId) return;
	        	/*if (requestId !== currentRequestId) return;*/
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
	    	    currentAdsData=data;
	    	   
	    	      // document.getElementById("ads").innerHTML = "";
	    	   	noofresults=data.length;
	    	   //	console.log('No of Results: ' +noofresults);
	    		 $('#noofresults').html('Results: '+noofresults) ;

	             let x = JSON.stringify(data); 
	             //console.log('x length : ' +data.length);
	             const bounds = new google.maps.LatLngBounds();var center;    
	            for (var i = 0; i < markers.length; i++) {
	    	   markers[i].setMap(null); // Remove marker from the map
	    	
	       }
	    locations = []; // Clear the array of markers
	    circles.forEach(circle => {
	        circle.setMap(null); // Remove circle from the map
	    });
	    circles.length = 0; // Clear the array
	    //Remove the previous circle if it exists
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
	    	     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
	             $.each(data, function (i, myList) {
	             	
	             	  var adsid = myList.id;
	      	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	    	      globalpng = {
					      url: "/rickshaw.png", // relative to your app’s static path
					      scaledSize: new google.maps.Size(20, 20), // adjust as needed
					      anchor: new google.maps.Point(20, 20),
					    };
	    	     	
	    	 
	    	      
	    	        const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	     		const marker = new google.maps.Marker({
	     	   
	     	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
	     	        map: map3,
	     	        icon:globalpng
	     	      });
	    markers.push(marker);	

	    var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp,adsid:adsid}
	    	marker.addListener('click', function() {	
	    		setTimeout(() => { showCardforvehicles(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
	    		});
	    bounds.extend(marker.position);
	    	        	  }); //.each
	             map3.fitBounds(bounds);
	    	        	  
	             center = bounds.getCenter();let maxDistance=0;
	    	    	$.each(data, function (i, myList) {
	    	    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	    	    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	    	    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	    				    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	    				    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	    	    		    	if (distance > maxDistance) { maxDistance = distance; }
	    	    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	    	    		    	});//2nd each 
	          //   $('#radius').empty().append(""+maxDistance/1000);
	           /*   circle = new google.maps.Circle({
	       		     map: map3,
	       		     radius: maxDistance, // Radius in meters
	       		  fillColor: '#00000000', // transparent color
	       	    fillOpacity: 0,         // fully transparent
	       		     strokeColor: '#F27C0A', // Red stroke color
	       		     strokeOpacity: 0.8, // Stroke opacity
	       		     strokeWeight: 2, // Stroke weight
	       		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
	       		   });  

	              circles.push(circle);*/
	        }//success
		
	})//ajax
		 }
		 }
		 

		 // rickshaw end
		 
		 
		 
		 //goods start
		 
		 	 
		  var goodsenabled = 0;
	function goodsads()
	{
		goodsenabled=1;
		busenabled=0;carenabled=0; rickshawenabled=0 ; newsenabled =0; vlogsenabledd =0;
		
		var k=0;
		
		const requestId = generateRequestId();
		latestRequestId = requestId;
		 if (goodsbutton.classList.contains("roadactive")) {       //when clicked to remove
			 goodsbutton.classList.remove("roadactive");
			 goodsbutton.classList.add("roadinactive");  
	         
			  document.getElementById("filter-container").style.display = "flex";
	         if (watchID !== undefined) {
	             navigator.geolocation.clearWatch(watchID); 
	         }
	         goodsenabled=0;
	         verticalenabledinlocation = "";
		     	globalpng ='http://maps.google.com/mapfiles/ms/icons/red-dot.png';
	         fetch('${pageContext.request.contextPath}/removegiads?requestId=' + requestId, {
	             method: 'POST'
	         }).then(response => {
	        	 
	        	 if (!response.ok) {
	        	        throw new Error("Network response was not ok");
	        	    }
	        	 
	        	 return response.json(); // ✅ Parse the JSON body
	         })
	        	 .then(data => {
	        		 if (requestId !== latestRequestId) return;
	        		 noofresults=data.length;
	        		  $('#noofresults').html('Results: '+noofresults) ;
	        			
	        		 	// Check if a specific class exists
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
	        		    currentAdsData=data;
	        		   
	        		      // document.getElementById("ads").innerHTML = "";
	        		   	noofresults=data.length;
	        		   //	console.log('No of Results: ' +noofresults);
	        			 $('#noofresults').html('Results: '+noofresults) ;

	        	         let x = JSON.stringify(data); 
	        	         //console.log('x length : ' +data.length);
	        	         const bounds = new google.maps.LatLngBounds();var center;    
	        	        for (var i = 0; i < markers.length; i++) {
	        		   markers[i].setMap(null); // Remove marker from the map
	        		
	        	   }
	        	locations = []; // Clear the array of markers
	        	circles.forEach(circle => {
	        	    circle.setMap(null); // Remove circle from the map
	        	});
	        	circles.length = 0; // Clear the array
	        	//Remove the previous circle if it exists
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
	        		     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
	        	         $.each(data, function (i, myList) {
	        	         	
	        	         	  var adsid = myList.id;
	        	  	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	        		      
	        		     	
	        		 
	        		      
	        		        const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	        	 		const marker = new google.maps.Marker({
	        	 	   
	        	 	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
	        	 	        map: map3,
	        	 	        icon:globalpng
	        	 	      });
	        	markers.push(marker);	

	        	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp}
	        		marker.addListener('click', function() {	
	        			setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
	        			});
	        	bounds.extend(marker.position);
	        		        	  }); //.each
	        	         map3.fitBounds(bounds);
	        		        	  
	        	         center = bounds.getCenter();let maxDistance=0;
	        		    	$.each(data, function (i, myList) {
	        		    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	        		    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	        		    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	        					    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	        					    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	        		    		    	if (distance > maxDistance) { maxDistance = distance; }
	        		    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	        		    		    	});//2nd each 
	        	      //   $('#radius').empty().append(""+maxDistance/1000);
	        	      /*    circle = new google.maps.Circle({
	        	   		     map: map3,
	        	   		     radius: maxDistance, // Radius in meters
	        	   		  fillColor: '#00000000', // transparent color
	        	   	    fillOpacity: 0,         // fully transparent
	        	   		     strokeColor: '#F27C0A', // Red stroke color
	        	   		     strokeOpacity: 0.8, // Stroke opacity
	        	   		     strokeWeight: 2, // Stroke weight
	        	   		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
	        	   		   });           	        
	        	          circles.push(circle);*/
	         });

	     } 
		
		 else{
			 goodsbutton.classList.remove("roadinactive");
			 goodsbutton.classList.add("roadactive");  	 
				verticalenabledinlocation = "goodsenabled";
			  document.getElementById("filter-container").style.display = "none";
		
		     if (gitagbutton.classList.contains("roadactive")) {  
			 gitagbutton.classList.add("roadinactive");
	         gitagbutton.classList.remove("roadactive");   
	       
		     }
	         if (roadbutton.classList.contains("roadactive")) {       //when clicked
	            
	            roadbutton.classList.remove("roadactive");
	             roadbutton.classList.add("roadinactive");
	         }
	         
	         if (templebutton.classList.contains("roadactive")) {       //when clicked
	             
	             templebutton.classList.remove("roadactive");
	              templebutton.classList.add("roadinactive");
	          }
	         
	         //for heritage, hostpital, bus, car, goods, rickashaw
	         
	         if(forestbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 forestbutton.classList.remove("roadactive");
	        	 forestbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(heritagebutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 heritagebutton.classList.remove("roadactive");
	        	 heritagebutton.classList.add("roadinactive");  
	         }

	         
	         if(carbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 carbutton.classList.remove("roadactive");
	        	 carbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(hospitalbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	 hospitalbutton.classList.remove("roadactive");
	        	 hospitalbutton.classList.add("roadinactive");  
	         }

	         
	         if(rickshawbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	rickshawbutton.classList.remove("roadactive");
	        	 rickshawbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(busbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	busbutton.classList.remove("roadactive");
	        	 busbutton.classList.add("roadinactive");  
	         }
	         
	         
	         if(vlogsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	vlogsbutton.classList.remove("roadactive");
	        	 vlogsbutton.classList.add("roadinactive");  
	         }
	         
	         if(newsbutton.classList.contains("roadactive"))  { //when clicked
	             // If 'active' class is already present, remove it
	           //  console.log('in IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
	        	newsbutton.classList.remove("roadactive");
	        	 newsbutton.classList.add("roadinactive");  
	         }
		$.ajax({
	        // Our sample url to make request 
	        url:"${pageContext.request.contextPath}/goodsads?requestId=" + requestId,
	        type: "GET",
	        contentType : 'application/json',
	        dataType : 'json',
	        //data:JSON.stringify({lat,lng}), 
	        success: function (data) {
	        	if (requestId !== latestRequestId) return;
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
	    	    currentAdsData=data;
	    	   
	    	      // document.getElementById("ads").innerHTML = "";
	    	   	noofresults=data.length;
	    	   //	console.log('No of Results: ' +noofresults);
	    		 $('#noofresults').html('Results: '+noofresults) ;

	             let x = JSON.stringify(data); 
	             //console.log('x length : ' +data.length);
	             const bounds = new google.maps.LatLngBounds();var center;    
	            for (var i = 0; i < markers.length; i++) {
	    	   markers[i].setMap(null); // Remove marker from the map
	    	
	       }
	    locations = []; // Clear the array of markers
	    circles.forEach(circle => {
	        circle.setMap(null); // Remove circle from the map
	    });
	    circles.length = 0; // Clear the array
	    //Remove the previous circle if it exists
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
	    	     // blueMarker.setPosition(new google.maps.LatLng(currentlatforblue, currentlngforblue));
	             $.each(data, function (i, myList) {
	             	
	             	  var adsid = myList.id;
	      	     	 var phno = myList.phoneNumber;	var whatsapp = myList.whatsappNumber;
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
	    	     	
	    	      globalpng = {
    				      url: "/transport.png", // relative to your app’s static path
    				      scaledSize: new google.maps.Size(20, 20), // adjust as needed
    				      anchor: new google.maps.Point(20, 20),
    				    };	
	    	 
	    	      
	    	        const lattt = Number(myList.location.lat); const longgg=Number(myList.location.lng) ;
	     		const marker = new google.maps.Marker({
	     	   
	     	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
	     	        map: map3,
	     	        icon:globalpng
	     	      });
	    markers.push(marker);	

	    var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail,whatsapp:whatsapp,adsid:adsid}
	    marker.addListener('click', function() {	
    		setTimeout(() => { showCardforvehicles(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
    		});
	    bounds.extend(marker.position);
	    	        	  }); //.each
	             map3.fitBounds(bounds);
	    	        	  
	             center = bounds.getCenter();let maxDistance=0;
	    	    	$.each(data, function (i, myList) {
	    	    	    		const lattt2 =  parseFloat(myList.location.lat); const longgg2= parseFloat(myList.location.lng ); 
	    	    		    	const markerPosition = new google.maps.LatLng(Number(lattt2),Number(longgg2)); 
	    	    		    	 var blueLatLng = new google.maps.LatLng(blueMarker.getPosition().lat(), blueMarker.getPosition().lng());
	    				    		//const distance = google.maps.geometry.spherical.computeDistanceBetween(center, markerPosition);
	    				    		const distance = google.maps.geometry.spherical.computeDistanceBetween(blueLatLng, markerPosition);
	    	    		    	if (distance > maxDistance) { maxDistance = distance; }
	    	    		    	 	//	console.log('maxdistance : ' +maxDistance/1000);
	    	    		    	});//2nd each 
	          //   $('#radius').empty().append(""+maxDistance/1000);
	          /*    circle = new google.maps.Circle({
	       		     map: map3,
	       		     radius: maxDistance, // Radius in meters
	       		  fillColor: '#00000000', // transparent color
	       	    fillOpacity: 0,         // fully transparent
	       		     strokeColor: '#F27C0A', // Red stroke color
	       		     strokeOpacity: 0.8, // Stroke opacity
	       		     strokeWeight: 2, // Stroke weight
	       		     center: blueMarker.getPosition()//center//marker.getPosition() // Center the circle around the marker   	        
	       		   });  
	              
	              circles.push(circle);*/
	        }//success
		
	})//ajax
		 }
		 }


</script>

</body>
</html>

