# NexaBot Panel - Arquitectura UI Profesional

## 1. Visión General

Dashboard SaaS profesional con modo oscuro para gestionar un único bot de Discord (NexaBot).

### Stack Tecnológico
- **Frontend**: React + TypeScript + TailwindCSS
- **Backend**: Node.js + Express + TypeScript
- **Base de Datos**: Supabase (PostgreSQL)
- **Autenticación**: Discord OAuth2
- **Despliegue**: Docker + Render/Railway

## 2. Estructura de Carpetas

```
nexabot-panel/
├── src/
│   ├── components/          # Componentes reutilizables
│   │   ├── ui/             # Componentes UI base
│   │   │   ├── Button.tsx
│   │   │   ├── Card.tsx
│   │   │   ├── Modal.tsx
│   │   │   ├── Input.tsx
│   │   │   ├── Table.tsx
│   │   │   └── Badge.tsx
│   │   ├── layout/         # Componentes de layout
│   │   │   ├── Navbar.tsx
│   │   │   ├── Sidebar.tsx
│   │   │   └── Footer.tsx
│   │   └── dashboard/      # Componentes específicos
│   │       ├── BotStatus.tsx
│   │       ├── ServerCard.tsx
│   │       └── StatsCard.tsx
│   ├── pages/              # Páginas principales
│   │   ├── Landing.tsx     # Página de inicio
│   │   ├── Dashboard.tsx   # Dashboard usuario
│   │   ├── Servers.tsx     # Gestión de servidores
│   │   ├── Subscription.tsx # Gestión de suscripción
│   │   ├── BotSettings.tsx # Configuración del bot
│   │   └── Admin.tsx       # Panel admin
│   ├── api/                # API Routes
│   │   ├── auth.ts         # Discord OAuth2
│   │   ├── bot.ts          # Estado del bot
│   │   ├── servers.ts      # Servidores
│   │   └── subscriptions.ts # Suscripciones
│   ├── lib/                # Utilidades
│   │   ├── supabase.ts     # Cliente Supabase
│   │   ├── discord.ts      # Cliente Discord API
│   │   └── auth.ts         # Helpers de auth
│   ├── types/              # TypeScript types
│   │   ├── database.ts     # Tipos de BD
│   │   └── discord.ts      # Tipos de Discord
│   ├── styles/             # Estilos globales
│   │   └── globals.css     # TailwindCSS + custom
│   ├── App.tsx             # Componente principal
│   └── main.tsx            # Entry point
├── server/                 # Backend
│   ├── routes/
│   │   ├── auth.ts
│   │   ├── api.ts
│   │   └── bot.ts
│   ├── middleware/
│   │   ├── auth.ts
│   │   └── apiKey.ts
│   └── index.ts
├── supabase/              # Migraciones
│   └── migrations/
│       └── 001_initial_schema.sql
├── Dockerfile
├── package.json
├── tsconfig.json
└── tailwind.config.js
```

## 3. Modelos de Base de Datos

