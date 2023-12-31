<%@ page import="com.example.taskmanagementwebapp.model.entity.Todotask" %>
<%@ page import="java.util.List" %>
<%@ page import="org.apache.log4j.Logger" %>

<%@ page import="com.example.taskmanagementwebapp.model.entity.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<html>
<head>
    <title>dashboard.jsp</title>
    <link rel="stylesheet" type="text/css" href="css/dashboardjsp.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://kit.fontawesome.com/106fca075c.js" crossorigin="anonymous"></script>

    <!-- Include the Font Awesome library -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

</head>
<body>
<div class="container-fluid bg-dark" id="main-container">
    <div class="row text-center">
        <div class="col-6">
            <%
                User user = (User) session.getAttribute("user");
                if (user != null) {
            %>
            <div class="welcome-container">
                <h2>Welcome to your dashboard <span class="badge bg-secondary"><%= user.getUsername() %></span></h2>
            </div>
            <%
                }
            %>
        </div>
        <div class="col-4 welcomeMiddle">
            <form class="search-form" action="DashboardServlet" method="get">
                <input type="text" class="search-input" name="searchKeyword" placeholder="   Search tasks...">
                <button type="submit" class="btn btn-outline-light btn-lg" id="searchBtn"><i class="fas fa-search"></i>
                    Search
                </button>
            </form>
        </div>
        <div class="col-2 welcomeMiddle">
            <form action="${pageContext.request.contextPath}/LogoutServlet" method="get">
                <button type="submit" class="btn btn-danger btn-lg" id="logoutBtn"><i
                        class="fas fa-solid fa-power-off"></i> Logout
                </button>
            </form>
        </div>
    </div>
</div>
<%
    Logger logger = Logger.getLogger("DashboardLogger");
%>

<div class="container d-flex justify-content-center p-3">
    <div class="row align-items-center">
        <div class="col">
            <button type="button" class="btn btn-dark btn-lg" style="white-space: nowrap;"
                    onclick="openCreateTaskModal()"><i class="fa-sharp fa-solid fa-circle-plus fa-xl"
                                                       style="color: #fcfcfc;margin-right: 10px;"></i>Create New Task
            </button>
        </div>
        <div class="col">
            <button type="button" id="resetBtn" class="btn btn-warning btn-lg"
                    onclick="window.location.href = 'DashboardServlet';"><i class="fa-solid fa-rotate-right fa-xl"
                                                                            style="color: #0d0d0d;margin-right: 10px;"></i>Reset
            </button>
        </div>
    </div>
</div>


