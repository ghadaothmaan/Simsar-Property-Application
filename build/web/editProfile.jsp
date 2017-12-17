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
                                    <%
                                        }
                                    %>
                              <li class="nav-item active"><a href="viewProfile.jsp" class="nav-link">Profile</a></li>
                              <form action="logout">
                                    <button type="submit" value="Logout" class="btn  btn-dark">Logout</button>
                              </form>
                              <!--<li class="nav-item"><a href="logout" class="nav-link">Logout</a></li>-->
                        </ul>
                  </div>
            </nav>

            <div class="container">
                  <h1>Hello, <%=user.name%>!</h1>
                  <img src="<%=user.picture%>" height="150" width="150"/>

                  <div class="row">
                        <div class="col">
                              <form action = "updateProfile" method = "POST" class="form-horizontal"> <br><br>
                                    <input type="file" value ="upload" name = "picture" class="form-control"> <br>
                                    Name: <input type="text" name="name" value="<%=user.name%>" class="form-control"><br>
                                    Email: <input type="email" name="email" value="<%=user.email%>" class="form-control" readonly><br>
                                    Old Password: <input type="password" name="oldpassword" class="form-control"><br>
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
