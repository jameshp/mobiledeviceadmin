// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('appsettings_item.html')
library mobiledeviceadmin.lib.appsettings_item;

import 'dart:html';
import 'dart:core';

import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_icon_item.dart';
import 'package:polymer_elements/paper_item_body.dart';
import 'package:polymer_elements/paper_spinner.dart';
import 'package:polymer_elements/paper_toast.dart';
import 'package:polymer_elements/iron_ajax.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/hardware_icons.dart';
import 'package:polymer_elements/maps_icons.dart';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';


//import 'package:polymer_elements/iron_flex_layout.dart'; // to allow flexbox styling

/// Uses [PaperInput]
@PolymerRegister('Appsettings-item')
class AppsettingsItem extends PolymerElement {

  IronAjax releaseRequest;
  PaperToast toast;

  @property
  Map data;

  @Property(computed: 'isReleased(data.state)')
  bool released;


  @reflectable
  bool isReleased(String state){
    if (state == 'RELEASED'){
      return true;
    }
    else return false;
  }

  @reflectable
  releaseAppSettings(_,__){
    releaseRequest.generateRequest();

  }

  @reflectable
  handleResponse(_,__){
    Map response = releaseRequest.lastResponse;
    toast = $$('#toast');
    toast.duration = 10000;
    toast.text = "config was relased as verion ${response['version']}";
    toast.open();

  }

  /// Constructor used to create instance of MainApp.
  AppsettingsItem.created() : super.created();

 /// Called when main-app has been fully prepared (Shadow DOM created,
 /// property observers set up, event listeners attached).
  ready() {
    releaseRequest = $$('#ReleaseRequest');
    print ("AppSettings Item created");
  }
}
