import tkinter as tk
from tkinter import messagebox
import psycopg2

# ============================================================================
# BLOQUE 1: INTERFACES OPERATIVAS (DISPARADORES DE EVENTOS TRANSACCIONALES)
# Estas ventanas ejecutan modificaciones DML reales utilizando la misma
# conexión física (socket TCP) abierta al autenticar, garantizando que el
# Process ID (PID) no cambie y el trigger capture al usuario exacto.
# ============================================================================

def abrir_formulario_acta(conexion, usuario, pid):
    """
    Formulario de Arbitraje: Modifica el puntaje de un set en la tabla 'set_partido'.
    Detona el trigger 'tr_set_partido', registrando la operación UPDATE en la tabla 'log'.
    """
    ventana_acta = tk.Toplevel()
    ventana_acta.title("Planilla Oficial - Registro de Sets")
    ventana_acta.geometry("380x300")
    ventana_acta.resizable(False, False)

    # Identificación visual de la sesión activa
    tk.Label(ventana_acta, text="Planilla Oficial de Partido", font=("Arial", 12, "bold"), fg="#198754").pack(pady=10)
    tk.Label(ventana_acta, text=f"Juez de Mesa: {usuario}  |  PID Postgres: {pid}", font=("Arial", 8), fg="#555").pack()

    frame_campos = tk.Frame(ventana_acta)
    frame_campos.pack(pady=12)

    # Entradas de datos con valores por defecto válidos en el modelo
    tk.Label(frame_campos, text="ID Partido:").grid(row=0, column=0, sticky="e", padx=5, pady=4)
    entry_partido = tk.Entry(frame_campos, width=10)
    entry_partido.insert(0, "1")
    entry_partido.grid(row=0, column=1, padx=5, pady=4)

    tk.Label(frame_campos, text="Nro Set:").grid(row=1, column=0, sticky="e", padx=5, pady=4)
    entry_set = tk.Entry(frame_campos, width=10)
    entry_set.insert(0, "1")
    entry_set.grid(row=1, column=1, padx=5, pady=4)

    tk.Label(frame_campos, text="Puntos Jugador 1:").grid(row=2, column=0, sticky="e", padx=5, pady=4)
    entry_p1 = tk.Entry(frame_campos, width=10)
    entry_p1.insert(0, "15")
    entry_p1.grid(row=2, column=1, padx=5, pady=4)

    tk.Label(frame_campos, text="Puntos Jugador 2:").grid(row=3, column=0, sticky="e", padx=5, pady=4)
    entry_p2 = tk.Entry(frame_campos, width=10)
    entry_p2.insert(0, "11")
    entry_p2.grid(row=3, column=1, padx=5, pady=4)

    def guardar_resultado():
        try:
            cur = conexion.cursor()
            query_update = """
                UPDATE public.set_partido
                SET puntos_j1 = %s, puntos_j2 = %s
                WHERE id_partido = %s AND nro_set = %s;
            """
            cur.execute(query_update, (
                int(entry_p1.get()),
                int(entry_p2.get()),
                int(entry_partido.get()),
                int(entry_set.get())
            ))
            
            # Verificar si la fila existía físicamente en la BD
            if cur.rowcount == 0:
                conexion.rollback()
                cur.close()
                messagebox.showwarning("Aviso", "No se encontró el Set para ese Partido. Verifica el ID.")
                return

            conexion.commit()
            cur.close()
            messagebox.showinfo("Confirmación", "Marcador de set actualizado con éxito.")
        except Exception as err:
            conexion.rollback()
            messagebox.showerror("Error de Transacción", str(err))

    tk.Button(
        ventana_acta,
        text="Guardar Marcador",
        command=guardar_resultado,
        bg="#198754",
        fg="white",
        font=("Arial", 10, "bold"),
        pady=5
    ).pack(pady=10)


