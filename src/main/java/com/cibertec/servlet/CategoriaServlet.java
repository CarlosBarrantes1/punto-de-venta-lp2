package com.cibertec.servlet;

import com.cibertec.dao.CategoriaDAO;
import com.cibertec.model.Categoria;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class CategoriaServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("my-webapp");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        CategoriaDAO categoriaDAO = new CategoriaDAO(em);
        List<Categoria> categorias = categoriaDAO.listar();
        System.out.println("Categorias size: " + categorias.size());
        em.close();
        req.setAttribute("categorias", categorias);
        req.setAttribute("contentPage", "Mantenimiento/categorias.jsp");
        req.getRequestDispatcher("/WEB-INF/jsp/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        CategoriaDAO categoriaDAO = new CategoriaDAO(em);
        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) {
                String nombre = req.getParameter("nombre");
                String descripcion = req.getParameter("descripcion");
                categoriaDAO.guardar(new Categoria(nombre, descripcion));
            } else if ("edit".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                Categoria categoria = categoriaDAO.obtener(id);
                categoria.setNombre(req.getParameter("nombre"));
                categoria.setDescripcion(req.getParameter("descripcion"));
                categoriaDAO.actualizar(categoria);
            } else if ("delete".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                categoriaDAO.eliminar(id);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        resp.sendRedirect(req.getContextPath() + "/categoria");
    }

    @Override
    public void destroy() {
        if (emf != null) {
            emf.close();
        }
    }
} 