package com.cibertec.servlet;

import com.cibertec.dao.ProveedorDAO;
import com.cibertec.model.Proveedor;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class ProveedorServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("my-webapp");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        ProveedorDAO proveedorDAO = new ProveedorDAO(em);
        List<Proveedor> proveedores = proveedorDAO.listar();
        System.out.println("Proveedores size: " + proveedores.size());
        em.close();
        req.setAttribute("proveedores", proveedores);
        req.setAttribute("contentPage", "Mantenimiento/proveedores.jsp");
        req.getRequestDispatcher("/WEB-INF/jsp/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        ProveedorDAO proveedorDAO = new ProveedorDAO(em);
        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) {
                String ruc = req.getParameter("ruc");
                String razonSocial = req.getParameter("razonSocial");
                String direccion = req.getParameter("direccion");
                String telefono = req.getParameter("telefono");
                String email = req.getParameter("email");
                String contacto = req.getParameter("contacto");
                proveedorDAO.guardar(new Proveedor(ruc, razonSocial, direccion, telefono, email, contacto));
            } else if ("edit".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                Proveedor proveedor = proveedorDAO.obtener(id);
                proveedor.setRuc(req.getParameter("ruc"));
                proveedor.setRazonSocial(req.getParameter("razonSocial"));
                proveedor.setDireccion(req.getParameter("direccion"));
                proveedor.setTelefono(req.getParameter("telefono"));
                proveedor.setEmail(req.getParameter("email"));
                proveedor.setContacto(req.getParameter("contacto"));
                proveedorDAO.actualizar(proveedor);
            } else if ("delete".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                proveedorDAO.eliminar(id);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        resp.sendRedirect(req.getContextPath() + "/proveedor");
    }

    @Override
    public void destroy() {
        if (emf != null) {
            emf.close();
        }
    }
} 