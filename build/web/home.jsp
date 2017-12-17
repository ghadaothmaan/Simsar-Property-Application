<%-- 
    Document   : home
    Created on : Nov 29, 2017, 3:21:38 PM
    Author     : Abeer Ahmed
--%>

<%@page import="java.sql.Statement"%>
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
            <title>Home Page</title>

            <script src="http://code.jquery.com/jquery-latest.min.js"></script>
            <script>
                $(document).ready(function () {
                    $.get("getActiveAds", null, function (data) {
                        for (var i = 0; i < data.length; i++) {
                            $("#ads").append("<tr><td><a href='viewAd.jsp?ID=" + data[i]["adsID"] + "'>" + data[i]["title"] + " </a> </td><td>Rate: " + data[i]["rate"] + "</td></tr>");
                        }
                    });

                    $.get("getCountries", null, function (data) {

                        for (var i = 0; i < data.length; i++) {
                            var option = new Option(data[i], data[i]);
                            $("#country").append($(option));
                        }
                    });
                    $("#country").change(function () {
                        $("#city").empty();
                        $("#city").append("<option value='' selectedn>Choose...</option>");
                        console.log($(this).serialize());
                        $.get("getCities", $(this).serialize(), function (data) {
                            for (var i = 0; i < data.length; i++) {
                                var option = new Option(data[i], data[i]);
                                $("#city").append($(option));
                            }
                        });
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

      </head>
      <body>
            <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                  <div class="container">
                        <a class="navbar-brand" href="home.jsp">Simsar</a>
                        <ul class="navbar-nav mr-auto">
                              <li class="nav-item-active" class="nav-item"><a href="home.jsp" class="nav-link">Home</a></li>
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
                  <br>
                  <br>
                  <form action="search">
                        <div class="row">
                              <div class="col">
                                    Type: <select name="type" class="form-control">
                                          <option value="" selected>Choose...</option>
                                          <option value="apartment">Apartment</option>
                                          <option value="studio">Studio</option>
                                          <option value="villa">Villa</option>
                                    </select>
                              </div>
                              <div class="col">
                                    Rent/Sale: <select name="rentOrsell" class="form-control">
                                          <option value="" selected>Choose...</option>
                                          <option value="rent">Rent</option>
                                          <option value="sell">Sale</option>
                                    </select>
                              </div>
                              <div class="col">
                                    Status: <select name="status" class="form-control">
                                          <option value="" selected>Choose...</option>
                                          <option value="finished">Finished</option>
                                          <option value="semi-finished">Semi-Finished</option>
                                          <option value="unfinished">Unfinished</option>
                                    </select>
                              </div>
                              <div class="col">
                                    Price: From: <input type="number" name="priceFrom" class="form-control"> To: <input type="number" name="priceTo" class="form-control">
                              </div>
                              <div class="col">
                                    Size From:
                                    <input type="number" name="sizeFrom" class="form-control"> To: <input type="number" name="sizeTo" class="form-control"><br>
                              </div>
                              <div class="col">
                                    Country: <select id="country" name="country" class="form-control">
                                          <option value="" selected>Choose...</option>
                                    </select>
                              </div>
                              <div class="col">
                                    City: <select id="city" name="city" class="form-control">
                                          <option value="" selectedn>Choose...</option>
                                    </select> 
                              </div>
                              <div class="col">
                                    <button type="submit" value="search" class="btn btn-dark">search</button>
                                    <br><br>
                                    <button value="alert" id="alert-btn" class="btn btn-dark">alert!</button>
                              </div>
                        </div>
                  </form>

                  <table id="ads" class="table table-light">
                  </table>
            </div>
      </body>
</html>
