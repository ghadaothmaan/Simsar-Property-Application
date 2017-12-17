<%-- 
    Document   : searchResult
    Created on : Dec 11, 2017, 3:14:38 PM
    Author     : menna
--%>

<%@page import="database.Ad"%>
<%@page import="javafx.util.Pair"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.css">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
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
                    <!--<li class="nav-item"><a href="logout" class="nav-link">Logout</a></li>-->
                </ul>
            </div>
        </nav>
        <div class="container">
            <br><br>
            <table class="table table-light">
        <%
            ArrayList<Ad> ads = (ArrayList<Ad>) request.getAttribute("ads");
            if (ads.size() == 0) out.println("No ads found");
            for (int i = 0; i < ads.size(); i++) {
                %>
                <tr>
                <td>
                <a href="viewAd.jsp?ID=<%=ads.get(i).adsID%>"><%=ads.get(i).title%></a>
                </td>
                <td>
                    Rate: <%=ads.get(i).rate%>
                </td>
                </tr>
                <%
            }
            %>
            </table>
        </div>
    </body>
</html>
