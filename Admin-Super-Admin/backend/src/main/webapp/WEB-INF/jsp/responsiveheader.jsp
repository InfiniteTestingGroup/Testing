<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
height: 55px;
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
    align-items: center;gap:10px;
 /*   border-bottom: 1px solid #000;*/
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
  
  .searchloc{box-sizing: border-box;display: flex;flex-direction: row;justify-content: space-between;align-items: center;
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
<div class = "logo-container" style = "width:35%;">
<!-- <img loading="lazy" src="/logo.png" class="logo-image" alt="Company Logo" /> -->
<!-- <svg width="30" height="30" viewBox="0 0 30 30" fill="none" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
<rect width="30" height="30" fill="url(#pattern0_392_439)"/>
<defs>
<pattern id="pattern0_392_439" patternContentUnits="objectBoundingBox" width="1" height="1">
<use xlink:href="#image0_392_439" transform="matrix(0.00522748 0 0 0.00533681 0.0436579 0.123533)"/>
</pattern>
<image id="image0_392_439" width="512" height="127" xlink:href="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAgAAAAB/CAYAAACZk3rHAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAINBJREFUeNrsnXt0JFWdx2/PAQHBSw8iIIxMBRgB9Rw6f+3Zh6ajHvA9HXWPro9Ntx5dWXWTuOgKIkkQZxTEJL7f6fjaXVadzp59qYvpYc8+FdKDugygmxoYkJek5zIoKpPe+6u6nXQ6/ayq232r6vs5p04yPUml6r5+39/v3vu7jAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIBwkUAThRPz+8zKswkbllWaVRFJ+VJZfi/Lfc/xHtxdRQgAAACAAomL0//C5ljTwY/LbrGP0K/I751LVSF/dz6QASIzwWw+UUWoAAAAgAMJo9J9/sfTuExnH8FdYyqmyyiZj30gA0Pdk/Af5bQdslCIAAIB6jkMRGGr4hy5KSSNO3j4Z/6SHW9Dv7CMRgNIEAACACIDJRn/4QvL2s8rbtxp6+51HAKqfTfPl0hRKFwAAAASAaYb/RRe6C/ocb7+Nse9eANhSAAyglAEAAEAAmGD0L91lOSH+imP0LddYd2DsuxcA9O9BXiqVUOqds2PHjnT9Z4cPHy6iZIDH9lOW7adk4HPS2GPVfWzLZ7VRi32pD5q6TfVq7IEA6LXhv2xXVn6pbt+rM9baBMCIFAAFlH7bzkd1M9aoA9ZAg/ic7JB5lBioG7jdvt26/VA/XOxn+1HtfDejiGNryOgs0DPL58WOIr1ikdpNuoEYqx97imr8CUSgQQD0wui/7PzUurfP6rbv9UYA5KQAgMFqPXgvtRm4Gw2OIxgYgWw/1G72tRm8+95+lKGZ7/I5nYiAvCbks8KJCH7c2acMf7dMy/qYggAw1ei/4jxp6BNVbz+1bpxZnZHujQAYlgKgiFoJzPjXKvJhiIBYt5+MGsS94GzV7UW4XXn98z5vk0PkK1DRSONO0sdt8rI+cn6eYxuqImDD/6qBjHjledTRVqWtnvFoWEDv2OejjlIBDKogvIO45bP+kz7EQ7fGJoh2Oq/uBfw7HfM+jT+RlffyFQWAAAjC6GcsS+y2psTugRXVobMolVB0xDTzFn6rJYNBMbYEMYinlHeukxlD7xVXxgN0DMeUoIAA6Lnhf/XOrBixKIyzIr39Sdb93BroL2OG3QeERzymAhCPVSZD8pxEWkU+gHdGA7xX0o/DCQHQrdF/7bkp8ZpzZ8Rrdq4qDyCNUgktmYDugzaAQdwPVqNtp4a1cbT34ARZ0AJqyOsvIhVwJ0b/dc9Kqv36G1vEKiiXkHfEIAcxGsAt7J2OFWkN9ytqeM4hDfe8BNVvlHjyfE8IgFaG//Vqf2YFc/oRJOh5e1L1EABoPyYZaiIZgnePE0mT7gkBUG/033iO5Rj8SmLUGdTh6aMjdj4oFlGs0UdTuN4KiVAB/jjVpIeBAKga/jednVHefgalAQxR9iA+WCiCWGCUIIu1ABCjz7Tck/echD1JePuxYieKAMCrBj2GkoelIQD6ZfRzZyWVlz/mZOgLBzY8BHhcwBi0RHtohbiGA4MwdpjFkS7qzdYtFmKzDVC89cy0eMuZtG2P9uzPh0DF00BAaR63M/dADgAAhIUXAaBjbALeaJc2nM5bGJbXSBfG33Mq8khHAMTbznCTJDhh/lCo4LJqAHN8/8H1Tiae/xx0GwCAF/Z78CLLLYz8fjVGAW8UG3y/X5V3kc4VUZn9VjzeEwJA/NkzMtLg0yr+TDjm9SuyAhML/Ad35tE/AAABQsa620yDSXVN6DqHPq6oKZ6mh/DVHE7WTTRoMfYCQFx+Onn4tKAvExJv32ZuaD/Pb77LRtcAAOgwONKoFD1EAZzT6uTvklMyp2FtAthq/L0cK12NGsdPAIh3nZZUBn/UaeDh8PZlh0os8u/dHbkwmth7fJY5WynXjyWWyjSR51f/BsflAtA/ppn3xWTUp+nUuZISAnkUpxbjTwvTvRwuNe3nOPJQCgDx7tNSrrfvrOYPw/5r8vDnWEJ6+//8s0gaQ8f4V6gBV42/85UGnUlx7Yk5fs0TmDcEoD9RgKI0MDnm70jgFPOx2Aw0Nfzk7dMJi17yz+Rl3c76+fuhEQBiPJl09utXnJPXwpChT3aWijR6iTn+Tz+PfviMMie6Xj+rEwHOmedi6qQcn/o1vAcA+iMC8tLYlD16meTA5LAeQAteD5Qjz3/K7x83fhugeE8yIyaSVEirSilZhj+y7CSVnLSBA/wf/i/H//Hn8Zg7Wzf48lpbN/7q385n8+KapyLLIgD9EwEUhRtg7pSA3aHhn5DXIIy/tjqhLX8UnenETpCAIydqIAjjb2wEQFxxqsrHz0YZC82CPnf73t+v2LFsyWuJaiSArUcCKls+mxdXn1zi1z1uo+sD0BeDQ0aEjMeUCj9bDTxQMvY2TrfsWZ2QUc+rHQApddVGaUqqPgJ3Jo0SAOJ93DX6lUraCSMnmOnH7pLRX+AFG/PblURJzfm3EgGUhZFWuQ6i2wPQd8NjK+cF3r054qzYy/rouwAQ7z8lJY1D+Bb00fa97xzCoph1AcAWZD2Ob10HUCsCnO9T4spTpvjeo1MotMYoz4z6w07lDVCbO0SegArjAgBAOAWAuOpkaeid7Xsb+fjN9vbdvZYJ6e3fdA/UcgP45BMlMXlSURr4dAciYFK872kFfv1j2Fu82fBTX6B1LukWP1NWAnTWz/YfAADoqQAQV5+cVvP62ZCcvFdSg22B33QvBtu2UYDEhKzX5U1TAM1FABm6YRTaumHPKuPfLgpG/0+Z3Ubl74wgQQsAwFgBIK45yZJGoDq3b7XIgmiSt5+XjznHv4lFMF1FAa79VUl84GTalzregQhIi788NctvPJKH8Xc8/273aMu+5GRqG4YIAAAYJQDE1InS6Cd2s9Dk41cL+r5xH+ZY/YiADz8+Ia48Jc1o7rqZCNj4flJMJAt8phzb6Ioy/ksefz2pRMBA2KYD1Hsnsb0MgIgIAPGhEyy1oC+rEsCYDnn4C06Gvq/eD28/KCpsRLaDZcdAtYoEuGc2jDN3W1IcjX+SeUvMUi8CaOogZ9B7kQCka6eKVFSvRj/b6GOKaJTZxuJHEgklrHkItI6y8stuVS+1R6NXTwKka6Hf0SXVR2hB7FCDNkTP6pxOGMSWRSVKq3+rnv1M4yJc1Wd2q7pIN+gPdO0POhVzIPF4cd0J0ttTi5da7wP3/1ljQ8Lqss81/zn3vnlatc7zD4TC+xDPf84UectN37N9+Q3zUsnzu4q9x1O92vyq33bcycT7njau5vnb1V1Zfh3gn3y03OOBZYl5z4/eiK4zcwX8DAP92rdds2thd8Bl2kiwUzte7OduCPm+VM+TGm49rDsionLOd5NQjco51w/x1WU506LYCR+Gf6bDtkttMLC1N6rvdJMN0GYBZmX0nQlQfPgpUklWluW4nmZmU3K8pERlO59/IBcW499X4bH3+Ky8VqWBXmJrbEV86IQVce2JHRk5fv1js9K4l5wEQZuyAjJW9xkp/GwMPTCvKUCbkenDO2SViFnpYgD1g6Xayj75d1epDJXnBDr3+rs9bY7a1Yoykj3z+uW13KXIGld9qtu/RRHI5S7aLpXdchDloe6x3GW/ob+/pOqyvwJA7CHj7+uACd2QaqVFaYP8yw8O8q88mJcXwoid1S1N58xLY51cN9hrCUtek2LypGXxwae2D1u7uwJUKuC6yEWtCFhLjMVsIB7XIHqGemz4V5j3POZBUBWONBguBzUgRtz4z/so630qHN8L6Dm9GFhqlzNdivAZj8+4LwDPf4l5n/4LRPx6FgBiz/GWwcbfCVvxLzy0nX/xoQn+pYewSrpbaH6+arjpOlbz/VoiJa8lN59DiyjAjUcoL0Bx05kAjUWAJS4/PRbnBNRs99NhEHU/u6U8/nlmVorulBoQl3rpqYaozSUDaHOWpnbbqH/4GQvGlXHtxPj7EY2Wmk7xI3L89tl5v6LMewQgoWUOzA82cw65qAzwzz88wr/wcB5d3wfNjX/VcJMIaN8GKonpLQcDNRYBozEYiFO9GEQ1Dszdhit7DT3bspo7BhtMBiQQs50Y1wCeVes9VPvIBvB3hjz2pXRA/cjy+x5+pgBM8djI0I/wzzwywD/7yBT/3CM2+nvAAqD5NS7ey1s2ZD67WpQ/V9wqAurWBlQSGfH2M5JRLU6l1P2E/DoRwDqN/zwLR6puxwCoaEASHdk13AHea0xjO8uwYCJL2TbGNyjn1Wu0adSU+vAkAMTe41P9HQwqFNKnFZ/b+ad/meOf+SX27gcMn3yiWOPtNxYA7uftPdoKm95s9GuPDN50fHA2imXZA+NP7Nds/MMGDfSxFwHKqAZZBjodv6EA3zvdpB/uC/B5UwaUoeVn2strBKAfnap6FvIg/8TqIP/ko7P8U49iQZ/eKEBhq+HfEh1IifFkS8Mt64nWAdgb4X/WTATsjmhJzvsYLDry/oPeH1xjPOZDXO5+kixFhaDbnaVxGiCt+V5BTYV4toNKmCRNKbdtIWjARUYL+mbL2/ncak4afyzo650AWGg5BbCxNqCTtQBzW1b/b54CIBGQFrmzIuWxqcVGuqfLJjQ8txVy479uALtZGR5BdOwO0SUAghQrlzRoz+MG1IeOstsZNQFgM3f73gD/eHmYz5Tzcey5YujitHjBxdRo++IZ8z1HKQJgtzH+zvZA8c6np9sIgEKTLYD1uQHSUak/FT7Pav4zeU1JccI059+OceQLMDqqwDRM1SQbeP8mYJlUH8cZ1rDcfPwfE7Gb0xcvvNBNAVlJXOIckVxhZmxnWnNW8c9vGG7WaO6eOSmg3WhNYzHxuYdt8fYzSurdajIDsvosjUOqHYTd+PcifF6Uxj+n4dmzjEVHiCkoCjAYQ2Otox51CMOUxr5oMXOSjZ1qUuMwQQCQt09H7ub59SI2c/ri0l0ZafCGXIOYcDupgYcm8RtEXrwnOUrh+QYh+1rjnRFvOyPJv/hQ8zpcY4uMJVJb0zhvuk/oDY/H0/26habCRjTdezKCXY6mArI61koA46MUY4Y+V9+jCv0SAGXl5c3xjxw1ek5fvPjZFju2TV7ScB3bRlnxhtiT8usxZx+8nxz7Y6Hxso458/ftBIAjApi7ULMxblKgyZojgRuJgFAncqlZaZzU3H9GdORnV96/xaLJWMv2CULpxXYQpdDl/Ztiu0InAEp8z1FjTi8Tb9hBBt5iT5JRd4z7kGPsj21LsSfR2/ncakG86zRbGmhrS17/zQJgd6sBln/5waLInVV3WNFWESDeeE6af+O+YtjKqWa7n24DOqzx4J8op2WmKECq3yfcRcy7Nr1PBr0NshY77BV5XFxarBjb7hp5MurHao08efZkfRIBnY0YUdYoCpCY2bKCf21Tgp/2EQ06IKiSSLURAWH0QCm5x+4eDI45XQZMTV3ofP5q5G+RbRz3m6wZoNM9KMNRgzw3oB+dC6gXIQBMMvLXnWA5B9Y8WReup9z18OT9UXFyAsy0mQJIijefneJfu7/UQkiUnAF+88K/+u/DKAB68czTmuewdaZj7uRY2aK8ptSKfV3nDZBHOIEOHRvSmu5bFbOhZltUalnsPX6KJSp0QhmFYGnF76RT+QmGw0ECgH/2EXvTlsBjTfMDpNoIiUNtTgZkzk4IUA9t95vS/DcyGp+94zUL6qzzQaYnxGohRXA8UPkfdAnzOR1rcGItAMR7eZJyy4sreFZccWoaTdgwKKd/+/MBrDYCoNjmUCDmHEEMainp2O5XN1hamgZL28uzq8FV1zvDKYgHuhL/9EKM94R+TQEkxVWnZJ1Qb4VdQqFjx1uvbg9zmWYt9pWDvgiAA22mAOj71pnH1taFwNYtgGw9VTAEQI0BlddwD/6OLqM47fUXKRIghUlJw7OlMbYAj8zKdhmZKaR+CYBe7JMGwQuAUmsBwDbm8Vt4s1t+h225Dzw0F23b/XooAPzOky7CYwcGkJfXgpqeigzHoV5BFwKgdR4A999Wq1vwb95XFq97ljL6tb9fGwHAdgzFSA+3rOnIGV8KQLzQgDsZgncF4RbaJXUdqfncZu4UVjGqLw4BADqGf+3+onjDOb4EwCbD30oEgFwEBp4gIhc2mgLQ6NXPxTkvBAQA8BAFaDEFsNaB995yCkCJgHgz24eUtWkTC4ISHu3YsQP9DgQJTUtNaEymBQHQBlJclP+fvEXa8pVk0Tt8JNoCYN34exAAazWeflMREN/BKUqLjAAwjBzOg+i/ACjzPUe3VAJtA2Tugh8SBjaqxyzEa89NrRv+hgLA+bx92HfLqv9GOwJiywJaGgAw/lEWAA3hNzinARZRLYZC2zUrbQRApXWaVTFiJTdOA2whAuIL5eIvoLEBECjTMP6GCwCfzCrxYDFMLejhmMry11oAtBERLLXJ028sAuwYl3KaUuFGeeUxAD3GjkriHgiAZtGDK3/XNHogJpK1UwsQB94jADvbbgNkiVKbezTe+89Y7fd2zEuacmQMROA9kiqvPwB99f5RBNGPADQXBzPl5uLgTWdvFgcViIOm0Gl/7QXAoTYRgHSHIiDOUL76bARCltSvltBxQB8pI/RvngBIiatOmZKDfZ7vPdpXb49//f7m4uCyXYgcVMvi5edb0sCnfEcA1hKndhAJ2I+u6SS/wcAFgD+KKALzBEBSDXCT4v2nFOTAv8A/+phxC5/4d+9uLg4GL/Gbr562etHpa0OhEBQV+aybjH2DFMDyKy8ebN3hKtV1BC1FQBldMzJRAAD6yQEUgXkCoBYyghnxV0+znTPnK2yO3yBs0wuOLx/wZaT49+6upp50BcWLLkwrIWCmIFhLjHUgANqr7eoUQL0I2JwFsISuiSgAAIgARF8ArHs8zD2+cVxcwenIWNoPXeA3HomFN8hvvrNY21jF0EXGCAJx2a40W6P1EVvS/tYLgMWW93npBRsnPrYQAaosgBsFmMIKZgCADrYZ+lxk8Ggl9Ip4T3JeTCRjdxoY33+wyPffMcVvuYOOgu3vKta1xKjj8be7KILT1vtnm7MGbj1gCN7/ZsakCMDxyMGyiCKIDTaKIHwCoAoNfFl5LYvx5LIY2z4uLwyGvRcA2Q4EQJH/+09bd7ZKYrf7s4w1n05IQABs7QPjKIbAoIgiEi3FBOT71yMA+hGWpyjAjDQUq+Ivts+Ld5+WRvXpR7zwwkwTb7/+s5YpbMWluywnCVDTHQTr32MHAKIAOsEhMAD4EQD8yt/12UtLUFRgSbzrtBXxzqdPyctCVWrz/lMdeP82/+8f59t4/5kG4f5GIgDeGaIAukAueAACiAAQJgzUZPgnpdFYEX9++j5x+ekZVGngAmDIMdT1Rv/Ypn+3X6NQYWMNwv11IoCV+C13YAtg8ygAhK43yOgPwPgDsBnvuwAqznG+JhlcdzvhO04vS4NCHX2Of/5hG1XsWwBszfW/eQugzW+9veXA6mxxrDhZFlsc/+t8j5PwWkcBaFtgLkTPTP2vn3ValFdJGn6ISgCCFAD8qt8VxZ6nTKtBySASbri0wsbF288oOUKlwgr8Sw9hENAhABgb6cz7XzfyrUQAwv+tye7YsWM6RHPYOIQFAIPxtQuAX/Vb6tyzBr8fLRx0txO+9cx58ZYzU6jyrgXAQpMFgBRpyfHbDrQ+/nf4IsuZ/6+0Xf3ffhcBYOYJbgBALAWAIwI+8NsJ6bkNUyjY4Pfc2E6YO2tFXuMiexZWVXdSv//1k7w01LN1IoDSNw/y5VK+A+9/soOFf0wlfgKdRQEsFAMAoO8CwDESV/+myD/4Gzq+lMLBpodxafCckdeqGH3mvPjTZ2LhYLv6/eGPJ6Sh3i4N9bD0+BPS8I/wUqmt4HOyGVZUDoHWIqDM//Mn+ZAXEz3/cM2l831m0CoBAH4JNBWwFAFk/Ati+sSqxz2mDK6x3hRd4s1nkzFbcE4n/Pr9NppFg7q97UDTg5Gae/+JSfW11cK/6oLSsHPo8OHD6+UjvXRbtS8dZOT907V/DwAA+hIB2GIsJp8o86knZvn0rwc6OiDGjKgAGasV8cZz9ok3nJNF0/CHeMHF2fWDfxrP+TO1vZDWEsxG7f3VQj2dUQCsBQAAmCcAQg5NCcyLP9mxKq8Z8XrMt3qCvP/2C/8c75//z4+jukND5xkOaYoCoKEBALxyHIqgKdXsa+Pidc8qqTB1gd90L7YTtvP+/+g5GXfff6Nw/6bPqCxno1oOFAWQRpqiAFmNUYBinNtaCxFkI+UvABAAQeBuJ6wkZsQfn1ughDX8W/cUUSxNvf/dDef8148AXl8TMM1/dHvUBdWCRgGQDnAtQFmJ3iCxNBh86oujzI3UWW1+trpuZQ7rJQDYCqYAuo8K0GC+JF6zc0W8eue4GNmJ7YRbBADLbBwWxJokEWIlafxno14UyvDoND7zAd1Hx/keVlCHGNHWR3ktyW+XmRuZszrsryQUluTvzqNjAgABEKR3M8NYYlVkrH3ywnbCjQhAsvG2v1oRkJiIUYnoXAtAhjGICIOtK0oRkNe/7PNeWYgAACAAdEDGf5/YPbAiXjUwJV45YMW6NNZYi0N/nM9n+W0HinEpjh5EAYLYEXBA07ON+jT+5MUvsWCmJ7JYOAlAeAUAeSkmzxlb7mCcWBGvOG9JXtlYtqoKbe1rKgLyfPnARAxLRWemwyCiALqO+M4oD94r8yzYtQmjDAAQSgFAmQYpt0BO44AVFNLTSMyLl5+/Kl52/ox46QXxOYdgLTHX4OAg2u8/zZdLuTh2NHUUrW1qFEBFKXSJ63kvawHk79Bcf9BTaxaGfQDCJwCm+dxqiX9itcw/+WheXoOOGHC3kZkcFahuJ1wWL7mArqy4bFekFw7yH90+JY39iHMsc4Xlnfn+ChvgpdJUzPub7rUAaZ/30JXGO9WtCFARDR0pjyEAAFCEZRtgkc+WtxgP/qlHyaOicPKEuPx0GjB2a/AYAh4IExTSnBGX7qIDdRb49+8qRlIE3HqgwMw/F6LnUQBp2CY1GiEKb/tpT4tMY/piJVImWm3JUyJhUolmHSCPBwAhEgDUYduGjflnH8nLL3nxjmdYahAbNVjtV7cTZsWLn227SYYSBX7znTaaZORZYPrS+GaVgfVk5OTvFdQZBrr6DUUCaEteSQmVI3X/P8QC2DUAAQBAZARAZZrPHOnYMPLPPUw/S9GCKfG2MzIqKpA1+AXlYJuYcaICL7zQjQosHYTnHF1oymqMBZ90p9bTzvv4fZqm0L1dLqWufgCR7Z8SiiAamL4GoMA/fsRzshj+xYcK8spJA7uduVMFpjdcdzth+qIVMXTRjBi62EITjRbKO9d5+uGQz+fLR3yA32/ws4VFnBxBT45GuzFZAHQU+u9ICHzpwTL/8oOz/CsP0sLBQWdhmvnbCWkOdEW84OIlv4M6MM6L0blwNQjPOsrbNAumth2cXYBxBwKgSoLl+I1HAh8k+fwDJZ5/IMcqiQElMIqGN5g00z8vGkf65sWoKIDOFfd+n6/IonlI06zX9RENnJOwoGN80/H+dkjuGdpxJ0wCIM8/dkTrPDhf+EVZXnn+1V8MMze3wCzDAiHQO2U/bfLLSEMZhimzbo1BUGVeNqD9RMqL1RT9sA1th8bUxzZDC6inIUj+tftt/vX7J+RFawVGGLavwWBrNgpqwMsbXkbDEREBVDcjAXn/VHdGhXHbsD9Ez2qH5DlNe6ZDURIAOf4x0TdPnH/jvgL/5n3VjIPTDKuGo0rQ9erFKExr8CYDM07KYIZdBDjvoMFoF0NgqHUIXVvjWoWwlKmfPlU0qdxMEwCz/AZRNOFB+F8ftvnfHJ6S14AaBE331kD3XlxQA1nJi3epBtKgdwSUAi6nqggohrCaS5qMP7EY8P0Kmtp5IWCRqTM6GooyNey5bD/t2yQBUOLXCyNXH/O/vbfIb7qXFgxuZxVGaW2xDzYaBNURPR/0IzvvVMBGO/C1BSQC5DXMDF+3UO9MaDT+TDkEQRnWouYdAEEaHG1bWAMWK/mgpnw0EGQZ+jpkzCQBYPwhMfzv7inzb90zy799j7udkBm/nRDo74hl5j86lAuoHc3qNCRKrAwys6cEisrwT+g0AAHnc9AtrIKaair0YKvidEjK1E/bKbJgImpl5nO3jhkCIMGm+UcfC5VXzb99qMS/cyjH99nbnQG8EsoQaaxRg5nfgWLOr6FRXqpfAVzqxaBHzyqvQfW8tkHVWVCGf1jTPGuzKIPfcSuv+3kDaueB5WVp86xBlOl0CHIqTAQgynJ+xx4TBECRf+SxqTAbEl6w83zRdrcTuoOCzUBYRMCUDw8+r34/iOco+Bhgq15vuYflRu9eXR/Tr7nWkhpIB+SzjPTQ8NdGAfwskqQyzPXoWWd9tPNyj9uX3zI13p4o0T/sQwTk1Jjh0/fWjLjmpCX5Z9LumfB0qT/pnhdfltcg/8jRyBlM8YrzMvId6UCizPp7V1SR15bFpjKp/az2Z9t8trlMG302zEslRChasGPHDho0ujmkZ1rHQCOfgxL57GOdHchjq+fIG1B+dLZBmrlnb6SZngOFqocIHWBuOLpsSNuhd59n3Z1EOt0PQ1VzzHKnZ1EUlbGxDS9TagsTJvQFD/2d3rPTBF62es9ARHe/BcAE33s0ihnHNt7/5edb8j1JDIzJrxYEgNGdkYwWDZBDqkMm6wYYMkCLTPNcqBr86DlGGwwMZTUoL5o82Kl3SCkxcGrNe6RaGB+bbUTPqKyPqK+2xsV8QQ/mozXv3ejdtLefDuumelBaqoFYK1bbeq+jKh7KtLZPlkM89tTWR6qB8LV19Pl+CoAC33N0JE4GRrzkgrSKCmQhAECXgyALgxEEAISHfq0BkEqtkotbYfN/+VmRf/duWjDoLhzEsZqgA9TCO7QVAEAkBECO73k8ttvn+PfuLssrz79/18Z2woq27YRleP8AAABMEAB5/uHHkWu/Kgb+9a4Sv/nOHP/BndWoQNDGGmUNAACg7wLAZolInzXuTwz84M48XzpY3U44zSq+txPSVAvKGwAAQN8FQI5f9zgy57UTAsWDNt9/cIrfcgcJAT+nE47w5QMobwAAAH0VALP8ul8VUeRdioFb7ijwf/tfEgE0RTDRYVTAOf6U33YA5Q0AAKAhvdoGmOTX/moQxR1Qmf7Bc93thE5+AZas2/JHCwqn+a232ygpAAAAzTiuN38mflv+tEYF/uOn5NnTlRO/97z0+uc/vB0ePwAAAEO81cmTUigFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAA/l+AAQAHvBty5cQwkgAAAABJRU5ErkJggg=="/>
</defs>
</svg>-->
<img src = "/logo-full.png" style = "width:100%;">
</div>
<div class="map-container">
<div class="map-container2">
<!-- <input type="text" class="form-control" id="usr">-->
<div class = "locationbuttons" style = "display:flex;flex-direction:row;gap:2px;justify-content:space-evenly; align-items:center; width:100%;">
<button style="border:none;outline:none;background:none;flex:1; text-align:center;" id="currentlocationbutton"><img src = "/currentlocation.png" style = "height:25px;"></button>
<div><button style="border:none;outline:none;background:none;flex:1; text-align:center;" id = "pinlocationbutton"><img src = "/google-maps.png" style = "height:25px;"></button></div>

</div>
<button data-toggle="modal" data-target="#myModal" style ="border:none;outline:none;background:none;">
<svg width="9" height="9" viewBox="0 0 9 9" fill="none" xmlns="http://www.w3.org/2000/svg" id = "mapdrop">
<path d="M4.54635 5.75013L7.5645 2.73603C7.5938 2.70657 7.62871 2.6833 7.66717 2.66758C7.70563 2.65187 7.74685 2.64403 7.78839 2.64453C7.82993 2.64504 7.87095 2.65387 7.90902 2.67051C7.94708 2.68716 7.98142 2.71127 8.01 2.74143C8.06855 2.8031 8.10074 2.88518 8.09973 2.97022C8.09872 3.05526 8.0646 3.13655 8.0046 3.19683L4.76325 6.43368C4.73417 6.46296 4.69954 6.48615 4.66139 6.50189C4.62324 6.51763 4.58233 6.52561 4.54106 6.52536C4.49979 6.52511 4.45898 6.51663 4.42103 6.50043C4.38307 6.48422 4.34873 6.46061 4.32 6.43098L0.992251 3.02403C0.933356 2.96303 0.90044 2.88156 0.90044 2.79678C0.90044 2.71199 0.933356 2.63052 0.992251 2.56953C1.02119 2.53972 1.05582 2.51603 1.09408 2.49986C1.13234 2.48368 1.17346 2.47534 1.215 2.47534C1.25654 2.47534 1.29766 2.48368 1.33592 2.49986C1.37418 2.51603 1.40881 2.53972 1.43775 2.56953L4.54635 5.75013Z" fill="black"/>
</svg>
</button>
</div><!-- map-container2 -->
</div>
<div class="bell-icon"  style ="display: flex;    flex-direction: row;    gap: 5px;">
<!--  <button id ="distance" class="activesort"><span class="glyphicon glyphicon-resize-vertical"></span>  </button>
   <button id ="time" class="inactivesort"> <i class="material-icons" style="font-size:18px">access_time</i>  </button>
   <button id ="road" class="roadinactive"> <span class="glyphicon glyphicon-road"></span>  </button>
   <button id = "gi" class="roadinactive" onclick="giads()"><img src="gitagicon2.png" style = "width: 20px;   border: none;
   /*border-color: #F27C0A;border: 1px solid #F27C0A;*/border-color: #FFF;border: #FFF;outline: none;background: #F27C0A;height: 25px;"></button> -->
   
   <button style = "background: none; outline: none;  border: none;" id = "menuicon"><img src = "menu-icon.png"></button>
</div>
<button id = "vlogs" onclick = "vlogs()" class="roadinactive"  ><img src= "vlogs.png" style = "width:20px;"></button>
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


<div class="dropdown-menu-dots" id="dropdownMenu" style ="display:none;position: absolute;  background-color: #f9f9f9;  min-width: 160px;  box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);  z-index: 1;margin-top: 46%; margin-left: 24%;    margin-right: 17%;  ">
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
</div><!-- responsiveheader-container -->
<div class="search-container">
<div class="search">
<div id = "inputtypes" style ="display:flex;flex-direction:row;gap:10px;">
<form id="searchForm" style ="display: flex;flex-direction: row;justify-content: flex-end;align-items: center; gap: 10px; flex: 1;">
<input type ="text" style ="border: none;outline: none;width: 75%;" placeholder="Search" id="searchinput">
<!-- <button style ="border:none;background:none;outline:none;"><svg width="19" height="19" viewBox="0 0 19 19" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_50_3976)">
<path d="M9.05859 7.05774C8.31267 7.05774 7.5973 7.35406 7.06986 7.8815C6.54241 8.40895 6.24609 9.12432 6.24609 9.87024C6.24609 10.6162 6.54241 11.3315 7.06986 11.859C7.5973 12.3864 8.31267 12.6827 9.05859 12.6827C9.80452 12.6827 10.5199 12.3864 11.0473 11.859C11.5748 11.3315 11.8711 10.6162 11.8711 9.87024C11.8711 9.12432 11.5748 8.40895 11.0473 7.8815C10.5199 7.35406 9.80452 7.05774 9.05859 7.05774Z" fill="black"/>
<path fill-rule="evenodd" clip-rule="evenodd" d="M9.05859 1.80774C9.20778 1.80774 9.35085 1.867 9.45634 1.97249C9.56183 2.07798 9.62109 2.22105 9.62109 2.37024V3.33174C11.1615 3.46452 12.6055 4.13678 13.6988 5.23004C14.792 6.32329 15.4643 7.76736 15.5971 9.30774H16.5586C16.7078 9.30774 16.8509 9.367 16.9563 9.47249C17.0618 9.57798 17.1211 9.72106 17.1211 9.87024C17.1211 10.0194 17.0618 10.1625 16.9563 10.268C16.8509 10.3735 16.7078 10.4327 16.5586 10.4327H15.5971C15.4643 11.9731 14.792 13.4172 13.6988 14.5104C12.6055 15.6037 11.1615 16.276 9.62109 16.4087V17.3702C9.62109 17.5194 9.56183 17.6625 9.45634 17.768C9.35085 17.8735 9.20778 17.9327 9.05859 17.9327C8.90941 17.9327 8.76634 17.8735 8.66085 17.768C8.55536 17.6625 8.49609 17.5194 8.49609 17.3702V16.4087C6.95571 16.276 5.51164 15.6037 4.41839 14.5104C3.32514 13.4172 2.65288 11.9731 2.52009 10.4327H1.55859C1.40941 10.4327 1.26634 10.3735 1.16085 10.268C1.05536 10.1625 0.996094 10.0194 0.996094 9.87024C0.996094 9.72106 1.05536 9.57798 1.16085 9.47249C1.26634 9.367 1.40941 9.30774 1.55859 9.30774H2.52009C2.65288 7.76736 3.32514 6.32329 4.41839 5.23004C5.51164 4.13678 6.95571 3.46452 8.49609 3.33174V2.37024C8.49609 2.22105 8.55536 2.07798 8.66085 1.97249C8.76634 1.867 8.90941 1.80774 9.05859 1.80774ZM3.62109 9.87024C3.62109 10.5843 3.76174 11.2914 4.035 11.9511C4.30826 12.6108 4.70878 13.2102 5.2137 13.7151C5.71862 14.2201 6.31804 14.6206 6.97775 14.8938C7.63746 15.1671 8.34453 15.3077 9.05859 15.3077C9.77266 15.3077 10.4797 15.1671 11.1394 14.8938C11.7991 14.6206 12.3986 14.2201 12.9035 13.7151C13.4084 13.2102 13.8089 12.6108 14.0822 11.9511C14.3554 11.2914 14.4961 10.5843 14.4961 9.87024C14.4961 8.42812 13.9232 7.04508 12.9035 6.02535C11.8838 5.00562 10.5007 4.43274 9.05859 4.43274C7.61648 4.43274 6.23343 5.00562 5.2137 6.02535C4.19397 7.04508 3.62109 8.42812 3.62109 9.87024Z" fill="black"/>
</g>
<defs>
<clipPath id="clip0_50_3976">
<rect width="18" height="18" fill="white" transform="translate(0.0585938 0.870239)"/>
</clipPath>
</defs>
</svg></button>-->
<button style ="border:none;background:none;outline:none;">
<svg width="25" height="25" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect x="0.0585938" width="31.9414" height="31.7406" rx="15.8703" fill="#F5F5F5"/>
<path d="M18.5146 16.0774C18.5146 16.7915 18.2528 17.4763 17.7867 17.9813C17.3206 18.4862 16.6885 18.7699 16.0293 18.7699C15.3701 18.7699 14.738 18.4862 14.2719 17.9813C13.8058 17.4763 13.5439 16.7915 13.5439 16.0774V10.6925C13.5439 9.97838 13.8058 9.29354 14.2719 8.7886C14.738 8.28367 15.3701 8 16.0293 8C16.6885 8 17.3206 8.28367 17.7867 8.7886C18.2528 9.29354 18.5146 9.97838 18.5146 10.6925V16.0774Z" stroke="black" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M21 16.285C21 19.0249 18.7747 21.2466 16.0293 21.2466M16.0293 21.2466C13.2839 21.2466 11.0586 19.0249 11.0586 16.2845M16.0293 21.2466V23.7406" stroke="black" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
</button>
<button style ="border:none;background:none;outline:none;" id = "searchmagnifier" type = "submit">
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

