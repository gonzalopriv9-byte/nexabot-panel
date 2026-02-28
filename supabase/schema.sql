```sql
-- Habilitar uuid-ossp extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- profiles
CREATE TABLE profiles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  discord_id BIGINT UNIQUE NOT NULL,
  discord_username TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own profile" ON profiles FOR SELECT USING (discord_id = auth.uid()::bigint);
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (discord_id = auth.uid()::bigint);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (discord_id = auth.uid()::bigint);

-- discord_servers
CREATE TABLE discord_servers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  guild_id BIGINT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  icon_url TEXT,
  owner_user_id BIGINT REFERENCES profiles(discord_id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE discord_servers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users own servers" ON discord_servers FOR ALL USING (owner_user_id = auth.uid()::bigint);

-- user_roles
CREATE TABLE user_roles (
  id SERIAL PRIMARY KEY,
  user_id BIGINT REFERENCES profiles(discord_id) ON DELETE CASCADE,
  role TEXT CHECK (role IN ('admin', 'user')) NOT NULL
);
CREATE INDEX idx_user_roles_user_id ON user_roles(user_id);

ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users view own role" ON user_roles FOR SELECT USING (user_id = auth.uid()::bigint);

-- Función helper para roles
CREATE OR REPLACE FUNCTION public.has_role(p_user_id BIGINT, p_role TEXT)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.user_roles 
    WHERE user_id = p_user_id AND role = p_role
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- subscriptions
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id BIGINT REFERENCES profiles(discord_id) ON DELETE CASCADE,
  discord_server_id UUID REFERENCES discord_servers(id) ON DELETE CASCADE,
  plan_type TEXT CHECK (plan_type IN ('monthly', 'yearly', 'lifetime')) NOT NULL,
  status TEXT CHECK (status IN ('pending_payment', 'active', 'canceled', 'expired')) DEFAULT 'pending_payment',
  payment_method TEXT CHECK (payment_method IN ('bizum', 'paypal', null)),
  tx_proof_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  activated_at TIMESTAMP WITH TIME ZONE,
  expires_at TIMESTAMP WITH TIME ZONE
);

ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users view own subs" ON subscriptions FOR SELECT USING (user_id = auth.uid()::bigint);

-- bot_settings
CREATE TABLE bot_settings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  discord_server_id UUID UNIQUE REFERENCES discord_servers(id) ON DELETE CASCADE,
  prefix TEXT DEFAULT '!',
  language TEXT DEFAULT 'es',
  log_channel_id BIGINT,
  admin_role_id BIGINT,
  welcome_enabled BOOLEAN DEFAULT false,
  welcome_message TEXT,
  other_settings JSONB DEFAULT '{}',
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE bot_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Server owners manage settings" ON bot_settings FOR ALL 
USING (discord_server_id IN (SELECT id FROM discord_servers WHERE owner_user_id = auth.uid()::bigint));

-- bot_status (singleton)
CREATE TABLE bot_status (
  id TEXT PRIMARY KEY DEFAULT 'main_bot',
  total_servers INTEGER DEFAULT 0,
  status TEXT DEFAULT 'online' CHECK (status IN ('online', 'offline', 'maintenance')),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Trigger auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_bot_settings_updated_at BEFORE UPDATE
  ON bot_settings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Índices clave
CREATE INDEX idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_servers_owner ON discord_servers(owner_user_id);
```