<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="form"  uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%
    // Set a session variable (this is usually done before)
 String profilepicpath = (String)   session.getAttribute("profilePicPath");
    if (profilepicpath == null) {
    	profilepicpath = "";
    }
    String mobilenumbersession = (String)   session.getAttribute("mobilenumber");
%>
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
 <!--   <script src="https://maps.googleapis.com/maps/api/js?key=${googleMapsApiKey}"></script> -->
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
     background-color:white;
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
.footer-container
{
display: flex;
flex-direction: row;
justify-content: center;
align-items: center;
padding: 6px 28px;
gap: 70px;/*30px*/
position: absolute;
left: 0px;
bottom: 0px;
background: #FFFFFF;
box-shadow: 0px 0px 14px rgba(0, 0, 0, 0.25);
width:100%;

}
footer{position: fixed; bottom: 0; left: 0; right: 0;background: #FFF;}

   
            
   .activefooter svg  path:first-child{fill:#F27C0A;stroke:#F27C0A;}     
    .activefooter svg path:last-child {
            stroke: white;   /* Change the stroke of the second path to red when active */
            fill:#F27C0A;
        }
.activefooter #spotlightfooterpath
 {
 stroke:#F27C0A;
 }
        
</style>
</head>
<body>
<footer>
<div class ="footer-container">
<a href ="/" class="link activefooter" id="home" data-url="/">
<svg width="21" height="22" viewBox="0 0 21 22" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M0.926636 10.7384C0.926636 9.08563 0.926636 8.25924 1.29993 7.53266C1.67458 6.80607 2.37621 6.26935 3.78082 5.19347L5.14321 4.15045C7.68405 2.2068 8.95106 1.23315 10.4633 1.23315C11.9755 1.23315 13.2439 2.20559 15.7834 4.14923L17.1458 5.19225C18.549 6.26813 19.252 6.80486 19.6253 7.53144C20 8.25803 20 9.08441 20 10.7372V15.8987C20 18.1941 20 19.3406 19.2016 20.0538C18.4033 20.767 17.1199 20.767 14.5504 20.767H6.37616C3.80671 20.767 2.52335 20.767 1.72499 20.0538C0.926636 19.3406 0.926636 18.1941 0.926636 15.8987V10.7384Z" stroke="black" stroke-width="1.5"/>
<path d="M13.8692 20.767V14.6817C13.8692 14.3589 13.7257 14.0493 13.4702 13.8211C13.2147 13.5928 12.8682 13.4646 12.5068 13.4646H8.41969C8.05837 13.4646 7.71184 13.5928 7.45634 13.8211C7.20085 14.0493 7.05731 14.3589 7.05731 14.6817V20.767" stroke="black" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>

</a>
<!--  <a href ="responsivespotlight" class="link " id="spotlightfooter" data-url="/responsivespotlight" >-->

<svg width="27" height="26" viewBox="0 0 27 26" fill="none" xmlns="http://www.w3.org/2000/svg">
<path id="spotlightfooterpath" d="M24.4091 13H25.5M13.5 2.09091V1M13.5 25V23.9091M22.2273 21.7273L21.1364 20.6364M22.2273 4.27273L21.1364 5.36364M4.77273 21.7273L5.86364 20.6364M4.77273 4.27273L5.86364 5.36364M1.5 13H2.59091M13.5 19.5455C15.236 19.5455 16.9008 18.8558 18.1283 17.6283C19.3558 16.4008 20.0455 14.736 20.0455 13C20.0455 11.264 19.3558 9.59918 18.1283 8.37167C16.9008 7.14415 15.236 6.45455 13.5 6.45455C11.764 6.45455 10.0992 7.14415 8.87167 8.37167C7.64415 9.59918 6.95455 11.264 6.95455 13C6.95455 14.736 7.64415 16.4008 8.87167 17.6283C10.0992 18.8558 11.764 19.5455 13.5 19.5455Z" stroke="black" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>

<a href = "responsivelocation" class="link" id ="location" data-url="/responsivelocation">
<svg width="16" height="20" viewBox="0 0 16 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path  fill-rule="evenodd" clip-rule="evenodd" d="M8 19.1884L8.72115 18.3758C9.53943 17.4386 10.2754 16.5495 10.9303 15.7038L11.4709 14.9906C13.728 11.9495 14.8571 9.53579 14.8571 7.75179C14.8571 3.94379 11.7874 0.856934 8 0.856934C4.21257 0.856934 1.14286 3.94379 1.14286 7.75179C1.14286 9.53579 2.272 11.9495 4.52915 14.9906L5.06972 15.7038C6.00393 16.9008 6.98134 18.0623 8 19.1884Z" stroke="black" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M8 10.5712C9.57796 10.5712 10.8571 9.29203 10.8571 7.71408C10.8571 6.13612 9.57796 4.85693 8 4.85693C6.42205 4.85693 5.14286 6.13612 5.14286 7.71408C5.14286 9.29203 6.42205 10.5712 8 10.5712Z" stroke="black" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
</a>
<a href ="/responsiveprofile" class="link" id ="profilefooter" data-url="/">
 <img  src="/Default_pfp.jpg"  alt="" style="width: 30px;height: 30px;border-radius:50%;" id="footerprofilepic" />
</a>
<!--<c:choose>
        <c:when test="${not empty sessionScope.profilePicPath}">
            <img src="${sessionScope.profilePicPath}" alt="Uploaded Image" id="footerprofilepic1" />
        </c:when>
        <c:otherwise>
            <a href ="/responsiveprofile" class="link" id ="profilefooter" data-url="/">
 <img  src="/Default_pfp.jpg"  alt="" style="width: 30px;height: 30px;border-radius:50%;" id="footerprofilepic2" />
</a>
        </c:otherwise>
    </c:choose>-->
</div>
</footer>
<script type="text/javascript">

var profileimgpath = "<%= profilepicpath%>";
var phonenumbersession = <%=mobilenumbersession%>;
var activeLink = '<%= session.getAttribute("activeLink") != null ? session.getAttribute("activeLink") : "" %>';
console.log('active Link : ' +activeLink);
// Get all anchor elements with the class "link"
    const links = document.querySelectorAll('.link');

    // Make the first link active by default
  /*  if (links.length > 0) {
        links[0].classList.add('activefooter');
    }

    // Add click event listener to each link
    links.forEach(link => {
        link.addEventListener('click', function(event) {
            // Prevent the default action (page navigation)
            event.preventDefault();

            // Remove the "active" class from all links
            links.forEach(link => link.classList.remove('activefooter'));
            if(activeLink=="spotlight")
            	{
            	var element = document.getElementById('spotlight');
            	element.classList.add('activefooter');
            	}
         
            const targetUrl = this.getAttribute('data-url');

            // Redirect to the target URL
            window.location.href = targetUrl;
        });
    });*/

    $(document).ready(function() { 
    	//console.log("The DOM is fully loaded"); // Your code here
    	   links.forEach(link => link.classList.remove('activefooter'));
           if(activeLink=="spotlight")
           	{
           	var element = document.getElementById('spotlightfooter');
           	element.classList.add('activefooter');
           	var path = document.getElementById('spotlightfooterpath');
           	path.setAttribute('stroke', 'red');
           	}
           if(activeLink=="location")
          	{
          	var element = document.getElementById('location');
          	element.classList.add('activefooter');
          	}
           if(activeLink=="home")
         	{
         	var element = document.getElementById('home');
         	element.classList.add('activefooter');
         	}
           if(activeLink=="profile")
        	{
        	var element = document.getElementById('profilefooter');
        	element.classList.add('activefooter');
        	}         
           if(phonenumbersession != null)
        	   {
           if(profileimgpath=="" )
        	   {
        	
        	   }
           else
        	   {
        	 $('#footerprofilepic').attr("src", profileimgpath);
        	   }
           
        	   }
           
    });

</script>
</body>
</html>