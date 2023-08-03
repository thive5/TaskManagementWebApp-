package com.example.taskmanagementwebapp.model.entity.sessionbean;

import com.example.taskmanagementwebapp.model.entity.Todotask;

import javax.ejb.EJBException;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import java.util.List;

@Stateless
public class TaskSessionBean implements TaskSessionBeanLocal {

    @PersistenceContext(unitName = "TaskManagementWebApp")
    EntityManager entityManager;

    @Override
    public List<Todotask> getTaskByUser(Integer userId,int maxResults, int firstResult,String searchKeyword) throws EJBException {
//        Query q = entityManager.createNativeQuery("SELECT * FROM taskmanager.todotask WHERE userid = ?", Todotask.class);
//        q.setParameter(1, userId);
        Query q = null;
        if(searchKeyword == null ||searchKeyword.isEmpty()){
            q = entityManager.createQuery("SELECT t FROM Todotask t WHERE t.userid.id = :userId", Todotask.class);
            q.setParameter("userId", userId);
        }else {
            q = entityManager.createQuery("SELECT t FROM Todotask t WHERE t.userid.id = :userId AND (t.title LIKE :searchKeyword OR t.description LIKE :searchKeyword)", Todotask.class);
            q.setParameter("searchKeyword", "%" + searchKeyword + "%");
            q.setParameter("userId", userId);
        }


        q.setMaxResults(maxResults);
        q.setFirstResult(firstResult);
        List<Todotask> resultList = q.getResultList();
        return resultList;
    }
    @Override
    public int getTaskCountForUser(int userId) {
        Query q = entityManager.createQuery("SELECT COUNT(t) FROM Todotask t WHERE t.userid.id = :userId");
        q.setParameter("userId", userId);
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
