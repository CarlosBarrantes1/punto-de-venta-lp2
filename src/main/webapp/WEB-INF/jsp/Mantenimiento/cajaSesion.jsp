<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.cibertec.model.CajaSesion" %>
<%@ page import="com.cibertec.model.Caja" %>
<%@ page import="com.cibertec.model.Usuario" %>

<div class="d-flex">
    <%@ include file="../sidebar.jsp" %>
    <div class="flex-grow-1">
        <div class="tab-content">
            <div class="tab-pane fade show active" id="cajaSesion" role="tabpanel">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2>Detalle de Sesiones de Caja</h2>
                    <a href="<%= request.getContextPath() %>/caja" class="btn btn-secondary">Volver</a>
                </div>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID Sesión</th>
                            <th>Caja</th>
                            <th>Usuario</th>
                            <th>Fecha Apertura</th>
                            <th>Monto Inicial</th>
                            <th>Fecha Cierre</th>
                            <th>Monto Cierre</th>
                            <th>Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            java.util.List sesiones = (java.util.List) request.getAttribute("sesiones");
                            if (sesiones != null) {
                                for (Object obj : sesiones) {
                                    com.cibertec.model.CajaSesion sesion = (com.cibertec.model.CajaSesion) obj;
                        %>
                        <tr>
                            <td><%= sesion.getId() %></td>
                            <td><%= (sesion.getCaja() != null) ? sesion.getCaja().getNombre() : "" %></td>
                            <td>
                                <%= (sesion.getUsuario() != null) ? sesion.getUsuario().getNombre() : "" %>
                                <%= (sesion.getUsuario() != null) ? sesion.getUsuario().getApellido() : "" %>
                            </td>
                            <td><%= sesion.getFechaApertura() %></td>
                            <td><%= sesion.getMontoInicial() %></td>
                            <td><%= sesion.getFechaCierre() != null ? sesion.getFechaCierre() : "" %></td>
                            <td><%= sesion.getMontoCierre() != null ? sesion.getMontoCierre() : "" %></td>
                            <td><%= sesion.getEstado() %></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>