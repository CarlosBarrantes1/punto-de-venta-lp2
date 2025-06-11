<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
                            if (cajas != null) {
                                for (Object obj : cajas) {
                                    com.cibertec.model.Caja caja = (com.cibertec.model.Caja) obj;
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
                                <button class="btn btn-sm btn-secondary edit-btn"
                                        data-bs-toggle="modal"
                                        data-bs-target="#cajaModal"
                                        data-id="<%= caja.getId() %>"
                                        data-codigo="<%= caja.getCodigo() %>"
                                        data-nombre="<%= caja.getNombre() %>"
                                        data-localid="<%= caja.getLocal() != null ? caja.getLocal().getId() : "" %>">
                                    Editar
                                </button>
                                <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal"
                                        data-id="<%= caja.getId() %>" data-nombre="<%= caja.getNombre() %>">Eliminar</button>
                            </td>
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

<!-- Add/Edit Caja Modal -->
<div class="modal fade" id="cajaModal" tabindex="-1" aria-labelledby="cajaModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" id="cajaForm">
        <input type="hidden" name="action" id="cajaAction" value="add" />
        <input type="hidden" name="id" id="cajaId" />
        <div class="modal-header">
          <h5 class="modal-title" id="cajaModalLabel">Agregar Caja</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
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
            <select class="form-select" id="local_id" name="local_id" required>
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
          <div class="mb-3">
            <label for="usuario" class="form-label">Usuario</label>
            <input type="text" class="form-control" id="usuario"
                   value="<%= request.getAttribute("usuarioLogueado") != null ? ((com.cibertec.model.Usuario)request.getAttribute("usuarioLogueado")).getNombre() + " " + ((com.cibertec.model.Usuario)request.getAttribute("usuarioLogueado")).getApellido() : "" %>" readonly>
          </div>
          <div class="mb-3">
            <label for="fechaCreacion" class="form-label">Fecha de Creación</label>
            <input type="text" class="form-control" id="fechaCreacion"
                   value="<%= request.getAttribute("fechaActual") != null ? request.getAttribute("fechaActual") : "" %>" readonly>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
          <button type="submit" class="btn btn-primary">Guardar</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
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
</script>