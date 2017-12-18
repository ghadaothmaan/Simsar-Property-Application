<%-- 
    Document   : addNewAd
    Created on : Dec 3, 2017, 3:41:19 PM
    Author     : Salma-Hassan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
      <head>
            <link rel="stylesheet" type="text/css" href="css/bootstrap.css">
            <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Add New Ad</title>
            <meta charset="UTF-8">
            <!--<meta name="viewport" content="width=device-width, initial-scale=1.0">-->
            <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
            <style>
                  #map {
                      height: 100%;
                  }
                  html, body {
                      height: 50%;
                      margin: 0;
                      padding: 0;
                  }
            </style>

            <script>
                var geocoder;
                function initMap() {
                    console.log("hello?");
                    var myLatLng = {lat: 29.363, lng: 29.880};

                    var map = new google.maps.Map(document.getElementById('map'), {
                        zoom: 4,
                        center: myLatLng
                                //center: marker.position

                    });

                    var marker = new google.maps.Marker({
                        position: myLatLng,
                        map: map,
                        title: 'Hello World!',
                        draggable: true
                    });
                    google.maps.event.addListener(marker, 'dragend', function (evt) {
                        document.getElementById('current').innerHTML = '<p>Marker dropped: Current Lat: ' + evt.latLng.lat().toFixed(3) + ' Current Lng: ' + evt.latLng.lng().toFixed(3) + '</p>';
                        document.getElementById("lat").value = evt.latLng.lat().toFixed(3);
                        document.getElementById("lng").value = evt.latLng.lng().toFixed(3);
                        geocoder = new google.maps.Geocoder();
                        geocoder.geocode({'latLng': evt.latLng}, processRevGeocode);
                    });

                }

                function processRevGeocode(results, status) {

                    if (status == google.maps.GeocoderStatus.OK) {
                        displayPostcode(results[0].address_components);
                        document.getElementById('formatted_address').value = results[0].formatted_address;
                    } else {
                        alert('Geocoder failed due to: ' + status);
                    }
                }

                function displayPostcode(address) {
                    console.log(address);
                    for (var p = address.length - 1; p >= 0; p--) {
                        for (var t = 0; t < address[p].types.length; t++) {
                            if (address[p].types[t] == "country") {
                                document.getElementById('country').value = address[p].long_name;
                            }
                            if (address[p].types[t] == "administrative_area_level_1") {
                                document.getElementById('administrative_area_level_1').value = address[p].long_name;
                            }
                            if (address[p].types[t] == "administrative_area_level_2") {
                                document.getElementById('administrative_area_level_2').value = address[p].long_name;
                            }
                        }
                    }
                }               
            </script>
            <script async defer
                    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBN-fQHoonOOopc67XWJqebcZJTb6GqX3w&callback=initMap">
            </script>

      </head>

      <body>
            <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                  <div class="container">
                        <a class="navbar-brand" href="home.jsp">Simsar</a>
                        <ul class="navbar-nav mr-auto">
                              <li class="nav-item"><a href="home.jsp" class="nav-link">Home</a></li>
                              <li class="active nav-item"><a href="viewUserAds.jsp" class="nav-link">My Ads</a></li>
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
                              <form action="logout">
                                    <button type="submit" value="Logout" class="btn  btn-dark">Logout</button>
                              </form>
                        </ul>
                  </div>
            </nav>
            <br><br>
            <div class="container">
                  <h1>Add New Advertisement</h1>
                  <div class="row">
                        <div class="col">
                              <form action = "addNewAd" method ="POST" class="form-horizontal"><br>
                                    Title:
                                    <input type="text" name="title" class="form-control"><br>
                                    Description:
                                    <input type="text" name="description"  class="form-control"><br>
                                    Status:
                                    <select name="status" class="form-control" required>
                                          <option value="" selected disabled hidden>Choose...</option>
                                          <option value="finished">Finished</option>
                                          <option value="semi-finished">Semi-Finished</option>
                                          <option value="unfinished">Unfinished</option>
                                    </select><br>              
                                    Type: 
                                    <select name="type" required class="form-control" required>
                                          <option value="" selected disabled hidden>Choose...</option>
                                          <option value="studio">Studio</option>
                                          <option value="villa">Villa</option>
                                          <option value="apartment">Apartment</option>
                                    </select><br>
                                    Size:
                                    <input type="number" name="size" class="form-control">
                                    <br>
                                    Floor:
                                    <input type="number" name="floor" class="form-control"><br>                      
                                    Rent/Sale:
                                    <select name="rentOrsell" required class="form-control">
                                          <option value="" selected disabled hidden>Choose...</option>
                                          <option value="rent">Rent</option>
                                          <option value="sell">Sell</option>
                                    </select>
                                    <br>
                                    Price:
                                    <input type="number" name ="price" class="form-control"><br>
                                    Latitude:
                                    <input type='text' id='lat' name='map_lat' class="form-control"><br>
                                    Longitude:
                                    <input type='text' id='lng' name = 'map_lng' class="form-control"><br>
                                    <input type="hidden" id="formatted_address" name="address" class="form-control">
                                    Country:
                                    <input type="text" id="country" name="country" class="form-control"><br>
                                    City:
                                    <input type="text" id="administrative_area_level_1" name="city" class="form-control"><br>
                                    Region:
                                    <input type="text" id="administrative_area_level_2" name="region" class="form-control"><br>

                                    <br><br>  <button type="submit" name="save" value = "save" class="btn btn-dark">Save</button>
                                    <br><br>

                              </form>
                        </div>
                        <div class="col">
                              <div id="map"></div>
                              <div id="current"></div> 
                        </div>
                  </div>
            </div>
            <br><br>
      </body>
</html>
