<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<title>Insert title here</title>
<style>
html {
    height: 100%;
}
body {
    min-height: 100%;
    width:100%;
    margin: 0;        /* Remove default margin */
    padding: 0; 
}
* { 
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}
.header
{
display: flex;
width: 1367px;/* 1367px;*/
padding: 07px 54px;
flex-direction: column;
align-items: flex-start;
gap: 10px;
background: rgba(255, 255, 255, 0.80);
backdrop-filter: blur(5px);
}
.headercontent{
display: flex;
align-items: center;
gap: 100px;/*40px*/
align-self: stretch;

}
.logo-container,.logo-image
{
width: 147.059px;
height: 50px;
background:  #fff 5.617px 6.177px / 91% 67.778% no-repeat;
}
.search-container
{
display: flex;
justify-content: center;
align-items: center;
gap: 44px;/*75px not sure*/
align-self: stretch;
}
.search-input
{
display: flex;
width: 460px;
height: 50px;
padding: 10px 16px;
align-items: center;
gap: 10px;
border-radius: 10px;
border: 1px solid #D0D0D0;
background: #FFF;
}
/*.search-input{
display: flex;
align-items: center;
gap: 10px;
flex: 1 0 0;

}*/
#search-inputfield
{
flex: 1 0 0;
color: #000;
font-family: Inter;
font-size: 16px;
font-style: normal;
font-weight: 400;
line-height: normal;
opacity: 0.5;
border:none;
outline:none;
}
.voice-search{
display: flex;
padding: 8px 11px;
flex-direction: column;
align-items: center;
border-radius: 40px;
background: #F5F5F5;
border:none;
outline:none;
}
.search{
display: flex;
padding: 5px;
align-items: center;
gap: 10px;
border-radius: 30px;
background: var(--Brand-Primary, linear-gradient(90deg, #F27C0A 0%, #F2382C 100%));
border:none;
outline:none;
}
.locationcontainer
{
display: flex;
width: 290px;
padding: 0px 7px;/*20px*/
align-items: center;
gap: 10px;
align-self: stretch;
border-radius: 10px;
border: 1px solid #D0D0D0;
margin-top:5px;
margin-bottom:5px;
}
.location
{
display: flex;
align-items: center;
gap: 10px;
flex: 1 0 0;
}
.locationicon{
display: flex;
width: 24px;
height: 24px;
padding: 2.857px 5.143px 2.81px 5.143px;
justify-content: center;
align-items: center;}
.currentloc{
color: #000;
font-family: Inter;
font-size: 16px;
font-style: normal;
font-weight: 400;
line-height: normal;
}
.rightsection
{
display: flex;
justify-content: flex-end;
align-items: center;
gap: 10px;
}
.notificationicon
{
display: flex;
width: 40px;
height: 40px;
justify-content: center;
align-items: center;
align-content: center;
gap: 10px;
flex-wrap: wrap;
}
.profilecontainer
{
display: flex;
height: 50px;
padding: 20px 16px;
align-items: center;
gap: 10px;
border-radius: 50px;
}
.profilesection
{
display: flex;
height: 60px;
padding: 5px 0px;
justify-content: center;
align-items: center;
gap: 10px;
}
.profilecontent
{
display: flex;
align-items: center;
gap: 10px;
}

.modal-open .modal {
    overflow-x: hidden;
    overflow-y: hidden;
    background: none;
    margin-left:573px;
    margin-top: 50px;
}
.modal-open .modal {
    overflow-x: hidden;
    overflow-y: hidden;
}
.modal-content {
width:600px;
border-radius:20px;
}

    .modalbody1,.modalbody3
    {
    display: flex;
justify-content: center;
align-items: center;
gap: 0px;/*20px*/
align-self: stretch;
    }
     .component2
   {
   display: inline-flex;
padding: 20px;/*30px*/
flex-direction: column;
justify-content: center;
align-items: flex-start;
gap: 20px;
border-radius: 20px;
background: #FFF;   
   }
  /* 
   .dropdown {
  position: relative;
  display: inline-block;
}*/

#profiledrop {
 display:none;
  position: absolute; 
  box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
  /*z-index: -18;*/
  border-radius: 20px;
background: #FFF;
right:0;
top:50px;
/*padding:20px;*/
}

.frame45
{
display: flex;
flex-direction: column;
align-items: flex-start;
gap: 0px;/*16px;*/
align-self: stretch;
}
.log
{
display: flex;
flex-direction: row;
align-items: center;
gap: 250px;/*16px;*/
align-self: stretch;
color: #000;
font-family: Inter;
font-size: 25px;
font-style: normal;
font-weight: 700;
line-height: normal;
}

#closeButtonheader {
    float: right;
    font-size: 19px;
    font-weight: 700;
    line-height: 1;
    color: #0e0000;
    /* opacity: .2; */
}
.frame47
{
display: flex;
padding: 8px 0px;/*20px 10px;*/
align-items: center;
gap: 10px;
align-self: stretch;
border-bottom: 1px solid #B9B9B9;
}
.frame46
{
display: flex;
width: 350px;
flex-direction: column;
align-items: flex-start;
gap: 10px;
}

