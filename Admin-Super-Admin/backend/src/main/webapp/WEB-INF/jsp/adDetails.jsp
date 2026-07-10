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
.frame64
{
display: flex;
width: 1300px;
padding: 20px 0px;
align-items: flex-start;
gap: 20px;
}
.frame95
{
display: flex;
width:474px;/* 474px;*/
flex-direction: column;
align-items: flex-start;
gap: 10px;
flex-shrink: 0;
align-self: stretch;
}

.frame94
{
/*display: flex;
width: 474px;
height: 100px;
align-items: flex-start;
gap: 10px;
/*position: absolute;*/
/*bottom: 100px;/*-230px*/
display: flex;
width: 474px;
align-items: flex-start;
gap: 10px;
flex-shrink: 0;
align-self: stretch;
}
.frame96
{
display: flex;
width: 474px;
/*padding-bottom: 145px;*/
flex-direction: column;
align-items: center;gap:17px;
}
.frame101
{
display: flex;
padding: 0px 0px;/*2px*/
flex-direction: column;
align-items: flex-start;
gap: 10px;
align-self: stretch;
}
.frame83
{
display: flex;
align-items: flex-start;
gap: 20px;
align-self: stretch;
}
.frame79
{
display: flex;
padding: 20px;
flex-direction: column;
justify-content: center;
align-items: flex-start;
gap: 20px;
flex: 1 0 0;
align-self: stretch;
background: #FFF;
}
.frame78
{
display: flex;
padding: 20px;
flex-direction: column;
justify-content: center;
align-items: flex-start;
gap: 20px;
align-self: stretch;
background: #FFF;
}
.frame81
{
display: flex;
flex-direction: column;
align-items: flex-start;
flex: 1 0 0;
border-radius: 20px;
}
#panelhead
{
display: flex;
padding:20px;/* 30px;*/
align-items: center;
gap: 20px;
align-self: stretch;
background: #FFF;
box-shadow: 0px 4px 4px 0px rgba(0, 0, 0, 0.05), 0px 4px 4px 0px rgba(0, 0, 0, 0.05);
border-top-left-radius: 20px;
    border-top-right-radius: 20px;
    height:86px;
}
.button-group
{
display: flex;
align-items: center;
gap: 24px;
flex: 1 0 0;
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
.video
{
display: flex;
padding: 20px;
flex-direction: column;
justify-content: center;
align-items: flex-start;
gap: 20px;
flex: 1 0 0;
align-self: stretch;
background: #FFF;
box-shadow: 0px 0px 4px 0px rgba(0, 0, 0, 0.25);
margin-top:20px;
position:relative;
}
.carousel {
    position: relative;
    width: 300px;/*474px;*/
    height: 250px;
  
    overflow: hidden;
}
.frame70
{
display: flex;
    flex-direction: column;
    gap: 10px;
}

.carousel-control.left,
.carousel-control.right {
  background: transparent;
}

.roundedborder
{
border-radius:50%;
}
video {
            width: 100% ;/* Set video to full width of the container */
            height: 200px; /* Maintain aspect ratio */
            
          /*  position: absolute;*/
    min-width: 100%;
    min-height: 100%;
    right: 0;
    bottom: 0;
        }
    iframe
    {
    border: none;
    /* background-color: #ffffff; */
    width: 100%;
    height: 100%;
}
    }  
</style>
</head>
<body>
<div class = "container">
<div class="frame64">
<div class = "frame95">
<div class="frame96">
<div class = "carousel-container">

<div id="myMainCarousel" class="carousel slide" data-ride="carousel">
  <!-- Indicators -->
  <ol class="carousel-indicators">
    <li data-target="#myMainCarousel" data-slide-to="0" class="active"></li>
    <li data-target="#myMainCarousel" data-slide-to="1"></li>
    <li data-target="#myMainCarousel" data-slide-to="2"></li>
  </ol>

  <!-- Wrapper for slides -->
  <div class="carousel-inner">
    <div class="item active">
     <img src="<c:url value='${addetails.a.thumbnail}' />" alt="New York">
    </div>

    <div class="item">
     <img src="<c:url value='${addetails.a.thumbnail}' />" alt="New York">
    </div>

    <div class="item">
       <img src="<c:url value='${addetails.a.thumbnail}' />" alt="New York">
    </div>
  </div>

  <!-- Left and right controls -->
  <a class="left carousel-control" href="#myMainCarousel" data-slide="prev">
    <span class="glyphicon glyphicon-chevron-left"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="right carousel-control" href="#myMainCarousel" data-slide="next">
    <span class="glyphicon glyphicon-chevron-right"></span>
    <span class="sr-only">Next</span>
  </a>
