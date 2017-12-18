<%-- 
    Document   : viewAd
    Created on : Dec 6, 2017, 1:15:37 AM
    Author     : Bayan
--%>
<%@page import="java.util.ArrayList"%>
<%@page import="database.User"%>
<%@page import="database.Ad"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
      <head>
            <style>
                  .mySlides {display:none}
                  .w3-left, .w3-right, .w3-badge {cursor:pointer}
                  .w3-badge {height:13px;width:13px;padding:0}
            </style>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <script async defer
                    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBN-fQHoonOOopc67XWJqebcZJTb6GqX3w">
            </script>
            <link href="css/notifcss.css" rel="stylesheet" type="text/css"/>
            <link rel="stylesheet" type="text/css" href="css/font-awesome.css">
            <link rel="stylesheet" type="text/css" href="css/bootstrap.css">
            <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
            <link href="css/w3.css" rel="stylesheet" type="text/css"/>

            <%
                String adID = request.getParameter("ID");
                Integer userID = (Integer) session.getAttribute("userID");
                Ad ad = new Ad();
            %>
            <script src="js/jquery-latest.min.js"></script>
            <script src="http://code.jquery.com/jquery-latest.min.js"></script>
      <body>        
            <script>
                        $(document).ready(function () {
                            var param = "ID=" +<%=adID%>;
                            var adID = <%=adID%>;

                            $.post("getAd", param, function (data) {
                                console.log(data);
                                $("#theAd").text(data["title"]);
                                $("#headTitle").prepend("<h1>" + data["title"] + "</h1>");
                                $("#ad").append("<tr><th>Description: </th><td>" + data["description"] + "</td></tr>");
                                //   $("#ad").append("<tr><th>Rate: </th><td>" + data["rate"] + "</td><td><span id='stars'></span></td></tr>");
                                $("#ad").append("<tr><th>Rate: </th><td><span id='stars'></span></td></tr>");
                                $("#ad").append("<tr><th>Rent/Sale: </th><td>" + data["rentsell"] + "</td></tr>");
                                $("#ad").append("<tr><th>Size: </th><td>" + data["size"] + "</td></tr>");
                                $("#ad").append("<tr><th>Floor: </th><td>" + data["floor"] + "</td></tr>");
                                $("#ad").append("<tr><th>Status: </th><td>" + data["status"] + "</td></tr>");
                                $("#ad").append("<tr><th>Type: </th><td>" + data["type"] + "</td></tr>");
                                $("#ad").append("<tr><th>Price:  </th><td>" + data["price"] + "</td></tr>");
                                $("#ad").append("<tr><th>Publish Date:  </th><td>" + data["publishDate"] + "</td></tr>");
                                $("#ad").append("<tr><th>Country:  </th><td>" + data["country"] + "</td></tr>");
                                $("#ad").append("<tr><th>City:  </th><td>" + data["city"] + "</td></tr>");
                                $("#ad").append("<tr><th>Region:  </th><td>" + data["region"] + "</td></tr></table>");
                                $("#map_lat").val(data["mapLat"]);
                                $("map_lng").val(data["mapLng"]);

                                for (var i = 0; i < data["rate"]; i++) { // append full stars
                                    $("#stars").append("<span class='fa fa-star'></span>");
                                }
                                for (var i = 0; i < (5 - data["rate"]); i++) { // append empty stars
                                    $("#stars").append("<span class='fa fa-star-o'></span>");
                                }
                                $.get("getAdUser", "userID=" + data["userID"], function (data) {
                                    $("#name").text("Name: " + data["name"]);
                                    $("#phone").text("Phone: " + data["phone"]);
                                    $("#email").text("Email: " + data["email"]);
                                });
                                $.get("getAdComments", "ID=" + data["adsID"], function (data) {
                                    for (var i = 0; i < data.length; i++) {
                                        $("#comments").append("<tr><td>" + data[i]["key"] + "</td><td>" + data[i]["value"]["key"] + "</td></tr><tr><td>" + data[i]["value"]["value"] + "</td></tr>");
                                    }
                                });
                                if (data["userID"] === <%=userID%>) {
                                    $("#headEdit").prepend("<a href='editUserAd.jsp?ID=<%=adID%>'><button class='btn btn-dark'>Edit Ad</button></a>");
                                    $("#headEdit").prepend("<a href='closeAd?ID=" + adID + "'><button class='btn btn-danger'>Close Ad</button></a>");
                                }
                                initMap(data["mapLat"], data["mapLng"]);
                            });
                            $.get("getAllPhotos", param, function (data) {
                                console.log(data);
                                for (var i = 0; i < data.length; i++) {
                                    $("#slideshow").prepend("<img class='mySlides' src='getAdPhoto?adID=" + adID + "&photoID=" + data[i] + "' width='800' height='400'>");
                                    $("#innerslide").prepend("<span class='w3-badge demo w3-border w3-transparent w3-hover-white' onclick='currentDiv(" + (i + 1) + ")'></span>");
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
                    if (document.getElementById('name').style.display !== "none" &&
                            document.getElementById('phone').style.display !== "none" &&
                            document.getElementById('email').style.display !== "none") {
                        document.getElementById('name').style.display = "none";
                        document.getElementById('phone').style.display = "none";
                        document.getElementById('email').style.display = "none";
                    } else {
                        document.getElementById('name').style.display = "block";
                        document.getElementById('phone').style.display = "block";
                        document.getElementById('email').style.display = "block";
                    }
                }
            </script>
            <script>
                function initMap(lat, long) {
                    geocoder = new google.maps.Geocoder();
                    var myLatLng = {lat: lat, lng: long};
                    var map = new google.maps.Map(document.getElementById('map'), {
                        zoom: 15,
                        center: new google.maps.LatLng(lat, long)
                    });
                    var marker = new google.maps.Marker({
                        position: myLatLng,
                        map: map,
                        title: 'Hello World!'
                    });
                }
                ;
            </script>

            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>view Ad</title>
      </head>

      <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container">
                  <a class="navbar-brand" href="home.jsp">Simsar</a>
                  <ul class="navbar-nav mr-auto">
                        <li class="active" class="nav-item"><a href="home.jsp" class="nav-link">Home</a></li>
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
                        <li class="nav-item"><a href="viewProfile.jsp" class="nav-link">Profile</a></li>
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
            <div class="row" id="head">
                  <div class="col" id="headTitle">

                  </div>
                  <div class="col" id="headEdit">

                  </div>
            </div>

            <!--slideshow for ad photos-->
            <div class="w3-content w3-display-container" style="max-width:800px" id = "slideshow">    
                  <div class="w3-center w3-container w3-section w3-large w3-text-white w3-display-bottommiddle" style="width:100%" id = "innerslide">
                        <div class="w3-left w3-hover-text-khaki" onclick="plusDivs(-1)">&#10094;</div>
                        <div class="w3-right w3-hover-text-khaki" onclick="plusDivs(1)">&#10095;</div>

                  </div>
            </div>

            <br> <br>
            <div class="row">
                  <div class="col" class="firstCol">
                        <h1 id="theAd">Title</h1>
                        <table class="table table-light" id="ad">

                        </table>
                  </div>
                  <div class="col" id="secondCol">
                        <div id="map" style="height: 100%;"></div>
                        <!--<div id="current"></div>-->
                  </div>
            </div>

            <br>

            <button type="button" name="answer" value="Contact Information" onclick="showDiv()" class="btn btn-outline-dark">Contact Info</button><br>
            <br><div id="name"  style="display:none;" class="answer_list" ></div>
            <div id="phone"  style="display:none;" class="answer_list" ></div>
            <div id="email"  style="display:none;" class="answer_list" ></div><br>

            <form action="addRate" method="POST" class="form-horizontal">

                  <input type="number" min="0" max="5" name="rate"placeholder="Rate this advertisement." class="form-control"/>
                  <input type ="hidden" name ="adID" value="<%=adID%>"> <br>
                  <button type="submit" name="submit" class="btn btn-dark">rate</button><br><br>
            </form>

            <form action="addComment" method = "POST" class="form-horizontal">
                  <input type ="text" name ="comment" placeholder="Please add a comment. Note, offensive comments will not be tolerated." class="form-control">
                  <input type ="hidden" name ="adID" value="<%=adID%>"> <br>
                  <input type="hidden" name ="userID" value="<%=userID%>">
                  <button type="submit" name ="submit" value="add" class="btn btn-dark">comment </button><br><br>
            </form>
            <table id="comments" class="table table-striped">

            </table>

            <input type="hidden" id="map_lat" value="">
            <input type="hidden" id="map_lng" value="">

      </div>
      <br><br><br>

</body>

<script>
    var slideIndex = 1;

    showDivs(slideIndex);

    function plusDivs(n) {
        showDivs(slideIndex += n);
    }

    function currentDiv(n) {
        showDivs(slideIndex = n);
    }

    function showDivs(n) {
        var i;
        var x = document.getElementsByClassName("mySlides");
        var dots = document.getElementsByClassName("demo");
        if (n > x.length) {
            slideIndex = 1;
        }
        if (n < 1) {
            slideIndex = x.length;
        }
        for (i = 0; i < x.length; i++) {
            x[i].style.display = "none";
        }
        for (i = 0; i < dots.length; i++) {
            dots[i].className = dots[i].className.replace(" w3-white", "");
        }
        x[slideIndex - 1].style.display = "block";
        dots[slideIndex - 1].className += " w3-white";
    }
</script>
</html>
