# NexaBot Panel 🎨

> **Dashboard SaaS Profesional con Modo Oscuro para NexaBot Discord Bot**

## 📚 Versión 2.0 - UI Profesional

Panel de administración completo con diseño moderno tipo SaaS para gestionar NexaBot, suscripciones Premium y configuración de servidores Discord.

### ✨ Características

- **🎨 UI Moderna**: Diseño dark mode con TailwindCSS
- **🔒 Auth Discord**: OAuth2 completo con Discord
- **📊 Dashboard**: Estado del bot en tiempo real
- **💳 Suscripciones**: Gestión de planes Premium (mensual, anual, lifetime)
- **⚙️ Configuración**: Panel de ajustes del bot por servidor
- **👤 Admin Panel**: Gestión completa para administradores
- **🚀 API REST**: Endpoints para que el bot actualice su estado

## 🛠️ Stack Tecnológico

### Frontend
- React 18 + TypeScript
- TailwindCSS (Dark Mode)
- React Router v6
- Axios

### Backend
- Node.js + Express
- TypeScript
- Passport Discord OAuth2
- Supabase (PostgreSQL)

### DevOps
- Docker
- Render/Railway
- GitHub Actions (CI/CD)

## 📁 Estructura del Proyecto

Ver [ARCHITECTURE.md](./ARCHITECTURE.md) para documentación completa de la arquitectura.

```
nexabot-panel/
├── src/
│   ├── components/  # Componentes React
│   ├── pages/       # Páginas principales
│   ├── api/         # API routes
│   ├── lib/         # Utilidades
│   └── types/       # TypeScript types
├── server/         # Backend Express
└── supabase/       # Migraciones DB
```

## 🚀 Quick Start

### 1. Clonar repositorio
```bash
git clone https://github.com/gonzalopriv9-byte/nexabot-panel.git
cd nexabot-panel
```

### 2. Instalar dependencias
```bash
npm install
```

### 3. Configurar variables de entorno
Copia `.env.local.example` a `.env.local` y configura:

```env
# Discord OAuth2
DISCORD_CLIENT_ID=tu_client_id
DISCORD_CLIENT_SECRET=tu_client_secret
DISCORD_REDIRECT_URI=http://localhost:5173/auth/discord/callback

# Supabase
SUPABASE_URL=tu_supabase_url
SUPABASE_ANON_KEY=tu_supabase_anon_key

# Bot API
BOT_API_KEY=tu_api_key_secreta

# Session
SESSION_SECRET=tu_session_secret
```

### 4. Crear tablas en Supabase
Ejecuta las migraciones en `/supabase/migrations/`

### 5. Ejecutar en desarrollo
```bash
# Frontend (puerto 5173)
npm run dev

# Backend (puerto 3000)
npm run server
```

## 💳 Planes de Suscripción

| Plan | Precio | Duración |
|------|--------|----------|
| **Premium Monthly** | 1,99 € | 30 días |
| **Premium Yearly** | 10,00 € | 365 días |
| **Premium Lifetime** | 15,00 € | De por vida |

### Métodos de Pago
- 💱 Bizum: +34 683136215
- 💳 PayPal: Contactar por Discord

## 📚 Documentación

- [ARCHITECTURE.md](./ARCHITECTURE.md) - Arquitectura completa del sistema
- [API.md](./docs/API.md) - Documentación de endpoints (próximamente)
- [DEPLOY.md](./docs/DEPLOY.md) - Guía de despliegue (próximamente)

## 🔑 API para el Bot

El bot puede actualizar su estado usando:

```javascript
// Actualizar estado del bot
POST /api/v1/bot/status
Headers: { 'X-API-Key': 'tu_api_key' }
Body: { total_servers: 150, status: 'online' }

// Obtener configuración de un servidor
GET /api/v1/servers/:guildId/settings
Headers: { 'X-API-Key': 'tu_api_key' }
```

## 👥 Contribuir

¡Las contribuciones son bienvenidas! Por favor:

1. Fork el proyecto
2. Crea tu rama (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add: Amazing Feature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 TODO

- [ ] Completar componentes UI (Button, Card, Modal, etc.)
- [ ] Implementar Discord OAuth2
- [ ] Crear páginas (Dashboard, Servers, Subscription, Admin)
- [ ] Desarrollar API REST completa
- [ ] Conectar con Supabase
- [ ] Testing y deployment
- [ ] Documentación completa de la API

## 💬 Soporte

- Discord: [Servidor de NexaBot](#)
- Email: gonzalopriv9@example.com
- Issues: [GitHub Issues](https://github.com/gonzalopriv9-byte/nexabot-panel/issues)

## 📜 Licencia

Este proyecto es privado y está protegido por derechos de autor.

---

**Hecho con ❤️ por gonzalopriv9-byte**
