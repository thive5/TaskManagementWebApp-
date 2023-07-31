<%--
  Created by IntelliJ IDEA.
  User: thive
  Date: 7/31/2023
  Time: 1:10 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>createTask.jsp</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container d-flex justify-content-center align-items-center">
    <div class="card p-3 w-50 mx-auto my-auto">
        <h1 class="text-center">Create new task</h1>
        <form id="createTaskForm" action="CreateTaskServlet" method="post">
            <div class="mb-3">
                <div class="form-group">
                    <label for="title" class="form-label">Title</label>
                    <input type="text" class="form-control ${titleError != null ? 'is-invalid' : ''}"
                           id="title" name="title" value="${title}" aria-describedby="titleError">
                    <div id="titleError"
                         class="invalid-feedback">${titleError != null ? 'Please provide a title' : ''}</div>
                </div>
            </div>
            <div class="mb-3">
                <div class="form-group">
                    <label for="description" class="form-label">Description:</label>
                    <input type="text" class="form-control ${descriptionError != null ? 'is-invalid' : ''}"
                           id="description" name="description" value="${description}"
                           aria-describedby="descriptionError">
                    <div id="descriptionError"
                         class="invalid-feedback">${descriptionError != null ? 'Please provide a description' : ''}</div>
                </div>
            </div>
            <div class="mb-3">
                <div class="form-group">
                    <label for="duedate" class="form-label">Due Date:</label>
                    <input type="date" class="form-control ${deudateError != null ? 'is-invalid' : ''}"
                           id="duedate" name="duedate" value="${deudate}" aria-describedby="deudateError">
                    <div id="duedateError"
                         class="invalid-feedback">${duedateError != null ? 'Please provide a DeuDate' : ''}</div>
                </div>
            </div>
            <div class="mb-3">
                <label for="status" class="form-label">Status:</label>
                <input type="text" class="form-control" id="status" name="status" value="pending" readonly>
            </div>
            <div class="mb-3">
                <label for="priority" class="form-label">Priority:</label>
                <select class="form-select ${priorityError != null ? 'is-invalid' : ''}"
                        id="priority" name="priority" aria-describedby="priorityError">
                    <option selected disabled>Select Priority</option>
                    <option value="high">high</option>
                    <option value="medium">medium</option>
                    <option value="low">low</option>
                </select>
                <div id="priorityError"
                     class="invalid-feedback">${priorityError != null ? 'Please select a priority' : ''}</div>
            </div>
            <div class="mb-3 text-center">
                <button type="submit" class="btn btn-primary">Create Task</button>
                <a href="DashboardServlet" class="btn btn-danger">Close</a>
            </div>
        </form>
    </div>
</div>

</body>
</html>
