<%-- 
    Document   : manageUsers
    Created on : Dec 18, 2017, 5:14:17 PM
    Author     : gee & soso
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
      <head>
            <link href="css/notifcss.css" rel="stylesheet" type="text/css"/>
            <link rel="stylesheet" type="text/css" href="css/bootstrap.css">
            <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
            <link rel="stylesheet" type="text/css" href="css/font-awesome.css">
            <link rel="stylesheet" type="text/css" href="css/font-awesome.min.css">

            <script src="http://code.jquery.com/jquery-latest.min.js"></script>

            <script>
                $(document).ready(function () {
                    $(document).on('click', '#changepass-btn', function () {
                        var id = $(this).val();
                        console.log(id);
                        $("#userID").val(id);
                    });

                    $.get("getAllUsers", null, function (data) {
                        for (var i = 0; i < data.length; i++) {
                            $("#users").append("<div class='row' id='row" + data[i]["id"] + "'><div class='col'>" + data[i]["username"] + "</div><div class='col'><button id='changepass-btn' name='userID' value='" + data[i]["id"] + "'class='btn btn-sm btn-outline-dark' onclick='showDiv()'><span class='fa fa-times'></span>Change Password</button></div></div><br>");
                        }
                    });
                    $.get("getUserNotifications", null, function (data) {
                        for (var i = 0; i < data.length; i++) {
                            $("#notifications").append("<tr><td><a href='getNotification?ID=" + data[i]["notificationID"] + "'>"
                                    + data[i]["notification"] + " </a></td></tr>");
                        }
                        $('#notification_count').text(data.length);
                    });
                    $("#notificationLink").click(function ()
                    {
                        $("#notificationContainer").fadeToggle(300);
                        $("#notification_count").fadeOut("slow");
                        return false;
                    });
                    //document click hiding the popup 
                    $(document).click(function ()
                    {
                        $("#notificationContainer").hide();
                    });
                    //popup on click
                    $("#notificationContainer").click(function ()
                    {
                        return false;
                    });
                    $("#notificationsBody").click(function () {
                        window.location = $(this).find("a").attr("href");
                        return false;
                    });
                });
            </script>
            <script>
                function showDiv() {
                    if (document.getElementById('passwordform').style.display !== "none") {
                        document.getElementById('passwordform').style.display = "none";
                    } else {
                        document.getElementById('passwordform').style.display = "block";
                    }
                }
            </script>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>JSP Page</title>
      </head>
      <body>
            <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                  <div class="container">
                        <a class="navbar-brand" href="home.jsp">Simsar</a>
                        <ul class="navbar-nav mr-auto">
                              <li class="nav-item"><a href="home.jsp" class="nav-link">Home</a></li>
                              <li class="nav-item"><a href="viewUserAds.jsp" class="nav-link">My Ads</a></li>
                        </ul>
                        <ul class="nav navbar-nav navbar-right">
                              <%
                                  session = request.getSession();
                                  Integer admin = (Integer) session.getAttribute("admin");
                                  if (admin == 1) {
                              %>
                              <li class="nav-item active"><a href="manageAds.jsp" class="nav-link">Manage Ads</a><li>
                              <li class="nav-item"><a href="manageUsers.jsp" class="nav-link">Manage Users</a><li>

                                    <%
                                        }
                                    %>
                              <li class="nav-item"><a href="viewProfile.jsp" class="nav-link">Profile</a></li>
                              <li class="nav-item">
                                    <ul id="nav">
                                          <li id="notification_li">
                                                <a href="#" id="notificationLink" class="nav-link">Notifications</a>

                                                <span id="notification_count"> </span>

                                                <div id="notificationContainer">

                                                      <div id="notificationTitle">Notifications</div>

                                                      <div id="notificationsBody" class="notifications">

                                                            <table id="notifications">

                                                            </table>

                                                      </div>

                                                      <div id="notificationFooter"><a href="#">See All</a></div>
                                                </div>
                                          </li>
                                    </ul>
                              </li>
                              <form action="logout">
                                    <button type="submit" value="Logout" class="btn  btn-dark">Logout</button>
                              </form>
                        </ul>
                  </div>
            </nav>
            <div class="container">
                  <br><br>

                  <div id="users">

                  </div>
                  <form action="changePassword" style="display:none;" class="form-horizontal"  id="passwordform">
                        <input type="password" value="" id="passwordtext" name="password" placeholder="Enter new password here" class="form-control"><br>
                        <input type="hidden" id="userID" name="userID" value="">
                        <button id="savebtn" class="btn btn-dark form-control"> Change Password</button>
                  </form>

            </div>
      </body>
</html>
