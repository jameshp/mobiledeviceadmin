// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('main_app.html')
library mobiledeviceadmin.lib.main_app;

import 'dart:html';

import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/iron_pages.dart';
import 'package:polymer_elements/paper_icon_item.dart';
import 'package:polymer_elements/paper_tab.dart';
import 'package:polymer_elements/paper_tabs.dart';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

//app layout imports
import 'package:polymer_app_layout/app_drawer_layout.dart';
import 'package:polymer_app_layout/app_drawer.dart';
import 'package:polymer_app_layout/app_header_layout.dart';
import 'package:polymer_app_layout/app_header.dart';
import 'package:polymer_app_layout/app_toolbar.dart';
import 'package:polymer_app_layout/app_scroll_effects.dart';


//style imports
import 'package:polymer_elements/color.dart';
import 'package:polymer_elements/typography.dart';
import 'package:polymer_elements/default_theme.dart';

//own custom elements imports
import 'package:mobiledeviceadmin/device_list.dart';
import 'package:mobiledeviceadmin/file_upload.dart';

/// Uses [PaperInput]
@PolymerRegister('main-app')
class MainApp extends PolymerElement {
  @property
  String text;

  @property
  bool searchTextHidden = true;

  @reflectable
  toggleSearch([_, __]) {
      set('searchTextHidden', !this.searchTextHidden);
  }

  @Property(notify: true, observer: 'selectedChanged')
  int selected = 0; //default selected tab


  // Constructor used to create instance of MainApp.
  MainApp.created() : super.created();

  @reflectable
  String reverseText(String text) {
    return text.split('').reversed.join('');
  }

  @reflectable
  selectedChanged(newValue,oldValue){
       print ("Seleced changed from {$oldValue} to {$newValue}");
  }

  // @reflectable
  // void drawerChanged(String newState, String oldState) {
  //     print ("$newState  <-->  $oldState");
  // }

  // Optional lifecycle methods - uncomment if needed.

//  /// Called when an instance of main-app is inserted into the DOM.
//  attached() {
//    super.attached();
//  }

//  /// Called when an instance of main-app is removed from the DOM.
//  detached() {
//    super.detached();
//  }

//  /// Called when an attribute (such as a class) of an instance of
//  /// main-app is added, changed, or removed.
//  attributeChanged(String name, String oldValue, String newValue) {
//    super.attributeChanged(name, oldValue, newValue);
//  }

 /// Called when main-app has been fully prepared (Shadow DOM created,
 /// property observers set up, event listeners attached).
 ready() {

 }
}
