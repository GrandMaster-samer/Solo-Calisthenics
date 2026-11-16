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
}
