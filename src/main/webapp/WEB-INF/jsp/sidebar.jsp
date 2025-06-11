<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<div class="sidebar bg-light border-end">
    <div class="list-group list-group-flush">
        <a class="list-group-item list-group-item-action" href="<%= request.getContextPath() %>/inicio">Inicio</a>
        <div class="list-group-item p-0">
            <a class="list-group-item list-group-item-action d-flex justify-content-between align-items-center" 
               data-bs-toggle="collapse" 
               href="#mantenimientoCollapse" 
               role="button" 
               aria-expanded="false" 
               aria-controls="mantenimientoCollapse">
                Mantenimiento
                <i class="bi bi-chevron-down"></i>
            </a>
            <div class="collapse" id="mantenimientoCollapse">
                <div class="list-group list-group-flush">
                    <a class="list-group-item list-group-item-action ps-4" href="<%= request.getContextPath() %>/usuario">Usuarios</a>
                    <a class="list-group-item list-group-item-action ps-4" href="<%= request.getContextPath() %>/rol">Roles</a>
                    <a class="list-group-item list-group-item-action ps-4" href="<%= request.getContextPath() %>/producto">Productos</a>
                    <a class="list-group-item list-group-item-action ps-4" href="<%= request.getContextPath() %>/categoria">Categorías</a>
                    <a class="list-group-item list-group-item-action ps-4" href="<%= request.getContextPath() %>/local">Locales</a>
                    <a class="list-group-item list-group-item-action ps-4" href="<%= request.getContextPath() %>/medioPago">Medios de Pago</a>
                    <a class="list-group-item list-group-item-action ps-4" href="<%= request.getContextPath() %>/proveedor">Proveedores</a>
                    <a class="list-group-item list-group-item-action ps-4" href="<%= request.getContextPath() %>/cliente">Clientes</a>
                    <a class="list-group-item list-group-item-action ps-4" href="<%= request.getContextPath() %>/caja">Caja</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const mantenimientoCollapse = document.getElementById('mantenimientoCollapse');
    const collapseToggle = document.querySelector('[data-bs-toggle="collapse"]');
    
    // Get the saved state from localStorage
    const savedState = localStorage.getItem('mantenimientoCollapseState');
    
    // If there's a saved state, apply it
    if (savedState === 'show') {
        mantenimientoCollapse.classList.add('show');
        collapseToggle.setAttribute('aria-expanded', 'true');
    }
    
    // Listen for collapse events
    mantenimientoCollapse.addEventListener('show.bs.collapse', function () {
        localStorage.setItem('mantenimientoCollapseState', 'show');
    });
    
    mantenimientoCollapse.addEventListener('hide.bs.collapse', function () {
        localStorage.setItem('mantenimientoCollapseState', 'hide');
    });

    // Highlight active menu item
    const currentPath = window.location.pathname;
    const menuItems = document.querySelectorAll('.list-group-item-action');
    
    menuItems.forEach(item => {
        const href = item.getAttribute('href');
        // Check if the current path matches the href or if it's the root path and the item is Inicio
        if (href === currentPath || 
            (currentPath === '/' && href.endsWith('/inicio')) || 
            (currentPath === '' && href.endsWith('/inicio'))) {
            item.classList.add('active');
            
            // If the active item is in the collapse menu, expand it
            if (item.closest('#mantenimientoCollapse')) {
                mantenimientoCollapse.classList.add('show');
                collapseToggle.setAttribute('aria-expanded', 'true');
                localStorage.setItem('mantenimientoCollapseState', 'show');
            }
        }
    });
});
</script> 