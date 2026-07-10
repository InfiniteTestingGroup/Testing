<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
      <%@ taglib prefix="form"  uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 <jsp:include page="responsiveheaderspotlight.jsp" />
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
 
<style>
html {
    height: 100%;
     overflow-x: hidden;
     max-width:100%;
}
body {
    min-height: 100%;
    background-color: #f1f1f1;
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
/*
display: flex;
flex-direction: row;
align-items: center;
padding: 16px;
gap: 17px;
width: 100%;
/*overflow-x: scroll;*/
/*flex: none;
align-self: stretch;
flex-grow: 1;
*/
 /*overflow-x: auto;*/ /* Enable horizontal scrolling */
     /* -webkit-overflow-scrolling: touch; /* Smooth scroll for touch devices */
    /*  scroll-snap-type: x mandatory; /* Enable scroll snapping */
    /* overflow:hidden;*/
    
    
   display: flex;
flex-direction: row;
align-items: center;
padding: 10px 16px;
gap: 17px;

width: 360px;
height: 115px;
/*overflow-x: scroll;*/
/* Inside auto layout */
flex: none;
order: 0;
align-self: stretch;
flex-grow: 0;    
}


/* For WebKit browsers (Chrome, Safari, Edge) to hide scrollbar */
 .spotlightlist::-webkit-scrollbar {
      display: none; /* Hide scrollbar */
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
 scroll-snap-align: start; /* Snap to the start of the item */
/* min-width: 100%; flex-shrink: 0; transition: transform 0.3s ease;*/
}
.spotlightimg
{
border-radius: 50%;
}
#profile
{
display: flex;
flex-direction: row;
justify-content: center;
align-items: center;
padding: 10px 40px;
gap: 10px;
border-radius: 0px 5px 5px 0px;
flex: none;
order: 1;
flex-grow: 1;color:black;outline:none;border-color:black;
}
#posts
{
display: flex;
flex-direction: row;
justify-content: center;
align-items: center;
padding: 10px 40px;
gap: 10px;
border-radius: 0px 5px 5px 0px;color:black;
flex: none;
order: 1;
flex-grow: 1;outline:none;border-color:black;
}
.btn-group .btn.active { /*background: linear-gradient(90deg, #F27C0A 0%, #F2382C 100%), #FFFFFF; /* Color of the active button */

background: linear-gradient(90deg, #F27C0A 0%, #F2382C 100%), #FFFFFF; /* Highlight color for active button */
    color: white;

 }
.campaignnumber
{
display: flex;
flex-direction: column;
align-items: center;
padding: 30px 10px;
gap: 24px;
width: 100%;/*328px;*/
/*height: 420px;*/
background: #FFFFFF;
border-radius: 20px;
flex: none;
align-self: stretch;
flex-grow: 0;/*margin-left: 23px;*/
}
.followspotlight
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
    border-radius: 10px;
    background: #FFF;    
        border: solid 1px;
    padding: 8px;    
}
.newStyle
{
display: flex;
flex-direction: row;
justify-content: center;
align-items: center;
padding: 10px 20px;
gap: 10px;
width: 149.5px;
height: 42px;
background: linear-gradient(90deg, #F27C0A 0%, #F2382C 100%);
border-radius: 10px;
flex: none;
flex-grow: 0;border: none;
font-family: 'Inter';
font-style: normal;
font-weight: 700;
font-size: 18px;
line-height: 22px;
color: #FFFFFF;
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
display: flex; flex-direction: row; align-items: center; padding: 25px 15px !important; gap: 35px;  width: 100%;
height: 34px;  flex: none; order: 2; align-self: stretch;flex-grow: 0; background-color:#FFF !important;border-top:none !important;
border-bottom-left-radius: 20px !important;border-bottom-right-radius: 20px !important;}
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
flex-grow: 0;border:none;outline:none;font-family: 'Inter';font-style: normal;font-weight: 700;
font-size: 12px;line-height: 15px;color: #FFFFFF;
}
.fade.in {
    opacity: 1;
    background: initial;
}
.adcard
{
display:none;
}
 .campaignbtngrp button  {
    color: #F2382C;
    background-color: white;
    border-color: white;
    outline: none;
    padding:5px;
    }
    
   .campaignbtngrp  .actives { background-color: #F2382C !important; color: white !important; }
   
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
</style>
</head>
<body>
<div style = "background: #F0F0F0;/*height:100%;*/margin-top: 10px;">
<div class= "ad-container" style ="display: flex;flex-direction: column;align-items: flex-start;padding-left:13px;width: 100%;/*height:100vh;*/padding-right:13px;
/*overflow-y: scroll;*/background: #F0F0F0;flex: none;align-self: stretch;flex-grow: 1;gap:15px;justify-content:center;position:relative;padding-bottom: 30px;padding:15px;/*overflow:hidden;*/">
<div class="spotlightlist" id ="spotlightlist" ></div>

<div class="btn-group" style ="display: flex;flex-direction: row;align-items: flex-start;padding: 3px;
overflow-y: scroll;/*border: 1px solid #D6D6D6;*/border-radius: 5px;flex: none;order: 0;align-self: stretch;flex-grow: 0;width: 96%;
    margin-left: 9px;">
    <button type="button" class="btn active" id ="profile" onclick="setActiveButton(this);">PROFILE</button>
    <button type="button" class="btn" id ="posts" onclick="setActiveButton(this);">POSTS</button>
   
  </div>
  <div class= "campaignbtngroup" style ="display:none;"><div class = "campaignbtngrp" style ="align-items: flex-end;justify-content: space-between;display: flex;flex-direction: row;padding-left: 160px;">
<button id="active" class="actives" onclick="setCampaign(this)">Active</button>
<button id="completed" onclick="setCampaign(this)">Completed</button>
<button id="all"  onclick="setCampaign(this)">All</button>
</div><!--campaignbtngrp  -->
</div><!-- campaignbtngroup -->
 <div class="campaignnumbercontainer" style ="display: block;margin-top: 5px;/*margin-left: 12px;*/height: 100%;width: 100%;"> 
<div class= "campaign" style ="margin-bottom:100px;padding: 10px;">
<div class= "campaignnumber" >
  <div><img  src="/Default_pfp.jpg"  alt="" style="width: 30px;height: 30px;" id="profilepic"/></div>
  <p id ="publishername" style ="font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 18px;line-height: 22px;color: #000000;">Publisher Name</p>
  <div style ="display: flex;flex-direction: row;justify-content: center;align-items: center;padding: 0px;gap: 30px;flex: none;align-self: stretch;flex-grow: 0;">
<div style ="display: flex;flex-direction: column;align-items: center;padding: 0px;gap: 10px;width: 89.33px;
height: 55px;flex: none;flex-grow: 0;" id="followers">
<div style ="display: flex;flex-direction: row;align-items: center;padding: 0px;gap: 10px;width: 63px;height: 29px;
flex: none;flex-grow: 0;">
<svg width="25" height="25" viewBox="0 0 25 25" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_50_3538)">
<path d="M19.4493 20.2407H19.9393C21.0893 20.2407 22.0043 19.7167 22.8253 18.9847C24.9113 17.1237 20.0073 15.2407 18.3333 15.2407M16.3333 5.30972C16.5606 5.26372 16.7956 5.24072 17.0383 5.24072C18.8583 5.24072 20.3333 6.58372 20.3333 8.24072C20.3333 9.89772 18.8583 11.2407 17.0383 11.2407C16.7956 11.2407 16.5606 11.2177 16.3333 11.1717M5.3143 16.3517C4.1353 16.9837 1.0443 18.2737 2.9273 19.8877C3.8473 20.6767 4.8713 21.2407 6.1593 21.2407H13.5073C14.7953 21.2407 15.8193 20.6767 16.7393 19.8877C18.6223 18.2737 15.5313 16.9837 14.3523 16.3517C11.5873 14.8707 8.0793 14.8707 5.3143 16.3517ZM13.8333 7.74072C13.8333 8.80159 13.4119 9.819 12.6617 10.5691C11.9116 11.3193 10.8942 11.7407 9.8333 11.7407C8.77243 11.7407 7.75501 11.3193 7.00487 10.5691C6.25472 9.819 5.8333 8.80159 5.8333 7.74072C5.8333 6.67986 6.25472 5.66244 7.00487 4.9123C7.75501 4.16215 8.77243 3.74072 9.8333 3.74072C10.8942 3.74072 11.9116 4.16215 12.6617 4.9123C13.4119 5.66244 13.8333 6.67986 13.8333 7.74072Z" stroke="black" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</g>
<defs>
<clipPath id="clip0_50_3538">
<rect width="24" height="24" fill="white" transform="translate(0.833252 0.240723)"/>
</clipPath>
</defs>
</svg>
<div id = "nooffollow" style ="font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 24px;line-height: 29px;color: #000000;"></div>
</div>
<p style="font-family: 'Inter';font-style: normal;font-weight: 400;font-size: 13px;line-height: 16px;text-align: center;color: #000000;opacity: 0.5;"> Followers</p>
</div>

