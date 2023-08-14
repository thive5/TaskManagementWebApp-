<%--
  Created by IntelliJ IDEA.
  User: thive
  Date: 8/13/2023
  Time: 11:59 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<div class="container d-flex flex-column justify-content-center border-primary">
    <% String searchError = (String) request.getAttribute("searchError"); %>
    <% if (searchError != null && !searchError.isEmpty()) { %>
    <div class="alert alert-danger text-center">
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
            List<Todotask> tasks = (List<Todotask>) request.getAttribute("tasksList");
//            int currentPage = (Integer) request.getAttribute("currentPage");
//            int recordsPerPage = (Integer) request.getAttribute("recordsPerPage");
            for (int i = 0; i < tasks.size(); i++) {
                Todotask task = tasks.get(i);
        %>
        <tr>
            <td><%= (currentPage - 1) * recordsPerPage + i + 1 %>
            </td>
            <td><%= task.getTitle() %>
            </td>
            <td><%= task.getDescription() %>
            </td>
            <td><%= new SimpleDateFormat("yyyy-MM-dd").format(task.getDuedate()) %>
            </td>
            <td>

                <%
                    if ("pending".equals(task.getStatus())) {
                %>
                <span class="status-pending">${task.status}</span>
                <%
                } else {
                %>
                <span class="status-completed">${task.status}</span>
                <%
                    }
                %>
            </td>
            <td>
                <%
                    if ("high".equals(task.getPriority())) {
                %>
                <span class="priority-high">${task.priority}</span>
                <%
                } else if ("medium".equals(task.getPriority())) {
                %>
                <span class="priority-medium">${task.priority}</span>
                <%
                } else {
                %>
                <span class="priority-low">${task.priority}</span>
                <%
                    }
                %>
            </td>
            <td>
                <button type="button" class="btn btn-primary"
                        onclick="openUpdateTaskModal(${task.id}, '${task.title}', '${task.description}', '${task.duedate}', '${task.status}', '${task.priority}')">
                    <i class="fa-solid fa-pen fa-xl" style="color: #fcfcfc;"></i>
                    Update
                </button>
                <button type="button" class="btn btn-danger" onclick="openDeleteTaskModal(${task.id})"><i
                        class="fa-solid fa-trash fa-xl" style="color: #000000;"></i>
                    Remove
                </button>
                <form action="${pageContext.request.contextPath}/CompleteServlet" method="get"
                      id="completedForm" style="display: inline;">
                    <input type="hidden" name="taskId" value="${task.id}"/>
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
                int currentPage = (Integer) request.getAttribute("currentPage");
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
</body>
</html>
