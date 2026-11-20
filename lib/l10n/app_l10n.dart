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

  /// No description provided for @tabSkills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get tabSkills;

  /// No description provided for @tabProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get tabProgress;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @planPromoTitle.
  ///
  /// In en, this message translates to:
  /// **'Get your weekly plan'**
  String get planPromoTitle;

  /// No description provided for @planPromoBody.
  ///
  /// In en, this message translates to:
  /// **'Pick your training days and session length. The plan adapts to your level and joints, and progresses as you log.'**
  String get planPromoBody;

  /// No description provided for @planCreate.
  ///
  /// In en, this message translates to:
  /// **'Create my plan'**
  String get planCreate;

  /// No description provided for @planSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly plan'**
  String get planSetupTitle;

  /// No description provided for @planSave.
  ///
  /// In en, this message translates to:
  /// **'Save plan'**
  String get planSave;

  /// No description provided for @planDaysPerWeek.
  ///
  /// In en, this message translates to:
  /// **'Training days per week'**
  String get planDaysPerWeek;

  /// No description provided for @planSessionLength.
  ///
  /// In en, this message translates to:
  /// **'Session length'**
  String get planSessionLength;

  /// No description provided for @planSkills.
  ///
  /// In en, this message translates to:
  /// **'Skills to work on'**
  String get planSkills;

  /// No description provided for @planSkillsHint.
  ///
  /// In en, this message translates to:
  /// **'Optional. Skill work is placed first in the session while you are fresh.'**
  String get planSkillsHint;

  /// No description provided for @planDeload.
  ///
  /// In en, this message translates to:
  /// **'Lighter week'**
  String get planDeload;

  /// No description provided for @planDeloadHint.
  ///
  /// In en, this message translates to:
  /// **'An automatic easier week to recover. It also starts early if your performance drops two sessions in a row.'**
  String get planDeloadHint;

  /// No description provided for @everyWeeks.
  ///
  /// In en, this message translates to:
  /// **'Every {weeks} weeks'**
  String everyWeeks(int weeks);

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @deloadWeek.
  ///
  /// In en, this message translates to:
  /// **'Lighter week'**
  String get deloadWeek;

  /// No description provided for @deloadExplainer.
  ///
  /// In en, this message translates to:
  /// **'Lighter week: fewer sets and easier targets so your body recovers. Progress is not judged this week.'**
  String get deloadExplainer;

  /// No description provided for @todaysWorkout.
  ///
  /// In en, this message translates to:
  /// **'Today\'s workout'**
  String get todaysWorkout;

  /// No description provided for @nextWorkout.
  ///
  /// In en, this message translates to:
  /// **'Next workout'**
  String get nextWorkout;

  /// No description provided for @aboutMinutes.
  ///
  /// In en, this message translates to:
  /// **'About {minutes} min'**
  String aboutMinutes(int minutes);

  /// No description provided for @reviewAndStart.
  ///
  /// In en, this message translates to:
  /// **'Review and start'**
  String get reviewAndStart;

  /// No description provided for @weekComplete.
  ///
  /// In en, this message translates to:
  /// **'All planned workouts done this week'**
  String get weekComplete;

  /// No description provided for @dayDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get dayDone;

  /// No description provided for @dayOpen.
  ///
  /// In en, this message translates to:
  /// **'Not done yet'**
  String get dayOpen;

  /// No description provided for @dayUpper.
  ///
  /// In en, this message translates to:
  /// **'Upper body'**
  String get dayUpper;

  /// No description provided for @progressUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress update'**
  String get progressUpdateTitle;

  /// No description provided for @changeUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked: {name}'**
  String changeUnlocked(String name);

  /// No description provided for @changeGoalUp.
  ///
  /// In en, this message translates to:
  /// **'{name}: goal raised'**
  String changeGoalUp(String name);

  /// No description provided for @changeGoalDown.
  ///
  /// In en, this message translates to:
  /// **'{name}: goal lowered for now'**
  String changeGoalDown(String name);

  /// No description provided for @changeRegressed.
  ///
  /// In en, this message translates to:
  /// **'Back to {name} for now, to rebuild'**
  String changeRegressed(String name);

  /// No description provided for @nodeDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get nodeDone;

  /// No description provided for @nodeCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get nodeCurrent;

  /// No description provided for @nodeLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get nodeLocked;

  /// No description provided for @goalReps.
  ///
  /// In en, this message translates to:
  /// **'goal {reps} reps on every set'**
  String goalReps(int reps);

  /// No description provided for @goalHold.
  ///
  /// In en, this message translates to:
  /// **'goal {seconds} s on every set'**
  String goalHold(int seconds);

  /// No description provided for @unlockedOn.
  ///
  /// In en, this message translates to:
  /// **'unlocked {date}'**
  String unlockedOn(String date);

  /// No description provided for @statWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get statWorkouts;

  /// No description provided for @statWeekStreak.
  ///
  /// In en, this message translates to:
  /// **'Week streak'**
  String get statWeekStreak;

  /// No description provided for @statUnlocks.
  ///
  /// In en, this message translates to:
  /// **'Skills unlocked'**
  String get statUnlocks;

  /// No description provided for @chartWorkoutsTitle.
  ///
  /// In en, this message translates to:
  /// **'Workouts per week'**
  String get chartWorkoutsTitle;

  /// No description provided for @chartSetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sets per week'**
  String get chartSetsTitle;

  /// No description provided for @chartLast8Weeks.
  ///
  /// In en, this message translates to:
  /// **'Last 8 weeks. Tap a bar for its week.'**
  String get chartLast8Weeks;

  /// No description provided for @weekOf.
  ///
  /// In en, this message translates to:
  /// **'Week of {date}'**
  String weekOf(String date);

  /// No description provided for @strengthTitle.
  ///
  /// In en, this message translates to:
  /// **'Strength gains'**
  String get strengthTitle;

  /// No description provided for @strengthHint.
  ///
  /// In en, this message translates to:
  /// **'Best single set, first session compared with the latest.'**
  String get strengthHint;

  /// No description provided for @strengthEmpty.
  ///
  /// In en, this message translates to:
  /// **'Train an exercise in two sessions to see its trend.'**
  String get strengthEmpty;

  /// No description provided for @bestSetFromTo.
  ///
  /// In en, this message translates to:
  /// **'{first} → {latest} {unit}'**
  String bestSetFromTo(int first, int latest, String unit);

  /// No description provided for @sessionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions'**
  String sessionsCount(int count);

  /// No description provided for @milestonesTitle.
  ///
  /// In en, this message translates to:
  /// **'Skill milestones'**
  String get milestonesTitle;

  /// No description provided for @milestonesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Unlock a harder exercise and it will show up here.'**
  String get milestonesEmpty;

  /// No description provided for @vaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress photos'**
  String get vaultTitle;

  /// No description provided for @vaultOpen.
  ///
  /// In en, this message translates to:
  /// **'Open photo vault'**
  String get vaultOpen;

  /// No description provided for @vaultHint.
  ///
  /// In en, this message translates to:
  /// **'Encrypted, private, never shown in your gallery.'**
  String get vaultHint;

  /// No description provided for @vaultEmpty.
  ///
  /// In en, this message translates to:
  /// **'No photos yet. Add one with the buttons above. Photos stay encrypted inside the app.'**
  String get vaultEmpty;

  /// No description provided for @vaultNoPin.
  ///
  /// In en, this message translates to:
  /// **'Set a PIN to lock this vault.'**
  String get vaultNoPin;

  /// No description provided for @photoFromCamera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get photoFromCamera;

  /// No description provided for @photoFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Import a photo'**
  String get photoFromGallery;

  /// No description provided for @photoFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not get the photo.'**
  String get photoFailed;

  /// No description provided for @photoWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Weight on this day'**
  String get photoWeightTitle;

  /// No description provided for @photoDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this photo?'**
  String get photoDeleteTitle;

  /// No description provided for @photoDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get photoDeleteBody;

  /// No description provided for @compare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get compare;

  /// No description provided for @compareHint.
  ///
  /// In en, this message translates to:
  /// **'Tap two photos to compare them side by side.'**
  String get compareHint;

  /// No description provided for @before.
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get before;

  /// No description provided for @after.
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get after;

  /// No description provided for @daysApart.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Same day} =1{1 day apart} other{{days} days apart}}'**
  String daysApart(num days);

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurity;

  /// No description provided for @setPin.
  ///
  /// In en, this message translates to:
  /// **'Set a PIN'**
  String get setPin;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @removePin.
  ///
  /// In en, this message translates to:
  /// **'Remove PIN'**
  String get removePin;

  /// No description provided for @pinSettingHint.
  ///
  /// In en, this message translates to:
  /// **'Locks the photo vault, and the whole app if you choose.'**
  String get pinSettingHint;

  /// No description provided for @lockWholeApp.
  ///
  /// In en, this message translates to:
  /// **'Lock the whole app'**
  String get lockWholeApp;

  /// No description provided for @lockWholeAppHint.
  ///
  /// In en, this message translates to:
  /// **'Ask for the PIN every time the app is opened.'**
  String get lockWholeAppHint;

  /// No description provided for @useBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Unlock with fingerprint or face'**
  String get useBiometrics;

  /// No description provided for @unlockReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock Solo Calisthenics'**
  String get unlockReason;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get enterPin;

  /// No description provided for @choosePin.
  ///
  /// In en, this message translates to:
  /// **'Choose a PIN'**
  String get choosePin;

  /// No description provided for @confirmPin.
  ///
  /// In en, this message translates to:
  /// **'Enter it again to confirm'**
  String get confirmPin;

  /// No description provided for @pinNoRecovery.
  ///
  /// In en, this message translates to:
  /// **'4 to 8 digits. There is no way to recover a forgotten PIN.'**
  String get pinNoRecovery;

  /// No description provided for @pinWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN'**
  String get pinWrong;

  /// No description provided for @pinMismatch.
  ///
  /// In en, this message translates to:
  /// **'The PINs did not match. Start again.'**
  String get pinMismatch;

  /// No description provided for @pinTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least {count} digits'**
  String pinTooShort(int count);

  /// No description provided for @pinLockedOut.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in {seconds} s.'**
  String pinLockedOut(int seconds);

  /// No description provided for @pinDigitsEntered.
  ///
  /// In en, this message translates to:
  /// **'{count} digits entered'**
  String pinDigitsEntered(int count);

  /// No description provided for @deleteDigit.
  ///
  /// In en, this message translates to:
  /// **'Delete digit'**
  String get deleteDigit;

  /// No description provided for @forgotPin.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN?'**
  String get forgotPin;

  /// No description provided for @forgotPinBody.
  ///
  /// In en, this message translates to:
  /// **'A forgotten PIN cannot be recovered. You can erase all app data, including workouts and photos, and start over.'**
  String get forgotPinBody;

  /// No description provided for @eraseEverything.
  ///
  /// In en, this message translates to:
  /// **'Erase everything'**
  String get eraseEverything;

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backupTitle;

  /// No description provided for @backupExport.
  ///
  /// In en, this message translates to:
  /// **'Export encrypted backup'**
  String get backupExport;

  /// No description provided for @backupExportHint.
  ///
  /// In en, this message translates to:
  /// **'One file with all your data and photos, protected by a passphrase you choose.'**
  String get backupExportHint;

  /// No description provided for @backupImport.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get backupImport;

  /// No description provided for @backupImportHint.
  ///
  /// In en, this message translates to:
  /// **'Replaces everything on this device with a backup file.'**
  String get backupImportHint;

  /// No description provided for @backupPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Backup passphrase'**
  String get backupPassphrase;

  /// No description provided for @backupPassphraseAgain.
  ///
  /// In en, this message translates to:
  /// **'Passphrase again'**
  String get backupPassphraseAgain;

  /// No description provided for @backupPassphraseHint.
  ///
  /// In en, this message translates to:
  /// **'You need this passphrase to restore. It cannot be recovered if you lose it.'**
  String get backupPassphraseHint;

  /// No description provided for @backupPassphraseShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least {count} characters'**
  String backupPassphraseShort(int count);

  /// No description provided for @backupPassphraseMismatch.
  ///
  /// In en, this message translates to:
  /// **'The passphrases do not match'**
  String get backupPassphraseMismatch;

  /// No description provided for @backupExportFailed.
  ///
  /// In en, this message translates to:
  /// **'The backup could not be created.'**
  String get backupExportFailed;

  /// No description provided for @backupUnreadable.
  ///
  /// In en, this message translates to:
  /// **'Could not open the backup. Check the file and the passphrase.'**
  String get backupUnreadable;

  /// No description provided for @backupTooNew.
  ///
  /// In en, this message translates to:
  /// **'This backup was made by a newer version of the app. Update the app first.'**
  String get backupTooNew;

  /// No description provided for @backupImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace all data?'**
  String get backupImportTitle;

  /// No description provided for @backupImportBody.
  ///
  /// In en, this message translates to:
  /// **'Everything currently in the app will be replaced by the backup. This cannot be undone.'**
  String get backupImportBody;

  /// No description provided for @backupImportConfirm.
  ///
  /// In en, this message translates to:
  /// **'Replace and restore'**
  String get backupImportConfirm;

  /// No description provided for @cloudTitle.
  ///
  /// In en, this message translates to:
  /// **'Account and cloud (optional)'**
  String get cloudTitle;

  /// No description provided for @cloudOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'The app works fully without an account. Sign in only if you want cloud backup or coach review.'**
  String get cloudOptionalHint;

  /// No description provided for @signInGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInGoogle;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get signedIn;

  /// No description provided for @roleCoach.
  ///
  /// In en, this message translates to:
  /// **'Signed in as coach'**
  String get roleCoach;

  /// No description provided for @cloudFailed.
  ///
  /// In en, this message translates to:
  /// **'That did not work. Check your connection and try again.'**
  String get cloudFailed;

  /// No description provided for @cloudBackupNow.
  ///
  /// In en, this message translates to:
  /// **'Back up to the cloud'**
  String get cloudBackupNow;

  /// No description provided for @cloudBackupNone.
  ///
  /// In en, this message translates to:
  /// **'No cloud backup yet. Encrypted on this device before upload.'**
  String get cloudBackupNone;

  /// No description provided for @cloudBackupLast.
  ///
  /// In en, this message translates to:
  /// **'Last cloud backup: {date}'**
  String cloudBackupLast(String date);

  /// No description provided for @cloudBackupDone.
  ///
  /// In en, this message translates to:
  /// **'Encrypted backup uploaded.'**
  String get cloudBackupDone;

  /// No description provided for @cloudBackupTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The backup is larger than {mb} MB. Remove some photos or use the file export instead.'**
  String cloudBackupTooLarge(int mb);

  /// No description provided for @cloudRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore from the cloud'**
  String get cloudRestore;

  /// No description provided for @cloudDeleteData.
  ///
  /// In en, this message translates to:
  /// **'Delete my cloud data'**
  String get cloudDeleteData;

  /// No description provided for @cloudDeleteDataHint.
  ///
  /// In en, this message translates to:
  /// **'Removes your cloud backup, clips and feedback from the server.'**
  String get cloudDeleteDataHint;

  /// No description provided for @cloudDeleteDataBody.
  ///
  /// In en, this message translates to:
  /// **'Your cloud backup, review clips and feedback will be deleted from the server. Data on this device is not affected.'**
  String get cloudDeleteDataBody;

  /// No description provided for @coachReview.
  ///
  /// In en, this message translates to:
  /// **'Coach review'**
  String get coachReview;

  /// No description provided for @coachOpen.
  ///
  /// In en, this message translates to:
  /// **'Send a clip to the coach'**
  String get coachOpen;

  /// No description provided for @coachHint.
  ///
  /// In en, this message translates to:
  /// **'Get technique corrections on a short video of your movement.'**
  String get coachHint;

  /// No description provided for @coachSignInNeeded.
  ///
  /// In en, this message translates to:
  /// **'Coach review needs an account, so your clips and feedback reach the right person.'**
  String get coachSignInNeeded;

  /// No description provided for @clipNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New clip'**
  String get clipNewTitle;

  /// No description provided for @clipRules.
  ///
  /// In en, this message translates to:
  /// **'Up to {seconds} seconds. Compressed on your phone, sent without sound, and deleted after review or after {days} days.'**
  String clipRules(int seconds, int days);

  /// No description provided for @clipChooseExercise.
  ///
  /// In en, this message translates to:
  /// **'Choose the exercise'**
  String get clipChooseExercise;

  /// No description provided for @clipRecord.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get clipRecord;

  /// No description provided for @clipChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose video'**
  String get clipChoose;

  /// No description provided for @clipReady.
  ///
  /// In en, this message translates to:
  /// **'Clip ready to send'**
  String get clipReady;

  /// No description provided for @clipNote.
  ///
  /// In en, this message translates to:
  /// **'Note for the coach'**
  String get clipNote;

  /// No description provided for @clipSend.
  ///
  /// In en, this message translates to:
  /// **'Send for review'**
  String get clipSend;

  /// No description provided for @clipSent.
  ///
  /// In en, this message translates to:
  /// **'Clip sent. Feedback will appear below.'**
  String get clipSent;

  /// No description provided for @clipTooLong.
  ///
  /// In en, this message translates to:
  /// **'The clip must be {seconds} seconds or shorter.'**
  String clipTooLong(int seconds);

  /// No description provided for @clipFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not prepare the clip.'**
  String get clipFailed;

  /// No description provided for @clipUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This clip is no longer available.'**
  String get clipUnavailable;

  /// No description provided for @clipPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get clipPlay;

  /// No description provided for @feedbackInbox.
  ///
  /// In en, this message translates to:
  /// **'Your feedback'**
  String get feedbackInbox;

  /// No description provided for @feedbackEmpty.
  ///
  /// In en, this message translates to:
  /// **'Clips you send and the coach\'s feedback will appear here.'**
  String get feedbackEmpty;

  /// No description provided for @statusWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get statusWaiting;

  /// No description provided for @statusReviewed.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get statusReviewed;

  /// No description provided for @coachSays.
  ///
  /// In en, this message translates to:
  /// **'Coach feedback'**
  String get coachSays;

  /// No description provided for @coachInbox.
  ///
  /// In en, this message translates to:
  /// **'Coach inbox'**
  String get coachInbox;

  /// No description provided for @coachInboxWaiting.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing waiting} =1{1 clip waiting} other{{count} clips waiting}}'**
  String coachInboxWaiting(num count);

  /// No description provided for @coachInboxEmpty.
  ///
  /// In en, this message translates to:
  /// **'No clips waiting for review.'**
  String get coachInboxEmpty;

  /// No description provided for @feedbackWrite.
  ///
  /// In en, this message translates to:
  /// **'Technique feedback'**
  String get feedbackWrite;

  /// No description provided for @feedbackSend.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get feedbackSend;

  /// No description provided for @feedbackDeletesClip.
  ///
  /// In en, this message translates to:
  /// **'Sending the feedback deletes the clip from the server.'**
  String get feedbackDeletesClip;

  /// No description provided for @illustrationOf.
  ///
  /// In en, this message translates to:
  /// **'Drawing of {name}'**
  String illustrationOf(String name);
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
