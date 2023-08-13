<%--
  Created by IntelliJ IDEA.
  User: thive
  Date: 8/13/2023
  Time: 6:14 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>LoginPage</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

    <style>
        body {
            overflow: auto;
            height: 100vh;
        }

        .main-container {
            display: flex;
            flex-direction: column; /* Stack children vertically */
            justify-content: center;
            align-items: center;
            min-height: 100vh; /* Ensure it takes at least the full height of the viewport */
            padding: 20px; /* Add some padding to prevent content from touching the edges */
        }


        .login-container {
            width: auto;
            padding: 16px;
            background-color: white;
            border-radius: 4px;
            box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, 0.1);
            border: 2px solid black;
            margin: 20px;
        }

        /* Container for the alert */
        .alert-container {
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .register-link {
            text-align: center;
            margin-top: 20px;
        }

        .register-link a {
            color: #007BFF;
            text-decoration: none;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        #error {
            color: red;
            font-size: 1em;
            text-align: center;
        }


    </style>
</head>
<body>
<div class="main-container">
    <%
        String accountCreatedMessage = (String) session.getAttribute("accountCreated");
        if (accountCreatedMessage != null) {
    %>
    <div class="alert-container">
        <div class="alert alert-success text-center">
            <%= accountCreatedMessage %>
            <h1 style="color: green;">Account created successfully!</h1>
            <h3 style="color: black;">Login using with your new account</h3>
        </div>
    </div>
    <% session.removeAttribute("accountCreated"); // remove the attribute after displaying
    }
    %>

    <div class="login-container">
        <h2 class="text-center">Login</h2>
        <form action="LoginServlet" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" class="form-control" id="password" name="password" required>
                <!--            show incorrect username and password form validation error-->
                <div id="error"></div>
            </div>
            <div class="text-center">
                <button type="submit" class="btn btn-primary btn-block mt-3">Login</button>
            </div>
        </form>
        <div class="register-link">
            <p>Don't have an account? <a href="createaccount.jsp">Create New Account</a></p>
        </div>
    </div>

</div>
<script>
    $(document).ready(function () {
        $.get('GetSessionServlet', function (responseText) {
            if (responseText !== "") {
                $('#error').text(responseText);
            }
        });
    });
</script>
</body>
</html>
