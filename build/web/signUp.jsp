<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
    <head>
          <link href="css/notifcss.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.css">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <title>Sign Up</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script>
            $(document).ready(function () {
                $("#username").change(function () {
                    console.log($(this).serialize());
                    var password = document.getElementById("password").value;
                    var password2 = document.getElementById("password2").value;
                    console.log($("#email"));
                    $.get("validateUserInput", $(this).serialize() + "&email=" + document.getElementById("email").value, function (data) {  // ajax code :D
                        if (!data.validUsername) {
                            $("#username-msg").text("Username already taken :(");
                            $("#username-msg").addClass("alert alert-danger");
                            $("#submit-btn").attr('disabled', 'disabled');
                        } else {
                            $("#username-msg").text("");
                            $("#username-msg").removeClass("alert alert-danger");
                        }
                        console.log(data);
                        if (data.validUsername && data.validEmail && password === password2) {
                            $("#submit-btn").removeAttr('disabled');
                        }
                    });
                });
                $("#email").change(function () {
                    $.get("validateUserInput", $(this).serialize() + "&username=" + document.getElementById("username").value, function (data) {
                        var password = document.getElementById("password").value;
                        var password2 = document.getElementById("password2").value;
                        console.log(data);
                        if (!data.validEmail) {
                            $("#email-msg").text("Email already registered!");
                            $("#email-msg").addClass("alert alert-danger");
                            $("#submit-btn").attr('disabled', 'disabled');
                        } else {
                            $("#email-msg").text("");
                            $("#email-msg").removeClass("alert alert-danger");
                        }
                        if (data.validUsername && data.validEmail && password === password2) {
                            $("#submit-btn").removeAttr('disabled');
                        }
                    });
                });
                $("#password2").change(function () {
                    console.log($("#password").value); // gives undefined for some reason
                    var password = document.getElementById("password").value;
                    var password2 = document.getElementById("password2").value;
                    if (password != password2) {
                        $("#password-msg").text("Password does not match!");
                        $("#password-msg").addClass("alert alert-danger");
                        $("#submit-btn").attr('disabled', 'disabled');
                    } else {
                        $("#password-msg").text("");
                        $("#password-msg").removeClass("alert alert-danger");
                    }
                    $.get("validateUserInput", "&username=" + document.getElementById("username").value +
                            "&email=" + document.getElementById("email").value, function (data) {
                        console.log("PW: " + $(this).serialize());
                        if (data.validUsername && data.validEmail && password == password2) {
                            $("#submit-btn").removeAttr('disabled');
                        }
                    });
                });
            });
        </script>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container">
                <a class="navbar-brand" href="#">Simsar</a>
            </div>
        </nav>
        <br><br>
        <div class="container">
            <form action="signUp" method="post" class="form-horizontal">
                Name: <input placeholder="Name" type="text" name="name" required class="form-control"><br>
                Username: <input placeholder="Username" type="text" name="username" id="username" required class="form-control">
                <div id="username-msg"></div><br>
                Email: <input placeholder="Email" type="email" name="email" id="email" required class="form-control">
                <div id="email-msg"></div><br>
                Password: <input placeholder="Password" type="password" name="password" id="password" required class="form-control"><br>
                Re-enter Password: <input placeholder="Re-enter Password" type="password" name="password2" id="password2" required class="form-control">
                <div id="password-msg"></div><br>
                
                <input type="submit" value="Sign Up" id="submit-btn" class="btn btn-dark form-control">
            </form>
        </div>
    </body>
</html>
