package com.cibertec.servlet;

import com.cibertec.dao.MedioPagoDAO;
import com.cibertec.model.MedioPago;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class MedioPagoServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("my-webapp");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        MedioPagoDAO medioPagoDAO = new MedioPagoDAO(em);
        List<MedioPago> mediosPago = medioPagoDAO.listar();
        System.out.println("Medios de pago size: " + mediosPago.size());
        em.close();
        req.setAttribute("mediosPago", mediosPago);
        req.setAttribute("contentPage", "Mantenimiento/mediosPago.jsp");
        req.getRequestDispatcher("/WEB-INF/jsp/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        MedioPagoDAO medioPagoDAO = new MedioPagoDAO(em);
        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) {
                String nombre = req.getParameter("nombre");
                String descripcion = req.getParameter("descripcion");
                String tipo = req.getParameter("tipo");
                medioPagoDAO.guardar(new MedioPago(nombre, descripcion, tipo));
            } else if ("edit".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                MedioPago medioPago = medioPagoDAO.obtener(id);
                medioPago.setNombre(req.getParameter("nombre"));
                medioPago.setDescripcion(req.getParameter("descripcion"));
                medioPago.setTipo(req.getParameter("tipo"));
                medioPagoDAO.actualizar(medioPago);
            } else if ("delete".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                medioPagoDAO.eliminar(id);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        resp.sendRedirect(req.getContextPath() + "/medioPago");
    }

    @Override
    public void destroy() {
        if (emf != null) {
            emf.close();
        }
    }
} 