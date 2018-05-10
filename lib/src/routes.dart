import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/main_screen.dart';
import 'package:knuffiworkout/src/workout/edit_screen.dart';

typedef WidgetBuilder PathParser(List<String> pathSegments);

class AppRouteItem {
  AppRouteItem({this.title, this.path, this.buildWidget, this.pathParser});

  final String title;
  final String path;
  final WidgetBuilder buildWidget;
  final PathParser pathParser;

  void navigateTo(BuildContext context, {List<String> pathSegments}) {
    var resultPath = path;
    if (pathSegments != null && pathSegments.isNotEmpty) {
      resultPath = '$path/${pathSegments.join("/")}';
    }
    Navigator.of(context).pushNamed(resultPath);
  }
}

final mainScreen = new AppRouteItem(
    title: "Current workout",
    path: '/',
    buildWidget: (BuildContext context) => new MainScreen());

final editScreen = new AppRouteItem(
    title: "Edit workout",
    path: '/edit',
    pathParser: (List<String> pathSegments) {
      assert(pathSegments.length == 1);
      final splitDate = pathSegments.single.split('-').map(int.parse).toList();
      final date = new DateTime(splitDate[0], splitDate[1], splitDate[2]);
      return (BuildContext context) => new EditScreen(date);
    });

final directMappedRoutes = [mainScreen];