</form>
</div><!-- inputtypes -->

</div>

<div><button style ="border:none;outline:none;background:none;" id = "searchclose"><i class="fa fa-remove"></i></button></div>

</div><!-- search-container -->

<!--modal start here -->
<div id="myModal" class="modal fullscreen-modal" role="dialog">
  <div class="modal-dialog fullscreen-modal-dialog">

    <!-- Modal content-->
    <div class="modal-content fullscreen-modal-content">
      <div class="modal-header" >
     <button style ="border: none;  outline: none;   background: #F27C0A;   border-radius: 5px;   font-size: 14px;    color: white;    padding: 4px 4px;" data-dismiss="modal">
     
     
     <!--  <svg width="12" height="24" viewBox="0 0 12 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M10 19.438L8.95502 20.5L1.28902 12.71C1.10452 12.5197 1.00134 12.2651 1.00134 12C1.00134 11.7349 1.10452 11.4803 1.28902 11.29L8.95502 3.5L10 4.563L2.68202 12L10 19.438Z" fill="black"/>
</svg> -->

Back

</button>  
        <h4 class="modal-title" style ="width: 262px;height: 17px;font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 14px;line-height: 17px;text-align: center;color: #000000;flex: none;/*order: 1;*/flex-grow: 1;">Choose Location </h4>
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
        <div class = "currentloc" style = "display: flex;flex-direction: row;justify-content: flex-start;align-items: center;padding: 0px;gap: 10px;width: 100%;/*height: 35px;*/flex: none;order: 0;flex-grow: 0;">
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

