<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="d-flex">
    <%@ include file="../sidebar.jsp" %>
    <div class="flex-grow-1">
        <div class="tab-content">
            <div class="tab-pane fade show active" id="productos" role="tabpanel">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2>Productos</h2>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#productoModal" id="addProductoBtn">Agregar Producto</button>
                </div>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Código</th>
                            <th>Nombre</th>
                            <th>Descripción</th>
                            <th>Precio</th>
                            <th>Categoría</th>
                            <th>Imagen</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            java.util.List productos = (java.util.List) request.getAttribute("productos");
                            if (productos != null) {
                                for (Object obj : productos) {
                                    com.cibertec.model.Producto producto = (com.cibertec.model.Producto) obj;
                        %>
                        <tr>
                            <td><%= producto.getId() %></td>
                            <td><%= producto.getCodigo() %></td>
                            <td><%= producto.getNombre() %></td>
                            <td><%= producto.getDescripcion() %></td>
                            <td><%= producto.getPrecio() %></td>
                            <td><%= producto.getCategoria().getNombre() %></td>
                            <td>
                                <% if (producto.getImagen() != null && !producto.getImagen().isEmpty()) { %>
                                    <img src="<%= producto.getImagen() %>" alt="<%= producto.getNombre() %>" style="max-width: 50px; max-height: 50px;">
                                <% } %>
                            </td>
                            <td>
                                <button class="btn btn-sm btn-secondary edit-btn" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#productoModal"
                                        data-id="<%= producto.getId() %>"
                                        data-codigo="<%= producto.getCodigo() %>"
                                        data-nombre="<%= producto.getNombre() %>"
                                        data-descripcion="<%= producto.getDescripcion() %>"
                                        data-precio="<%= producto.getPrecio() %>"
                                        data-categoria-id="<%= producto.getCategoria().getId() %>"
                                        data-imagen="<%= producto.getImagen() %>">Editar</button>
                                <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="<%= producto.getId() %>" data-nombre="<%= producto.getNombre() %>">Eliminar</button>
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
<!-- Add/Edit Producto Modal -->
<div class="modal fade" id="productoModal" tabindex="-1" aria-labelledby="productoModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" id="productoForm">
        <input type="hidden" name="action" id="productoAction" value="add" />
        <input type="hidden" name="id" id="productoId" />
        <div class="modal-header">
          <h5 class="modal-title" id="productoModalLabel">Agregar Producto</h5>
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
            <label for="descripcion" class="form-label">Descripción</label>
            <textarea class="form-control" id="descripcion" name="descripcion" rows="3"></textarea>
          </div>
          <div class="mb-3">
            <label for="precio" class="form-label">Precio</label>
            <input type="number" step="0.01" class="form-control" id="precio" name="precio" required>
          </div>
          <div class="mb-3">
            <label for="categoria_id" class="form-label">Categoría</label>
            <select class="form-select" id="categoria_id" name="categoria_id" required>
              <option value="">Seleccione una categoría</option>
              <%
                  java.util.List categorias = (java.util.List) request.getAttribute("categorias");
                  if (categorias != null) {
                      for (Object obj : categorias) {
                          com.cibertec.model.Categoria categoria = (com.cibertec.model.Categoria) obj;
              %>
              <option value="<%= categoria.getId() %>"><%= categoria.getNombre() %></option>
              <%
                      }
                  }
              %>
            </select>
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
        <input type="hidden" name="id" id="deleteProductoId" />
        <div class="modal-header">
          <h5 class="modal-title" id="deleteModalLabel">Confirmar Eliminación</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          ¿Está seguro que desea eliminar el producto <span id="deleteProductoNombre"></span>?
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
// Pass producto id and name to delete modal
var deleteModal = document.getElementById('deleteModal');
deleteModal.addEventListener('show.bs.modal', function (event) {
  var button = event.relatedTarget;
  var id = button.getAttribute('data-id');
  var nombre = button.getAttribute('data-nombre');
  document.getElementById('deleteProductoId').value = id;
  document.getElementById('deleteProductoNombre').textContent = nombre;
});

// Edit functionality
var productoModal = document.getElementById('productoModal');
productoModal.addEventListener('show.bs.modal', function (event) {
  var button = event.relatedTarget;
  var modalTitle = document.getElementById('productoModalLabel');
  var actionInput = document.getElementById('productoAction');
  var idInput = document.getElementById('productoId');
  var codigoInput = document.getElementById('codigo');
  var nombreInput = document.getElementById('nombre');
  var descripcionInput = document.getElementById('descripcion');
  var precioInput = document.getElementById('precio');
  var categoriaInput = document.getElementById('categoria_id');

  if (button && button.classList.contains('edit-btn')) {
    // Edit mode
    modalTitle.textContent = 'Editar Producto';
    actionInput.value = 'edit';
    idInput.value = button.getAttribute('data-id');
    codigoInput.value = button.getAttribute('data-codigo');
    nombreInput.value = button.getAttribute('data-nombre');
    descripcionInput.value = button.getAttribute('data-descripcion');
    precioInput.value = button.getAttribute('data-precio');
    categoriaInput.value = button.getAttribute('data-categoria-id');
  } else {
    // Add mode
    modalTitle.textContent = 'Agregar Producto';
    actionInput.value = 'add';
    idInput.value = '';
    codigoInput.value = '';
    nombreInput.value = '';
    descripcionInput.value = '';
    precioInput.value = '';
    categoriaInput.value = '';
  }
});
// Reset modal on close
productoModal.addEventListener('hidden.bs.modal', function () {
  document.getElementById('productoForm').reset();
});
</script> 