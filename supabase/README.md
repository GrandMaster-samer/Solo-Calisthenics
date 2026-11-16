# Connecting the optional cloud backend

The app is fully usable without any of this. Cloud features (Google sign-in,
encrypted cloud backup, coach review) only appear in builds that are given a
Supabase project. Everything here fits the Supabase free tier.

## One-time setup

1. Create a project at supabase.com (free plan).
2. SQL editor: paste and run `supabase/setup.sql`.
3. Authentication, Providers, Google: enable it. This needs an OAuth client
   from Google Cloud Console (type "Web application") whose authorised redirect
   URI is the callback URL Supabase shows on that page.
4. Authentication, URL configuration, Redirect URLs: add
   `com.grandmastersamer.solocalisthenics://login-callback`
5. Run the app with your project's URL and publishable key:

   ```bash
   flutter run --dart-define=SUPABASE_URL=https://YOUR-PROJECT.supabase.co --dart-define=SUPABASE_KEY=YOUR_PUBLISHABLE_KEY
   ```

   The publishable key is safe to ship in the app; access is enforced by the
   row-level security policies from step 2. Never put the service-role key in the app.
6. Sign in once in the app, then make yourself the coach (SQL editor):

   ```sql
   insert into public.coaches (user_id)
   select id from auth.users where email = 'you@example.com';
   ```

   Sign out and in again; the Coach inbox appears.

## How data is protected

* **Cloud backup** is the same passphrase-encrypted file as the local export.
  It is encrypted on the phone; the server only stores ciphertext. One backup per
  user, replaced on each upload, 50 MB limit.
* **Review clips** are at most 30 seconds, compressed to 720p without audio on the
  phone, and stored in a private bucket readable only by the athlete and coaches.
* **Deletion**: a clip is deleted the moment feedback is sent. Clips older than 30
  days are deleted whenever the athlete or a coach opens the coach screens.
  This cleanup runs from the app, so a clip of someone who never opens the app
  again stays until a coach opens the inbox. For a server-side guarantee, add a
  scheduled Edge Function later that removes old objects from `review-videos`.

## Changing provider or adding payments

* All server access goes through `CloudBackend`
  (`lib/features/cloud/domain/cloud_backend.dart`). Implement it for another
  provider and return it from `connectCloudBackend` in `lib/main.dart`.
* Coach review is gated by `Entitlements` in the same file. It currently allows
  every signed-in user. Add a subscription-backed implementation and override
  `entitlementsProvider`; no screen needs to change.
