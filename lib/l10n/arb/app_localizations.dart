import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_km.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('en'),
    Locale('km')
  ];

  /// No description provided for @tmie_manager.
  ///
  /// In en, this message translates to:
  /// **'Timer Manager'**
  String get tmie_manager;

  /// No description provided for @pause_all.
  ///
  /// In en, this message translates to:
  /// **'Pause All'**
  String get pause_all;

  /// No description provided for @resume_all.
  ///
  /// In en, this message translates to:
  /// **'Resume All'**
  String get resume_all;

  /// No description provided for @stop_all.
  ///
  /// In en, this message translates to:
  /// **'Stop All'**
  String get stop_all;

  /// No description provided for @reset_all.
  ///
  /// In en, this message translates to:
  /// **'Reset All'**
  String get reset_all;

  /// No description provided for @restart_all.
  ///
  /// In en, this message translates to:
  /// **'Restart All'**
  String get restart_all;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @no_history_yet.
  ///
  /// In en, this message translates to:
  /// **'No history yet.'**
  String get no_history_yet;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @riel.
  ///
  /// In en, this message translates to:
  /// **'Riels'**
  String get riel;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @new_person.
  ///
  /// In en, this message translates to:
  /// **'New Person'**
  String get new_person;

  /// No description provided for @person_name.
  ///
  /// In en, this message translates to:
  /// **'Person Name'**
  String get person_name;

  /// No description provided for @name_cannot_be_empty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get name_cannot_be_empty;

  /// No description provided for @horuly_rate.
  ///
  /// In en, this message translates to:
  /// **'Hourly Rate (Riel)'**
  String get horuly_rate;

  /// No description provided for @rate_is_required.
  ///
  /// In en, this message translates to:
  /// **'Rate is required'**
  String get rate_is_required;

  /// No description provided for @rate_must_be_positive_number.
  ///
  /// In en, this message translates to:
  /// **'Rate must be a positive number'**
  String get rate_must_be_positive_number;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @delete_person.
  ///
  /// In en, this message translates to:
  /// **'Delete Person'**
  String get delete_person;

  /// No description provided for @are_you_sure_you_wanna_delete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this person?'**
  String get are_you_sure_you_wanna_delete;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @total_hours.
  ///
  /// In en, this message translates to:
  /// **'Total Hours'**
  String get total_hours;

  /// No description provided for @total_money.
  ///
  /// In en, this message translates to:
  /// **'Total Money'**
  String get total_money;

  /// No description provided for @riels_hour.
  ///
  /// In en, this message translates to:
  /// **'Riels/hour'**
  String get riels_hour;

  /// No description provided for @running.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get running;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get hour;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get minute;

  /// No description provided for @second.
  ///
  /// In en, this message translates to:
  /// **'Second'**
  String get second;

  /// No description provided for @press_here_change_language.
  ///
  /// In en, this message translates to:
  /// **'Press here to change language'**
  String get press_here_change_language;

  /// No description provided for @customize_theme_appearance.
  ///
  /// In en, this message translates to:
  /// **'Customize theme appearance'**
  String get customize_theme_appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @call_developer.
  ///
  /// In en, this message translates to:
  /// **'Call Developer'**
  String get call_developer;

  /// No description provided for @call_developer_description.
  ///
  /// In en, this message translates to:
  /// **'If you have any question or suggestion, please call me.'**
  String get call_developer_description;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'Copyright'**
  String get copyright;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// No description provided for @light_mode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get light_mode;

  /// No description provided for @system_default.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get system_default;

  /// No description provided for @dark_mode_description.
  ///
  /// In en, this message translates to:
  /// **'App look darker.'**
  String get dark_mode_description;

  /// No description provided for @voice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voice;

  /// No description provided for @change_voice_sound.
  ///
  /// In en, this message translates to:
  /// **'Change Voice Sound'**
  String get change_voice_sound;

  /// No description provided for @alert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert;

  /// No description provided for @sound_khmer_not_supported.
  ///
  /// In en, this message translates to:
  /// **'Sound Khmer not supported'**
  String get sound_khmer_not_supported;

  /// No description provided for @allow_speak.
  ///
  /// In en, this message translates to:
  /// **'Allow to speak'**
  String get allow_speak;

  /// No description provided for @please_turn_on_permission.
  ///
  /// In en, this message translates to:
  /// **'Please turn on {permissionType} permission'**
  String please_turn_on_permission(Object permissionType);

  /// lable open settings
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get open_setting;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @chose_photo.
  ///
  /// In en, this message translates to:
  /// **'Choose Photo'**
  String get chose_photo;

  /// take photo option lable
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get take_photo;

  /// choose from library option lable
  ///
  /// In en, this message translates to:
  /// **'Choose from Library'**
  String get choose_from_library;

  /// No description provided for @ai_sound.
  ///
  /// In en, this message translates to:
  /// **'AI Sound'**
  String get ai_sound;

  /// No description provided for @ai_sound_description.
  ///
  /// In en, this message translates to:
  /// **'Allow to use AI voice to speak'**
  String get ai_sound_description;

  /// No description provided for @update_empolyee.
  ///
  /// In en, this message translates to:
  /// **'Update Employee'**
  String get update_empolyee;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @start_timer.
  ///
  /// In en, this message translates to:
  /// **'Time Start'**
  String get start_timer;

  /// No description provided for @stop_timer.
  ///
  /// In en, this message translates to:
  /// **'Time Stop'**
  String get stop_timer;
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
      <String>['en', 'km'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'km':
      return AppLocalizationsKm();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
