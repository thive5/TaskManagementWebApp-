package com.example.taskmanagementwebapp.model.entity.sessionbean;

import com.example.taskmanagementwebapp.controller.DashboardServlet;
import com.example.taskmanagementwebapp.model.entity.Todotask;

import javax.ejb.EJBException;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import java.util.List;

import org.apache.log4j.Logger;

@Stateless
public class TaskSessionBean implements TaskSessionBeanLocal {
    private static final Logger logger = Logger.getLogger(TaskSessionBean.class);
    @PersistenceContext(unitName = "TaskManagementWebApp")
    EntityManager entityManager;

    @Override
    public List<Todotask> getTaskByUser(Integer userId, int maxResults, int firstResult, String searchKeyword, String duedateSortInput, String statusInput, String priorityInput) throws EJBException {

        logger.info("duedateSortInput=" + duedateSortInput);
        Query q = null;
        String baseQuery = "SELECT t FROM Todotask t WHERE t.userid.id = :userId";
        String orderByClause = " ORDER BY t.id";

        if (searchKeyword != null && !searchKeyword.isEmpty()) {
            searchKeyword = searchKeyword.trim();
            baseQuery += " AND (LOWER(t.title) LIKE :searchKeyword OR LOWER(t.description) LIKE :searchKeyword)";
        }
        if (duedateSortInput != null && !duedateSortInput.isEmpty()) {
            if (duedateSortInput.equals("ASC")) {
                orderByClause = " ORDER BY t.duedate ASC";
            } else if (duedateSortInput.equals("DESC")) {
                orderByClause = " ORDER BY t.duedate DESC";
            }
        }
        if (statusInput != null && !statusInput.isEmpty()) {
            baseQuery += " AND t.status = :statusInput";
        }
        if (priorityInput != null && !priorityInput.isEmpty()) {
            baseQuery += " AND t.priority = :priorityInput";
        }

        String fullQuery = baseQuery + orderByClause;
        q = entityManager.createQuery(fullQuery, Todotask.class);
        q.setParameter("userId", userId);
        if (searchKeyword != null && !searchKeyword.isEmpty()) {
            q.setParameter("searchKeyword", "%" + searchKeyword.toLowerCase() + "%");
        }
        if (statusInput != null && !statusInput.isEmpty()) {
            q.setParameter("statusInput", statusInput);
        }
        if (priorityInput != null && !priorityInput.isEmpty()) {
            q.setParameter("priorityInput", priorityInput);
        }


        q.setMaxResults(maxResults);
        q.setFirstResult(firstResult);
        List<Todotask> resultList = q.getResultList();
        return resultList;
    }

    @Override
    public int getTaskCountForUser(int userId ,String searchKeyword, String duedateSortInput, String statusInput, String priorityInput) {
        Query q = null;
        String baseCount="SELECT COUNT(t) FROM Todotask t WHERE t.userid.id =:userId";
        // If there's a search keyword, add a condition for it
        if (searchKeyword != null && !searchKeyword.isEmpty()) {
            baseCount += " AND(t.title LIKE :searchKeyword OR t.description LIKE :searchKeyword)";
        }
        if (statusInput != null && !statusInput.isEmpty()) {
            baseCount += " AND t.status = :statusInput";
        }
        if (priorityInput != null && !priorityInput.isEmpty()) {
            baseCount += " AND t.priority = :priorityInput";
        }
        String fullbaseCount = baseCount;
        q = entityManager.createQuery(fullbaseCount, Long.class);
        q.setParameter("userId", userId);
        if (searchKeyword != null && !searchKeyword.isEmpty()) {
            q.setParameter("searchKeyword", "%" + searchKeyword + "%");
        }
        if (statusInput != null && !statusInput.isEmpty()) {
            q.setParameter("statusInput", statusInput);
        }
        if (priorityInput != null && !priorityInput.isEmpty()) {
            q.setParameter("priorityInput", priorityInput);
        }
        return ((Long) q.getSingleResult()).intValue();
    }

    @Override
    public void createTask(Todotask task) {
        entityManager.persist(task);
    }

    @Override
    public void updateTask(Todotask task) {
        entityManager.merge(task);
        entityManager.flush();
    }

    @Override
    public void deleteTask(int id) {
        // Find the task entity with the given ID
        Todotask task = entityManager.find(Todotask.class, id);
        // If the task exists, remove it
        if (task != null) {
            entityManager.remove(task);
        }
    }
}
