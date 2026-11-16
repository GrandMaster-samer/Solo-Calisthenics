// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Solo Calisthenics';

  @override
  String get listSeparator => ', ';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get skip => 'Skip';

  @override
  String get continueLabel => 'Continue';

  @override
  String get finishSetup => 'Finish setup';

  @override
  String get remove => 'Remove';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get invalidValue => 'Enter a valid value';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get welcomeTitle => 'Train with your own body';

  @override
  String get welcomeBody =>
      'A few questions so the app fits your level and protects your joints. Everything stays on this device, encrypted. No account needed.';

  @override
  String get disclaimerTitle => 'Health disclaimer';

  @override
  String get disclaimerBody =>
      'This app does not diagnose or treat injuries. If you have pain or an injury, consult a medical professional before training. Stop any exercise that causes pain.';

  @override
  String get disclaimerAccept => 'I understand';

  @override
  String get statsTitle => 'About you';

  @override
  String get statsBody =>
      'Used to adapt your training. You can change this later in Settings.';

  @override
  String get birthYear => 'Year of birth';

  @override
  String get height => 'Height';

  @override
  String get weight => 'Weight';

  @override
  String get feet => 'Feet';

  @override
  String get inches => 'Inches';

  @override
  String get unitCm => 'cm';

  @override
  String get unitFtIn => 'ft / in';

  @override
  String get unitKg => 'kg';

  @override
  String get unitLb => 'lb';

  @override
  String get experienceTitle => 'Training experience';

  @override
  String get experienceBody =>
      'Pick the level that matches your calisthenics training.';

  @override
  String get expBeginner => 'Beginner';

  @override
  String get expIntermediate => 'Intermediate';

  @override
  String get expAdvanced => 'Advanced';

  @override
  String get expBeginnerDesc =>
      'New to bodyweight training, or returning after a long break.';

  @override
  String get expIntermediateDesc =>
      'Comfortable with push-ups, pull-ups and dips for multiple sets.';

  @override
  String get expAdvancedDesc =>
      'Working on skills such as muscle-ups, levers or handstand push-ups.';

  @override
  String get baselineTitle => 'Baseline test (optional)';

  @override
  String get baselineBody =>
      'Your best single effort for each. Leave blank what you have not tested, or skip this step.';

  @override
  String get maxPushUps => 'Max push-ups';

  @override
  String get maxPullUps => 'Max pull-ups';

  @override
  String get maxDeadHang => 'Max dead hang';

  @override
  String get maxPlank => 'Max plank';

  @override
  String get repsUnit => 'reps';

  @override
  String get secondsUnit => 's';

  @override
  String get jointsTitle => 'Joints and injuries';

  @override
  String get jointsBody =>
      'Flag any joint with a past or current limitation. Exercises are filtered and adapted to match.';

  @override
  String get jointsRules =>
      'Mild: allowed with a targeted warm-up and fewer sets. Moderate: high-stress exercises are replaced with an easier variation. Severe: medium and high-stress exercises are excluded.';

  @override
  String get noIssue => 'No issue';

  @override
  String get severityMild => 'Mild';

  @override
  String get severityModerate => 'Moderate';

  @override
  String get severitySevere => 'Severe';

  @override
  String get injuryCurrent => 'Current issue';

  @override
  String get injuryCurrentHint =>
      'Turn off if this is a past injury you still want to protect.';

  @override
  String get jointWrists => 'Wrists';

  @override
  String get jointShoulders => 'Shoulders';

  @override
  String get jointElbows => 'Elbows';

  @override
  String get jointKnees => 'Knees';

  @override
  String get jointLowerBack => 'Lower back';

  @override
  String get tabTrain => 'Train';

  @override
  String get tabLibrary => 'Library';

  @override
  String get tabSettings => 'Settings';

  @override
  String get patternPush => 'Push';

  @override
  String get patternPull => 'Pull';

  @override
  String get patternLegs => 'Legs';

  @override
  String get patternCore => 'Core';

  @override
  String get patternStatics => 'Statics';

  @override
  String get stressNone => 'None';

  @override
  String get stressLow => 'Low';

  @override
  String get stressMedium => 'Medium';

  @override
  String get stressHigh => 'High';

  @override
  String targetReps(int min, int max) {
    return '$min–$max reps';
  }

  @override
  String targetSeconds(int min, int max) {
    return '$min–$max s';
  }

  @override
  String restSeconds(int seconds) {
    return 'Rest $seconds s';
  }

  @override
  String levelInChain(int level, int total) {
    return 'Level $level of $total';
  }

  @override
  String notRecommendedFor(String joints) {
    return 'Not recommended for your $joints';
  }

  @override
  String cautionFor(String joints) {
    return 'Take care: $joints';
  }

  @override
  String volumeCapped(int sets) {
    return 'Volume capped at $sets sets.';
  }

  @override
  String trySubstitute(String name) {
    return 'Try instead: $name';
  }

  @override
  String get noSubstitute =>
      'No easier variation in this chain is suitable right now.';

  @override
  String get excludedConfirmTitle => 'Not recommended';

  @override
  String excludedConfirmBody(String joints) {
    return 'Your injury screening excludes this exercise ($joints). Add it anyway?';
  }

  @override
  String get addAnyway => 'Add anyway';

  @override
  String get formCues => 'Form cues';

  @override
  String get commonMistakes => 'Common mistakes';

  @override
  String get jointStress => 'Joint stress';

  @override
  String get progressionPath => 'Progression path';

  @override
  String get easier => 'Easier (regression)';

  @override
  String get harder => 'Harder (progression)';

  @override
  String get noneInChain => 'None: end of the chain';

  @override
  String get mediaPlaceholder => 'PLACEHOLDER\nVisual guide not added yet';

  @override
  String get exerciseMissing => 'Exercise not found';

  @override
  String get trainThis => 'Train this exercise';

  @override
  String get pickExercises => 'Pick exercises';

  @override
  String addSelected(int count) {
    return 'Add ($count)';
  }

  @override
  String get starterWorkouts => 'Starter workouts';

  @override
  String get starterWorkoutsHint =>
      'Matched to your level and adapted to your joints.';

  @override
  String get templatePush => 'Push';

  @override
  String get templatePull => 'Pull';

  @override
  String get templateLegsCore => 'Legs and core';

  @override
  String get templateFullBody => 'Full body';

  @override
  String get templateEmpty =>
      'No suitable exercises with your current injury settings.';

  @override
  String get buildYourOwn => 'Build your own workout';

  @override
  String get customWorkout => 'Custom workout';

  @override
  String get history => 'History';

  @override
  String get historyEmpty => 'Finished workouts will appear here.';

  @override
  String get workoutInProgress => 'Workout in progress';

  @override
  String get resume => 'Resume';

  @override
  String setsLogged(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sets logged',
      one: '1 set logged',
      zero: 'No sets yet',
    );
    return '$_temp0';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String setsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sets',
      one: '1 set',
    );
    return '$_temp0';
  }

  @override
  String get startWorkout => 'Start workout';

  @override
  String get addExercises => 'Add exercises';

  @override
  String get replaceWorkoutTitle => 'Replace current workout?';

  @override
  String get replaceWorkoutBody =>
      'You have a workout in progress. Starting a new one discards it.';

  @override
  String get startNew => 'Start new';

  @override
  String get warmUpTitle => 'Warm up these joints first';

  @override
  String get warmUpWrists =>
      'Wrist circles and palm/back-of-hand rocks, 1 minute';

  @override
  String get warmUpShoulders =>
      'Arm circles, scapular push-ups and band pull-aparts, 2 minutes';

  @override
  String get warmUpElbows =>
      'Light elbow bends and forearm rotations, 1 minute';

  @override
  String get warmUpKnees =>
      'Knee circles, slow half squats and leg swings, 2 minutes';

  @override
  String get warmUpLowerBack =>
      'Cat-cow, bird-dog and glute bridges, 2 minutes';

  @override
  String setOf(int current, int total) {
    return 'Set $current of $total';
  }

  @override
  String get tapToCount => 'Tap anywhere here to count a rep';

  @override
  String get tapOrVolumeToCount => 'Tap here or press volume up to count a rep';

  @override
  String get tapToStartHold => 'Tap to start the hold timer';

  @override
  String get tapToStopHold => 'Tap to stop and save';

  @override
  String get minusOne => 'Remove one rep';

  @override
  String get enterReps => 'Enter reps';

  @override
  String get enterSeconds => 'Enter seconds';

  @override
  String doneReps(int count) {
    return 'Done · $count reps';
  }

  @override
  String doneSeconds(int count) {
    return 'Done · $count s';
  }

  @override
  String get undoLastSet => 'Undo last set';

  @override
  String get previousExercise => 'Previous exercise';

  @override
  String get nextExercise => 'Next exercise';

  @override
  String get rest => 'Rest';

  @override
  String get skipRest => 'Skip rest';

  @override
  String minusSeconds(int seconds) {
    return '−$seconds s';
  }

  @override
  String plusSeconds(int seconds) {
    return '+$seconds s';
  }

  @override
  String nextUp(String exercise, String set) {
    return 'Next: $exercise · $set';
  }

  @override
  String get rirQuestion => 'How many more reps could you have done? (RIR)';

  @override
  String get rpeQuestion => 'How hard was that set? (RPE)';

  @override
  String get restOverTitle => 'Rest is over';

  @override
  String get restOverBody => 'Time for your next set.';

  @override
  String get finish => 'Finish';

  @override
  String get finishWorkout => 'Finish workout';

  @override
  String get keepGoing => 'Keep going';

  @override
  String get finishEarlyTitle => 'Finish early?';

  @override
  String get finishEarlyBody =>
      'Some sets are not done yet. What you logged is saved.';

  @override
  String get discard => 'Discard workout';

  @override
  String get discardTitle => 'Discard this workout?';

  @override
  String get discardBody => 'All sets logged in this workout will be deleted.';

  @override
  String get workoutComplete => 'Workout complete';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsWorkout => 'Workout';

  @override
  String get settingsReminders => 'Workout reminders';

  @override
  String get settingsAbout => 'About';

  @override
  String get editProfile => 'Profile and injuries';

  @override
  String get editProfileHint =>
      'Stats, experience, baseline test, joint screening';

  @override
  String get effortScale => 'Effort scale after each set';

  @override
  String get effortRir => 'RIR (reps in reserve)';

  @override
  String get effortRpe => 'RPE (6–10)';

  @override
  String get settingSound => 'Sounds';

  @override
  String get settingHaptics => 'Vibration';

  @override
  String get settingVolumeButtons => 'Count reps with volume buttons';

  @override
  String get settingVolumeButtonsHint =>
      'Volume up adds a rep, volume down removes one.';

  @override
  String get weekdaysShort => 'Mon,Tue,Wed,Thu,Fri,Sat,Sun';

  @override
  String get reminderTime => 'Reminder time';

  @override
  String get reminderTitle => 'Time to train';

  @override
  String get reminderBody => 'Your workout is waiting.';

  @override
  String get privacyTitle => 'Privacy';

  @override
  String get privacyBody =>
      'All data is stored encrypted on this device. Nothing is sent anywhere.';

  @override
  String get licenses => 'Open-source licenses';

  @override
  String get tabSkills => 'Skills';

  @override
  String get tabProgress => 'Progress';

  @override
  String get optional => 'Optional';

  @override
  String get delete => 'Delete';

  @override
  String get planPromoTitle => 'Get your weekly plan';

  @override
  String get planPromoBody =>
      'Pick your training days and session length. The plan adapts to your level and joints, and progresses as you log.';

  @override
  String get planCreate => 'Create my plan';

  @override
  String get planSetupTitle => 'Weekly plan';

  @override
  String get planSave => 'Save plan';

  @override
  String get planDaysPerWeek => 'Training days per week';

  @override
  String get planSessionLength => 'Session length';

  @override
  String get planSkills => 'Skills to work on';

  @override
  String get planSkillsHint =>
      'Optional. Skill work is placed first in the session while you are fresh.';

  @override
  String get planDeload => 'Lighter week';

  @override
  String get planDeloadHint =>
      'An automatic easier week to recover. It also starts early if your performance drops two sessions in a row.';

  @override
  String everyWeeks(int weeks) {
    return 'Every $weeks weeks';
  }

  @override
  String get thisWeek => 'This week';

  @override
  String get deloadWeek => 'Lighter week';

  @override
  String get deloadExplainer =>
      'Lighter week: fewer sets and easier targets so your body recovers. Progress is not judged this week.';

  @override
  String get todaysWorkout => 'Today\'s workout';

  @override
  String get nextWorkout => 'Next workout';

  @override
  String aboutMinutes(int minutes) {
    return 'About $minutes min';
  }

  @override
  String get reviewAndStart => 'Review and start';

  @override
  String get weekComplete => 'All planned workouts done this week';

  @override
  String get dayDone => 'Done';

  @override
  String get dayOpen => 'Not done yet';

  @override
  String get dayUpper => 'Upper body';

  @override
  String get progressUpdateTitle => 'Progress update';

  @override
  String changeUnlocked(String name) {
    return 'Unlocked: $name';
  }

  @override
  String changeGoalUp(String name) {
    return '$name: goal raised';
  }

  @override
  String changeGoalDown(String name) {
    return '$name: goal lowered for now';
  }

  @override
  String changeRegressed(String name) {
    return 'Back to $name for now, to rebuild';
  }

  @override
  String get nodeDone => 'Done';

  @override
  String get nodeCurrent => 'Current';

  @override
  String get nodeLocked => 'Locked';

  @override
  String goalReps(int reps) {
    return 'goal $reps reps on every set';
  }

  @override
  String goalHold(int seconds) {
    return 'goal $seconds s on every set';
  }

  @override
  String unlockedOn(String date) {
    return 'unlocked $date';
  }

  @override
  String get statWorkouts => 'Workouts';

  @override
  String get statWeekStreak => 'Week streak';

  @override
  String get statUnlocks => 'Skills unlocked';

  @override
  String get chartWorkoutsTitle => 'Workouts per week';

  @override
  String get chartSetsTitle => 'Sets per week';

  @override
  String get chartLast8Weeks => 'Last 8 weeks. Tap a bar for its week.';

  @override
  String weekOf(String date) {
    return 'Week of $date';
  }

  @override
  String get strengthTitle => 'Strength gains';

  @override
  String get strengthHint =>
      'Best single set, first session compared with the latest.';

  @override
  String get strengthEmpty =>
      'Train an exercise in two sessions to see its trend.';

  @override
  String bestSetFromTo(int first, int latest, String unit) {
    return '$first → $latest $unit';
  }

  @override
  String sessionsCount(int count) {
    return '$count sessions';
  }

  @override
  String get milestonesTitle => 'Skill milestones';

  @override
  String get milestonesEmpty =>
      'Unlock a harder exercise and it will show up here.';

  @override
  String get vaultTitle => 'Progress photos';

  @override
  String get vaultOpen => 'Open photo vault';

  @override
  String get vaultHint => 'Encrypted, private, never shown in your gallery.';

  @override
  String get vaultEmpty =>
      'No photos yet. Add one with the buttons above. Photos stay encrypted inside the app.';

  @override
  String get vaultNoPin => 'Set a PIN to lock this vault.';

  @override
  String get photoFromCamera => 'Take a photo';

  @override
  String get photoFromGallery => 'Import a photo';

  @override
  String get photoFailed => 'Could not get the photo.';

  @override
  String get photoWeightTitle => 'Weight on this day';

  @override
  String get photoDeleteTitle => 'Delete this photo?';

  @override
  String get photoDeleteBody => 'This cannot be undone.';

  @override
  String get compare => 'Compare';

  @override
  String get compareHint => 'Tap two photos to compare them side by side.';

  @override
  String get before => 'Before';

  @override
  String get after => 'After';

  @override
  String daysApart(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days apart',
      one: '1 day apart',
      zero: 'Same day',
    );
    return '$_temp0';
  }

  @override
  String get settingsSecurity => 'Security';

  @override
  String get setPin => 'Set a PIN';

  @override
  String get changePin => 'Change PIN';

  @override
  String get removePin => 'Remove PIN';

  @override
  String get pinSettingHint =>
      'Locks the photo vault, and the whole app if you choose.';

  @override
  String get lockWholeApp => 'Lock the whole app';

  @override
  String get lockWholeAppHint =>
      'Ask for the PIN every time the app is opened.';

  @override
  String get useBiometrics => 'Unlock with fingerprint or face';

  @override
  String get unlockReason => 'Unlock Solo Calisthenics';

  @override
  String get enterPin => 'Enter your PIN';

  @override
  String get choosePin => 'Choose a PIN';

  @override
  String get confirmPin => 'Enter it again to confirm';

  @override
  String get pinNoRecovery =>
      '4 to 8 digits. There is no way to recover a forgotten PIN.';

  @override
  String get pinWrong => 'Wrong PIN';

  @override
  String get pinMismatch => 'The PINs did not match. Start again.';

  @override
  String pinTooShort(int count) {
    return 'Use at least $count digits';
  }

  @override
  String pinLockedOut(int seconds) {
    return 'Too many attempts. Try again in $seconds s.';
  }

  @override
  String pinDigitsEntered(int count) {
    return '$count digits entered';
  }

  @override
  String get deleteDigit => 'Delete digit';

  @override
  String get forgotPin => 'Forgot PIN?';

  @override
  String get forgotPinBody =>
      'A forgotten PIN cannot be recovered. You can erase all app data, including workouts and photos, and start over.';

  @override
  String get eraseEverything => 'Erase everything';

  @override
  String get backupTitle => 'Backup';

  @override
  String get backupExport => 'Export encrypted backup';

  @override
  String get backupExportHint =>
      'One file with all your data and photos, protected by a passphrase you choose.';

  @override
  String get backupImport => 'Restore from backup';

  @override
  String get backupImportHint =>
      'Replaces everything on this device with a backup file.';

  @override
  String get backupPassphrase => 'Backup passphrase';

  @override
  String get backupPassphraseAgain => 'Passphrase again';

  @override
  String get backupPassphraseHint =>
      'You need this passphrase to restore. It cannot be recovered if you lose it.';

  @override
  String backupPassphraseShort(int count) {
    return 'Use at least $count characters';
  }

  @override
  String get backupPassphraseMismatch => 'The passphrases do not match';

  @override
  String get backupExportFailed => 'The backup could not be created.';

  @override
  String get backupUnreadable =>
      'Could not open the backup. Check the file and the passphrase.';

  @override
  String get backupTooNew =>
      'This backup was made by a newer version of the app. Update the app first.';

  @override
  String get backupImportTitle => 'Replace all data?';

  @override
  String get backupImportBody =>
      'Everything currently in the app will be replaced by the backup. This cannot be undone.';

  @override
  String get backupImportConfirm => 'Replace and restore';
}
