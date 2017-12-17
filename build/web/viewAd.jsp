<%-- 
    Document   : viewAd
    Created on : Dec 6, 2017, 1:15:37 AM
    Author     : Bayan
--%>

<%@page import="database.User"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
      <head>
            <link rel="stylesheet" type="text/css" href="css/font-awesome.css">
            <link rel="stylesheet" type="text/css" href="css/bootstrap.css">
            <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
            <script async defer
                    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBN-fQHoonOOopc67XWJqebcZJTb6GqX3w">
            </script>
            <%
                String adID = request.getParameter("ID");
                Integer userID = (Integer) session.getAttribute("userID");
            %>
            <script src="js/jquery-latest.min.js"></script>
            <script src="http://code.jquery.com/jquery-latest.min.js"></script>

            <script>
                        $(document).ready(function () {
                            var param = "ID=" +<%=adID%>;
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
                                }
                                initMap(data["mapLat"], data["mapLng"]);
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
                        center: new google.maps.LatLng(lat, long),
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

      <body>
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
                                    <%
                                        }
                                    %>
                              <li class="nav-item"><a href="viewProfile.jsp" class="nav-link">Profile</a></li>
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


                  <br><br>

                  <div id="name"  style="display:none;" class="answer_list" ></div>
                  <div id="phone"  style="display:none;" class="answer_list" ></div>
                  <div id="email"  style="display:none;" class="answer_list" ></div>
                  <button type="button" name="answer" value="Contact Information" onclick="showDiv()" class="btn btn-outline-dark">Contact Info</button>


                  <form action="addRate" method="POST" class="form-horizontal">
                        your rate: <br>
                        <input type="number" min="0" max="5" name="rate" class="form-control"/>
                        <input type ="hidden" name ="adID" value="<%=adID%>"> <br>
                        <button type="submit" name="submit" class="btn btn-dark">rate</button>
                  </form>


                  <table id="comments" class="table table-striped">

                  </table>
                  <form action="addComment" method = "POST" class="form-horizontal">
                        add a comment: <br>
                        <input type ="text" name ="comment" placeholder="add comment" class="form-control">
                        <input type ="hidden" name ="adID" value="<%=adID%>"> <br>
                        <input type="hidden" name ="userID" value="<%=userID%>">
                        <button type="submit" name ="submit" value="add" class="btn btn-dark">comment </button>
                  </form>

                  <input type="hidden" id="map_lat" value="">
                  <input type="hidden" id="map_lng" value="">

            </div>

      </body>
</html>
