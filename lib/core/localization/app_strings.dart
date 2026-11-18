/// Every Arabic UI string in one place — the only file where UI text exists.
///
/// Raw Firebase error messages must never reach the screen; the repo/cubit
/// boundary maps them to these constants via FirebaseErrorMapper.
class AppStrings {
  AppStrings._();

  // App-level.
  static const String appName = 'حجوزات';

  // Auth.
  static const String loginTitle = 'مرحباً بعودتك';
  static const String loginSubtitle = 'سجّل دخولك لمتابعة رحلتك';
  static const String emailLabel = 'البريد الإلكتروني';
  static const String passwordLabel = 'كلمة المرور';
  static const String loginButton = 'تسجيل الدخول';
  static const String signUpButton = 'إنشاء حساب';
  static const String noAccount = 'ليس لديك حساب؟';
  static const String haveAccount = 'لديك حساب بالفعل؟';
  static const String nameLabel = 'الاسم';

  // Search.
  static const String searchTitle = 'أين تريد الإقامة؟';
  static const String destinationHint = 'المدينة (مثال: القاهرة)';
  static const String checkInLabel = 'تاريخ الوصول';
  static const String checkOutLabel = 'تاريخ المغادرة';
  static const String guestsLabel = 'عدد الضيوف';
  static const String searchButton = 'ابحث';
  static const String resultsTitle = 'نتائج البحث';
  static const String maxPriceLabel = 'أقصى سعر لليلة';
  static const String sortDescending = 'السعر: من الأعلى';
  static const String sortAscending = 'السعر: من الأدنى';
  static const String clearFilters = 'مسح الفلاتر';
  static const String retry = 'إعادة المحاولة';

  // Results states.
  static const String emptyResultsTitle = 'لا توجد نتائج';
  static const String emptyResultsSubtitle =
      'جرّب تعديل الفلاتر أو اختيار مدينة أخرى';
  static const String loadFailureTitle = 'تعذر تحميل النتائج';

  // Booking.
  static const String bookButton = 'تأكيد الحجز';
  static const String nightsLabel = 'ليلات';
  static const String perNight = 'لكل ليلة';
  static const String submittingBooking = 'جارٍ تأكيد الحجز...';
  static const String bookingSuccessTitle = 'تم تأكيد الحجز';
  static const String bookingSuccessSubtitle =
      'حجزك مؤكد، يمكنك مراجعته من "حجوزاتي"';
  static const String myBookingsTitle = 'حجوزاتي';
  static const String cancelButton = 'إلغاء الحجز';
  static const String cancellingBooking = 'جارٍ الإلغاء...';
  static const String cancelSuccessTitle = 'تم إلغاء الحجز';
  static const String cancelledStatus = 'ملغي';
  static const String confirmedStatus = 'مؤكد';

  // Conflict moment (designed full-screen notice, never a bare dialog).
  static const String conflictTitle = 'التواريخ حُجزت للتو';
  static const String conflictBodyPrefix = 'للأسف، الغرفة حُجزت للليالات ';
  static const String conflictBodySuffix = ' من مستخدم آخر قبل لحظات.';
  static const String conflictChangeDates = 'تغيير التواريخ';
  static const String conflictSimilarRooms = 'عرض غرف مشابهة';
  static const String conflictBackToResults = 'الرجوع إلى النتائج';

  // Offline-pending.
  static const String offlinePendingTitle = 'لم يتم تأكيد الحجز';
  static const String offlinePendingBody =
      'لا يوجد اتصال الآن — لم تُحجز أي ليالي ويمكنك المحاولة عند عودة الاتصال.';

  // Errors (mapped from FailureCode — never raw Firebase strings).
  static const String errorAuthRequired = 'تحقق من بيانات الدخول أو سجّل أولاً';
  static const String errorNetworkUnavailable =
      'تحقق من اتصالك بالإنترنت وحاول مرة أخرى';
  static const String errorRuleDenied = 'لا تملك صلاحية تنفيذ هذا الإجراء';
  static const String errorConflictLost = 'نأسف، هذه التواريخ حُجزت للتو';
  static const String errorTransactionRetry = 'تعذر إتمام الحجز، حاول مرة أخرى';
  static const String errorUnknown = 'حدث خطأ غير متوقع، حاول مرة أخرى';

