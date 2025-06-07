package com.cibertec.servlet;

import com.cibertec.dao.LocalDAO;
import com.cibertec.model.Local;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class LocalServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("my-webapp");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        LocalDAO localDAO = new LocalDAO(em);
        List<Local> locales = localDAO.listar();
        System.out.println("Locales size: " + locales.size());
        em.close();
        req.setAttribute("locales", locales);
        req.setAttribute("contentPage", "Mantenimiento/locales.jsp");
        req.getRequestDispatcher("/WEB-INF/jsp/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        LocalDAO localDAO = new LocalDAO(em);
        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) {
                String nombre = req.getParameter("nombre");
                String direccion = req.getParameter("direccion");
                String telefono = req.getParameter("telefono");
                String email = req.getParameter("email");
                String horario = req.getParameter("horario");
                localDAO.guardar(new Local(nombre, direccion, telefono, email, horario));
            } else if ("edit".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                Local local = localDAO.obtener(id);
                local.setNombre(req.getParameter("nombre"));
                local.setDireccion(req.getParameter("direccion"));
                local.setTelefono(req.getParameter("telefono"));
                local.setEmail(req.getParameter("email"));
                local.setHorario(req.getParameter("horario"));
                localDAO.actualizar(local);
            } else if ("delete".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                localDAO.eliminar(id);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        resp.sendRedirect(req.getContextPath() + "/local");
    }

    @Override
    public void destroy() {
        if (emf != null) {
            emf.close();
        }
    }
} 