def abrir_formulario_programacion(conexion, usuario, pid):
    """
    Formulario Administrativo: Permite reasignar de cancha un encuentro en la tabla 'partido'.
    Detona el trigger 'tr_partido', registrando la operación UPDATE en la tabla 'log'.
    """
    ventana_prog = tk.Toplevel()
    ventana_prog.title("Comisión Técnica - Programación")
    ventana_prog.geometry("380x260")
    ventana_prog.resizable(False, False)

    tk.Label(ventana_prog, text="Reasignación de Canchas", font=("Arial", 12, "bold"), fg="#0d6efd").pack(pady=10)
    tk.Label(ventana_prog, text=f"Administrador: {usuario}  |  PID Postgres: {pid}", font=("Arial", 8), fg="#555").pack()

    frame_campos = tk.Frame(ventana_prog)
    frame_campos.pack(pady=12)

    tk.Label(frame_campos, text="ID Partido:").grid(row=0, column=0, sticky="e", padx=5, pady=6)
    entry_partido = tk.Entry(frame_campos, width=10)
    entry_partido.insert(0, "1")
    entry_partido.grid(row=0, column=1, padx=5, pady=6)

    tk.Label(frame_campos, text="Nro Cancha (1-12):").grid(row=1, column=0, sticky="e", padx=5, pady=6)
    entry_cancha = tk.Entry(frame_campos, width=10)
    entry_cancha.insert(0, "3")
    entry_cancha.grid(row=1, column=1, padx=5, pady=6)

    def guardar_cancha():
        try:
            cur = conexion.cursor()
            query_update = """
                UPDATE public.partido
                SET nro_cancha = %s
                WHERE id_partido = %s;
            """
            cur.execute(query_update, (
                int(entry_cancha.get()),
                int(entry_partido.get())
            ))

            if cur.rowcount == 0:
                conexion.rollback()
                cur.close()
                messagebox.showwarning("Aviso", "El partido ingresado no existe en la base de datos.")
                return

            conexion.commit()
            cur.close()
            messagebox.showinfo("Confirmación", "Cancha reasignada con éxito.")
        except Exception as err:
            conexion.rollback()
            messagebox.showerror("Error de Restricción", str(err))

    tk.Button(
        ventana_prog,
        text="Guardar Programación",
        command=guardar_cancha,
        bg="#0d6efd",
        fg="white",
        font=("Arial", 10, "bold"),
        pady=5
    ).pack(pady=10)


# ============================================================================
# BLOQUE 2: VENTANA SECUNDARIA (RENDERIZADO DINÁMICO DE PERMISOS)
# Muestra únicamente las interfaces autorizadas recuperadas desde la BD.
# ============================================================================

def abrir_pantalla_permisos(usuario, pid, lista_formularios, conexion):
    """
    Oculta el login y dibuja dinámicamente un botón por cada formulario
    autorizado devuelto por el motor de base de datos.
    """
    ventana.withdraw()

    secundaria = tk.Toplevel()
    secundaria.title("Panel de Control - Acceso Concedido")
    secundaria.geometry("380x420")
    secundaria.resizable(False, False)

    # PROTOCOLO DE CIERRE SEGURO:
    # Cuando el usuario cierra la ventana con la 'X', se marca la sesión
    # como inactiva en PostgreSQL y se corta la conexión TCP cleanly.
    def al_cerrar():
        try:
            cur = conexion.cursor()
            cur.execute("UPDATE public.sesion SET activo = false WHERE pid_postgres = %s;", (pid,))
            conexion.commit()
            cur.close()
            conexion.close()
        except:
            pass
        ventana.destroy()

    secundaria.protocol("WM_DELETE_WINDOW", al_cerrar)

    tk.Label(secundaria, text="Panel del Sistema", font=("Arial", 14, "bold"), fg="#0d6efd").pack(pady=10)
    tk.Label(secundaria, text=f"Usuario Activo: {usuario}  |  PID: {pid}", font=("Arial", 9, "bold"), fg="#198754").pack()

    if not lista_formularios:
        tk.Label(secundaria, text="Este usuario no cuenta con interfaces asignadas.", fg="red").pack(pady=30)
        return

    tk.Label(secundaria, text="Módulos Disponibles:", font=("Arial", 10, "underline")).pack(pady=10)

    frame_botones = tk.Frame(secundaria)
    frame_botones.pack(pady=5, fill="both", expand=True)

    # RENDERIZADO DINÁMICO: Cero bifurcaciones 'if rol == ...' fijas
    # Se itera la lista de tuplas devuelta por la subconsulta SQL
    for fila in lista_formularios:
        nombre_form = fila[0]

        # Enlace a las pantallas operativas según el formulario autorizado
        if nombre_form == "form_acta_sets":
            accion = lambda: abrir_formulario_acta(conexion, usuario, pid)
            color_btn = "#d1e7dd"
        elif nombre_form == "form_programacion":
            accion = lambda: abrir_formulario_programacion(conexion, usuario, pid)
            color_btn = "#cfe2ff"
        else:
            accion = lambda f=nombre_form: messagebox.showinfo("Módulo Informativo", f"Cargando la interfaz {f}...")
            color_btn = "#f8f9fa"

        btn = tk.Button(
            frame_botones,
            text=f"Abrir {nombre_form}",
            font=("Arial", 9),
            bg=color_btn,
            relief="groove",
            pady=5,
            command=accion
        )
        btn.pack(pady=4, fill="x", padx=30)