<!-- <div id="locationPopup" style="display:none; 
    position:fixed; top:0; left:0; width:100%; height:100%; 
    background:rgba(0,0,0,0.5); text-align:center; padding-top:200px;">
    <div style="background:white; padding:20px; display:inline-block; border-radius:5px;">
        <p>Permission to fetch location is disabled. Please enable it in your browser settings.</p>
        <button onclick="document.getElementById('locationPopup').style.display='none'">OK</button>
    </div>
</div>-->


<div class="modal fade" id="locationPopup" role="dialog" style ="z-index:1076; top: 58%;
   left: 50%;
   transform: translate(-50%, -50%);width:75%;   ">
    <div class="modal-dialog modal-sm">
      <div class="modal-content" style ="border-radius:10px;">
        <div class="modal-body" style ="display:flex;flex-direction:column;height:75px;border-radius:10px;">
        <div style ="display:flex;flex-direction:row;/*gap: 165px;*/justify-content: space-between;width:100%; ">
        <h4 style ="font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 12px;line-height: 22px;color: #000000;">Permission to fetch location is disabled </h4>
     <!--    <button type="button" class="close" data-dismiss="modal" id="loginModalClose">&times;</button>--></div>
        
         
        </div>
        <div class="modal-footer" style ="border-top:none;text-align:center;">
          <button onclick="document.getElementById('locationPopup').style.display='none'" style = "border-radius:10px;padding:5px;" data-dismiss="modal">OK</button>
        </div>
      </div>
    </div>
  </div>
  
  
  
  
<script type="text/javascript">

