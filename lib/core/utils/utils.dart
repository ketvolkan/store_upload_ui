import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:process_run/process_run.dart';
import 'package:store_upload_ui/app/modules/project_list/project_list_controller.dart';
import 'package:store_upload_ui/core/constants/app_constants.dart';
import 'package:store_upload_ui/core/models/project_model.dart';
import 'package:xml/xml.dart';
import 'package:yaml/yaml.dart';

Future<R?> errorHandler<R>({required Future<R?> Function() tryMethod, required Future<R?> Function() onErr}) async {
  try {
    return await tryMethod();
  } catch (exception) {
    debugPrint(exception.toString());
    return await onErr();
  }
}

class Utils {
  //Textsize
  static double get extraLowTextSize => Get.height * 0.012;
  static double get lowTextSize => Get.height * 0.015;
  static double get normalTextSize => Get.height * 0.018;
  static double get highTextSize => Get.height * 0.022;
  static double get extraHighTextSize => Get.height * 0.025;

  //Padding
  static double get extraLowPadding => Get.height * 0.005;
  static double get lowPadding => Get.height * 0.01;
  static double get normalPadding => Get.height * 0.015;
  static double get highPadding => Get.height * 0.02;
  static double get extraHighPadding => Get.height * 0.025;

  //Radius
  static double get extraLowRadius => Get.height * 0.01;
  static double get lowRadius => Get.height * 0.015;
  static double get normalRadius => Get.height * 0.02;
  static double get highRadius => Get.height * 0.025;
  static double get extraHighRadius => Get.height * 0.035;

  //Icons
  static double get extraLowIconSize => Get.height * 0.015;
  static double get lowIconSize => Get.height * 0.02;
  static double get normalIconSize => Get.height * 0.025;
  static double get highIconSize => Get.height * 0.033;
  static double get extraHighIconSize => Get.height * 0.04;

  static double get appBarHeight => Get.height * 0.1;
}

extension CustomProjectModelExtensions on ProjectModel {
  Future<String> get getProjectName async {
    printLogOnProjectListPage("Serching Project Name...");
    if (Get.context == null) return "Project Name Not Found";
    if (path is! String) return "Project Name Not Found";
    Shell shell = Shell(workingDirectory: path);
    await processResultListToLog(await shell.run("git checkout $branch"));
    File manifestPath = File('$path${AppConstants.manifestPath}');
    String manifestContent = await manifestPath.readAsString();
    final XmlDocument document = XmlDocument.parse(manifestContent);
    final XmlElement? applicationNode = document.rootElement.findElements('application').firstOrNull;
    if (applicationNode != null) {
      final String? labelValue = applicationNode.getAttribute('android:label');
      printLogOnProjectListPage(labelValue ?? "Project Name Not Found");
      return (labelValue ?? "Project Name Not Found");
    } else {
      printLogOnProjectListPage("Project Name Not Found");
      return "Project Name Not Found";
    }
  }

  Future<List<String>> get branchList async {
    return (await errorHandler<List<String>>(
          tryMethod: () async {
            printLogOnProjectListPage("Getting Brach List...");
            List<String> branchListString = [];
            if (path is! String) return branchListString;
            Shell shell = Shell(workingDirectory: path);
            List<ProcessResult> result = await shell.run("git branch");
            for (var branch in result) {
              for (var line in (const LineSplitter().convert(branch.stdout))) {
                branchListString.add(line.replaceFirst("*", "").replaceAll(" ", ""));
                printLogOnProjectListPage(line.replaceFirst("*", "").replaceAll(" ", ""));
              }
            }
            printLogOnProjectListPage("Brach List Getted");
            return branchListString;
          },
          onErr: () async => [],
        ) ??
        []);
  }

  Future<String> get getVersionName async {
    String text = await errorHandler<String>(
          tryMethod: () async {
            printLogOnProjectListPage("Getting Version Name...");
            if (path is! String) return "";
            String folderPath = path ?? "";
            Shell shell = Shell(workingDirectory: path);
            await processResultListToLog(await shell.run("git checkout $branch"));
            File pubspecPath = File('$folderPath${AppConstants.pubspecYmlPath}');
            String versionName = (loadYaml(await pubspecPath.readAsString()) as Map)['version'].toString();
            printLogOnProjectListPage("Version Name Getted");
            return versionName;
          },
          onErr: () async => "",
        ) ??
        "";
    return text;
  }

  Future<bool> get setVersionName async {
    if (version == null) return false;
    await errorHandler<bool>(
          tryMethod: () async {
            printLogOnProjectListPage("Version Name Setting..");
            if (path is! String) return false;
            String folderPath = path ?? "";
            Shell shell = Shell(workingDirectory: path);
            await processResultListToLog(await shell.run("git checkout $branch"));
            File pubspecPath = File('$folderPath${AppConstants.pubspecYmlPath}');
            String oldVersionName = await getVersionName;
            String versionString = await pubspecPath.readAsString();
            versionString = versionString.replaceAll("version: $oldVersionName", "version: $version");
            pubspecPath.writeAsString(versionString);
            printLogOnProjectListPage("Version Name Setted");
            return true;
          },
          onErr: () async => false,
        ) ??
        false;
    return false;
  }

  Future<bool> get build async {
    if (version == null) return false;
    return await errorHandler<bool>(
          tryMethod: () async {
            printLogOnProjectListPage("Build is started...");
            await setVersionName;
            Shell shell = Shell(workingDirectory: "$path");
            Shell shellIos = Shell(workingDirectory: "$path/ios/");
            Shell shellAndroid = Shell(workingDirectory: "$path/android/");
            processResultListToLog(await shell.run("git checkout $branch"));
            if (ios ?? false) {
              printLogOnProjectListPage("Switched Folder Ios...");
              printLogOnProjectListPage("Ios Build Start..");
              await processResultListToLog(await shellIos.run("fastlane ios beta"));

              printLogOnProjectListPage("Ios Build Finish..");
            }
            if (android ?? false) {
              printLogOnProjectListPage("Switched Folder Android...");
              printLogOnProjectListPage("Android Build Start..");
              await processResultListToLog(await shellAndroid.run("fastlane android internal"));
              printLogOnProjectListPage("Android Build Finish..");
            }
            printLogOnProjectListPage("Build is Finish SUCCESS...");
            return true;
          },
          onErr: () async {
            printLogOnProjectListPage("Build is Finish With ERROR...");
            return false;
          },
        ) ??
        false;
  }
}

Future<void> processResultListToLog(List<ProcessResult> resultList) async {
  for (var log in resultList) {
    for (var line in const LineSplitter().convert(log.stdout)) {
      printLogOnProjectListPage(line);
    }
  }
}

void printLogOnProjectListPage(String log) {
  if (!Get.isRegistered<ProjectListController>()) return;
  final projectListController = Get.find<ProjectListController>();
  projectListController.log.add(log);
  projectListController.refreshLog;
}
