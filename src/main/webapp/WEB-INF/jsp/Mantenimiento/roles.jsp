<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="d-flex">
    <%@ include file="../sidebar.jsp" %>
    <div class="flex-grow-1">
        <div class="tab-content">
            <div class="tab-pane fade show active" id="roles" role="tabpanel">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2>Roles</h2>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#rolModal" id="addRolBtn">Agregar Rol</button>
                </div>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>Descripción</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            java.util.List roles = (java.util.List) request.getAttribute("roles");
                            if (roles != null) {
                                for (Object obj : roles) {
                                    com.cibertec.model.Rol rol = (com.cibertec.model.Rol) obj;
                        %>
                        <tr>
                            <td><%= rol.getId() %></td>
                            <td><%= rol.getNombre() %></td>
                            <td><%= rol.getDescripcion() %></td>
                            <td>
                                <button class="btn btn-sm btn-secondary edit-btn" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#rolModal"
                                        data-id="<%= rol.getId() %>"
                                        data-nombre="<%= rol.getNombre() %>"
                                        data-descripcion="<%= rol.getDescripcion() %>">Editar</button>
                                <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="<%= rol.getId() %>" data-nombre="<%= rol.getNombre() %>">Eliminar</button>
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
<!-- Add/Edit Rol Modal -->
<div class="modal fade" id="rolModal" tabindex="-1" aria-labelledby="rolModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" id="rolForm">
        <input type="hidden" name="action" id="rolAction" value="add" />
        <input type="hidden" name="id" id="rolId" />
        <div class="modal-header">
          <h5 class="modal-title" id="rolModalLabel">Agregar Rol</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="nombre" class="form-label">Nombre</label>
            <input type="text" class="form-control" id="nombre" name="nombre" required>
          </div>
          <div class="mb-3">
            <label for="descripcion" class="form-label">Descripción</label>
            <textarea class="form-control" id="descripcion" name="descripcion" rows="3"></textarea>
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
        <input type="hidden" name="id" id="deleteRolId" />
        <div class="modal-header">
          <h5 class="modal-title" id="deleteModalLabel">Confirmar Eliminación</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          ¿Está seguro que desea eliminar el rol <span id="deleteRolNombre"></span>?
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
// Pass rol id and name to delete modal
var deleteModal = document.getElementById('deleteModal');
deleteModal.addEventListener('show.bs.modal', function (event) {
  var button = event.relatedTarget;
  var id = button.getAttribute('data-id');
  var nombre = button.getAttribute('data-nombre');
  document.getElementById('deleteRolId').value = id;
  document.getElementById('deleteRolNombre').textContent = nombre;
});

// Edit functionality
var rolModal = document.getElementById('rolModal');
rolModal.addEventListener('show.bs.modal', function (event) {
  var button = event.relatedTarget;
  var modalTitle = document.getElementById('rolModalLabel');
  var actionInput = document.getElementById('rolAction');
  var idInput = document.getElementById('rolId');
  var nombreInput = document.getElementById('nombre');
  var descripcionInput = document.getElementById('descripcion');

  if (button && button.classList.contains('edit-btn')) {
    // Edit mode
    modalTitle.textContent = 'Editar Rol';
    actionInput.value = 'edit';
    idInput.value = button.getAttribute('data-id');
    nombreInput.value = button.getAttribute('data-nombre');
    descripcionInput.value = button.getAttribute('data-descripcion');
  } else {
    // Add mode
    modalTitle.textContent = 'Agregar Rol';
    actionInput.value = 'add';
    idInput.value = '';
    nombreInput.value = '';
    descripcionInput.value = '';
  }
});
// Reset modal on close
rolModal.addEventListener('hidden.bs.modal', function () {
  document.getElementById('rolForm').reset();
});
</script> 