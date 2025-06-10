package com.cibertec.dao;

import com.cibertec.model.Caja;
import jakarta.persistence.EntityManager;
import java.util.List;

public class CajaDAO {
    private EntityManager em;

    public CajaDAO(EntityManager em) {
        this.em = em;
    }

    public void guardar(Caja caja) {
        em.getTransaction().begin();
        em.persist(caja);
        em.getTransaction().commit();
    }

    public void actualizar(Caja caja) {
        em.getTransaction().begin();
        em.merge(caja);
        em.getTransaction().commit();
    }

    public void eliminar(Long id) {
        em.getTransaction().begin();
        Caja caja = em.find(Caja.class, id);
        if (caja != null) {
            em.remove(caja);
        }
        em.getTransaction().commit();
    }

    public List<Caja> listar() {
        return em.createQuery("SELECT c FROM Caja c", Caja.class).getResultList();
    }

    public Caja obtener(Long id) {
        return em.find(Caja.class, id);
    }
}