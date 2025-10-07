#!/bin/bash

# ===========================================
# OPTICASH MONOREPO - SCRIPT DE CONFIGURACIÓN
# ===========================================

echo "🚀 Configurando OptiCash Monorepo..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes
print_message() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar prerrequisitos
print_message "Verificando prerrequisitos..."

# Verificar Git
if ! command -v git &> /dev/null; then
    print_error "Git no está instalado. Por favor instala Git primero."
    exit 1
fi

# Verificar Docker
if ! command -v docker &> /dev/null; then
    print_warning "Docker no está instalado. Algunas funcionalidades no estarán disponibles."
fi

# Verificar Docker Compose
if ! command -v docker-compose &> /dev/null; then
    print_warning "Docker Compose no está instalado. Algunas funcionalidades no estarán disponibles."
fi

# Verificar Node.js
if ! command -v node &> /dev/null; then
    print_error "Node.js no está instalado. Por favor instala Node.js v16+ primero."
    exit 1
fi

# Verificar Python
if ! command -v python3 &> /dev/null; then
    print_error "Python 3 no está instalado. Por favor instala Python 3.9+ primero."
    exit 1
fi

print_success "Prerrequisitos verificados correctamente."

# Configurar submódulos
print_message "Configurando submódulos de Git..."

# Inicializar submódulos
git submodule init

# Actualizar submódulos
git submodule update

print_success "Submódulos configurados correctamente."

# Instalar dependencias del monorepo
print_message "Instalando dependencias del monorepo..."

if [ -f "package.json" ]; then
    npm install
    print_success "Dependencias del monorepo instaladas."
else
    print_warning "No se encontró package.json en el monorepo."
fi

# Configurar variables de entorno
print_message "Configurando variables de entorno..."

if [ ! -f ".env" ]; then
    if [ -f "env.example" ]; then
        cp env.example .env
        print_success "Archivo .env creado desde env.example"
        print_warning "Por favor edita el archivo .env con tus configuraciones específicas."
    else
        print_warning "No se encontró env.example. Debes crear manualmente el archivo .env"
    fi
else
    print_message "El archivo .env ya existe."
fi

# Configurar backend
print_message "Configurando backend..."

if [ -d "backend" ]; then
    cd backend
    
    # Crear entorno virtual de Python
    if [ ! -d "venv" ]; then
        python3 -m venv venv
        print_success "Entorno virtual de Python creado."
    fi
    
    # Activar entorno virtual
    source venv/bin/activate
    
    # Instalar dependencias de Python
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt
        print_success "Dependencias de Python instaladas."
    else
        print_warning "No se encontró requirements.txt en el backend."
    fi
    
    cd ..
else
    print_warning "Directorio backend no encontrado. Asegúrate de que el submódulo esté configurado correctamente."
fi

# Configurar frontend
print_message "Configurando frontend..."

if [ -d "frontend" ]; then
    cd frontend
    
    # Instalar dependencias de Node.js
    if [ -f "package.json" ]; then
        npm install
        print_success "Dependencias de frontend instaladas."
    else
        print_warning "No se encontró package.json en el frontend."
    fi
    
    cd ..
else
    print_warning "Directorio frontend no encontrado. Asegúrate de que el submódulo esté configurado correctamente."
fi

# Crear directorios necesarios
print_message "Creando directorios necesarios..."

mkdir -p logs
mkdir -p data/postgres
mkdir -p data/redis
mkdir -p nginx/ssl

print_success "Directorios creados correctamente."

# Configurar permisos
print_message "Configurando permisos..."

chmod +x scripts/*.sh

print_success "Permisos configurados correctamente."

# Resumen final
print_success "¡Configuración completada!"
echo ""
echo "📋 Resumen de la configuración:"
echo "  ✅ Submódulos de Git configurados"
echo "  ✅ Dependencias del monorepo instaladas"
echo "  ✅ Variables de entorno configuradas"
echo "  ✅ Backend configurado (si está disponible)"
echo "  ✅ Frontend configurado (si está disponible)"
echo "  ✅ Directorios necesarios creados"
echo ""
echo "🚀 Próximos pasos:"
echo "  1. Edita el archivo .env con tus configuraciones"
echo "  2. Ejecuta 'npm run dev' para desarrollo"
echo "  3. O ejecuta 'docker-compose up -d' para producción"
echo ""
echo "📚 Documentación:"
echo "  - README.md: Documentación principal"
echo "  - docs/: Documentación detallada"
echo "  - scripts/: Scripts de automatización"
echo ""
print_success "¡OptiCash Monorepo está listo para usar!"
