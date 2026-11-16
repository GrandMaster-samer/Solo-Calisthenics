import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_l10n_ar.dart';
import 'app_l10n_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Solo Calisthenics'**
  String get appName;

  /// No description provided for @listSeparator.
  ///
  /// In en, this message translates to:
  /// **', '**
  String get listSeparator;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @finishSetup.
  ///
  /// In en, this message translates to:
  /// **'Finish setup'**
  String get finishSetup;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @invalidValue.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid value'**
  String get invalidValue;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Train with your own body'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'A few questions so the app fits your level and protects your joints. Everything stays on this device, encrypted. No account needed.'**
  String get welcomeBody;

  /// No description provided for @disclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Health disclaimer'**
  String get disclaimerTitle;

  /// No description provided for @disclaimerBody.
  ///
  /// In en, this message translates to:
  /// **'This app does not diagnose or treat injuries. If you have pain or an injury, consult a medical professional before training. Stop any exercise that causes pain.'**
  String get disclaimerBody;

  /// No description provided for @disclaimerAccept.
  ///
  /// In en, this message translates to:
  /// **'I understand'**
  String get disclaimerAccept;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get statsTitle;

  /// No description provided for @statsBody.
  ///
  /// In en, this message translates to:
  /// **'Used to adapt your training. You can change this later in Settings.'**
  String get statsBody;

  /// No description provided for @birthYear.
  ///
  /// In en, this message translates to:
  /// **'Year of birth'**
  String get birthYear;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @feet.
  ///
  /// In en, this message translates to:
  /// **'Feet'**
  String get feet;

  /// No description provided for @inches.
  ///
  /// In en, this message translates to:
  /// **'Inches'**
  String get inches;

  /// No description provided for @unitCm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get unitCm;

  /// No description provided for @unitFtIn.
  ///
  /// In en, this message translates to:
  /// **'ft / in'**
  String get unitFtIn;

  /// No description provided for @unitKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get unitKg;

  /// No description provided for @unitLb.
  ///
  /// In en, this message translates to:
  /// **'lb'**
  String get unitLb;

  /// No description provided for @experienceTitle.
  ///
  /// In en, this message translates to:
  /// **'Training experience'**
  String get experienceTitle;

  /// No description provided for @experienceBody.
  ///
  /// In en, this message translates to:
  /// **'Pick the level that matches your calisthenics training.'**
  String get experienceBody;

  /// No description provided for @expBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get expBeginner;

  /// No description provided for @expIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get expIntermediate;

  /// No description provided for @expAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get expAdvanced;

  /// No description provided for @expBeginnerDesc.
  ///
  /// In en, this message translates to:
  /// **'New to bodyweight training, or returning after a long break.'**
  String get expBeginnerDesc;

  /// No description provided for @expIntermediateDesc.
  ///
  /// In en, this message translates to:
  /// **'Comfortable with push-ups, pull-ups and dips for multiple sets.'**
  String get expIntermediateDesc;

  /// No description provided for @expAdvancedDesc.
  ///
  /// In en, this message translates to:
  /// **'Working on skills such as muscle-ups, levers or handstand push-ups.'**
  String get expAdvancedDesc;

  /// No description provided for @baselineTitle.
  ///
  /// In en, this message translates to:
  /// **'Baseline test (optional)'**
  String get baselineTitle;

  /// No description provided for @baselineBody.
  ///
  /// In en, this message translates to:
  /// **'Your best single effort for each. Leave blank what you have not tested, or skip this step.'**
  String get baselineBody;

  /// No description provided for @maxPushUps.
  ///
  /// In en, this message translates to:
  /// **'Max push-ups'**
  String get maxPushUps;

  /// No description provided for @maxPullUps.
  ///
  /// In en, this message translates to:
  /// **'Max pull-ups'**
  String get maxPullUps;

  /// No description provided for @maxDeadHang.
  ///
  /// In en, this message translates to:
  /// **'Max dead hang'**
  String get maxDeadHang;

  /// No description provided for @maxPlank.
  ///
  /// In en, this message translates to:
  /// **'Max plank'**
  String get maxPlank;

  /// No description provided for @repsUnit.
  ///
  /// In en, this message translates to:
  /// **'reps'**
  String get repsUnit;

  /// No description provided for @secondsUnit.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get secondsUnit;

  /// No description provided for @jointsTitle.
  ///
  /// In en, this message translates to:
  /// **'Joints and injuries'**
  String get jointsTitle;

  /// No description provided for @jointsBody.
  ///
  /// In en, this message translates to:
  /// **'Flag any joint with a past or current limitation. Exercises are filtered and adapted to match.'**
  String get jointsBody;

  /// No description provided for @jointsRules.
  ///
  /// In en, this message translates to:
  /// **'Mild: allowed with a targeted warm-up and fewer sets. Moderate: high-stress exercises are replaced with an easier variation. Severe: medium and high-stress exercises are excluded.'**
  String get jointsRules;

  /// No description provided for @noIssue.
  ///
  /// In en, this message translates to:
  /// **'No issue'**
  String get noIssue;

  /// No description provided for @severityMild.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get severityMild;

  /// No description provided for @severityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get severityModerate;

  /// No description provided for @severitySevere.
  ///
  /// In en, this message translates to:
  /// **'Severe'**
  String get severitySevere;

  /// No description provided for @injuryCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current issue'**
  String get injuryCurrent;

  /// No description provided for @injuryCurrentHint.
  ///
  /// In en, this message translates to:
  /// **'Turn off if this is a past injury you still want to protect.'**
  String get injuryCurrentHint;

  /// No description provided for @jointWrists.
  ///
  /// In en, this message translates to:
  /// **'Wrists'**
  String get jointWrists;

  /// No description provided for @jointShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get jointShoulders;

  /// No description provided for @jointElbows.
  ///
  /// In en, this message translates to:
  /// **'Elbows'**
  String get jointElbows;

  /// No description provided for @jointKnees.
  ///
  /// In en, this message translates to:
  /// **'Knees'**
  String get jointKnees;

  /// No description provided for @jointLowerBack.
  ///
  /// In en, this message translates to:
  /// **'Lower back'**
  String get jointLowerBack;

  /// No description provided for @tabTrain.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get tabTrain;

  /// No description provided for @tabLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get tabLibrary;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @patternPush.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get patternPush;

  /// No description provided for @patternPull.
  ///
  /// In en, this message translates to:
  /// **'Pull'**
  String get patternPull;

  /// No description provided for @patternLegs.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get patternLegs;

  /// No description provided for @patternCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get patternCore;

  /// No description provided for @patternStatics.
  ///
  /// In en, this message translates to:
  /// **'Statics'**
  String get patternStatics;

  /// No description provided for @stressNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get stressNone;

  /// No description provided for @stressLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get stressLow;

  /// No description provided for @stressMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get stressMedium;

  /// No description provided for @stressHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get stressHigh;

  /// No description provided for @targetReps.
  ///
  /// In en, this message translates to:
  /// **'{min}–{max} reps'**
  String targetReps(int min, int max);

  /// No description provided for @targetSeconds.
  ///
  /// In en, this message translates to:
  /// **'{min}–{max} s'**
  String targetSeconds(int min, int max);

  /// No description provided for @restSeconds.
  ///
  /// In en, this message translates to:
  /// **'Rest {seconds} s'**
  String restSeconds(int seconds);

  /// No description provided for @levelInChain.
  ///
  /// In en, this message translates to:
  /// **'Level {level} of {total}'**
  String levelInChain(int level, int total);

  /// No description provided for @notRecommendedFor.
  ///
  /// In en, this message translates to:
  /// **'Not recommended for your {joints}'**
  String notRecommendedFor(String joints);

  /// No description provided for @cautionFor.
  ///
  /// In en, this message translates to:
  /// **'Take care: {joints}'**
  String cautionFor(String joints);

  /// No description provided for @volumeCapped.
  ///
  /// In en, this message translates to:
  /// **'Volume capped at {sets} sets.'**
  String volumeCapped(int sets);

  /// No description provided for @trySubstitute.
  ///
  /// In en, this message translates to:
  /// **'Try instead: {name}'**
  String trySubstitute(String name);

  /// No description provided for @noSubstitute.
  ///
  /// In en, this message translates to:
  /// **'No easier variation in this chain is suitable right now.'**
  String get noSubstitute;

  /// No description provided for @excludedConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Not recommended'**
  String get excludedConfirmTitle;

  /// No description provided for @excludedConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Your injury screening excludes this exercise ({joints}). Add it anyway?'**
  String excludedConfirmBody(String joints);

  /// No description provided for @addAnyway.
  ///
  /// In en, this message translates to:
  /// **'Add anyway'**
  String get addAnyway;

  /// No description provided for @formCues.
  ///
  /// In en, this message translates to:
  /// **'Form cues'**
  String get formCues;

  /// No description provided for @commonMistakes.
  ///
  /// In en, this message translates to:
  /// **'Common mistakes'**
  String get commonMistakes;

  /// No description provided for @jointStress.
  ///
  /// In en, this message translates to:
  /// **'Joint stress'**
  String get jointStress;

  /// No description provided for @progressionPath.
  ///
  /// In en, this message translates to:
  /// **'Progression path'**
  String get progressionPath;

  /// No description provided for @easier.
  ///
  /// In en, this message translates to:
  /// **'Easier (regression)'**
  String get easier;

  /// No description provided for @harder.
  ///
  /// In en, this message translates to:
  /// **'Harder (progression)'**
  String get harder;

  /// No description provided for @noneInChain.
  ///
  /// In en, this message translates to:
  /// **'None: end of the chain'**
  String get noneInChain;

  /// No description provided for @mediaPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'PLACEHOLDER\nVisual guide not added yet'**
  String get mediaPlaceholder;

  /// No description provided for @exerciseMissing.
  ///
  /// In en, this message translates to:
  /// **'Exercise not found'**
  String get exerciseMissing;

  /// No description provided for @trainThis.
  ///
  /// In en, this message translates to:
  /// **'Train this exercise'**
  String get trainThis;

  /// No description provided for @pickExercises.
  ///
  /// In en, this message translates to:
  /// **'Pick exercises'**
  String get pickExercises;

  /// No description provided for @addSelected.
  ///
  /// In en, this message translates to:
  /// **'Add ({count})'**
  String addSelected(int count);

  /// No description provided for @starterWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Starter workouts'**
  String get starterWorkouts;

  /// No description provided for @starterWorkoutsHint.
  ///
  /// In en, this message translates to:
  /// **'Matched to your level and adapted to your joints.'**
  String get starterWorkoutsHint;

  /// No description provided for @templatePush.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get templatePush;

  /// No description provided for @templatePull.
  ///
  /// In en, this message translates to:
  /// **'Pull'**
  String get templatePull;

  /// No description provided for @templateLegsCore.
  ///
  /// In en, this message translates to:
  /// **'Legs and core'**
  String get templateLegsCore;

  /// No description provided for @templateFullBody.
  ///
  /// In en, this message translates to:
  /// **'Full body'**
  String get templateFullBody;

  /// No description provided for @templateEmpty.
  ///
  /// In en, this message translates to:
  /// **'No suitable exercises with your current injury settings.'**
  String get templateEmpty;

  /// No description provided for @buildYourOwn.
  ///
  /// In en, this message translates to:
  /// **'Build your own workout'**
  String get buildYourOwn;

  /// No description provided for @customWorkout.
  ///
  /// In en, this message translates to:
  /// **'Custom workout'**
  String get customWorkout;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'Finished workouts will appear here.'**
  String get historyEmpty;

  /// No description provided for @workoutInProgress.
  ///
  /// In en, this message translates to:
  /// **'Workout in progress'**
  String get workoutInProgress;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @setsLogged.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No sets yet} =1{1 set logged} other{{count} sets logged}}'**
  String setsLogged(num count);

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(int minutes);

  /// No description provided for @setsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 set} other{{count} sets}}'**
  String setsCount(num count);

  /// No description provided for @startWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start workout'**
  String get startWorkout;

  /// No description provided for @addExercises.
  ///
  /// In en, this message translates to:
  /// **'Add exercises'**
  String get addExercises;

  /// No description provided for @replaceWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace current workout?'**
  String get replaceWorkoutTitle;

  /// No description provided for @replaceWorkoutBody.
  ///
  /// In en, this message translates to:
  /// **'You have a workout in progress. Starting a new one discards it.'**
  String get replaceWorkoutBody;

  /// No description provided for @startNew.
  ///
  /// In en, this message translates to:
  /// **'Start new'**
  String get startNew;

  /// No description provided for @warmUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Warm up these joints first'**
  String get warmUpTitle;

  /// No description provided for @warmUpWrists.
  ///
  /// In en, this message translates to:
  /// **'Wrist circles and palm/back-of-hand rocks, 1 minute'**
  String get warmUpWrists;

  /// No description provided for @warmUpShoulders.
  ///
  /// In en, this message translates to:
  /// **'Arm circles, scapular push-ups and band pull-aparts, 2 minutes'**
  String get warmUpShoulders;

  /// No description provided for @warmUpElbows.
  ///
  /// In en, this message translates to:
  /// **'Light elbow bends and forearm rotations, 1 minute'**
  String get warmUpElbows;

  /// No description provided for @warmUpKnees.
  ///
  /// In en, this message translates to:
  /// **'Knee circles, slow half squats and leg swings, 2 minutes'**
  String get warmUpKnees;

  /// No description provided for @warmUpLowerBack.
  ///
  /// In en, this message translates to:
  /// **'Cat-cow, bird-dog and glute bridges, 2 minutes'**
  String get warmUpLowerBack;

  /// No description provided for @setOf.
  ///
  /// In en, this message translates to:
  /// **'Set {current} of {total}'**
  String setOf(int current, int total);

  /// No description provided for @tapToCount.
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere here to count a rep'**
  String get tapToCount;

  /// No description provided for @tapOrVolumeToCount.
  ///
  /// In en, this message translates to:
  /// **'Tap here or press volume up to count a rep'**
  String get tapOrVolumeToCount;

  /// No description provided for @tapToStartHold.
  ///
  /// In en, this message translates to:
  /// **'Tap to start the hold timer'**
  String get tapToStartHold;

  /// No description provided for @tapToStopHold.
  ///
  /// In en, this message translates to:
  /// **'Tap to stop and save'**
  String get tapToStopHold;

  /// No description provided for @minusOne.
  ///
  /// In en, this message translates to:
  /// **'Remove one rep'**
  String get minusOne;

  /// No description provided for @enterReps.
  ///
  /// In en, this message translates to:
  /// **'Enter reps'**
  String get enterReps;

  /// No description provided for @enterSeconds.
  ///
  /// In en, this message translates to:
  /// **'Enter seconds'**
  String get enterSeconds;

  /// No description provided for @doneReps.
  ///
  /// In en, this message translates to:
  /// **'Done · {count} reps'**
  String doneReps(int count);

  /// No description provided for @doneSeconds.
  ///
  /// In en, this message translates to:
  /// **'Done · {count} s'**
  String doneSeconds(int count);

  /// No description provided for @undoLastSet.
  ///
  /// In en, this message translates to:
  /// **'Undo last set'**
  String get undoLastSet;

  /// No description provided for @previousExercise.
  ///
  /// In en, this message translates to:
  /// **'Previous exercise'**
  String get previousExercise;

  /// No description provided for @nextExercise.
  ///
  /// In en, this message translates to:
  /// **'Next exercise'**
  String get nextExercise;

  /// No description provided for @rest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get rest;

  /// No description provided for @skipRest.
  ///
  /// In en, this message translates to:
  /// **'Skip rest'**
  String get skipRest;

  /// No description provided for @minusSeconds.
  ///
  /// In en, this message translates to:
  /// **'−{seconds} s'**
  String minusSeconds(int seconds);

  /// No description provided for @plusSeconds.
  ///
  /// In en, this message translates to:
  /// **'+{seconds} s'**
  String plusSeconds(int seconds);

  /// No description provided for @nextUp.
  ///
  /// In en, this message translates to:
  /// **'Next: {exercise} · {set}'**
  String nextUp(String exercise, String set);

  /// No description provided for @rirQuestion.
  ///
  /// In en, this message translates to:
  /// **'How many more reps could you have done? (RIR)'**
  String get rirQuestion;

  /// No description provided for @rpeQuestion.
  ///
  /// In en, this message translates to:
  /// **'How hard was that set? (RPE)'**
  String get rpeQuestion;

  /// No description provided for @restOverTitle.
  ///
  /// In en, this message translates to:
  /// **'Rest is over'**
  String get restOverTitle;

  /// No description provided for @restOverBody.
  ///
  /// In en, this message translates to:
  /// **'Time for your next set.'**
  String get restOverBody;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @finishWorkout.
  ///
  /// In en, this message translates to:
  /// **'Finish workout'**
  String get finishWorkout;

  /// No description provided for @keepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get keepGoing;

  /// No description provided for @finishEarlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish early?'**
  String get finishEarlyTitle;

  /// No description provided for @finishEarlyBody.
  ///
  /// In en, this message translates to:
  /// **'Some sets are not done yet. What you logged is saved.'**
  String get finishEarlyBody;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard workout'**
  String get discard;

  /// No description provided for @discardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard this workout?'**
  String get discardTitle;

  /// No description provided for @discardBody.
  ///
  /// In en, this message translates to:
  /// **'All sets logged in this workout will be deleted.'**
  String get discardBody;

  /// No description provided for @workoutComplete.
  ///
  /// In en, this message translates to:
  /// **'Workout complete'**
  String get workoutComplete;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get settingsWorkout;

  /// No description provided for @settingsReminders.
  ///
  /// In en, this message translates to:
  /// **'Workout reminders'**
  String get settingsReminders;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile and injuries'**
  String get editProfile;

  /// No description provided for @editProfileHint.
  ///
  /// In en, this message translates to:
  /// **'Stats, experience, baseline test, joint screening'**
  String get editProfileHint;

  /// No description provided for @effortScale.
  ///
  /// In en, this message translates to:
  /// **'Effort scale after each set'**
  String get effortScale;

  /// No description provided for @effortRir.
  ///
  /// In en, this message translates to:
  /// **'RIR (reps in reserve)'**
  String get effortRir;

  /// No description provided for @effortRpe.
  ///
  /// In en, this message translates to:
  /// **'RPE (6–10)'**
  String get effortRpe;

  /// No description provided for @settingSound.
  ///
  /// In en, this message translates to:
  /// **'Sounds'**
  String get settingSound;

  /// No description provided for @settingHaptics.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get settingHaptics;

  /// No description provided for @settingVolumeButtons.
  ///
  /// In en, this message translates to:
  /// **'Count reps with volume buttons'**
  String get settingVolumeButtons;

  /// No description provided for @settingVolumeButtonsHint.
  ///
  /// In en, this message translates to:
  /// **'Volume up adds a rep, volume down removes one.'**
  String get settingVolumeButtonsHint;

  /// No description provided for @weekdaysShort.
  ///
  /// In en, this message translates to:
  /// **'Mon,Tue,Wed,Thu,Fri,Sat,Sun'**
  String get weekdaysShort;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get reminderTime;

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Time to train'**
  String get reminderTitle;

  /// No description provided for @reminderBody.
  ///
  /// In en, this message translates to:
  /// **'Your workout is waiting.'**
  String get reminderBody;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyTitle;

  /// No description provided for @privacyBody.
  ///
  /// In en, this message translates to:
  /// **'All data is stored encrypted on this device. Nothing is sent anywhere.'**
  String get privacyBody;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get licenses;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppL10nAr();
    case 'en':
      return AppL10nEn();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