</div>
</div><!-- carousel container -->

<div class ="frame94">
 <div class="" style = "display: flex;    flex-direction: row;    gap: 12px;">
 
 <c:set var="index" value="0" />
<c:set var="elementAtIndex0" value="${addetails.a.content.banners[index]}" />
<c:if test="${not empty elementAtIndex0}">
       <img src="<c:url value='${elementAtIndex0}' />" alt="New York" id ="tomato" style ="width: 150px;    height: 100px;"> </c:if>
       <c:if test="${empty elementAtIndex0}">
 <img src="nopreview.jpg" alt="New York" id ="tomato" style ="width: 150px;    height: 100px;"> </c:if>     
 
  
 <c:set var="index" value="1" />
<c:set var="elementAtIndex1" value="${addetails.a.content.banners[index]}" />  

<c:if test="${not empty elementAtIndex1}">   
   <img src="<c:url value='${elementAtIndex1}'/>" alt="New York"  style ="width: 150px;height: 100px;"></c:if>
   <c:if test="${empty elementAtIndex1}">
 <img src="nopreview.jpg" alt="New York" id ="tomato" style ="width: 150px;    height: 100px;"> </c:if>
 
 
  <c:set var="index" value="2" />
<c:set var="elementAtIndex2" value="${addetails.a.content.banners[index]}" /> 
     <c:if test="${not empty elementAtIndex2}">
         <img src="<c:url value='${elementAtIndex2}'/>"  alt="New York" id ="tomato" style ="width: 150px;height: 100px;">  </c:if>
          <c:if test="${empty elementAtIndex2}">
 <img src="nopreview.jpg" alt="New York" id ="tomato" style ="width: 150px;    height: 100px;"> </c:if>
 
 	
         
         
            
 </div>
 

</div>

</div><!--96 -->

<div class = "frame101">
<div class="frame83">
<div class="frame79">
<p> Offers </p>
<div><svg xmlns="http://www.w3.org/2000/svg" width="180" height="70" viewBox="0 0 134 70" fill="none">
  <path d="M65.6637 1.20001C66.4238 0.517418 67.5762 0.517418 68.3363 1.20001L82.241 13.6866C82.7061 14.1042 83.3397 14.2804 83.9536 14.1628L110.323 9.112C111.878 8.81423 113.146 10.3547 112.555 11.823L108.39 22.1721C107.913 23.3574 108.654 24.6801 109.914 24.8913L131.809 28.5615C133.806 28.8963 134.098 31.6474 132.215 32.3934L116.184 38.7438C114.763 39.3066 114.473 41.1904 115.658 42.1547L125.78 50.3882C127.248 51.5827 126.389 53.9596 124.497 53.9396L98.517 53.6654C97.6348 53.656 96.8507 54.2259 96.5872 55.0679L92.6308 67.7094C92.2762 68.8424 91.0185 69.4189 89.9288 68.948L67.7933 59.3828C67.2871 59.164 66.7129 59.164 66.2067 59.3828L44.0712 68.948C42.9815 69.4189 41.7238 68.8424 41.3692 67.7094L37.4128 55.0679C37.1493 54.2259 36.3652 53.656 35.483 53.6654L9.50345 53.9396C7.61059 53.9596 6.75179 51.5827 8.22027 50.3882L18.3419 42.1547C19.5275 41.1904 19.2372 39.3066 17.8165 38.7438L1.78535 32.3934C-0.0977488 31.6474 0.193686 28.8963 2.19128 28.5615L24.0857 24.8913C25.3459 24.6801 26.0875 23.3574 25.6104 22.1721L21.4452 11.823C20.8542 10.3547 22.1222 8.81423 23.6768 9.112L50.0464 14.1628C50.6603 14.2804 51.2939 14.1042 51.759 13.6866L65.6637 1.20001Z" fill="#FFCA44"/>
  <text x="35" y="35" fill="red">20% Offer</text>
