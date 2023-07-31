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

    public List<Todotask> getTaskByUser(Integer userId) throws EJBException {
//        Query q = entityManager.createNativeQuery("SELECT * FROM taskmanager.todotask WHERE userid = ?", Todotask.class);
//        q.setParameter(1, userId);
        Query q = entityManager.createQuery("SELECT t FROM Todotask t WHERE t.userid.id = :userId", Todotask.class);
        q.setParameter("userId", userId);
        List<Todotask> resultList = q.getResultList();
        return resultList;
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
}