<div id = "campaigns" style ="display: flex;flex-direction: column;align-items: center;padding: 0px;gap: 10px;width: 89.33px;height: 55px;
flex: none;flex-grow: 0;">
<div style="display: flex;flex-direction: row;align-items: center;padding: 0px;gap: 10px;width: 50px;height: 29px;flex: none;flex-grow: 0;">
<svg width="25" height="25" viewBox="0 0 25 25" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M8.66663 10.7407V9.74072H15.6666V10.7407H8.66663ZM8.66663 13.7407V12.7407H15.6666V13.7407H8.66663ZM8.66663 16.7407V15.7407H15.6666V16.7407H8.66663ZM18.1666 8.24072V6.24072H16.1666V5.24072H18.1666V3.24072H19.1666V5.24072H21.1666V6.24072H19.1666V8.24072H18.1666ZM4.16663 20.2407V4.24072H15.0896V5.24072H5.16663V19.2407H19.1666V9.31772H20.1666V20.2407H4.16663Z" fill="black"/>
</svg>
<p id ="noofcamp" style ="font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 24px;line-height: 29px;color: #000000;"></p>

</div>

<p style="font-family: 'Inter';font-style: normal;font-weight: 400;font-size: 13px;line-height: 16px;text-align: center;color: #000000;opacity: 0.5;"> Campaigns</p>

</div>
</div>

<div class="btn-grp" style ="display: flex;flex-direction: row;align-items: flex-start;padding: 20px;gap: 55px;flex: none;flex-grow: 0;justify-content: center;">
<div class="phone"  ><button id ="campaignnumberphone" data-value ="" onclick="phonefromcampaign();" style="border:none;outline:none;background:none;"><i class="fa fa-phone" style="font-size:30px;"></i></button></div>
<div class="whatsapp" ><button id ="campaignnumberwhatsapp" data-value="" onclick="whatsappfromcampaign();" style="border:none;outline:none;background:none;"><i class="fa fa-whatsapp" style="font-size:30px;"></i></button></div>
<div class="email" id ="campaignnumberemail"><i class="fa fa-envelope" style="font-size:30px;"></i></div>


</div><!-- btn-grp -->
<div class="followbutton">
<button style ="outline:none;" class ="followspotlight" id = "followspotlight" value="0" onclick="follow();">Follow <i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button>


</div><!-- followbutton -->
</div> <!-- campaignnumber -->
</div><!-- campaign -->
    </div> <!-- campaignnumbercontainer --> 
    <div class="adcard" style="background: #F0F0F0;display:none;width: 96%;margin-left: 8px;margin-bottom:5px;"></div>
 </div><!--ad-container  -->
</div>
<!-- ad detail modal start here -->
<div id="addetailModal" class="modal fullscreen-modal" role="dialog" >
  <div class="modal-dialog fullscreen-modal-dialog">

    <!-- Modal content-->
    <div class="modal-content fullscreen-modal-content">
      <div class="modal-header" style ="justify-content: flex-start;gap:18px;">
     <button style ="border:none;outline:none;" data-dismiss="modal"> <svg width="12" height="24" viewBox="0 0 12 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M10 19.438L8.95502 20.5L1.28902 12.71C1.10452 12.5197 1.00134 12.2651 1.00134 12C1.00134 11.7349 1.10452 11.4803 1.28902 11.29L8.95502 3.5L10 4.563L2.68202 12L10 19.438Z" fill="black"/>
