package com.cibertec.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "caja_sesion")
public class CajaSesion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "caja_id", nullable = false)
    private Caja caja;

    @ManyToOne
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @Column(name = "fecha_apertura")
    private LocalDateTime fechaApertura;

    @Column(name = "fecha_cierre")
    private LocalDateTime fechaCierre;

    @Column(name = "monto_inicial")
    private Double montoInicial;

    @Column(name = "monto_cierre")
    private Double montoCierre;

    @Column(name = "estado")
    private String estado;

    // Getters y setters

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Caja getCaja() { return caja; }
    public void setCaja(Caja caja) { this.caja = caja; }

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

    public LocalDateTime getFechaApertura() { return fechaApertura; }
    public void setFechaApertura(LocalDateTime fechaApertura) { this.fechaApertura = fechaApertura; }

    public LocalDateTime getFechaCierre() { return fechaCierre; }
    public void setFechaCierre(LocalDateTime fechaCierre) { this.fechaCierre = fechaCierre; }

    public Double getMontoInicial() { return montoInicial; }
    public void setMontoInicial(Double montoInicial) { this.montoInicial = montoInicial; }

    public Double getMontoCierre() { return montoCierre; }
    public void setMontoCierre(Double montoCierre) { this.montoCierre = montoCierre; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}