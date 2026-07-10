<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
      <%@ taglib prefix="form"  uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Set a session variable (this is usually done before)
 String latitude= (String)   session.getAttribute("latitude");
String longitude =(String)session.getAttribute("longitude");

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
     overflow-x: hidden;
     max-width:100%;
}
body {
    min-height: 100%;
     background-color: white;
    margin: 0;        
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
justify-content: flex-start;gap:10px;overflow-x: hidden;
}

.map-container2
{
display:flex;
flex-direction:row;
justify-content: center;
align-items: center;
border-bottom: 1px solid #000;
}
.logo-image{width: 20%; /* Adjust the width as needed */ height: auto; /* Maintain aspect ratio */}

#usr{border: none;outline: none;box-shadow: none;}
</style>
</head>
<body>

<div class="responsiveheader-container">
<div class = "logo-container">
<!-- <img loading="lazy" src="/logo.png" class="logo-image" alt="Company Logo" /> -->
<svg width="30" height="30" viewBox="0 0 30 30" fill="none" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
<rect width="30" height="30" fill="url(#pattern0_392_439)"/>
<defs>
<pattern id="pattern0_392_439" patternContentUnits="objectBoundingBox" width="1" height="1">
<use xlink:href="#image0_392_439" transform="matrix(0.00522748 0 0 0.00533681 0.0436579 0.123533)"/>
</pattern>
<image id="image0_392_439" width="512" height="127" xlink:href="data:image/png;base64,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"/>
</defs>
</svg>

</div>
<div class="map-container" style ="flex:1;">
<div class="map-container2">
<input type="text" class="form-control" id="usr">
<button data-toggle="modal" data-target="#myModal" style ="border:none;outline:none;background:none;">
<svg width="9" height="9" viewBox="0 0 9 9" fill="none" xmlns="http://www.w3.org/2000/svg" id = "mapdrop">
<path d="M4.54635 5.75013L7.5645 2.73603C7.5938 2.70657 7.62871 2.6833 7.66717 2.66758C7.70563 2.65187 7.74685 2.64403 7.78839 2.64453C7.82993 2.64504 7.87095 2.65387 7.90902 2.67051C7.94708 2.68716 7.98142 2.71127 8.01 2.74143C8.06855 2.8031 8.10074 2.88518 8.09973 2.97022C8.09872 3.05526 8.0646 3.13655 8.0046 3.19683L4.76325 6.43368C4.73417 6.46296 4.69954 6.48615 4.66139 6.50189C4.62324 6.51763 4.58233 6.52561 4.54106 6.52536C4.49979 6.52511 4.45898 6.51663 4.42103 6.50043C4.38307 6.48422 4.34873 6.46061 4.32 6.43098L0.992251 3.02403C0.933356 2.96303 0.90044 2.88156 0.90044 2.79678C0.90044 2.71199 0.933356 2.63052 0.992251 2.56953C1.02119 2.53972 1.05582 2.51603 1.09408 2.49986C1.13234 2.48368 1.17346 2.47534 1.215 2.47534C1.25654 2.47534 1.29766 2.48368 1.33592 2.49986C1.37418 2.51603 1.40881 2.53972 1.43775 2.56953L4.54635 5.75013Z" fill="black"/>
</svg>
</button>
</div><!-- map-container2 -->
</div>
  



</div><!-- responsiveheader-container -->

<script type="text/javascript"></script>



</body>
</html>