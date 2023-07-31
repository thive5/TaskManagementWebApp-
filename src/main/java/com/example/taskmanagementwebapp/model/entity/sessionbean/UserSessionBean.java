package com.example.taskmanagementwebapp.model.entity.sessionbean;

import com.example.taskmanagementwebapp.model.entity.User;

import javax.ejb.EJBException;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

@Stateless
public class UserSessionBean implements UserSessionBeanLocal {
    @PersistenceContext(unitName = "TaskManagementWebApp")
    EntityManager entityManager;

    public User findUserByUsername(String username) {
        TypedQuery<User> query = entityManager.createQuery("SELECT u FROM User u WHERE u.username = :username", User.class);
        query.setParameter("username", username);
        try {
            return query.getSingleResult();
        } catch (Exception ex) {
            throw new EJBException("Problem finding user by username", ex);
        }
    }
}