  // About (the in-app project identity — any reviewer understands the
  // project within one screen: what it is, what it does, the guarantee).
  static const String aboutTitle = 'عن التطبيق';
  static const String aboutAppName = 'حجوزات';
  static const String aboutTagline =
      'تطبيق حجز غرف فندقية — يعمل كموقع ويب وتطبيق أندرويد من قاعدة كود واحدة';
  static const String aboutWhatTitle = 'ما هذا التطبيق؟';
  static const String aboutWhatBody =
      'مشروع تدريبي يحاكي تجربة مواقع الحجز العالمية: تختار المدينة وتاريخي الوصول والمغادرة وعدد الضيوف، فتشاهد نتائج البحث تتحدث مباشرة مع الأسعار، ثم تفتح صفحة الغرفة لتأكيد الحجز — وتتابع حجوزاتك أو تلغيها من «حجوزاتي» فتتحرر التواريخ فورًا للآخرين.';
  static const String aboutGuaranteeTitle = 'الضمان الأساسي: لا حجز مزدوج';
  static const String aboutGuaranteeBody =
      'لو حاول مستخدمان حجز نفس الغرفة لنفس الليالات في نفس اللحظة، سينجح أحدهما فقط ويرى الآخر إشعارًا واضحًا بأن التواريخ حُجزت للتو. الضمان مطبَّق على الخادم نفسه (معاملة Firestore ذرّية + قواعد أمان Firestore) وليس في التطبيق فقط، لذلك يصمد حتى لو مُسِّس عميل — وهو مُثبت باختبار سباق تلقائي يشغّل حجزين متزامنين على المحاكي ويؤكد فوز واحدًا فقط.';
  static const String aboutFeaturesTitle = 'أبرز الميزات';
  static const String aboutFeatureSearch =
      'بحث مباشر: نتائج متدفقة تتحدث لحظيًا لكل المستخدمين المتصلين';
  static const String aboutFeatureFilters =
      'فلترة بالسعر الأقصى وعدد الضيوف مع ترتيب تنازلي أو تصاعدي';
  static const String aboutFeatureNights =
      'حجز بالليل الواحد: كل ليلة مستند مستقل يُقفل لحظة الحجز';
  static const String aboutFeatureConflict =
      'شاشة تعارض مصممة تسمي التواريخ وتقترح بدائل بدل رسالة خطأ جافة';
  static const String aboutFeatureCancel =
      'إلغاء فوري يحرر الليالات ويجعلها متاحة لإعادة الحجز';
  static const String aboutFeatureOffline =
      'سلوك أوفلاين صادق: لا تُقفل أي ليلة قبل تأكيد الخادم';
  static const String aboutStackTitle = 'التقنيات المستخدمة';
  static const String aboutStackBody =
      'Flutter (ويب + أندرويد) • Firebase Authentication وCloud Firestore • Bloc/Cubit مع freezed • get_it • flutter_screenutil — مغطاة بأكثر من 45 اختبارًا (وحدة/ويدجت/تكامل) بينها اختبار السباق الذي يثبت منع التعارض.';
  static const String aboutReviewersTitle = 'للمراجع التقني';
  static const String aboutReviewersBody =
      'هيكل الميزات موحد: data (مستودعات + نماذج) / logic (Cubits وحالاتها) / ui (شاشات وويدجت)، والبنية المشتركة في core. مستند التصميم الكامل في docs/designs/، قواعد الأمان في firestore.rules، وكل محاولة حجز فاشلة تُسجَّل في مجموعة تدقيق booking_failures حتى يمكن إعادة بناء أي تعارض بعد وقوعه.';
  static const String aboutFooter = 'مشروع تدريبي — DEPI';
}
