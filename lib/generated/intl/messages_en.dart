// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(filename) => "Are you sure you want to delete ${filename}}?";

  static String m1(path) => "Current path: ${path}";

  static String m2(error) => "Error: ${error}";

  static String m3(filename) => "${filename} created.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appName": MessageLookupByLibrary.simpleMessage("flupass"),
        "dialogBackToViewModeContent":
            MessageLookupByLibrary.simpleMessage("Abort all changes?"),
        "dialogBackToViewModeTitle":
            MessageLookupByLibrary.simpleMessage("Back to view mode"),
        "dialogButtonAbort": MessageLookupByLibrary.simpleMessage("Abort"),
        "dialogButtonCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "dialogButtonCreate": MessageLookupByLibrary.simpleMessage("Create"),
        "dialogButtonDelete": MessageLookupByLibrary.simpleMessage("Delete"),
        "dialogButtonOk": MessageLookupByLibrary.simpleMessage("OK"),
        "dialogDeletePassContent": m0,
        "dialogDeletePassTitle": MessageLookupByLibrary.simpleMessage("Delete"),
        "dialogEnterPassphraseTitle":
            MessageLookupByLibrary.simpleMessage("Enter your passphrase"),
        "dialogNewFolderCurrentPath": m1,
        "dialogNewFolderHintFolderName":
            MessageLookupByLibrary.simpleMessage("Folder name"),
        "dialogNewFolderInvalidHintFolderName":
            MessageLookupByLibrary.simpleMessage(
                "Please enter a valid folder name"),
        "dialogNewFolderTitle":
            MessageLookupByLibrary.simpleMessage("New folder"),
        "dialogNewPassHelperPassName": MessageLookupByLibrary.simpleMessage(
            "Filename would be end up with .gpg"),
        "dialogNewPassHintInvalidHintPassName":
            MessageLookupByLibrary.simpleMessage(
                "Please enter a valid pass name"),
        "dialogNewPassHintPassName":
            MessageLookupByLibrary.simpleMessage("Pass name"),
        "dialogNewPassTitle": MessageLookupByLibrary.simpleMessage("New pass"),
        "errorMessageYouShouldSettingUpPassStorePathFirst":
            MessageLookupByLibrary.simpleMessage(
                "You should setting up pass store path first."),
        "pageLibraryDialActionNewFolder":
            MessageLookupByLibrary.simpleMessage("New folder"),
        "pageLibraryDialActionNewPass":
            MessageLookupByLibrary.simpleMessage("New pass"),
        "pageLibraryDialCreate": MessageLookupByLibrary.simpleMessage("Create"),
        "pageLibrarySnackMsgError": m2,
        "pageLibrarySnackMsgFilenameCreated": m3,
        "pagePassDetailEmpty": MessageLookupByLibrary.simpleMessage("Empty."),
        "pagePassDetailExtraInfoFieldNoLabel":
            MessageLookupByLibrary.simpleMessage("No Label"),
        "pagePassDetailNewExtraInfoEntryHintKey":
            MessageLookupByLibrary.simpleMessage("Key"),
        "pagePassDetailNewExtraInfoEntryHintValue":
            MessageLookupByLibrary.simpleMessage("Value"),
        "pagePassDetailNewExtraInfoEntryValueError":
            MessageLookupByLibrary.simpleMessage("Value must not be null!"),
        "pagePassDetailPasswordFieldLabel":
            MessageLookupByLibrary.simpleMessage("Password"),
        "pagePassDetailToolbarActionDoneTitle":
            MessageLookupByLibrary.simpleMessage("Done"),
        "pagePassDetailToolbarActionEditTitle":
            MessageLookupByLibrary.simpleMessage("EDIT"),
        "pagePasswordGeneratorButtonCopy":
            MessageLookupByLibrary.simpleMessage("Copy"),
        "pagePasswordGeneratorButtonGenerate":
            MessageLookupByLibrary.simpleMessage("Generate"),
        "pagePasswordGeneratorOptionEntryLengthTitle":
            MessageLookupByLibrary.simpleMessage("Length"),
        "pagePasswordGeneratorOptionEntryLowercaseTitle":
            MessageLookupByLibrary.simpleMessage("a-z"),
        "pagePasswordGeneratorOptionEntryNumberTitle":
            MessageLookupByLibrary.simpleMessage("123"),
        "pagePasswordGeneratorOptionEntrySymbolsTitle":
            MessageLookupByLibrary.simpleMessage("!@#"),
        "pagePasswordGeneratorOptionEntryUppercaseTitle":
            MessageLookupByLibrary.simpleMessage("A-Z"),
        "pagePasswordGeneratorSnackMsgCopied":
            MessageLookupByLibrary.simpleMessage("Copied"),
        "pagePasswordGeneratorSnackMsgFailedToCopy":
            MessageLookupByLibrary.simpleMessage("Failed to copy"),
        "pagePasswordGeneratorTitle":
            MessageLookupByLibrary.simpleMessage("Password Generator"),
        "pageSettingsSettingEntryAppLanguageTitle":
            MessageLookupByLibrary.simpleMessage("Language"),
        "pageSettingsSettingEntryAppLanguageValueEnglish":
            MessageLookupByLibrary.simpleMessage("English"),
        "pageSettingsSettingEntryAppLanguageValueSimplifiedChinese":
            MessageLookupByLibrary.simpleMessage("Simplified Chinese"),
        "pageSettingsSettingEntryPassStoreLibraryLocationTitle":
            MessageLookupByLibrary.simpleMessage("Pass store library location"),
        "pageSettingsSettingEntryPassphraseTitle":
            MessageLookupByLibrary.simpleMessage("Passphrase"),
        "pageSettingsSettingEntryPrivateKeyTitle":
            MessageLookupByLibrary.simpleMessage("Private key"),
        "pageSettingsSettingEntryPublicKeyTitle":
            MessageLookupByLibrary.simpleMessage("Public key"),
        "pageSettingsSettingEntryValueSet":
            MessageLookupByLibrary.simpleMessage("Set"),
        "pageSettingsSettingEntryValueUnset":
            MessageLookupByLibrary.simpleMessage("Unset"),
        "pageSettingsSettingEntryVersionTitle":
            MessageLookupByLibrary.simpleMessage("Version"),
        "pageSettingsTitle": MessageLookupByLibrary.simpleMessage("Settings"),
        "viewPassDetailButtonDelete":
            MessageLookupByLibrary.simpleMessage("Delete")
      };
}
