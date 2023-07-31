<%@ page import="com.example.taskmanagementwebapp.model.entity.Todotask" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.taskmanagementwebapp.model.entity.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>dashboard.jsp</title>
    <link rel="stylesheet" type="text/css" href="css/dashboardjsp.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container-fluid bg-primary" id="main-container">
    <div class="row text-center">
        <div class="col-6">
            <%
                User user = (User) session.getAttribute("user");
                if (user != null) {
            %>
            <h2>Welcome to your dashboard, <%= user.getUsername() %>!</h2>
            <%
                }
            %>
        </div>
        <div class="col-4">
            <p>Search bar </p>
        </div>
        <div class="col-2">
            <p>Log out button </p>
        </div>
    </div>
</div>

<div class="container-fluid bg-primary" style="--bs-bg-opacity: .5;">
    <div class="row justify-content-evenly">
        <div class="col-2 d-flex align-items-center justify-content-center">
            <button type="button" class="btn btn-warning btn-lg">Completed</button>
        </div>
        <div class="col-2 d-flex align-items-center justify-content-center">
            <button type="button" class="btn btn-warning btn-lg">Pending</button>
        </div>
        <div class="col-2 d-flex align-items-center justify-content-center">
            <button type="button" class="btn btn-warning btn-lg">Button 3</button>
        </div>
        <div class="col-2 d-flex align-items-center justify-content-center">
            <button type="button" class="btn btn-warning btn-lg">Button 4</button>
        </div>
    </div>
</div>
<div class="container d-flex justify-content-center border-primary">
    <button type="button" class="btn btn-dark" onclick="openCreateTaskModal()">Create New Task</button>
    <button type="button" class="btn btn-primary" onclick="window.location.href='createTask.jsp'">Create New Task</button>
</div>

<div class="container d-flex justify-content-center border-primary">
    <c:choose>
        <c:when test="${empty tasksList}">
            <p>No tasks found.</p>
        </c:when>
        <c:otherwise>
            <table class="table table-striped table-hover m-3">
                <thead class="table-dark">
                <tr>
                    <th scope="col">#</th>
                    <th scope="col">Title</th>
                    <th scope="col">Description</th>
                    <th scope="col">Due Date</th>
                    <th scope="col">Status</th>
                    <th scope="col">Priority</th>
                    <th scope="col">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="task" items="${tasksList}" varStatus="status">
                    <tr>
                        <td>${status.count}</td>
                        <td><c:out value="${task.title}"/></td>
                        <td><c:out value="${task.description}"/></td>
                        <td><fmt:formatDate value="${task.duedate}" pattern="yyyy-MM-dd"/></td>
                        <td><c:out value="${task.status}"/></td>
                        <td><c:out value="${task.priority}"/></td>
                        <td>
                            <button type="button" class="btn btn-primary"
                                    onclick="openUpdateTaskModal(${task.id}, '${task.title}', '${task.description}', '${task.duedate}', '${task.status}', '${task.priority}')">
                                Update
                            </button>
                            <button type="button" class="btn btn-danger">Remove</button>
                            <button type="button" class="btn btn-success">Completed</button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>
<!-- Create Task Modal -->
<div class="modal fade" id="createTaskModal" tabindex="-1" aria-labelledby="createTaskModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="createTaskModalLabel">Create Task</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="createTaskForm" action="CreateTaskServlet" method="post">
                    <div class="mb-3">
                        <label for="title">Title:</label>
                        <input type="text" class="form-control" id="title" name="title" required>
                        <div class="error-message">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">Description:</label>
                        <input type="text" class="form-control" id="description" name="description" required>
                        <div class="error-message">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="duedate" class="form-label">Due Date:</label>
                        <input type="date" class="form-control" id="duedate" name="duedate" required>
                        <div class="error-message">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="status" class="form-label">Status:</label>
                        <input type="text" class="form-control" id="status" name="status" value="pending" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="priority" class="form-label">Priority:</label>
                        <select class="form-select" id="priority" name="priority" required>
                            <option selected disabled>Open this select menu</option>
                            <option value="high">high</option>
                            <option value="medium">medium</option>
                            <option value="low">low</option>
                        </select>
                        <div class="error-message">
                            Please select priority
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary"
                        onclick="document.getElementById('createTaskForm').submit();">Create Task
                </button>
            </div>
        </div>
    </div>
</div>


<!-- Update Task Modal -->
<div class="modal fade" id="updateTaskModal" tabindex="-1" aria-labelledby="updateTaskModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="updateTaskModalLabel">Update Task</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="updateTaskForm" action="UpdateTaskServlet" method="post">
                    <input type="hidden" id="updateTaskId" name="id">
                    <div class="mb-3">
                        <label for="updateTitleId">Title:</label>
                        <input type="text" class="form-control" id="updateTitleId" name="title">
                    </div>
                    <div class="mb-3">
                        <label for="updateDescriptionId" class="form-label">Description:</label>
                        <input type="text" class="form-control" id="updateDescriptionId" name="description">
                    </div>
                    <div class="mb-3">
                        <label for="updateDuedateId" class="form-label">Due Date:</label>
                        <input type="date" class="form-control" id="updateDuedateId" name="duedate">
                    </div>
                    <div class="mb-3">
                        <label for="updateStatusId" class="form-label">Status:</label>
                        <select class="form-select" id="updateStatusId" name="status">
                            <option selected disabled>Open this select menu</option>
                            <option value="pending">pending</option>
                            <option value="completed">completed</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="updatePriorityId" class="form-label">Priority:</label>
                        <select class="form-select" id="updatePriorityId" name="priority">
                            <option selected disabled>Open this select menu</option>
                            <option value="high">high</option>
                            <option value="medium">medium</option>
                            <option value="low">low</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary"
                        onclick="document.getElementById('updateTaskForm').submit();">Save changes
                </button>
            </div>
        </div>
    </div>
</div>


<script src="https://code.jquery.com/jquery-3.1.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js"></script>
<script>
    function openUpdateTaskModal(id, title, description, duedate, status, priority) {
        document.getElementById('updateTaskId').value = id;
        document.getElementById('updateTitleId').value = title;
        document.getElementById('updateDescriptionId').value = description;
        document.getElementById('updateDuedateId').value = duedate;
        document.getElementById('updateStatusId').value = status;
        document.getElementById('updatePriorityId').value = priority;
        let updateTaskModal = new bootstrap.Modal(document.getElementById('updateTaskModal'));
        updateTaskModal.show();
    }

    function openCreateTaskModal() {
        let createTaskModal = new bootstrap.Modal(document.getElementById('createTaskModal'));
        createTaskModal.show();
    }
</script>
<%--<script>--%>
<%--    <% if (request.getAttribute("errorMessage") != null) { %>--%>
<%--    let errorMessages = document.getElementsByClassName('error-message');--%>
<%--    for (let i = 0; i < errorMessages.length; i++) {--%>
<%--        errorMessages[i].innerText = '<%= request.getAttribute("errorMessage") %>';--%>
<%--    }--%>
<%--    openCreateTaskModal();--%>
<%--    <% } %>--%>
<%--</script>--%>


</body>
</html>