# ============================================================================
# BLOQUE 3: CONTROLADOR DE AUTENTICACIÓN Y SESIONES CONCURRENTES
# ============================================================================

def autenticar():
    """
    Abre un proceso backend dedicado en PostgreSQL, captura su PID, valida
    las credenciales, registra la sesión y consulta los permisos mínimos.
    """
    usuario_ingresado = entry_user.get().strip()
    clave_ingresada = entry_pass.get().strip()

    if not usuario_ingresado or not clave_ingresada:
        messagebox.showwarning("Atención", "Por favor ingresa usuario y contraseña.")
        return

    try:
        # 1. Apertura de socket TCP independiente por ventana
        conexion = psycopg2.connect(
            host="localhost",
            database="torneo_racquetbol",
            user="sharkdev",
            password="IwillrememberthisoneIpromise"
        )
        cursor = conexion.cursor()

        # 2. Captura inmediata del PID asignado por el kernel de PostgreSQL
        cursor.execute("SELECT pg_backend_pid();")
        pid_actual = cursor.fetchone()[0]

        # 3. Validación de credenciales parametrizada contra SQL Injection
        consulta_usuario = """
            SELECT public.usuario.id_user, public.usuario.activo
            FROM public.usuario
            WHERE public.usuario.nombre = %s AND public.usuario.contrasenia = %s;
        """
        cursor.execute(consulta_usuario, (usuario_ingresado, clave_ingresada))
        resultado = cursor.fetchone()

        if resultado:
            id_user, activo = resultado
 
            # Control de bloqueo lógico de usuario
            if not activo:
                cursor.close()
                conexion.close()
                messagebox.showerror("Acceso Denegado", "El usuario existe pero se encuentra inactivo.")
                return

            # 4. Registro de Sesión (Idiom Maestro-Detalle con secuencia local)
            # Garantiza unicidad del nro_sesion por cada usuario individual
            query_sesion = """
                INSERT INTO public.sesion (id_user, nro_sesion, pid_postgres, activo)
                VALUES (
                    %s,
                    COALESCE((SELECT MAX(public.sesion.nro_sesion) + 1 FROM public.sesion WHERE public.sesion.id_user = %s), 1),
                    %s,
                    true
                );
            """
            cursor.execute(query_sesion, (id_user, id_user, pid_actual))
            conexion.commit()

            # 5. CONSULTA EN CASCADA CON OPERADOR 'IN' (SIN JOINS NI ALIAS)
            # Resuelve de adentro hacia afuera para transferir únicamente los
            # nombres de formularios necesarios, optimizando ancho de banda y RAM.
            consulta_permisos = """
                SELECT public.iu.nombre_form 
                FROM public.iu
                WHERE public.iu.id_iu IN (
                    SELECT public.funcion_iu.id_iu 
                    FROM public.funcion_iu
                    WHERE public.funcion_iu.id_funcion IN (
                        SELECT public.rol_funcion.id_funcion 
                        FROM public.rol_funcion
                        WHERE public.rol_funcion.id_rol IN (
                            SELECT public.user_rol.id_rol 
                            FROM public.user_rol
                            WHERE public.user_rol.id_user = %s
                        )
                    )
                );
            """
            cursor.execute(consulta_permisos, (id_user,))
            formularios_usuario = cursor.fetchall()

            # El cursor se cierra pero la CONEXIÓN queda viva para la sesión activa
            cursor.close()

            # 6. Despliegue de la ventana secundaria transfiriendo la conexión
            abrir_pantalla_permisos(usuario_ingresado, pid_actual, formularios_usuario, conexion)

        else:
            cursor.close()
            conexion.close()
            messagebox.showerror("Error", "Credenciales incorrectas.")

    except Exception as e:
        messagebox.showerror("Error de Conexión", str(e))


# ============================================================================
# BLOQUE 4: INICIALIZACIÓN DE LA INTERFAZ PRINCIPAL
# ============================================================================

ventana = tk.Tk()
ventana.title("Sistema Torneo Sarco - Acceso")
ventana.geometry("340x300")
ventana.resizable(False, False)

tk.Label(ventana, text="Iniciar Sesión", font=("Arial", 16, "bold")).pack(pady=15)

tk.Label(ventana, text="Usuario:").pack()
entry_user = tk.Entry(ventana, width=25)
entry_user.pack(pady=4)

tk.Label(ventana, text="Contraseña:").pack()
entry_pass = tk.Entry(ventana, width=25, show="*")
entry_pass.pack(pady=4)

tk.Button(
    ventana, 
    text="Ingresar al Sistema", 
    command=autenticar, 
    bg="#0d6efd", 
    fg="white", 
    padx=10, 
    pady=5,
    relief="flat"
).pack(pady=20)

ventana.mainloop()
