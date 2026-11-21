-- Tranquilo: PostgreSQL & RLS Şeması
-- Bu script Supabase SQL Editöründe çalıştırılmak üzere hazırlanmıştır.

-- 1. Seanslar Tablosu
CREATE TABLE IF NOT EXISTS public.sessions (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL DEFAULT 'anonymous',
    worry_text TEXT NOT NULL,
    intensity_before INTEGER,
    intensity_after INTEGER,
    prompts JSONB DEFAULT '[]'::jsonb,
    answers JSONB DEFAULT '{}'::jsonb,
    small_action TEXT,
    ai_relief_message TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    completed_at TIMESTAMPTZ
);

-- 2. Row Level Security (RLS) Etkinleştirme
ALTER TABLE public.sessions ENABLE ROW LEVEL SECURITY;

-- 3. Güvenlik Politikaları (Her kullanıcı yalnızca kendi seansını okuyabilir ve yazabilir)
CREATE POLICY "Users can only read own sessions"
    ON public.sessions
    FOR SELECT
    USING (auth.uid()::text = user_id OR user_id = 'anonymous');

CREATE POLICY "Users can insert own sessions"
    ON public.sessions
    FOR INSERT
    WITH CHECK (auth.uid()::text = user_id OR user_id = 'anonymous');

CREATE POLICY "Users can update own sessions"
    ON public.sessions
    FOR UPDATE
    USING (auth.uid()::text = user_id OR user_id = 'anonymous');

CREATE POLICY "Users can delete own sessions"
    ON public.sessions
    FOR DELETE
    USING (auth.uid()::text = user_id OR user_id = 'anonymous');