/*$('#locationPopup').on('hidden.bs.modal', function () {
    $('.modal-backdrop').remove();
    $('body').removeClass('modal-open');
});*/
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
document.getElementById("searchForm").addEventListener("submit", function(event) {
	//console.log('hit Enter: ');
	  event.preventDefault();  // Prevent form submission if not needed
	  // Get the value from the input field
	   var keywordvalue = $('#searchinput').val();var k=0;
	 //console.log('keyword value : ' +keywordvalue);
	 
//	console.log(',' + onesinglelatitude + ',' + onesinglelongitude);
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
		    	// Check if a specific class exists
		 //   	console.log('search data : ' +data);
		    	
		    	//console.log('one single : ' +','+);
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
	        	//noofresults=data.length;
	        	// $('#noofresults').html('Results: '+noofresults) ;
	        	
	        	noofresults = 0;
	        	   document.getElementById("ads").innerHTML = "";
	        	 if(gitagenabled===1 || templeenabled ===1 || forestenabled ===1 || heritageenabled ===1  ){
	      //  	console.log(gitagenabled + ','+templeenabled + ',' +forestenabled + ','+heritageenabled);
	        		  $.each(data, function (i, myList) {	 
	        		// if(myList.giTag===1 || myList.temple ===1 || myList.forest ===1 || myList.heritage ===1 )
	        		 {
	        			  let shouldRender = false;
	        			    let matchedFeature = "";

	        			    if (gitagenabled === 1 && myList.giTag === 1) {
	        			        shouldRender = true;
	        			        matchedFeature = "Gita";
	        			    } else if (templeenabled === 1 && myList.temple === 1) {
	        			        shouldRender = true;
	        			        matchedFeature = "Temple";
	        			    } else if (forestenabled === 1 && myList.forest === 1) {
	        			        shouldRender = true;
	        			        matchedFeature = "Forest";
	        			    } else if (heritageenabled === 1 && myList.heritage === 1) {
	        			        shouldRender = true;
	        			        matchedFeature = "Heritage";
	        			    }

	        			    // If none match, skip this ad
	        			    if (!shouldRender) return;
	        			 
	        			 noofresults++;
	        			 var adsid = myList.id;
	 	    	     	 var phno = myList.phoneNumber;
	 	    	     	var whatsapp = myList.whatsappNumber;
	 	    	     	// console.log('phno : ' +phno);
	 	    	     	 var email= myList.emailAddress;
	 	    	     	 var publisher_name = myList.a.title;var fullname = myList.fullName;
	 	    	    // 	 console.log('date sort: '+myList.dateRange.fromDate+'and : '+publisher_name);
	 	    	     	 var description = myList.a.description;var distance = myList.distance.toFixed(2);
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
	 	        		  }//if(myList.giTag===1 || myList.temple ===1){
	        		  });//.each
	        		 }	 //if(gitagenabled===1 || templeenabled ===1){
	        	 
	        	
	        		  else {
	        			  
	        		  		 
	     	     //   	 console.log(' not gitagenabled');
	        	  $.each(data, function (i, myList) {
	        		 
	        		//  if(myList.giTag!=1 || myList.temple!=1 ){	
	        			//calculate the distance 
	        			 // console.log('dist<= r: Before ' +myList.giTag);
	        			
	        			//console.log(myList.location.lat+','+ myList.location.lng+','+onesinglelatitude+','+onesinglelongitude);
	        			var dist=getDistanceFromLatLonInKm(myList.location.lat,myList.location.lng,onesinglelatitude,onesinglelongitude).toFixed(1);
	        			var r = document.getElementById("radius").value;
	        		//	console.log('dist: ' +dist +'r : ' +r);
	        			if(dist<= r)
	        	{			
	        		//  console.log('dist<= r: ' +myList.giTag);
	        		  
	        		  noofresults++;
	    	     	  var adsid = myList.id;
	    	     	 var phno = myList.phoneNumber;var whatsapp = myList.whatsappNumber;
	    	     	// console.log('phno : ' +phno);
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
	    	 
if ( ([
	 	        busenabled,
		        carenabled,
		        rickshawenabled,
		        goodsenabled
		    ].some(v => v === 1)) ) 
	     		 {
		 console.log('in serach show location');
	     		var ad_card='<div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
	            +'<div class="panel-heading">'
	            +'<img src="<c:url value="'+companyLogoUrl+'" />"  style="height:30px;width:30px;border-radius:50%;" alt="User profile" class="spotlightimg" loading="lazy" />'
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
	            +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" loading="lazy" style ="display: block;max-width: 100%;height: 300px;width: 100%;">'
	            +'</div>'
	            +'<div class="item">'
	            +'<img src="<c:url value="'+banner1+'" />" alt="Image" loading="lazy"  style ="display: block;max-width: 100%;height: 300px;width: 100%;">'
	            +'</div>'
	            +'<div class="item">'
	            +'<img src="<c:url value="'+banner2+'" />" alt="Image" loading="lazy" style ="display: block;max-width: 100%;height: 300px;width: 100%;">'
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
	            <!--+'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'-->
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
	     		 
	     		 }
else{
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
}
	    	     	 $('.ads').append(ad_card);    	
	        		 }//if
	    	}); //.each
	        		  }
	        	  
	        	  
	        		  $('#noofresults').html('Results: '+noofresults) ;
		    })//.then
		    
		   
		    .catch(error => {
		        console.error('Fetch error:', error); // Handling errors
		    });

 
	  // Trigger the request to the server
	 
	});
$(document).ready(function() {
	$(".search-container").hide();
	distance=1;
	
});
let map;var blueMarker; var blueMarkers = [];var currentMarker;  // Variable to keep track of the current marker
function initMap() {
    // Initialize the map and set default properties
    if(onesinglelatitude!=null){
     map = new google.maps.Map(document.getElementById('map'), {
        center: { lat: onesinglelatitude, lng: onesinglelongitude },
        zoom:12        
    });
    }
    
    
    else
    	{
    	 map = new google.maps.Map(document.getElementById('map'), {
    	        center: { lat: 13.529271965260616, lng: 75.36285138756304 },
    	        zoom:12        
    	    });
    	}
     google.maps.event.addListener(map,'click',function(event) {
         //	console.log('in listener'+event.latLng);
         	if (currentMarker){
         		currentMarker.setMap(null);}
         	 handleMapClick(event.latLng, map);
         	});
     
    // console.log('inside init Map ');
     
     
     geocoder = new google.maps.Geocoder();
     
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
	 $("#searchinput").val("");
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
        		
        		 }
        	 if (time===1)
        		 {
        		 
        		    let dateTimeArray = data;
        			let dateTimeArraySorted=dateTimeArray.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
        			data = dateTimeArraySorted;
        			
        		 }
        	    currentAdsData=data;
        	   
        	       document.getElementById("ads").innerHTML = "";
        	   	   noofresults=data.length;
        		   $('#noofresults').html('Results: '+noofresults) ;

        	    $.each(data, function (i, myList) {
        	    	
        	    	     var adsid = myList.id;
        		     	 var phno = myList.phoneNumber;var whatsapp = myList.whatsappNumber;
        		     
        		     	 var email= myList.emailAddress;
        	    	 var publisher_name = myList.a.title;
        	   
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
        	 	 
        	 	 
        	 	if ( ([
    	 	        busenabled,
    		        carenabled,
    		        rickshawenabled,
    		        goodsenabled
    		    ].some(v => v === 1)) ) 
    	     		 {
    	//	 console.log('in serach show location');
    	     		var ad_card='<div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
    	            +'<div class="panel-heading">'
    	            +'<img src="<c:url value="'+companyLogoUrl+'" />"  style="height:30px;width:30px;border-radius:50%;" alt="User profile" class="spotlightimg" loading="lazy" />'
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
    	            +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" loading="lazy" style ="display: block;max-width: 100%;height: 300px;width: 100%;">'
    	            +'</div>'
    	            +'<div class="item">'
    	            +'<img src="<c:url value="'+banner1+'" />" alt="Image" loading="lazy"  style ="display: block;max-width: 100%;height: 300px;width: 100%;">'
    	            +'</div>'
    	            +'<div class="item">'
    	            +'<img src="<c:url value="'+banner2+'" />" alt="Image" loading="lazy" style ="display: block;max-width: 100%;height: 300px;width: 100%;">'
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
    	            <!--+'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'-->
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
    	     		 
    	     		 }
        	 	else{
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
        	   <!--     +'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'-->
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
        	//  console.log('ad_card: '+ad_card);
        	       var  latt = 13.529271965260616;
        	    var lngg = 75.36285138756304; 
        	  
        	    const lattt =  myList.location.lat; const longgg= myList.location.lng ;
        	/*	const marker = new google.maps.Marker({
        	    //   position: new google.maps.LatLng(myList.location.lat,myList.location.lng),
        	    //  position: new google.maps.LatLng(locations[j][0], locations[j][1]),
        	   // position:{ lat: JSON.parse(locations[j][0]), lng:JSON.parse(locations[j][1] )},
        	   
        	 //  position:{ lat: parseFloat(locations[j][0]), lng:parseFloat(locations[j][1] )},
        	//  position:{ lat:lattt, lng:longgg},
        	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
        	        map: map3,
        	        icon:png
        	      });
        	markers.push(marker);	*/
        	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}
        	/*	marker.addListener('click', function() {
        	console.log('marker clicked');
        	setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
        	});*/
        	       	  }); //.each


         
     });
	 
});

//on lcick of search orange icon end here 
//to show the address start here
var currentlatforblue;var currentlngforblue;

function getCurrentLocation() {
    //	console.log('in get current location');   
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                function(position) {
                //	console.log('to fetch lat lng');
                  /*  const lat = position.coords.latitude;
                    const lng = position.coords.longitude;*/
                //    console.log('what for this is'); 
                    if((latitudefromsession ==null && longitudefromsession==null) || finallistofads){
                    	const lat = position.coords.latitude;
                        const lng = position.coords.longitude;
                        //displayCurrentLocation(lat, lng);
                        currentlatforblue=lat;currentlatforblue=lng;//not neessary                      
                        document.getElementById("currentlocationbutton").disabled = false;
      	          	  document.getElementById("pinlocationbutton").disabled = true;
                    }
                    else
                    	{
                    const lat = latitudefromsession;
                    const lng = longitudefromsession;
               //     displayCurrentLocation(lat, lng);
                document.getElementById("currentlocationbutton").style.background=" #F27C0A";
                        document.getElementById("pinlocationbutton").style.background="  none";
                    currentlatforblue=lat;currentlatforblue=lng;//not neessarys
                    	}
                    
                //  	console.log('to fetch lat lng'+lat +'and: ' +lng);
                   
                },
                function(error) {
                    console.error('Error getting location:', error);
                    //document.getElementById('location').innerText = 'Error getting location.';
                    var defaultLocation = { coords: { latitude: 13.529271965260616,  longitude: 75.36285138756304 } };
                 	 const lat = defaultLocation.coords.latitude;
                    const lng = defaultLocation.coords.longitude;
                   // displayCurrentLocation(lat, lng);
                    document.getElementById("currentlocationbutton").disabled = true;
  	          	  document.getElementById("pinlocationbutton").disabled = true;
                }
            );
        } else {
        	
        }
    }
function displayCurrentLocation(lat, lng) {
	console.log('display curent Location : ' +lat +'and : ' +lng);
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
              /* currentMarker = new google.maps.Marker({
                   position: location,
                   map: map,
                  title: address
               });*/
              // console.log('in currrent mark' +currentMarker);
            } else {
            //    document.getElementById('location').innerText = 'Unable to reverse geocode location.';
            }
        
        })//.then
        .catch(error => {
            console.error('Error with reverse geocoding:', error);
            //document.getElementById('location').innerText = 'Error with reverse geocoding.';
        });
}
//window.onload = getCurrentLocation;
//getCurrentLocation();
// to show the address end here

//current location start here 
let watchID; var onesinglelatitude;var onesinglelongitude;

//moving blue marker start here 
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
   	 
   	 currentdistanceglobal=dist;
   	currentlocationglobal++;
 //   console.log('Every 30 sec: '); //$('#itr').html('CItr: '+currentlocationglobal) ;
  //   $('#dis').html('dist: '+currentdistanceglobal) ;
   //  $('#current').html('current '+lat.toFixed(4) +'and : ' +lng.toFixed(4)) ;
   //  $('#last').html('last '+lastlat.toFixed(4) +'and : ' +lastlng.toFixed(4)) ;
     //displayCurrentLocation(lat, lng);
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
 //moving blue marker end here 
 var currentlocationglobal=0;var currentdistanceglobal=0;
 function getCurrentLocations(){
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
                	//watchID = navigator.geolocation.watchPosition(updateMarkerPosition, showError, { enableHighAccuracy: true, timeout: 30000, maximumAge: 10000,  distanceFilter: 10 });
              //  	watchID = navigator.geolocation.watchPosition(updateMarkerPosition, showError, { enableHighAccuracy: true, timeout: 30000, maximumAge: 10000,  distanceFilter: 10 });
              currentLocation(position);
              
             // $('#itr').html('CItr: '+currentlocationglobal) ;
              
                },
                function(error) {
                    console.error('Error getting location by :', error);
                   // document.getElementById('location').innerText = 'Error getting location.';
                   
                    $('#locationPopup').modal('show');
                }
            );
        } else {
           // document.getElementById('location').innerText = 'Geolocation is not supported by this browser.';
        	$('#locationPopup').modal('show');
        }
    	 // console.log('lat and lng : '+ lat +lng);
    }
    function currentLocation(position){
    //	console.log('current location got successfully from watch');
    	currentLocationset=true;//declared in index
    	locationset++;//declared in index
  
    	 var lat = position.coords.latitude;
    	 var lng = position.coords.longitude;
      //   displayCurrentLocation(lat, lng);
       document.getElementById("currentlocationbutton").disabled = false;
	          	  document.getElementById("pinlocationbutton").disabled = true;
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
        	
        	        	
        	// Check if a specific class exists
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
           // console.log(x);
            document.getElementById("ads").innerHTML = "";
        	//noofresults=data.length;
        	noofresults=0;
    
    
            $.each(data, function (i, myList) {
  	     	 var adsid = myList.id;
	     	 var phno = myList.phoneNumber;var whatsapp = myList.whatsappNumber;
	     	// console.log('phno : ' +phno);
	     	 var email= myList.emailAddress;
   	     	 var publisher_name = myList.a.title;   	   
   	     	 var description = myList.a.description;var fullname = myList.fullName;var distance = myList.distance.toFixed(2);
   	     	 var dates = myList.dateRange.toDate;
   	     	const date = new Date(dates);
   	    	var companyName='';
   	    	var latitudes=myList.location.lat;
	    	var longitudes = myList.location.lng;
   	    	var companyLogoUrl = myList.companies.companyLogoPath;
	    	var thumbnail = myList.a.thumbnail;
	    	var createdBy = myList.createdBy;
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
	     	 var carouselid= 'myCarouselhome'+k;
	     	 
	     	 if ( [
	 	        busenabled,
		        carenabled,
		        rickshawenabled,
		        roadenabled
		    ].some(v => v === 1) ) 
	     		 {
	     		var ad_card='<div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
	            +'<div class="panel-heading">'
	            +'<img src="<c:url value="'+companyLogoUrl+'" />"  style="height:30px;width:30px;border-radius:50%;" alt="User profile" class="spotlightimg" loading="lazy" />'
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
	            +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" loading="lazy" style ="display: block;max-width: 100%;height: 300px;width: 100%;">'
	            +'</div>'
	            +'<div class="item">'
	            +'<img src="<c:url value="'+banner1+'" />" alt="Image" loading="lazy"  style ="display: block;max-width: 100%;height: 300px;width: 100%;">'
	            +'</div>'
	            +'<div class="item">'
	            +'<img src="<c:url value="'+banner2+'" />" alt="Image" loading="lazy" style ="display: block;max-width: 100%;height: 300px;width: 100%;">'
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
	            <!--+'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'-->
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
	     		 
	     		 }
	     	 else
	     		 {
	     	var ad_card='<div class="panel panel-default" role="button" id = '+adsid+' onclick=nextui(this,\'' + createdBy + '\');>'
	            +'<div class="panel-heading">'
	            +'<img src="<c:url value="'+companyLogoUrl+'" />"  style="height:30px;width:30px;border-radius:50%;" alt="User profile" class="spotlightimg" loading="lazy" />'
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
	            +'<img src="<c:url value="'+thumbnail+'"/>" alt="Image" loading="lazy" style ="display: block;max-width: 100%;height: 300px;width: 100%;">'
	            +'</div>'
	            +'<div class="item">'
	            +'<img src="<c:url value="'+banner1+'" />" alt="Image" loading="lazy"  style ="display: block;max-width: 100%;height: 300px;width: 100%;">'
	            +'</div>'
	            +'<div class="item">'
	            +'<img src="<c:url value="'+banner2+'" />" alt="Image" loading="lazy" style ="display: block;max-width: 100%;height: 300px;width: 100%;">'
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
	            
	     		 }
		     	 $('.ads').append(ad_card);
	            noofresults++;
   	 //  console.log('ad_card: '+ad_card);
   	     var  latt = 13.529271965260616;
	        var lngg = 75.36285138756304; 
	      
	        const lattt =  myList.location.lat; const longgg= myList.location.lng ;
    	/*	const marker = new google.maps.Marker({
    	    //   position: new google.maps.LatLng(myList.location.lat,myList.location.lng),
    	    //  position: new google.maps.LatLng(locations[j][0], locations[j][1]),
    	   // position:{ lat: JSON.parse(locations[j][0]), lng:JSON.parse(locations[j][1] )},
    	   
    	 //  position:{ lat: parseFloat(locations[j][0]), lng:parseFloat(locations[j][1] )},
    	//  position:{ lat:lattt, lng:longgg},
    	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
    	        map: map3,
    	        icon:png
    	      });
 markers.push(marker);*/	
 var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}
/*	marker.addListener('click', function() {
		console.log('marker clicked');
		setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
		});*/
   	results++;
   	 
  	     
   	        	  }); //.each
   	        	  
  
    
    
    $('#noofresults').html('Results: '+noofresults) ;
        }//success
    	});//ajax
    	
        }
