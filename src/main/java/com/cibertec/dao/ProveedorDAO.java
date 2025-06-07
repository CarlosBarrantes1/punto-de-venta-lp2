package com.cibertec.dao;
import com.cibertec.model.Proveedor;

import jakarta.persistence.EntityManager;
import java.util.List;

public class ProveedorDAO {
    private EntityManager em;

    public ProveedorDAO(EntityManager em) {
        this.em = em;
    }

    public void guardar(Proveedor proveedor) {
        em.getTransaction().begin();
        em.persist(proveedor);
        em.getTransaction().commit();
    }

    public void actualizar(Proveedor proveedor) {
        em.getTransaction().begin();
        em.merge(proveedor);
        em.getTransaction().commit();
    }

    public void eliminar(Long id) {
        em.getTransaction().begin();
        Proveedor proveedor = em.find(Proveedor.class, id);
        if (proveedor != null) {
            em.remove(proveedor);
        }
        em.getTransaction().commit();
    }

    public List<Proveedor> listar() {
        return em.createQuery("SELECT p FROM Proveedor p", Proveedor.class).getResultList();
    }

    public Proveedor obtener(Long id) {
        return em.find(Proveedor.class, id);
    }
} 