<div class="container d-flex flex-column justify-content-center border-primary">
    <% String searchError = (String) request.getAttribute("searchError");
        List<Todotask> tasksList = (List<Todotask>) request.getAttribute("tasksList");
        if (searchError != null && !searchError.isEmpty()) {
    %>
    <div class="alert alert-danger text-center" style="padding: 30px; font-size: 24px; border-radius: 10px;">
        <%= searchError %>
    </div>
    <% } else if (tasksList == null || tasksList.isEmpty()) { %>
    <div class="alert-container">
        <div class="alert alert-danger text-center">
            <h1 style="color: red;">No task saved</h1>
            <h3 style="color: black;">Create New Task</h3>
        </div>
    </div>
    <% } else { %>
    <!-- Display the table with tasks -->
    <table class="table table-striped table-hover table-dark m-3">
        <thead class="table-dark">
        <tr>
            <th scope="col">#</th>
            <th scope="col">Title</th>
            <th scope="col">Description</th>
            <th scope="col">Due Date
                <%@ include file="duedate_dropdown.html" %>
            </th>
            <th scope="col">Status
                <%@ include file="status_dropdown.html" %>
            </th>
            <th scope="col">Priority
                <%@ include file="priority_dropdown.html" %>
            </th>
            <th scope="col">Actions</th>
        </tr>
        </thead>
        <tbody>
        <%
            int currentPage = (Integer) request.getAttribute("currentPage");
            int recordsPerPage = (Integer) request.getAttribute("recordsPerPage");
            for (Todotask task : tasksList) {
        %>
        <tr>
            <td><%= (currentPage - 1) * recordsPerPage + tasksList.indexOf(task) + 1 %>
            </td>
            <td><%= task.getTitle() %>
            </td>
            <td><%= task.getDescription() %>
            </td>
            <td><%= new SimpleDateFormat("yyyy-MM-dd").format(task.getDuedate()) %>
            </td>
            <td>
                <%if ("pending".equals(task.getStatus())) {%>
                <span class="status-pending"><%= task.getStatus() %></span>
                <%} else {%>
                <span class="status-completed"><%= task.getStatus() %></span>
                <%}%>
            </td>
            <td>
                <%
                    if ("high".equals(task.getPriority())) {
                %>
                <span class="priority-high"><%= task.getPriority() %></span>
                <%
                } else if ("medium".equals(task.getPriority())) {
                %>
                <span class="priority-medium"><%= task.getPriority() %></span>
                <%
                } else {
                %>
                <span class="priority-low"><%= task.getPriority() %></span>
                <%
                    }
                %>
            </td>
            <td>
                <button type="button" class="btn btn-primary"
                        onclick="openUpdateTaskModal('<%= task.getId() %>', '<%= task.getTitle()%>', '<%= task.getDescription()%>','<%= new SimpleDateFormat("yyyy-MM-dd").format(task.getDuedate()) %>',  '<%= task.getStatus() %>', '<%= task.getPriority() %>')">
                    <i class="fa-solid fa-pen fa-xl" style="color: #fcfcfc;"></i>
                    Update
                </button>
                <button type="button" class="btn btn-danger" onclick="openDeleteTaskModal(<%= task.getId() %>)"><i
                        class="fa-solid fa-trash fa-xl" style="color: #000000;"></i>
                    Remove
                </button>
                <form action="${pageContext.request.contextPath}/CompleteServlet" method="get"
                      id="completedForm" style="display: inline;">
                    <input type="hidden" name="taskId" value="<%= task.getId() %>"/>
                    <input type="hidden" name="completedStatus" value="completed"/>
                    <button type="submit" class="btn btn-success"><i class="fa-solid fa-circle-check fa-xl"
                                                                     style="color: #00FF00;"></i> Completed
                    </button>
                </form>
            </td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <%--pagination code--%>
    <nav aria-label="Page navigation">
        <ul class="pagination pagination-lg justify-content-center">
            <%
                String searchKeyword = (String) request.getAttribute("searchKeyword");
                String duedateSortInput = (String) request.getAttribute("duedateSortInput");
                String statusInput = (String) request.getAttribute("statusInput");
                String priorityInput = (String) request.getAttribute("priorityInput");
                int numOfPages = (Integer) request.getAttribute("numOfPages");

                if (currentPage != 1) {
            %>
            <li class="page-item">
                <a class="page-link"
                   href="DashboardServlet?currentPage=<%= currentPage - 1 %>&searchKeyword=<%= searchKeyword %>&duedateSortInput=<%= duedateSortInput %>&statusInput=<%= statusInput %>&priorityInput=<%= priorityInput %>"
                   aria-label="Previous">
                    <span aria-hidden="true">&laquo;</span>
                </a>
            </li>
            <%
                }
                for (int i = 1; i <= numOfPages; i++) {
                    if (i == currentPage) {
            %>
            <li class="page-item active">
                <a class="page-link"
                   href="DashboardServlet?currentPage=<%= i %>&searchKeyword=<%= searchKeyword %>&duedateSortInput=<%= duedateSortInput %>&statusInput=<%= statusInput %>&priorityInput=<%= priorityInput %>"><%= i %>
                </a>
            </li>
            <%
            } else {
            %>
            <li class="page-item">
                <a class="page-link"
                   href="DashboardServlet?currentPage=<%= i %>&searchKeyword=<%= searchKeyword %>&duedateSortInput=<%= duedateSortInput %>&statusInput=<%= statusInput %>&priorityInput=<%= priorityInput %>"><%= i %>
                </a>
            </li>
            <%
                    }
                }
                if (currentPage != numOfPages) {
            %>
            <li class="page-item">
                <a class="page-link"
                   href="DashboardServlet?currentPage=<%= currentPage + 1 %>&searchKeyword=<%= searchKeyword %>&duedateSortInput=<%= duedateSortInput %>&priorityInput=<%= priorityInput %>&statusInput=<%= statusInput %>"
                   aria-label="Next">
                    <span aria-hidden="true">&raquo;</span>
                </a>
            </li>
            <%
                }
            %>
        </ul>
    </nav>
    <% } %>
</div>

<% int currentPage = (Integer) request.getAttribute("currentPage"); %>
<input type="hidden" id="currentPage" value="<%= currentPage %>"/>
<!-- Create Task Modal -->
<div class="modal fade" id="createTaskModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false"
     aria-labelledby="createTaskModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="createTaskModalLabel">Create Task</h5>
                <%--                <button type="button" class="btn-close" onclick="window.location.href = 'DashboardServlet?currentPage='+ currentPage;"--%>
                <%--                        aria-label="Close"></button>--%>
                <button type="button" class="btn-close" onclick="closeModalAndRedirect();" aria-label="Close"></button>

            </div>
            <div class="modal-body">
                <form id="createTaskForm" action="TaskServlet" method="post">
                    <input type="hidden" name="action" value="create">
                    <div class="mb-3">
                        <div class="form-group">
                            <label for="title" class="form-label">Title</label>
                            <input type="text" class="form-control ${titleError != null ? 'is-invalid' : ''}"
                                   id="title" name="title" value="${title}" aria-describedby="titleError">
                            <div id="titleErrorCreate"
                                 class="invalid-feedback">${titleError != null ? 'Please provide a title' : ''}</div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="form-group">
                            <label for="description" class="form-label">Description:</label>
                            <input type="text" class="form-control ${descriptionError != null ? 'is-invalid' : ''}"
                                   id="description" name="description" value="${description}"
                                   aria-describedby="descriptionError">
                            <div id="descriptionErrorCreate"
                                 class="invalid-feedback">${descriptionError != null ? 'Please provide a description' : ''}</div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="form-group">
                            <label for="duedate" class="form-label">Due Date:</label>
                            <input type="date" class="form-control ${duedateError != null ? 'is-invalid' : ''}"
                                   id="duedate" name="duedate" value="${duedate}" aria-describedby="deudateError">
                            <div id="duedateErrorCreate"
                                 class="invalid-feedback">${duedateError != null ? 'Please provide a DeuDate' : ''}</div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="status" class="form-label">Status:</label>
                        <input type="text" class="form-control" id="status" name="status" value="pending" readonly>
                    </div>
                    <div class="mb-3">
                        <div class="form-group">
                            <label for="priority" class="form-label">Priority:</label>
                            <select class="form-select ${priorityError != null ? 'is-invalid' : ''}"
                                    id="priority" name="priority" aria-describedby="priorityError">
                                <option selected disabled>Select Priority</option>
                                <option value="high">high</option>
                                <option value="medium">medium</option>
                                <option value="low">low</option>
                            </select>
                            <div id="priorityErrorCreate"
                                 class="invalid-feedback">${priorityError != null ? 'Please select a priority' : ''}</div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary"
                        onclick="document.getElementById('createTaskForm').submit();">Create Task
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Update Task Modal -->
<div class="modal fade" id="updateTaskModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false"
     aria-labelledby="updateTaskModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="updateTaskModalLabel">Update Task</h5>
                <%--                <button type="button" class="btn-close" onclick="window.location.href = 'DashboardServlet?currentPage='+ currentPage;"--%>
                <%--                        aria-label="Close"></button>--%>
                <button type="button" class="btn-close" onclick="closeModalAndRedirect();" aria-label="Close"></button>

            </div>
            <div class="modal-body">
                <form id="updateTaskForm" action="TaskServlet" method="post">

                    <input type="hidden" name="action" value="update">
                    <input type="hidden" id="updateTaskId" name="id">
                    <div class="mb-3">
                        <div class="form-group">
                            <label for="updateTitleId">Title:</label>
                            <input type="text" class="form-control ${titleError != null ? 'is-invalid' : ''}"
                                   id="updateTitleId" name="title" value="${title}" aria-describedby="titleError">
                            <div id="titleError"
                                 class="invalid-feedback">${titleError != null ? 'Please provide a title' : ''}</div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="form-group">
                            <label for="updateDescriptionId" class="form-label">Description:</label>
                            <input type="text" class="form-control ${descriptionError != null ? 'is-invalid' : ''}"
                                   id="updateDescriptionId" name="description" value="${description}"
                                   aria-describedby="descriptionError">
                            <div id="descriptionError"
                                 class="invalid-feedback">${descriptionError != null ? 'Please provide a description' : ''}</div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="form-group">
                            <label for="updateDuedateId" class="form-label">Due Date:</label>
                            <input type="date" class="form-control ${duedateError != null ? 'is-invalid' : ''}"
                                   id="updateDuedateId" name="duedate" value="${duedate}"
                                   aria-describedby="deudateError">
                            <div id="duedateError"
                                 class="invalid-feedback">${duedateError != null ? 'Please provide a DeuDate' : ''}</div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="form-group">
                            <label for="updateStatusId" class="form-label">Status:</label>
                            <select class="form-select" id="updateStatusId" name="status">
                                <option selected disabled>Open this select menu</option>
                                <option value="pending">pending</option>
                                <option value="completed">completed</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="form-group">
                            <label for="updatePriorityId" class="form-label">Priority:</label>
                            <select class="form-select ${priorityError != null ? 'is-invalid' : ''}"
                                    id="updatePriorityId" name="priority" aria-describedby="priorityError">
                                <option selected disabled>Open this select menu</option>
                                <option value="high">high</option>
                                <option value="medium">medium</option>
                                <option value="low">low</option>
                            </select>
                            <div id="priorityError"
                                 class="invalid-feedback">${priorityError != null ? 'Please select a priority' : ''}</div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary"
                        onclick="document.getElementById('updateTaskForm').submit();">Save changes
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteTaskModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false"
     aria-labelledby="deleteTaskModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteTaskModalLabel">Confirm Delete</h5>
                <%--                <button type="button" class="btn-close" onclick="window.location.href = 'DashboardServlet?currentPage='+ currentPage;"--%>
                <%--                        aria-label="Close"></button>--%>
                <button type="button" class="btn-close" onclick="closeModalAndRedirect();" aria-label="Close"></button>

            </div>
            <div class="modal-body">
                Are you sure you want to delete this task?
                <form id="deleteTaskForm" action="TaskServlet" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" id="deleteTaskId" name="id">
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-danger"
                        onclick="document.getElementById('deleteTaskForm').submit();">Delete Task
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.1.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js"></script>
<script>
    function openCreateTaskModal() {
        let createTaskModal = new bootstrap.Modal(document.getElementById('createTaskModal'));
        createTaskModal.show();
    }

    function openUpdateTaskModal(id, title, description, duedate, status, priority) {
        document.getElementById('updateTaskId').value = id;
        document.getElementById('updateTitleId').value = title;
        document.getElementById('updateDescriptionId').value = description;
        let changedate = duedate.split(' ')[0];
        document.getElementById('updateDuedateId').value = changedate;
        document.getElementById('updateStatusId').value = status;
        document.getElementById('updatePriorityId').value = priority;
        let updateTaskModal = new bootstrap.Modal(document.getElementById('updateTaskModal'));
        updateTaskModal.show();
    }

    function openDeleteTaskModal(id) {
        document.getElementById('deleteTaskId').value = id;
        let deleteTaskModal = new bootstrap.Modal(document.getElementById('deleteTaskModal'));
        deleteTaskModal.show();
    }
</script>
<script>
    //Get back the action type
    let currentAction = "${currentAction}";
    // Check if the form has validation errors
    let hasErrors = "${hasErrors}";
    if (hasErrors) {
        // Get the form data from the request attributes
        var id = "${id}";
        var title = "${title}";
        var description = "${description}";
        var duedate = "${duedate}";
        var status = "${status}";
        var priority = "${priority}";
        if (currentAction === "create") {
            openCreateTaskModal(id, title, description, duedate, status, priority);
        } else if (currentAction === "update") {
            // Open the modal with the form data
            openUpdateTaskModal(id, title, description, duedate, status, priority);
        }
    }
</script>

<script>
    function closeModalAndRedirect() {
        // setTimeout(function() {
        //     let currentPage = document.getElementById('currentPage').value;
        //     window.location.href = 'DashboardServlet?currentPage=' + currentPage;
        // }, 500);
        let currentPage = document.getElementById('currentPage').value;
        window.location.href = 'DashboardServlet?currentPage=' + currentPage;
    }
</script>


</body>
</html>
