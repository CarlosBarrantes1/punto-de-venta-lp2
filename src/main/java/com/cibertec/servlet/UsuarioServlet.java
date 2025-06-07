package com.cibertec.servlet;

import com.cibertec.dao.RolDAO;
import com.cibertec.dao.UsuarioDAO;
import com.cibertec.model.Rol;
import com.cibertec.model.Usuario;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class UsuarioServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("my-webapp");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        UsuarioDAO usuarioDAO = new UsuarioDAO(em);
        RolDAO rolDAO = new RolDAO(em);
        List<Usuario> usuarios = usuarioDAO.listar();
        List<Rol> roles = rolDAO.listar();
        System.out.println("Usuarios size: " + usuarios.size());
        em.close();
        req.setAttribute("usuarios", usuarios);
        req.setAttribute("roles", roles);
        req.setAttribute("contentPage", "Mantenimiento/usuarios.jsp");
        req.getRequestDispatcher("/WEB-INF/jsp/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        UsuarioDAO usuarioDAO = new UsuarioDAO(em);
        RolDAO rolDAO = new RolDAO(em);
        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) {
                String nombre = req.getParameter("nombre");
                String apellido = req.getParameter("apellido");
                String email = req.getParameter("email");
                String password = req.getParameter("password");
                String telefono = req.getParameter("telefono");
                String rolId = req.getParameter("rol");
                
                Usuario usuario = new Usuario(nombre, apellido, email, password);
                usuario.setTelefono(telefono);
                
                if (rolId != null && !rolId.isEmpty()) {
                    Rol rol = rolDAO.obtener(Long.parseLong(rolId));
                    if (rol != null) {
                        usuario.setRol(rol);
                    }
                }
                usuarioDAO.guardar(usuario);
            } else if ("edit".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                Usuario usuario = usuarioDAO.obtener(id);
                usuario.setNombre(req.getParameter("nombre"));
                usuario.setApellido(req.getParameter("apellido"));
                usuario.setEmail(req.getParameter("email"));
                usuario.setPassword(req.getParameter("password"));
                usuario.setTelefono(req.getParameter("telefono"));
                
                String rolId = req.getParameter("rol");
                if (rolId != null && !rolId.isEmpty()) {
                    Rol rol = rolDAO.obtener(Long.parseLong(rolId));
                    if (rol != null) {
                        usuario.setRol(rol);
                    }
                } else {
                    usuario.setRol(null);
                }
                usuarioDAO.actualizar(usuario);
            } else if ("delete".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                usuarioDAO.eliminar(id);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        resp.sendRedirect(req.getContextPath() + "/usuario");
    }

    @Override
    public void destroy() {
        if (emf != null) {
            emf.close();
        }
    }
} 