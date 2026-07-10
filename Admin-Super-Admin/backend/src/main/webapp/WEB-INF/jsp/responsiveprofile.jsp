<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <% // Set a session variable (this is usually done before) String latitude=(String)
                session.getAttribute("latitude"); String longitude=(String)session.getAttribute("longitude"); %>

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
                    <script type="text/javascript"
                        src="https://maps.googleapis.com/maps/api/js?key=${googleMapsApiKey}"></script>
                    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"
                        type="text/javascript"></script>
                    <!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"> -->

                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

                    <link rel="preconnect" href="https://fonts.googleapis.com">
                    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap"
                        rel="stylesheet">


                    <!--  <script src="js/jquery-1.7.1.min.js"></script>
<script src="js/bootstrap.js"></script> -->
                    <style>
                        html {
                            height: 100%;
                            overflow-x: hidden;
                            max-width: 100%;
                        }

                        body {
                            min-height: 100%;
                            background-color: white;
                            margin: 0;
                            padding: 0;
                            overflow-x: hidden;
                            max-width: 100%;
                        }

                        * {
                            margin: 0;
                            padding: 0;
                            box-sizing: border-box;
                        }

                        .image-container {
                            position: relative;
                            display: inline-block;
                        }

                        .image-container img {
                            width: 150px;
                            height: 150px;
                            border-radius: 50%;
                            object-fit: cover;
                            border: 3px solid #ddd;
                        }

                        .edit-icon {
                            position: relative;
                            /*absolute;*/
                            bottom: 10px;
                            right: 10px;
                            background-color: white;
                            color: black;
                            padding: 6px;
                            border-radius: 50%;
                            cursor: pointer;
                            /* border: 1px solid #aaa;*/
                            transition: transform 0.2s ease-in-out;
                            float: inline-end;
                        }

                        .edit-icon:hover {
                            transform: scale(1.1);
                            background-color: #f0f0f0;
                        }

                        input[type="file"] {
                            display: none;
                        }

                        .container {
                            padding: 30px;
                        }

                        .modal.fullscreen-modal {
                            top: 0;
                            right: 0;
                            bottom: 0;
                            left: 0;
                            position: fixed;
                            overflow: hidden;
                        }

                        .modal-dialog.fullscreen-modal-dialog {
                            width: 100%;
                            height: 100%;
                            margin: 0;
                            padding: 0;
                        }

                        .modal-content.fullscreen-modal-content {
                            height: 100%;
                            border-radius: 0;
                        }

                        .toggle-container {
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            /* margin-top: 7px; */
                            flex-direction: row;
                        }

                        .toggle-button {
                            padding: 5px 20px;
                            border: 1px solid #ccc;
                            background-color: #fff;
                            cursor: pointer;
                            outline: none;
                        }

                        .toggle-button.active {
                            background: linear-gradient(90deg, #F27C0A 0%, #F2382C 100%), #FFFFFF;
                            color: white;
                        }

                        .toggle-button:first-child {
                            border-radius: 25px 0 0 25px;
                        }

                        .toggle-button:last-child {
                            border-radius: 0 25px 25px 0;
                        }


                        .confirmation-box {
                            display: none;
                            /* Hidden by default */
                            position: fixed;
                            /* Stay in place */
                            z-index: 1;
                            /* Sit on top */
                            left: 50%;
                            top: 50%;
                            transform: translate(-50%, -50%);
                            width: 300px;
                            /* Width of the confirmation box */
                            padding: 20px;
                            background-color: white;
                            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5);
                            border-radius: 8px;
                            text-align: center;
                        }

                        .confirmation-box button {
                            margin: 10px;
                            padding: 10px 20px;
                            border: none;
                            border-radius: 4px;
                            cursor: pointer;
                        }

                        .confirm-btn {
                            background-color: #28a745;
                            color: white;
                        }

                        .cancel-btn {
                            background-color: #dc3545;
                            color: white;
                        }

                        .error {
                            color: red;
                            font-size: 10px;
                        }

                        .icon-circle {
                            display: inline-flex;
                            align-items: center;
                            justify-content: center;
                            width: 33px;
                            height: 36px;
                            border-radius: 50%;
                            /* border: 1px solid black; */
                            font-size: 24px;
                            background-color: #FFE7CC;
                        }
                    </style>
                </head>

                <body>
                    <div class="container">
                        <!-- <div class="edit-icon" onclick="document.getElementById('fileInput').click()">✏️</div>--><!-- onclick="editProfileModalOpen();"-->
                        <div class="edit-icon" data-toggle="modal" data-target="#editProfileModal">✏️</div>
                        <div class="image-container1"
                            style="display: flex;    flex-direction: row;    align-items: center;    justify-content: center;padding-left: 20px;">
                            <div class="image-container">
                                <img id="profileImage" src="${users_keliri.profileImagePath}" alt="Profile Image">

                            </div>
                        </div><!-- image-container1 -->
                        <div
                            style="justify-content: center; display: flex;    padding: 15px;font-family: 'Inter';    font-style: normal;    font-weight: 700;    font-size: 18px;    line-height: 22px;    color: #000000;">
                            <c:set var="myNameorPhoneValue" value="${users_keliri.name}" />
                            <c:choose>
                                <c:when test="${empty myNameorPhoneValue}">
                                    <div class="profileorphone"
                                        style="display:flex;flex-direction:row;gap: 10px;    align-items: center;    justify-content: center;">
                                        <div>${users_keliri.phoneNumber}</div>

                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="profileorphone"
                                        style="display:flex;flex-direction:row;gap: 10px;    align-items: center;    justify-content: center;">
                                        <div>${users_keliri.name}</div>

                                    </div>
                                </c:otherwise>
                            </c:choose>

                        </div>
                        <div class="profileoptions" style="display:flex;flex-direction:column;gap:15px;">
                            <button style="outline: none;    background: none;    border: none;">
                                <div style="display:flex;flex-direction:row;align-items: center;    gap: 10px;">
                                    <svg width="30" height="30" viewBox="0 0 30 30" fill="none"
                                        xmlns="http://www.w3.org/2000/svg">
                                        <rect width="30" height="30" rx="15" fill="#FFE7CC" />
                                        <path
                                            d="M19.8285 20.9208H20.2153C21.1232 20.9208 21.8456 20.5072 22.4937 19.9293C24.1406 18.4601 20.269 16.9735 18.9474 16.9735M17.3685 9.13322C17.5479 9.0969 17.7335 9.07874 17.925 9.07874C19.3619 9.07874 20.5264 10.139 20.5264 11.4472C20.5264 12.7553 19.3619 13.8156 17.925 13.8156C17.7335 13.8156 17.5479 13.7974 17.3685 13.7611M8.66925 17.8506C7.73846 18.3495 5.2982 19.368 6.78478 20.6422C7.51109 21.2651 8.31952 21.7103 9.33636 21.7103H15.1374C16.1543 21.7103 16.9627 21.2651 17.689 20.6422C19.1756 19.368 16.7353 18.3495 15.8045 17.8506C13.6216 16.6814 10.8521 16.6814 8.66925 17.8506ZM15.3948 11.0524C15.3948 11.89 15.0621 12.6932 14.4699 13.2854C13.8776 13.8776 13.0744 14.2103 12.2369 14.2103C11.3994 14.2103 10.5961 13.8776 10.0039 13.2854C9.41169 12.6932 9.07899 11.89 9.07899 11.0524C9.07899 10.2149 9.41169 9.41168 10.0039 8.81946C10.5961 8.22724 11.3994 7.89453 12.2369 7.89453C13.0744 7.89453 13.8776 8.22724 14.4699 8.81946C15.0621 9.41168 15.3948 10.2149 15.3948 11.0524Z"
                                            stroke="black" stroke-linecap="round" stroke-linejoin="round" />
                                    </svg>
                                    <h5
                                        style="color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">
                                        Following</h5>
                                </div>
                            </button>
                            <button style="outline: none;    background: none;    border: none;">
                                <div style="display:flex;flex-direction:row;align-items: center;    gap: 10px;">
                                    <svg width="28" height="30" viewBox="0 0 28 30" fill="none"
                                        xmlns="http://www.w3.org/2000/svg">
                                        <rect width="28" height="30" rx="14" fill="#FFE7CC" />
                                        <path
                                            d="M8.9725 20.0951V9.08008H18.73V20.1472L14.1192 16.0218L13.6911 15.6387L13.2734 16.0332L8.9725 20.0951Z"
                                            stroke="black" stroke-width="1.25" />
                                    </svg>

                                    <h5
                                        style="color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">
                                        Saved</h5>
                                </div>
                            </button>
                            <button style="outline: none;    background: none;    border: none;">
                                <div style="display:flex;flex-direction:row;align-items: center;    gap: 10px;">
                                    <svg width="28" height="30" viewBox="0 0 28 30" fill="none"
                                        xmlns="http://www.w3.org/2000/svg">
                                        <rect width="28" height="30" rx="14" fill="#FFE7CC" />
                                        <path
                                            d="M17.3493 9.47363C15.9426 9.47363 14.7034 10.2565 14 11.4868C13.2967 10.2565 12.0574 9.47363 10.6507 9.47363C8.4402 9.47363 6.63159 11.4868 6.63159 13.9473C6.63159 18.3837 14 22.8947 14 22.8947C14 22.8947 21.3684 18.421 21.3684 13.9473C21.3684 11.4868 19.5598 9.47363 17.3493 9.47363Z"
                                            fill="#F44336" />
                                    </svg>
                                    <h5
                                        style="color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">
                                        My Preferences</h5>
                                </div>
                            </button>
                            <button style="outline: none;    background: none;    border: none;">
                                <div style="display:flex;flex-direction:row;align-items: center;    gap: 10px;">
                                    <svg width="28" height="30" viewBox="0 0 28 30" fill="none"
                                        xmlns="http://www.w3.org/2000/svg">
                                        <rect width="28" height="30" rx="14" fill="#FFE7CC" />
                                        <path
                                            d="M6.8158 9.67085H16.7632M11.7895 7.89453V9.67085M14.5526 22.1051L17.8684 13.8156L21.1842 22.1051M15.5716 19.7366H20.1653M14.8739 9.67085C14.8739 9.67085 14.0345 13.1495 12.0313 15.7769C10.028 18.4044 7.92106 19.7366 7.92106 19.7366"
                                            stroke="black" stroke-linecap="round" stroke-linejoin="round" />
                                        <path
                                            d="M14 17.9606C14 17.9606 12.7911 16.9614 11.5132 15.1851C10.2352 13.4088 9.57895 12.0396 9.57895 12.0396"
                                            stroke="black" stroke-linecap="round" stroke-linejoin="round" />
                                    </svg>
                                    <div
                                        style="display: flex;    flex-direction: row;    justify-content: space-between;    align-items: center;    gap: 10px;    width: 80%;">
                                        <h5
                                            style="color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">
                                            Language</h5>
                                        <h5
                                            style="color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">
                                            English</h5>
                                    </div>
                                </div>
                            </button>
                            <button style="outline: none;    background: none;    border: none;">
                                <div style="display:flex;flex-direction:row;align-items: center;    gap: 10px;">
                                    <svg width="28" height="30" viewBox="0 0 28 30" fill="none"
                                        xmlns="http://www.w3.org/2000/svg">
                                        <rect width="28" height="30" rx="14" fill="#FFE7CC" />
                                        <path
                                            d="M6.8158 9.67085H16.7632M11.7895 7.89453V9.67085M14.5526 22.1051L17.8684 13.8156L21.1842 22.1051M15.5716 19.7366H20.1653M14.8739 9.67085C14.8739 9.67085 14.0345 13.1495 12.0313 15.7769C10.028 18.4044 7.92106 19.7366 7.92106 19.7366"
                                            stroke="black" stroke-linecap="round" stroke-linejoin="round" />
                                        <path
                                            d="M14 17.9606C14 17.9606 12.7911 16.9614 11.5132 15.1851C10.2352 13.4088 9.57895 12.0396 9.57895 12.0396"
                                            stroke="black" stroke-linecap="round" gvvvvgf-linejoin="round" />
                                    </svg>
                                    <h5
                                        style="color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">
                                        Set Range</h5>
                                </div>
                            </button>

                            <button style="outline: none;    background: none;    border: none;" id="regform"
                                onclick="window.location.href='https://www.keliri.com/kelirilink/registrationForm'"><!-- https://www.keliri.com:3000/regform and onclick="window.open('https://www.keliri.com:3000/regform', '_blank')"-->
                                <div style="display:flex;flex-direction:row;align-items: center;    gap: 10px;">
                                    <span class="icon-circle">
                                        <i class="fa fa-file-text-o" style="font-size:15px"></i>

                                    </span>
                                    <h5
                                        style="color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">
                                        Registration Form</h5>
                                </div>
                            </button>


                            <button style="outline: none;    background: none;    border: none;" id="adrequestform"
                                onclick="window.location.href='https://www.keliri.com/kelirilink/advertisementrequestform'">
                                <div style="display:flex;flex-direction:row;align-items: center;    gap: 10px;">
                                    <span class="icon-circle">
                                        <i class="fa fa-file-text-o" style="font-size:15px"></i></span>
                                    <h5
                                        style="color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">
                                        Advertisement Request Form</h5>
                                </div>
                            </button>

                            <button style="outline: none;    background: none;    border: none;" id="vehicleapp"
                                onclick="window.location.href='<c:url value=" /download-apk" />'">
                            <div style="display:flex;flex-direction:row;align-items: center;    gap: 10px;">
                                <span class="icon-circle">
                                    <i class="fa fa-file-text-o" style="font-size:15px"></i></span>
                                <h5
                                    style="color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">
                                    Click Here for Vehicle App</h5>
                            </div>
                            </button>

                            <button style="outline: none; background: none;    border: none;"
                                onclick="showConfirmationBox()">
                                <div style="display:flex;flex-direction:row;align-items: center;    gap: 10px;">
                                    <svg width="28" height="30" viewBox="0 0 28 30" fill="none"
                                        xmlns="http://www.w3.org/2000/svg">
                                        <rect width="28" height="30" rx="14" fill="#FFE7CC" />
                                        <path
                                            d="M8.10526 21.3157V8.68408H14.0147V9.47356H8.8421V20.5262H14.0147V21.3157H8.10526ZM17.2878 17.7938L16.7705 17.2254L18.4793 15.3946H11.9309V14.6051H18.4793L16.7698 12.7736L17.287 12.2067L19.8947 14.9999L17.2878 17.7938Z"
                                            fill="black" />
                                    </svg>
                                    <h5
                                        style="color: #000;font-family: Inter;font-size: 16px;font-style: normal;font-weight: 400;line-height: normal;">
                                        Logout</h5>
                                </div>
                            </button>
                        </div><!-- profileoptions -->


                        <!-- Hidden file input -->
                        <input type="file" id="fileInput" name="file" accept="image/*" onchange="uploadImage(event)"
                            style="display:none;">
                    </div><!-- container -->

                    <div id="editProfileModal" class="modal fullscreen-modal" role="dialog">
                        <div class="modal-dialog fullscreen-modal-dialog">

                            <!-- Modal content-->
                            <div class="modal-content fullscreen-modal-content">
                                <div class="modal-header" style="justify-content: flex-start;gap:18px;display:flex;">
                                    <button style="border:none;outline:none;background:none;" data-dismiss="modal"> <svg
                                            width="12" height="24" viewBox="0 0 12 24" fill="none"
                                            xmlns="http://www.w3.org/2000/svg">
                                            <path fill-rule="evenodd" clip-rule="evenodd"
                                                d="M10 19.438L8.95502 20.5L1.28902 12.71C1.10452 12.5197 1.00134 12.2651 1.00134 12C1.00134 11.7349 1.10452 11.4803 1.28902 11.29L8.95502 3.5L10 4.563L2.68202 12L10 19.438Z"
                                                fill="black" />
                                        </svg></button>
                                    <p
                                        style="width: 96px;height: 15px;font-family: 'Inter';font-style: normal;font-weight: 700;font-size: 18px;line-height: 22px;color: #000000;flex: none;order: 0;flex-grow: 0;">
                                        Edit Profile</p>
                                </div><!-- modal header -->
                                <div class="modal-body"
                                    style="height:auto;gap:12px;gap: 12px;    display: flex;    flex-direction: column;">
                                    <form:form method="post" action="profileForm" modelAttribute="users_keliri"
                                        enctype="multipart/form-data" onsubmit="return validateForm()">
                                        <div class="image-container1"
                                            style="display: flex;    flex-direction: row;    align-items: center;    justify-content: center;padding-left: 20px;">
                                            <div class="image-container">
                                                <img id="profilePic" src="${users_keliri.profileImagePath}" width="150"
                                                    height="150" style="border-radius: 50%; cursor: pointer;"
                                                    onclick="triggerFileInput()" />

                                            </div>
                                        </div><!-- image-container1 -->

                                        <!-- Hidden File Input -->
                                        <input type="file" id="profileImageFile" name="profileImageFile"
                                            accept="image/*" style="display: none;" onchange="previewImage(event)" />
                                        <div
                                            style="display: flex;flex-direction: column;align-items: flex-start;padding: 10px;gap: 10px;width: 328px;height: 40px;flex: none;order: 0;align-self: stretch;flex-grow: 0;border-bottom: 1px solid #d3c4c4;">
                                            <form:input type="text" placeholder="Name"
                                                style="border:none;background:none;outline:none;width:100%;" path="name"
                                                value="${users_keliri.name}" />
                                        </div>
                                        <div
                                            style="display: flex;flex-direction: column;align-items: flex-start;padding: 10px;gap: 10px;width: 328px;height: 40px;flex: none;order: 0;align-self: stretch;flex-grow: 0;border-bottom: 1px solid #d3c4c4;">
                                            <form:input type="text" placeholder="Phone Number"
                                                style="border:none;background:none;outline:none;width:100%;"
                                                path="phoneNumber" value="${users_keliri.phoneNumber}"
                                                readonly="${not empty users_keliri.phoneNumber}" id="phone" /><span
                                                id="phoneError" class="error"></span>
                                            <form:errors path="phoneNumber" cssClass="error" /><br>
                                        </div>
                                        <div
                                            style="display: flex;flex-direction: column;align-items: flex-start;padding: 10px;gap: 10px;width: 328px;height: 40px;flex: none;order: 0;align-self: stretch;flex-grow: 0;border-bottom: 1px solid #d3c4c4;">
                                            <form:input type="text" placeholder="Nick Name"
                                                style="border:none;background:none;outline:none;width:100%;"
                                                path="nickName" value="${users_keliri.nickName}" />
                                        </div>
                                        <div
                                            style="display: flex;flex-direction: column;align-items: flex-start;padding: 10px;gap: 10px;width: 328px;height: 40px;flex: none;order: 0;align-self: stretch;flex-grow: 0;border-bottom: 1px solid #d3c4c4;">
                                            <form:input type="text" placeholder="Email-Id"
                                                style="border:none;background:none;outline:none;width:100%;"
                                                path="emailId" value="${users_keliri.emailId}" id="email" /><span
                                                id="emailError" class="error"></span>
                                            <form:errors path="emailId" cssClass="error" /><br>
                                        </div>
                                        <div
                                            style="display: flex;flex-direction: column;align-items: flex-start;padding: 10px;gap: 10px;width: 328px;height: 40px;flex: none;order: 0;align-self: stretch;flex-grow: 0;border-bottom: 1px solid #d3c4c4;">
                                            <form:input type="text" placeholder="Age"
                                                style="border:none;background:none;outline:none;width:100%;" path="age"
                                                value="${users_keliri.age}" id="age" /><span id="ageError"
                                                class="error"></span>
                                            <form:errors path="age" cssClass="error" /><br>
                                        </div>
                                        <div
                                            style="display: flex;flex-direction: column;align-items: flex-start;padding: 10px;gap: 10px;width: 328px;height: 40px;flex: none;order: 0;align-self: stretch;flex-grow: 0;border-bottom: 1px solid #d3c4c4;">
                                            <form:input type="text" placeholder="Interest"
                                                style="border:none;background:none;outline:none;width:100%;"
                                                path="interest" value="${users_keliri.interest}" />
                                        </div>
                                        <div
                                            style="display: flex;    flex-direction: row;    gap: 50px;    padding: 10px;    align-items: center;    justify-content: flex-start;    flex: 1;">
                                            <p
                                                style="font-family: 'Inter';font-style: normal;font-weight: 600;font-size: 15px;">
                                                Gender</p>
                                            <form:hidden path="gender" id="genderInput"
                                                value="${not empty users_keliri.gender ? users_keliri.gender : 'Male'}" />
                                            <div class="toggle-container">
                                                <c:set var="genderValue" value="${users_keliri.gender}" />
                                                <c:if test="${genderValue=='Male'}">
                                                    <button class="toggle-button active" id="male" value="Male"
                                                        name="gender"
                                                        onclick="selectGender(this.value,event)">Male&nbsp;&nbsp;</button>
                                                    <button class="toggle-button" id="female" value="Female"
                                                        name="gender"
                                                        onclick="selectGender(this.value,event)">Female</button>
                                                </c:if>
                                                <c:if test="${genderValue=='Female'}">
                                                    <button class="toggle-button" id="male" value="Male" name="gender"
                                                        onclick="selectGender(this.value,event)">Male&nbsp;&nbsp;</button>
                                                    <button class="toggle-button active" id="female" value="Female"
                                                        name="gender"
                                                        onclick="selectGender(this.value,event)">Female</button>
                                                </c:if>
                                                <c:if test="${empty genderValue}">
                                                    <button class="toggle-button active" id="male" value="Male"
                                                        name="gender"
                                                        onclick="selectGender(this.value,event)">Male&nbsp;&nbsp;</button>
                                                    <button class="toggle-button" id="female" value="Female"
                                                        name="gender"
                                                        onclick="selectGender(this.value,event)">Female</button>
                                                </c:if>
                                            </div><!-- toggle container -->
                                        </div>
                                        <div style="display:flex;flex-direction:row;">
                                            <button style="display: flex;flex-direction: row;justify-content: center;align-items: center;padding: 14px 20px;gap: 10px;width: 328px;height: 45px;
