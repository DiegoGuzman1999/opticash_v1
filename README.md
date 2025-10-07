# OptiCash v1 - Monorepo

## 🏗️ Arquitectura de Microservicios

Este es el repositorio principal que contiene la arquitectura completa de OptiCash como un monorepo con microservicios.

## 📁 Estructura del Proyecto

```
opticash_v1/
├── backend/          # Microservicio Backend (FastAPI + PostgreSQL)
├── frontend/         # Microservicio Frontend (React + Tailwind CSS)
├── docs/            # Documentación del proyecto
├── scripts/         # Scripts de automatización
├── docker-compose.yml # Orquestación de servicios
└── README.md        # Este archivo
```

## 🚀 Microservicios

### 1️⃣ Backend (`opticash_backend`)
- **Tecnología**: FastAPI + PostgreSQL
- **Repositorio**: https://github.com/DiegoGuzman1999/opticash_backend
- **Puerto**: 8000
- **Funcionalidades**:
  - API REST para gestión financiera
  - Autenticación JWT
  - Base de datos PostgreSQL
  - Documentación automática con Swagger

### 2️⃣ Frontend (`opticash_frontend`)
- **Tecnología**: React + Tailwind CSS + JavaScript
- **Repositorio**: https://github.com/DiegoGuzman1999/opticash_frontend
- **Puerto**: 3000
- **Funcionalidades**:
  - Interfaz de usuario moderna
  - Gestión de presupuestos
  - Análisis de gastos
  - Dashboard financiero

## 🛠️ Configuración del Monorepo

### Prerrequisitos
- Git
- Docker y Docker Compose
- Node.js (v16+)
- Python (v3.9+)

### Instalación

1. **Clonar el monorepo**:
```bash
git clone https://github.com/DiegoGuzman1999/opticash_v1.git
cd opticash_v1
```

2. **Inicializar submódulos**:
```bash
git submodule init
git submodule update
```

3. **Configurar variables de entorno**:
```bash
cp .env.example .env
# Editar .env con tus configuraciones
```

4. **Ejecutar con Docker Compose**:
```bash
docker-compose up -d
```

## 🐳 Docker Compose

El proyecto incluye un `docker-compose.yml` que orquesta todos los microservicios:

- **Backend**: Puerto 8000
- **Frontend**: Puerto 3000
- **PostgreSQL**: Puerto 5432
- **Redis**: Puerto 6379

## 📋 Scripts Disponibles

- `npm run dev` - Ejecutar todos los servicios en modo desarrollo
- `npm run build` - Construir todos los servicios
- `npm run test` - Ejecutar tests de todos los servicios
- `npm run lint` - Linter para todo el monorepo

## 🔧 Desarrollo

### Trabajando con Submódulos

1. **Actualizar submódulos**:
```bash
git submodule update --remote
```

2. **Trabajar en un submódulo**:
```bash
cd backend
# Hacer cambios
git add .
git commit -m "feat: nueva funcionalidad"
git push origin main
cd ..
git add backend
git commit -m "update: actualizar backend"
```

3. **Agregar cambios de submódulos**:
```bash
git add backend frontend
git commit -m "update: actualizar submódulos"
git push origin main
```

## 📚 Documentación

- [Backend API Docs](backend/README.md)
- [Frontend Docs](frontend/README.md)
- [Arquitectura](docs/architecture.md)
- [Deployment](docs/deployment.md)

## 🤝 Contribución

1. Fork el repositorio
2. Crea una rama para tu feature
3. Haz cambios en los submódulos correspondientes
4. Actualiza el monorepo principal
5. Crea un Pull Request

## 📄 Licencia

MIT License - ver [LICENSE](LICENSE) para más detalles.

## 👥 Equipo

- **Desarrollador Principal**: Diego Guzmán
- **Email**: diego@opticash.com
- **GitHub**: [@DiegoGuzman1999](https://github.com/DiegoGuzman1999)

---

⭐ ¡No olvides darle una estrella al proyecto si te gusta!