</svg></div>
</div>
<div class="frame78">
<div><p> Validity</p></div>
<div style = "display:flex;flex-direction:row;gap:20px;">
<div style ="display:flex;flex-direction:column;gap:0px;" ><p id="from">${addetails.dateRange.fromDate}</p><p>Validity From</p></div>
<div style ="display:flex;flex-direction:column;gap:0px;" ><p id ="till">${addetails.dateRange.toDate}</p><p>Validity Till</p></div>


 </div>



</div><!-- 78 -->


</div><!-- 83-->


</div>
</div><!-- 95 -->
<div class ="frame81">
<div class="panel panel-default "   role = "button" style = "border-radius:20px; width:650px;" >
<div class="panel-heading" id ="panelhead"   >
 <img src="<c:url value='${addetails.companies.companyLogoPath}' />"  alt="User profile" style="width: 37px;height: 39px;" class="roundedborder" />
  <div id="frame20" style ="display: flex;flex-direction: column;align-items: flex-start;gap: 0px;flex: 1 0 0;"><h5 id="publishername" style ="color: #000;
font-family: Inter;font-size: 17px;font-style: normal;font-weight: 700;line-height: normal;align-self: stretch;">${addetails.companies.name} </h5><div id ="publisherdate"></div></div>
<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>
<div><svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 40 40" fill="none"> <path d="M11.5 28.6801V10H28V28.7634L20.1668 21.7548L19.4817 21.1418L18.8134 21.773L11.5 28.6801Z" stroke="black" stroke-width="2"/></svg></div>
</div>
<div class="panel-body" style="padding:25px;border-bottom-left-radius: 20px;border-bottom-right-radius: 20px;">  		    	     	 
    		    	     	 
<div class= "textcontainer" style = "display: flex;    flex-direction: column;    gap: 10px;"> 
<p style="color: #000;font-family: Inter;font-size: 18px;font-style: normal;font-weight: 700;line-height: normal;align-self: stretch;">${addetails.a.title}</p>
<p class="description" style="display: -webkit-box;-webkit-box-orient: vertical;-webkit-line-clamp: 3;align-self: stretch;overflow: hidden;color: #000;text-overflow: ellipsis;
font-family: Inter;font-size: 18px;font-style: normal;font-weight: 400;line-height: normal;">${addetails.a.description}</p>
<c:if test="${not empty addetails.a.customTextSection}">
<c:forEach var="itm" items="${addetails.a.customTextSection}">
<p>${itm.title}</p>
<p>${itm.description}</p>
</c:forEach>
</c:if>
<h5 class="expires" style ="display: -webkit-box;-webkit-box-orient: vertical;-webkit-line-clamp: 1;overflow: hidden;
color: #FF1515;text-overflow: ellipsis;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;"> Expires on ${addetails.dateRange.fromDate}</h5>
 <div class ="button-group"><button style = "outline: none;background-color: #F4F2ED;border: none;width: 33px;
    height: 33px;    border-radius: 9px;">  <i class="fa fa-phone" aria-hidden="true"></i></button>
 <button style = "outline: none;background-color: #F4F2ED;border: none;width: 33px;
    height: 33px;    border-radius: 9px;"><i class="fa fa-whatsapp" aria-hidden="true" onclick=whatsapp(${addetails.phoneNumber})></i></button><button style = "outline: none;background-color: #F4F2ED;border: none;width: 33px;
    height: 33px;    border-radius: 9px;"><i class="fa fa-envelope"></i></button>
 <button type="button" class="btn btn-default" id = "takeme" onclick="takeme(${addetails.location.lat},${addetails.location.lng})";><i class="fa fa-map-marker" aria-hidden="true" style = "font-size:17px;color: #F27C0A;">&nbsp;Take me there</i></button>
 </div>


</div><!-- textcontainer-->

