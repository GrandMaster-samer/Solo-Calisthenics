// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_l10n.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppL10nAr extends AppL10n {
  AppL10nAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'سولو كاليسثنكس';

  @override
  String get listSeparator => '، ';

  @override
  String get ok => 'حسناً';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get skip => 'تخطٍّ';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get finishSetup => 'إنهاء الإعداد';

  @override
  String get remove => 'إزالة';

  @override
  String get dismiss => 'إخفاء';

  @override
  String get invalidValue => 'أدخل قيمة صحيحة';

  @override
  String get language => 'اللغة';

  @override
  String get languageSystem => 'لغة النظام';

  @override
  String get welcomeTitle => 'تمرّن بوزن جسمك';

  @override
  String get welcomeBody =>
      'بضعة أسئلة ليناسب التطبيق مستواك ويحمي مفاصلك. كل بياناتك تبقى على هذا الجهاز مشفّرة، ولا حاجة إلى حساب.';

  @override
  String get disclaimerTitle => 'تنبيه صحي';

  @override
  String get disclaimerBody =>
      'هذا التطبيق لا يشخّص الإصابات ولا يعالجها. إذا كنت تشعر بألم أو لديك إصابة فاستشر مختصاً طبياً قبل التمرين، وتوقف عن أي تمرين يسبب لك الألم.';

  @override
  String get disclaimerAccept => 'أفهم ذلك';

  @override
  String get statsTitle => 'عن نفسك';

  @override
  String get statsBody =>
      'تُستخدم لتكييف تمرينك. يمكنك تعديلها لاحقاً من الإعدادات.';

  @override
  String get birthYear => 'سنة الميلاد';

  @override
  String get height => 'الطول';

  @override
  String get weight => 'الوزن';

  @override
  String get feet => 'قدم';

  @override
  String get inches => 'بوصة';

  @override
  String get unitCm => 'سم';

  @override
  String get unitFtIn => 'قدم / بوصة';

  @override
  String get unitKg => 'كغ';

  @override
  String get unitLb => 'رطل';

  @override
  String get experienceTitle => 'خبرتك في التمرين';

  @override
  String get experienceBody => 'اختر المستوى الأقرب لخبرتك في الكاليسثنكس.';

  @override
  String get expBeginner => 'مبتدئ';

  @override
  String get expIntermediate => 'متوسط';

  @override
  String get expAdvanced => 'متقدم';

  @override
  String get expBeginnerDesc =>
      'جديد على تمارين وزن الجسم أو عائد بعد انقطاع طويل.';

  @override
  String get expIntermediateDesc =>
      'تؤدي الضغط والعقلة والمتوازي بعدة مجموعات بارتياح.';

  @override
  String get expAdvancedDesc =>
      'تعمل على مهارات مثل الماسل أب والرافعات وضغط الوقوف على اليدين.';

  @override
  String get baselineTitle => 'اختبار المستوى (اختياري)';

  @override
  String get baselineBody =>
      'أفضل محاولة واحدة لكل تمرين. اترك ما لم تختبره فارغاً أو تخطَّ هذه الخطوة.';

  @override
  String get maxPushUps => 'أقصى عدد ضغط';

  @override
  String get maxPullUps => 'أقصى عدد عقلة';

  @override
  String get maxDeadHang => 'أطول تعلق حر';

  @override
  String get maxPlank => 'أطول بلانك';

  @override
  String get repsUnit => 'عدّة';

  @override
  String get secondsUnit => 'ث';

  @override
  String get jointsTitle => 'المفاصل والإصابات';

  @override
  String get jointsBody =>
      'حدّد أي مفصل لديك فيه مشكلة سابقة أو حالية، وسيجري تكييف التمارين وفقاً لذلك.';

  @override
  String get jointsRules =>
      'خفيفة: يُسمح بالتمرين مع إحماء موجّه ومجموعات أقل. متوسطة: تُستبدل التمارين عالية الإجهاد بنسخة أسهل. شديدة: تُستبعد التمارين متوسطة وعالية الإجهاد.';

  @override
  String get noIssue => 'لا مشكلة';

  @override
  String get severityMild => 'خفيفة';

  @override
  String get severityModerate => 'متوسطة';

  @override
  String get severitySevere => 'شديدة';

  @override
  String get injuryCurrent => 'مشكلة حالية';

  @override
  String get injuryCurrentHint =>
      'أوقفه إن كانت إصابة سابقة ما زلت تريد حمايتها.';

  @override
  String get jointWrists => 'الرسغان';

  @override
  String get jointShoulders => 'الكتفان';

  @override
  String get jointElbows => 'المرفقان';

  @override
  String get jointKnees => 'الركبتان';

  @override
  String get jointLowerBack => 'أسفل الظهر';

  @override
  String get tabTrain => 'التمرين';

  @override
  String get tabLibrary => 'المكتبة';

  @override
  String get tabSettings => 'الإعدادات';

  @override
  String get patternPush => 'دفع';

  @override
  String get patternPull => 'سحب';

  @override
  String get patternLegs => 'أرجل';

  @override
  String get patternCore => 'الجذع';

  @override
  String get patternStatics => 'الثبات والتوازن';

  @override
  String get stressNone => 'لا يوجد';

  @override
  String get stressLow => 'منخفض';

  @override
  String get stressMedium => 'متوسط';

  @override
  String get stressHigh => 'مرتفع';

  @override
  String targetReps(int min, int max) {
    return '$min–$max عدّة';
  }

  @override
  String targetSeconds(int min, int max) {
    return '$min–$max ث';
  }

  @override
  String restSeconds(int seconds) {
    return 'راحة $seconds ث';
  }

  @override
  String levelInChain(int level, int total) {
    return 'المستوى $level من $total';
  }

  @override
  String notRecommendedFor(String joints) {
    return 'غير موصى به بسبب: $joints';
  }

  @override
  String cautionFor(String joints) {
    return 'انتبه: $joints';
  }

  @override
  String volumeCapped(int sets) {
    return 'الحد الأقصى للمجموعات: $sets.';
  }

  @override
  String trySubstitute(String name) {
    return 'جرّب بدلاً منه: $name';
  }

  @override
  String get noSubstitute => 'لا توجد نسخة أسهل مناسبة في هذه السلسلة حالياً.';

  @override
  String get excludedConfirmTitle => 'غير موصى به';

  @override
  String excludedConfirmBody(String joints) {
    return 'فحص الإصابات يستبعد هذا التمرين ($joints). هل تريد إضافته على أي حال؟';
  }

  @override
  String get addAnyway => 'أضفه على أي حال';

  @override
  String get formCues => 'نقاط الأداء الصحيح';

  @override
  String get commonMistakes => 'أخطاء شائعة';

  @override
  String get jointStress => 'إجهاد المفاصل';

  @override
  String get progressionPath => 'مسار التدرّج';

  @override
  String get easier => 'أسهل (تراجع)';

  @override
  String get harder => 'أصعب (تقدّم)';

  @override
  String get noneInChain => 'لا يوجد: نهاية السلسلة';

  @override
  String get mediaPlaceholder => 'عنصر مؤقت\nلم يُضف الدليل المرئي بعد';

  @override
  String get exerciseMissing => 'التمرين غير موجود';

  @override
  String get trainThis => 'تمرّن على هذا التمرين';

  @override
  String get pickExercises => 'اختر التمارين';

  @override
  String addSelected(int count) {
    return 'إضافة ($count)';
  }

  @override
  String get starterWorkouts => 'تمارين جاهزة';

  @override
  String get starterWorkoutsHint => 'مناسبة لمستواك ومكيّفة مع مفاصلك.';

  @override
  String get templatePush => 'يوم الدفع';

  @override
  String get templatePull => 'يوم السحب';

  @override
  String get templateLegsCore => 'الأرجل والجذع';

  @override
  String get templateFullBody => 'الجسم كاملاً';

  @override
  String get templateEmpty =>
      'لا توجد تمارين مناسبة وفق إعدادات الإصابات الحالية.';

  @override
  String get buildYourOwn => 'أنشئ تمرينك الخاص';

  @override
  String get customWorkout => 'تمرين مخصص';

  @override
  String get history => 'السجل';

  @override
  String get historyEmpty => 'ستظهر التمارين المكتملة هنا.';

  @override
  String get workoutInProgress => 'تمرين جارٍ';

  @override
  String get resume => 'متابعة التمرين';

  @override
  String setsLogged(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'المجموعات المسجّلة: $count',
      zero: 'لا مجموعات بعد',
    );
    return '$_temp0';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes د';
  }

  @override
  String setsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'المجموعات: $count',
    );
    return '$_temp0';
  }

  @override
  String get startWorkout => 'ابدأ التمرين';

  @override
  String get addExercises => 'إضافة تمارين';

  @override
  String get replaceWorkoutTitle => 'استبدال التمرين الحالي؟';

  @override
  String get replaceWorkoutBody => 'لديك تمرين جارٍ. بدء تمرين جديد سيحذفه.';

  @override
  String get startNew => 'ابدأ جديداً';

  @override
  String get warmUpTitle => 'أحمِ هذه المفاصل أولاً';

  @override
  String get warmUpWrists =>
      'تدوير الرسغين والتأرجح على الكفين وظهر اليدين، دقيقة واحدة';

  @override
  String get warmUpShoulders =>
      'تدوير الذراعين وضغط لوحي الكتف وسحب المطاط، دقيقتان';

  @override
  String get warmUpElbows => 'ثني خفيف للمرفقين وتدوير الساعدين، دقيقة واحدة';

  @override
  String get warmUpKnees =>
      'تدوير الركبتين ونصف قرفصاء بطيئة وأرجحة الساقين، دقيقتان';

  @override
  String get warmUpLowerBack =>
      'تمرين القطة والبقرة وتمرين الطائر والكلب وجسر المؤخرة، دقيقتان';

  @override
  String setOf(int current, int total) {
    return 'المجموعة $current من $total';
  }

  @override
  String get tapToCount => 'اضغط في أي مكان هنا لعدّ تكرار';

  @override
  String get tapOrVolumeToCount => 'اضغط هنا أو على زر رفع الصوت لعدّ تكرار';

  @override
  String get tapToStartHold => 'اضغط لبدء مؤقت الثبات';

  @override
  String get tapToStopHold => 'اضغط للإيقاف والحفظ';

  @override
  String get minusOne => 'إنقاص تكرار';

  @override
  String get enterReps => 'أدخل عدد التكرارات';

  @override
  String get enterSeconds => 'أدخل عدد الثواني';

  @override
  String doneReps(int count) {
    return 'تم · $count عدّة';
  }

  @override
  String doneSeconds(int count) {
    return 'تم · $count ث';
  }

  @override
  String get undoLastSet => 'تراجع عن آخر مجموعة';

  @override
  String get previousExercise => 'التمرين السابق';

  @override
  String get nextExercise => 'التمرين التالي';

  @override
  String get rest => 'راحة';

  @override
  String get skipRest => 'تخطي الراحة';

  @override
  String minusSeconds(int seconds) {
    return '‎−$seconds ث';
  }

  @override
  String plusSeconds(int seconds) {
    return '‎+$seconds ث';
  }

  @override
  String nextUp(String exercise, String set) {
    return 'التالي: $exercise · $set';
  }

  @override
  String get rirQuestion => 'كم تكراراً إضافياً كان بإمكانك؟ (RIR)';

  @override
  String get rpeQuestion => 'ما مدى صعوبة المجموعة؟ (RPE)';

  @override
  String get restOverTitle => 'انتهت الراحة';

  @override
  String get restOverBody => 'حان وقت المجموعة التالية.';

  @override
  String get finish => 'إنهاء';

  @override
  String get finishWorkout => 'إنهاء التمرين';

  @override
  String get keepGoing => 'متابعة';

  @override
  String get finishEarlyTitle => 'إنهاء مبكر؟';

  @override
  String get finishEarlyBody => 'بعض المجموعات لم تكتمل بعد. ما سجّلته سيُحفظ.';

  @override
  String get discard => 'حذف التمرين';

  @override
  String get discardTitle => 'حذف هذا التمرين؟';

  @override
  String get discardBody => 'ستُحذف جميع المجموعات المسجّلة في هذا التمرين.';

  @override
  String get workoutComplete => 'اكتمل التمرين';

  @override
  String get settingsGeneral => 'عام';

  @override
  String get settingsWorkout => 'التمرين';

  @override
  String get settingsReminders => 'تذكيرات التمرين';

  @override
  String get settingsAbout => 'حول';

  @override
  String get editProfile => 'الملف الشخصي والإصابات';

  @override
  String get editProfileHint => 'القياسات والخبرة واختبار المستوى وفحص المفاصل';

  @override
  String get effortScale => 'مقياس الجهد بعد كل مجموعة';

  @override
  String get effortRir => 'RIR (تكرارات احتياطية)';

  @override
  String get effortRpe => 'RPE (6–10)';

  @override
  String get settingSound => 'الأصوات';

  @override
  String get settingHaptics => 'الاهتزاز';

  @override
  String get settingVolumeButtons => 'عدّ التكرارات بأزرار الصوت';

  @override
  String get settingVolumeButtonsHint =>
      'زر رفع الصوت يضيف تكراراً وزر الخفض ينقص واحداً.';

  @override
  String get weekdaysShort =>
      'الاثنين,الثلاثاء,الأربعاء,الخميس,الجمعة,السبت,الأحد';

  @override
  String get reminderTime => 'وقت التذكير';

  @override
  String get reminderTitle => 'حان وقت التمرين';

  @override
  String get reminderBody => 'تمرينك في انتظارك.';

  @override
  String get privacyTitle => 'الخصوصية';

  @override
  String get privacyBody =>
      'جميع البيانات مخزّنة مشفّرة على هذا الجهاز ولا يُرسل أي شيء إلى أي مكان.';

  @override
  String get licenses => 'تراخيص المصادر المفتوحة';

  @override
  String get tabSkills => 'المهارات';

  @override
  String get tabProgress => 'التقدّم';

  @override
  String get optional => 'اختياري';

  @override
  String get delete => 'حذف';

  @override
  String get planPromoTitle => 'احصل على خطتك الأسبوعية';

  @override
  String get planPromoBody =>
      'اختر أيام التمرين ومدة الحصة. تتكيّف الخطة مع مستواك ومفاصلك وتتقدّم كلما سجّلت تمارينك.';

  @override
  String get planCreate => 'أنشئ خطتي';

  @override
  String get planSetupTitle => 'الخطة الأسبوعية';

  @override
  String get planSave => 'حفظ الخطة';

  @override
  String get planDaysPerWeek => 'أيام التمرين في الأسبوع';

  @override
  String get planSessionLength => 'مدة الحصة';

  @override
  String get planSkills => 'المهارات التي تريد العمل عليها';

  @override
  String get planSkillsHint =>
      'اختياري. يوضع تمرين المهارة في بداية الحصة وأنت بكامل نشاطك.';

  @override
  String get planDeload => 'أسبوع التخفيف';

  @override
  String get planDeloadHint =>
      'أسبوع أخف تلقائي للتعافي. يبدأ مبكراً أيضاً إذا انخفض أداؤك في حصتين متتاليتين.';

  @override
  String everyWeeks(int weeks) {
    return 'كل $weeks أسابيع';
  }

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get deloadWeek => 'أسبوع تخفيف';

  @override
  String get deloadExplainer =>
      'أسبوع تخفيف: مجموعات أقل وأهداف أسهل ليتعافى جسمك. لا يُقيَّم التقدّم هذا الأسبوع.';

  @override
  String get todaysWorkout => 'تمرين اليوم';

  @override
  String get nextWorkout => 'التمرين القادم';

  @override
  String aboutMinutes(int minutes) {
    return 'نحو $minutes د';
  }

  @override
  String get reviewAndStart => 'راجع وابدأ';

  @override
  String get weekComplete => 'أنجزت كل تمارين هذا الأسبوع';

  @override
  String get dayDone => 'تم';

  @override
  String get dayOpen => 'لم يُنجز بعد';

  @override
  String get dayUpper => 'الجزء العلوي';

  @override
  String get progressUpdateTitle => 'تحديث التقدّم';

  @override
  String changeUnlocked(String name) {
    return 'فُتح تمرين جديد: $name';
  }

  @override
  String changeGoalUp(String name) {
    return '$name: رُفع الهدف';
  }

  @override
  String changeGoalDown(String name) {
    return '$name: خُفّض الهدف مؤقتاً';
  }

  @override
  String changeRegressed(String name) {
    return 'العودة مؤقتاً إلى $name لإعادة البناء';
  }

  @override
  String get nodeDone => 'مُنجز';

  @override
  String get nodeCurrent => 'الحالي';

  @override
  String get nodeLocked => 'مقفل';

  @override
  String goalReps(int reps) {
    return 'الهدف $reps عدّة في كل مجموعة';
  }

  @override
  String goalHold(int seconds) {
    return 'الهدف $seconds ث في كل مجموعة';
  }

  @override
  String unlockedOn(String date) {
    return 'فُتح في $date';
  }

  @override
  String get statWorkouts => 'التمارين';

  @override
  String get statWeekStreak => 'أسابيع متتالية';

  @override
  String get statUnlocks => 'مهارات مفتوحة';

  @override
  String get chartWorkoutsTitle => 'التمارين في الأسبوع';

  @override
  String get chartSetsTitle => 'المجموعات في الأسبوع';

  @override
  String get chartLast8Weeks => 'آخر 8 أسابيع. اضغط على عمود لمعرفة أسبوعه.';

  @override
  String weekOf(String date) {
    return 'أسبوع $date';
  }

  @override
  String get strengthTitle => 'تطوّر القوة';

  @override
  String get strengthHint => 'أفضل مجموعة واحدة: أول حصة مقارنةً بآخر حصة.';

  @override
  String get strengthEmpty => 'تمرّن على تمرين في حصتين لترى تطوّره.';

  @override
  String bestSetFromTo(int first, int latest, String unit) {
    return '$first ← $latest $unit';
  }

  @override
  String sessionsCount(int count) {
    return 'عدد الحصص: $count';
  }

  @override
  String get milestonesTitle => 'إنجازات المهارات';

  @override
  String get milestonesEmpty => 'افتح تمريناً أصعب وسيظهر هنا.';

  @override
  String get vaultTitle => 'صور التقدّم';

  @override
  String get vaultOpen => 'افتح خزنة الصور';

  @override
  String get vaultHint => 'مشفّرة وخاصة ولا تظهر في معرض الصور.';

  @override
  String get vaultEmpty =>
      'لا توجد صور بعد. أضف صورة من الأزرار في الأعلى. تبقى الصور مشفّرة داخل التطبيق.';

  @override
  String get vaultNoPin => 'عيّن رمز PIN لقفل هذه الخزنة.';

  @override
  String get photoFromCamera => 'التقط صورة';

  @override
  String get photoFromGallery => 'استورد صورة';

  @override
  String get photoFailed => 'تعذّر الحصول على الصورة.';

  @override
  String get photoWeightTitle => 'الوزن في هذا اليوم';

  @override
  String get photoDeleteTitle => 'حذف هذه الصورة؟';

  @override
  String get photoDeleteBody => 'لا يمكن التراجع عن ذلك.';

  @override
  String get compare => 'مقارنة';

  @override
  String get compareHint => 'اضغط على صورتين لمقارنتهما جنباً إلى جنب.';

  @override
  String get before => 'قبل';

  @override
  String get after => 'بعد';

  @override
  String daysApart(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'الفارق بالأيام: $days',
      zero: 'في اليوم نفسه',
    );
    return '$_temp0';
  }

  @override
  String get settingsSecurity => 'الأمان';

  @override
  String get setPin => 'تعيين رمز PIN';

  @override
  String get changePin => 'تغيير رمز PIN';

  @override
  String get removePin => 'إزالة رمز PIN';

  @override
  String get pinSettingHint => 'يقفل خزنة الصور، والتطبيق كاملاً إن اخترت ذلك.';

  @override
  String get lockWholeApp => 'قفل التطبيق كاملاً';

  @override
  String get lockWholeAppHint => 'طلب رمز PIN عند كل فتح للتطبيق.';

  @override
  String get useBiometrics => 'الفتح بالبصمة أو الوجه';

  @override
  String get unlockReason => 'افتح سولو كاليسثنكس';

  @override
  String get enterPin => 'أدخل رمز PIN';

  @override
  String get choosePin => 'اختر رمز PIN';

  @override
  String get confirmPin => 'أدخله مرة أخرى للتأكيد';

  @override
  String get pinNoRecovery =>
      'من 4 إلى 8 أرقام. لا توجد طريقة لاستعادة رمز منسي.';

  @override
  String get pinWrong => 'رمز PIN غير صحيح';

  @override
  String get pinMismatch => 'الرمزان غير متطابقين. ابدأ من جديد.';

  @override
  String pinTooShort(int count) {
    return 'استخدم $count أرقام على الأقل';
  }

  @override
  String pinLockedOut(int seconds) {
    return 'محاولات كثيرة. حاول بعد $seconds ث.';
  }

  @override
  String pinDigitsEntered(int count) {
    return 'الأرقام المدخلة: $count';
  }

  @override
  String get deleteDigit => 'حذف رقم';

  @override
  String get forgotPin => 'نسيت رمز PIN؟';

  @override
  String get forgotPinBody =>
      'لا يمكن استعادة رمز منسي. يمكنك حذف جميع بيانات التطبيق، بما فيها التمارين والصور، والبدء من جديد.';

  @override
  String get eraseEverything => 'حذف كل شيء';

  @override
  String get backupTitle => 'النسخ الاحتياطي';

  @override
  String get backupExport => 'تصدير نسخة احتياطية مشفّرة';

  @override
  String get backupExportHint =>
      'ملف واحد يضم كل بياناتك وصورك، محمي بعبارة مرور تختارها.';

  @override
  String get backupImport => 'استعادة من نسخة احتياطية';

  @override
  String get backupImportHint =>
      'يستبدل كل ما على هذا الجهاز بمحتوى ملف النسخة.';

  @override
  String get backupPassphrase => 'عبارة مرور النسخة';

  @override
  String get backupPassphraseAgain => 'عبارة المرور مرة أخرى';

  @override
  String get backupPassphraseHint =>
      'ستحتاج إلى هذه العبارة للاستعادة، ولا يمكن استرجاعها إذا فقدتها.';

  @override
  String backupPassphraseShort(int count) {
    return 'استخدم $count أحرف على الأقل';
  }

  @override
  String get backupPassphraseMismatch => 'العبارتان غير متطابقتين';

  @override
  String get backupExportFailed => 'تعذّر إنشاء النسخة الاحتياطية.';

  @override
  String get backupUnreadable =>
      'تعذّر فتح النسخة. تحقق من الملف وعبارة المرور.';

  @override
  String get backupTooNew =>
      'أُنشئت هذه النسخة بإصدار أحدث من التطبيق. حدّث التطبيق أولاً.';

  @override
  String get backupImportTitle => 'استبدال جميع البيانات؟';

  @override
  String get backupImportBody =>
      'سيُستبدل كل ما في التطبيق حالياً بمحتوى النسخة. لا يمكن التراجع عن ذلك.';

  @override
  String get backupImportConfirm => 'استبدال واستعادة';

  @override
  String get cloudTitle => 'الحساب والسحابة (اختياري)';

  @override
  String get cloudOptionalHint =>
      'يعمل التطبيق كاملاً دون حساب. سجّل الدخول فقط إذا أردت النسخ السحابي أو مراجعة المدرب.';

  @override
  String get signInGoogle => 'تسجيل الدخول بحساب Google';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get signedIn => 'تم تسجيل الدخول';

  @override
  String get roleCoach => 'تم الدخول كمدرب';

  @override
  String get cloudFailed =>
      'تعذّر تنفيذ العملية. تحقق من الاتصال وحاول مجدداً.';

  @override
  String get cloudBackupNow => 'نسخ احتياطي إلى السحابة';

  @override
  String get cloudBackupNone =>
      'لا توجد نسخة سحابية بعد. تُشفَّر على هذا الجهاز قبل الرفع.';

  @override
  String cloudBackupLast(String date) {
    return 'آخر نسخة سحابية: $date';
  }

  @override
  String get cloudBackupDone => 'تم رفع النسخة المشفّرة.';

  @override
  String cloudBackupTooLarge(int mb) {
    return 'حجم النسخة يتجاوز $mb ميغابايت. احذف بعض الصور أو استخدم التصدير إلى ملف.';
  }

  @override
  String get cloudRestore => 'استعادة من السحابة';

  @override
  String get cloudDeleteData => 'حذف بياناتي السحابية';

  @override
  String get cloudDeleteDataHint =>
      'يحذف نسختك السحابية ومقاطعك والملاحظات من الخادم.';

  @override
  String get cloudDeleteDataBody =>
      'ستُحذف نسختك السحابية ومقاطع المراجعة والملاحظات من الخادم. لن تتأثر البيانات على هذا الجهاز.';

  @override
  String get coachReview => 'مراجعة المدرب';

  @override
  String get coachOpen => 'أرسل مقطعاً إلى المدرب';

  @override
  String get coachHint => 'احصل على تصحيحات للأداء عبر فيديو قصير لحركتك.';

  @override
  String get coachSignInNeeded =>
      'تحتاج مراجعة المدرب إلى حساب حتى تصل مقاطعك والملاحظات إلى الشخص الصحيح.';

  @override
  String get clipNewTitle => 'مقطع جديد';

  @override
  String clipRules(int seconds, int days) {
    return 'حتى $seconds ثانية. يُضغط على هاتفك ويُرسل دون صوت ويُحذف بعد المراجعة أو بعد $days يوماً.';
  }

  @override
  String get clipChooseExercise => 'اختر التمرين';

  @override
  String get clipRecord => 'تسجيل';

  @override
  String get clipChoose => 'اختيار فيديو';

  @override
  String get clipReady => 'المقطع جاهز للإرسال';

  @override
  String get clipNote => 'ملاحظة للمدرب';

  @override
  String get clipSend => 'إرسال للمراجعة';

  @override
  String get clipSent => 'تم إرسال المقطع. ستظهر الملاحظات في الأسفل.';

  @override
  String clipTooLong(int seconds) {
    return 'يجب ألا يتجاوز المقطع $seconds ثانية.';
  }

  @override
  String get clipFailed => 'تعذّر تجهيز المقطع.';

  @override
  String get clipUnavailable => 'هذا المقطع لم يعد متاحاً.';

  @override
  String get clipPlay => 'تشغيل';

  @override
  String get feedbackInbox => 'ملاحظاتك';

  @override
  String get feedbackEmpty => 'ستظهر هنا المقاطع التي ترسلها وملاحظات المدرب.';

  @override
  String get statusWaiting => 'بانتظار المراجعة';

  @override
  String get statusReviewed => 'تمت المراجعة';

  @override
  String get coachSays => 'ملاحظات المدرب';

  @override
  String get coachInbox => 'صندوق المدرب';

  @override
  String coachInboxWaiting(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'مقاطع بالانتظار: $count',
      zero: 'لا شيء بالانتظار',
    );
    return '$_temp0';
  }

  @override
  String get coachInboxEmpty => 'لا توجد مقاطع بانتظار المراجعة.';

  @override
  String get feedbackWrite => 'ملاحظات على الأداء';

  @override
  String get feedbackSend => 'إرسال الملاحظات';

  @override
  String get feedbackDeletesClip => 'إرسال الملاحظات يحذف المقطع من الخادم.';
}
