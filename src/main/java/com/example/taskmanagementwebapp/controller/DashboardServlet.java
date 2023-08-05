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
        logger.info("DashboardServlet doGet called");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            logger.warn("DashboardServlet cannot get current user");
            response.sendRedirect("loginpage.html");
            return;
        }
        int userId = user.getId();
        int currentPage = 1; //user would be shown page is 1 by default
        int recordsPerPage = 10;// default recordsPerPage is 10
        String searchKeyword = request.getParameter("searchKeyword");//search keyword
        String duedateSortInput = request.getParameter("duedateSortInput");
        logger.info("duedateSortInput="+ duedateSortInput);
        if (request.getParameter("currentPage") != null) {
            try {
                //check if the current is page 1 or not, if not 1 pass the current page value
                currentPage = Integer.parseInt(request.getParameter("currentPage"));
            } catch (NumberFormatException e) {
                // Handle exception
            }
        }


        try {
            //get total number of task for the user
            int rows = taskBean.getTaskCountForUser(userId);
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
                        logger.info("Removed Error attribute: " + field);
                    }
                }
                // Remove the emptyFields list from the session
                session.removeAttribute("emptyFields");
            }


            String[] attributeNames = {"title", "description", "duedate", "status", "priority", "hasErrors", "currentAction"};

            for (String attributeName : attributeNames) {
                Object attributeValue = session.getAttribute(attributeName);
                if (attributeValue != null) {
                    request.setAttribute(attributeName, attributeValue);
                    session.removeAttribute(attributeName);
                    logger.info("Removed session attribute: " + attributeName);
                }
            }

            List<Todotask> tasksList = taskBean.getTaskByUser(userId, recordsPerPage, (currentPage - 1) * recordsPerPage, searchKeyword,duedateSortInput);
            request.setAttribute("numOfPages", numOfPages);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("recordsPerPage", recordsPerPage);
            request.setAttribute("searchKeyword", searchKeyword);
            request.setAttribute("duedateSortInput", duedateSortInput);
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
