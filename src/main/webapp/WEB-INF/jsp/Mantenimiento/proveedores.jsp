<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="d-flex">
    <%@ include file="../sidebar.jsp" %>
    <div class="flex-grow-1">
        <div class="tab-content">
            <div class="tab-pane fade show active" id="proveedores" role="tabpanel">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2>Proveedores</h2>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#proveedorModal" id="addProveedorBtn">Agregar Proveedor</button>
                </div>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>RUC</th>
                            <th>Razón Social</th>
                            <th>Dirección</th>
                            <th>Teléfono</th>
                            <th>Email</th>
                            <th>Contacto</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            java.util.List proveedores = (java.util.List) request.getAttribute("proveedores");
                            if (proveedores != null) {
                                for (Object obj : proveedores) {
                                    com.cibertec.model.Proveedor proveedor = (com.cibertec.model.Proveedor) obj;
                        %>
                        <tr>
                            <td><%= proveedor.getId() %></td>
                            <td><%= proveedor.getRuc() %></td>
                            <td><%= proveedor.getRazonSocial() %></td>
                            <td><%= proveedor.getDireccion() %></td>
                            <td><%= proveedor.getTelefono() %></td>
                            <td><%= proveedor.getEmail() %></td>
                            <td><%= proveedor.getContacto() %></td>
                            <td>
                                <button class="btn btn-sm btn-secondary edit-btn" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#proveedorModal"
                                        data-id="<%= proveedor.getId() %>"
                                        data-ruc="<%= proveedor.getRuc() %>"
                                        data-razon-social="<%= proveedor.getRazonSocial() %>"
                                        data-direccion="<%= proveedor.getDireccion() %>"
                                        data-telefono="<%= proveedor.getTelefono() %>"
                                        data-email="<%= proveedor.getEmail() %>"
                                        data-contacto="<%= proveedor.getContacto() %>">Editar</button>
                                <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="<%= proveedor.getId() %>" data-nombre="<%= proveedor.getRazonSocial() %>">Eliminar</button>
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
<!-- Add/Edit Proveedor Modal -->
<div class="modal fade" id="proveedorModal" tabindex="-1" aria-labelledby="proveedorModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" id="proveedorForm">
        <input type="hidden" name="action" id="proveedorAction" value="add" />
        <input type="hidden" name="id" id="proveedorId" />
        <div class="modal-header">
          <h5 class="modal-title" id="proveedorModalLabel">Agregar Proveedor</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="ruc" class="form-label">RUC</label>
            <input type="text" class="form-control" id="ruc" name="ruc" required>
          </div>
          <div class="mb-3">
            <label for="razonSocial" class="form-label">Razón Social</label>
            <input type="text" class="form-control" id="razonSocial" name="razonSocial" required>
          </div>
          <div class="mb-3">
            <label for="direccion" class="form-label">Dirección</label>
            <input type="text" class="form-control" id="direccion" name="direccion" required>
          </div>
          <div class="mb-3">
            <label for="telefono" class="form-label">Teléfono</label>
            <input type="tel" class="form-control" id="telefono" name="telefono" required>
          </div>
          <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" class="form-control" id="email" name="email" required>
          </div>
          <div class="mb-3">
            <label for="contacto" class="form-label">Contacto</label>
            <input type="text" class="form-control" id="contacto" name="contacto">
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
        <input type="hidden" name="id" id="deleteProveedorId" />
        <div class="modal-header">
          <h5 class="modal-title" id="deleteModalLabel">Confirmar Eliminación</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          ¿Está seguro que desea eliminar el proveedor <span id="deleteProveedorNombre"></span>?
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
// Pass proveedor id and name to delete modal
var deleteModal = document.getElementById('deleteModal');
deleteModal.addEventListener('show.bs.modal', function (event) {
  var button = event.relatedTarget;
  var id = button.getAttribute('data-id');
  var nombre = button.getAttribute('data-nombre');
  document.getElementById('deleteProveedorId').value = id;
  document.getElementById('deleteProveedorNombre').textContent = nombre;
});

// Edit functionality
var proveedorModal = document.getElementById('proveedorModal');
proveedorModal.addEventListener('show.bs.modal', function (event) {
  var button = event.relatedTarget;
  var modalTitle = document.getElementById('proveedorModalLabel');
  var actionInput = document.getElementById('proveedorAction');
  var idInput = document.getElementById('proveedorId');
  var rucInput = document.getElementById('ruc');
  var razonSocialInput = document.getElementById('razonSocial');
  var direccionInput = document.getElementById('direccion');
  var telefonoInput = document.getElementById('telefono');
  var emailInput = document.getElementById('email');
  var contactoInput = document.getElementById('contacto');

  if (button && button.classList.contains('edit-btn')) {
    // Edit mode
    modalTitle.textContent = 'Editar Proveedor';
    actionInput.value = 'edit';
    idInput.value = button.getAttribute('data-id');
    rucInput.value = button.getAttribute('data-ruc');
    razonSocialInput.value = button.getAttribute('data-razon-social');
    direccionInput.value = button.getAttribute('data-direccion');
    telefonoInput.value = button.getAttribute('data-telefono');
    emailInput.value = button.getAttribute('data-email');
    contactoInput.value = button.getAttribute('data-contacto');
  } else {
    // Add mode
    modalTitle.textContent = 'Agregar Proveedor';
    actionInput.value = 'add';
    idInput.value = '';
    rucInput.value = '';
    razonSocialInput.value = '';
    direccionInput.value = '';
    telefonoInput.value = '';
    emailInput.value = '';
    contactoInput.value = '';
  }
});
// Reset modal on close
proveedorModal.addEventListener('hidden.bs.modal', function () {
  document.getElementById('proveedorForm').reset();
});
</script> 