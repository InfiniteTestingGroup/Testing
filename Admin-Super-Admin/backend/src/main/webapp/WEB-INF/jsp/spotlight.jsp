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
<title>Insert title here</title>
<style type="text/css">
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
padding: 20px;
flex-direction: column;
align-items: flex-start;
gap: 20px;
align-self: stretch;
border-radius: 20px;
background: #FFF;
width:98%;
}
.frame56
{
display: flex;
height: 40px;
padding: 10px 15px;
align-items: center;
gap: 10px;
align-self: stretch;
border-radius: 10px;
border: 1px solid #BDBDBD;
flex:1 0 0;
}

.frame101
{
display: flex;
width: 765px;
flex-direction: column;
align-items: flex-start;
gap: 20px;
flex-shrink: 0;

}
    .container {
        width: 1170px;
        padding-left: 10px;
        margin-left: 45px;
        padding-top: 30px;
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
.spotlightimg
{
border-radius: 50%;
}
.panel-body
{
display: flex;
flex-direction: row;
/*justify-content: center;*/

border-radius: 20px;
background: #FFF;
padding:0px;
align-items: flex-start;
align-self: stretch;
height:100%;
}
.panel-default {
  /*  border-color: #ddd;*/
    border-radius: 20px;
    background: #FFF;
    
    display: flex;
flex-direction: column;
justify-content: center;
align-items: flex-start;
align-self: stretch;
height:250px;
}
.carousel-control.left,
.carousel-control.right {
  background: transparent;
}
  .textcontainer
        {
       display: flex;  
       flex-direction: column;
       gap: 10px;
       padding:20px;width:83%;
        flex-grow: 0;
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
        }
        .carousel-container
        {
       /* width: 250px;*/
height: 100%;
flex-shrink: 0;
/*background: linear-gradient(180deg, rgba(0, 0, 0, 0.00) 70.84%, #000 128.8%);*/
/*width: 44%;
    height: 100%;*/
    align-self: stretch;
   /* flex: 1;*/
        }
        #rightcol
        {
        display: flex;
padding: 30px;
flex-direction: column;
justify-content: center;
align-items: center;
gap: 24px;
align-self: stretch;
border-radius: 20px;
background: #FFF;
width:100%;
        }
        .row
        {
        display:flex;
        flex-direction:row;
        
        }
        #bottomcol
        {
        display: flex;
padding: 30px 30px 60px 30px;
flex-direction: column;
align-items: flex-start;
gap: 10px;
align-self: stretch;
border-radius: 20px;
background: #FFF;
width:100%;
        
        }
        
       /*  #map {
            height: 250px; /* Set the height of the map */
         /*   width: 100%;   /* Set the width of the map */
      /*  }*/
        .carousel {
    position: relative;
    height: 100%;
}
.carousel-inner {
    position: relative;
    width: 100%;
    overflow: hidden;
    height: 100%;
}

    .carousel-inner >.item
    {
    height:100%;
    }
     .carousel-inner >.item active
    {
    height:100%;
    }
    .button-group
    {
/*    display: flex;
align-items: flex-start;
gap: 20px;
align-self: stretch;
align-items: center;
*/
display: flex;
align-items: center;
gap: 30px;
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
    
.mapcontainer
{
/*height:430px;*/
 position: relative;
 display:flex;
 flex-direction:row; 
 width:100%;
}
 #map{
   width: 100%;
    height: 150px;
    position: absolute;
    /*overflow: hidden;*/
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
.btn-container{
  
    justify-content: space-between;
    display: flex;
    flex-direction: row;
    gap: 520px;
    text-align: right;
    padding: 10px;
}


 

 .btn-group button  {
    color: #F2382C;
    background-color: white;
    border-color: white;
    outline: none;
    padding:10px;
    }
    
    
.selected { background-color: #F2382C !important; color: white !important; }
</style>
</head>
<body>
<div class ="container">
<div class="row">
<div class="frame101">
<div class="col-md-6">
<div class="frame56" id ="spotlightsearch">
<input type="text" placeholder="Search.." name="search" style ="border: none;outline: none;width:95%;"  id="spotlytsearch">
      <button type="submit" style ="border: none;outline: none;background: #FFF;"><i class="fa fa-search" ></i></button>
</div>

<div class="sp" style="display: flex;align-items: flex-start;gap: 20px;align-self: stretch;overflow:hidden;" >
<div class="spotlightlist" id ="spotlightlist">


</div>

</div>

</div><!-- clmd6 -->
<div class= "btn-container"><div></div>
<div class="btn-group" >
  <button id="active" class="selected" onclick="selectButton(this)">Active</button>
  <button id="completed" onclick="selectButton(this)">Completed</button>
  <button id="all" onclick="selectButton(this)">ALL</button>
</div>

</div><!-- btn container -->
<div class="onead" style="width: 98%;   display: flex;    flex-direction: column;    gap: 10px;">
</div>
</div><!-- 101 -->

<div class="rightmostframe" style = "display:flex; flex-direction:column;gap:10px;width:100%;">
<div class="col-md-6" id ="rightcol">
<div style ="display: flex;justify-content: center;align-items: center;gap: 10px;border-radius: 100px;
box-shadow: 0px 1px 9px 0px rgba(0, 0, 0, 0.25);">
<img src = "" style ="vertical-align: middle;width: 60px;height: 60px;border-radius: 100px;   
    box-shadow: 0px 1px 9px 0px rgba(0, 0, 0, 0.25)"; id="profilepic">
</div>
<div class="publdetails">
<div style ="display: flex;flex-direction: column;justify-content: center;align-items: center;gap: 20px;">
<p style ="color: #000;font-family: Inter;font-size: 22px;font-style: normal;font-weight: 700;line-height: normal;" id ="publishername">
</div>
<div class="detailsinnum" style ="display: flex;align-items: flex-start;">
<div class="frame103" style ="display: flex;width: 120px;flex-direction: column;align-items: center;gap: 10px;">
<div style="display: flex;align-items: center;gap: 10px;">
<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
  <path d="M18.616 20H19.106C20.256 20 21.171 19.476 21.992 18.744C24.078 16.883 19.174 15 17.5 15M15.5 5.069C15.7274 5.023 15.9624 5 16.205 5C18.025 5 19.5 6.343 19.5 8C19.5 9.657 18.025 11 16.205 11C15.9624 11 15.7274 10.977 15.5 10.931M4.48104 16.111C3.30204 16.743 0.211044 18.033 2.09404 19.647C3.01404 20.436 4.03804 21 5.32604 21H12.674C13.962 21 14.986 20.436 15.906 19.647C17.789 18.033 14.698 16.743 13.519 16.111C10.754 14.63 7.24604 14.63 4.48104 16.111ZM13 7.5C13 8.56087 12.5786 9.57828 11.8285 10.3284C11.0783 11.0786 10.0609 11.5 9.00004 11.5C7.93918 11.5 6.92176 11.0786 6.17162 10.3284C5.42147 9.57828 5.00004 8.56087 5.00004 7.5C5.00004 6.43913 5.42147 5.42172 6.17162 4.67157C6.92176 3.92143 7.93918 3.5 9.00004 3.5C10.0609 3.5 11.0783 3.92143 11.8285 4.67157C12.5786 5.42172 13 6.43913 13 7.5Z" stroke="black" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg><div id="nooffollow"></div>
</div>
<div>
<p style ="align-self: stretch;color: #000;text-align: center;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;
line-height: normal;">Followers</p>

</div>

</div><!-- 103-->
<div class="frame104" style ="display: flex;width: 120px;flex-direction: column;align-items: center;gap: 10px;">
<div style="display: flex;align-items: center;gap: 10px;">
<svg xmlns="http://www.w3.org/2000/svg" width="25" height="24" viewBox="0 0 25 24" fill="none">
  <path d="M8.5 10.5V9.5H15.5V10.5H8.5ZM8.5 13.5V12.5H15.5V13.5H8.5ZM8.5 16.5V15.5H15.5V16.5H8.5ZM18 8V6H16V5H18V3H19V5H21V6H19V8H18ZM4 20V4H14.923V5H5V19H19V9.077H20V20H4Z" fill="black"/>
</svg><div id="noofcamp"></div>
</div>
<div>
<p style ="align-self: stretch;color: #000;text-align: center;font-family: Inter;font-size: 16px;font-style: normal;
font-weight: 400;line-height: normal;">Campaigns</p>

</div>


</div><!-- 104 -->
</div>
</div>

</div>
<div class="col-md-6" id="bottomcol">
<div><p style = "color: #000;font-family: Inter;font-size: 24px;font-style: normal;font-weight: 700;line-height: normal;
text-transform: capitalize;">Spotlight Location</p></div>
<div class="mapcontainer" >
 <div id="slider-container" style="margin-top:120px;padding:10px;margin-left:40px;"> 
 <output id="rangeOutputId" >1.3 km</output>
  <input type="range" min="1.3" max="5.7" value="1.3" orient="vertical" id ="rangeInputId" step="2.2" oninput="sliderClick()" >
   
  
  </div>  
 <div  id="map"></div>
       </div>

</div><!-- bottomcol -->
</div><!-- rightmostframe -->


<div id="myModalforphone" class="modal" role="dialog">
  <div class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header" style ="border-bottom: none; display: flex;    flex-direction: column;">
      <div class ="phonemodalheader">
     <h4 class="modal-title" style = "align-self: stretch;color: #000;font-family: Inter;
font-size: 25px;font-style: normal;font-weight: 700;line-height: normal;">Login</h4>
   <span id="closeButtonheader" class="close"  >&times;</span>
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
      <div class="modal-body" style ="border-bottom: none; ">
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
  
  <!--  login modal success end here center-->
</div><!-- row -->

</div><!-- container -->

<script type="text/javascript">
function selectButton(button) { // Remove 'selected' class from all buttons
//	console.log('this: ' +button);
	var buttons = document.querySelectorAll('.btn-group button');
buttons.forEach(function(btn)
		{ btn.classList.remove('selected'); 
		}); // Add 'selected' class to the clicked button 
		button.classList.add('selected'); 
		console.log('spotlightId in  scelected : ' +spotlightId);
		console.log('button id : '+button.id);
		var buttonval = button.id;
		$(".onead").html("");
		$.ajax({
            url: '${pageContext.request.contextPath}/ads', // Sample API endpoint
            method: 'GET',
            contentType: 'text/plain',
            data: {spotlightId:spotlightId,buttonval:buttonval},
            success: function(data) {
                // Clear previous data           // Iterate through the data and display it
            	  $.each(data, function (i, myList) {
          	     	//  console.log(data);
          	     	  var adsid = myList.id;
          	     	 var phno = myList.phoneNumber;
          	     	// console.log('phno : ' +phno);
          	     	 var email= myList.emailAddress;
          	     	 var publisher_name = myList.a.title;
          	     	// var publisherName= myList.fullName;
          	     	 console.log(''+publisherName);
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
          	    	var nooffol = myList.noOfFollow;
          	    	var noofcam = myList.noOfCampaigns;
          	 //   	var profilepic= myList.profilePicturePath;
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
          	 //   	 banner1="nopreview.jpg";
          	  //  	banner2 = "nopreview.jpg";
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
          	     	//onclick=nextui(this);
          	     	 var img_path = "";
          	     	 k++;
          	     	 var carouselid= 'myCarousel'+k;
          	   var ad_card=	'<div class="panel panel-default">'
          	     	 
          	   
          	     	 +'<div class="panel-body" >'
          	     	 +'<div class="carousel-container">'
          	     	 +'<div id="'+carouselid+'" class="carousel slide" data-ride="carousel">'
          	     	 +'<ol class="carousel-indicators"><li data-target="#'+carouselid+'" data-slide-to="0" class="active"></li><li data-target="#'+carouselid+'" data-slide-to="1"></li><li data-target="#'+carouselid+'" data-slide-to="2"></li></ol>'
                       +'<div class="carousel-inner"><div class="item active">'
                       +'<img src="<c:url value="'+thumbnail+'" />" alt="Los Angeles" style ="width: 200px;height: 100%;border-bottom-left-radius: 20px;border-top-left-radius: 20px;max-height: 249px;"></div>'
                       +'<div class="item">'
                       
                       +'<img src="<c:url value="'+banner1+'" />" alt="Chicago" style ="width: 200px;height: 100%;border-bottom-left-radius: 20px;border-top-left-radius: 20px;max-height: 249px;" ></div>'
                       +'<div class="item"><img src="<c:url value="'+banner2+'" />" alt="New York" style ="width: 200px;height: 100%;border-bottom-left-radius: 20px;border-top-left-radius: 20px;max-height: 249px;"></div></div>'
                       +' <a class="left carousel-control" href="#'+carouselid+'" data-slide="prev" ><span class="glyphicon glyphicon-chevron-left"></span><span class="sr-only">Previous</span></a>'
                       +' <a class="right carousel-control" href="#'+carouselid+'" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span><span class="sr-only">Next</span></a></div>'
                       
                       +'</div>'
                       +'<div class= "textcontainer" > <p style="color: #000;font-family: Inter;font-size: 18px;font-style: normal;font-weight: 700;line-height: normal;align-self: stretch;">'+publisher_name+'</p>'
                       +'<p class="description" style = "display: -webkit-box;-webkit-box-orient: vertical;-webkit-line-clamp: 3;align-self: stretch;overflow: hidden;color: #000;text-overflow: ellipsis;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">'+description+'<h5 class="expires"> Expires on '+dates+'</h5>'
                       +'<div class ="button-group"><button style = "outline: none;background-color: white;border: none;width: 25px; border-radius: 5px;" onclick=phone('+phno+');>  <i class="fa fa-phone" aria-hidden="true"> </i></button>'
                       +'<button style = "outline: none;background-color: white;border: none;width: 25px;border-radius: 5px;" onclick=whatsapp('+phno+');><i class="fa fa-whatsapp" aria-hidden="true"></i></button><button style = "outline: none;background-color: white;border: none;width: 25px;border-radius: 5px;"><i class="fa fa-envelope"></i></button>'
                       +'<button type="button" class="btn btn-default" id = "takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+');><i class="fa fa-map-marker" aria-hidden="true" style = "font-size:17px;color: #F27C0A;">&nbsp;Take me there</i></button></div>';

          	     	 $('.onead').append(ad_card); 
          	
          	
          //var dist=getDistanceFromLatLonInKm(myList.location.lat,myList.location.lng,latt,lngg).toFixed(1);
        //  locations.push(  [myList.location.lat,myList.location.lng,publisher_name,publisher_name]);
          //console.log('dist value is :' +dist);
          //if(dist<=1.3)	{}	 
          	     	document.getElementById('nooffollow').innerText = nooffol;
          	     	document.getElementById('noofcamp').innerText = noofcam;
          	     	document.getElementById('publishername').innerText = publisherName;
        //  	   	document.getElementById('publishername').innerText = publisherName;
          	     	document.getElementById('profilepic').src = profilepic;
          	     	locations.push(  [myList.location.lat,myList.location.lng,publisher_name,publisher_name]);
          	        	  }); //.each
          	        	var zoom_val=0;

          	        	var infowindow = new google.maps.InfoWindow();
console.log('contents of array:  '+locations);
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
          	        	    	          infowindow.setContent('<b>Publisher Name:</b>&nbsp;'+ locations[i][3]);
          	        	    	          infowindow.open(map, marker);
          	        	    	        }
          	        	    	      })(marker, i));
          	        	    	      markers.push(marker);
          	        	    	  //    console.log('marker aray :  ' +markers);
          	        	}

               
            },
            error: function(xhr, status, error) {
           
                console.error(error);
            }
        });
		}
