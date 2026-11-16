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
}
