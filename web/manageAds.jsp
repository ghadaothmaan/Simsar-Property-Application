<%-- 
    Document   : manageAds
    Created on : Dec 13, 2017, 5:14:17 PM
    Author     : menna
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
                    // TO DO - WHEN CLOSE IS CLICKED - REMOVE AD SERVLET THEN REMOVE FROM DIV OR WHATEVER
                    // TO DO - WHEN SUSPEND IS CLICKED - SUSPEND AD AND ICON CHANGES
                    $(document).on('click', '#remove-btn', function () {
                        var id = $(this).val();
                        $.get("removeAd", "adID=" + id, function () {
                            $("#row" + id).remove();
                        });
                        console.log("hello");
                    });
                    $(document).on('click', '#suspend-btn', function () {
                        var id = $(this).val();
                        var btn = $(this);
                        $.get("suspendAd", "adID=" + id, function () {
                            //    $("#icon" + id).removeClass("fa-pause");
                            // $(btn).append("<span class='fa fa-play'></span>")
                            //  $("#icon" + id).addClass("fa-play");
                            console.log(btn.text());
                            btn.text("Activate");
                            btn.attr("id", "activate-btn");
                        });
                        console.log("hello");
                    });
                    $(document).on('click', '#activate-btn', function () {
                        var id = $(this).val();
                        var btn = $(this);
                        $.get("activateAd", "adID=" + id, function () {
                            //   $("#icon" + id).removeClass("fa-play");
                            // $("#icon" + id).addClass("fa-pause");
                            btn.text("Suspend");
                            btn.attr("id", "suspend-btn");
                        });
                        console.log("hello");
                    });
                    $.get("getAllAds", null, function (data) {
                        for (var i = 0; i < data.length; i++) {
                            if (data[i]["active"] === 1) // active 
                                $("#ads").append("<div class='row' id='row" + data[i]["adsID"] + "'><div class='col'><a href='viewAd.jsp?ID=" + data[i]["adsID"] + "'>" + data[i]["title"] + "</a></div><div class='col'><button id='remove-btn' name='adID' value='" + data[i]["adsID"] + "'class='btn btn-sm btn-outline-secondary'><span class='fa fa-times'></span>Remove</button></div><div class='col'><button id='suspend-btn' name = 'adID' value ='" + data[i]["adsID"] + "'class='btn btn-sm btn-outline-secondary'><span id='icon" + data[i]["adsID"] + "'></span>Suspend</button></div></div><br>");
                            else
                                $("#ads").append("<div class='row' id='row" + data[i]["adsID"] + "'><div class='col'><a href='viewAd.jsp?ID=" + data[i]["adsID"] + "'>" + data[i]["title"] + "</a></div><div class='col'><button id='remove-btn' name='adID' value='" + data[i]["adsID"] + "'class='btn btn-sm btn-outline-secondary'><span class='fa fa-times'></span>Remove</button></div><div class='col'><button id='activate-btn' name = 'adID' value ='" + data[i]["adsID"] + "'class='btn btn-sm btn-outline-secondary'><span id='icon" + data[i]["adsID"] + "'></span>Activate</button></div></div><br>");
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
                              <!--<li class="nav-item"><a href="logout" class="nav-link">Logout</a></li>-->
                        </ul>
                  </div>
            </nav>
            <div class="container">
                  <br><br>

                  <div id="ads">

                  </div>
            </div>
      </body>
</html>