document.addEventListener('DOMContentLoaded', () => {//console.log('in map');
	  const map = document.querySelector('.mapcontainer');
	  const outerContainer = document.querySelector('#bottomcol');
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
	
	
	
var users = ${users};
var spotlight="";
var x=0;

for(var i=0;i<users.length;i++)
{
	var name =users[i].fullName;
	 var profilepicpath= users[i].profilePicPath;
	var str = name.substring(0, 10);
	var usrphno = users[i].phoneNumber.dialNumber;
	var userid = users[i].id;
//	console.log('ph no : ' +usrphno);
	 spotlight+='  <div class="spotlightitem" role="button"  id="'+userid+'" >'
+'	<img  src="<c:url value="'+profilepicpath+'" />"  alt="User profile" style="width: 37px;height: 39px;" class="spotlightimg" />'
		+'<div class="companyname">'+str+'</div>'
+' 		</div>';    
	}
 
 $('.spotlightlist').append(spotlight);
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
	    	var usrphno = results[i].phoneNumber.dialNumber;
	    	var userid = results[i].id;
	    	 spotlightt+='<div class="spotlightitem" role="button" id="'+userid+'" >'
	    +'	<img  src="<c:url value="'+profilepicpath+'" />"  alt="User profile" style="width: 37px;height: 39px;" class="spotlightimg"  />'
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
 
 $('.spotlightitem').on('click', function() {
                //alert('Div clicked using .on()!');
               var y =  $(this).attr('id') ;
                var x = $(this).val();
                var z = $(this).usrphno;
                //console.log('z : ' +z);
            });
 var locations=[];
 var markers =[];
const circles = []; 
var spotlightId;
 $(document).ready(function() {
	 $('.spotlightlist').on('click', '.spotlightitem', function() {//for dynamic 
	        //alert('You clicked ' );
		 var y =  $(this).attr('id') ;
		 spotlightId =y;
		 console.log('spotlightId : ' +spotlightId);
		 var  k=0;
		
		// document.getElementsByClassName("onead").innerHTML = '';
		 $(".onead").html("");
		 for (var i = 0; i < markers.length; i++) {
	    	   markers[i].setMap(null); // Remove marker from the map
	    	 
	    	  // locations[i]=null;
	          }
	       locations = []; // Clear the array of markers
	       var buttons = document.querySelectorAll('.btn-group button');
	       buttons.forEach(function(btn)
	       		{ btn.classList.remove('selected'); 
	       		});
	       var button = document.getElementById("active"); 
	       //button.innerText += ' (Selected)'; 
	       button.classList.add('selected');
	       
		 $.ajax({
	            url: '${pageContext.request.contextPath}/spotlight', // Sample API endpoint
	            method: 'POST',
	            contentType: 'text/plain',
	            data: y,
	            success: function(data) {
	                // Clear previous data           // Iterate through the data and display it
	            	  $.each(data, function (i, myList) {
	          	     	//  console.log(data);
	          	     	  var adsid = myList.id;
	          	     	 var phno = myList.phoneNumber;
	          	     	// console.log('phno : ' +phno);
	          	     	 var email= myList.emailAddress;
	          	     	 var publisher_name = myList.a.title;
	          	     	 var publisherName= myList.fullName;
	          	     	 //console.log('publisherName'+publisherName);
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
	          	    	var nooffol = myList.noOfFollow;
	          	    	var noofcam = myList.noOfCampaigns;
	          	   	var profilepic= myList.profilePicturePath;
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
	          	 //   	 banner1="nopreview.jpg";
	          	  //  	banner2 = "nopreview.jpg";
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
	          	     	//onclick=nextui(this);
	          	     	 var img_path = "";
	          	     	 k++;
	          	     	 var carouselid= 'myCarousel'+k;
	          	   var ad_card=	'<div class="panel panel-default">'
	          	     	 
	          	   
	          	     	 +'<div class="panel-body" >'
	          	     	 +'<div class="carousel-container">'
	          	     	 +'<div id="'+carouselid+'" class="carousel slide" data-ride="carousel">'
	          	     	 +'<ol class="carousel-indicators"><li data-target="#'+carouselid+'" data-slide-to="0" class="active"></li><li data-target="#'+carouselid+'" data-slide-to="1"></li><li data-target="#'+carouselid+'" data-slide-to="2"></li></ol>'
	                       +'<div class="carousel-inner"><div class="item active">'
	                       +'<img src="<c:url value="'+thumbnail+'" />" alt="Los Angeles" style ="width: 200px;height: 100%;border-bottom-left-radius: 20px;border-top-left-radius: 20px;max-height: 249px;"></div>'
	                       +'<div class="item">'
	                       
	                       +'<img src="<c:url value="'+banner1+'" />" alt="Chicago" style ="width: 200px;height: 100%;border-bottom-left-radius: 20px;border-top-left-radius: 20px;max-height: 249px;" ></div>'
	                       +'<div class="item"><img src="<c:url value="'+banner2+'" />" alt="New York" style ="width: 200px;height: 100%;border-bottom-left-radius: 20px;border-top-left-radius: 20px;max-height: 249px;"></div></div>'
	                       +' <a class="left carousel-control" href="#'+carouselid+'" data-slide="prev" ><span class="glyphicon glyphicon-chevron-left"></span><span class="sr-only">Previous</span></a>'
	                       +' <a class="right carousel-control" href="#'+carouselid+'" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span><span class="sr-only">Next</span></a></div>'
	                       
	                       +'</div>'
	                       +'<div class= "textcontainer" > <p style="color: #000;font-family: Inter;font-size: 18px;font-style: normal;font-weight: 700;line-height: normal;align-self: stretch;">'+publisher_name+'</p>'
	                       +'<p class="description" style = "display: -webkit-box;-webkit-box-orient: vertical;-webkit-line-clamp: 3;align-self: stretch;overflow: hidden;color: #000;text-overflow: ellipsis;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">'+description+'<h5 class="expires"> Expires on '+dates+'</h5>'
	                       +'<div class ="button-group"><button style = "outline: none;background-color: white;border: none;width: 25px; border-radius: 5px;" onclick=phone('+phno+');>  <i class="fa fa-phone" aria-hidden="true"> </i></button>'
	                       +'<button style = "outline: none;background-color: white;border: none;width: 25px;border-radius: 5px;" onclick=whatsapp('+phno+');><i class="fa fa-whatsapp" aria-hidden="true"></i></button><button style = "outline: none;background-color: white;border: none;width: 25px;border-radius: 5px;"><i class="fa fa-envelope"></i></button>'
	                       +'<button type="button" class="btn btn-default" id = "takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+');><i class="fa fa-map-marker" aria-hidden="true" style = "font-size:17px;color: #F27C0A;">&nbsp;Take me there</i></button></div>';

	          	     	 $('.onead').append(ad_card); 
	          	
	          	
	          //var dist=getDistanceFromLatLonInKm(myList.location.lat,myList.location.lng,latt,lngg).toFixed(1);
	        //  locations.push(  [myList.location.lat,myList.location.lng,publisher_name,publisher_name]);
	          //console.log('dist value is :' +dist);
	          //if(dist<=1.3)	{}	 
	          	     	document.getElementById('nooffollow').innerText = nooffol;
	          	     	document.getElementById('noofcamp').innerText = noofcam;
	          	     	document.getElementById('publishername').innerText = publisherName;
	        //  	   	document.getElementById('publishername').innerText = publisherName;
	          	     	document.getElementById('profilepic').src = profilepic;
	          	     	locations.push(  [myList.location.lat,myList.location.lng,publisher_name,publisher_name]);
	          	        	  }); //.each
	          	        	var zoom_val=0;

	          	        	var infowindow = new google.maps.InfoWindow();
console.log('contents of array:  '+locations);
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
	          	        	    	          infowindow.setContent('<b>Publisher Name:</b>&nbsp;'+ locations[i][3]);
	          	        	    	          infowindow.open(map, marker);
	          	        	    	        }
	          	        	    	      })(marker, i));
	          	        	    	      markers.push(marker);
	          	        	    	  //    console.log('marker aray :  ' +markers);
	          	        	}

	               
	            },
	            error: function(xhr, status, error) {
	           
	                console.error(error);
	            }
	        });//ajax
	    });
 });//document.ready

 let map;
 function initMap() {
     var location = { lat: 13.529070948523234 , lng: 75.36325099627925 }; // Set your desired location
     map = new google.maps.Map(document.getElementById('map'), {
         zoom: 8,
         center: location
     });
    /* var marker = new google.maps.Marker({
         position: location,
         map: map
     });*/
 }
 initMap();
 
 function takeme(lats,lngs)
	{
		console.log(lats+'and :'+lngs);
		var sessionlat = '<%= session.getAttribute("latitude") %>';
		var sessionlng = '<%= session.getAttribute("longitude") %>';
		//console.log(takemelat+'current loc :'+takemelng);
		const originLat = sessionlat; // 
     const originLng = sessionlng; // 
     const destinationLat = lats; 
     const destinationLng = lngs; 
     const url = 'https://www.google.com/maps/dir/?api=1&origin='+originLat+','+originLng+'&destination='+destinationLat+','+destinationLng+'&travelmode=driving';
     window.open(url, '_blank');
	}
 
 function whatsapp(phno)
	{
	 
	 var sessionmobile =<%= session.getAttribute("mobilenumber") %>;
	if(sessionmobile == null)
		{
		console.log('in session null');
		$('#myModalforphone').modal('show');
		}
	else{	
		console.log('in session not null');
    	 var whatsappUrl = 'https://wa.me/' + phno;
      window.open(whatsappUrl, '_blank');
             	  }
            
	}
 
 function phone(phno)
	{
	 console.log('phone number is : '+phno);		
     let sessionmobile=<%=session.getAttribute("mobilenumber")%>;
     console.log('sessionmobile: '+sessionmobile);
 	if(sessionmobile == null)		
	{
 		console.log('in session null');
		$('#myModalforphone').modal('show');
			}
		else
			{
		   const div = document.getElementById('callme');
		    div.textContent = phno;
		   	console.log('in session not null');
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
						const myDiv = document.getElementById('photpno');
						var otp =  myDiv.innerHTML ;
						//var otp = $('#otpno').val();
						
						 $.post("${pageContext.request.contextPath}/verifyOtp.htm", {
								
								mobilenumber : mobilenumber,	
								otp:otp,
								
						}, function(data) {
						}).done(function(data) {
							$('#myModalforphoneenterotp').modal('hide');
						}).fail(function(xhr, textStatus, errorThrown) {
							
						})
						
					});

			
 var spotlightDetails = ${spotlightDetails};
 
 for(var i=0;i<spotlightDetails.length;i++)
 {
	 var k=0;
	 locations=[];
	 var adsid = spotlightDetails[i].id;
   	 var phno = spotlightDetails[i].phoneNumber;
   	// console.log('phno : ' +phno);
   	 var email= spotlightDetails[i].emailAddress;
   	 var publisher_name = spotlightDetails[i].a.title;
   	 var publisherName= spotlightDetails[i].fullName;
  // 	 console.log(publisher_name);
  var profilepic=spotlightDetails[i].profilePicturePath;
   	 var description = spotlightDetails[i].a.description;
   	 var dates = spotlightDetails[i].dateRange.toDate;
   	const date = new Date(dates);
  	var companyName='';
  	var latitudes=spotlightDetails[i].location.lat;
  	var longitudes = spotlightDetails[i].location.lng;
  	var companyLogoUrl = spotlightDetails[i].companies.companyLogoPath;
  	var thumbnail = spotlightDetails[i].a.thumbnail;
  	//console.log('companyLogoUrl: ' +companyLogoUrl);
  	var banner1="nopreview.jpg";
  	var banner2 = "nopreview.jpg";
  	var nooffol = spotlightDetails[i].noOfFollow;
  	var noofcam = spotlightDetails[i].noOfCampaigns;
  	if(spotlightDetails[i].a.adType =='64887c11cce361dafc86c23b' ){
  	var baners =  spotlightDetails[i].a.content.banners;
  		    	
  	if(baners !=null )
  		{
  		 banner1 = baners[0];
  		
  	//console.log('inside if baners!=null');
  		 if(baners[1] != undefined ){		
  			 banner2 = baners[1];
  		 }
  		}
  	}
  	 //banner1="nopreview.jpg";
  	// banner2 = "nopreview.jpg";
  /* 	if(myList.companies==null || myList.companies==undefined){//console.log('inside if'+publisher_name);
   	companyName=publisher_name;}
   	else{	     	 companyName= myList.companies.name;}*/
		//console.log('company name : '+companyName);
   
   // Create a formatter with custom options
   const formatter = new Intl.DateTimeFormat('en-GB', {
       day: 'numeric',
       month: 'long',
       year: 'numeric'
   });
	// banner1="nopreview.jpg";
  //	 banner2 = "nopreview.jpg";
   const formattedDate = formatter.format(date);
 //  console.log(formattedDate); // e.g., "29 August 2024"
   	//onclick=nextui(this);
   	 var img_path = "";
   	 k++;
   	 var carouselid= 'myCarousel'+k;
 var ad_card=	'<div class="panel panel-default"        >'
   	 
 
   	 +'<div class="panel-body" >'
   	 +'<div class="carousel-container">'
   	 +'<div id="'+carouselid+'" class="carousel slide" data-ride="carousel">'
   	 +'<ol class="carousel-indicators"><li data-target="#'+carouselid+'" data-slide-to="0" class="active"></li><li data-target="#'+carouselid+'" data-slide-to="1"></li><li data-target="#'+carouselid+'" data-slide-to="2"></li></ol>'
       +'<div class="carousel-inner"><div class="item active">'
       +'<img src="<c:url value="'+thumbnail+'" />" alt="Los Angeles" style ="width: 200px;height: 100%;border-bottom-left-radius: 20px;border-top-left-radius: 20px;max-height: 249px;"></div>'
       +'<div class="item">'
       
       +'<img src="<c:url value="'+banner1+'" />" alt="Chicago" style ="width: 200px;height: 100%;border-bottom-left-radius: 20px;border-top-left-radius: 20px;max-height: 249px;" ></div>'
       +'<div class="item"><img src="<c:url value="'+banner2+'" />" alt="New York" style ="width: 200px;height: 100%;border-bottom-left-radius: 20px;border-top-left-radius: 20px;max-height: 249px;"></div></div>'
       +' <a class="left carousel-control" href="#'+carouselid+'" data-slide="prev" ><span class="glyphicon glyphicon-chevron-left"></span><span class="sr-only">Previous</span></a>'
       +' <a class="right carousel-control" href="#'+carouselid+'" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span><span class="sr-only">Next</span></a></div>'
       
       +'</div>'
       +'<div class= "textcontainer" > <p style="color: #000;font-family: Inter;font-size: 18px;font-style: normal;font-weight: 700;line-height: normal;align-self: stretch;">'+publisher_name+'</p>'
       +'<p class="description" style = "display: -webkit-box;-webkit-box-orient: vertical;-webkit-line-clamp: 3;align-self: stretch;overflow: hidden;color: #000;text-overflow: ellipsis;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">'+description+'<h5 class="expires"> Expires on '+dates+'</h5>'
       +'<div class ="button-group"><button style = "outline: none;background-color: white;border: none;width: 25px; border-radius: 5px;" onclick=phone('+phno+');>  <i class="fa fa-phone" aria-hidden="true"> </i></button>'
       +'<button style = "outline: none;background-color: white;border: none;width: 25px;border-radius: 5px;" onclick=whatsapp('+phno+');><i class="fa fa-whatsapp" aria-hidden="true"></i></button><button style = "outline: none;background-color: white;border: none;width: 25px;border-radius: 5px;"><i class="fa fa-envelope"></i></button>'
       +'<button type="button" class="btn btn-default" id = "takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+');><i class="fa fa-map-marker" aria-hidden="true" style = "font-size:17px;color: #F27C0A;">&nbsp;Take me there</i></button></div>';

   	 $('.onead').append(ad_card); 


