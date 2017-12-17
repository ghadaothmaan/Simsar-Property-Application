<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.css">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <title>Edit User Ad</title>
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
                for (var p = address.length - 1; p >= 0; p--) {
                    for (var t = 0; t < address[p].types.length; t++) {
                        if (address[p].types[t] == "administrative_area_level_1") {
                            document.getElementById('administrative_area_level_1').value = address[p].long_name;
                        }
                        if (address[p].types[t] == "administrative_area_level_2") {
                            document.getElementById('administrative_area_level_2').value = address[p].long_name;
                        }
                        if (address[p].types[t] == "country") {
                            document.getElementById('country').value = address[p].long_name;
                        }
                    }
                }
            }


        </script>
        <script async defer
                src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBN-fQHoonOOopc67XWJqebcZJTb6GqX3w&callback=initMap">
        </script>

        <%
            //ToDo: get photos of ad

            // getting userID from application scope (stored in sign in page)
            //Integer id = (Integer) application.getAttribute("userID");
            Integer id = (Integer) request.getSession().getAttribute("userID");

            //get ID for ad to get the ad details
            String adID = request.getParameter("ID");
            String title = "", rentsell = "", size = "", description = "",
                    floor = "", status = "", type = "", publishDate = "",
                    name = "", email = "", phone = "", city = "", region = "", country = "";

            Integer price = 0, userID = 0;
            Double mapLat = 0.0, mapLng = 0.0;
            float rate = 0;

            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/ia-db", "root", "root");
            PreparedStatement statement = connection.prepareStatement("SELECT * FROM advertisement WHERE userID = ? AND adsID = ?");
            statement.setString(1, id.toString());
            statement.setString(2, adID);
            ResultSet result = statement.executeQuery();
            
            session.setAttribute("adID", adID);
            
            while (result.next()) {
                title = result.getString("title");
                userID = result.getInt("userID");
                rentsell = result.getString("rentsell");
                size = result.getString("size");
                description = result.getString("description");
                floor = result.getString("floor");
                status = result.getString("status");
                type = result.getString("type");
                publishDate = result.getString("publishDate");
                price = result.getInt("price");
                mapLat = result.getDouble("mapLat");
                mapLng = result.getDouble("mapLng");
                rate = result.getFloat("rate");
                city = result.getString("city");
                region = result.getString("region");
                country = result.getString("country");

            }
        %>


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
                    <%
                        }
                    %>
                    <li class="nav-item"><a href="viewProfile.jsp" class="nav-link">Profile</a></li>
                    <form action="logout">
                        <button type="submit" value="Logout" class="btn  btn-dark">Logout</button>
                    </form>
                    <!--<li class="nav-item"><a href="logout" class="nav-link">Logout</a></li>-->
                </ul>
            </div>
        </nav>
        <br><br>
       
        <div class="container">
            <h1>Edit My Ad</h1>
            <div class="row">
                <div class="col">
                    <form action="uploadAdImages" method="post" enctype="multipart/form-data" class="form-horizontal">
                        photos:
                        <input type="file" name="image" class="form-control" multiple/> <br>
                        <input type="submit" value="Upload" class="btn btn-dark"/>  
                        <input type="hidden" name ="adID" value="<%=adID%>">
                    </form>
                    
                    <form action = "UpdateUserAd" method ="POST" class="form-horizontal">
                        <br>
                        Title:
                        <input type="text" name="title" value="<%=title%>" class="form-control">
                        <br>
                        Description:
                        <input type="text" name="description" value="<%=description%>" class="form-control">
                        <br>
                        Status:
                        <select name="status" class="form-control" required>
                            <option value="<%=status%>"><%=status%></option> 
                            TO DO MAKE STATUS DEFAULT
                            <option value="" selected disabled hidden>Choose...</option>
                            <option value="finished">Finished</option>
                            <option value="semi-finished">Semi-Finished</option>
                            <option value="unfinished">Unfinished</option>
                        </select>
                        <br>              
                        Type: 
                        <select name="type" required class="form-control" required>
                            <option value="" selected disabled hidden>Choose...</option>
                            <option value="studio">Studio</option>
                            <option value="villa">Villa</option>
                            <option value="apartment">Apartment</option>
                        </select>
                        <br>
                        size:
                        <input type="text" name="size" value="<%=size%>" class="form-control">
                        <br>
                        floor:
                        <input type="text" name="floor" value="<%=floor%>" class="form-control">
                        <br>                      
                        Rent/Sale:
                        <select name="rentOrsell" required class="form-control">
                            <option value="" selected disabled hidden>Choose...</option>
                            <option value="rent">Rent</option>
                            <option value="sell">Sell</option>
                        </select>
                        <br>
                        price:
                        <input type="number" name ="price" value="<%=price%>" class="form-control">
                        <br>
                        latitude:
                        <input type='text' id='lat' name='map_lat' value="<%=mapLat%>" class="form-control">
                        <br>
                        longitude:
                        <input type='text' id='lng' name = 'map_lng' value="<%=mapLng%>" class="form-control">
                        <br>
                        Country:
                        <input type="text" id="administrative_area_level_2" name="country" value="<%=country%>" class="form-control">
                        <br>
                        City:
                        <input type="text" id="administrative_area_level_1" name="city" value="<%=city%>" class="form-control">
                        <br>
                        Region:
                        <input type="text" id="administrative_area_level_2" name="region" value="<%=region%>" class="form-control">
                        <br>
                        
                        <input type="hidden" name ="adID" value="<%=adID%>">
                        <input type="hidden" id="formatted_address">
                        
                        <br><br>  <button type="submit" name="save" value = "save" class="btn btn-dark">Save</button>
                        <br><br>

                    </form>
                        
                
                <div class="col">
                    <div id='map'></div>                  
                    <div id='current'></div>
                </div>
            </div>
        </div>
    </body>
</html>
