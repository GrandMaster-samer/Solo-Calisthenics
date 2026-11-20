# Phone test checklist

These are the things that automated tests cannot check. Go through them on a real
Android phone (and an iPhone if you have a Mac). Tick each one; send me whatever fails,
with a screenshot if you can.

## Get the app onto your phone

**Without Flutter (fastest):** open the repository on GitHub, go to **Actions**, open
the latest successful **CI** run, and download the `solo-calisthenics-apk` artifact.
Unzip it and copy `app-arm64-v8a-release.apk` to your phone (almost every phone from
the last several years is arm64). Open it and allow installing from that source.

**With Flutter:** on the phone, enable Developer options and USB debugging, connect it
by USB, then:

```bash
flutter pub get
```

```bash
flutter run --release
```

## Phase 1

- [ ] First launch shows onboarding. Switching to العربية flips the whole layout right-to-left.
- [ ] Finish onboarding with a wrist or shoulder limitation. The Library greys out the affected exercises and names the joint.
- [ ] Start a workout. The big tap zone counts reps and the phone vibrates on each tap.
- [ ] **Volume buttons (Android):** volume up adds a rep, volume down removes one, and the media volume does not change. During rest the volume buttons work normally again.
- [ ] The screen stays on during the workout.
- [ ] **Rest timer, screen off:** log a set, lock the phone, wait. A notification with sound and vibration arrives when rest ends. The first workout asks for notification permission; allow it.
- [ ] **Rest timer accuracy:** note the time left, lock the phone for 30 seconds, unlock. The timer has moved by 30 seconds.
- [ ] **Kill test:** mid-workout, with a few taps counted and a rest running, swipe the app away from recent apps. Reopen it. You are back in the workout with the same sets, counter and rest.
- [ ] Airplane mode on: everything above still works.
- [ ] Settings, reminders: pick today and a time two minutes ahead. The reminder arrives.
- [ ] Library rows show a small drawing per exercise; an exercise page shows the figure moving through a rep. With the system's "remove animations" setting on, it shows a still image instead.
- [ ] Fonts look right in both languages; timer digits do not jump sideways as they change.

## Phase 2

- [ ] Create a weekly plan. "This week" shows the right number of days.
- [ ] Do a planned workout hitting the top of the range on every set, twice (use manual entry to go quickly). After the second one a "Progress update" says the next exercise is unlocked, and the Skills tab shows it.
- [ ] Progress tab shows the workouts in the charts.
- [ ] **Photo vault:** add a photo with the camera and one from the gallery. Open your phone's gallery app: the camera photo is **not** there.
- [ ] Select two photos and compare them.
- [ ] Set a PIN in the vault. Leave and reopen the vault: it asks for the PIN.
- [ ] Settings, Security: turn on "Lock the whole app". Send the app to the background and return: it asks for the PIN.
- [ ] Turn on fingerprint/face unlock: the system prompt appears and unlocks.
- [ ] With the vault open, try a screenshot or look at the recent-apps preview: the content is hidden (Android).
- [ ] **Backup:** Settings, Export encrypted backup. Choose a passphrase, save the file to Files or Drive.
- [ ] **Restore:** uninstall the app, install it again, finish onboarding quickly, then Settings, Restore from backup. Pick the file, enter the passphrase. The app restarts with your old data and photos.
- [ ] A wrong passphrase shows an error and changes nothing.

## Phase 3 (only after connecting Supabase, see supabase/README.md)

- [ ] Settings shows "Account and cloud". Sign in with Google: the browser opens and returns to the app signed in.
- [ ] Back up to the cloud, then restore from the cloud on a fresh install.
- [ ] Progress, Coach review: record a clip under 30 seconds and send it. It appears as "Waiting".
- [ ] After making yourself a coach (SQL in the guide) and signing in again, the Coach inbox lists the clip, it plays, and sending feedback removes it from the inbox.
- [ ] The athlete account sees the feedback as "Reviewed".
- [ ] In the Supabase dashboard, Storage, `review-videos`: the clip file is gone after feedback.

## Known limits (not bugs)

- A forgotten PIN or backup passphrase cannot be recovered.
- iPhone has no volume-button counting; use the tap zone.
