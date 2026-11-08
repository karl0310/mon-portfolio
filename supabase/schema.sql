-- Karl Bryan portfolio: run this script in Supabase SQL Editor.
-- After creating your admin account in Authentication > Users, copy its UUID
-- and run the INSERT statement at the bottom.

create extension if not exists pgcrypto;

create table if not exists public.portfolio_admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(title) between 1 and 120),
  category text not null check (char_length(category) between 1 and 80),
  description text not null check (char_length(description) <= 1500),
  year_label text not null default extract(year from now())::text,
  icon text not null default '✦',
  image_url text,
  project_url text,
  status text not null default 'published' check (status in ('published','draft')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists projects_status_created_idx
  on public.projects(status, created_at desc);

create or replace function public.is_portfolio_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.portfolio_admins
    where user_id = (select auth.uid())
  );
$$;

alter table public.portfolio_admins enable row level security;
alter table public.projects enable row level security;

revoke all on public.portfolio_admins from anon, authenticated;
grant select on public.portfolio_admins to authenticated;
grant select on public.projects to anon, authenticated;
grant insert, update, delete on public.projects to authenticated;

drop policy if exists "Admins can read own admin record" on public.portfolio_admins;
create policy "Admins can read own admin record"
on public.portfolio_admins for select to authenticated
using (user_id = (select auth.uid()));

drop policy if exists "Anyone can read published projects" on public.projects;
create policy "Anyone can read published projects"
on public.projects for select to anon, authenticated
using (status = 'published' or (select public.is_portfolio_admin()));

drop policy if exists "Admins can insert projects" on public.projects;
create policy "Admins can insert projects"
on public.projects for insert to authenticated
with check ((select public.is_portfolio_admin()));

drop policy if exists "Admins can update projects" on public.projects;
create policy "Admins can update projects"
on public.projects for update to authenticated
using ((select public.is_portfolio_admin()))
with check ((select public.is_portfolio_admin()));

drop policy if exists "Admins can delete projects" on public.projects;
create policy "Admins can delete projects"
on public.projects for delete to authenticated
using ((select public.is_portfolio_admin()));

-- Optional public image bucket for project thumbnails.
insert into storage.buckets (id, name, public)
values ('portfolio-projects', 'portfolio-projects', true)
on conflict (id) do nothing;

drop policy if exists "Public can view portfolio images" on storage.objects;
create policy "Public can view portfolio images"
on storage.objects for select to public
using (bucket_id = 'portfolio-projects');

drop policy if exists "Admins can upload portfolio images" on storage.objects;
create policy "Admins can upload portfolio images"
on storage.objects for insert to authenticated
with check (bucket_id = 'portfolio-projects' and (select public.is_portfolio_admin()));

drop policy if exists "Admins can update portfolio images" on storage.objects;
create policy "Admins can update portfolio images"
on storage.objects for update to authenticated
using (bucket_id = 'portfolio-projects' and (select public.is_portfolio_admin()))
with check (bucket_id = 'portfolio-projects' and (select public.is_portfolio_admin()));

drop policy if exists "Admins can delete portfolio images" on storage.objects;
create policy "Admins can delete portfolio images"
on storage.objects for delete to authenticated
using (bucket_id = 'portfolio-projects' and (select public.is_portfolio_admin()));

-- IMPORTANT: after creating your account, replace the UUID below and execute:
-- insert into public.portfolio_admins (user_id)
-- values ('PASTE-YOUR-AUTH-USER-UUID-HERE');
