import 'package:flutter/material.dart';
import 'package:mafiagame/generated/l10n.dart';

class Validator {
  final BuildContext _context;
  Validator._(this._context);

  static Validator of(BuildContext context) {
    return Validator._(context);
  }

  /// Поле не может быть пустым
  String? notEmpty(String? value) {
    if (value == null || value.isEmpty) return S.of(_context).emptyFieldError;
    final checkValue = value.replaceAll(RegExp(r"\s+\b|\b\s|\s|\b"), "");
    if (checkValue.isEmpty) return S.of(_context).emptyFieldError;

    return null;
  }

  String? validateMobile(String? value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  // /// Вы должны ввести как минимум [length] символов
  // String? moreOrEqual(int length, String? value) {
  //   if (value == null || value.isEmpty || value.length < length) {
  //     return S.of(_context).notEnoughCharacters(length);
  //   }
  //   return null;
  // }

  /// Email не может быть пустым и должен содержать валидные символы
  String? isEmail(String? value) {
    if (notEmpty(value) != null) {
      return notEmpty(value);
    }
    if (!RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(value!)) return S.of(_context).invalidEmail;
    return null;
  }

  /// Должно быть числовое значение
  // String? isNumber(String? value) {
  //   final String? emptyCheck = notEmpty(value);
  //   if (emptyCheck != null) {
  //     return emptyCheck;
  //   }

  //   final int? number = int.tryParse(value!);

  //   if (number == null) {
  //     return S.of(_context).numberFieldError;
  //   }
  //   return null;
  // }

  // /// Номер телефона должен содержать валидные символы
  // String? isPhoneNumber(String? value) {
  //   final String? emptyCheck = notEmpty(value);
  //   if (emptyCheck != null) {
  //     return emptyCheck;
  //   }
  //   final regExp = RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$');

  //   if (!regExp.hasMatch(value!)) {
  //     return S.of(_context).phoneFieldError;
  //   }
  //   return null;
  // }

  // /// Должно быть числовое положительное значение
  // String? positive(String? value) {
  //   final String? emptyCheck = notEmpty(value);
  //   if (emptyCheck != null) {
  //     return emptyCheck;
  //   }
  //   final String? isRealNumber = isNumber(value);
  //   if (isRealNumber != null) {
  //     return isRealNumber;
  //   }

  //   final int number = int.parse(value!);
  //   if (number < 1) {
  //     return S.of(_context).mustBePositive;
  //   }
  //   return null;
  // }

  /// Базовый validator для пароля
  String? basePasswordValidator(String? value) {
    if (value == null) {
      return S.of(_context).emptyFieldError;
    }
    if (value.length < 8) {
      return S.of(_context).fewPasswordSymbols;
    }
    return null;
  }

  String? isPasswordMatch(String? value, String? oldValue) {
    if (value == null) {
      return S.of(_context).emptyFieldError;
    }
    if (value != oldValue) {
      return S.of(_context).password_doesnt_match;
    }
    return null;
  }

  /// Недопустимые символы контактных данных
  // String? contactMessenger(String? value) {
  //   if (value == null) return null;
  //   if (value.contains(RegExp(r'[!#$%^*]'))) {
  //     return S.of(_context).contactValidationError;
  //   }
  //   return null;
  // }
}
