package com.example.taskmanagementwebapp.controller;

import com.example.taskmanagementwebapp.model.entity.Todotask;
import com.example.taskmanagementwebapp.model.entity.User;
import com.example.taskmanagementwebapp.model.entity.sessionbean.TaskSessionBeanLocal;

import javax.ejb.EJB;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

import org.apache.log4j.Logger;

@WebServlet(name = "DashboardServlet", value = "/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(DashboardServlet.class);
    @EJB
    private TaskSessionBeanLocal taskBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            logger.warn("DashboardServlet cannot get current user");
            response.sendRedirect("loginpage.jsp");
            return;
        }
        int userId = user.getId();
        int currentPage = 1; //user would be shown page is 1 by default
        if (request.getParameter("currentPage") != null) {
            try {
                //check if the current is page 1 or not, if not 1 pass the current page value
                currentPage = Integer.parseInt(request.getParameter("currentPage"));
            } catch (NumberFormatException e) {
                // Handle exception
                logger.warn("Invalid currentPage value. Using default.");
            } catch (Exception e) {
                // Handle other exceptions
                e.printStackTrace();
                response.getWriter().write("An error occurred in DashboardServlet.");
            }
        }
        int recordsPerPage = 10;// default recordsPerPage is 10
        String searchKeyword = request.getParameter("searchKeyword");//search keyword
        if (searchKeyword == null || searchKeyword.isEmpty()) {
            searchKeyword = ""; // or some default value
        }
        String duedateSortInput = request.getParameter("duedateSortInput");
        if (duedateSortInput == null || duedateSortInput.isEmpty()) {
            duedateSortInput = ""; // or some default value
        }
        String statusInput = request.getParameter("statusInput");
        if (statusInput == null || statusInput.isEmpty()) {
            statusInput = ""; // or some default value
        }
        String priorityInput = request.getParameter("priorityInput");
        if (priorityInput == null || priorityInput.isEmpty()) {
            priorityInput = ""; // or some default value
        }
        String newStatusInput = statusInput;

        try {
            //get total number of task for the user
            int rows = taskBean.getTaskCountForUser(userId, searchKeyword, duedateSortInput, statusInput, priorityInput);
            int numOfPages = rows / recordsPerPage;
            if (rows % recordsPerPage > 0) {
                //if there is a remainder task, add new page
                numOfPages++;
            }
            if (currentPage > numOfPages && numOfPages != 0) {
                currentPage = numOfPages;
            }
            // Get the fields from the session
            List<String> emptyFields = (List<String>) session.getAttribute("emptyFields");
            // Check if the list is not null and not empty
            if (emptyFields != null && !emptyFields.isEmpty()) {
                // For each empty field, get the error attribute from the session and add it to the request
                for (String field : emptyFields) {
                    String error = (String) session.getAttribute(field + "Error");
                    if (error != null) {
                        request.setAttribute(field + "Error", error);
                        // Remove the attribute from the session to avoid it being persisted across requests
                        session.removeAttribute(field + "Error");
                    }
                }
                // Remove the emptyFields list from the session
                session.removeAttribute("emptyFields");
            }

            String[] attributeNames = {"id", "title", "description", "duedate", "status", "priority", "hasErrors", "currentAction"};

            for (String attributeName : attributeNames) {
                Object attributeValue = session.getAttribute(attributeName);
                if (attributeValue != null) {
                    request.setAttribute(attributeName, attributeValue);
                    session.removeAttribute(attributeName);
                }
            }

            List<Todotask> tasksList = taskBean.getTaskByUser(userId, recordsPerPage, (currentPage - 1) * recordsPerPage, searchKeyword, duedateSortInput, statusInput, priorityInput);
            request.setAttribute("numOfPages", numOfPages);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("recordsPerPage", recordsPerPage);
            // Check if the tasksList is empty and if a searchKeyword was provided
            if (tasksList.isEmpty() && (searchKeyword != null && !searchKeyword.trim().isEmpty())) {
                request.setAttribute("searchError", "The task you are searching doesn't exist.");
            }
            request.setAttribute("searchKeyword", searchKeyword);
            request.setAttribute("duedateSortInput", duedateSortInput);
            request.setAttribute("statusInput", statusInput);
            if (tasksList.isEmpty() && (statusInput != null && !statusInput.trim().isEmpty())) {
                if ("completed".equals(newStatusInput)) {
                    request.setAttribute("searchError", "No task has been completed");
                } else if ("pending".equals(newStatusInput)) {
                    request.setAttribute("searchError", "No task has been pending");
                } else {
                    request.setAttribute("searchError", "No task");
                }
            }
            request.setAttribute("priorityInput", priorityInput);
            if (tasksList.isEmpty() && (priorityInput != null && !priorityInput.trim().isEmpty())) {
                request.setAttribute("searchError", "No task matches this priority");
            }
            request.setAttribute("tasksList", tasksList);
            RequestDispatcher dispatcher = request.getRequestDispatcher("dashboard.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            logger.error("Error while retrieving tasks or forwarding request", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
