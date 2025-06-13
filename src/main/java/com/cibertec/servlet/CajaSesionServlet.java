package com.cibertec.servlet;

import com.cibertec.dao.CajaSesionDAO;
import com.cibertec.dao.CajaDAO;
import com.cibertec.dao.UsuarioDAO;
import com.cibertec.model.CajaSesion;
import com.cibertec.model.Caja;
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
import java.util.Map;
import java.util.HashMap;
import java.time.LocalDateTime;

public class CajaSesionServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("my-webapp");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        CajaSesionDAO cajaSesionDAO = new CajaSesionDAO(em);
        CajaDAO cajaDAO = new CajaDAO(em);

        List<CajaSesion> sesiones = cajaSesionDAO.listar();
        List<Caja> cajas = cajaDAO.listar();

        // Agregado: sesionesActivas solo con estado "ABIERTA"
        Map<Long, CajaSesion> sesionesActivas = new HashMap<>();
        for (CajaSesion sesion : sesiones) {
            if ("ABIERTA".equals(sesion.getEstado())) {
                sesionesActivas.put(sesion.getCaja().getId(), sesion);
            }
        }

        Usuario usuarioLogueado = (Usuario) req.getSession().getAttribute("usuarioLogueado");
        LocalDateTime fechaActual = LocalDateTime.now();

        em.close();

        req.setAttribute("sesiones", sesiones);
        req.setAttribute("cajas", cajas);
        req.setAttribute("sesionesActivas", sesionesActivas); // <-- agregado
        req.setAttribute("usuarioLogueado", usuarioLogueado);
        req.setAttribute("fechaActual", fechaActual);
        req.setAttribute("contentPage", "Mantenimiento/cajaSesion.jsp");
        req.getRequestDispatcher("/WEB-INF/jsp/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        CajaSesionDAO cajaSesionDAO = new CajaSesionDAO(em);
        CajaDAO cajaDAO = new CajaDAO(em);
        UsuarioDAO usuarioDAO = new UsuarioDAO(em);

        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) {
                Long cajaId = Long.parseLong(req.getParameter("caja_id"));
                Long usuarioId = Long.parseLong(req.getParameter("usuario_id"));
                double montoInicial = Double.parseDouble(req.getParameter("monto_inicial"));
                String estado = req.getParameter("estado");
                if (estado == null || estado.isEmpty()) {
                    estado = "ABIERTA";
                }

                Caja caja = cajaDAO.obtener(cajaId);
                Usuario usuario = usuarioDAO.obtener(usuarioId);

                CajaSesion sesion = new CajaSesion();
                sesion.setCaja(caja);
                sesion.setUsuario(usuario);
                sesion.setFechaApertura(LocalDateTime.now());
                sesion.setMontoInicial(montoInicial);
                sesion.setEstado(estado);

                cajaSesionDAO.guardar(sesion);
                // Redirige a la lista de cajas
                resp.sendRedirect(req.getContextPath() + "/caja");
                return;
            } else if ("abrirCaja".equals(action)) {
                // Acción desde el modal de abrir caja en caja.jsp
                Long cajaId = Long.parseLong(req.getParameter("caja_id"));
                Long usuarioId = Long.parseLong(req.getParameter("usuario_id"));
                double montoInicial = Double.parseDouble(req.getParameter("monto_inicial"));

                Caja caja = cajaDAO.obtener(cajaId);
                Usuario usuario = usuarioDAO.obtener(usuarioId);

                CajaSesion sesion = new CajaSesion();
                sesion.setCaja(caja);
                sesion.setUsuario(usuario);
                sesion.setFechaApertura(LocalDateTime.now());
                sesion.setMontoInicial(montoInicial);
                sesion.setEstado("ABIERTA");

                cajaSesionDAO.guardar(sesion);

                // Prepara datos y muestra cajaSesion.jsp
                List<CajaSesion> sesiones = cajaSesionDAO.listar();
                List<Caja> cajas = cajaDAO.listar();

                // Agregado: sesionesActivas solo con estado "ABIERTA"
                Map<Long, CajaSesion> sesionesActivas = new HashMap<>();
                for (CajaSesion s : sesiones) {
                    if ("ABIERTA".equals(s.getEstado())) {
                        sesionesActivas.put(s.getCaja().getId(), s);
                    }
                }

                Usuario usuarioLogueado = (Usuario) req.getSession().getAttribute("usuarioLogueado");
                LocalDateTime fechaActual = LocalDateTime.now();

                req.setAttribute("sesiones", sesiones);
                req.setAttribute("cajas", cajas);
                req.setAttribute("sesionesActivas", sesionesActivas); // <-- agregado
                req.setAttribute("usuarioLogueado", usuarioLogueado);
                req.setAttribute("fechaActual", fechaActual);
                req.setAttribute("contentPage", "Mantenimiento/cajaSesion.jsp");
                req.getRequestDispatcher("/WEB-INF/jsp/layout.jsp").forward(req, resp);
                return;
            } else if ("cerrarCaja".equals(action)) {
                Long cajaId = Long.parseLong(req.getParameter("caja_id"));
                Long sesionId = Long.parseLong(req.getParameter("sesion_id"));
                double montoCierre = Double.parseDouble(req.getParameter("monto_cierre"));

                CajaSesion sesion = cajaSesionDAO.obtener(sesionId);
                sesion.setMontoCierre(montoCierre);
                sesion.setFechaCierre(LocalDateTime.now());
                sesion.setEstado("CERRADA");
                cajaSesionDAO.actualizar(sesion);

                // Prepara datos y muestra cajaSesion.jsp
                List<CajaSesion> sesiones = cajaSesionDAO.listar();
                List<Caja> cajas = cajaDAO.listar();

                // Agregado: sesionesActivas solo con estado "ABIERTA"
                Map<Long, CajaSesion> sesionesActivas = new HashMap<>();
                for (CajaSesion s : sesiones) {
                    if ("ABIERTA".equals(s.getEstado())) {
                        sesionesActivas.put(s.getCaja().getId(), s);
                    }
                }

                Usuario usuarioLogueado = (Usuario) req.getSession().getAttribute("usuarioLogueado");
                LocalDateTime fechaActual = LocalDateTime.now();

                req.setAttribute("sesiones", sesiones);
                req.setAttribute("cajas", cajas);
                req.setAttribute("sesionesActivas", sesionesActivas); // <-- agregado
                req.setAttribute("usuarioLogueado", usuarioLogueado);
                req.setAttribute("fechaActual", fechaActual);
                req.setAttribute("contentPage", "Mantenimiento/cajaSesion.jsp");
                req.getRequestDispatcher("/WEB-INF/jsp/layout.jsp").forward(req, resp);
                return;
            } else if ("edit".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                CajaSesion sesion = cajaSesionDAO.obtener(id);
                // Actualiza los campos necesarios...
                // Ejemplo: sesion.setEstado(req.getParameter("estado"));
                cajaSesionDAO.actualizar(sesion);
                resp.sendRedirect(req.getContextPath() + "/caja");
                return;
            } else if ("delete".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                cajaSesionDAO.eliminar(id);
                resp.sendRedirect(req.getContextPath() + "/caja");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    @Override
    public void destroy() {
        if (emf != null) {
            emf.close();
        }
    }
}