.sendotp
{
display: flex;
padding: 10px 16px;
justify-content: center;
align-items: center;
gap: 10px;
border-radius: 10px;
border: 1px solid #000;
/*display: -webkit-box;*/
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
background:none;
padding:10px;
}
.frame21
{
display: flex;
flex-direction:row;
}
#profiledroplogin
{
display:none;
  position: absolute; 
  box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
  /*z-index: -18;*/
  border-radius: 20px;
  background: #FFF;
right:0;
top:50px;
/*padding:20px;*/
}

#closeButtonlogin
{
float: right;
    font-size: 19px;
    font-weight: 700;
    line-height: 1;
    color: #0e0000;
    /* opacity: .2; */
}
.sendotp:hover
{

background: linear-gradient(90deg, #F27C0A 0%, #F2382C 100%), #FFF;


}
.loginotp:hover
{

background: linear-gradient(90deg, #F27C0A 0%, #F2382C 100%), #FFF;


}

#loginsuccess
{
display:none;
border-radius: 10px;
background: #FFF;
box-shadow: 0px 0px 3px 0px rgba(0, 0, 0, 0.25);
position: absolute;
    top: 40px;
    right: 0;
}
.component3
{
display: flex;
width: 319px;
padding: 20px 24px;
flex-direction: column;
justify-content: center;
align-items: flex-start;
gap: 20px;
border-radius: 10px;
background: #FFF;
box-shadow: 0px 0px 3px 0px rgba(0, 0, 0, 0.25);
}
.loginsuccesdrop{
display: flex;padding: 0px 0px;align-items: center;gap: 10px;align-self: stretch;border-radius: 10px;}
 </style>
</head>
<body>
<header class="header">
<div class="headercontent">
<div class="logo-container">
    <a href="<c:url value="/"/>"><img loading="lazy" src="https://cdn.builder.io/api/v1/image/assets/TEMP/acfad736ac540f97f330df2ba4ae4e5f094c47151e8edac849f38e67f3c1b2f7?apiKey=ee52b334663c4c438b8630c033e5c520&&apiKey=ee52b334663c4c438b8630c033e5c520" class="logo-image" alt="Company Logo" /></a>
        </div>
<div class="search-container">
<div class="search-input">
<!--  <label for="search-inputfield" class="visually-hidden">Search</label> -->
                  <input type="text" id="search-inputfield" class="search-text" placeholder="Search" />
<div class="voice-search">
<svg xmlns="http://www.w3.org/2000/svg" width="13" height="18" viewBox="0 0 13 18" fill="none">
  <path d="M9.04395 9.20712C9.04395 9.92121 8.7821 10.606 8.316 11.111C7.84991 11.6159 7.21775 11.8996 6.55859 11.8996C5.89944 11.8996 5.26728 11.6159 4.80118 11.111C4.33509 10.606 4.07324 9.92121 4.07324 9.20712V3.82219C4.07324 3.10811 4.33509 2.42327 4.80118 1.91833C5.26728 1.4134 5.89944 1.12973 6.55859 1.12973C7.21775 1.12973 7.84991 1.4134 8.316 1.91833C8.7821 2.42327 9.04395 3.10811 9.04395 3.82219V9.20712Z" stroke="black" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M11.5293 9.41466C11.5293 12.1546 9.30397 14.3763 6.55859 14.3763M6.55859 14.3763C3.81322 14.3763 1.58789 12.1546 1.58789 9.41425M6.55859 14.3763V16.8703" stroke="black" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
</div>
<div class="search" role = "button">

<svg xmlns="http://www.w3.org/2000/svg" width="21" height="20" viewBox="0 0 21 20" fill="none">
  <path d="M18.0292 17.5L14.4101 13.8808M14.4101 13.8808C15.0291 13.2617 15.5202 12.5268 15.8552 11.7179C16.1903 10.9091 16.3627 10.0422 16.3627 9.16666C16.3627 8.29115 16.1903 7.42422 15.8552 6.61537C15.5202 5.80651 15.0291 5.07156 14.4101 4.45249C13.791 3.83342 13.056 3.34234 12.2472 3.0073C11.4383 2.67226 10.5714 2.49982 9.69589 2.49982C8.82039 2.49982 7.95346 2.67226 7.1446 3.0073C6.33574 3.34234 5.6008 3.83342 4.98172 4.45249C3.73145 5.70276 3.02905 7.3985 3.02905 9.16666C3.02905 10.9348 3.73145 12.6305 4.98172 13.8808C6.232 15.1311 7.92774 15.8335 9.69589 15.8335C11.464 15.8335 13.1598 15.1311 14.4101 13.8808Z" stroke="white" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>


</div>

</div>

<div class="locationcontainer">
<div class ="location">
<div class="locationicon">
<svg xmlns="http://www.w3.org/2000/svg" width="15" height="20" viewBox="0 0 15 20" fill="none">
  <path fill-rule="evenodd" clip-rule="evenodd" d="M7.52926 19.1886L8.25041 18.376C9.06869 17.4389 9.80469 16.5497 10.4595 15.704L11.0001 14.9909C13.2573 11.9497 14.3864 9.536 14.3864 7.752C14.3864 3.944 11.3167 0.857147 7.52926 0.857147C3.74183 0.857147 0.672119 3.944 0.672119 7.752C0.672119 9.536 1.80126 11.9497 4.05841 14.9909L4.59898 15.704C5.53319 16.901 6.5106 18.0626 7.52926 19.1886Z" stroke="black" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M7.52926 10.5714C9.10722 10.5714 10.3864 9.29225 10.3864 7.71429C10.3864 6.13633 9.10722 4.85715 7.52926 4.85715C5.95131 4.85715 4.67212 6.13633 4.67212 7.71429C4.67212 9.29225 5.95131 10.5714 7.52926 10.5714Z" stroke="black" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
</div>
<div class ="currentloc">
<input type ="text" style="border:none;outline:none;background: none;" id = "address">

</div>

</div>
<div class="dropdown" role="button"   data-toggle="modal" data-target="#myModal" >
<svg xmlns="http://www.w3.org/2000/svg" width="13" height="12" viewBox="0 0 13 12" fill="none">
  <path d="M6.59119 7.66679L10.6154 3.64799C10.6545 3.60872 10.701 3.57769 10.7523 3.55674C10.8036 3.53578 10.8585 3.52533 10.9139 3.526C10.9693 3.52667 11.024 3.53845 11.0748 3.56064C11.1255 3.58284 11.1713 3.61499 11.2094 3.65519C11.2875 3.73743 11.3304 3.84687 11.329 3.96026C11.3277 4.07364 11.2822 4.18203 11.2022 4.26239L6.88039 8.57819C6.84162 8.61724 6.79544 8.64816 6.74458 8.66915C6.69371 8.69014 6.63917 8.70077 6.58414 8.70044C6.52911 8.7001 6.4747 8.6888 6.4241 8.66719C6.37349 8.64559 6.32769 8.61411 6.28939 8.57459L1.85239 4.03199C1.77387 3.95067 1.72998 3.84204 1.72998 3.72899C1.72998 3.61595 1.77387 3.50732 1.85239 3.42599C1.89098 3.38626 1.93715 3.35467 1.98817 3.3331C2.03918 3.31153 2.09401 3.30042 2.14939 3.30042C2.20478 3.30042 2.25961 3.31153 2.31062 3.3331C2.36164 3.35467 2.40781 3.38626 2.44639 3.42599L6.59119 7.66679Z" fill="black"/>
</svg>


</div>


</div><!-- Location container -->
<div class= "rightsection">
<div class="notificationicon">
<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
  <path d="M9.00001 21C9.79601 21.622 10.848 22 12 22C13.152 22 14.204 21.622 15 21M2.53001 14.394C2.31701 15.747 3.26801 16.686 4.43201 17.154C8.89501 18.949 15.105 18.949 19.568 17.154C20.732 16.686 21.683 15.747 21.47 14.394C21.34 13.562 20.693 12.87 20.214 12.194C19.587 11.297 19.525 10.32 19.524 9.279C19.525 5.26 16.157 2 12 2C7.843 2 4.47501 5.26 4.47501 9.28C4.47501 10.32 4.41301 11.298 3.78501 12.194C3.30701 12.87 2.66101 13.562 2.53001 14.394Z" stroke="black" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
</div>
<div class="profilesection">
<div class="profilecontainer">
<div class="profilecontent">
 <img  src="<c:url value='/Default_pfp.jpg' />"  alt="User profile" style="width: 37px;height: 39px;" />
<div class="dropdown">
<button data-toggle="dropdown" id = "profiledr" style ="background:none;outline:none;border:none;">
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="8" viewBox="0 0 16 8" fill="none">
  <g clip-path="url(#clip0_2183_2296)">
    <path d="M8 6.99999C7.93442 7.00079 7.86941 6.98786 7.80913 6.96202C7.74885 6.93619 7.69465 6.89803 7.65 6.84999L3.15 2.34999C2.95 2.14999 2.95 1.83999 3.15 1.63999C3.35 1.43999 3.66 1.43999 3.86 1.63999L8.01 5.78999L12.15 1.64999C12.35 1.44999 12.66 1.44999 12.86 1.64999C13.06 1.84999 13.06 2.15999 12.86 2.35999L8.36 6.85999C8.26 6.95999 8.13 7.00999 8.01 7.00999L8 6.99999Z" fill="black"/>
  </g>
  <defs>
    <clipPath id="clip0_2183_2296">
      <rect width="16" height="7" fill="white" transform="translate(0 0.5)"/>
    </clipPath>
  </defs>
</svg>
</button>
<!-- dropndown start here -->
 <div class="dropdown-men" id ="profiledrop">
<div class = "component2" id="component2">
<div class = "frame45">
<div class ="log">
<h5 style ="align-self: stretch;color: #000;font-family: Inter;font-size: 25px;font-style: normal;font-weight: 700;line-height: normal;">
 Login</h5>
 
  <span id="closeButtonheader" class="close">&times;</span>
</div>
<div>
<p  style = "align-self: stretch;color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;opacity: 0.5;">Enter your mobile no
</div>


</div>
<div class="frame46">
<div class= "frame47">
<input type = "text" style ="border:none;outline:none;color: #000;
font-family: Inter;font-size: 14px;font-style: normal;font-weight: 400;line-height: normal;opacity: 0.5;" placeholder="Enter your mobile no." id = "mobilenumber" autocomplete="off">

</div>
</div>
<div class="frame21" >
<button class= "sendotp" id = "sendotp">
Send OTP
<svg xmlns="http://www.w3.org/2000/svg" width="25" height="24" viewBox="0 0 25 24" fill="none">
  <path d="M18.4959 5.90946C18.4459 5.35945 17.9595 4.95411 17.4095 5.00411L8.44643 5.81893C7.89641 5.86893 7.49107 6.35534 7.54107 6.90536C7.59107 7.45537 8.07748 7.86072 8.6275 7.81071L16.5946 7.08643L17.3189 15.0536C17.3689 15.6036 17.8553 16.0089 18.4054 15.9589C18.9554 15.9089 19.3607 15.4225 19.3107 14.8725L18.4959 5.90946ZM8.26822 18.6402L18.2682 6.64018L16.7318 5.35982L6.73178 17.3598L8.26822 18.6402Z" fill="black"/>
</svg>
</button>

</div>
</div><!-- component2 -->
 
</div>
<!-- to enter OTP start here -->
<div class="dropdown-men" id ="profiledroplogin">
<div class = "component2" id="component2">
<div class = "frame45">
<div class ="log">
<h5 style ="align-self: stretch;color: #000;font-family: Inter;font-size: 25px;font-style: normal;font-weight: 700;line-height: normal;">
 OTP</h5>
 
  <span id="closeButtonlogin" class="close">&times;</span>
</div>
<div style ="display:flex;flex-direction:row;">
<p  style = "align-self: stretch;color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;opacity: 0.5;" id="p">Enter the OTP &nbsp;</p>
<div id="otpno" style ="color:#d94228;font-size:16px;" autocomplete="off"></div><p style = "align-self: stretch;color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;opacity: 0.5;">&nbsp; below:</p>
</div>
</div>
<div class="frame46">
<div class= "frame47">
<input type = "text" style ="border:none;outline:none;color: #000;
font-family: Inter;font-size: 14px;font-style: normal;font-weight: 400;line-height: normal;opacity: 0.5;" placeholder="Enter OTP" id = "otpnumber" autocomplete="off">

</div>
<div style ="display: flex;flex-direction: row;"><a style = "color: #010a12; text-decoration: none;margin-left:180px" id = "resend"> Resend OTP in &nbsp;</a> 
   <div id="countdown" class="timer"></div>

</div>
</div>
<div class="frame21" >
<button class= "sendotp" id = "loginotp">
LOGIN
<svg xmlns="http://www.w3.org/2000/svg" width="25" height="24" viewBox="0 0 25 24" fill="none">
  <path d="M18.4959 5.90946C18.4459 5.35945 17.9595 4.95411 17.4095 5.00411L8.44643 5.81893C7.89641 5.86893 7.49107 6.35534 7.54107 6.90536C7.59107 7.45537 8.07748 7.86072 8.6275 7.81071L16.5946 7.08643L17.3189 15.0536C17.3689 15.6036 17.8553 16.0089 18.4054 15.9589C18.9554 15.9089 19.3607 15.4225 19.3107 14.8725L18.4959 5.90946ZM8.26822 18.6402L18.2682 6.64018L16.7318 5.35982L6.73178 17.3598L8.26822 18.6402Z" fill="black"/>
</svg>
</button>

</div>
</div><!-- component2 -->
 
</div>

<!-- to enter OTP end here -->
<!-- logged in start here -->
<div class="dropdown-men" id ="loginsuccess">
<div class = "component3" id="component3">
<div style ="display: flex;align-items: center;gap: 10px;align-self: stretch;">
 <img  src="<c:url value='/Default_pfp.jpg' />"  alt="User profile" style="width: 37px;height: 39px;" />
<div><h5 style="color: #000;font-family: Inter;font-size: 18px;font-style: normal;font-weight: 700;line-height: normal;">Your Profile</h5></div>
</div>
<div style = "display:flex;flex-direction: column;">
<div class = "loginsuccesdrop">
<div>
<svg xmlns="http://www.w3.org/2000/svg" width="31" height="30" viewBox="0 0 31 30" fill="none">
  <rect x="0.5" width="30" height="30" rx="15" fill="#FFE7CC"/>
  <path d="M20.3281 20.9211H20.7149C21.6228 20.9211 22.3452 20.5074 22.9934 19.9295C24.6402 18.4603 20.7686 16.9737 19.447 16.9737M17.8681 9.13346C18.0476 9.09714 18.2331 9.07899 18.4247 9.07899C19.8615 9.07899 21.026 10.1392 21.026 11.4474C21.026 12.7556 19.8615 13.8158 18.4247 13.8158C18.2331 13.8158 18.0476 13.7977 17.8681 13.7614M9.16889 17.8508C8.2381 18.3498 5.79783 19.3682 7.28441 20.6424C8.01073 21.2653 8.81915 21.7106 9.83599 21.7106H15.637C16.6539 21.7106 17.4623 21.2653 18.1886 20.6424C19.6752 19.3682 17.2349 18.3498 16.3041 17.8508C14.1213 16.6816 11.3518 16.6816 9.16889 17.8508ZM15.8944 11.0527C15.8944 11.8902 15.5617 12.6934 14.9695 13.2856C14.3773 13.8779 13.574 14.2106 12.7365 14.2106C11.899 14.2106 11.0958 13.8779 10.5035 13.2856C9.91133 12.6934 9.57862 11.8902 9.57862 11.0527C9.57862 10.2151 9.91133 9.41192 10.5035 8.8197C11.0958 8.22748 11.899 7.89478 12.7365 7.89478C13.574 7.89478 14.3773 8.22748 14.9695 8.8197C15.5617 9.41192 15.8944 10.2151 15.8944 11.0527Z" stroke="black" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
</div>
<div style="flex: 1 0 0;"><h5 style = "color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">Following</h5></div>

</div>
<div class = "loginsuccesdrop">
<div style ="background: #FFE7CC;border-radius:12px;">
<svg xmlns="http://www.w3.org/2000/svg" width="25" height="24" viewBox="0 0 25 24" fill="none">
  <path d="M7.47168 17.0951V6.08008H17.2292V17.1472L12.6184 13.0218L12.1902 12.6387L11.7725 13.0332L7.47168 17.0951Z" stroke="black" stroke-width="1.25"/>
</svg>
</div>
<div style="flex: 1 0 0;"><h5 style = "color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">Saved</h5></div>

</div>
<div class = "loginsuccesdrop">
<div>
<svg xmlns="http://www.w3.org/2000/svg" width="29" height="30" viewBox="0 0 29 30" fill="none">
  <rect x="0.5" width="28" height="30" rx="14" fill="#FFE7CC"/>
  <path d="M17.8495 9.47363C16.4428 9.47363 15.2036 10.2565 14.5003 11.4868C13.7969 10.2565 12.5577 9.47363 11.151 9.47363C8.94045 9.47363 7.13184 11.4868 7.13184 13.9473C7.13184 18.3837 14.5003 22.8947 14.5003 22.8947C14.5003 22.8947 21.8687 18.421 21.8687 13.9473C21.8687 11.4868 20.0601 9.47363 17.8495 9.47363Z" fill="#F44336"/>
</svg>
</div>
<div style="flex: 1 0 0;"><h5 style = "color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">My Preferences</h5></div>

</div>
<div class = "loginsuccesdrop">
<div>
<svg xmlns="http://www.w3.org/2000/svg" width="29" height="30" viewBox="0 0 29 30" fill="none">
  <rect x="0.5" width="28" height="30" rx="14" fill="#FFE7CC"/>
  <path d="M7.31543 9.67109H17.2628M12.2891 7.89478V9.67109M15.0523 22.1053L18.3681 13.8158L21.6838 22.1053M16.0712 19.7369H20.6649M15.3735 9.67109C15.3735 9.67109 14.5342 13.1497 12.5309 15.7772C10.5276 18.4046 8.42069 19.7369 8.42069 19.7369" stroke="black" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M14.5002 17.9606C14.5002 17.9606 13.2913 16.9614 12.0133 15.1851C10.7354 13.4088 10.0791 12.0396 10.0791 12.0396" stroke="black" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
</div>
<div style="flex: 1 0 0;"><h5 style = "color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">Change Language</h5></div>

</div>
<div class = "loginsuccesdrop">
<div>
<svg xmlns="http://www.w3.org/2000/svg" width="29" height="30" viewBox="0 0 29 30" fill="none">
  <rect x="0.5" width="28" height="30" rx="14" fill="#FFE7CC"/>
  <path d="M11.0425 18.401L7.86816 15.015L11.0285 11.6297L11.5494 12.1729L9.28364 14.6052H19.7166L17.4508 12.1736L17.9717 11.6289L21.1313 15.0157L17.9717 18.401L17.4361 17.8571L19.7158 15.4097H9.26964L11.5494 17.8571L11.0425 18.401Z" fill="black"/>
</svg>
</div>
<div style="flex: 1 0 0;"><h5 style = "color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">Set Range</h5></div>

</div>
<div class = "loginsuccesdrop">
<div>
<svg xmlns="http://www.w3.org/2000/svg" width="29" height="30" viewBox="0 0 29 30" fill="none">
  <rect x="0.5" width="28" height="30" rx="14" fill="#FFE7CC"/>
  <path d="M8.60547 21.3159V8.68433H14.5149V9.4738H9.34231V20.5264H14.5149V21.3159H8.60547ZM17.788 17.7941L17.2707 17.2256L18.9795 15.3949H12.4312V14.6054H18.9795L17.27 12.7738L17.7873 12.207L20.3949 15.0001L17.788 17.7941Z" fill="black"/>
</svg>
</div>
<div style="flex: 1 0 0;"><h5 style = "color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">Logout</h5></div>

</div>
</div>
<!-- logged in start here -->
</div>
</div>


</div>
</div>
</div><!-- rightse -->


</div>



</div><!-- hearercontent -->
   

</header>

 <div id="myModal" class="modal fade" role="dialog" style="overflow:hidden;border-radius:20px;">
  <div class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content" style="padding:10px 20px;border-radius:20px;">
      <div class="modal-header" style="padding:15px;">
      <input type ="text" style ="border:none;outline:none;background:#FFF;width:490px;" id="locationintext">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
       
      </div>
      <div class="modal-body" style="display:flex;flex-direction:column;gap:0px;">
      <div class="modalbody1" role="button">
       <svg xmlns="http://www.w3.org/2000/svg" width="40" height="41" viewBox="0 0 40 41" fill="none">
  <path d="M8.75325 17.125L28.1866 7.87169C31.0199 6.52169 33.9766 9.48002 32.6282 12.315L23.3749 31.7467C22.1099 34.4017 18.2766 34.2384 17.2432 31.4834L15.5332 26.9184C15.3662 26.473 15.1057 26.0686 14.7694 25.7322C14.433 25.3959 14.0286 25.1354 13.5832 24.9684L9.01658 23.2567C6.26325 22.2234 6.09825 18.39 8.75325 17.125Z" stroke="black" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
<div class="modalbody11" style="display:flex;flex-direction:column;align-items: flex-start;gap: 10px;flex: 1 0 0;">
   <button  class="btn btn-default" style ="border:none;outline:none;background-color: white;width:83%;text-align:start;color: #000;
   font-family: Inter;font-size: 18px;font-style: normal;font-weight: 700;line-height: normal; box-shadow: none; " onclick="getCurrentLocations()" data-dismiss="modal">
   Detect Current Location<p style="color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">	Using GPS</p></button>
 <!--  <a href= "">Detect Current Location<p style="font-size: 10px;">&nbsp;Using GPS</p></a>-->
 </div>
 </div>
 <div> <p style ="color: #000;font-family: Inter;font-size: 18px;font-style: normal;font-weight: 400;line-height: normal;">OR </p> </div>    
 <div class="modalbody3" role="button">
 <svg xmlns="http://www.w3.org/2000/svg" width="32" height="33" viewBox="0 0 32 33" fill="none">
  <path d="M16 18.5C15.0111 18.5 14.0444 18.2068 13.2222 17.6574C12.3999 17.1079 11.759 16.3271 11.3806 15.4134C11.0022 14.4998 10.9031 13.4945 11.0961 12.5246C11.289 11.5546 11.7652 10.6637 12.4645 9.96447C13.1637 9.26521 14.0546 8.789 15.0246 8.59608C15.9945 8.40315 16.9998 8.50217 17.9134 8.8806C18.8271 9.25904 19.6079 9.89991 20.1574 10.7222C20.7068 11.5444 21 12.5111 21 13.5C20.9984 14.8256 20.4711 16.0964 19.5338 17.0338C18.5964 17.9711 17.3256 18.4984 16 18.5ZM16 10.5C15.4067 10.5 14.8266 10.6759 14.3333 11.0056C13.8399 11.3352 13.4554 11.8038 13.2284 12.352C13.0013 12.9001 12.9419 13.5033 13.0576 14.0853C13.1734 14.6672 13.4591 15.2018 13.8787 15.6213C14.2982 16.0409 14.8328 16.3266 15.4147 16.4424C15.9967 16.5581 16.5999 16.4987 17.1481 16.2716C17.6962 16.0446 18.1648 15.6601 18.4944 15.1667C18.8241 14.6734 19 14.0933 19 13.5C18.9992 12.7046 18.6829 11.942 18.1204 11.3796C17.558 10.8171 16.7954 10.5008 16 10.5Z" fill="#FF3636"/>
  <path d="M16 30.5L7.56401 20.551C7.44679 20.4016 7.33078 20.2513 7.21601 20.1C5.77571 18.2014 4.99733 15.8831 5.00001 13.5C5.00001 10.5826 6.15893 7.78473 8.22183 5.72183C10.2847 3.65893 13.0826 2.5 16 2.5C18.9174 2.5 21.7153 3.65893 23.7782 5.72183C25.8411 7.78473 27 10.5826 27 13.5C27.0023 15.882 26.2243 18.1991 24.785 20.097L24.784 20.1C24.784 20.1 24.484 20.494 24.439 20.547L16 30.5ZM8.81301 18.895C8.81301 18.895 9.04601 19.203 9.09901 19.269L16 27.408L22.91 19.258C22.954 19.203 23.188 18.893 23.189 18.892C24.3662 17.3411 25.0024 15.447 25 13.5C25 11.1131 24.0518 8.82387 22.364 7.13604C20.6761 5.44821 18.387 4.5 16 4.5C13.6131 4.5 11.3239 5.44821 9.63605 7.13604C7.94822 8.82387 7.00001 11.1131 7.00001 13.5C6.99754 15.4483 7.63445 17.3436 8.81301 18.895Z" fill="#FF3636"/>
</svg>
<div class="modalbody33" style ="display: flex;flex-direction: column;align-items: flex-start;gap: 10px;flex: 1 0 0;">
 <button  class="btn btn-default" style ="border:none;outline:none;background-color: white;width:83%;text-align:start;color: #000;
font-family: Inter;font-size: 18px;font-style: normal;font-weight: 700;line-height: normal; box-shadow: none; ">Set Location Manually
<p style="color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">Move to Your location</p></button>
</div>
  </div>  
  <div id="maploc" style="width:100%;height:180px;">    </div>
      </div>
      <div class="modal-footer" style ="display:flex;justify-content: center;align-items: center;border-top:none;">
      <button type="button" class="btn " data-dismiss="modal" style="display: flex;padding: 10px 16px;justify-content: center;
align-items: center;gap: 10px;border-radius: 10px;border: 1px solid #000;background:none;outline:none;" id = "setlocation">Set Location
<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
  <path d="M17.9959 5.90946C17.9459 5.35945 17.4595 4.95411 16.9095 5.00411L7.94643 5.81893C7.39641 5.86893 6.99107 6.35534 7.04107 6.90536C7.09107 7.45537 7.57748 7.86072 8.1275 7.81071L16.0946 7.08643L16.8189 15.0536C16.8689 15.6036 17.3553 16.0089 17.9054 15.9589C18.4554 15.9089 18.8607 15.4225 18.8107 14.8725L17.9959 5.90946ZM7.76822 18.6402L17.7682 6.64018L16.2318 5.35982L6.23178 17.3598L7.76822 18.6402Z" fill="black"/>
</svg></button>
      </div>
    </div>
 
  </div>
 </div> 

<script type="text/javascript">
$(document).ready(function() {
	$('#profiledroplogin').hide();
	});
	
window.onclick = function(event) {
	/* document.getElementById('loginsuccess').style.display = 'none';
	 document.getElementById('loginsuccess').style.zIndex = -18;
	 document.getElementById('col-md-4').style.zIndex=18;*/
	 
/*	 document.getElementById('profiledrop').style.display = 'none';
	 document.getElementById('profiledrop').style.zIndex = -18;
	 document.getElementById('col-md-4').style.zIndex=18;*/
	 
	 
	/* document.getElementById('profiledroplogin').style.display = 'none';
	 document.getElementById('profiledroplogin').style.zIndex = -18;
	 document.getElementById('col-md-4').style.zIndex=18;*/
	 
	/* if (!$(event.target).closest('#loginsuccess .component3').length) {
	        // If the click was outside the dropdown
	        $(".component3").removeClass("block");
	        //$("#loginsuccess .component3").style.display="none";
	      //   document.getElementById('loginsuccess').style.display = 'none';
	     //    document.getElementById('loginsuccess').style.zIndex = -18;
	    //	 document.getElementById('col-md-4').style.zIndex=18;
	        console.log("Dropdown is closed");
	    }*/
}

$('#mobilenumber').click(function(event){
	event.stopPropagation();
})
/*$(document).click(function(event) {
    if (!$(event.target).closest('#loginsuccess .component3').length) {
        // If the click was outside the dropdown
        $("#loginsuccess .component3").removeClass("show");
        //$("#loginsuccess .component3").style.display="none";
      //   document.getElementById('loginsuccess').style.display = 'none';
        console.log("Dropdown is closed");
    }
});

// Prevent dropdown from closing if clicked inside the dropdown
$("#loginsuccess .component3").click(function(event) {
    event.stopPropagation(); // Prevent click inside the dropdown from closing it
});*/

/*window.onclick = function(event) {
	document.getElementById('loginsuccess').style.display = 'none';
	 document.getElementById('loginsuccess').style.zIndex = -18;
	 document.getElementById('col-md-4').style.zIndex=18;
	 
	/* document.getElementById('profiledrop').style.display = 'none';
	 document.getElementById('profiledrop').style.zIndex = -18;
	 document.getElementById('col-md-4').style.zIndex=18;
	 
	 document.getElementById('profiledroplogin').style.display = 'none';
	 document.getElementById('profiledroplogin').style.zIndex = -18;
	 document.getElementById('col-md-4').style.zIndex=18;
	 */
//}
/*window.addEventListener("click", function(event) {
	 var dropdown = document.getElementById("profiledrop");
	 console.log('window');
	/* document.getElementById('loginsuccess').style.display = 'none';
	 document.getElementById('loginsuccess').style.zIndex = -18;
	 document.getElementById('col-md-4').style.zIndex=18;*/
	 
	//  if (!dropdown.contains(event.target)) {
   //       dropdown.classList.remove("show");
    //  }
	 
	/* window.onclick = function(event) { 
		 if (!event.target.matches('.dropdown button')) 
		 { var dropdowns = document.getElementsByClassName("dropdown-content"); 
		 for (var i = 0; i < dropdowns.length; i++) 
		 { 
			 var openDropdown = dropdowns[i];
			 if (openDropdown.classList.contains('show'))
			 { openDropdown.classList.remove('show'); } } } }
});
*/

/*$(document).click(function(event) {
	document.getElementById('profiledrop').style.display = 'none';
	 document.getElementById('profiledrop').style.zIndex = -18;
	 document.getElementById('col-md-4').style.zIndex=18;
	 
});

/*
let countdown;
const timerDisplay = document.getElementById('countdown');
const resendBtn = document.getElementById('resend');

function startCountdown(duration) {
    let timeRemaining = duration;

    countdown = setInterval(() => {
        const minutes = Math.floor(timeRemaining / 60);
        const seconds = timeRemaining % 60;
console.log('in timer : ' +seconds);
        timerDisplay.textContent =seconds;

        if (timeRemaining <= 0) {
            clearInterval(countdown);
            timerDisplay.textContent = "OTP expired!";
            //resendBtn.style.display = 'block'; // Show the resend button
        }

        timeRemaining--;
    }, 1000);
}*/

/*document.getElementById('sendotp').addEventListener('click', () => {
    // Simulate sending OTP
    //alert("OTP sent!");

    // Reset and start countdown
    clearInterval(countdown); // Clear any existing countdown
    timerDisplay.textContent = ""; // Clear previous timer display
  //  resendBtn.style.display = 'none'; // Hide the resend button
    startCountdown(60); // Start a 60-second countdown
});*/

/*resendBtn.addEventListener('click', () => {
    // Simulate resending OTP
  //  alert("OTP resent!");

    // Reset and start countdown
    clearInterval(countdown);
    timerDisplay.textContent = ""; // Clear previous timer display
    resendBtn.style.display = 'none'; // Hide the resend button
    startCountdown(20); // Start a new 60-second countdown
});*/


/*function initMap() {
    // Initialize the map and set default properties
     map = new google.maps.Map(document.getElementById('map'), {
        center: { lat: 13.529271965260616, lng: 75.36285138756304 },
        zoom:12
    }); 
}*/
function kelirihome()
{
	
	
	
	
	
}
</script>
</body>
</html>