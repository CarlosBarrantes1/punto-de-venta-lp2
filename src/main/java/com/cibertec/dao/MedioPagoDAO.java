package com.cibertec.dao;
import com.cibertec.model.MedioPago;

import jakarta.persistence.EntityManager;
import java.util.List;

public class MedioPagoDAO {
    private EntityManager em;

    public MedioPagoDAO(EntityManager em) {
        this.em = em;
    }

    public void guardar(MedioPago medioPago) {
        em.getTransaction().begin();
        em.persist(medioPago);
        em.getTransaction().commit();
    }

    public void actualizar(MedioPago medioPago) {
        em.getTransaction().begin();
        em.merge(medioPago);
        em.getTransaction().commit();
    }

    public void eliminar(Long id) {
        em.getTransaction().begin();
        MedioPago medioPago = em.find(MedioPago.class, id);
        if (medioPago != null) {
            em.remove(medioPago);
        }
        em.getTransaction().commit();
    }

    public List<MedioPago> listar() {
        return em.createQuery("SELECT m FROM MedioPago m", MedioPago.class).getResultList();
    }

    public MedioPago obtener(Long id) {
        return em.find(MedioPago.class, id);
    }
} 