<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
.choseloccontainer
{
display: flex;flex-direction: row;justify-content: center;align-items: center;
padding: 16px;gap: 15px;width: 100%;/*360px;*/height: 56px;background: #FFFFFF;
box-shadow: 0px 0px 4px rgba(0, 0, 0, 0.25);backdrop-filter: blur(5px);flex: none;
order: 0;align-self: stretch;flex-grow: 0;z-index: 1;
}
.bell-icon{position: relative; display: inline-block;}
.badge{position: absolute; top: -10px; right: -10px; background-color: red; color: white;}
.fa-2x {    font-size: 1.5em;}

</style>
</head>
<body>
<div class="choseloccontainer">
<svg width="12" height="24" viewBox="0 0 12 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M10 19.438L8.95502 20.5L1.28902 12.71C1.10452 12.5197 1.00134 12.2651 1.00134 12C1.00134 11.7349 1.10452 11.4803 1.28902 11.29L8.95502 3.5L10 4.563L2.68202 12L10 19.438Z" fill="black"/>
</svg>
<h3> Choose Location</h3>
<div class="bell-icon">
 <i class="fa fa-bell-o fa-2x"></i> <span class="badge">5</span> 


</div>

</div>
</body>
</html>