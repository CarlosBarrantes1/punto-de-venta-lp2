package com.cibertec.dao;
import com.cibertec.model.Local;

import jakarta.persistence.EntityManager;
import java.util.List;

public class LocalDAO {
    private EntityManager em;

    public LocalDAO(EntityManager em) {
        this.em = em;
    }

    public void guardar(Local local) {
        em.getTransaction().begin();
        em.persist(local);
        em.getTransaction().commit();
    }

    public void actualizar(Local local) {
        em.getTransaction().begin();
        em.merge(local);
        em.getTransaction().commit();
    }

    public void eliminar(Long id) {
        em.getTransaction().begin();
        Local local = em.find(Local.class, id);
        if (local != null) {
            em.remove(local);
        }
        em.getTransaction().commit();
    }

    public List<Local> listar() {
        return em.createQuery("SELECT l FROM Local l", Local.class).getResultList();
    }

    public Local obtener(Long id) {
        return em.find(Local.class, id);
    }
} 