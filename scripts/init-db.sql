-- ===========================================
-- OPTICASH - SCRIPT DE INICIALIZACIÓN DE BASE DE DATOS
-- ===========================================

-- Crear base de datos si no existe
CREATE DATABASE IF NOT EXISTS opticash;

-- Usar la base de datos
\c opticash;

-- Crear extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ===========================================
-- TABLA DE USUARIOS
-- ===========================================
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    is_active BOOLEAN DEFAULT true,
    is_verified BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ===========================================
-- TABLA DE PERFILES FINANCIEROS
-- ===========================================
CREATE TABLE IF NOT EXISTS financial_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    monthly_income DECIMAL(15,2) DEFAULT 0,
    monthly_expenses DECIMAL(15,2) DEFAULT 0,
    savings_goal DECIMAL(15,2) DEFAULT 0,
    currency VARCHAR(3) DEFAULT 'USD',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ===========================================
-- TABLA DE CATEGORÍAS
-- ===========================================
CREATE TABLE IF NOT EXISTS categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    color VARCHAR(7) DEFAULT '#3B82F6',
    icon VARCHAR(50),
    is_income BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, name)
);

-- ===========================================
-- TABLA DE TRANSACCIONES
-- ===========================================
CREATE TABLE IF NOT EXISTS transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
    amount DECIMAL(15,2) NOT NULL,
    description TEXT,
    transaction_date DATE NOT NULL,
    is_recurring BOOLEAN DEFAULT false,
    recurring_frequency VARCHAR(20), -- 'daily', 'weekly', 'monthly', 'yearly'
    tags TEXT[], -- Array de tags
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ===========================================
-- TABLA DE PRESUPUESTOS
-- ===========================================
CREATE TABLE IF NOT EXISTS budgets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    amount DECIMAL(15,2) NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    spent_amount DECIMAL(15,2) DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ===========================================
-- TABLA DE METAS FINANCIERAS
-- ===========================================
CREATE TABLE IF NOT EXISTS financial_goals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    target_amount DECIMAL(15,2) NOT NULL,
    current_amount DECIMAL(15,2) DEFAULT 0,
    target_date DATE,
    is_achieved BOOLEAN DEFAULT false,
    priority INTEGER DEFAULT 1, -- 1-5, donde 5 es la máxima prioridad
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ===========================================
-- TABLA DE INVERSIONES
-- ===========================================
CREATE TABLE IF NOT EXISTS investments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    type VARCHAR(50) NOT NULL, -- 'stock', 'bond', 'crypto', 'real_estate', etc.
    symbol VARCHAR(20),
    quantity DECIMAL(15,8) NOT NULL,
    purchase_price DECIMAL(15,2) NOT NULL,
    current_price DECIMAL(15,2),
    purchase_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ===========================================
-- TABLA DE CUENTAS BANCARIAS
-- ===========================================
CREATE TABLE IF NOT EXISTS bank_accounts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    bank_name VARCHAR(100) NOT NULL,
    account_type VARCHAR(50) NOT NULL, -- 'checking', 'savings', 'credit', 'investment'
    account_number VARCHAR(50),
    routing_number VARCHAR(20),
    balance DECIMAL(15,2) DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ===========================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- ===========================================

-- Índices para usuarios
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);

-- Índices para transacciones
CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_category_id ON transactions(category_id);
CREATE INDEX IF NOT EXISTS idx_transactions_date ON transactions(transaction_date);
CREATE INDEX IF NOT EXISTS idx_transactions_user_date ON transactions(user_id, transaction_date);

-- Índices para presupuestos
CREATE INDEX IF NOT EXISTS idx_budgets_user_id ON budgets(user_id);
CREATE INDEX IF NOT EXISTS idx_budgets_category_id ON budgets(category_id);
CREATE INDEX IF NOT EXISTS idx_budgets_period ON budgets(period_start, period_end);

-- Índices para categorías
CREATE INDEX IF NOT EXISTS idx_categories_user_id ON categories(user_id);
CREATE INDEX IF NOT EXISTS idx_categories_is_income ON categories(is_income);

-- Índices para metas financieras
CREATE INDEX IF NOT EXISTS idx_goals_user_id ON financial_goals(user_id);
CREATE INDEX IF NOT EXISTS idx_goals_target_date ON financial_goals(target_date);
CREATE INDEX IF NOT EXISTS idx_goals_is_achieved ON financial_goals(is_achieved);

