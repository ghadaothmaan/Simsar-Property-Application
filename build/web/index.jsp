<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.css">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <title>Sign In</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container">
                <a class="navbar-brand" href="#">Simsar</a>
            </div>
        </nav>
        <br><br>
        <div class="container">

            <form action="signIn" method="post" class="form-horizontal">
                <div class="form-group">
                    <input type="text" name="username"class="form-control" placeholder="Username">
                </div>
                <div class="form-group">
                    <input type="password" name="password" class="form-control" placeholder="Password">
                </div>
                <% if (request.getAttribute("message") != null) {
                %>
                <div class="alert alert-danger">
                    <strong>Oh snap!</strong> Invalid username or password :(
                </div> 
                <%
                    }
                %>
                <button type="submit" value="Sign In" class="btn btn-dark form-control">Sign In</button><br><br>
                <div class="form-group">
                    <a href="signUp.jsp"><button type="button" class="btn btn-outline-secondary form-control">Sign Up</button></a>

                </div>
            </form>
        </div>
    </body>
</html>
