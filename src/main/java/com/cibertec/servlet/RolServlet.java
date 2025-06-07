package com.cibertec.servlet;

import com.cibertec.dao.RolDAO;
import com.cibertec.model.Rol;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class RolServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("my-webapp");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        RolDAO rolDAO = new RolDAO(em);
        List<Rol> roles = rolDAO.listar();
        System.out.println("Roles size: " + roles.size());
        em.close();
        req.setAttribute("roles", roles);
        req.setAttribute("contentPage", "Mantenimiento/roles.jsp");
        req.getRequestDispatcher("/WEB-INF/jsp/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        RolDAO rolDAO = new RolDAO(em);
        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) {
                String nombre = req.getParameter("nombre");
                String descripcion = req.getParameter("descripcion");
                rolDAO.guardar(new Rol(nombre, descripcion));
            } else if ("edit".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                Rol rol = rolDAO.obtener(id);
                rol.setNombre(req.getParameter("nombre"));
                rol.setDescripcion(req.getParameter("descripcion"));
                rolDAO.actualizar(rol);
            } else if ("delete".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                rolDAO.eliminar(id);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        resp.sendRedirect(req.getContextPath() + "/rol");
    }

    @Override
    public void destroy() {
        if (emf != null) {
            emf.close();
        }
    }
} 