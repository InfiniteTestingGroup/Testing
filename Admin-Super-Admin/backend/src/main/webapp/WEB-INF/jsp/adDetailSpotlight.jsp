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
</style>
</head>
<body>

<script>
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
							     	//var videolink =  response.onead.a.content.videoLink;
							     	var videolink='https://keliri.s3.ap-south-1.amazonaws.com/media/ae45e5ac-1113-4ea9-92ea-2326b7bb2f58.mp4';
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
							    		 //targetDiv.innerHTML += ' <img src="<c:url value="'+response.onead.a.content.banners[j]+'"/>" alt="Image" style ="display: block;max-width: 80px;height:70px;">';
							    		 targetDiv.innerHTML += ' <img src="<c:url value="https://keliri.s3.ap-south-1.amazonaws.com/media/12f49934-89a0-498e-a8b2-b50e60b47985.png"/>" alt="Image" style ="display: block;max-width: 80px;height:70px;">';
				   		
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
							    	     console.log('simple text ad : ' +response.onead.a.content.AdText);
							    		 var targetDiv = document.getElementById('image-container');
							    		 targetDiv.innerHTML +='<p>'+response.onead.a.content.AdText+'</p>';
							    	 }
							     
					                },
					                error: function(xhr, status, error) {
					                   
					                }
					            });
							 
							 $('#addetailModal').modal('show');
							 	 }

//to show the ad in more detail end here
</script>
</body>
</html>