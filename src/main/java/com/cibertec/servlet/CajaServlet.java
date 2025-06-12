package com.cibertec.servlet;

import com.cibertec.dao.CajaDAO;
import com.cibertec.dao.CajaSesionDAO;
import com.cibertec.dao.LocalDAO;
import com.cibertec.model.Caja;
import com.cibertec.model.CajaSesion;
import com.cibertec.model.Usuario;
import com.cibertec.model.Local;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

public class CajaServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("my-webapp");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        CajaDAO cajaDAO = new CajaDAO(em);
        CajaSesionDAO cajaSesionDAO = new CajaSesionDAO(em);
        LocalDAO localDAO = new LocalDAO(em);

        List<Caja> cajas = cajaDAO.listar();
        List<Local> locales = localDAO.listar();
        List<CajaSesion> sesiones = cajaSesionDAO.listar();

        // Mapear la sesión activa (sin fechaCierre) por id de caja
        Map<Long, CajaSesion> sesionesActivas = new HashMap<>();
        for (CajaSesion sesion : sesiones) {
            if (sesion.getCaja() != null && sesion.getFechaCierre() == null) {
                sesionesActivas.put(sesion.getCaja().getId(), sesion);
            }
        }

        // NUEVO: Mapear cantidad de sesiones por caja (para ocultar botón eliminar si tiene sesiones)
        Map<Long, Integer> sesionesPorCaja = new HashMap<>();
        for (CajaSesion sesion : sesiones) {
            if (sesion.getCaja() != null) {
                Long cajaId = sesion.getCaja().getId();
                sesionesPorCaja.put(cajaId, sesionesPorCaja.getOrDefault(cajaId, 0) + 1);
            }
        }

        // Obtener usuario logueado desde la sesión
        Usuario usuarioLogueado = (Usuario) req.getSession().getAttribute("usuarioLogueado");

        // Fecha actual
        String fechaActual = java.time.LocalDateTime.now().toString();

        em.close();

        req.setAttribute("cajas", cajas);
        req.setAttribute("locales", locales);
        req.setAttribute("sesionesActivas", sesionesActivas);
        req.setAttribute("sesionesPorCaja", sesionesPorCaja); // <-- NUEVO
        req.setAttribute("usuarioLogueado", usuarioLogueado);
        req.setAttribute("fechaActual", fechaActual);
        req.setAttribute("contentPage", "Mantenimiento/caja.jsp");
        req.getRequestDispatcher("/WEB-INF/jsp/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        CajaDAO cajaDAO = new CajaDAO(em);
        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) {
                String codigo = req.getParameter("codigo");
                String nombre = req.getParameter("nombre");
                Long localId = Long.parseLong(req.getParameter("local_id"));
                Local local = em.find(Local.class, localId);

                // Usuario logueado desde la sesión (no editable)
                Usuario usuario = (Usuario) req.getSession().getAttribute("usuarioLogueado");

                Caja caja = new Caja(codigo, nombre, LocalDateTime.now(), usuario, local);
                cajaDAO.guardar(caja);
            } else if ("edit".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                Caja caja = cajaDAO.obtener(id);
                caja.setCodigo(req.getParameter("codigo"));
                caja.setNombre(req.getParameter("nombre"));
                Long localId = Long.parseLong(req.getParameter("local_id"));
                Local local = em.find(Local.class, localId);
                caja.setLocal(local);

                // Usuario logueado desde la sesión (no editable)
                Usuario usuario = (Usuario) req.getSession().getAttribute("usuarioLogueado");
                caja.setUsuario(usuario);

                cajaDAO.actualizar(caja);
            } else if ("delete".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                cajaDAO.eliminar(id);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        resp.sendRedirect(req.getContextPath() + "/caja");
    }

    @Override
    public void destroy() {
        if (emf != null) {
            emf.close();
        }
    }
}