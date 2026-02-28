```bash
# Setup NexaBot Panel

1. Clona repo
   git clone https://github.com/gonzalopriv9-byte/nexabot-panel.git
   cd nexabot-panel

2. Instala dependencias
   npm i @supabase/supabase-js @supabase/ssr lucide-react
   npm i -D prisma @prisma/client tailwindcss postcss autoprefixer

3. Configura .env.local desde .env.local.example

4. Crea tablas en Supabase (ver /supabase/migrations/)

5. npm run dev

Deploy: justrunmy.app o Vercel
```