</svg></button>  
        <img   style="height:30px;width:30px;" alt="User profile" class="spotlightimg" id="companyimg"/>
        <div ><h5  style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;" id="companyname"></h5></div>
        <div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>
      </div>
      <div class="modal-body" style ="height:auto;gap:12px;">
      <div class="carousel-container" style ="height:100%;width:100%;order:1;" id = "addetailModalcarousel-container">
      <div  class="carousel slide" data-ride="carousel" id="addetailcarousel">
        <ol class="carousel-indicators">
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
      <span class="glyphicon glyphicon-chevron-left" ></span>
      <span class="sr-only">Previous</span>
      </a>
      <a class="right carousel-control" href="#addetailcarousel" data-slide="next">
      <span class="glyphicon glyphicon-chevron-right" ></span>
      <span class="sr-only">Next</span>
      </a> 
      </div><!-- slide -->
    
      </div><!-- carousel container -->
      <div class="image-container" style ="display:flex;flex-direction:row;gap:20px;order:2;width:100%" id = "image-container" >
      </div>
         <p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;" id="pexpiry"></p>
         <div class="buttons-container" style ="display:flex;flex-direction:row;gap:35px;justify-content: center;    align-items: center;" id ="buttons-container">
      <div class="phone" id ="phone" data-value="12345" onclick="phonefrommodal();"><i class="fa fa-phone" style="font-size:20px;"></i></div>
      <div class="whatsapp" id ="whatsapp"  data-value="12345" onclick="whatsappfrommodal();"><i class="fa fa-whatsapp" style="font-size:20px;"></i></div>
      <div class="email" id ="email"><i class="fa fa-envelope" style="font-size:20px;"></i></div>
      <div class="takeme" ><button  id ="addetailmodaltakeme"  style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Take me there</button></div>
      </div>
      <div class="text-container" id = "addetailModaltext-container">
      <p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;" id="ptitle"></p>
      <p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;" id="pdescription"></p>
      <div id ="customtextsection"></div>
   
      </div><!-- text-container -->
 
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
      
      </div><!--validity-container  -->
   <!--  <div class="line" style = "width: 328px;height: 0px;opacity: 0.1;border: 0.923913px solid #000000;flex: none;/*order: 2;*/align-self: stretch;flex-grow: 0;"></div>-->  
<!--     <div style="width:100%;">  <h4 style ="/*width: 182px;*/height: 17px;font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 14px;line-height: 17px;color: #000000;
flex: none;order: 2;flex-grow: 0;text-align:center;">Other ads by the publisher </h4></div>
 <div class="otheradsbypubli" style ="display:flex;flex-direction:column;gap:10px;"></div> -->

              </div><!-- modal body -->
     
      </div>
    </div>

  </div>
<!--  </div>-->
<!--ad detail modal end here --> 
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
var users = ${users};
document.addEventListener("DOMContentLoaded", function() {	
//to load spotlights start here
var spotlight="";
var x=0;
for(var i=0;i<users.length;i++)
{
	spotlightId = users[1].id;
	var name =users[i].fullName;
	var profilepicpath= users[i].profilePicPath;
	var str = name.substring(0, 10);
	var userid = users[i].id;
	spotlight+='<div class="spotlightitem" role="button" id = "'+userid+'" onclick="toaddevent(this);" >'
+'	<img  src="<c:url value="'+profilepicpath+'" />"  alt="User profile" style="width: 37px;height: 39px;" class="spotlightimg"/>'
		+'<div class="companyname">'+str+'</div>'
+'</div>';    
} 
 $('.spotlightlist').append(spotlight);
 
 /*var spotlightItem = document.querySelectorAll('.spotlightitem');
 var secondItem = spotlightItem[1];

 secondItem.style.width= '73px';
 secondItem.style.height='95px';
 secondItem.style.background= 'linear-gradient(90deg, rgba(242, 124, 10, 0.1) 0%, rgba(242, 56, 44, 0.1) 100%)';*/
 //to load spotlights end here
 });
const swipeWrapper = document.getElementById('spotlightlist');
//document.addEventListener("DOMContentLoaded", function() {
	//function swipe(){
//dragging listener for spotlight starts here 2 
let currentPage = 1;  // Keep track of the current page of items
let isLoading = false;  // Prevent multiple loads at the same time

const swipeContainer = document.querySelector('.spotlightlists');
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
function loadItems(page) {
    if (isLoading) return;  // Prevent loading if already in progress
    isLoading = true;
    // Simulate loading by adding 5 new items
    setTimeout(function() {
        let newItems = [];
        for (let i = 0; i < users.length; i++) {
        	var name =users[i].fullName;
      //  	console.log('name: ' +users[2].fullName);
   		 var profilepicpath= users[i].profilePicPath;
   			var str = name.substring(0, 10);
   			var userid = users[i].id;
            newItems.push('<div class="spotlightitem" role="button" id = "'+userid+'"  >'
            		+'	<img  src="<c:url value="'+profilepicpath+'" />"  alt="User profile" style="width: 37px;height: 39px;" class="spotlightimg"/>'
            				+'<div class="companyname">'+str+'</div>'
            		+' 		</div>');
        }

        // Append new items to the swipe-wrapper
        swipeWrapper.innerHTML += newItems.join('');
        isLoading = false;
    }, 1000);  // Simulate network delay (1 second)
}
//});
//}
///window.onload = swipe;

//window.onload = function() { swipe(); };
// Initial loading of items
//swipe spotlight end here
//to change the colour of the button on click start here
// Get all buttons in the button group 
/*var buttons = document.querySelectorAll('.btn-group button'); // Add event listener to each button 
buttons.forEach(function(button) { 
	console.log('inside button click');
	button.addEventListener('click', function() { // Remove 'active' class from all buttons 
		buttons.forEach(function(btn) { btn.classList.remove('active'); }); // Add 'active' class to the clicked button
		this.classList.add('active'); }); });*/