// current location end here

//pin location start here
$( "#setlocation" ).on( "click", function() {
    	  //alert( "Handler for `click` called." ); 
    	 
    	currentLocationset=false;currentLocationsetfromsess= false;
    	  var lat =currentMarker.getPosition().lat();
    	  var lng = currentMarker.getPosition().lng();
    	  onesinglelatitude =lat;
          onesinglelongitude = lng;
    	  var k = 0;
     //     displayCurrentLocation(lat, lng);
     document.getElementById("currentlocationbutton").disabled = true;
	          	  document.getElementById("pinlocationbutton").disabled = false;
   
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
        	// Check if a specific class exists
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
           // console.log(x);
               document.getElementById("ads").innerHTML = "";
          // 	noofresults=data.length;
           	
           	noofresults=0;
      // 	 $('#noofresults').html('Results: '+noofresults) ;
     
     /*  	 if(gitagenabled===1 || templeenabled ===1){
       	 $.each(data, function (i, myList) {
    	   if(myList.giTag===1 || myList.temple ===1){
    		   
    		     var adsid = myList.id;
    	     	 var phno = myList.phoneNumber;    	     
    	     	 var email= myList.emailAddress;
    	     	 var publisher_name = myList.a.title;
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
    noofresults++;
    			  
    		  }
    	   
    	   });//.each
    	   
        	 
           	 }
       	 else{
       		 
 
       	$.each(data, function (i, myList) {
     	   if(myList.giTag===1 || myList.temple ===1){
     		   
     		   var adsid = myList.id;
     	     	 var phno = myList.phoneNumber;
     	     	
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
     	    	var banner2 = "nopreview.jpg";
     	    	var createdBy = myList.createdBy;
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
     		
     	     // Create a formatter with custom options
     	     const formatter = new Intl.DateTimeFormat('en-GB', {
     	         day: 'numeric',
     	         month: 'long',
     	         year: 'numeric'
     	     });

     	     const formattedDate = formatter.format(date);
     	    	 var img_path = "";
     	     	 k++;
     	     	 var carouselid= 'myCarouselhome'+k;
     	     	      	 

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
     noofresults++; 
     			  
     		  }
     	   
     	   });*/
       	 
            	

            $.each(data, function (i, myList) {
            
            	  var adsid = myList.id;
     	     	 var phno = myList.phoneNumber;
     	     	var whatsapp = myList.whatsappNumber;
     	     	 var email= myList.emailAddress;
   	     	 var publisher_name = myList.a.title;
   	   
   	     	 var description = myList.a.description; var fullname = myList.fullName; var distance = myList.distance.toFixed(2);
   	     	 var dates = myList.dateRange.toDate;
   	     	const date = new Date(dates);
   	    	var companyName='';
   	    	var latitudes=myList.location.lat;
	    	var longitudes = myList.location.lng;
   	    	var companyLogoUrl = myList.companies.companyLogoPath;
	    	var thumbnail = myList.a.thumbnail;
	    
	    	var banner1="nopreview.jpg";
	    	var banner2 = "nopreview.jpg";	var createdBy = myList.createdBy;
	    	var whatsapp = myList.whatsappNumber;
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
	    	 
	            noofresults++;
   
   	        var  latt = 13.529271965260616;
	        var lngg = 75.36285138756304; 
	      
	        const lattt =  myList.location.lat; const longgg= myList.location.lng ;
    	/*	const marker = new google.maps.Marker({
    	    //   position: new google.maps.LatLng(myList.location.lat,myList.location.lng),
    	    //  position: new google.maps.LatLng(locations[j][0], locations[j][1]),
    	   // position:{ lat: JSON.parse(locations[j][0]), lng:JSON.parse(locations[j][1] )},
    	   
    	 //  position:{ lat: parseFloat(locations[j][0]), lng:parseFloat(locations[j][1] )},
    	//  position:{ lat:lattt, lng:longgg},
    	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
    	        map: map3,
    	        icon:png
    	      });
 markers.push(marker);	*/
 var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}
/*	marker.addListener('click', function() {
		console.log('marker clicked');
		setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
		});*/
		
         //   	}
   	        	  }); //.each
   	       	  
       	// }//else
       		 
       		 
       	$('#noofresults').html('Results: '+noofresults) ;    	 
        }//success
    });//ajax
});
//pin location end here

 //to search start here
 /*
 $('#searchmagnifier').click(function()
{		 
	 var keywordvalue = $('#searchinput').val();var k=0;
	 console.log('keyword value : ' +keywordvalue);
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
		    	// Check if a specific class exists
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
	        	noofresults=data.length;
	        	 $('#noofresults').html('Results: '+noofresults) ;
	        	   document.getElementById("ads").innerHTML = "";
	        	   
	        	   if(gitagenabled===1){
	                 	 $.each(data, function (i, myList) {
	          	   if(myList.giTag===1){
	          		   
	          		   var adsid = myList.id;
	          	     	 var phno = myList.phoneNumber;
	          	     	// console.log('phno : ' +phno);
	          	     	 var email= myList.emailAddress;
	          	     	 var publisher_name = myList.a.title;
	          	    // 	 console.log('date sort: '+myList.dateRange.fromDate+'and : '+publisher_name);
	          	     	 var description = myList.a.description;var fullname = myList.fullName;
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
	          			  
	          		  }
	          	   
	          	   });	                 	 
	                 	 }
	        	   
	        	   else {
	        		   
	        	   
	        	  $.each(data, function (i, myList) {
	        		  if(myList.giTag===1){
	    	     	  var adsid = myList.id;
	    	     	 var phno = myList.phoneNumber;
	    	     	// console.log('phno : ' +phno);
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
	        		  }
   
	    	}); //.each

	    	
	        	  $.each(data, function (i, myList) {
	        		  if(myList.giTag!=1){
	    	     	  var adsid = myList.id;
	    	     	 var phno = myList.phoneNumber;
	    	     	// console.log('phno : ' +phno);
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
	        		  }
   
	    	}); //.each
	        	  
	    	
	    	
	        	   }//else
	          
		    })
		    .catch(error => {
		        console.error('Fetch error:', error); // Handling errors
		    });

 
 
});
 */
//search end here

//tracking continuous location start here
 const roadbutton = document.getElementById("road");
document.getElementById("road").addEventListener("click", function() {
//	console.log('road clicked');
            // Toggle the 'clicked' class on button click
          //  this.classList.toggle("roadactive");
      gitagenabled=0;templeenabled =0;forestenabled=0;heritageenabled =0;hospitalenabled =0;newsenabled=0;vlogsenabledd=0;goodsenabled=0;	busenabled=0;carenabled=0; rickshawenabled=0;roadenabled =1;
            if (roadbutton.classList.contains("roadactive")) {       //when clicked
                // If 'active' class is already present, remove it
                roadbutton.classList.remove("roadactive");
                roadbutton.classList.add("roadinactive");
                
                if (watchID !== undefined) {
                    navigator.geolocation.clearWatch(watchID); 
                }                
     //           console.log('watch Id : ' +watchID);
       roadenabled =0;
                document.getElementById("currentlocationbutton").disabled =false;
          	  document.getElementById("pinlocationbutton").disabled = true;
                
            } else {
                // If 'active' class is not present, add it
                  roadenabled =1;
                roadbutton.classList.remove("roadinactive");
                roadbutton.classList.add("roadactive");  
                document.getElementById("currentlocationbutton").disabled = false;
          	  document.getElementById("pinlocationbutton").disabled = true;
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
                        //    document.getElementById('location').innerText = 'Error getting location.';
                        }
                    );
                } else {
                  //  document.getElementById('location').innerText = 'Geolocation is not supported by this browser.';
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

var gitagenabled=0;var roadenabled =0;
function giads()
{
	gitagenabled=1;templeenabled =0;forestenabled=0;heritageenabled =0;hospitalenabled =0;newsenabled=0;vlogsenabledd=0;goodsenabled=0;	busenabled=0;carenabled=0; rickshawenabled=0;roadenabled =0;
		
		
	//console.log('giads');
	var k=0;
	const requestId = generateRequestId();
	latestRequestId = requestId;
	 if (watchID !== undefined) {
         navigator.geolocation.clearWatch(watchID); 
     }
/*	gitagbutton.classList.remove("giinactive");
	gitagbutton.classList.add("giactive");*/
	
	 if (gitagbutton.classList.contains("roadactive")) {       //when clicked to remove
         gitagbutton.classList.remove("roadactive");
         gitagbutton.classList.add("roadinactive");  
         
         
         document.getElementById("filter-container").style.display = "flex";
        
         gitagenabled=0;
         
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
            		
            		 }
            	 if (time===1)
            		 {
            		 
            		    let dateTimeArray = data;
            			let dateTimeArraySorted=dateTimeArray.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
            			data = dateTimeArraySorted;
            			
            		 }
            	    currentAdsData=data;
            	   
            	       document.getElementById("ads").innerHTML = "";
            	   	   noofresults=data.length;
            		   $('#noofresults').html('Results: '+noofresults) ;

            	    $.each(data, function (i, myList) {
            	    	
            	    	     var adsid = myList.id;
            		     	 var phno = myList.phoneNumber;
            		     	var whatsapp = myList.whatsappNumber;
            		     	 var email= myList.emailAddress;
            	    	 var publisher_name = myList.a.title;
            	   
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
            	//  console.log('ad_card: '+ad_card);
            	       var  latt = 13.529271965260616;
            	    var lngg = 75.36285138756304; 
            	  
            	    const lattt =  myList.location.lat; const longgg= myList.location.lng ;
            	/*	const marker = new google.maps.Marker({
            	    //   position: new google.maps.LatLng(myList.location.lat,myList.location.lng),
            	    //  position: new google.maps.LatLng(locations[j][0], locations[j][1]),
            	   // position:{ lat: JSON.parse(locations[j][0]), lng:JSON.parse(locations[j][1] )},
            	   
            	 //  position:{ lat: parseFloat(locations[j][0]), lng:parseFloat(locations[j][1] )},
            	//  position:{ lat:lattt, lng:longgg},
            	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
            	        map: map3,
            	        icon:png
            	      });
            	markers.push(marker);	*/
            	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}
            	/*	marker.addListener('click', function() {
            	console.log('marker clicked');
            	setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
            	});*/
            	       	  }); //.each


             
         });
     } //if else 
	
	 else{
		 gitagbutton.classList.remove("roadinactive");
         gitagbutton.classList.add("roadactive");   
         
         document.getElementById("filter-container").style.display = "none";
         if (roadbutton.classList.contains("roadactive")) {       //when clicked
             // If 'active' class is already present, remove it
             roadbutton.classList.remove("roadactive");
             roadbutton.classList.add("roadinactive");
             
             if (watchID !== undefined) {
                 navigator.geolocation.clearWatch(watchID); 
             }                
  //           
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
         
         //for heritage, hostpital, bus, car, goods, rickashaw
	$.ajax({
        // Our sample url to make request 
        url:"${pageContext.request.contextPath}/giads?requestId=" + requestId,
        type: "GET",
        contentType : 'application/json',
        dataType : 'json',
        //data:JSON.stringify({lat,lng}), 
        success: function (data) {
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
   // console.log(x);
       document.getElementById("ads").innerHTML = "";
   	noofresults=data.length;
	 $('#noofresults').html('Results: '+noofresults) ;

    $.each(data, function (i, myList) {
    	
    	     var adsid = myList.id;
	     	 var phno = myList.phoneNumber;
	     	// console.log('phno : ' +phno);
	     	 var email= myList.emailAddress;
    	 var publisher_name = myList.a.title;
   // 	 console.log(publisher_name);
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
//  console.log('ad_card: '+ad_card);
    var  latt = 13.529271965260616;    var lngg = 75.36285138756304; 
  
    const lattt =  myList.location.lat; const longgg= myList.location.lng ;
/*	const marker = new google.maps.Marker({
    //   position: new google.maps.LatLng(myList.location.lat,myList.location.lng),
    //  position: new google.maps.LatLng(locations[j][0], locations[j][1]),
   // position:{ lat: JSON.parse(locations[j][0]), lng:JSON.parse(locations[j][1] )},
   
 //  position:{ lat: parseFloat(locations[j][0]), lng:parseFloat(locations[j][1] )},
//  position:{ lat:lattt, lng:longgg},
position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
        map: map3,
        icon:png
      });
markers.push(marker);	*/
var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}
/*	marker.addListener('click', function() {
console.log('marker clicked');
setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
});*/
       	  }); //.each

        }//success
	
})//ajax

	 }
}


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
	
	//modaldismissbutton
	
