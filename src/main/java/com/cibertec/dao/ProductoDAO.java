package com.cibertec.dao;
import com.cibertec.model.Producto;

import jakarta.persistence.EntityManager;
import java.util.List;

public class ProductoDAO {
    private EntityManager em;

    public ProductoDAO(EntityManager em) {
        this.em = em;
    }

    public void guardar(Producto producto) {
        em.getTransaction().begin();
        em.persist(producto);
        em.getTransaction().commit();
    }

    public void actualizar(Producto producto) {
        em.getTransaction().begin();
        em.merge(producto);
        em.getTransaction().commit();
    }

    public void eliminar(Long id) {
        em.getTransaction().begin();
        Producto producto = em.find(Producto.class, id);
        if (producto != null) {
            em.remove(producto);
        }
        em.getTransaction().commit();
    }

    public List<Producto> listar() {
        return em.createQuery("SELECT p FROM Producto p", Producto.class).getResultList();
    }

    public Producto obtener(Long id) {
        return em.find(Producto.class, id);
    }
} 