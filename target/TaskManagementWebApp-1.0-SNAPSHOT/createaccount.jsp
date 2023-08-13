<%--
  Created by IntelliJ IDEA.
  User: thive
  Date: 8/13/2023
  Time: 12:05 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Create New Account</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://kit.fontawesome.com/106fca075c.js" crossorigin="anonymous"></script>

    <!-- Include the Font Awesome library -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f8f9fa;
        }

        .createAccount-container {
            width: 350px;
            padding: 16px;
            background-color: white;
            border-radius: 4px;
            box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, 0.1);
            border: 2px solid black;
        }

        .register-link {
            text-align: center; /* Center the text */
            margin-top: 20px; /* Add some space above the link */
        }

        .register-link a {
            color: #007BFF; /* Bootstrap primary color for the link */
            text-decoration: none; /* Remove underline */
        }

        .register-link a:hover {
            text-decoration: underline; /* Add underline on hover */
        }

        #error {
            color: red;
            font-size: 1em;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="createAccount-container">
    <h2 class="text-center">Create New Account</h2>
    <form id="createAccountForm" action="CreateAccountServlet" method="post">
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" class="form-control" id="username" name="username" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" class="form-control" id="password" name="password" required>
            <div id="error"></div>
        </div>
        <div class="text-center">
            <button type="submit" class="btn btn-primary btn-block mt-3">Create Account</button>
        </div>
    </form>
    <div class="register-link">
        <a href="loginpage.jsp">Back to login page!</a>
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