/*	$('#addetailModal').on('hidden.bs.modal', function () {
	/*    var video = document.getElementById('videoPlayer');
	  var  player = new YT.Player('videoframe');
	    video.pause();
	    video.currentTime = 0; */// Optional: Reset to the beginning
	  //  console.log('TO PAUSE : ');
	    //pauseVideo();
	    
	  //   var iframe = document.getElementById('videoframe');
   /* if (iframe && iframe.contentWindow) {
      iframe.contentWindow.postMessage('{"event":"command","func":"pauseVideo","args":""}', '*');
    }*/
	 // });*/
	var templeenabled = 0;
function templeads()
{
	gitagenabled=0;templeenabled =1;forestenabled=0;heritageenabled =0;hospitalenabled =0;newsenabled=0;vlogsenabledd=0;goodsenabled=0;	busenabled=0;carenabled=0; rickshawenabled=0;roadenabled =0;
	const requestId = generateRequestId();
	latestRequestId = requestId;
	var k=0;
	  if (watchID !== undefined) {
          navigator.geolocation.clearWatch(watchID); 
      }
	 if (templebutton.classList.contains("roadactive")) {       //when clicked to remove
         templebutton.classList.remove("roadactive");
         templebutton.classList.add("roadinactive");  
         
         document.getElementById("filter-container").style.display = "flex";
       
         templeenabled=0;
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
            		
            		 }
            	 if (time===1)
            		 {
            		 
            		    let dateTimeArray = data;
            			let dateTimeArraySorted=dateTimeArray.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
            			data = dateTimeArraySorted;
            			
            		 }
            	    currentAdsData=data;
            	   
            	       document.getElementById("ads").innerHTML = "";
            	   	   noofresults=data.length;
            		   $('#noofresults').html('Results: '+noofresults) ;

            	    $.each(data, function (i, myList) {
            	    	
            	    	     var adsid = myList.id;
            		     	 var phno = myList.phoneNumber;var whatsapp = myList.whatsappNumber;
            		     
            		     	 var email= myList.emailAddress;
            	    	 var publisher_name = myList.a.title;
            	   
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
            	//  console.log('ad_card: '+ad_card);
            	       var  latt = 13.529271965260616;
            	    var lngg = 75.36285138756304; 
            	  
            	    const lattt =  myList.location.lat; const longgg= myList.location.lng ;
            	/*	const marker = new google.maps.Marker({
            	    //   position: new google.maps.LatLng(myList.location.lat,myList.location.lng),
            	    //  position: new google.maps.LatLng(locations[j][0], locations[j][1]),
            	   // position:{ lat: JSON.parse(locations[j][0]), lng:JSON.parse(locations[j][1] )},
            	   
            	 //  position:{ lat: parseFloat(locations[j][0]), lng:parseFloat(locations[j][1] )},
            	//  position:{ lat:lattt, lng:longgg},
            	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
            	        map: map3,
            	        icon:png
            	      });
            	markers.push(marker);	*/
            	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}
            	/*	marker.addListener('click', function() {
            	console.log('marker clicked');
            	setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
            	});*/
            	       	  }); //.each


             
         });
     } 
	
	 else{
		 templebutton.classList.remove("roadinactive");
	     templebutton.classList.add("roadactive");  	 
	
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
//	 console.log('distance =1' );
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
   // console.log(x);
       document.getElementById("ads").innerHTML = "";
   	noofresults=data.length;
	 $('#noofresults').html('Results: '+noofresults) ;

	 
	 
    $.each(data, function (i, myList) {
    	
    	     var adsid = myList.id;
	     	 var phno = myList.phoneNumber;var whatsapp = myList.whatsappNumber;
	     	// console.log('phno : ' +phno);
	     	 var email= myList.emailAddress;
    	 var publisher_name = myList.a.title;
   // 	 console.log(publisher_name);
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

       var  latt = 13.529271965260616;    var lngg = 75.36285138756304; 
  
    const lattt =  myList.location.lat; const longgg= myList.location.lng ;

var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}

       	  }); //.each

        }//success
	
})//ajax
	 }
	 }

var forestenabled=0;
function forestads()
{
	gitagenabled=0;templeenabled =0;forestenabled=1;heritageenabled =0;hospitalenabled =0;newsenabled=0;vlogsenabledd=0;goodsenabled=0;	busenabled=0;carenabled=0; rickshawenabled=0;roadenabled =0;
	
	var k=0;
	const requestId = generateRequestId();
	latestRequestId = requestId;
	if (watchID !== undefined) {
        navigator.geolocation.clearWatch(watchID); 
    }
	 if (forestbutton.classList.contains("roadactive")) {       //when clicked to remove
		 forestbutton.classList.remove("roadactive");
		 forestbutton.classList.add("roadinactive");  
		 
		  document.getElementById("filter-container").style.display = "flex";
         
         
         forestenabled=0;
         
         
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
            		
            		 }
            	 if (time===1)
            		 {
            		 
            		    let dateTimeArray = data;
            			let dateTimeArraySorted=dateTimeArray.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
            			data = dateTimeArraySorted;
            			
            		 }
            	    currentAdsData=data;
            	   
            	       document.getElementById("ads").innerHTML = "";
            	   	   noofresults=data.length;
            		   $('#noofresults').html('Results: '+noofresults) ;

            	    $.each(data, function (i, myList) {
            	    	
            	    	     var adsid = myList.id;
            		     	 var phno = myList.phoneNumber;
            		     	var whatsapp = myList.whatsappNumber;
            		     	 var email= myList.emailAddress;
            	    	 var publisher_name = myList.a.title;
            	   
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
            	//  console.log('ad_card: '+ad_card);
            	       var  latt = 13.529271965260616;
            	    var lngg = 75.36285138756304; 
            	  
            	    const lattt =  myList.location.lat; const longgg= myList.location.lng ;
            	/*	const marker = new google.maps.Marker({
            	    //   position: new google.maps.LatLng(myList.location.lat,myList.location.lng),
            	    //  position: new google.maps.LatLng(locations[j][0], locations[j][1]),
            	   // position:{ lat: JSON.parse(locations[j][0]), lng:JSON.parse(locations[j][1] )},
            	   
            	 //  position:{ lat: parseFloat(locations[j][0]), lng:parseFloat(locations[j][1] )},
            	//  position:{ lat:lattt, lng:longgg},
            	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
            	        map: map3,
            	        icon:png
            	      });
            	markers.push(marker);	*/
            	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}
            	/*	marker.addListener('click', function() {
            	console.log('marker clicked');
            	setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
            	});*/
            	       	  }); //.each             
         });

     } 
	
	 else{
		 forestbutton.classList.remove("roadinactive");
		 forestbutton.classList.add("roadactive");  	 
	
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
//	 console.log('distance =1' );
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
   // console.log(x);
       document.getElementById("ads").innerHTML = "";
   	noofresults=data.length;
	 $('#noofresults').html('Results: '+noofresults) ;

	 
	 
    $.each(data, function (i, myList) {
    	
    	     var adsid = myList.id;
	     	 var phno = myList.phoneNumber;var whatsapp = myList.whatsappNumber;
	     	// console.log('phno : ' +phno);
	     	 var email= myList.emailAddress;
    	 var publisher_name = myList.a.title;
   // 	 console.log(publisher_name);
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

       var  latt = 13.529271965260616;    var lngg = 75.36285138756304; 
  
    const lattt =  myList.location.lat; const longgg= myList.location.lng ;

var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}

       	  }); //.each

        }//success
	
})//ajax
	 }
	 }


var heritageenabled = 0;
function heritageads()
{
	gitagenabled=0;templeenabled =0;forestenabled=0;heritageenabled =1;hospitalenabled =0;newsenabled=0;vlogsenabledd=0;goodsenabled=0;	busenabled=0;carenabled=0; rickshawenabled=0;roadenabled =0;
	
	var k=0;
	
	const requestId = generateRequestId();
	latestRequestId = requestId;
	  if (watchID !== undefined) {
          navigator.geolocation.clearWatch(watchID); 
      }
	 if (heritagebutton.classList.contains("roadactive")) {       //when clicked to remove
		 heritagebutton.classList.remove("roadactive");
		 heritagebutton.classList.add("roadinactive");  
		 
		  document.getElementById("filter-container").style.display = "flex";
         
       
         heritageenabled=0;
         
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
            		
            		 }
            	 if (time===1)
            		 {
            		 
            		    let dateTimeArray = data;
            			let dateTimeArraySorted=dateTimeArray.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
            			data = dateTimeArraySorted;
            			
            		 }
            	    currentAdsData=data;
            	   
            	       document.getElementById("ads").innerHTML = "";
            	   	   noofresults=data.length;
            		   $('#noofresults').html('Results: '+noofresults) ;

            	    $.each(data, function (i, myList) {
            	    	
            	    	     var adsid = myList.id;
            		     	 var phno = myList.phoneNumber;
            		     	var whatsapp = myList.whatsappNumber;
            		     	 var email= myList.emailAddress;
            	    	 var publisher_name = myList.a.title;
            	   
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
            
            	       var  latt = 13.529271965260616;    var lngg = 75.36285138756304; 
            	  
            	    const lattt =  myList.location.lat; const longgg= myList.location.lng ;
            	
            	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}
            
            	       	  }); //.each

         });

     } 
	
	 else{
		 heritagebutton.classList.remove("roadinactive");
		 heritagebutton.classList.add("roadactive");  	 
	
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
//	 console.log('distance =1' );
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
   // console.log(x);
       document.getElementById("ads").innerHTML = "";
   	noofresults=data.length;
	 $('#noofresults').html('Results: '+noofresults) ;

	 
	 
    $.each(data, function (i, myList) {
    	
    	     var adsid = myList.id;
	     	 var phno = myList.phoneNumber;var whatsapp = myList.whatsappNumber;
	     	// console.log('phno : ' +phno);
	     	 var email= myList.emailAddress;
    	 var publisher_name = myList.a.title;
   // 	 console.log(publisher_name);
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

       var  latt = 13.529271965260616;    var lngg = 75.36285138756304; 
  
    const lattt =  myList.location.lat; const longgg= myList.location.lng ;

var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}

       	  }); //.each

        }//success
	
})//ajax
	 }
	 }
	 
	 
	 //hospital
	 
	 var hospitalenabled = 0;
