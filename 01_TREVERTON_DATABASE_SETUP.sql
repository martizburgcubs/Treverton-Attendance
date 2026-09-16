
-- ============================================================
-- TREVERTON COLLEGE: DATABASE REPAIR / CREATE MISSING TABLES
-- Run this in the Supabase project you want to use for Treverton College.
-- ============================================================

create extension if not exists pgcrypto;

create table if not exists public.trev_players (
  id uuid primary key default gen_random_uuid(),
  sport text not null,
  team text not null,
  slot integer not null,
  player_name text not null default '',
  class_name text not null default '',
  updated_at timestamptz not null default now(),
  unique (sport, team, slot)
);

create table if not exists public.trev_attendance (
  id uuid primary key default gen_random_uuid(),
  sport text not null,
  team text not null,
  slot integer not null,
  session_date date not null,
  status text not null default '?'
    check (status in ('?','P','A','E','S','SC')),
  updated_at timestamptz not null default now(),
  unique (sport, team, slot, session_date)
);

create table if not exists public.trev_player_support (
  id uuid primary key default gen_random_uuid(),
  sport text not null,
  team text not null,
  slot integer not null,
  coach_notes text not null default '',
  injury_notes text not null default '',
  sc_notes text not null default '',
  availability_status text not null default 'clear'
    check (availability_status in ('clear','pending','low','injured')),
  first_flagged_at timestamptz,
  status_updated_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (sport, team, slot)
);

create table if not exists public.trev_bus_journeys (
  id uuid primary key default gen_random_uuid(),
  travel_date date not null default current_date,
  vehicle text not null,
  sport text not null,
  team text not null,
  journey text not null,
  destination text not null,
  departure_time time,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  removed_at timestamptz,
  removal_reason text,
  restored_at timestamptz
);

create table if not exists public.trev_bus_passengers (
  id uuid primary key default gen_random_uuid(),
  journey_id uuid not null references public.trev_bus_journeys(id) on delete cascade,
  slot integer,
  learner_name text not null,
  status text not null default 'On bus'
    check (status in ('On bus','Not travelling')),
  created_at timestamptz not null default now()
);

create or replace function public.trev_touch_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists trg_trev_players_touch on public.trev_players;
create trigger trg_trev_players_touch
before update on public.trev_players
for each row execute function public.trev_touch_updated_at();

drop trigger if exists trg_trev_attendance_touch on public.trev_attendance;
create trigger trg_trev_attendance_touch
before update on public.trev_attendance
for each row execute function public.trev_touch_updated_at();

drop trigger if exists trg_trev_bus_touch on public.trev_bus_journeys;
create trigger trg_trev_bus_touch
before update on public.trev_bus_journeys
for each row execute function public.trev_touch_updated_at();

create or replace function public.trev_support_before_write()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := now();

  if tg_op = 'INSERT' then
    new.status_updated_at := now();
    if new.availability_status in ('pending','low','injured') then
      new.first_flagged_at := now();
    end if;
    return new;
  end if;

  if old.availability_status is distinct from new.availability_status then
    new.status_updated_at := now();
    if old.availability_status = 'clear'
       and new.availability_status in ('pending','low','injured')
       and new.first_flagged_at is null then
      new.first_flagged_at := now();
    end if;
  else
    new.status_updated_at := old.status_updated_at;
  end if;

  return new;
end;
$$;

drop trigger if exists trg_trev_support_before_write on public.trev_player_support;
create trigger trg_trev_support_before_write
before insert or update on public.trev_player_support
for each row execute function public.trev_support_before_write();

alter table public.trev_players enable row level security;
alter table public.trev_attendance enable row level security;
alter table public.trev_player_support enable row level security;
alter table public.trev_bus_journeys enable row level security;
alter table public.trev_bus_passengers enable row level security;

do $$
declare t text;
begin
  foreach t in array array[
    'trev_players',
    'trev_attendance',
    'trev_player_support',
    'trev_bus_journeys',
    'trev_bus_passengers'
  ]
  loop
    execute format('drop policy if exists "trev_public_select" on public.%I', t);
    execute format('drop policy if exists "trev_public_insert" on public.%I', t);
    execute format('drop policy if exists "trev_public_update" on public.%I', t);

    execute format(
      'create policy "trev_public_select" on public.%I for select to anon, authenticated using (true)', t
    );
    execute format(
      'create policy "trev_public_insert" on public.%I for insert to anon, authenticated with check (true)', t
    );
    execute format(
      'create policy "trev_public_update" on public.%I for update to anon, authenticated using (true) with check (true)', t
    );
  end loop;
end $$;

grant select, insert, update on public.trev_players to anon, authenticated;
grant select, insert, update on public.trev_attendance to anon, authenticated;
grant select, insert, update on public.trev_player_support to anon, authenticated;
grant select, insert, update on public.trev_bus_journeys to anon, authenticated;
grant select, insert on public.trev_bus_passengers to anon, authenticated;

-- Ask PostgREST to refresh its schema cache immediately.
notify pgrst, 'reload schema';