<div class = "video">
Video
<div style = "display: block;    width: 100%;height:200px;overflow:hidden;" class="video-container">
 <!-- <video  controls>
    <source src='${addetails.a.content.videoLink}' type="video/mp4">
   
</video>  -->

<iframe width="560" height="315" src='${addetails.a.content.videoLink}' frameborder="0" allowfullscreen></iframe>


</div>

 </div><!-- video -->

</div><!-- panel body -->
</div><!-- panel default -->

</div><!-- 81 -->




</div>
<div class="frame70">

<div><p>Other Offers in your location</p></div>
<div style ="display:flex;flex-direction:row;gap:10px;overflow:hidden;user-select:none;" id ="ads" class="ads">
 <c:forEach var="adDetailsList" items="${allads}" varStatus="status">
                    <c:set var="count" value="${count + 1}" scope="page"/>
<div class="panel panel-default "   role = "button" style = "border-radius:20px;height:300px; " >
<div class="panel-heading" id ="panelhead">
 <img src="<c:url value='${adDetailsList.companies.companyLogoPath}' />"  alt="User profile" style="width: 37px;height: 39px;" class="roundedborder"/>
  <div id="frame20" style ="display: flex;flex-direction: column;align-items: flex-start;gap: 0px;flex: 1 0 0;"><h5 id="publishername" style ="color: #000;
font-family: Inter;font-size: 17px;font-style: normal;font-weight: 700;line-height: normal;align-self: stretch;">${adDetailsList.companies.name} </h5><div id ="publisherdate"></div></div>
<div class="follow" style="display:flex;flex-direction:row;align-items:center;"><button type="button" class="btn btn-default" id ="followbutton" >Follow<i class="fa fa-plus fa-sm" style="margin-left:8px;font-size: 12px;"></i></button></div>
<div><svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 40 40" fill="none"> <path d="M11.5 28.6801V10H28V28.7634L20.1668 21.7548L19.4817 21.1418L18.8134 21.773L11.5 28.6801Z" stroke="black" stroke-width="2"/></svg></div>
</div>
<div class="panel-body" style="padding:0px;;display:flex;flex-direction:row;user-select: none;">  		    	     	 
 <div class = "carousel-container" style ="margin-right:10px;">

<div id="myCarousel-${status.index}" class="carousel slide" data-ride="carousel" style ="width:200px;height:212px">
  <!-- Indicators -->
  <ol class="carousel-indicators">
    <li data-target="#myCarousel-${status.index}" data-slide-to="0" class="active"></li>
    <li data-target="#myCarousel-${status.index}" data-slide-to="1"></li>
    <li data-target="#myCarousel-${status.index}" data-slide-to="2"></li>
  </ol>

  <!-- Wrapper for slides -->
  <div class="carousel-inner">
    <div class="item active">
 
 
   <img src="<c:url value='${adDetailsList.a.thumbnail}'/>" alt="New York"  style ="width: 200px;height: 212px;border-bottom-left-radius: 20px;">
   

    </div>
    
<div class="item">
<c:set var="index" value="0" />
<c:set var="elementAtIndex0" value="${adDetailsList.a.content.banners[index]}" /> 

<c:if test="${not empty elementAtIndex0}">   
   <img src="<c:url value='${elementAtIndex0}'/>" alt="New York"  style ="width: 200px;height: 212px;border-bottom-left-radius: 20px;"></c:if>
   <c:if test="${empty elementAtIndex0}">
 <img src="nopreview.jpg" alt="New York" id ="tomato" style ="width: 200px;    height: 212px;border-bottom-left-radius: 20px;"> </c:if>


</div>
<div class="item">
<c:set var="index" value="1" />
<c:set var="elementAtIndex1" value="${adDetailsList.a.content.banners[index]}" /> 

<c:if test="${not empty elementAtIndex1}">   
   <img src="<c:url value='${elementAtIndex1}'/>" alt="New York"  style ="width: 200px;height: 212px;border-bottom-left-radius: 20px;"></c:if>
   <c:if test="${empty elementAtIndex1}">
 <img src="nopreview.jpg" alt="New York" id ="tomato" style ="width: 200px;    height: 212px;border-bottom-left-radius: 20px;"> </c:if>

