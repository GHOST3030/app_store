import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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

  /// No description provided for @passwordMustBeAtLeast6.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long'**
  String get passwordMustBeAtLeast6;

  /// No description provided for @passwordSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully!'**
  String get passwordSuccessfully;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @setNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get setNewPassword;

  /// No description provided for @enterYourNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your new password below.'**
  String get enterYourNewPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @enterYourEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterYourEmailAddress;

  /// No description provided for @willSendMessageToSetPassword.
  ///
  /// In en, this message translates to:
  /// **'We will send you a message to set or reset your new password'**
  String get willSendMessageToSetPassword;

  /// No description provided for @supabaseUriResetPassword.
  ///
  /// In en, this message translates to:
  /// **'io.supabase.flutter://reset-callback'**
  String get supabaseUriResetPassword;

  /// No description provided for @resetInstructionsSent.
  ///
  /// In en, this message translates to:
  /// **'Reset instructions sent!'**
  String get resetInstructionsSent;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please Enter your email'**
  String get pleaseEnterYourEmail;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot\npassword?'**
  String get forgetPassword;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome\nBack!'**
  String get welcomeBack;

  /// No description provided for @usernameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Username or Email'**
  String get usernameOrEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPasswordAsk.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordAsk;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'- OR Continue with -'**
  String get orContinueWith;

  /// No description provided for @createAnAccountText.
  ///
  /// In en, this message translates to:
  /// **'Create An Account '**
  String get createAnAccountText;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @createAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an\naccount'**
  String get createAnAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @byClickingThe.
  ///
  /// In en, this message translates to:
  /// **'By clicking the '**
  String get byClickingThe;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @agreeToPublicOffer.
  ///
  /// In en, this message translates to:
  /// **' button, you agree to the public offer'**
  String get agreeToPublicOffer;

  /// No description provided for @pleaseFillInAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get pleaseFillInAllFields;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @verifyAccountToLogin.
  ///
  /// In en, this message translates to:
  /// **'Account created! Please check your email and verify your account to log in.'**
  String get verifyAccountToLogin;

  /// No description provided for @iAlreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'I Already Have an Account '**
  String get iAlreadyHaveAnAccount;

  /// No description provided for @brandName.
  ///
  /// In en, this message translates to:
  /// **'Stylish'**
  String get brandName;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search any Product...'**
  String get searchHint;

  /// No description provided for @dealOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'Deal of the Day'**
  String get dealOfTheDay;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @allFeatured.
  ///
  /// In en, this message translates to:
  /// **'All Featured'**
  String get allFeatured;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @beauty.
  ///
  /// In en, this message translates to:
  /// **'Beauty'**
  String get beauty;

  /// No description provided for @fashion.
  ///
  /// In en, this message translates to:
  /// **'Fashion'**
  String get fashion;

  /// No description provided for @kids.
  ///
  /// In en, this message translates to:
  /// **'Kids'**
  String get kids;

  /// No description provided for @mens.
  ///
  /// In en, this message translates to:
  /// **'Mens'**
  String get mens;

  /// No description provided for @womens.
  ///
  /// In en, this message translates to:
  /// **'Womens'**
  String get womens;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @priceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: Low → High'**
  String get priceLowToHigh;

  /// No description provided for @priceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Price: High → Low'**
  String get priceHighToLow;

  /// No description provided for @topRated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get topRated;

  /// No description provided for @newestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get newestFirst;

  /// No description provided for @clearSort.
  ///
  /// In en, this message translates to:
  /// **'Clear Sort'**
  String get clearSort;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRange;

  /// No description provided for @minRating.
  ///
  /// In en, this message translates to:
  /// **'Min Rating'**
  String get minRating;

  /// No description provided for @inStockOnly.
  ///
  /// In en, this message translates to:
  /// **'In Stock Only'**
  String get inStockOnly;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @any.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get any;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get outOfStock;

  /// No description provided for @outOfStockShort.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get outOfStockShort;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'off'**
  String get off;

  /// No description provided for @noDealsRightNow.
  ///
  /// In en, this message translates to:
  /// **'No deals right now'**
  String get noDealsRightNow;

  /// No description provided for @noProducts.
  ///
  /// In en, this message translates to:
  /// **'No products'**
  String get noProducts;

  /// No description provided for @noNewArrivals.
  ///
  /// In en, this message translates to:
  /// **'No new arrivals'**
  String get noNewArrivals;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get loadMore;

  /// No description provided for @hotSummerSale.
  ///
  /// In en, this message translates to:
  /// **'🔥 Hot Summer Sale!'**
  String get hotSummerSale;

  /// No description provided for @specialOffers.
  ///
  /// In en, this message translates to:
  /// **'Special Offers'**
  String get specialOffers;

  /// No description provided for @specialOffersFire.
  ///
  /// In en, this message translates to:
  /// **'Special Offers 🔥'**
  String get specialOffersFire;

  /// No description provided for @exploreDeals.
  ///
  /// In en, this message translates to:
  /// **'Explore Deals'**
  String get exploreDeals;

  /// No description provided for @sponsored.
  ///
  /// In en, this message translates to:
  /// **'Sponsored'**
  String get sponsored;

  /// No description provided for @upTo.
  ///
  /// In en, this message translates to:
  /// **'– UP TO –'**
  String get upTo;

  /// No description provided for @fiftyPercentOff.
  ///
  /// In en, this message translates to:
  /// **'50% OFF'**
  String get fiftyPercentOff;

  /// No description provided for @upToFiftyPercentOff.
  ///
  /// In en, this message translates to:
  /// **'up to 50% Off  →'**
  String get upToFiftyPercentOff;

  /// No description provided for @offerAtBestPrices.
  ///
  /// In en, this message translates to:
  /// **'We make sure you get the offer\nyou need at best prices'**
  String get offerAtBestPrices;

  /// No description provided for @flatAndHeels.
  ///
  /// In en, this message translates to:
  /// **'Flat and Heels'**
  String get flatAndHeels;

  /// No description provided for @standAChanceToBeRewarded.
  ///
  /// In en, this message translates to:
  /// **'Stand a chance to get rewarded'**
  String get standAChanceToBeRewarded;

  /// No description provided for @visitNow.
  ///
  /// In en, this message translates to:
  /// **'Visit now →'**
  String get visitNow;

  /// No description provided for @trendingProducts.
  ///
  /// In en, this message translates to:
  /// **'Trending Products'**
  String get trendingProducts;

  /// No description provided for @lastDate.
  ///
  /// In en, this message translates to:
  /// **'Last Date 29/02/22'**
  String get lastDate;

  /// No description provided for @newArrivals.
  ///
  /// In en, this message translates to:
  /// **'New Arrivals'**
  String get newArrivals;

  /// No description provided for @summerCollections.
  ///
  /// In en, this message translates to:
  /// **'Summer \'25 Collections'**
  String get summerCollections;

  /// No description provided for @promosFiftyFortyOff.
  ///
  /// In en, this message translates to:
  /// **'50–40% OFF'**
  String get promosFiftyFortyOff;

  /// No description provided for @promosNowInProducts.
  ///
  /// In en, this message translates to:
  /// **'Now in (product)\nAll colours'**
  String get promosNowInProducts;

  /// No description provided for @shopNow.
  ///
  /// In en, this message translates to:
  /// **'Shop Now'**
  String get shopNow;

  /// No description provided for @promosSummerFresh.
  ///
  /// In en, this message translates to:
  /// **'Summer \'25\nFresh Collections'**
  String get promosSummerFresh;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @flashSale.
  ///
  /// In en, this message translates to:
  /// **'Flash Sale'**
  String get flashSale;

  /// No description provided for @promosFlashSale.
  ///
  /// In en, this message translates to:
  /// **'Limited time\nUp to 70% off'**
  String get promosFlashSale;

  /// No description provided for @grabNow.
  ///
  /// In en, this message translates to:
  /// **'Grab Now'**
  String get grabNow;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @wishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @failedToLoadProducts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load products:'**
  String get failedToLoadProducts;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error — check your connection'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error — please try again later'**
  String get serverError;

  /// No description provided for @unknownFailure.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get unknownFailure;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'RETRY'**
  String get retry;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