### users
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  discord_id TEXT UNIQUE NOT NULL,
  discord_username TEXT NOT NULL,
  avatar_url TEXT,
  role TEXT DEFAULT 'user', -- 'user' | 'admin'
  created_at TIMESTAMP DEFAULT NOW()
);
```

### discord_servers
```sql
CREATE TABLE discord_servers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  guild_id TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  icon_url TEXT,
  owner_user_id UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW()
);
```

### subscriptions
```sql
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id),
  discord_server_id UUID REFERENCES discord_servers(id),
  plan_type TEXT NOT NULL, -- 'premium_monthly' | 'premium_yearly' | 'premium_lifetime'
  status TEXT DEFAULT 'pending_payment', -- 'pending_payment' | 'active' | 'canceled' | 'expired'
  created_at TIMESTAMP DEFAULT NOW(),
  activated_at TIMESTAMP,
  expires_at TIMESTAMP
);
```

### bot_settings
```sql
CREATE TABLE bot_settings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  discord_server_id UUID REFERENCES discord_servers(id) UNIQUE,
  prefix TEXT DEFAULT '!',
  language TEXT DEFAULT 'es',
  log_channel_id TEXT,
  admin_role_id TEXT,
  welcome_enabled BOOLEAN DEFAULT false,
  welcome_message TEXT,
  other_json JSONB DEFAULT '{}'::jsonb
);
```

### bot_status
```sql
CREATE TABLE bot_status (
  id TEXT PRIMARY KEY DEFAULT 'main_bot',
  total_servers INTEGER DEFAULT 0,
  status TEXT DEFAULT 'offline', -- 'online' | 'offline' | 'maintenance'
  updated_at TIMESTAMP DEFAULT NOW()
);
```

## 4. API Endpoints

### Autenticación
- `GET /auth/discord` - Inicia OAuth2
- `GET /auth/discord/callback` - Callback OAuth2
- `GET /auth/me` - Usuario actual
- `POST /auth/logout` - Cerrar sesión

### Bot
- `POST /api/v1/bot/status` - Actualizar estado (requiere API key)
- `GET /api/v1/bot/status` - Obtener estado

### Servidores
- `GET /api/v1/servers` - Lista servidores del usuario
- `GET /api/v1/servers/:guildId` - Detalle servidor
- `GET /api/v1/servers/:guildId/subscription` - Suscripción del servidor
- `GET /api/v1/servers/:guildId/settings` - Configuración del bot
- `PUT /api/v1/servers/:guildId/settings` - Actualizar configuración

### Suscripciones
- `POST /api/v1/subscriptions` - Crear suscripción
- `PUT /api/v1/subscriptions/:id/status` - Cambiar estado (admin)

### Admin
- `GET /api/v1/admin/users` - Lista usuarios
- `GET /api/v1/admin/subscriptions` - Lista suscripciones
- `PUT /api/v1/admin/subscriptions/:id` - Editar suscripción

## 5. Componentes UI (Diseño SaaS Oscuro)

### Paleta de Colores (Dark Mode)
```css
--bg-primary: #0A0E1A
--bg-secondary: #111827
--bg-tertiary: #1F2937
--text-primary: #F9FAFB
--text-secondary: #D1D5DB
--accent: #6366F1 (Indigo)
--accent-hover: #4F46E5
--success: #10B981
--warning: #F59E0B
--error: #EF4444
```

### Componentes Principales
1. **Navbar**: Logo + Usuario + Notificaciones
2. **Sidebar**: Navegación principal
3. **Card**: Contenedor con sombra y borde sutil
4. **Table**: Tabla responsive con hover
5. **Modal**: Diálogos con backdrop blur
6. **Button**: Variantes (primary, secondary, danger)
7. **Badge**: Estados (active, pending, expired)

## 6. Páginas y Flujo

### Landing Page
- Hero con descripción del bot
- Pricing (3 planes: mensual, anual, lifetime)
- Botón "Entrar con Discord"

### Dashboard
- Header con usuario
- Card con estado del bot (servidores, status)
- Lista de servidores del usuario
- Accesos rápidos a configuración y suscripción

### Servers
- Tabla/grid de servidores
- Filtros por estado de suscripción
- Acciones: Configurar, Gestionar suscripción

### Subscription
- Plan actual y estado
- Opciones de upgrade/cambio
- Instrucciones de pago (Bizum/PayPal)

### Bot Settings
- Formulario de configuración
- Solo disponible para servidores Premium activos
- Guardar cambios con feedback visual

### Admin Panel
- Estadísticas generales
- Gestión de usuarios
- Gestión de suscripciones (cambiar estados)
- Logs del bot

## 7. Seguridad

1. **Discord OAuth2**: Almacenar tokens encriptados
2. **API Key**: Header `X-API-Key` para el bot
3. **CORS**: Configurado para dominio específico
4. **Rate Limiting**: Limitar peticiones por IP
5. **Validación**: Joi/Zod para validar inputs

## 8. Despliegue

1. **Frontend**: Render/Vercel
2. **Backend**: Render/Railway con Docker
3. **Base de Datos**: Supabase
4. **Variables de Entorno**:
   - `DISCORD_CLIENT_ID`
   - `DISCORD_CLIENT_SECRET`
   - `DISCORD_REDIRECT_URI`
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
   - `BOT_API_KEY`
   - `SESSION_SECRET`

## 9. Próximos Pasos

1. ✅ Crear estructura de carpetas
2. ✅ Implementar componentes UI base
3. ✅ Configurar Discord OAuth2
4. ✅ Crear páginas principales
5. ✅ Implementar API endpoints
6. ✅ Conectar con Supabase
7. ✅ Testing y deployment