function setActiveButton(button) {	 
    const buttons = button.parentNode.querySelectorAll('.btn');// Remove 'active' class from all buttons in the group
    buttons.forEach(btn => btn.classList.remove('active'));    
    button.classList.add('active');// Add 'active' class to the clicked button
    var buttonId = button.id;

    if (buttonId=="posts"){
    var div = document.querySelector(".campaignnumbercontainer");//change here
	div.style.display='none';
	var div3 = document.querySelector(".adcard");
	  div3.style.display='block';
	  var div4 = document.querySelector(".campaignbtngroup");
	  div4.style.display='block';
	}    
    if (buttonId=="profile"){ 
    	  var div3 = document.querySelector(".adcard");
    	  div3.style.display='none'; 
    	  var div2 = document.querySelector(".campaignnumbercontainer");
    	  div2.style.display='block';
    	  var div4 = document.querySelector(".campaignbtngroup");
    	  div4.style.display='none';
    }
}
//to change the colour of the button on click end here
//window.onload waits for everything (including images, scripts, etc.) to load, not just the DOM:
/*window.onload = function() {
  initialFunction();
};*/
/*function fetchData(url) { return new Promise((resolve, reject) => { $.ajax({ url: url, type: 'GET', success: function(response) { resolve(response); }, error: function(error) { reject(error); } }); }); } fetchData('your-url-here') .then(response => { console.log('Data:', response); }) .catch(error => { console.error('Error:', error); });*/
function setCampaign(button)
{
	 const campaignbuttons = document.querySelectorAll('.campaignbtngrp button' );//for all campagin coomplted
	 campaignbuttons.forEach(btn => btn.classList.remove('actives'));
     const buttonactive = document.getElementById(button.id); 
     buttonactive.classList.add('actives');
     var buttonval = button.id;
     var k=0;
	// var container = document.querySelector('.ad-container');
	 var container = document.getElementsByClassName("ad-container");
	 var div4 = document.querySelector(".campaignnumbercontainer");
	 //div4.innerHTML='';
	
	var other_ad_card ='';
	var id =0;
     $.ajax({
         url: '${pageContext.request.contextPath}/ads', // Sample API endpoint
         method: 'GET',
         async:false,
         contentType: 'text/plain',
         data: {spotlightId:spotlightId,buttonval:buttonval},
         success: function(data) {
             // Clear previous data           // Iterate through the data and display it
         	  $.each(data, function (i, myList) {
       //	     	  console.log('data1' + JSON.stringify(myList));
       	     	  var adsid = myList.id;
       	     	 var phno = myList.phoneNumber;
       	     	// console.log('phno : ' +phno);
       	     	 var email= myList.emailAddress;
       	     	 var publisher_name = myList.a.title;
       	     	var publisherName= myList.fullName;
       	     	// console.log(''+publisherName);
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
       	  	var createdBy = myList.createdBy;
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
       	  
       	     	 var img_path = "";
       	     	 k++;
       	    	var carouselid= 'myCarouselspotlyt'+k;
      	    	 //onclick=nextui(this);							     	 
      	 	 if(buttonval=="active"){
  other_ad_card +='<div ><div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
      	 	 +'<div class="panel-heading">'
      	     +'<img src="<c:url value="'+companyLogoUrl+'" />" style="height:30px;width:30px;" alt="User profile" class="spotlightimg" />'
      	     +'<div id="frame20"><h5 id="publishername" style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">'+companyName+' </h5></div>'
      	     +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
      	     +'<div class="saved"><svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/></svg>'
      	     +'</div>'
      	     +'</div>'//heading
      	 +'<div class="panel-body" style="padding:0px !important;">'
      	 +'<div class="carousel-container" style = "border-top-left-radius: 20px;border-top-right-radius: 20px;overflow: hidden;background:transparent">'
      	 +'<div  class="carousel slide" data-ride="carousel" id="'+carouselid+'">'
      	 +'<ol class="carousel-indicators">'
      	 +'<li data-target="#'+carouselid+'"  data-slide-to="0" class="active"></li>'// Indicators
      	 +'<li data-target="#'+carouselid+'" data-slide-to="1"></li>'
      	 +'<li data-target="#'+carouselid+'"  data-slide-to="2"></li>'
      	 +'</ol>'
      	 +'<div class="carousel-inner">'
      	 +'<div class="item active">'///tomato.jpg
      	 +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" style ="display: block;max-width: 100%;height: 200px;width: 100%;border-top-left-radius:20px;border-top-right-radius:20px;  background-color: transparent; object-fit: cover;  ">'
      	 +'</div>'
      	 +'<div class="item">'
      	 +'<img src="<c:url value="'+banner1+'" />" alt="Image" style ="display: block;max-width: 100%;height: 200px;width: 100%;border-top-left-radius:20px;border-top-right-radius:20px;">'
      	 +'</div>'
      	 +'<div class="item">'
      	 +'<img src="<c:url value="'+banner2+'" />" alt="Image" style ="display: block;max-width: 100%;height: 200px;width: 100%;border-top-left-radius:20px;border-top-right-radius:20px;">'
      	 +'</div>'
      	 +'</div>'
      	 +'<a class="left carousel-control" href="#'+carouselid+'" data-slide="prev" >'// Left and right controls 
      	 +'<span class="glyphicon glyphicon-chevron-left" aria-hidden="true" style ="display:none;"></span>'
      	 +'<span class="sr-only">Previous</span>'
      	 +'</a>'
      	 +'<a class="right carousel-control" href="#'+carouselid+'" data-slide="next" >'
      	 +'<span class="glyphicon glyphicon-chevron-right" aria-hidden="true" style ="display:none;"></span>'
      	 +'<span class="sr-only">Next</span>'
      	 +'</a>'
      	 +'</div>'
      	 +'</div>'// carousel container 
      	 +'<div class="text-container">'
      	 +'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;">'+publisher_name+'</p>'
      	 +'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+description+'</p>'
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
      	 +'</div></div>';
      	 	 }
      	 	 
      	 	 else
      	 		 {
      	 		 other_ad_card +='<div ><div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
          	 	 +'<div class="panel-heading">'
          	     +'<img src="<c:url value="'+companyLogoUrl+'" />" style="height:30px;width:30px;" alt="User profile" class="spotlightimg" />'
          	     +'<div id="frame20"><h5 id="publishername" style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">'+companyName+' </h5></div>'
          	     +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
          	     +'<div class="saved"><svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/></svg>'
          	     +'</div>'
          	     +'</div>'//heading
          	 +'<div class="panel-body" style="padding:0px !important;">'
          	 +'<div class="carousel-container" style = "border-top-left-radius: 20px;border-top-right-radius: 20px;overflow: hidden;background:transparent">'
          	 +'<div  class="carousel slide" data-ride="carousel" id="'+carouselid+'">'
          	 +'<ol class="carousel-indicators">'
          	 +'<li data-target="#'+carouselid+'"  data-slide-to="0" class="active"></li>'// Indicators
          	 +'<li data-target="#'+carouselid+'" data-slide-to="1"></li>'
          	 +'<li data-target="#'+carouselid+'"  data-slide-to="2"></li>'
          	 +'</ol>'
          	 +'<div class="carousel-inner">'
          	 +'<div class="item active">'///tomato.jpg
          	 +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" style ="display: block;max-width: 100%;height: 200px;width: 100%;border-top-left-radius:20px;border-top-right-radius:20px;  background-color: transparent; object-fit: cover;  ">'
          	 +'</div>'
          	 +'<div class="item">'
          	 +'<img src="<c:url value="'+banner1+'" />" alt="Image" style ="display: block;max-width: 100%;height: 200px;width: 100%;border-top-left-radius:20px;border-top-right-radius:20px;">'
          	 +'</div>'
          	 +'<div class="item">'
          	 +'<img src="<c:url value="'+banner2+'" />" alt="Image" style ="display: block;max-width: 100%;height: 200px;width: 100%;border-top-left-radius:20px;border-top-right-radius:20px;">'
          	 +'</div>'
          	 +'</div>'
          	 +'<a class="left carousel-control" href="#'+carouselid+'" data-slide="prev">'// Left and right controls 
          	 +'<span class="glyphicon glyphicon-chevron-left" aria-hidden="true" style ="display:none;"></span>'
          	 +'<span class="sr-only">Previous</span>'
          	 +'</a>'
          	 +'<a class="right carousel-control" href="#'+carouselid+'" data-slide="next">'
          	 +'<span class="glyphicon glyphicon-chevron-right" aria-hidden="true" style ="display:none;"></span>'
          	 +'<span class="sr-only">Next</span>'
          	 +'</a>'
          	 +'</div>'
          	 +'</div>'// carousel container 
          	 +'<div class="text-container">'
          	 +'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;">'+publisher_name+'</p>'
          	 +'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+description+'</p>'
          	 +'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'
          	 +'</div>'
          	 +'</div>'//<!-- panel body --> 
          	 +'<div class="line" style ="width: 90%;    margin: 11px 11px;    border-top: 2px solid black;   opacity: 0.1; "></div>'
          	 +'<div class="panel-footer">'
          	
          	 +'</div>'
          	 +'</div></div>';
      	 		 }
      	 //$(".otheradsbypubli").append(other_ad_card);
      	 // Insert the new div in the same place as the old div
      	 //  container.insertBefore(other_ad_card, null); // Insert it at the end of the flex container
      	// container.append(other_ad_card);	
      	
      	// 
      
     	/*    document.getElementById('nooffollow').innerText = nooffol;
	     	document.getElementById('noofcamp').innerText = noofcam;
	     	document.getElementById('publishername').innerText = publisherName;
//  	   	document.getElementById('publishername').innerText = publisherName;
	     	document.getElementById('profilepic').src = profilepic;*/ 
       	        	  }); //.each
       	        //	 console.log('other_ad_card: ' +other_ad_card);
         	 var div5 = document.querySelector(".adcard");
             div5.innerHTML ="";         	
         	 div5.innerHTML +=other_ad_card;
         	// Remove the 'active' class from all buttons
             const buttons = document.querySelectorAll('.btn');
             buttons.forEach(btn => btn.classList.remove('active'));

             // Add the 'active' class to the button with the given id
          /*   const activeButton = document.getElementById("profile");
             activeButton.classList.add('active');
             
             var div3 = document.querySelector(".adcard");
       	  div3.style.display='none'; 
       	  var div2 = document.querySelector(".campaignnumbercontainer");
       	  div2.style.display='block';*/
        	 
          const activeButton = document.getElementById("posts");
          activeButton.classList.add('active');
          
          var div3 = document.querySelector(".adcard");
    	  div3.style.display='block'; 
    	  var div2 = document.querySelector(".campaignnumbercontainer");
    	  div2.style.display='none';
        	 
       	        	},    //successs     
        
         error: function(xhr, status, error) {
        
             console.error(error);
         }
     });
     
   
  
   // showorhide();
}
function showorhide(other_ad_card)
{
//	console.log(other_ad_card);
    const buttons = document.querySelectorAll('.btn');
    buttons.forEach(btn => btn.classList.remove('active'));

    // Add the 'active' class to the button with the given id
    const activeButton = document.getElementById("profile");
    activeButton.classList.add('active');
    
    var div3 = document.getElementsByClassName("adcard");
	 if(div3){ div3.style.display='none';}
	  var div2 = document.getElementsByClassName("campaign");
	  if(div2){div2.style.display='block';} 	
	
	
}
window.onload = initialFunction;
//initialFunction();
function initialFunction()
{
	var spotlyt = ${spotlightDetails};
	var k=0;
	var container = document.querySelector('.adcard');   
	var other_ad_card="";	var createdby;
	
	 if(latitudefromsession==null)
	 {
           //console.log('latitudefromsession is null');
           getCurrentLocations();
      }
	 else
	{	 
	 $.each(spotlyt, function (i, myList) {
	  var adsid = myList.id;
   	  var phno = myList.phoneNumber;
   	 var email= myList.emailAddress;
   	 var publisher_name = myList.a.title; var publisherName= myList.fullName;
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
  	var createdBy = myList.createdBy;createdby=createdBy;
  	var nooffol = myList.noOfFollow;
   	var noofcam = myList.noOfCampaigns;
  	    var profilepic= myList.profilePicturePath;var createdBy = myList.createdBy;spotlightId = myList.createdBy;
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
   	 var carouselid= 'myCarouselspotlyt'+k;
   	 //onclick=nextui(this);							     	 
	 
other_ad_card += '<div><div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\'); >'
	+'<div class="panel-heading">'
    +'<img src="<c:url value="'+companyLogoUrl+'" />" style="height:30px;width:30px;" alt="User profile" class="spotlightimg" />'
    +'<div id="frame20"><h5 id="publishername" style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">'+companyName+' </h5></div>'
    +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
    +'<div class="saved"><svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/></svg>'
    +'</div>'
    +'</div>'//heading
+'<div class="panel-body" style="padding:0px !important;">'
+'<div class="carousel-container" style = "/*border-top-left-radius: 20px;border-top-right-radius: 20px;*/overflow: hidden;background:transparent">'
+'<div  class="carousel slide" data-ride="carousel" id="'+carouselid+'">'
+'<ol class="carousel-indicators">'
+'<li data-target="#'+carouselid+'"  data-slide-to="0" class="active"></li>'// Indicators
+'<li data-target="#'+carouselid+'" data-slide-to="1"></li>'
+'<li data-target="#'+carouselid+'"  data-slide-to="2"></li>'
+'</ol>'
+'<div class="carousel-inner">'
+'<div class="item active">'///tomato.jpg
+'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" style ="display: block;max-width: 100%;height: 200px;width: 100%;border-top-left-radius:20px;border-top-right-radius:20px;  background-color: transparent; object-fit: cover;  ">'
+'</div>'
+'<div class="item">'
+'<img src="<c:url value="'+banner1+'" />" alt="Image" style ="display: block;max-width: 100%;height: 200px;width: 100%;border-top-left-radius:20px;border-top-right-radius:20px;">'
+'</div>'
+'<div class="item">'
+'<img src="<c:url value="'+banner2+'" />" alt="Image" style ="display: block;max-width: 100%;height: 200px;width: 100%;border-top-left-radius:20px;border-top-right-radius:20px;">'
+'</div>'
+'</div>'
+'<a class="left carousel-control" href="#'+carouselid+'" data-slide="prev">'// Left and right controls 
+'<span class="glyphicon glyphicon-chevron-left" style ="display:none;"></span>'
+'<span class="sr-only">Previous</span>'
+'</a>'
+'<a class="right carousel-control" href="#'+carouselid+'" data-slide="next">'
+'<span class="glyphicon glyphicon-chevron-right" style = "display:none;"></span>'
+'<span class="sr-only">Next</span>'
+'</a>'
+'</div>'
+'</div>'// carousel container 
+'<div class="text-container">'
+'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;">'+publisher_name+'</p>'
+'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+description+'</p>'
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
+'</div></div>';

//$(".otheradsbypubli").append(other_ad_card);
// Insert the new div in the same place as the old div
//  container.insertBefore(other_ad_card, null); // Insert it at the end of the flex container
//container.append(other_ad_card);
document.getElementById('nooffollow').innerText = nooffol;
	document.getElementById('noofcamp').innerText = noofcam;
	document.getElementById('publishername').innerText = publisherName;
//	   	document.getElementById('publishername').innerText = publisherName;
	document.getElementById('profilepic').src = profilepic;
	var buttonph = document.getElementById('campaignnumberphone');   buttonph.setAttribute("data-value", phno);
	var buttonw = document.getElementById('campaignnumberwhatsapp');buttonw.setAttribute("data-value", phno);
	
	
	
});//.each
	// console.log('other_ad_card: ' +other_ad_card );
	 container.innerHTML += other_ad_card;
	 //var div5 = document.querySelector(".adcard");
	 //div5.style.display='none'; 

	 var spotlightItem = document.querySelectorAll('.spotlightitem');
//	 var secondItem = spotlightItem[1];
console.log('created By : ' +createdby);
 var secondItem = document.getElementById(createdby);
 //console.log('secondItem : ' +secondItem);
	 secondItem.style.width= '73px';
	 secondItem.style.height='95px';
	 secondItem.style.background= 'linear-gradient(90deg, rgba(242, 124, 10, 0.1) 0%, rgba(242, 56, 44, 0.1) 100%)';
	 
	 
	}//else	
}
// to change folllow start here 
//document.getElementById("followspotlight").addEventListener("click", function() {
	function follow(){
/*  this.classList.toggle("active"); // Toggle the "active" class on the button
if (this.classList.contains("active")) //Change the button text 
{ 
	this.innerHTML = ' Following <i class="fa fa-check"></i>';
	} else { this.textContent = "Click me!"; }*/
	var button = document.getElementById("followspotlight");
//	console.log(button.value);
	 if (parseInt(button.value) === 0) {		
	  button.removeAttribute("class");// Remove any existing styles by clearing the class list	  
	  button.innerHTML = 'Following <i class="fa fa-check"></i>';// Change button text	
	  button.value = "1";	  
	  button.classList.add("newStyle");// Change button CSS class
	 }
	 else
		 {
		  button.value = "0";
		  button.removeAttribute("class");
		  button.innerHTML = 'Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i>';
		  button.classList.add("followspotlight");
		 }
}
//to change folllow end here

