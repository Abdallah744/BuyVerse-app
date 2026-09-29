import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    Map<String, dynamic> jsonMap = _getLanguageMap(locale.languageCode);
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  Map<String, dynamic> _getLanguageMap(String code) {
    if (code == 'ar') {
      return {
        // App General
        'app_title': 'باي فيرس',
        'home': 'الرئيسية',
        'products': 'المنتجات',
        'orders': 'الطلبات',
        'profile': 'الملف الشخصي',
        'settings': 'الإعدادات',
        'language': 'اللغة',
        'arabic': 'العربية',
        'english': 'الإنجليزية',
        'select_language': 'اختر اللغة',
        'loading': 'جاري التحميل...',
        'error': 'خطأ',
        'success': 'تم بنجاح',
        'confirm': 'تأكيد',
        'save': 'حفظ',
        'cancel': 'إلغاء',
        'delete': 'حذف',
        'edit': 'تعديل',
        'add': 'إضافة',
        'see_all': 'عرض الكل',
        'no_data': 'لا توجد بيانات',
        'logout': 'تسجيل خروج',
        'good_morning': 'صباح الخير،',
        'quick_actions': 'إجراءات سريعة',
        'optional': 'اختياري',
        'step': 'خطوة',
        'of': 'من',

        // Auth
        'login': 'تسجيل الدخول',
        'register': 'إنشاء حساب',
        'email': 'البريد الإلكتروني',
        'password': 'كلمة المرور',
        'confirm_password': 'تأكيد كلمة المرور',
        'forgot_password': 'نسيت كلمة المرور؟',
        'dont_have_account': 'ليس لديك حساب؟',
        'already_have_account': 'لديك حساب بالفعل؟',
        'full_name': 'الاسم الكامل',
        'phone': 'رقم الهاتف',
        'national_id': 'الرقم القومي',
        'business_name': 'اسم النشاط التجاري',
        'business_address': 'عنوان العمل',
        'store_location': 'موقع المتجر على الخريطة',
        'personal_information': 'المعلومات الشخصية',
        'business_information': 'معلومات العمل',
        'business_documents': 'وثائق العمل',
        'commercial_register': 'السجل التجاري',
        'tax_card': 'البطاقة الضريبية',
        'uploaded': 'تم الرفع',
        'not_uploaded': 'لم يتم الرفع',
        'pick_image': 'اختر صورة',
        'pick_file': 'اختر ملف',
        'profile_image': 'الصورة الشخصية',
        'security': 'الأمان',
        'sign_in_manage': 'قم بتسجيل الدخول لإدارة متجرك',
        'for_business': 'للأعمال',

        // Verification
        'verify_email': 'تفعيل البريد',
        'check_your_email': 'افحص بريدك الإلكتروني',
        'otp_sent_to': 'لقد أرسلنا كود تفعيل مكون من 6 أرقام إلى',
        'code_expires_in': 'ينتهي الكود خلال ',
        'verify': 'تفعيل',
        'resend_code': 'إعادة إرسال الكود',
        'otp_sent_msg': 'تم إرسال كود التفعيل إلى بريدك الإلكتروني',
        'otp_failed_msg': 'عذراً، فشل إرسال الكود',
        'otp_success_msg': 'تم تفعيل الحساب بنجاح',
        'invalid_otp_msg': 'كود غير صحيح، يرجى المحاولة مرة أخرى',
        'wait_timer_msg': 'يرجى الانتظار حتى انتهاء العداد',

        // Products
        'add_product': 'إضافة منتج',
        'edit_product': 'تعديل منتج',
        'product_details': 'تفاصيل المنتج',
        'product_name': 'اسم المنتج',
        'price': 'السعر',
        'quantity': 'الكمية',
        'description': 'الوصف',
        'description_hint': 'صف منتجك بالتفصيل...',
        'category': 'القسم',
        'select_category': 'اختر القسم',
        'visible_to_customers': 'مرئي للعملاء',
        'total_products': 'إجمالي المنتجات',
        'products_overview': 'نظرة عامة على المنتجات',
        'no_products': 'لا توجد منتجات مضافة بعد',
        'search_products': 'ابحث عن المنتجات...',
        'visible': 'مرئي',
        'hidden': 'مخفي',
        'details': 'التفاصيل',
        'added_date': 'تاريخ الإضافة',

        // Categories
        'categories': 'الأقسام',
        'manage_categories': 'إدارة الأقسام',
        'add_category': 'إضافة قسم',
        'edit_category': 'تعديل القسم',
        'category_name': 'اسم القسم',
        'category_description': 'وصف القسم',

        // Orders
        'total_orders': 'إجمالي الطلبات',
        'pending_orders': 'طلبات معلقة',
        'recent_orders': 'آخر الطلبات',
        'order_details': 'تفاصيل الطلب',
        'customer': 'العميل',
        'status': 'الحالة',
        'payment_method': 'طريقة الدفع',
        'total_price': 'السعر الإجمالي',
        'items': 'الأصناف',
        'no_orders': 'لا توجد طلبات حتى الآن',
        'pending': 'معلق',
        'delivered': 'تم التوصيل',
        'delivery': 'التوصيل',
        'summary': 'الملخص',
        'view_on_map': 'عرض على الخريطة',
        'notifications': 'الإشعارات',
        'mark_all_as_read': 'تحديد الكل كمقروء',
        'no_notifications': 'لا توجد إشعارات حالياً',
        'unread': 'غير مقروء',

        // Warnings & Validations
        'email_required': 'البريد الإلكتروني مطلوب',
        'password_required': 'كلمة المرور مطلوبة',
        'password_too_short': 'كلمة المرور يجب أن تكون 8 أحرف على الأقل',
        'passwords_not_match': 'كلمات المرور غير متطابقة',
        'name_required': 'الاسم مطلوب',
        'name_no_numbers': 'الاسم لا يجب أن يحتوي على أرقام',
        'invalid_email': 'يرجى إدخال بريد إلكتروني صحيح',
        'phone_required': 'رقم الهاتف مطلوب',
        'phone_digits_only': 'رقم الهاتف يجب أن يكون أرقام فقط',
        'id_required': 'الرقم القومي مطلوب',
        'id_too_short': 'الرقم القومي يجب أن يكون 14 رقم',
        'id_digits_only': 'الرقم القومي يجب أن يكون أرقام فقط',
        'business_name_required': 'اسم العمل مطلوب',
        'location_required': 'موقع المتجر مطلوب',
        'price_required': 'السعر مطلوب',
        'quantity_required': 'الكمية مطلوبة',
        'category_required': 'يرجى اختيار قسم',
        'image_required': 'يرجى اختيار صورة للمنتج',
        'low_stock_warning': 'تنبيه: مخزون منخفض',
        'out_of_stock': 'نفذت الكمية',
        'create_category_first': 'يرجى إنشاء قسم واحد على الأقل أولاً',
        'delete_confirmation': 'هل أنت متأكد من الحذف؟',
        'low_stock_msg': 'الكمية أوشكت على النفاذ',
        'out_of_stock_msg': 'هذا المنتج غير متوفر حالياً',
        'new_order_received': 'تم استلام طلب جديد',
        'order_status_updated': 'تم تحديث حالة الطلب',
      };
    } else {
      return {
        // App General
        'app_title': 'Buy Verse',
        'home': 'Home',
        'products': 'Products',
        'orders': 'Orders',
        'profile': 'Profile',
        'settings': 'Settings',
        'language': 'Language',
        'arabic': 'Arabic',
        'english': 'English',
        'select_language': 'Select Language',
        'loading': 'Loading...',
        'error': 'Error',
        'success': 'Success',
        'confirm': 'Confirm',
        'save': 'Save',
        'cancel': 'Cancel',
        'delete': 'Delete',
        'edit': 'Edit',
        'add': 'Add',
        'see_all': 'See All',
        'no_data': 'No Data',
        'logout': 'Logout',
        'good_morning': 'Good morning,',
        'quick_actions': 'Quick Actions',
        'optional': 'Optional',
        'step': 'Step',
        'of': 'of',

        // Auth
        'login': 'Login',
        'register': 'Register',
        'email': 'Email',
        'password': 'Password',
        'confirm_password': 'Confirm Password',
        'forgot_password': 'Forgot Password?',
        'dont_have_account': "Don't have an account?",
        'already_have_account': 'Already have an account?',
        'full_name': 'Full Name',
        'phone': 'Phone Number',
        'national_id': 'National ID',
        'business_name': 'Business Name',
        'business_address': 'Business Address',
        'store_location': 'Store Location on Map',
        'personal_information': 'PERSONAL INFORMATION',
        'business_information': 'BUSINESS INFORMATION',
        'business_documents': 'BUSINESS DOCUMENTS',
        'commercial_register': 'Commercial Register',
        'tax_card': 'Tax Card',
        'uploaded': 'Uploaded',
        'not_uploaded': 'Not Uploaded',
        'pick_image': 'Pick Image',
        'pick_file': 'Pick File',
        'profile_image': 'Profile Picture',
        'security': 'Security',
        'sign_in_manage': 'Sign in to manage your store',
        'for_business': 'FOR BUSINESS',

        // Verification
        'verify_email': 'Verify Email',
        'check_your_email': 'Check your email',
        'otp_sent_to': 'We sent a 6-digit verification code to',
        'code_expires_in': 'Code expires in ',
        'verify': 'Verify',
        'resend_code': 'Resend Code',
        'otp_sent_msg': 'OTP has been sent to your email',
        'otp_failed_msg': 'Oops, OTP send failed',
        'otp_success_msg': 'OTP Verified Successfully',
        'invalid_otp_msg': 'Invalid OTP, please try again',
        'wait_timer_msg': 'Please wait until the timer expires',

        // Products
        'add_product': 'Add Product',
        'edit_product': 'Edit Product',
        'product_details': 'Product Details',
        'product_name': 'Product Name',
        'price': 'Price',
        'quantity': 'Quantity',
        'description': 'Description',
        'description_hint': 'Describe your product...',
        'category': 'Category',
        'select_category': 'Select Category',
        'visible_to_customers': 'Visible to customers',
        'total_products': 'Total Products',
        'products_overview': 'Products Overview',
        'no_products': 'No products added yet',
        'search_products': 'Search products...',
        'visible': 'Visible',
        'hidden': 'Hidden',
        'details': 'Details',
        'added_date': 'Added Date',

        // Categories
        'categories': 'Categories',
        'manage_categories': 'Manage Categories',
        'add_category': 'Add Category',
        'edit_category': 'Edit Category',
        'category_name': 'Category Name',
        'category_description': 'Category Description',

        // Orders
        'total_orders': 'Total Orders',
        'pending_orders': 'Pending Orders',
        'recent_orders': 'Recent Orders',
        'order_details': 'Order Details',
        'customer': 'Customer',
        'status': 'Status',
        'payment_method': 'Payment Method',
        'total_price': 'Total Price',
        'items': 'Items',
        'no_orders': 'No orders yet',
        'pending': 'Pending',
        'delivered': 'Delivered',
        'delivery': 'Delivery',
        'summary': 'Summary',
        'view_on_map': 'View on Map',
        'notifications': 'Notifications',
        'mark_all_as_read': 'Mark all as read',
        'no_notifications': 'No notifications yet',
        'unread': 'Unread',

        // Warnings & Validations
        'email_required': 'Email is required',
        'password_required': 'Password is required',
        'password_too_short': 'Password must be at least 8 characters',
        'passwords_not_match': 'Passwords do not match',
        'name_required': 'Name is required',
        'name_no_numbers': 'Name should not contain numbers',
        'invalid_email': 'Enter a valid email address',
        'phone_required': 'Phone is required',
        'phone_digits_only': 'Phone must be digits only',
        'id_required': 'ID is required',
        'id_too_short': 'ID must be at least 14 digits',
        'id_digits_only': 'ID must be digits only',
        'business_name_required': 'Enter business name',
        'location_required': 'Enter store location',
        'price_required': 'Price is required',
        'quantity_required': 'Quantity is required',
        'category_required': 'Please select a category',
        'image_required': 'Please select a product image',
        'low_stock_warning': 'Warning: Low Stock',
        'out_of_stock': 'Out of Stock',
        'create_category_first': 'Please create at least one category first',
        'delete_confirmation': 'Are you sure you want to delete?',
        'low_stock_msg': 'Stock is almost empty',
        'out_of_stock_msg': 'This product is currently out of stock',
        'new_order_received': 'New Order Received',
        'order_status_updated': 'Order Status Updated',
      };
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
