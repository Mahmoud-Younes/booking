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
}
