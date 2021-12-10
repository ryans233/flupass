// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `flupass`
  String get appName {
    return Intl.message(
      'flupass',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get pageLibraryDialCreate {
    return Intl.message(
      'Create',
      name: 'pageLibraryDialCreate',
      desc: '',
      args: [],
    );
  }

  /// `New pass`
  String get pageLibraryDialActionNewPass {
    return Intl.message(
      'New pass',
      name: 'pageLibraryDialActionNewPass',
      desc: '',
      args: [],
    );
  }

  /// `New folder`
  String get pageLibraryDialActionNewFolder {
    return Intl.message(
      'New folder',
      name: 'pageLibraryDialActionNewFolder',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get dialogButtonCancel {
    return Intl.message(
      'Cancel',
      name: 'dialogButtonCancel',
      desc: '',
      args: [],
    );
  }

  /// `Abort`
  String get dialogButtonAbort {
    return Intl.message(
      'Abort',
      name: 'dialogButtonAbort',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get dialogButtonCreate {
    return Intl.message(
      'Create',
      name: 'dialogButtonCreate',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get dialogButtonDelete {
    return Intl.message(
      'Delete',
      name: 'dialogButtonDelete',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get dialogButtonOk {
    return Intl.message(
      'OK',
      name: 'dialogButtonOk',
      desc: '',
      args: [],
    );
  }

  /// `New pass`
  String get dialogNewPassTitle {
    return Intl.message(
      'New pass',
      name: 'dialogNewPassTitle',
      desc: '',
      args: [],
    );
  }

  /// `Pass name`
  String get dialogNewPassHintPassName {
    return Intl.message(
      'Pass name',
      name: 'dialogNewPassHintPassName',
      desc: '',
      args: [],
    );
  }

  /// `Filename would be end up with .gpg`
  String get dialogNewPassHelperPassName {
    return Intl.message(
      'Filename would be end up with .gpg',
      name: 'dialogNewPassHelperPassName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid pass name`
  String get dialogNewPassHintInvalidHintPassName {
    return Intl.message(
      'Please enter a valid pass name',
      name: 'dialogNewPassHintInvalidHintPassName',
      desc: '',
      args: [],
    );
  }

  /// `New folder`
  String get dialogNewFolderTitle {
    return Intl.message(
      'New folder',
      name: 'dialogNewFolderTitle',
      desc: '',
      args: [],
    );
  }

  /// `Folder name`
  String get dialogNewFolderHintFolderName {
    return Intl.message(
      'Folder name',
      name: 'dialogNewFolderHintFolderName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid folder name`
  String get dialogNewFolderInvalidHintFolderName {
    return Intl.message(
      'Please enter a valid folder name',
      name: 'dialogNewFolderInvalidHintFolderName',
      desc: '',
      args: [],
    );
  }

  /// `Current path: {path}`
  String dialogNewFolderCurrentPath(Object path) {
    return Intl.message(
      'Current path: $path',
      name: 'dialogNewFolderCurrentPath',
      desc: '',
      args: [path],
    );
  }

  /// `Password Generator`
  String get pagePasswordGeneratorTitle {
    return Intl.message(
      'Password Generator',
      name: 'pagePasswordGeneratorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Generate`
  String get pagePasswordGeneratorButtonGenerate {
    return Intl.message(
      'Generate',
      name: 'pagePasswordGeneratorButtonGenerate',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get pagePasswordGeneratorButtonCopy {
    return Intl.message(
      'Copy',
      name: 'pagePasswordGeneratorButtonCopy',
      desc: '',
      args: [],
    );
  }

  /// `Copied`
  String get pagePasswordGeneratorSnackMsgCopied {
    return Intl.message(
      'Copied',
      name: 'pagePasswordGeneratorSnackMsgCopied',
      desc: '',
      args: [],
    );
  }

  /// `Failed to copy`
  String get pagePasswordGeneratorSnackMsgFailedToCopy {
    return Intl.message(
      'Failed to copy',
      name: 'pagePasswordGeneratorSnackMsgFailedToCopy',
      desc: '',
      args: [],
    );
  }

  /// `Length`
  String get pagePasswordGeneratorOptionEntryLengthTitle {
    return Intl.message(
      'Length',
      name: 'pagePasswordGeneratorOptionEntryLengthTitle',
      desc: '',
      args: [],
    );
  }

  /// `A-Z`
  String get pagePasswordGeneratorOptionEntryUppercaseTitle {
    return Intl.message(
      'A-Z',
      name: 'pagePasswordGeneratorOptionEntryUppercaseTitle',
      desc: '',
      args: [],
    );
  }

  /// `a-z`
  String get pagePasswordGeneratorOptionEntryLowercaseTitle {
    return Intl.message(
      'a-z',
      name: 'pagePasswordGeneratorOptionEntryLowercaseTitle',
      desc: '',
      args: [],
    );
  }

  /// `123`
  String get pagePasswordGeneratorOptionEntryNumberTitle {
    return Intl.message(
      '123',
      name: 'pagePasswordGeneratorOptionEntryNumberTitle',
      desc: '',
      args: [],
    );
  }

  /// `!@#`
  String get pagePasswordGeneratorOptionEntrySymbolsTitle {
    return Intl.message(
      '!@#',
      name: 'pagePasswordGeneratorOptionEntrySymbolsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get pageSettingsTitle {
    return Intl.message(
      'Settings',
      name: 'pageSettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Unset`
  String get pageSettingsSettingEntryValueUnset {
    return Intl.message(
      'Unset',
      name: 'pageSettingsSettingEntryValueUnset',
      desc: '',
      args: [],
    );
  }

  /// `Set`
  String get pageSettingsSettingEntryValueSet {
    return Intl.message(
      'Set',
      name: 'pageSettingsSettingEntryValueSet',
      desc: '',
      args: [],
    );
  }

  /// `Pass store library location`
  String get pageSettingsSettingEntryPassStoreLibraryLocationTitle {
    return Intl.message(
      'Pass store library location',
      name: 'pageSettingsSettingEntryPassStoreLibraryLocationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Private key`
  String get pageSettingsSettingEntryPrivateKeyTitle {
    return Intl.message(
      'Private key',
      name: 'pageSettingsSettingEntryPrivateKeyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Public key`
  String get pageSettingsSettingEntryPublicKeyTitle {
    return Intl.message(
      'Public key',
      name: 'pageSettingsSettingEntryPublicKeyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Passphrase`
  String get pageSettingsSettingEntryPassphraseTitle {
    return Intl.message(
      'Passphrase',
      name: 'pageSettingsSettingEntryPassphraseTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter your passphrase`
  String get dialogEnterPassphraseTitle {
    return Intl.message(
      'Enter your passphrase',
      name: 'dialogEnterPassphraseTitle',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get viewPassDetailButtonDelete {
    return Intl.message(
      'Delete',
      name: 'viewPassDetailButtonDelete',
      desc: '',
      args: [],
    );
  }

  /// `Back to view mode`
  String get dialogBackToViewModeTitle {
    return Intl.message(
      'Back to view mode',
      name: 'dialogBackToViewModeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Abort all changes?`
  String get dialogBackToViewModeContent {
    return Intl.message(
      'Abort all changes?',
      name: 'dialogBackToViewModeContent',
      desc: '',
      args: [],
    );
  }

  /// `EDIT`
  String get pagePassDetailToolbarActionEditTitle {
    return Intl.message(
      'EDIT',
      name: 'pagePassDetailToolbarActionEditTitle',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get pagePassDetailToolbarActionDoneTitle {
    return Intl.message(
      'Done',
      name: 'pagePassDetailToolbarActionDoneTitle',
      desc: '',
      args: [],
    );
  }

  /// `Empty.`
  String get pagePassDetailEmpty {
    return Intl.message(
      'Empty.',
      name: 'pagePassDetailEmpty',
      desc: '',
      args: [],
    );
  }

  /// `No Label`
  String get pagePassDetailExtraInfoFieldNoLabel {
    return Intl.message(
      'No Label',
      name: 'pagePassDetailExtraInfoFieldNoLabel',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get pagePassDetailPasswordFieldLabel {
    return Intl.message(
      'Password',
      name: 'pagePassDetailPasswordFieldLabel',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get pageSettingsSettingEntryAppLanguageTitle {
    return Intl.message(
      'Language',
      name: 'pageSettingsSettingEntryAppLanguageTitle',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get pageSettingsSettingEntryAppLanguageValueEnglish {
    return Intl.message(
      'English',
      name: 'pageSettingsSettingEntryAppLanguageValueEnglish',
      desc: '',
      args: [],
    );
  }

  /// `Simplified Chinese`
  String get pageSettingsSettingEntryAppLanguageValueSimplifiedChinese {
    return Intl.message(
      'Simplified Chinese',
      name: 'pageSettingsSettingEntryAppLanguageValueSimplifiedChinese',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get pageSettingsSettingEntryVersionTitle {
    return Intl.message(
      'Version',
      name: 'pageSettingsSettingEntryVersionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Value must not be null!`
  String get pagePassDetailNewExtraInfoEntryValueError {
    return Intl.message(
      'Value must not be null!',
      name: 'pagePassDetailNewExtraInfoEntryValueError',
      desc: '',
      args: [],
    );
  }

  /// `Key`
  String get pagePassDetailNewExtraInfoEntryHintKey {
    return Intl.message(
      'Key',
      name: 'pagePassDetailNewExtraInfoEntryHintKey',
      desc: '',
      args: [],
    );
  }

  /// `Value`
  String get pagePassDetailNewExtraInfoEntryHintValue {
    return Intl.message(
      'Value',
      name: 'pagePassDetailNewExtraInfoEntryHintValue',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get dialogDeletePassTitle {
    return Intl.message(
      'Delete',
      name: 'dialogDeletePassTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete {filename}}?`
  String dialogDeletePassContent(Object filename) {
    return Intl.message(
      'Are you sure you want to delete $filename}?',
      name: 'dialogDeletePassContent',
      desc: '',
      args: [filename],
    );
  }

  /// `{filename} created.`
  String pageLibrarySnackMsgFilenameCreated(Object filename) {
    return Intl.message(
      '$filename created.',
      name: 'pageLibrarySnackMsgFilenameCreated',
      desc: '',
      args: [filename],
    );
  }

  /// `Error: {error}`
  String pageLibrarySnackMsgError(Object error) {
    return Intl.message(
      'Error: $error',
      name: 'pageLibrarySnackMsgError',
      desc: '',
      args: [error],
    );
  }

  /// `You should setting up pass store path first.`
  String get errorMessageYouShouldSettingUpPassStorePathFirst {
    return Intl.message(
      'You should setting up pass store path first.',
      name: 'errorMessageYouShouldSettingUpPassStorePathFirst',
      desc: '',
      args: [],
    );
  }

  /// `OTP`
  String get pagePassDetailOtpFieldLabel {
    return Intl.message(
      'OTP',
      name: 'pagePassDetailOtpFieldLabel',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(
          languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
