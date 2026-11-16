-- Solo Calisthenics: optional cloud backend (Supabase free tier).
-- Run once in the Supabase SQL editor of a new project.

-- 1. Coaches -----------------------------------------------------------------
-- Add yourself after your first sign-in:
--   insert into public.coaches (user_id)
--   select id from auth.users where email = 'you@example.com';
create table if not exists public.coaches (
  user_id uuid primary key references auth.users (id) on delete cascade
);
alter table public.coaches enable row level security;
-- No policies: the table is only readable through is_coach() below.

create or replace function public.is_coach()
returns boolean
language sql stable security definer set search_path = public
as $$ select exists (select 1 from public.coaches where user_id = auth.uid()) $$;

-- 2. Coach review submissions -------------------------------------------------
create table if not exists public.submissions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  exercise_id text not null,
  note text not null default '' check (char_length(note) <= 1000),
  video_path text,
  status text not null default 'pending' check (status in ('pending', 'reviewed')),
  feedback text check (char_length(feedback) <= 4000),
  coach_id uuid references auth.users (id),
  created_at timestamptz not null default now(),
  reviewed_at timestamptz
);
create index if not exists submissions_user_idx on public.submissions (user_id, created_at desc);
create index if not exists submissions_queue_idx on public.submissions (status, created_at);
alter table public.submissions enable row level security;

create policy "athlete or coach can read" on public.submissions
  for select using (user_id = auth.uid() or public.is_coach());
create policy "athlete creates own pending submission" on public.submissions
  for insert with check (user_id = auth.uid() and status = 'pending' and feedback is null);
create policy "coach writes feedback" on public.submissions
  for update using (public.is_coach()) with check (public.is_coach());
create policy "athlete deletes own" on public.submissions
  for delete using (user_id = auth.uid());

-- 3. Private storage buckets ---------------------------------------------------
-- Files live under a folder named after the user's id.
insert into storage.buckets (id, name, public, file_size_limit)
values ('backups', 'backups', false, 52428800),            -- 50 MB encrypted backup
       ('review-videos', 'review-videos', false, 26214400) -- 25 MB clip
on conflict (id) do nothing;

create policy "own backup: all" on storage.objects
  for all using (bucket_id = 'backups' and (storage.foldername(name))[1] = auth.uid()::text)
  with check (bucket_id = 'backups' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "own clips: all" on storage.objects
  for all using (bucket_id = 'review-videos' and (storage.foldername(name))[1] = auth.uid()::text)
  with check (bucket_id = 'review-videos' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "coach reads clips" on storage.objects
  for select using (bucket_id = 'review-videos' and public.is_coach());
create policy "coach deletes clips" on storage.objects
  for delete using (bucket_id = 'review-videos' and public.is_coach());
