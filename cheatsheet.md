# Cheatsheet: Linux, PostgreSQL & DBeaver

---

## 1. Navegación e Inspección en Linux (WSL)

### Comandos de Terminal
```bash
# Diagnóstico y búsqueda
which git
which psql
which nvim
find ~ -type d -name "taller-bd"
df -h /
du -sh ~/universidad/*
```

---

## 2. Gestión del Servicio PostgreSQL

### Comandos de Servicio
```bash
# Iniciar motor de base de datos
sudo service postgresql start

# Verificar estado (activo/inactivo)
sudo service postgresql status

# Reiniciar servicio
sudo service postgresql restart

# Detener servicio
sudo service postgresql stop
```

---

## 3. Consola Interactiva (psql)

### Conexión por Terminal
```bash
# Entrar como superusuario postgres
sudo -u postgres psql

# Entrar directamente a una base de datos específica
psql -U postgres -d nombre_bd -h localhost
```

### Metacomandos de psql
| Metacomando | Descripción |
| :--- | :--- |
| `\l` | Listar todas las bases de datos |
| `\c nombre_bd` | Cambiar o conectarse a otra base de datos |
| `\dt` | Listar tablas del esquema actual |
| `\dt *.*` | Listar tablas de todos los esquemas |
| `\d nombre_tabla` | Describir columnas, tipos, PKs y FKs de una tabla |
| `\dn` | Listar esquemas existentes |
| `\du` | Listar roles, usuarios y privilegios |
| `\timing` | Activar o desactivar cronómetro de consultas |
| `\i archivo.sql` | Ejecutar un script SQL externo |
| `\q` | Salir de la consola psql |

---

## 4. Lanzamiento de DBeaver

### Comandos de Ejecución
```bash
# Lanzar en segundo plano
dbeaver-ce &

# Lanzar en segundo plano silenciando logs de terminal
dbeaver-ce > /dev/null 2>&1 &
```

---

## 5. Atajos de Teclado en DBeaver

### Ejecución de Consultas y Scripts
| Atajo | Acción |
| :--- | :--- |
| `Ctrl + Enter` | Ejecutar la sentencia SQL actual |
| `Alt + X` | Ejecutar el script SQL completo |
| `Ctrl + Shift + Enter` | Ejecutar la consulta actual y medir el tiempo |
| `Ctrl + Alt + Shift + X` | Ejecutar el script desde la línea actual hasta el final |

### Edición y Formato de Código
| Atajo | Acción |
| :--- | :--- |
| `Ctrl + Space` | Autocompletar tablas, columnas y sintaxis |
| `Ctrl + Shift + F` | Autoformatear e indentar el código SQL |
| `Ctrl + /` | Comentar o descomentar línea / bloque |
| `Ctrl + Shift + U` | Convertir texto seleccionado a MAYÚSCULAS |
| `Ctrl + Shift + L` | Convertir texto seleccionado a minúsculas |
| `Ctrl + Alt + Down` / `Up` | Duplicar línea actual hacia abajo / arriba |
| `Alt + Down` / `Up` | Mover línea actual hacia abajo / arriba |
| `Ctrl + D` | Eliminar la línea actual |

### Navegación y Gestión de Pestañas
| Atajo | Acción |
| :--- | :--- |
| `F4` | Abrir nuevo editor SQL sobre la BD seleccionada |
| `Ctrl + F4` / `Ctrl + W` | Cerrar pestaña activa |
| `Ctrl + Tab` | Alternar entre pestañas abiertas |
| `F3` | Ir a la definición de la entidad bajo el cursor |
| `Ctrl + Shift + E` | Ver el plan de ejecución (*Explain Execution Plan*) |

### Visor de Datos y Resultados
| Atajo | Acción |
| :--- | :--- |
| `F5` | Refrescar datos o esquemas |
| `Tab` / `Shift + Tab` | Moverse a la celda siguiente / anterior |
| `Ctrl + Alt + C` | Copiar fila en formato avanzado (JSON, CSV, INSERT) |
| `Ctrl + S` | Guardar cambios manuales en la grilla de datos |

# 🐘 pgModeler Cheatsheet

Guía rápida de uso, comandos y atajos de teclado para modelado de bases de datos PostgreSQL en WSL.

---

## 🚀 1. Comandos de Terminal (WSL)

```bash
# Abrir pgModeler en segundo plano (WSLg)
pgmodeler &

# Abrir un archivo de modelo existente (.dbm)
pgmodeler assets/modelo.dbm &

# Exportar modelo a script SQL directamente desde CLI
pgmodeler-cli --input assets/modelo.dbm --export-to-file src/01_schema.sql
```

---

## ⌨️ 2. Atajos de Teclado Esenciales

| Acción | Atajo |
| :--- | :--- |
| **Nuevo modelo** | `Ctrl + N` |
| **Abrir modelo** | `Ctrl + O` |
| **Guardar cambios** | `Ctrl + S` |
| **Exportar SQL / Diccionario / PNG** | `Ctrl + E` |
| **Validar integridad del modelo** | `F8` |
| **Buscar objetos en el lienzo** | `Ctrl + F` |
| **Zoom In / Zoom Out** | `Ctrl + +` / `Ctrl + -` (o rueda del ratón) |
| **Ajustar vista al lienzo (Reset Zoom)** | `Ctrl + 0` |
| **Modo Pantalla Completa** | `F11` |

---

## 🛠️ 3. Atajos de Creación de Objetos

| Elemento | Atajo |
| :--- | :--- |
| **Nueva Tabla** | `T` (o doble clic en espacio vacío) |
| **Nueva Relación 1:1** | `R` luego `1` |
| **Nueva Relación 1:N** | `R` luego `N` |
| **Nueva Relación N:N** | `R` luego `M` |
| **Nueva Vista** | `V` |
| **Nuevo Cuadro de Texto / Nota** | `N` |

---

## 💡 4. Flujo Recomendado para Tareas

```text
1. Diseñar el diagrama en el lienzo (Tablas, PKs, FKs, Constraints).
2. Validar con F8 para revisar inconsistencias de tipos o relaciones.
3. Guardar el archivo fuente en: assets/modelo.dbm
4. Exportar imagen (Ctrl + E -> Exportar como imagen) a: assets/er-diagram.png
5. Exportar DDL (Ctrl + E -> Exportar a SQL) a: src/01_schema.sql
```


## 7. Rutas del Sistema

* **Carpeta de trabajo:** `~/universidad/taller-bd/`
* **Configuración PostgreSQL:** `/etc/postgresql/16/main/`
* **Almacenamiento de datos PostgreSQL:** `/var/lib/postgresql/`
* **Configuración Neovim:** `~/.config/nvim/`
* **Configuración Git:** `~/.gitconfig`
* **Configuración Bash:** `~/.bashrc`