//var dist=getDistanceFromLatLonInKm(myList.location.lat,myList.location.lng,latt,lngg).toFixed(1);
//  locations.push(  [myList.location.lat,myList.location.lng,publisher_name,publisher_name]);
//console.log('dist value is :' +dist);
//if(dist<=1.3)	{}	 
   	document.getElementById('nooffollow').innerText = nooffol;
   	document.getElementById('noofcamp').innerText = noofcam;
   	
   	document.getElementById('publishername').innerText = publisherName;
   	document.getElementById('profilepic').src = profilepic;
   	locations.push(  [spotlightDetails[i].location.lat,spotlightDetails[i].location.lng,publisher_name,publisher_name]);
   	
   	//to bring marker on map
	var zoom_val=0;

  	var infowindow = new google.maps.InfoWindow();
//console.log('contents of array:  '+locations);
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
  	    	          infowindow.setContent('<b>Publisher Name:</b>&nbsp;'+ locations[i][3]);
  	    	          infowindow.open(map, marker);
  	    	        }
  	    	      })(marker, i));
  	    	      markers.push(marker);
  	    	  //    console.log('marker aray :  ' +markers);
  	}      	  
 }
 
 //on chNGE OF SLIDER VALUE starts here
 function sliderClick(){
	   var slider = document.getElementById('rangeOutputId');
       var sliderValue = document.getElementById('rangeInputId');
       slider.value = sliderValue.value;
     
      var s = sliderValue.value;
     // console.log('s: '+s);
     var k =0;
       $.ajax({
           url: '${pageContext.request.contextPath}/spotlightslider',
           type: "GET",
           //contentType: 'application/json',
           data:{slidervalue:s},
           success: function(response) {
              // console.log('Success:', response);
               let x = JSON.stringify(response);      
               $(".onead").html("");
               //console.log(x);
           //    document.getElementById("adcards").innerHTML = "";
              for (var i = 0; i < markers.length; i++) {
   	   markers[i].setMap(null); // Remove marker from the map
   	 
   	  // locations[i]=null;
         }
      locations = []; // Clear the array of markers
     /* circles.forEach(circle => {
          circle.setMap(null); // Remove circle from the map
      });
      circles.length = 0; // Clear the array*/
      
 
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
   	    		
   	    	console.log('inside if baners!=null');
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
      	   var ad_card=	'<div class="panel panel-default "   role = "button" id = '+adsid+' onclick=nextui(this);>'
      	     	
      	     	 +'<div class="panel-body" style = "display:flex;flex-direction:row;">'
      	     	+'<div class="carousel-container">'
      	     	 
      	     	 +'<div id="'+carouselid+'" class="carousel slide" data-ride="carousel">'
      	     	 +'<ol class="carousel-indicators"><li data-target="#'+carouselid+'" data-slide-to="0" class="active"></li><li data-target="#'+carouselid+'" data-slide-to="1"></li><li data-target="#'+carouselid+'" data-slide-to="2"></li></ol>'
                   +'<div class="carousel-inner"><div class="item active"><img src="<c:url value="'+thumbnail+'" />" alt="Los Angeles" style ="width: 200px;height: 100%;border-bottom-left-radius: 20px;border-top-left-radius: 20px;max-height: 249px;"></div>'
                   +'<div class="item"><img src="<c:url value="'+banner1+'" />" alt="Chicago" style ="width: 200px;height: 100%;border-bottom-left-radius: 20px;border-top-left-radius: 20px;max-height: 249px;"></div><div class="item"><img src="<c:url value="'+banner2+'" />" alt="New York" style ="width: 200px;height: 100%;border-bottom-left-radius: 20px;border-top-left-radius: 20px;max-height: 249px;"></div></div>'
                   +' <a class="left carousel-control" href="#'+carouselid+'" data-slide="prev"><span class="glyphicon glyphicon-chevron-left"></span><span class="sr-only">Previous</span></a>'
                   +' <a class="right carousel-control" href="#'+carouselid+'" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span><span class="sr-only">Next</span></a></div>'
                   +'</div>'
                   +'<div class= "textcontainer" > <p style="color: #000;font-family: Inter;font-size: 18px;font-style: normal;font-weight: 700;line-height: normal;align-self: stretch;">'+publisher_name+'</p><p class="description">'+description+'<h5 class="expires"> Expires on '+dates+'</h5>'
                   +'  <div class ="button-group"><button style = "outline: none;background-color: white;border: none;" onclick=phone('+phno+');>  <i class="fa fa-phone" aria-hidden="true"></i></button>'
                   +'<button style = "outline: none;background-color: white;border: none;" onclick=whatsapp('+phno+');><i class="fa fa-whatsapp" aria-hidden="true"></i></button><button style = "outline: none;background-color: white;border: none;"><i class="fa fa-envelope"></i></button>'
                   +'<button type="button" class="btn btn-default" id = "takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takeme('+latitudes+','+longitudes+');><i class="fa fa-map-marker" aria-hidden="true" style = "font-size:17px;color: #F27C0A;">&nbsp;Take me there</i></button></div>';

      	     	 $('.onead').append(ad_card); 
      	
   	      
    /*  var dist=getDistanceFromLatLonInKm(myList.location.lat,myList.location.lng,lat,lng).toFixed(1);
      //console.log('dist value is :' +dist);
        if(dist<=s)
      	{	}*/
   	   locations.push(  [myList.location.lat,myList.location.lng,publisher_name,publisher_name]);
      	
      	 
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
           },//success
       });
 }
</script>
</body>
</html>