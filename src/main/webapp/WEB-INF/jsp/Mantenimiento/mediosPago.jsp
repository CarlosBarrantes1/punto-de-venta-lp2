<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="d-flex">
    <%@ include file="../sidebar.jsp" %>
    <div class="flex-grow-1">
        <div class="tab-content">
            <div class="tab-pane fade show active" id="mediosPago" role="tabpanel">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2>Medios de Pago</h2>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#medioPagoModal" id="addMedioPagoBtn">Agregar Medio de Pago</button>
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
                            java.util.List mediosPago = (java.util.List) request.getAttribute("mediosPago");
                            if (mediosPago != null) {
                                for (Object obj : mediosPago) {
                                    com.cibertec.model.MedioPago medioPago = (com.cibertec.model.MedioPago) obj;
                        %>
                        <tr>
                            <td><%= medioPago.getId() %></td>
                            <td><%= medioPago.getNombre() %></td>
                            <td><%= medioPago.getDescripcion() %></td>
                            <td>
                                <button class="btn btn-sm btn-secondary edit-btn" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#medioPagoModal"
                                        data-id="<%= medioPago.getId() %>"
                                        data-nombre="<%= medioPago.getNombre() %>"
                                        data-descripcion="<%= medioPago.getDescripcion() %>">Editar</button>
                                <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="<%= medioPago.getId() %>" data-nombre="<%= medioPago.getNombre() %>">Eliminar</button>
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
<!-- Add/Edit MedioPago Modal -->
<div class="modal fade" id="medioPagoModal" tabindex="-1" aria-labelledby="medioPagoModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" id="medioPagoForm">
        <input type="hidden" name="action" id="medioPagoAction" value="add" />
        <input type="hidden" name="id" id="medioPagoId" />
        <div class="modal-header">
          <h5 class="modal-title" id="medioPagoModalLabel">Agregar Medio de Pago</h5>
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
        <input type="hidden" name="id" id="deleteMedioPagoId" />
        <div class="modal-header">
          <h5 class="modal-title" id="deleteModalLabel">Confirmar Eliminación</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          ¿Está seguro que desea eliminar el medio de pago <span id="deleteMedioPagoNombre"></span>?
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
// Pass medioPago id and name to delete modal
var deleteModal = document.getElementById('deleteModal');
deleteModal.addEventListener('show.bs.modal', function (event) {
  var button = event.relatedTarget;
  var id = button.getAttribute('data-id');
  var nombre = button.getAttribute('data-nombre');
  document.getElementById('deleteMedioPagoId').value = id;
  document.getElementById('deleteMedioPagoNombre').textContent = nombre;
});

// Edit functionality
var medioPagoModal = document.getElementById('medioPagoModal');
medioPagoModal.addEventListener('show.bs.modal', function (event) {
  var button = event.relatedTarget;
  var modalTitle = document.getElementById('medioPagoModalLabel');
  var actionInput = document.getElementById('medioPagoAction');
  var idInput = document.getElementById('medioPagoId');
  var nombreInput = document.getElementById('nombre');
  var descripcionInput = document.getElementById('descripcion');

  if (button && button.classList.contains('edit-btn')) {
    // Edit mode
    modalTitle.textContent = 'Editar Medio de Pago';
    actionInput.value = 'edit';
    idInput.value = button.getAttribute('data-id');
    nombreInput.value = button.getAttribute('data-nombre');
    descripcionInput.value = button.getAttribute('data-descripcion');
  } else {
    // Add mode
    modalTitle.textContent = 'Agregar Medio de Pago';
    actionInput.value = 'add';
    idInput.value = '';
    nombreInput.value = '';
    descripcionInput.value = '';
  }
});
// Reset modal on close
medioPagoModal.addEventListener('hidden.bs.modal', function () {
  document.getElementById('medioPagoForm').reset();
});
</script> 