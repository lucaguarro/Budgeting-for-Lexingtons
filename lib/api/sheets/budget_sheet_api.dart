import 'package:budgeting_for_lexingtons/model/expense.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gsheets/gsheets.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class BudgetSheetApi {
  static var _gsheets;

  static var _spreadsheetId; // = '1vAdGDUAxCP157ynkLQdlwR4DvE2ou_hQqLygbt-X2Zo';
  static Worksheet? _userSheet;

  static Future<bool> setSheetConnection() async {
    rootBundle.loadString('assets/sheet_creds.txt').then((value){
      _gsheets = GSheets(value);
    });
    try {
      _spreadsheetId = await readSheetID();
       var spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      _userSheet = await _getWorkSheet(spreadsheet, title: '2. Enter Data');
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/sheetid.txt');
  }

  static Future<File> writeSheetID(String sheetid) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString(sheetid);
  }

  static Future<String> readSheetID() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return '';
    }
  }

  static Future<Worksheet?> _getWorkSheet(
    Spreadsheet spreadsheet, {
      required String title,
    }) async {
      try {
        return await spreadsheet.addWorksheet(title);
      } catch (e) {
        return spreadsheet.worksheetByTitle(title);
      }
  }

  static Future insert(List<Map<String, dynamic>> rowList) async {
    if (_userSheet == null) return false;

    try {
      await _userSheet!.values.map.appendRows(rowList);
    } catch (e) {
      return false;
    }
    return true;
  }
}