function hospitalads()
{
	gitagenabled=0;templeenabled =0;forestenabled=0;heritageenabled =0;hospitalenabled =1;newsenabled=0;vlogsenabledd=0;goodsenabled=0;	busenabled=0;carenabled=0; rickshawenabled=0;roadenabled =0;
	
	var k=0;
	
	const requestId = generateRequestId();
	latestRequestId = requestId;
	  if (watchID !== undefined) {
          navigator.geolocation.clearWatch(watchID); 
      }
	 if (hospitalbutton.classList.contains("roadactive")) {       //when clicked to remove
		 hospitalbutton.classList.remove("roadactive");
		 hospitalbutton.classList.add("roadinactive");  
         
		 
		  document.getElementById("filter-container").style.display = "flex";
        
         hospitalenabled=0;
         
         
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
            		
            		 }
            	 if (time===1)
            		 {
            		 
            		    let dateTimeArray = data;
            			let dateTimeArraySorted=dateTimeArray.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
            			data = dateTimeArraySorted;
            			
            		 }
            	    currentAdsData=data;
            	   
            	       document.getElementById("ads").innerHTML = "";
            	   	   noofresults=data.length;
            		   $('#noofresults').html('Results: '+noofresults) ;

            	    $.each(data, function (i, myList) {
            	    	
            	    	     var adsid = myList.id;
            		     	 var phno = myList.phoneNumber;
            		     	var whatsapp = myList.whatsappNumber;
            		     	 var email= myList.emailAddress;
            	    	 var publisher_name = myList.a.title;
            	   
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
            
            	       var  latt = 13.529271965260616;    var lngg = 75.36285138756304; 
            	  
            	    const lattt =  myList.location.lat; const longgg= myList.location.lng ;
            	
            	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}
            
            	       	  }); //.each


             
         });

     } 
	
	 else{
		 hospitalbutton.classList.remove("roadinactive");
		 hospitalbutton.classList.add("roadactive");  	 
	
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
//	 console.log('distance =1' );
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
   // console.log(x);
       document.getElementById("ads").innerHTML = "";
   	noofresults=data.length;
	 $('#noofresults').html('Results: '+noofresults) ;

	 
	 
    $.each(data, function (i, myList) {
    	
    	     var adsid = myList.id;
	     	 var phno = myList.phoneNumber;var whatsapp = myList.whatsappNumber;
	     	// console.log('phno : ' +phno);
	     	 var email= myList.emailAddress;
    	 var publisher_name = myList.a.title;
   // 	 console.log(publisher_name);
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

       var  latt = 13.529271965260616;    var lngg = 75.36285138756304; 
  
    const lattt =  myList.location.lat; const longgg= myList.location.lng ;

var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}

       	  }); //.each

        }//success
	
})//ajax
	 }
	 }
	 
	 
	 //hospital ends

	 
//bus start	 
	 
	  var busenabled = 0;
function busads()
{
	gitagenabled=0;templeenabled =0;forestenabled=0;heritageenabled =0;hospitalenabled =0;newsenabled=0;vlogsenabledd=0;goodsenabled=0;	busenabled=1;carenabled=0; rickshawenabled=0;roadenabled =0;
	
	var k=0;
	  if (watchID !== undefined) {
          navigator.geolocation.clearWatch(watchID); 
      }
	  
	  const requestId = generateRequestId();
	  latestRequestId = requestId;
	 if (busbutton.classList.contains("roadactive")) {       //when clicked to remove
		 busbutton.classList.remove("roadactive");
		busbutton.classList.add("roadinactive");  
		
		  document.getElementById("filter-container").style.display = "flex";
         
       
         busenabled=0;
         
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
            		
            		 }
            	 if (time===1)
            		 {
            		 
            		    let dateTimeArray = data;
            			let dateTimeArraySorted=dateTimeArray.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
            			data = dateTimeArraySorted;
            			
            		 }
            	    currentAdsData=data;
            	   
            	       document.getElementById("ads").innerHTML = "";
            	   	   noofresults=data.length;
            		   $('#noofresults').html('Results: '+noofresults) ;

            	    $.each(data, function (i, myList) {
            	    	
            	    	     var adsid = myList.id;
            		     	 var phno = myList.phoneNumber;
            		     	var whatsapp = myList.whatsappNumber;
            		     	 var email= myList.emailAddress;
            	    	 var publisher_name = myList.a.title;
            	   var distance = myList.distance;
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
            	        +'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;display:flex;flex-direction:column;">'+publisher_name+'</p>'
            	      
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
            
            	       var  latt = 13.529271965260616;    var lngg = 75.36285138756304; 
            	  
            	    const lattt =  myList.location.lat; const longgg= myList.location.lng ;
            	
            	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}
            
            	       	  }); //.each


             
         });

     } 
	
	 else{
		 busbutton.classList.remove("roadinactive");
		 busbutton.classList.add("roadactive");  	 
	
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
//	 console.log('distance =1' );
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
   // console.log(x);
       document.getElementById("ads").innerHTML = "";
   	noofresults=data.length;
	 $('#noofresults').html('Results: '+noofresults) ;

	 
	 
    $.each(data, function (i, myList) {
    	
    	     var adsid = myList.id;
	     	 var phno = myList.phoneNumber;var whatsapp = myList.whatsappNumber;
	     	// console.log('phno : ' +phno);
	     	 var email= myList.emailAddress;
    	 var publisher_name = myList.a.title;
   // 	 console.log(publisher_name);
    	 var description = myList.a.description; var fullname = myList.fullName;let distance = myList.distance.toFixed(2);
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
       <!-- +'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;">'+publisher_name+'</p>'-->
        +'<div style="display:flex;justify-content:space-between;align-items:center;font-family:Inter;">'
	       + '<span style="font-weight:700;font-size:16px;">' + publisher_name + '</span>'
	       + '<span style="font-weight:500;font-size:14px;color:#666;">' + distance + '</span>'
	       + '</div>'
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
        +'<div class="takeme" ><button  id ="takeme" data-lat='+latitudes+' data-long='+longitudes+'  onclick=takemefromvehicle('+latitudes+','+longitudes+',\''+adsid+'\'); style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Show Location</button></div>'
        +'</div>'
        +'</div>'
        
     	 $('.ads').append(ad_card);

       var  latt = 13.529271965260616;    var lngg = 75.36285138756304; 
  
    const lattt =  myList.location.lat; const longgg= myList.location.lng ;

var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}

       	  }); //.each

        }//success
	
})//ajax
	 }
	 }
	 

	 
	 //bus end
	 
	 //car start
	 	 
	  var carenabled = 0;
function carads()
{
	gitagenabled=0;templeenabled =0;forestenabled=0;heritageenabled =0;hospitalenabled =0;newsenabled=0;vlogsenabledd=0;goodsenabled=0;	busenabled=0;carenabled=1; rickshawenabled=0;roadenabled =0;
	var k=0;
	  if (watchID !== undefined) {
          navigator.geolocation.clearWatch(watchID); 
      }
	  
	  const requestId = generateRequestId();
	  latestRequestId = requestId;
	 if (carbutton.classList.contains("roadactive")) {       //when clicked to remove
		 carbutton.classList.remove("roadactive");
		 carbutton.classList.add("roadinactive");  
		 
		  document.getElementById("filter-container").style.display = "flex";
         
        
         carenabled=0;
         
         
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
            		
            		 }
            	 if (time===1)
            		 {
            		 
            		    let dateTimeArray = data;
            			let dateTimeArraySorted=dateTimeArray.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
            			data = dateTimeArraySorted;
            			
            		 }
            	    currentAdsData=data;
            	   
            	       document.getElementById("ads").innerHTML = "";
            	   	   noofresults=data.length;
            		   $('#noofresults').html('Results: '+noofresults) ;

            	    $.each(data, function (i, myList) {
            	    	
            	    	     var adsid = myList.id;
            		     	 var phno = myList.phoneNumber;
            		     	var whatsapp = myList.whatsappNumber;
            		     	 var email= myList.emailAddress;
            	    	 var publisher_name = myList.a.title;
            	   
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
            
            	       var  latt = 13.529271965260616;    var lngg = 75.36285138756304; 
            	  
            	    const lattt =  myList.location.lat; const longgg= myList.location.lng ;
            	
            	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}
            
            	       	  }); //.each


             
         });

     } 
	
	 else{
		 carbutton.classList.remove("roadinactive");
		 carbutton.classList.add("roadactive");  	 
	
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
//	 console.log('distance =1' );
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
   // console.log(x);
       document.getElementById("ads").innerHTML = "";
   	noofresults=data.length;
	 $('#noofresults').html('Results: '+noofresults) ;

	 
	 
    $.each(data, function (i, myList) {
    	
    	     var adsid = myList.id;
	     	 var phno = myList.phoneNumber;var whatsapp = myList.whatsappNumber;
	     	// console.log('phno : ' +phno);
	     	 var email= myList.emailAddress;
    	 var publisher_name = myList.a.title;
   // 	 console.log(publisher_name);
    	 var description = myList.a.description; var fullname = myList.fullName;let distance = myList.distance.toFixed(2);
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
	       + '<span style="font-weight:700;font-size:16px;">' + publisher_name + '</span>'
	       + '<span style="font-weight:500;font-size:14px;color:#666;">' + distance + '</span>'
	       + '</div>'
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
        +'<div class="takeme" ><button  id ="takeme" data-lat='+latitudes+' data-long='+longitudes+'  onclick=takemefromvehicle('+latitudes+','+longitudes+',\''+adsid+'\'); style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Show Location</button></div>'
        +'</div>'
        +'</div>'
        
     	 $('.ads').append(ad_card);

       var  latt = 13.529271965260616;    var lngg = 75.36285138756304; 
  
    const lattt =  myList.location.lat; const longgg= myList.location.lng ;

var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}

       	  }); //.each

        }//success
	
})//ajax
	 }
	 }
	 
 
	 // car end
	 
	 
	 // rickshaw start
	 
	 	 
	  var rickshawenabled = 0;
	  let latestRequestId = null;

	  function generateRequestId() {
	      return Date.now() + '_' + Math.random().toString(36).substring(2, 10);
	  }
function rickshawads()
{
	gitagenabled=0;templeenabled =0;forestenabled=0;heritageenabled =0;hospitalenabled =0;newsenabled=0;vlogsenabledd=0;goodsenabled=0;	busenabled=0;carenabled=0; rickshawenabled=1;roadenabled =0;
	var k=0;
	const requestId = generateRequestId();
    latestRequestId = requestId;
	  if (watchID !== undefined) {
          navigator.geolocation.clearWatch(watchID); 
      }
	 if (rickshawbutton.classList.contains("roadactive")) {       //when clicked to remove
		 rickshawbutton.classList.remove("roadactive");
		 rickshawbutton.classList.add("roadinactive");  
         
		  document.getElementById("filter-container").style.display = "flex";
         
         rickshawenabled=0;
         
         
         fetch('/removegiads?requestId=' + requestId, {
             method: 'POST'
         }).then(response => {
        	 
        	 if (!response.ok) {
        	        throw new Error("Network response was not ok");
        	    }
        	 
        	 return response.json(); // ✅ Parse the JSON body
         })
        	 .then(data => {
            		
        		 if (requestId !== latestRequestId) return;
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
            		
            		 }
            	 if (time===1)
            		 {
            		 
            		    let dateTimeArray = data;
            			let dateTimeArraySorted=dateTimeArray.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
            			data = dateTimeArraySorted;
            			
            		 }
            	    currentAdsData=data;
            	   
            	       document.getElementById("ads").innerHTML = "";
            	   	   noofresults=data.length;
            		   $('#noofresults').html('Results: '+noofresults) ;

            	    $.each(data, function (i, myList) {
            	    	
            	    	     var adsid = myList.id;
            		     	 var phno = myList.phoneNumber;
            		     	var whatsapp = myList.whatsappNumber;
            		     	 var email= myList.emailAddress;
            	    	 var publisher_name = myList.a.title;
            	   
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
            
            	       var  latt = 13.529271965260616;    var lngg = 75.36285138756304; 
            	  
            	    const lattt =  myList.location.lat; const longgg= myList.location.lng ;
            	
            	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}
            
            	       	  }); //.each


             
         });

     } 
	
	 else{
		rickshawbutton.classList.remove("roadinactive");
		rickshawbutton.classList.add("roadactive");  	
		
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
	//console.log(data);
	
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
//	 console.log('distance =1' );
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
   // console.log(x);
       document.getElementById("ads").innerHTML = "";
   	noofresults=data.length;
	 $('#noofresults').html('Results: '+noofresults) ;

	 
	 
    $.each(data, function (i, myList) {
    	
    	     var adsid = myList.id;
	     	 var phno = myList.phoneNumber;var whatsapp = myList.whatsappNumber;
	     	 //console.log('adsid : ' +adsid);
	     	 var email= myList.emailAddress;
    	 var publisher_name = myList.a.title;
   // 	 console.log(publisher_name);
    	 var description = myList.a.description; var fullname = myList.fullName;let distance = myList.distance.toFixed(2);
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
        +'<div style="display:flex;justify-content:space-between;align-items:center;font-family:Inter;">'
	       + '<span style="font-weight:700;font-size:16px;">' + publisher_name + '</span>'
	       + '<span style="font-weight:500;font-size:14px;color:#666;">' + distance + '</span>'
	       + '</div>'
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
        +'<div class="takeme" ><button  id ="takeme" data-lat='+latitudes+' data-long='+longitudes+' onclick=takemefromvehicle('+latitudes+','+longitudes+',\''+adsid+'\'); style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Show Location</button></div>'
        +'</div>'
        +'</div>'
        
     	 $('.ads').append(ad_card);

       var  latt = 13.529271965260616;    var lngg = 75.36285138756304; 
  
    const lattt =  myList.location.lat; const longgg= myList.location.lng ;

var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}

       	  }); //.each

        }//success
	
})//ajax
	 }
	 }
	 

	 // rickshaw end
	 
	 
	 
	 //goods start
	 
	 	 
	  var goodsenabled = 0;