</div>   
  </div>

  <!-- Left and right controls -->
  <a class="left carousel-control" href="#myCarousel-${status.index}" data-slide="prev">
    <span class="glyphicon glyphicon-chevron-left"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="right carousel-control" href="#myCarousel-${status.index}" data-slide="next">
    <span class="glyphicon glyphicon-chevron-right"></span>
    <span class="sr-only">Next</span>
  </a>
</div>
</div>   		    	     	 
<div class= "textcontainer" style = "display: flex;    flex-direction: column;    gap: 5px;padding:10px;" onclick=nextui(this); id = "${adDetailsList.id}"> <p style="color: #000;font-family: Inter;font-size: 18px;font-style: normal;font-weight: 700;line-height: normal;align-self: stretch;">${adDetailsList.a.title}</p><p class="description" style="display: -webkit-box;
-webkit-box-orient: vertical;-webkit-line-clamp: 3;align-self: stretch;overflow: hidden;color: #000;text-overflow: ellipsis;
font-family: Inter;font-size: 14px;font-style: normal;font-weight: 400;line-height: normal;">${adDetailsList.a.description}</p><h5 class="expires" style ="display: -webkit-box;
-webkit-box-orient: vertical;-webkit-line-clamp: 1;overflow: hidden;
color: #FF1515;text-overflow: ellipsis;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;"> Expires on ${adDetailsList.dateRange.fromDate}</h5>
 <div class ="button-group"><button style = "outline: none;background-color: #F4F2ED;border: none;width: 33px;
    height: 33px;    border-radius: 9px;">  <i class="fa fa-phone" aria-hidden="true"></i></button>
 <button style = "outline: none;background-color: #F4F2ED;border: none;width: 33px;
    height: 33px;    border-radius: 9px;"><i class="fa fa-whatsapp" aria-hidden="true"></i></button><button style = "outline: none;background-color: #F4F2ED;border: none;width: 33px;
    height: 33px;    border-radius: 9px;"><i class="fa fa-envelope"></i></button>
 <button type="button" class="btn btn-default" id = "take" style ="border-radius:6px;"><i class="fa fa-map-marker" aria-hidden="true" style = "font-size:17px;color: #F27C0A;">&nbsp;Take me there</i></button>
 </div>


</div><!-- textcontainer-->

</div><!-- panel body -->
<!--  <div class="panel-footer">hi</div>-->
</div><!-- panel default -->

</c:forEach>
</div>
</div>

</div>
<script type="text/javascript">

$(document).ready(function() {
    // Your code here
    console.log("The DOM is fully loaded.");
    
    var date1 = '${addetails.dateRange.fromDate}';
    var date2 = '${addetails.dateRange.toDate}';
   console.log(date1);
 	const dates1 = new Date(date1);
 	const dates2 = new Date(date2);
 	 console.log(dates1);
 	$('#from').val(date1);
 	$('#till').val(date2);
});
const container = document.querySelector('.ads');
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


function takeme(lats,lngs)
{
	console.log(lats+'and :'+lngs);
	//console.log(takemelat+'current loc :'+takemelng);
	var takemelat = '<%= session.getAttribute("latitude") %>';
	var takemelng = '<%= session.getAttribute("longitude") %>';
	const originLat = takemelat; // 
    const originLng = takemelng; // 
    const destinationLat = lats; 
    const destinationLng = lngs; 
    const url = 'https://www.google.com/maps/dir/?api=1&origin='+originLat+','+originLng+'&destination='+destinationLat+','+destinationLng+'&travelmode=driving';
    window.open(url, '_blank');
}

function whatsapp(phno)
{
/*if(mob=="")
	{
	$('#myModalforphone').modal('show');
	}
else{	*/					
   	 var whatsappUrl = 'https://wa.me/' + phno;
     window.open(whatsappUrl, '_blank');
            //	  }
           
}

function nextui(element)
{
	 const buttonId = element.id;
//console.log('in nextui');
//console.log(buttonId);			
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
</script>
<jsp:include page="footer.jsp" />
</body>
</html>