background: linear-gradient(90deg, #F27C0A 0%, #F2382C 100%);border-radius: 8px;flex: none;order: 2;align-self: stretch;flex-grow: 0;outline: none;
    border: none;" type="submit">Update
                                                <svg width="18" height="16" viewBox="0 0 18 16" fill="none"
                                                    xmlns="http://www.w3.org/2000/svg">
                                                    <path d="M1.75 7.5L6.75 13.5L16.25 1.5" stroke="white"
                                                        stroke-width="2" />
                                                </svg>
                                            </button>
                                        </div>
                                    </form:form>
                                </div><!-- modal body -->

                            </div>

                        </div>
                    </div>

                    <!-- Logout confirmation Modal start here -->
                    <div id="confirmationBox" class="confirmation-box">
                        <p
                            style="font-family: 'Inter'; font-style: normal;    font-weight: 700;    font-size: 14px;    line-height: 22px;    color: #000000;">
                            Are you sure ?</p>
                        <button class="confirm-btn" onclick="confirmAction()">Yes</button>
                        <button class="cancel-btn" onclick="hideConfirmationBox()">No</button>
                    </div>
                    <!-- Logout confirmation Modal start here -->
                    <script type="text/javascript">
                        $(document).ready(function () {
                            $('#footerprofilepic').attr("src", "${users_keliri.profileImagePath}");

                        });

                        function uploadImage(event) {
                            const file = event.target.files[0];
                            if (file) {
                                const reader = new FileReader();
                                reader.onload = function (e) {
                                    document.getElementById('profileImage').src = e.target.result;
                                };
                                reader.readAsDataURL(file);

                                // Create FormData
                                let formData = new FormData();
                                formData.append("file", file);

                                // Send file to server
                                fetch('/upload', {
                                    method: 'POST',
                                    body: formData
                                })
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.imageUrl) {
                                            // alert("Image uploaded successfully!");
                                            document.getElementById('profileImage').src = data.imageUrl; // Update with uploaded image
                                        } else {
                                            alert("Upload failed!");
                                        }
                                    })
                                    .catch(error => {
                                        console.error("Error:", error);
                                        alert("Error uploading file.");
                                    });
                            }
                        }

                        //to show edit profile start here
                        <!--<div class="edit-icon" onclick="document.getElementById('fileInput').click()">✏️</div>-->
                        function editProfileModalOpen() {

                            // $("#editProfileModal").show();

                        }

                        //to show edit profile end here

                        //to make one of the gender button active start here 
                        /*const buttons = document.querySelectorAll('.toggle-button');
                        
                            buttons.forEach(button => {
                                button.addEventListener('click', function(event) {
                                    buttons.forEach(btn => btn.classList.remove('active'));
                                    this.classList.add('active');
                                    event.preventDefault();
                                    document.getElementById("genderInput").value = gender;
                                });
                                
                            });*/
                        function selectGender(gender, event) {
                            const buttons = document.querySelectorAll('.toggle-button');
                            buttons.forEach(btn => btn.classList.remove('active'));
                            event.preventDefault();
                            document.querySelectorAll(".toggle-button").forEach(btn => {
                                if (btn.value === gender) {
                                    btn.classList.add("active");
                                }
                            });

                            document.getElementById("genderInput").value = gender;
                        }
                        //to make one of the gender button active end here


                        //Logout confirmation start here
                        function showConfirmationBox() {
                            document.getElementById("confirmationBox").style.display = "block";
                        }

                        function hideConfirmationBox() {
                            document.getElementById("confirmationBox").style.display = "none";
                        }

                        function confirmAction() {
                            //  alert("Action confirmed!");

                            hideConfirmationBox();
                        }

                        //Logout confirmation end here


                        function triggerFileInput() {
                            document.getElementById('profileImageFile').click();
                        }

                        function previewImage(event) {
                            var reader = new FileReader();
                            reader.onload = function () {
                                document.getElementById('profilePic').src = reader.result;
                            };
                            reader.readAsDataURL(event.target.files[0]);
                        }


                        function validateForm() {
                            //console.log('in validation');
                            let email = document.getElementById("email").value;
                            let phone = document.getElementById("phone").value;
                            let emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                            let phonePattern = /^[0-9]{10}$/;
                            let age = document.getElementById("age").value;
                            let agePattern = /^(?:[1-9]|[1-9][0-9]|100)$/;
                            if (age.trim() !== "" && !agePattern.test(age)) {
                                //  alert("Age must be between 1 and 100!");
                                document.getElementById("ageError").innerHTML = "Age must be a valid number!";
                                return false;
                            }
                            if (email.trim() !== "" && !emailPattern.test(email)) {
                                //alert("Invalid email format!");
                                document.getElementById("emailError").innerHTML = "Invalid email format!";
                                return false;
                            }
                            if (phone.trim() === "") {
                                //   alert("Phone number is required!");
                                document.getElementById("phoneError").innerHTML = "Phone number is required!";
                                return false;
                            }
                            else if (!phonePattern.test(phone)) {
                                document.getElementById("phoneError").innerHTML = "Phone number must be 10 digits!";
                                return false;
                            }

                            return true;
                        }
                    </script>
                    <jsp:include page="responsivefooter.jsp" />
                </body>

                </html>