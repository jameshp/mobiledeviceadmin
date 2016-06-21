// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('device_item.html')
library mobiledeviceadmin.lib.device_item;

import 'dart:html';
import 'dart:core';

import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_icon_item.dart';
import 'package:polymer_elements/paper_item_body.dart';
import 'package:polymer_elements/paper_spinner.dart';
import 'package:polymer_elements/iron_ajax.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/hardware_icons.dart';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

//import 'package:polymer_elements/iron_flex_layout.dart'; // to allow flexbox styling

/// Uses [PaperInput]
@PolymerRegister('device-item')
class DeviceItem extends PolymerElement {
  @property
  String data;


  /// Constructor used to create instance of MainApp.
  DeviceItem.created() : super.created();



 /// Called when main-app has been fully prepared (Shadow DOM created,
 /// property observers set up, event listeners attached).
  ready() {
    print ("device Item created");
  }
}
