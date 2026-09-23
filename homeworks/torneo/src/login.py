import tkinter as tk
from tkinter import messagebox
import psycopg2

def abrir_pantalla_permisos(usuario, pid, lista_formularios):
    """Oculta el login y abre la ventana secundaria con botones dinámicos."""
    ventana.withdraw()

    secundaria = tk.Toplevel()
    secundaria.title("Panel de Permisos - Formularios")
    secundaria.geometry("360x380")
    secundaria.resizable(False, False)

    # Si se cierra esta ventana secundaria, se termina la aplicación
    secundaria.protocol("WM_DELETE_WINDOW", ventana.destroy)

    tk.Label(secundaria, text="Acceso Concedido", font=("Arial", 14, "bold"), fg="#0d6efd").pack(pady=10)
    tk.Label(secundaria, text=f"Usuario: {usuario}  |  PostgreSQL PID: {pid}", font=("Arial", 9), fg="#555").pack()

    if not lista_formularios:
        tk.Label(secundaria, text="El usuario no tiene formularios autorizados.", fg="red").pack(pady=30)
        return

    tk.Label(secundaria, text="Formularios Disponibles (Visual):", font=("Arial", 10, "underline")).pack(pady=10)

    frame_botones = tk.Frame(secundaria)
    frame_botones.pack(pady=5, fill="both", expand=True)

    # RENDERIZADO DINÁMICO:
    # La base de datos dicta cuántos y cuáles botones dibujar
    for fila in lista_formularios:
        nombre_formulario = fila[0]
        
        btn = tk.Button(
            frame_botones,
            text=f"Abrir {nombre_formulario}",
            font=("Arial", 9),
            bg="#f8f9fa",
            relief="groove",
            pady=5
        )
        btn.pack(pady=4, fill="x", padx=30)


def autenticar():
    usuario_ingresado = entry_user.get().strip()
    clave_ingresada = entry_pass.get().strip()

    if not usuario_ingresado or not clave_ingresada:
        messagebox.showwarning("ATENCIÓN", "Ingresa usuario y contraseña.")
        return

    try:
        # 1. Conexión al motor de base de datos
        conexion = psycopg2.connect(
            host="localhost",
            database="torneo_racquetbol",
            user="sharkdev",
            password="IwillrememberthisoneIpromise"
        )
        cursor = conexion.cursor()

        # 2. Capturar el Process ID (PID) inmediatamente
        cursor.execute("SELECT pg_backend_pid();")
        pid_actual = cursor.fetchone()[0]

        # 3. Validar credenciales
        consulta_usuario = """
            SELECT public.usuario.id_user, public.usuario.activo
            FROM public.usuario
            WHERE public.usuario.nombre = %s AND public.usuario.contrasenia = %s;
        """
        cursor.execute(consulta_usuario, (usuario_ingresado, clave_ingresada))
        resultado = cursor.fetchone()

        if resultado:
            id_user, activo = resultado
            if not activo:
                cursor.close()
                conexion.close()
                messagebox.showerror("BLOQUEADO", "El usuario existe pero está inactivo.")
                return

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

            # 5. CONSULTA OPTIMIZADA DE PERMISOS (Con operador IN y sin alias)
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

            cursor.close()
            conexion.close()

            # 6. Abrir pantalla con los accesos permitidos
            abrir_pantalla_permisos(usuario_ingresado, pid_actual, formularios_usuario)

        else:
            cursor.close()
            conexion.close()
            messagebox.showerror("Error", "Credenciales incorrectas.")

    except Exception as e:
        messagebox.showerror("Error de Conexión", str(e))


# Configuración visual de la ventana de login
ventana = tk.Tk()
ventana.title("LOGIN Y PID")
ventana.geometry("340x300")
ventana.resizable(False, False)

tk.Label(ventana, text="Iniciar Sesión", font=("Arial", 16, "bold")).pack(pady=15)

tk.Label(ventana, text="Usuario:").pack()
entry_user = tk.Entry(ventana, width=25)
entry_user.pack(pady=4)

tk.Label(ventana, text="Contraseña:").pack()
entry_pass = tk.Entry(ventana, width=25, show="*")
entry_pass.pack(pady=4)

tk.Button(ventana, text="Ingresar al Sistema", command=autenticar, bg="#0d6efd", fg="white", padx=10, pady=5).pack(pady=20)

ventana.mainloop()