-- ===========================================
-- TRIGGERS PARA ACTUALIZAR updated_at
-- ===========================================

-- Función para actualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para todas las tablas
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_financial_profiles_updated_at BEFORE UPDATE ON financial_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON categories
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_transactions_updated_at BEFORE UPDATE ON transactions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_budgets_updated_at BEFORE UPDATE ON budgets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_financial_goals_updated_at BEFORE UPDATE ON financial_goals
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_investments_updated_at BEFORE UPDATE ON investments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_bank_accounts_updated_at BEFORE UPDATE ON bank_accounts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ===========================================
-- DATOS INICIALES
-- ===========================================

-- Insertar categorías por defecto
INSERT INTO categories (user_id, name, description, color, icon, is_income) VALUES
-- Categorías de gastos
('00000000-0000-0000-0000-000000000000', 'Alimentación', 'Gastos en comida y bebida', '#EF4444', '🍽️', false),
('00000000-0000-0000-0000-000000000000', 'Transporte', 'Gastos de transporte público y privado', '#F59E0B', '🚗', false),
('00000000-0000-0000-0000-000000000000', 'Vivienda', 'Renta, hipoteca, servicios básicos', '#8B5CF6', '🏠', false),
('00000000-0000-0000-0000-000000000000', 'Salud', 'Gastos médicos y farmacéuticos', '#10B981', '🏥', false),
('00000000-0000-0000-0000-000000000000', 'Entretenimiento', 'Ocio, diversión y entretenimiento', '#F97316', '🎬', false),
('00000000-0000-0000-0000-000000000000', 'Educación', 'Cursos, libros, capacitación', '#06B6D4', '📚', false),
('00000000-0000-0000-0000-000000000000', 'Ropa', 'Vestimenta y accesorios', '#EC4899', '👕', false),
('00000000-0000-0000-0000-000000000000', 'Otros', 'Gastos diversos', '#6B7280', '📦', false),
-- Categorías de ingresos
('00000000-0000-0000-0000-000000000000', 'Salario', 'Ingresos por trabajo', '#10B981', '💰', true),
('00000000-0000-0000-0000-000000000000', 'Freelance', 'Trabajos independientes', '#3B82F6', '💼', true),
('00000000-0000-0000-0000-000000000000', 'Inversiones', 'Ganancias por inversiones', '#F59E0B', '📈', true),
('00000000-0000-0000-0000-000000000000', 'Otros Ingresos', 'Otros tipos de ingresos', '#8B5CF6', '💵', true)
ON CONFLICT (user_id, name) DO NOTHING;

-- ===========================================
-- VISTAS ÚTILES
-- ===========================================

-- Vista para resumen financiero del usuario
CREATE OR REPLACE VIEW user_financial_summary AS
SELECT 
    u.id as user_id,
    u.username,
    COALESCE(fp.monthly_income, 0) as monthly_income,
    COALESCE(fp.monthly_expenses, 0) as monthly_expenses,
    COALESCE(fp.savings_goal, 0) as savings_goal,
    COALESCE(SUM(CASE WHEN c.is_income = true THEN t.amount ELSE 0 END), 0) as total_income,
    COALESCE(SUM(CASE WHEN c.is_income = false THEN t.amount ELSE 0 END), 0) as total_expenses,
    COALESCE(SUM(CASE WHEN c.is_income = true THEN t.amount ELSE -t.amount END), 0) as net_income
FROM users u
LEFT JOIN financial_profiles fp ON u.id = fp.user_id
LEFT JOIN transactions t ON u.id = t.user_id
LEFT JOIN categories c ON t.category_id = c.id
WHERE t.transaction_date >= DATE_TRUNC('month', CURRENT_DATE)
GROUP BY u.id, u.username, fp.monthly_income, fp.monthly_expenses, fp.savings_goal;

-- Vista para gastos por categoría
CREATE OR REPLACE VIEW expenses_by_category AS
SELECT 
    u.id as user_id,
    c.name as category_name,
    c.color as category_color,
    SUM(t.amount) as total_amount,
    COUNT(t.id) as transaction_count,
    AVG(t.amount) as average_amount
FROM users u
JOIN transactions t ON u.id = t.user_id
JOIN categories c ON t.category_id = c.id
WHERE c.is_income = false
    AND t.transaction_date >= DATE_TRUNC('month', CURRENT_DATE)
GROUP BY u.id, c.name, c.color
ORDER BY total_amount DESC;

print_success "Base de datos inicializada correctamente.";