function goodsads()
{
	gitagenabled=0;templeenabled =0;forestenabled=0;heritageenabled =0;hospitalenabled =0;newsenabled=0;vlogsenabledd=0;goodsenabled=1;	busenabled=0;carenabled=0; rickshawenabled=0;roadenabled =0;
	var k=0;
	  if (watchID !== undefined) {
          navigator.geolocation.clearWatch(watchID); 
      }
	  
	  const requestId = generateRequestId();
	  latestRequestId = requestId;
	 if (goodsbutton.classList.contains("roadactive")) {       //when clicked to remove
		 goodsbutton.classList.remove("roadactive");
		 goodsbutton.classList.add("roadinactive");  
         
		  document.getElementById("filter-container").style.display = "flex";
         
		  
         goodsenabled=0;
         
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
            		
            		 }
            	 if (time===1)
            		 {
            		 
            		    let dateTimeArray = data;
            			let dateTimeArraySorted=dateTimeArray.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
            			data = dateTimeArraySorted;
            			
            		 }
            	    currentAdsData=data;
            	   
            	       document.getElementById("ads").innerHTML = "";
            	   	   noofresults=data.length;
            		   $('#noofresults').html('Results: '+noofresults) ;

            	    $.each(data, function (i, myList) {
            	    	
            	    	     var adsid = myList.id;
            		     	 var phno = myList.phoneNumber;
            		     	var whatsapp = myList.whatsappNumber;
            		     	 var email= myList.emailAddress;
            	    	 var publisher_name = myList.a.title;
            	   
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
            
            	       var  latt = 13.529271965260616;    var lngg = 75.36285138756304; 
            	  
            	    const lattt =  myList.location.lat; const longgg= myList.location.lng ;
            	
            	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}
            
            	       	  }); //.each


             
         });

     } 
	
	 else{
		 goodsbutton.classList.remove("roadinactive");
		 goodsbutton.classList.add("roadactive");  	 
		 
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
//	 console.log('distance =1' );
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
   // console.log(x);
       document.getElementById("ads").innerHTML = "";
   	noofresults=data.length;
	 $('#noofresults').html('Results: '+noofresults) ;

	 
	 
    $.each(data, function (i, myList) {
    	
    	     var adsid = myList.id;
	     	 var phno = myList.phoneNumber;var whatsapp = myList.whatsappNumber;let distance = myList.distance.toFixed(2);
	     	// console.log('phno : ' +phno);
	     	 var email= myList.emailAddress;
    	 var publisher_name = myList.a.title;
   // 	 console.log(publisher_name);
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
       <!-- +'<p style ="font-family:Inter;font-style: normal;font-weight: 700; font-size: 16px;line-height: 19px;color: #000000;">'+publisher_name+'</p>'-->
       +'<div style="display:flex;justify-content:space-between;align-items:center;font-family:Inter;">'
       + '<span style="font-weight:700;font-size:16px;">' + publisher_name + '</span>'
       + '<span style="font-weight:500;font-size:14px;color:#666;">' + distance + '</span>'
       + '</div>'
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
        +'<div class="takeme" ><button  id ="takeme" data-lat='+latitudes+' data-long='+longitudes+'  onclick=takemefromvehicle('+latitudes+','+longitudes+',\''+adsid+'\'); style="font-size:14px;"><i class="glyphicon glyphicon-map-marker" style="top:0px;"></i>Show Location</button></div>'
        +'</div>'
        +'</div>'
        
     	 $('.ads').append(ad_card);

       var  latt = 13.529271965260616;    var lngg = 75.36285138756304; 
  
    const lattt =  myList.location.lat; const longgg= myList.location.lng ;

var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}

       	  }); //.each

        }//success
	
})//ajax
	 }
	 }
	 
 
	 //goods end
	 
	 
	 
	 
	 let geocoder;
	document.getElementById("searchmagnifierlocation").addEventListener("click", function() {
    var address = document.getElementById("searchlocationinput").value;
   // console.log("Input value:", address);
    geocoder.geocode({ address: address }, function(results, status) {
        if (status === "OK") {
            map.setCenter(results[0].geometry.location);
            map.setZoom(14); // Zoom in close to the location

            // Optional: add a marker
           /* new google.maps.Marker({
                map: map,
                position: results[0].geometry.location,
            });*/
        } else {
            alert("Geocode was not successful for the following reason: " + status);
        }
    });
}); 

//
var vlogsenabledd =0;
function vlogs()
{
		gitagenabled=0;templeenabled =0;forestenabled=0;heritageenabled =0;hospitalenabled =0;vlogsenabledd=1; newsenabled =0; roadenabled =0;goodsenabled=0;	busenabled=0;carenabled=0; rickshawenabled=0
		
	var k=0;
		
		const requestId = generateRequestId();
		latestRequestId = requestId;
	
	 if (watchID !== undefined) {
         navigator.geolocation.clearWatch(watchID); 
     }
/*	gitagbutton.classList.remove("giinactive");
	gitagbutton.classList.add("giactive");*/
	
	 if (vlogsbutton.classList.contains("roadactive")) {       //when clicked to remove
         vlogsbutton.classList.remove("roadactive");
         vlogsbutton.classList.add("roadinactive");          
         document.getElementById("filter-container").style.display = "flex";
        
         vlogsenabledd=0;
         
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
            		
            		 }
            	 if (time===1)
            		 {
            		 
            		    let dateTimeArray = data;
            			let dateTimeArraySorted=dateTimeArray.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
            			data = dateTimeArraySorted;
            			
            		 }
            	    currentAdsData=data;
            	   
            	       document.getElementById("ads").innerHTML = "";
            	   	   noofresults=data.length;
            		   $('#noofresults').html('Results: '+noofresults) ;

            	    $.each(data, function (i, myList) {
            	    	
            	    	     var adsid = myList.id;
            		     	 var phno = myList.phoneNumber;
            		     	var whatsapp = myList.whatsappNumber;
            		     	 var email= myList.emailAddress;
            	    	 var publisher_name = myList.a.title;
            	   
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
            	//  console.log('ad_card: '+ad_card);
            	       var  latt = 13.529271965260616;
            	    var lngg = 75.36285138756304; 
            	  
            	    const lattt =  myList.location.lat; const longgg= myList.location.lng ;
            	/*	const marker = new google.maps.Marker({
            	    //   position: new google.maps.LatLng(myList.location.lat,myList.location.lng),
            	    //  position: new google.maps.LatLng(locations[j][0], locations[j][1]),
            	   // position:{ lat: JSON.parse(locations[j][0]), lng:JSON.parse(locations[j][1] )},
            	   
            	 //  position:{ lat: parseFloat(locations[j][0]), lng:parseFloat(locations[j][1] )},
            	//  position:{ lat:lattt, lng:longgg},
            	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
            	        map: map3,
            	        icon:png
            	      });
            	markers.push(marker);	*/
            	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}
            	/*	marker.addListener('click', function() {
            	console.log('marker clicked');
            	setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
            	});*/
            	       	  }); //.each


             
         });
     } //if else 
	
	 else{
		 vlogsbutton.classList.remove("roadinactive");
         vlogsbutton.classList.add("roadactive");          
         document.getElementById("filter-container").style.display = "none";
         if (roadbutton.classList.contains("roadactive")) {       //when clicked
             // If 'active' class is already present, remove it
             roadbutton.classList.remove("roadactive");
             roadbutton.classList.add("roadinactive");
             
             if (watchID !== undefined) {
                 navigator.geolocation.clearWatch(watchID); 
             }                
  //           
         }
         
         if (newsbutton.classList.contains("roadactive")) {       //when clicked
             // If 'active' class is already present, remove it
             newsbutton.classList.remove("roadactive");
             newsbutton.classList.add("roadinactive");
         }
         if (gitagbutton.classList.contains("roadactive")) {       //when clicked
             // If 'active' class is already present, remove it
             gitagbutton.classList.remove("roadactive");
             gitagbutton.classList.add("roadinactive");
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
   // console.log(x);
       document.getElementById("ads").innerHTML = "";
   	noofresults=data.length;
	 $('#noofresults').html('Results: '+noofresults) ;

    $.each(data, function (i, myList) {
    	
    	     var adsid = myList.id;
	     	 var phno = myList.phoneNumber;var whatsapp = myList.whatsappNumber;
	     	// console.log('phno : ' +phno);
	     	 var email= myList.emailAddress;
    	 var publisher_name = myList.a.title;
   // 	 console.log(publisher_name);
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
        <!--+'<p style ="font-family:Inter;font-style: normal;font-weight: 400;font-size: 12px;line-height: 15px;color: #FF1515;opacity: 0.5;">Expires on '+dates+'</p>'  -->
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
//  console.log('ad_card: '+ad_card);
    var  latt = 13.529271965260616;    var lngg = 75.36285138756304; 
  
    const lattt =  myList.location.lat; const longgg= myList.location.lng ;
/*	const marker = new google.maps.Marker({
    //   position: new google.maps.LatLng(myList.location.lat,myList.location.lng),
    //  position: new google.maps.LatLng(locations[j][0], locations[j][1]),
   // position:{ lat: JSON.parse(locations[j][0]), lng:JSON.parse(locations[j][1] )},
   
 //  position:{ lat: parseFloat(locations[j][0]), lng:parseFloat(locations[j][1] )},
//  position:{ lat:lattt, lng:longgg},
position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
        map: map3,
        icon:png
      });
markers.push(marker);	*/
var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}
/*	marker.addListener('click', function() {
console.log('marker clicked');
setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
});*/
       	  }); //.each

        }//success
	
})//ajax

	 }
	
	
	
	
}

var newsenabled=0;
function news()
{
		gitagenabled=0;templeenabled =0;forestenabled=0;heritageenabled =0;hospitalenabled =0;newsenabled=1;vlogsenabledd=0;goodsenabled=0;	busenabled=0;carenabled=0; rickshawenabled=0;roadenabled =0;
		
	var k=0;
	
	 if (watchID !== undefined) {
         navigator.geolocation.clearWatch(watchID); 
     }
	 const requestId = generateRequestId();
	 latestRequestId = requestId;
	 if (newsbutton.classList.contains("roadactive")) {       //when clicked to remove
         newsbutton.classList.remove("roadactive");
         newsbutton.classList.add("roadinactive");  
         
         
         document.getElementById("filter-container").style.display = "flex";
        
         newsenabled=0;
         
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
            		
            		 }
            	 if (time===1)
            		 {
            		 
            		    let dateTimeArray = data;
            			let dateTimeArraySorted=dateTimeArray.sort(function(a, b) { return new Date(b.dateRange.fromDate) - new Date(a.dateRange.fromDate); });
            			data = dateTimeArraySorted;
            			
            		 }
            	    currentAdsData=data;
            	   
            	       document.getElementById("ads").innerHTML = "";
            	   	   noofresults=data.length;
            		   $('#noofresults').html('Results: '+noofresults) ;

            	    $.each(data, function (i, myList) {
            	    	
            	    	     var adsid = myList.id;
            		     	 var phno = myList.phoneNumber;
            		     	var whatsapp = myList.whatsappNumber;
            		     	 var email= myList.emailAddress;
            	    	 var publisher_name = myList.a.title;
            	   
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
            	//  console.log('ad_card: '+ad_card);
            	       var  latt = 13.529271965260616;
            	    var lngg = 75.36285138756304; 
            	  
            	    const lattt =  myList.location.lat; const longgg= myList.location.lng ;
            	/*	const marker = new google.maps.Marker({
            	    //   position: new google.maps.LatLng(myList.location.lat,myList.location.lng),
            	    //  position: new google.maps.LatLng(locations[j][0], locations[j][1]),
            	   // position:{ lat: JSON.parse(locations[j][0]), lng:JSON.parse(locations[j][1] )},
            	   
            	 //  position:{ lat: parseFloat(locations[j][0]), lng:parseFloat(locations[j][1] )},
            	//  position:{ lat:lattt, lng:longgg},
            	position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
            	        map: map3,
            	        icon:png
            	      });
            	markers.push(marker);	*/
            	var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}
            	/*	marker.addListener('click', function() {
            	console.log('marker clicked');
            	setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
            	});*/
            	       	  }); //.each


             
         });
     } //if else 
	
	 else{
		 newsbutton.classList.remove("roadinactive");
         newsbutton.classList.add("roadactive");            
         document.getElementById("filter-container").style.display = "none";
         
         if (roadbutton.classList.contains("roadactive")) {       //when clicked
             roadbutton.classList.remove("roadactive");
             roadbutton.classList.add("roadinactive");
             
             if (watchID !== undefined) {
                 navigator.geolocation.clearWatch(watchID); 
             }                
       
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
   // console.log(x);
       document.getElementById("ads").innerHTML = "";
   	noofresults=data.length;
	 $('#noofresults').html('Results: '+noofresults) ;

    $.each(data, function (i, myList) {
    	
    	     var adsid = myList.id;
	     	 var phno = myList.phoneNumber;var whatsapp = myList.whatsappNumber;
	     	// console.log('phno : ' +phno);
	     	 var email= myList.emailAddress;
    	 var publisher_name = myList.a.title;
   // 	 console.log(publisher_name);
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
//  console.log('ad_card: '+ad_card);
    var  latt = 13.529271965260616;    var lngg = 75.36285138756304; 
  
    const lattt =  myList.location.lat; const longgg= myList.location.lng ;
/*	const marker = new google.maps.Marker({
    //   position: new google.maps.LatLng(myList.location.lat,myList.location.lng),
    //  position: new google.maps.LatLng(locations[j][0], locations[j][1]),
   // position:{ lat: JSON.parse(locations[j][0]), lng:JSON.parse(locations[j][1] )},
   
 //  position:{ lat: parseFloat(locations[j][0]), lng:parseFloat(locations[j][1] )},
//  position:{ lat:lattt, lng:longgg},
position:new google.maps.LatLng(myList.location.lat, myList.location.lng),
        map: map3,
        icon:png
      });
markers.push(marker);	*/
var markerDetails ={lat:lattt,lng:longgg,title:publisher_name,email:email,phno:phno,description:description, companyName:companyName,companyLogoUrl:companyLogoUrl,thumbnail:thumbnail}
/*	marker.addListener('click', function() {
console.log('marker clicked');
setTimeout(() => { showCard(markerDetails); }, 500); // Delay of 0.5 seconds before showing the card 
});*/
       	  }); //.each

        }//success
	
})//ajax

	 }
	
	
	
	
}
</script>

</body>
</html>

