// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_Hans_CN locale. All the
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
  String get localeName => 'zh_Hans_CN';

  static String m0(path) => "当前路径：${path}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appName": MessageLookupByLibrary.simpleMessage("flupass"),
        "dialogBackToViewModeButtonAbort":
            MessageLookupByLibrary.simpleMessage("放弃"),
        "dialogBackToViewModeButtonCancel":
            MessageLookupByLibrary.simpleMessage("取消"),
        "dialogBackToViewModeContent":
            MessageLookupByLibrary.simpleMessage("放弃所有更改吗？"),
        "dialogBackToViewModeTitle":
            MessageLookupByLibrary.simpleMessage("返回查看模式"),
        "dialogEnterPassphraseButtonOk":
            MessageLookupByLibrary.simpleMessage("OK"),
        "dialogEnterPassphraseTitle":
            MessageLookupByLibrary.simpleMessage("输入你的密码"),
        "dialogNewFolderButtonCreate":
            MessageLookupByLibrary.simpleMessage("创建"),
        "dialogNewFolderCurrentPath": m0,
        "dialogNewFolderHintFolderName":
            MessageLookupByLibrary.simpleMessage("文件夹名称"),
        "dialogNewFolderInvalidHintFolderName":
            MessageLookupByLibrary.simpleMessage("请输入合法的文件夹名称"),
        "dialogNewFolderTitle": MessageLookupByLibrary.simpleMessage("新的文件夹"),
        "dialogNewPassButtonCreate": MessageLookupByLibrary.simpleMessage("创建"),
        "dialogNewPassHelperPassName":
            MessageLookupByLibrary.simpleMessage("文件名将会以 .gpg 后缀名结尾"),
        "dialogNewPassHintInvalidHintPassName":
            MessageLookupByLibrary.simpleMessage("请输入合法的文件名"),
        "dialogNewPassHintPassName":
            MessageLookupByLibrary.simpleMessage("密码文件名"),
        "dialogNewPassTitle": MessageLookupByLibrary.simpleMessage("新的密码"),
        "pageLibraryDialActionNewFolder":
            MessageLookupByLibrary.simpleMessage("新的文件夹"),
        "pageLibraryDialActionNewPass":
            MessageLookupByLibrary.simpleMessage("新的密码"),
        "pageLibraryDialCreate": MessageLookupByLibrary.simpleMessage("创建"),
        "pagePassDetailExtraInfoFieldNoLabel":
            MessageLookupByLibrary.simpleMessage("无标签"),
        "pagePassDetailNoExtraInfos":
            MessageLookupByLibrary.simpleMessage("无内容。"),
        "pagePassDetailPasswordFieldLabel":
            MessageLookupByLibrary.simpleMessage("密码"),
        "pagePassDetailToolbarActionDoneTitle":
            MessageLookupByLibrary.simpleMessage("完成"),
        "pagePassDetailToolbarActionEditTitle":
            MessageLookupByLibrary.simpleMessage("编辑"),
        "pagePasswordGeneratorButtonCopy":
            MessageLookupByLibrary.simpleMessage("复制"),
        "pagePasswordGeneratorButtonGenerate":
            MessageLookupByLibrary.simpleMessage("生成"),
        "pagePasswordGeneratorOptionEntryLengthTitle":
            MessageLookupByLibrary.simpleMessage("长度"),
        "pagePasswordGeneratorOptionEntryLowercaseTitle":
            MessageLookupByLibrary.simpleMessage("a-z"),
        "pagePasswordGeneratorOptionEntryNumberTitle":
            MessageLookupByLibrary.simpleMessage("123"),
        "pagePasswordGeneratorOptionEntrySymbolsTitle":
            MessageLookupByLibrary.simpleMessage("!@#"),
        "pagePasswordGeneratorOptionEntryUppercaseTitle":
            MessageLookupByLibrary.simpleMessage("A-Z"),
        "pagePasswordGeneratorSnackMsgCopied":
            MessageLookupByLibrary.simpleMessage("已复制"),
        "pagePasswordGeneratorSnackMsgFailedToCopy":
            MessageLookupByLibrary.simpleMessage("复制失败"),
        "pagePasswordGeneratorTitle":
            MessageLookupByLibrary.simpleMessage("密码生成器"),
        "pageSettingsSettingEntryAppLanguageTitle":
            MessageLookupByLibrary.simpleMessage("语言"),
        "pageSettingsSettingEntryAppLanguageValueEnglish":
            MessageLookupByLibrary.simpleMessage("英文"),
        "pageSettingsSettingEntryAppLanguageValueSimplifiedChinese":
            MessageLookupByLibrary.simpleMessage("简体中文"),
        "pageSettingsSettingEntryPassStoreLibraryLocationTitle":
            MessageLookupByLibrary.simpleMessage("密码库路径"),
        "pageSettingsSettingEntryPassphraseTitle":
            MessageLookupByLibrary.simpleMessage("密码"),
        "pageSettingsSettingEntryPrivateKeyTitle":
            MessageLookupByLibrary.simpleMessage("私钥"),
        "pageSettingsSettingEntryPublicKeyTitle":
            MessageLookupByLibrary.simpleMessage("公钥"),
        "pageSettingsSettingEntryValueSet":
            MessageLookupByLibrary.simpleMessage("已设定"),
        "pageSettingsSettingEntryValueUnset":
            MessageLookupByLibrary.simpleMessage("未设定"),
        "pageSettingsSettingEntryVersionTitle":
            MessageLookupByLibrary.simpleMessage("版本"),
        "pageSettingsTitle": MessageLookupByLibrary.simpleMessage("设置"),
        "viewPassDetailButtonDelete": MessageLookupByLibrary.simpleMessage("删除")
      };
}
