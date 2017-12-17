<%-- 
    Document   : profile
    Created on : Dec 2, 2017, 8:10:28 PM
    Author     : Salma-Hassan and gee othman lol
--%>

<%@page import="database.User"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
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

      <%
          Integer userID = (Integer) session.getAttribute("userID");
          System.out.println("hellooooo " + userID);
      %>
      <script src="js/jquery-latest.min.js"></script>
      <script src="http://code.jquery.com/jquery-latest.min.js"></script>

      <script>
          $(document).ready(function () {
              var param = "ID=" +<%=userID%>;
              $.post("getProfile", param, function (data) {
                  console.log(data);
                  $("#theProfile").text("Hello, " + data["name"]);
                  $("#headTitle").prepend("<img src='getUserPhoto?"+param+"' height='150' width='150' class='img-circle'/><br>");
                  $("#profile").append("<tr><th>Username: </th><td>" + data["username"] + "</td></tr>");
                  $("#profile").append("<tr><th>Email: </th><td>" + data["email"] + "</td></tr>");
                  $("#profile").append("<tr><th>Address: </th><td>" + data["address"] + "</td></tr>");
                  $("#profile").append("<tr><th>Phone:  </th><td>" + data["phone"] + "</td></tr>");
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

      <body>
            <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                  <div class="container">
                        <a class="navbar-brand" href="home.jsp">Simsar</a>
                        <ul class="navbar-nav mr-auto">
                              <li class="nav-item" class="nav-item"><a href="home.jsp" class="nav-link">Home</a></li>
                              <li class="nav-item"><a href="viewUserAds.jsp" class="nav-link">My Ads</a></li>
                        </ul>
                        <ul class="nav navbar-nav navbar-right">
                              <%
                                  session = request.getSession();
                                  Integer admin = (Integer) session.getAttribute("admin");
                                  if (admin == 1) {
                              %>
                              <li class="nav-item"><a href="manageAds.jsp" class="nav-link">Manage Ads</a><li>
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
                  <br><br>
                  <div class="row" id="head">
                        <div class="col" id="headTitle">

                        </div>
                        <div class="col" id="headEdit">

                        </div>
                  </div>
                  <div class="row">
                        <div class="col" class="firstCol">
                              <h1 id="theProfile">Hello,</h1>
                              <table class="table table-light" id="profile">

                              </table>
                        </div>
                  </div>
                  <br><br>

                  <form action="editProfile.jsp">
                        <button type="submit" name="submit" class="btn btn-dark" /> edit profile </button>
                  </form>

            </div>
      </body>

</html>
