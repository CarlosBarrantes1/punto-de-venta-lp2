<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="d-flex">
    <%@ include file="../sidebar.jsp" %>
    <div class="flex-grow-1">
        <div class="tab-content">
            <div class="tab-pane fade show active" id="cajas" role="tabpanel">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2>Cajas</h2>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#cajaModal" id="addCajaBtn">Agregar Caja</button>
                </div>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Código</th>
                            <th>Nombre</th>
                            <th>Local</th>
                            <th>Usuario</th>
                            <th>Fecha de Creación</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            java.util.List cajas = (java.util.List) request.getAttribute("cajas");
                            java.util.Map sesionesActivas = (java.util.Map) request.getAttribute("sesionesActivas");
                            java.util.Map sesionesPorCaja = (java.util.Map) request.getAttribute("sesionesPorCaja");
                            if (cajas != null) {
                                for (Object obj : cajas) {
                                    com.cibertec.model.Caja caja = (com.cibertec.model.Caja) obj;
                                    com.cibertec.model.CajaSesion sesion = null;
                                    if (sesionesActivas != null) {
                                        sesion = (com.cibertec.model.CajaSesion) sesionesActivas.get(caja.getId());
                                    }
                                    // MODIFICADO: Manejo seguro de cantidadSesiones
                                    Integer cantidadSesiones = 0;
                                    if (sesionesPorCaja != null) {
                                        Object cantidadObj = sesionesPorCaja.get(caja.getId());
                                        if (cantidadObj != null) {
                                            cantidadSesiones = (Integer) cantidadObj;
                                        }
                                    }
                        %>
                        <tr>
                            <td><%= caja.getId() %></td>
                            <td><%= caja.getCodigo() %></td>
                            <td><%= caja.getNombre() %></td>
                            <td>
                                <% if (caja.getLocal() != null) { %>
                                    <span class="badge bg-primary"><%= caja.getLocal().getNombre() %></span>
                                <% } %>
                            </td>
                            <td>
                                <% if (caja.getUsuario() != null) { %>
                                    <%= caja.getUsuario().getNombre() %> <%= caja.getUsuario().getApellido() %>
                                <% } %>
                            </td>
                            <td><%= caja.getFechaCreacion() %></td>
                            <td>
                                <% if (sesion == null) { %>
                                    <button class="btn btn-info btn-sm abrir-btn" data-id="<%= caja.getId() %>">Abrir</button>
                                <% } else { %>
                                    <button class="btn btn-success btn-sm cerrar-btn" 
                                            data-id="<%= caja.getId() %>" 
                                            data-sesionid="<%= sesion.getId() %>">Cerrar</button>
                                <% } %>
                                <button class="btn btn-sm btn-secondary edit-btn"
                                        data-bs-toggle="modal"
                                        data-bs-target="#cajaModal"
                                        data-id="<%= caja.getId() %>"
                                        data-codigo="<%= caja.getCodigo() %>"
                                        data-nombre="<%= caja.getNombre() %>"
                                        data-localid="<%= caja.getLocal() != null ? caja.getLocal().getId() : "" %>">
                                    Editar
                                </button>
                                <% if (cantidadSesiones == null || cantidadSesiones == 0) { %>
                                <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal"
                                        data-id="<%= caja.getId() %>" data-nombre="<%= caja.getNombre() %>">Eliminar</button>
                                <% } %>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
                <!-- Botón para ver sesiones -->
                <div class="mt-3">
                  <form action="<%= request.getContextPath() %>/cajaSesion" method="get" style="display:inline;">
                    <button type="submit" class="btn btn-outline-primary">Ver Sesiones</button>
                  </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal para agregar/editar caja -->
<div class="modal fade" id="cajaModal" tabindex="-1" aria-labelledby="cajaModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form id="cajaForm" method="post" action="<%= request.getContextPath() %>/caja">
        <input type="hidden" id="cajaAction" name="action" value="add" />
        <input type="hidden" id="cajaId" name="id" />
        <div class="modal-header">
          <h5 class="modal-title" id="cajaModalLabel">Agregar Caja</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="codigo" class="form-label">Código</label>
            <input type="text" class="form-control" id="codigo" name="codigo" required>
          </div>
          <div class="mb-3">
            <label for="nombre" class="form-label">Nombre</label>
            <input type="text" class="form-control" id="nombre" name="nombre" required>
          </div>
          <div class="mb-3">
            <label for="local_id" class="form-label">Local</label>
            <select class="form-control" id="local_id" name="local_id" required>
              <option value="">Seleccione un local</option>
              <%
                java.util.List locales = (java.util.List) request.getAttribute("locales");
                if (locales != null) {
                    for (Object obj : locales) {
                        com.cibertec.model.Local local = (com.cibertec.model.Local) obj;
              %>
              <option value="<%= local.getId() %>"><%= local.getNombre() %></option>
              <%
                    }
                }
              %>
            </select>
          </div>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-primary">Guardar</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Modal para abrir caja -->
<div class="modal fade" id="abrirCajaModal" tabindex="-1" aria-labelledby="abrirCajaModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" id="abrirCajaForm" action="<%= request.getContextPath() %>/cajaSesion">
        <input type="hidden" name="action" value="abrirCaja" />
        <input type="hidden" name="caja_id" id="abrirCajaId" />
        <input type="hidden" name="usuario_id" value="2">
        <!-- Usuario logueado oculto -->
        <!-- <input type="hidden" name="usuario_id" value="2"
          !--"<%= request.getAttribute("usuarioLogueado") != null ? ((com.cibertec.model.Usuario)request.getAttribute("usuarioLogueado")).getId() : "" %>">--! -->
        <div class="modal-header">
          <h5 class="modal-title" id="abrirCajaModalLabel">Abrir Caja</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="monto_inicial" class="form-label">Monto Inicial</label>
            <input type="number" step="0.01" class="form-control" id="monto_inicial" name="monto_inicial" required>
          </div>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-primary">Guardar</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Modal para cerrar caja -->
<div class="modal fade" id="cerrarCajaModal" tabindex="-1" aria-labelledby="cerrarCajaModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" id="cerrarCajaForm" action="<%= request.getContextPath() %>/cajaSesion">
        <input type="hidden" name="action" value="cerrarCaja" />
        <input type="hidden" name="caja_id" id="cerrarCajaId" />
        <input type="hidden" name="sesion_id" id="cerrarSesionId" />
        <div class="modal-header">
          <h5 class="modal-title" id="cerrarCajaModalLabel">Cerrar Caja</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="monto_cierre" class="form-label">Monto de Cierre</label>
            <input type="number" step="0.01" class="form-control" id="monto_cierre" name="monto_cierre" required>
          </div>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-primary">Guardar</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="<%= request.getContextPath() %>/caja">
        <input type="hidden" name="action" value="delete" />
        <input type="hidden" name="id" id="deleteCajaId" />
        <div class="modal-header">
          <h5 class="modal-title" id="deleteModalLabel">Confirmar Eliminación</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          ¿Está seguro que desea eliminar la caja <span id="deleteCajaNombre"></span>?
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
          <button type="submit" class="btn btn-danger">Eliminar</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
// Delete modal
var deleteModal = document.getElementById('deleteModal');
deleteModal.addEventListener('show.bs.modal', function (event) {
  var button = event.relatedTarget;
  var id = button.getAttribute('data-id');
  var nombre = button.getAttribute('data-nombre');
  document.getElementById('deleteCajaId').value = id;
  document.getElementById('deleteCajaNombre').textContent = nombre;
});

// Edit functionality
var cajaModal = document.getElementById('cajaModal');
cajaModal.addEventListener('show.bs.modal', function (event) {
  var button = event.relatedTarget;
  var modalTitle = document.getElementById('cajaModalLabel');
  var actionInput = document.getElementById('cajaAction');
  var idInput = document.getElementById('cajaId');
  var codigoInput = document.getElementById('codigo');
  var nombreInput = document.getElementById('nombre');
  var localInput = document.getElementById('local_id');

  if (button && button.classList.contains('edit-btn')) {
    // Edit mode
    modalTitle.textContent = 'Editar Caja';
    actionInput.value = 'edit';
    idInput.value = button.getAttribute('data-id');
    codigoInput.value = button.getAttribute('data-codigo');
    nombreInput.value = button.getAttribute('data-nombre');
    localInput.value = button.getAttribute('data-localid');
  } else {
    // Add mode
    modalTitle.textContent = 'Agregar Caja';
    actionInput.value = 'add';
    idInput.value = '';
    codigoInput.value = '';
    nombreInput.value = '';
    localInput.value = '';
  }
});
// Reset modal on close
cajaModal.addEventListener('hidden.bs.modal', function () {
  document.getElementById('cajaForm').reset();
});

// Abrir caja: pasar el id de la caja al modal
document.querySelectorAll('.abrir-btn').forEach(function(btn) {
    btn.addEventListener('click', function() {
        document.getElementById('abrirCajaId').value = btn.getAttribute('data-id');
        var abrirModal = new bootstrap.Modal(document.getElementById('abrirCajaModal'));
        abrirModal.show();
    });
});

// Cerrar caja: pasar el id de la caja y sesión al modal
document.querySelectorAll('.cerrar-btn').forEach(function(btn) {
    btn.addEventListener('click', function() {
        document.getElementById('cerrarCajaId').value = btn.getAttribute('data-id');
        document.getElementById('cerrarSesionId').value = btn.getAttribute('data-sesionid');
        var cerrarModal = new bootstrap.Modal(document.getElementById('cerrarCajaModal'));
        cerrarModal.show();
    });
});
</script>