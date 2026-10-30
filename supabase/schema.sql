create table if not exists public.reports (
 id uuid primary key default gen_random_uuid(),
 created_at timestamptz not null default now(),
 match_code text not null check (char_length(match_code) between 1 and 40),
 player_label text not null check (char_length(player_label) between 1 and 60),
 platform text not null check (platform in ('Android','iPhone')),
 vpn_status text not null check (vpn_status in ('yes','no','unsure')),
 proxy_status text not null check (proxy_status in ('yes','no','unsure')),
 dns_mode text not null check (dns_mode in ('custom','automatic','unsure')),
 note text not null default '' check (char_length(note)<=500),
 consent boolean not null check (consent=true),
 browser_online boolean not null default false,
 user_agent text not null default '' check (char_length(user_agent)<=300),
 timezone text not null default '' check (char_length(timezone)<=80),
 evidence_type text not null default 'player_self_report' check (evidence_type='player_self_report')
);
alter table public.reports enable row level security;
drop policy if exists "public can submit consented reports" on public.reports;
create policy "public can submit consented reports" on public.reports for insert to anon,authenticated
with check (consent=true and evidence_type='player_self_report');
drop policy if exists "authenticated admins can read reports" on public.reports;
create policy "only designated admins can read reports" on public.reports for select to authenticated
using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
grant insert on public.reports to anon,authenticated;
grant select on public.reports to authenticated;
