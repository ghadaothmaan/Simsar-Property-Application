<%-- 
    Document   : editProfile
    Created on : Dec 2, 2017, 10:26:50 PM
    Author     : Salma-Hassan
--%>

<%@page import="database.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
      <head>
            <link href="css/notifcss.css" rel="stylesheet" type="text/css"/>
            <link rel="stylesheet" type="text/css" href="css/bootstrap.css">
            <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">

            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Profile</title>
      </head>
      <body>
            <%
                session = request.getSession();
                User user = (User) session.getAttribute("user");
                System.out.println("hellooooo ahlan " + user.name);
            %>
            <script src="http://code.jquery.com/jquery-latest.min.js"></script>
            <script>
                $(document).ready(function () {
                    $.get("getUserNotifications", null, function (data) {
                        for (var i = 0; i < data.length; i++) {
                            $("#notifications").append("<tr><td><a href='getNotification?ID=" + data[i]["notificationID"] + "'>"
                                    + data[i]["notification"] + " </a></td></tr>");
                        }
                        $('#notification_count').text(data.length);
                    });
                    $("#notificationLink").click(function () {
                        $("#notificationContainer").fadeToggle(300);
                        $("#notification_count").fadeOut("slow");
                        return false;
                    });
                    //document click hiding the popup 
                    $(document).click(function () {
                        $("#notificationContainer").hide();
                    });
                    //popup on click
                    $("#notificationContainer").click(function () {
                        return false;
                    });
                    $("#notificationsBody").click(function () {
                        window.location = $(this).find("a").attr("href");
                        return false;
                    });
                });
            </script>

            <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                  <div class="container">
                        <a class="navbar-brand" href="#">Simsar</a>
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
                              <li class="nav-item"><a href="manageAds.jsp" class="nav-link">Manage Ads</a><li>
                              <li class="nav-item"><a href="manageUsers.jsp" class="nav-link">Manage Users</a><li>
                                    <%
                                        }
                                    %>
                              <li class="nav-item active"><a href="viewProfile.jsp" class="nav-link">Profile</a></li>
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
                              <!--<li class="nav-item"><a href="logout" class="nav-link">Logout</a></li>-->
                        </ul>
                  </div>
            </nav>

            <div class="container">
                  <%
                      String status = (String) request.getAttribute("status");
                      if (status != null) {
                          if (status == "nopassword") {
                  %>
                  <br>
                  <div class="alert alert-danger">
                        <strong>Oh snap!</strong> Please enter your old password!
                  </div> 
                  <%
                  } else if (status == "wrongpassword") {
                  %>
                  <br>
                  <div class="alert alert-danger">
                        <strong>Oh snap!</strong> Wrong password :(
                  </div> 
                  <%
                          }
                      }
                  %>
                  <br><h1>Hello, <%=user.name%>!</h1>

                  <div class="row">
                        <div class="col">
                              <form action="uploadUserImage" method="post" enctype="multipart/form-data" class="form-horizontal">
                                    <img src="getUserPhoto?ID=<%=user.id%>"  height=150 width=150 class='img-circle'><br><br>
                                    <input type="file" name="image" class="form-control"/> <br>
                                    <input type="submit" value="Upload" class="btn btn-dark"/>  
                                    <input type="hidden" name ="ID" value="<%=user.id%>">
                              </form>

                              <form action = "updateProfile" method = "POST" class="form-horizontal"> <br>
                                    Name: <input type="text" name="name" value="<%=user.name%>" class="form-control"><br>
                                    Email: <input type="email" name="email" value="<%=user.email%>" class="form-control" readonly><br>

                                    Old Password: <input type="password" name="oldpassword" class="form-control" ><br>
                                    <input type="hidden" name="password" class="form-control" value="<%=user.password%>" >
                                    <%-- TODO verify old password matches user.password --%>
                                    New Password: <input type="password" name="newpassword" class="form-control"><br>
                                    Address: <input type="text" name="address" value="<%=user.address%>" class="form-control"><br>
                                    Phone No: <input type="number" name="phone" value="<%=user.phone%>" class="form-control"><br>
                                    <br> <button type="submit" name="Update" value = "Update" class="btn btn-dark">Update</button>
                                    <br><br><br>
                              </form>
                        </div>
                  </div>
            </div>
      </body>
</html>
