package com.cibertec.servlet;

import com.cibertec.dao.ClienteDAO;
import com.cibertec.model.Cliente;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class ClienteServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("my-webapp");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        ClienteDAO clienteDAO = new ClienteDAO(em);
        List<Cliente> clientes = clienteDAO.listar();
        System.out.println("Clientes size: " + clientes.size());
        em.close();
        req.setAttribute("clientes", clientes);
        req.setAttribute("contentPage", "Mantenimiento/clientes.jsp");
        req.getRequestDispatcher("/WEB-INF/jsp/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        ClienteDAO clienteDAO = new ClienteDAO(em);
        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) {
                String nombre = req.getParameter("nombre");
                String apellido = req.getParameter("apellido");
                String dni = req.getParameter("dni");
                String direccion = req.getParameter("direccion");
                String telefono = req.getParameter("telefono");
                String email = req.getParameter("email");
                clienteDAO.guardar(new Cliente(nombre, apellido, dni, direccion, telefono, email));
            } else if ("edit".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                Cliente cliente = clienteDAO.obtener(id);
                cliente.setNombre(req.getParameter("nombre"));
                cliente.setApellido(req.getParameter("apellido"));
                cliente.setDni(req.getParameter("dni"));
                cliente.setDireccion(req.getParameter("direccion"));
                cliente.setTelefono(req.getParameter("telefono"));
                cliente.setEmail(req.getParameter("email"));
                clienteDAO.actualizar(cliente);
            } else if ("delete".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                clienteDAO.eliminar(id);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        resp.sendRedirect(req.getContextPath() + "/cliente");
    }

    @Override
    public void destroy() {
        if (emf != null) {
            emf.close();
        }
    }
} 