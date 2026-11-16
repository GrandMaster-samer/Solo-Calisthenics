# Exercise media pipeline

Every exercise shows a clearly labeled placeholder until you add your own clip.
No third-party or copyrighted media ships with the app.

## Add a clip

1. Record the movement (landscape, 3 to 6 seconds, one clean rep or hold).
2. Convert it to a small looping animated WebP (no audio):

   ```bash
   ffmpeg -i push_up.mp4 -vf "fps=15,scale=640:-2" -loop 0 -an -c:v libwebp -q:v 60 push_up.webp
   ```

   Target: 640 px wide, 15 fps, under about 250 KB per clip, 16:9 framing.
3. Put the file in `assets/media/exercises/`.
4. In `assets/data/exercises.json`, set that exercise's `"media"` to the file
   name, for example `"media": "push_up.webp"`.

No code changes are needed. The folder is already bundled, and
`test/exercises/seed_data_test.dart` fails if the JSON names a file that is missing.

## Size budget

The base install target is under 40 MB. 80 clips at 250 KB each is about 20 MB, so
keep clips short and at the settings above.
