package com.cibertec.servlet;

import com.cibertec.dao.ProductoDAO;
import com.cibertec.dao.CategoriaDAO;
import com.cibertec.model.Producto;
import com.cibertec.model.Categoria;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

public class ProductoServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("my-webapp");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        ProductoDAO productoDAO = new ProductoDAO(em);
        CategoriaDAO categoriaDAO = new CategoriaDAO(em);
        List<Producto> productos = productoDAO.listar();
        List<Categoria> categorias = categoriaDAO.listar();
        System.out.println("Productos size: " + productos.size());
        em.close();
        req.setAttribute("productos", productos);
        req.setAttribute("categorias", categorias);
        req.setAttribute("contentPage", "Mantenimiento/productos.jsp");
        req.getRequestDispatcher("/WEB-INF/jsp/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        ProductoDAO productoDAO = new ProductoDAO(em);
        CategoriaDAO categoriaDAO = new CategoriaDAO(em);
        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) {
                String codigo = req.getParameter("codigo");
                String nombre = req.getParameter("nombre");
                String descripcion = req.getParameter("descripcion");
                BigDecimal precio = new BigDecimal(req.getParameter("precio"));
                Long categoriaId = Long.parseLong(req.getParameter("categoria_id"));
                Categoria categoria = categoriaDAO.obtener(categoriaId);
                Producto producto = new Producto(codigo, nombre, descripcion, precio, categoria);
                producto.setImagen(req.getParameter("imagen"));
                productoDAO.guardar(producto);
            } else if ("edit".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                Producto producto = productoDAO.obtener(id);
                producto.setCodigo(req.getParameter("codigo"));
                producto.setNombre(req.getParameter("nombre"));
                producto.setDescripcion(req.getParameter("descripcion"));
                producto.setPrecio(new BigDecimal(req.getParameter("precio")));
                producto.setImagen(req.getParameter("imagen"));
                Long categoriaId = Long.parseLong(req.getParameter("categoria_id"));
                Categoria categoria = categoriaDAO.obtener(categoriaId);
                producto.setCategoria(categoria);
                productoDAO.actualizar(producto);
            } else if ("delete".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                productoDAO.eliminar(id);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        resp.sendRedirect(req.getContextPath() + "/producto");
    }

    @Override
    public void destroy() {
        if (emf != null) {
            emf.close();
        }
    }
} 