-- T Marz — Ad Tracking: Supabase setup
-- Run this once in your new Supabase project's SQL Editor
-- (Project → SQL Editor → New query → paste → Run)

-- 1. The leads table
create table public.leads (
  id uuid primary key default gen_random_uuid(),
  first_name text not null,
  last_name text not null,
  source text,        -- utm_source (e.g. fb, ig, an, msg — from Meta's {{site_source_name}})
  campaign text,       -- utm_campaign (Meta {{campaign.name}})
  ad text,             -- utm_content (Meta {{ad.name}})
  created_at timestamptz not null default now()
);

-- 2. Row Level Security — the website uses the public "anon" key, so lock
--    this down to insert-only. Nobody can read leads back out with that key.
alter table public.leads enable row level security;

create policy "Public can insert leads"
  on public.leads
  for insert
  to anon
  with check (true);

-- No select/update/delete policy is created for anon — reads are default-denied.
-- The dashboard (separate build) will use the service_role key or an
-- authenticated policy to read this table; that's out of scope here.

-- 3. Enable Realtime on this table (dashboard build will subscribe to it later)
alter publication supabase_realtime add table public.leads;
