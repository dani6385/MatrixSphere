 
import 'package:flutter/material.dart';

class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
   
   @override
   void didPush(Route route, Route? previousRoute) {
     super.didPush(route, previousRoute);
     if (route is PageRoute) {
       print('Pushed: ${route.settings.name}');
     }
   }

   @override
   void didPop(Route route, Route? previousRoute) {
     super.didPop(route, previousRoute);
     if (route is PageRoute) {
       print('Popped: ${route.settings.name}');
     }
   }
}