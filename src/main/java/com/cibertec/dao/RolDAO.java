package com.cibertec.dao;
import com.cibertec.model.Rol;

import jakarta.persistence.EntityManager;
import java.util.List;

public class RolDAO {
    private EntityManager em;

    public RolDAO(EntityManager em) {
        this.em = em;
    }

    public void guardar(Rol rol) {
        em.getTransaction().begin();
        em.persist(rol);
        em.getTransaction().commit();
    }

    public void actualizar(Rol rol) {
        em.getTransaction().begin();
        em.merge(rol);
        em.getTransaction().commit();
    }

    public void eliminar(Long id) {
        em.getTransaction().begin();
        Rol rol = em.find(Rol.class, id);
        if (rol != null) {
            em.remove(rol);
        }
        em.getTransaction().commit();
    }

    public List<Rol> listar() {
        return em.createQuery("SELECT r FROM Rol r", Rol.class).getResultList();
    }

    public Rol obtener(Long id) {
        return em.find(Rol.class, id);
    }
} 