//serch in spotlight starts from here 1
 document.getElementById('spotlytsearch').addEventListener('input', function() {
     const query =$('#spotlytsearch').val(); //this.value;
  //   const swipeWrapper = document.getElementById('spotlightlist');
     swipeWrapper.style.transform='';
    // console.log('input : '+query);
     const resultsContainer = document.getElementById('spotlightlist');
	    resultsContainer.innerHTML = ""; // Clear previous results
     const filteredResults = filterArray(query);
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
		 $('.spotlightlist').append(spotlightt);
	}
 //}
 
 //end here 1
//search spotlight end here

// to load the ads on click of single spotlight start here
/*$('.spotlightitem').on('click', function() {
                alert('Div clicked using .on()!');
               var y =  $(this).attr('id') ;
                var x = $(this).val();
                var z = $(this).usrphno;
                //console.log('z : ' +z);
            });*/

var spotlightId;
          
function toaddevent(button){
	//$('.spotlightitem').on('click', function() {//for dynamic 
		//const flexItems = document.querySelectorAll('.spotlightitem'); 
	 //    console.log('You clicked ' );
		 //var y =  $(this).attr('id') ;
		 var y =  button.id ;
		 spotlightId =y;
	//	 console.log('spotlightId : ' +spotlightId);
		 var  k=0;
		 var container = document.querySelector('.ad-container'); 
		 var div4 = document.querySelector(".campaignnumbercontainer");
		 //div4.innerHTML='';
		 var div5 = document.querySelector(".adcard");
		 div5.innerHTML ="";
		 var other_ad_card = "";
		 
		 const removeactive = button.parentNode.querySelectorAll('.spotlightitem');// spotlight bckground
		 removeactive.forEach(btn => {		 
		 btn.style.background= 'none';});
		    
		 const selectedSpotlyt = document.getElementById(y);
		 selectedSpotlyt.style.width= '73px';
		 selectedSpotlyt.style.height='95px';
		 selectedSpotlyt.style.background= 'linear-gradient(90deg, rgba(242, 124, 10, 0.1) 0%, rgba(242, 56, 44, 0.1) 100%)';
		 /*selectedSpotlyt.style.borderRadius= '10px';*/

	     
	       const campaignbuttons = document.querySelectorAll('.campaignbtngrp button' );//for all campagin coomplted,all,active
	 campaignbuttons.forEach(btn => btn.classList.remove('actives'));
     const buttonactive = document.getElementById("active"); 
     buttonactive.classList.add('actives');          
     
		 $.ajax({
	         url: '${pageContext.request.contextPath}/spotlight', // Sample API endpoint
	         method: 'POST',
	         contentType: 'text/plain',
	         data: y,
	         success: function(data) {
	             // Clear previous data           // Iterate through the data and display it
	         	  $.each(data, function (i, myList) {
	       	     	  
	       	     	 var adsid = myList.id;
	       	     	 var phno = myList.phoneNumber;
	       	     	 var email= myList.emailAddress;
	       	     	 var publisher_name = myList.a.title;
	       	     	 var publisherName= myList.fullName;	       	     	
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
	       	    	var nooffol = myList.noOfFollow;
	       	    	var noofcam = myList.noOfCampaigns;
	       	   	    var profilepic= myList.profilePicturePath;var createdBy = myList.createdBy;
	       	    	if(myList.a.adType =='64887c11cce361dafc86c23b'){
	       	    	var baners =  myList.a.content.banners;	       	    		    	
	       	    	if(baners !=null )
	       	    		{
	       	    		 banner1 = baners[0];
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
	       	     	var carouselid= 'myCarouselspotlyt'+k;
	       	    	 //onclick=nextui(this);							     	 
	       	 	 
other_ad_card += '<div><div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
	       	 	+'<div class="panel-heading">'
	       	     +'<img src="<c:url value="'+companyLogoUrl+'" />" style="height:30px;width:30px;" alt="User profile" class="spotlightimg" />'
	       	     +'<div id="frame20"><h5 id="publishername" style ="font-family: Inter;font-style: normal;font-weight: 700;font-size: 12px;line-height: 15px;color: #000000;">'+companyName+' </h5></div>'
	       	     +'<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>'
	       	     +'<div class="saved"><svg width="15" height="18" viewBox="0 0 15 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1.875 14.9301V1.75H13.75V15.0134L8.29179 10.1298L7.60671 9.51679L6.93838 10.148L1.875 14.9301Z" stroke="black" stroke-width="2"/></svg>'
	       	     +'</div>'
	       	     +'</div>'//heading
	       	 +'<div class="panel-body" style="padding:0px !important;">'
	       	 +'<div class="carousel-container" style = "/*border-top-left-radius: 20px;border-top-right-radius: 20px;*/overflow: hidden;background:transparent">'
	       	 +'<div  class="carousel slide" data-ride="carousel" id="'+carouselid+'">'
	       	 +'<ol class="carousel-indicators">'
	       	 +'<li data-target="#'+carouselid+'"  data-slide-to="0" class="active"></li>'// Indicators
	       	 +'<li data-target="#'+carouselid+'" data-slide-to="1"></li>'
	       	 +'<li data-target="#'+carouselid+'"  data-slide-to="2"></li>'
	       	 +'</ol>'
	       	 +'<div class="carousel-inner">'
	       	 +'<div class="item active">'///tomato.jpg
	       	 +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" style ="display: block;max-width: 100%;height: 200px;width: 100%;border-top-left-radius:20px;border-top-right-radius:20px;  background-color: transparent; object-fit: cover;  ">'
	       	 +'</div>'
	       	 +'<div class="item">'
	       	 +'<img src="<c:url value="'+banner1+'" />" alt="Image" style ="display: block;max-width: 100%;height: 200px;width: 100%;border-top-left-radius:20px;border-top-right-radius:20px;">'
	       	 +'</div>'
	       	 +'<div class="item">'
	       	 +'<img src="<c:url value="'+banner2+'" />" alt="Image" style ="display: block;max-width: 100%;height: 200px;width: 100%;border-top-left-radius:20px;border-top-right-radius:20px;">'
	       	 +'</div>'
	       	 +'</div>'
	       	 +'<a class="left carousel-control" href="#'+carouselid+'" data-slide="prev">'// Left and right controls 
	       	 +'<span class="glyphicon glyphicon-chevron-left" style ="display:none;"></span>'
	       	 +'<span class="sr-only">Previous</span>'
	       	 +'</a>'
	       	 +'<a class="right carousel-control" href="#'+carouselid+'" data-slide="next">'
	       	 +'<span class="glyphicon glyphicon-chevron-right" style = "display:none;"></span>'
	       	 +'<span class="sr-only">Next</span>'
	       	 +'</a>'
	       	 +'</div>'
	       	 +'</div>'// carousel container 
	       	 +'<div class="text-container">'
	       	 +'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;">'+publisher_name+'</p>'
	       	 +'<p style ="font-family: Inter;font-style: normal;   font-weight: 400;font-size: 12px;line-height: 15px;color: #000000;">'+description+'</p>'
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
	       	 +'</div></div>';

	       	 //$(".otheradsbypubli").append(other_ad_card);
	       	 // Insert the new div in the same place as the old div
	       	 //  container.insertBefore(other_ad_card, null); // Insert it at the end of the flex container
	       	 //container.appendChild(other_ad_card);	       	 
	       	
	       
	     	document.getElementById('nooffollow').innerText = nooffol;
   	     	document.getElementById('noofcamp').innerText = noofcam;
   	     	document.getElementById('publishername').innerText = publisherName;
 //  	   	document.getElementById('publishername').innerText = publisherName;
   	     	document.getElementById('profilepic').src = profilepic      	     
	       	     
   	     	//for profile phone and whatsapp
   	     var buttonphone = document.getElementById('campaignnumberphone');   buttonphone.setAttribute("data-value", phno);
   		 var buttonwhatsapp = document.getElementById('campaignnumberwhatsapp');buttonwhatsapp.setAttribute("data-value", phno);
	       	        	  }); //.each
	       	        	 div5.innerHTML +=other_ad_card;
	         	
	    	     	
	       	     	
	       	  // Remove the 'active' class from all buttons
	            /*    const buttons = document.querySelectorAll('.btn');
	                buttons.forEach(btn => btn.classList.remove('active'));

	                // Add the 'active' class to the button with the given id
	                const activeButton = document.getElementById("profile");
	                activeButton.classList.add('active');
	                
	                var div3 = document.querySelector(".adcard");
	          	  div3.style.display='none'; 
	          	  var div2 = document.querySelector(".campaignnumbercontainer");
	          	  div2.style.display='block';*/
	          	  
	          	   var buttons = document.querySelector('.btn.active');
	          	   var activeButton = buttons.id;
	          	//   console.log('activeButton : ' +buttons.id);
	          	   if(activeButton=="profile")
	          		   {
	          		 var div3 = document.querySelector(".adcard");
		          	  div3.style.display='none'; 
		          	  var div2 = document.querySelector(".campaignnumbercontainer");
		          	  div2.style.display='block';
	          		   }
	          	   else if(activeButton=="posts"){
	          		 var div3 = document.querySelector(".adcard");
		          	  div3.style.display='block'; 
		          	  var div2 = document.querySelector(".campaignnumbercontainer");
		          	  div2.style.display='none';
	          	   }
	          	   
	         },
	         error: function(xhr, status, error) {
	        
	             console.error(error);
	         }
	     });//ajax
		// });

	}
		   
// to load the ads on click of single spotlight end here'
	 mob="";var telphno;
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

var phoneorwhatsapp=0;
function whatsapp(phno)
{
	//console.log('phno from whats app : ' +phno);
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
	telphno = phno;
    event.stopPropagation(); phoneorwhatsapp=1; 
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

/*function nextuifromspotlyt(adverid,createdBy)
{
	  var adid = adverid.id;
	  window.location.href = '${pageContext.request.contextPath}/adDetailSpotlight?param1=' + encodeURIComponent(adid) + '&param2=' + encodeURIComponent(createdBy);
}*/

//to show the ad in more detail start here
function nextui(element,createdBy)
{ 
			const adId = element.id; var k = 0;
			let divElementimagecontainer = document.getElementById('image-container'); // Clear all elements inside the div 
			divElementimagecontainer.innerHTML = '';		
			let divElementtextcontainer = document.getElementById('addetailModaltext-container'); // Clear all elements inside the div 
		
			document.getElementById('ptitle').innerHTML ='';
           document.getElementById('pdescription').innerHTML ='';
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
					               buttonElement2.setAttribute("data-value", response.onead.phoneNumber);
					               
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
					               p.textContent = response.onead.a.customTextSection[i].title; // Find the div element
					               let p2 = document.createElement("p"); // Set the text content of the p element
					               p2.textContent = response.onead.a.customTextSection[i].description; // Find the div element 
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
							     	 if(response.onead.a.adType=='64887c11cce361dafc86c23c'){
							     		// console.log('video link: ' +response.onead.a.content.videoLink);
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
							     	iframe.setAttribute('allowfullscreen', '');
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
							     if(response.onead.a.adType=='64887c11cce361dafc86c23b'){
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
				   		
					   		 }}
							    	 if(response.onead.a.adType=='64887c11cce361dafc86c23d'){
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
							    	  //  console.log('simple text ad : ' +response.onead.a.content.AdText);
							    		 var targetDiv = document.getElementById('image-container');
							    		 targetDiv.innerHTML +='<p>'+response.onead.a.content.adText+'</p>';
							    	 }
							     
					                },
					                error: function(xhr, status, error) {
					                   
					                }
					            });
							 
							 $('#addetailModal').modal('show');
							 	 }

//to show the ad in more detail end here
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

function phonefromcampaign()
{
	var div = document.getElementById("campaignnumberphone");
	var dataValue = div.getAttribute("data-value");//or var dataValue = div.dataset.value;	
	//console.log('in addetail button click : ' +dataValue);
	phoneorwhatsapp=1;
	phone(dataValue);
}
function whatsappfromcampaign()
{
	var div = document.getElementById("campaignnumberwhatsapp");
	var dataValue = div.getAttribute("data-value");//or var dataValue = div.dataset.value;	
	//console.log('in addetail button click : ' +dataValue);
	phoneorwhatsapp=2;
	whatsapp(dataValue);
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
							console.log('login click' +otp +' and ' +mobilenumber);
							 $.post("${pageContext.request.contextPath}/verifyOtp.htm", {		
									mobilenumber : mobilenumber,	
									otp:otp,
									
							}, function(data) {
							}).done(function(data) {
								
							if(data.status == "Success"){
								$('#footerprofilepic').attr("src", data.profileImagePath);
						//	console.log('data success or failure : '+data);
								$('#otpModal').modal('hide');
								if( phoneorwhatsapp=1)
									{
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
							console.log('span');
							$('#loginModal').modal('hide');
							}
						
						var cl = document.getElementById("otpModalClose");
						cl.onclick = function() { 	
							console.log('span');
						$('#otpModal').modal('hide');
							}


</script>
<jsp:include page="responsivefooter.jsp" /> 
</body>

</html>