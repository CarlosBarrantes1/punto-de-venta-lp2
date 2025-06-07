<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="d-flex">
    <%@ include file="../sidebar.jsp" %>
    <div class="flex-grow-1">
        <div class="tab-content">
            <div class="tab-pane fade show active" id="locales" role="tabpanel">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2>Locales</h2>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#localModal" id="addLocalBtn">Agregar Local</button>
                </div>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>Dirección</th>
                            <th>Teléfono</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            java.util.List locales = (java.util.List) request.getAttribute("locales");
                            if (locales != null) {
                                for (Object obj : locales) {
                                    com.cibertec.model.Local local = (com.cibertec.model.Local) obj;
                        %>
                        <tr>
                            <td><%= local.getId() %></td>
                            <td><%= local.getNombre() %></td>
                            <td><%= local.getDireccion() %></td>
                            <td><%= local.getTelefono() %></td>
                            <td>
                                <button class="btn btn-sm btn-secondary edit-btn" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#localModal"
                                        data-id="<%= local.getId() %>"
                                        data-nombre="<%= local.getNombre() %>"
                                        data-direccion="<%= local.getDireccion() %>"
                                        data-telefono="<%= local.getTelefono() %>">Editar</button>
                                <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="<%= local.getId() %>" data-nombre="<%= local.getNombre() %>">Eliminar</button>
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
<!-- Add/Edit Local Modal -->
<div class="modal fade" id="localModal" tabindex="-1" aria-labelledby="localModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" id="localForm">
        <input type="hidden" name="action" id="localAction" value="add" />
        <input type="hidden" name="id" id="localId" />
        <div class="modal-header">
          <h5 class="modal-title" id="localModalLabel">Agregar Local</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="nombre" class="form-label">Nombre</label>
            <input type="text" class="form-control" id="nombre" name="nombre" required>
          </div>
          <div class="mb-3">
            <label for="direccion" class="form-label">Dirección</label>
            <input type="text" class="form-control" id="direccion" name="direccion" required>
          </div>
          <div class="mb-3">
            <label for="telefono" class="form-label">Teléfono</label>
            <input type="tel" class="form-control" id="telefono" name="telefono" required>
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
        <input type="hidden" name="id" id="deleteLocalId" />
        <div class="modal-header">
          <h5 class="modal-title" id="deleteModalLabel">Confirmar Eliminación</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          ¿Está seguro que desea eliminar el local <span id="deleteLocalNombre"></span>?
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
// Pass local id and name to delete modal
var deleteModal = document.getElementById('deleteModal');
deleteModal.addEventListener('show.bs.modal', function (event) {
  var button = event.relatedTarget;
  var id = button.getAttribute('data-id');
  var nombre = button.getAttribute('data-nombre');
  document.getElementById('deleteLocalId').value = id;
  document.getElementById('deleteLocalNombre').textContent = nombre;
});

// Edit functionality
var localModal = document.getElementById('localModal');
localModal.addEventListener('show.bs.modal', function (event) {
  var button = event.relatedTarget;
  var modalTitle = document.getElementById('localModalLabel');
  var actionInput = document.getElementById('localAction');
  var idInput = document.getElementById('localId');
  var nombreInput = document.getElementById('nombre');
  var direccionInput = document.getElementById('direccion');
  var telefonoInput = document.getElementById('telefono');

  if (button && button.classList.contains('edit-btn')) {
    // Edit mode
    modalTitle.textContent = 'Editar Local';
    actionInput.value = 'edit';
    idInput.value = button.getAttribute('data-id');
    nombreInput.value = button.getAttribute('data-nombre');
    direccionInput.value = button.getAttribute('data-direccion');
    telefonoInput.value = button.getAttribute('data-telefono');
  } else {
    // Add mode
    modalTitle.textContent = 'Agregar Local';
    actionInput.value = 'add';
    idInput.value = '';
    nombreInput.value = '';
    direccionInput.value = '';
    telefonoInput.value = '';
  }
});
// Reset modal on close
localModal.addEventListener('hidden.bs.modal', function () {
  document.getElementById('localForm').reset();
});
</script> 