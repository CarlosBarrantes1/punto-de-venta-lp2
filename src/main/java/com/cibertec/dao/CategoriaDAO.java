package com.cibertec.dao;
import com.cibertec.model.Categoria;

import jakarta.persistence.EntityManager;
import java.util.List;

public class CategoriaDAO {
    private EntityManager em;

    public CategoriaDAO(EntityManager em) {
        this.em = em;
    }

    public void guardar(Categoria categoria) {
        em.getTransaction().begin();
        em.persist(categoria);
        em.getTransaction().commit();
    }

    public void actualizar(Categoria categoria) {
        em.getTransaction().begin();
        em.merge(categoria);
        em.getTransaction().commit();
    }

    public void eliminar(Long id) {
        em.getTransaction().begin();
        Categoria categoria = em.find(Categoria.class, id);
        if (categoria != null) {
            em.remove(categoria);
        }
        em.getTransaction().commit();
    }

    public List<Categoria> listar() {
        return em.createQuery("SELECT c FROM Categoria c", Categoria.class).getResultList();
    }

    public Categoria obtener(Long id) {
        return em.find(Categoria.class, id);
    }
} 