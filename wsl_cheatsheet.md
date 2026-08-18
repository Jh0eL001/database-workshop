# 🛠️ WSL & TBD Cheatsheet
Guía rápida de comandos para el flujo de trabajo en WSL, Git, visualización y gestión de paquetes.

## 📂 1. Tareas y Estructura (TBD)

# Crear una nueva tarea con estructura lista (assets, src, README.md)
newhw hw-01-nombre-tarea

## 📂 2. Git & Github
# Inicializar repositorio y subirlo por primera vez
cd ~/tbd
git init
git add .
git commit -m "feat: initial repository structure and template"
git branch -M main
git remote add origin [https://github.com/TU_USUARIO/database-workshop.git](https://github.com/TU_USUARIO/database-workshop.git)
git push -u origin main

# Flujo de trabajo diario (guardar cambios)
git add .
git commit -m "feat(hw-01): add ER diagram and schema scripts"
git push

## 4. Ver Imágenes y Diagramas ER

# Visor gráfico nativo de Linux (en segundo plano)
viewnior assets/er-diagram.png &

# Abrir con el visor de fotos de Windows
explorer.exe assets/er-diagram.png

# Abrir la carpeta actual en el Explorador de Windows
explorer.exe .

# Visor rápido en caracteres dentro de la terminal
chafa assets/er-diagram.png
# Visor gráfico nativo de Linux (en segundo plano)
viewnior assets/er-diagram.png &

# Abrir con el visor de fotos de Windows
explorer.exe assets/er-diagram.png

# Abrir la carpeta actual en el Explorador de Windows
explorer.exe .

# Visor rápido en caracteres dentro de la terminal
chafa assets/er-diagram.png

## 🔍 5. Control de Paquetes y Binarios

# Saber la ruta exacta de un programa instalado
which viewnior
which grip

# Saber si un comando es binario, alias o función
type newhw

# Listar paquetes instalados manualmente con APT
apt-mark showmanual

# Ver herramientas CLI instaladas en tu usuario
ls -la ~/.local/bin

# Ver herramientas instaladas con uv
uv tool list






# ejecutables instalados con apt:

base-files
bash
bsdutils
build-essential
chafa
coreutils
dash
debianutils
diffutils
findutils
fzf
grep
gzip
hostname
init
jq
libattr1
libfuse2t64
login
luarocks
ncurses-base
ncurses-bin
nodejs
npm
pandoc
pgmodeler
postgresql
postgresql-contrib
python3-pip
ripgrep
trash-cli
tree
ubuntu-minimal
ubuntu-wsl
unzip
util-linux
viewnior
xclip
