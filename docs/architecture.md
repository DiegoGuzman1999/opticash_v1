# 🏗️ Arquitectura de OptiCash

## 📋 Visión General

OptiCash está diseñado como un monorepo con arquitectura de microservicios, permitiendo escalabilidad, mantenibilidad y desarrollo independiente de cada componente.

## 🎯 Principios de Diseño

- **Separación de Responsabilidades**: Cada microservicio tiene una responsabilidad específica
- **Escalabilidad Horizontal**: Los servicios pueden escalarse independientemente
- **Resiliencia**: Fallos en un servicio no afectan a otros
- **Observabilidad**: Monitoreo y logging centralizados
- **Seguridad**: Autenticación y autorización centralizadas

## 🏛️ Arquitectura del Sistema

```
┌─────────────────────────────────────────────────────────────┐
│                    OPTICASH MONOREPO                        │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │   Frontend  │  │   Backend   │  │   Database  │        │
│  │   (React)   │  │  (FastAPI)  │  │(PostgreSQL) │        │
│  │   Port 3000 │  │  Port 8000  │  │  Port 5432  │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │    Redis    │  │    Nginx    │  │   Docker    │        │
│  │   (Cache)   │  │  (Proxy)    │  │ (Orchestr.) │        │
│  │  Port 6379  │  │  Port 80    │  │             │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
└─────────────────────────────────────────────────────────────┘
```

## 🔧 Componentes del Sistema

### 1️⃣ Frontend (React + Tailwind CSS)

**Tecnologías:**
- React 18
- Tailwind CSS
- JavaScript (ES6+)
- Axios para HTTP requests
- React Router para navegación

**Responsabilidades:**
- Interfaz de usuario
- Gestión de estado local
- Comunicación con API
- Validación de formularios
- Renderizado de datos

**Estructura:**
```
frontend/
├── src/
│   ├── components/     # Componentes reutilizables
│   ├── pages/         # Páginas de la aplicación
│   ├── services/      # Servicios de API
│   ├── hooks/         # Custom hooks
│   ├── utils/         # Utilidades
│   └── styles/        # Estilos globales
├── public/            # Archivos estáticos
└── package.json       # Dependencias
```

### 2️⃣ Backend (FastAPI + PostgreSQL)

**Tecnologías:**
- FastAPI (Python 3.9+)
- PostgreSQL 15
- SQLAlchemy (ORM)
- Alembic (Migraciones)
- Pydantic (Validación)
- JWT (Autenticación)

**Responsabilidades:**
- API REST
- Lógica de negocio
- Gestión de base de datos
- Autenticación y autorización
- Validación de datos

**Estructura:**
```
backend/
├── app/
│   ├── api/           # Endpoints de la API
│   ├── core/          # Configuración central
│   ├── models/        # Modelos de base de datos
│   ├── schemas/       # Esquemas Pydantic
│   ├── services/      # Lógica de negocio
│   └── utils/         # Utilidades
├── migrations/        # Migraciones de Alembic
├── tests/            # Pruebas unitarias
└── requirements.txt  # Dependencias Python
```

### 3️⃣ Base de Datos (PostgreSQL)

**Características:**
- PostgreSQL 15
- UUID como claves primarias
- Índices optimizados
- Triggers para auditoría
- Vistas para consultas complejas

**Tablas Principales:**
- `users` - Usuarios del sistema
- `financial_profiles` - Perfiles financieros
- `categories` - Categorías de transacciones
- `transactions` - Transacciones financieras
- `budgets` - Presupuestos
- `financial_goals` - Metas financieras
- `investments` - Inversiones
- `bank_accounts` - Cuentas bancarias

### 4️⃣ Cache (Redis)

**Uso:**
- Cache de sesiones
- Cache de consultas frecuentes
- Rate limiting
- Colas de tareas

### 5️⃣ Proxy Reverso (Nginx)

**Funcionalidades:**
- Balanceador de carga
- Terminación SSL
- Compresión de respuestas
- Cache de archivos estáticos
- Rate limiting

## 🔄 Flujo de Datos

### 1. Autenticación
```
Usuario → Frontend → Backend → PostgreSQL
                ↓
            JWT Token → Redis (Cache)
```

### 2. Transacciones
```
Frontend → Backend → PostgreSQL
    ↓         ↓
  Cache    Validación
 (Redis)   (Pydantic)
```

### 3. Reportes
```
Frontend → Backend → PostgreSQL → Vistas → Frontend
    ↓         ↓
  Cache    Procesamiento
 (Redis)   de Datos
```

## 🐳 Containerización

### Docker Compose
- **Orquestación**: Docker Compose
- **Red**: Red personalizada `opticash_network`
- **Volúmenes**: Persistencia de datos
- **Variables**: Configuración por entorno

### Servicios Docker
```yaml
services:
  postgres:    # Base de datos
  redis:       # Cache
  backend:     # API FastAPI
  frontend:    # Aplicación React
  nginx:       # Proxy reverso
```

## 🔒 Seguridad

### Autenticación
- JWT tokens
- Refresh tokens
- Expiración configurable
- Almacenamiento seguro

### Autorización
- Roles y permisos
- Middleware de autenticación
- Validación de endpoints

### Protección de Datos
- Encriptación en tránsito (HTTPS)
- Encriptación en reposo
- Validación de entrada
- Sanitización de datos

## 📊 Monitoreo y Observabilidad

### Logging
- Logs estructurados
- Niveles de log configurables
- Rotación de logs
- Agregación centralizada

### Métricas
- Métricas de aplicación
- Métricas de infraestructura
- Alertas automáticas
- Dashboards

### Health Checks
- Endpoints de salud
- Verificación de dependencias
- Estado de servicios
- Notificaciones automáticas

## 🚀 Despliegue

### Desarrollo
```bash
# Clonar repositorio
git clone https://github.com/DiegoGuzman1999/opticash_v1.git
cd OptiCash

# Configurar submódulos
git submodule init
git submodule update

# Ejecutar con Docker
docker-compose up -d
```

### Producción
```bash
# Build de imágenes
docker-compose build

# Despliegue
docker-compose -f docker-compose.prod.yml up -d
```

## 🔄 CI/CD

### GitHub Actions
- **Tests**: Automáticos en cada PR
- **Build**: Construcción de imágenes
- **Deploy**: Despliegue automático
- **Security**: Escaneo de vulnerabilidades

### Pipeline
1. **Checkout** código
2. **Setup** entorno
3. **Install** dependencias
4. **Test** ejecutar pruebas
5. **Build** construir imágenes
6. **Deploy** desplegar servicios

## 📈 Escalabilidad

### Horizontal
- Múltiples instancias de servicios
- Load balancing
- Auto-scaling
- Distribución de carga

### Vertical
- Optimización de recursos
- Caching inteligente
- Optimización de consultas
- Compresión de datos

## 🔧 Mantenimiento

### Actualizaciones
- Actualizaciones de submódulos
- Migraciones de base de datos
- Rollback automático
- Testing de regresión

### Backup
- Backup automático de BD
- Versionado de datos
- Recuperación de desastres
- Testing de restauración

## 📚 Documentación

### API Documentation
- Swagger/OpenAPI
- Documentación interactiva
- Ejemplos de uso
- Esquemas de datos

### Desarrollo
- README detallado
- Guías de contribución
- Arquitectura documentada
- Decisiones técnicas

---

Esta arquitectura proporciona una base sólida para el crecimiento y mantenimiento de OptiCash, permitiendo escalabilidad y flexibilidad para futuras mejoras.
