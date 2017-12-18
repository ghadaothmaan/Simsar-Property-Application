<%-- 
    Document   : viewUserAds
    Created on : Dec 3, 2017, 2:17:27 PM
    Author     : Salma-Hassan
    ===> SORRY IF THIS FEELS LIKE DIRTY WORK :'D
--%>

<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
      <head>
            <link href="css/notifcss.css" rel="stylesheet" type="text/css"/>
            <link rel="stylesheet" type="text/css" href="css/bootstrap.css">
            <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <%  session = request.getSession();
                Integer id = (Integer) session.getAttribute("userID"); %>
            <script src="http://code.jquery.com/jquery-latest.min.js"></script>
            <script>
                $(document).ready(function () {
                    $.get("getUserAds", null, function (data) {
                        console.log(data); // all attributes of ad are available!
                        if (data.length == 0) {
                            $("#myAds").append("<tr><td><strong>You have no ads yet!</strong></td></tr>");
                        }
                        for (var i = 0; i < data.length; i++) {
                            $("#myAds").append("<tr><td><a href='viewAd.jsp?ID=" + data[i]["adsID"] + "'>" + data[i]["title"] + " </a> </td><td>Rate: " + data[i]["rate"] + "</td></tr>");
                        }
                    }); // added ; 
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
            <title>My Ads</title>
      </head>
      <body>
            <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                  <div class="container">
                        <a class="navbar-brand" href="home.jsp">Simsar</a>
                        <ul class="navbar-nav mr-auto">
                              <li class="nav-item"><a href="home.jsp" class="nav-link">Home</a></li>
                              <li class="nav-item active"><a href="viewUserAds.jsp" class="nav-link">My Ads</a></li>
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
            <br><br>
            <div class="container">
                  <div class="row">
                        <div class="col">
                              <h2>My Ads</h2>
                        </div>
                        <div class="col"></div>
                        <div class="col"></div>
                        <div class="col">
                              <a href="addNewAd.jsp"><button type="button" class="btn btn-dark">Add new ad</button></a>
                        </div>
                  </div>
                  <br><br>
                  <div class="row">
                        <br><br>
                        <table id="myAds" class="table table-light">

                        </table>
                  </div>


            </div>
      </body>
</html>
