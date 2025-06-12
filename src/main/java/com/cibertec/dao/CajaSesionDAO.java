package com.cibertec.dao;

import com.cibertec.model.CajaSesion;
import jakarta.persistence.EntityManager;
import java.util.List;

public class CajaSesionDAO {
    private EntityManager em;

    public CajaSesionDAO(EntityManager em) {
        this.em = em;
    }

    public void guardar(CajaSesion sesion) {
        em.getTransaction().begin();
        em.persist(sesion);
        em.getTransaction().commit();
    }

    public void actualizar(CajaSesion sesion) {
        em.getTransaction().begin();
        em.merge(sesion);
        em.getTransaction().commit();
    }

    public void eliminar(Long id) {
        em.getTransaction().begin();
        CajaSesion sesion = em.find(CajaSesion.class, id);
        if (sesion != null) {
            em.remove(sesion);
        }
        em.getTransaction().commit();
    }

    public List<CajaSesion> listar() {
        return em.createQuery("SELECT cs FROM CajaSesion cs", CajaSesion.class).getResultList();
    }

    public CajaSesion obtener(Long id) {
        return em.find(CajaSesion.class, id);
    }

    // Opcional: obtener sesiones abiertas por caja
    public List<CajaSesion> listarPorCaja(Long cajaId) {
        return em.createQuery(
            "SELECT cs FROM CajaSesion cs WHERE cs.caja.id = :cajaId ORDER BY cs.fechaApertura DESC",
            CajaSesion.class
        ).setParameter("cajaId", cajaId).getResultList();
    }
}