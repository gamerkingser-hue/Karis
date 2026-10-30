-- Optional: run only after enabling pg_cron in Supabase.
create extension if not exists pg_cron;
select cron.schedule('delete-post-match-reports-older-than-30m','* * * * *',
$$delete from public.reports where created_at < now() - interval '30 minutes'$$);
