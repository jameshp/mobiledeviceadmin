// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('add_appsettings.html')
library mobiledeviceadmin.lib.add_appsettings;

import 'dart:html';
import 'dart:core';

import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_icon_item.dart';
import 'package:polymer_elements/paper_item_body.dart';
import 'package:polymer_elements/paper_spinner.dart';
import 'package:polymer_elements/paper_progress.dart';
import 'package:polymer_elements/iron_ajax.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/hardware_icons.dart';
import 'package:polymer_elements/maps_icons.dart';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

//paper dialog imports
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/neon_animation.dart';
import 'package:polymer_elements/neon_animatable.dart';
import 'package:polymer_elements/neon_animation/animations/scale_up_animation.dart';
import 'package:polymer_elements/neon_animation/animations/fade_out_animation.dart';


import 'package:mobiledeviceadmin/file_upload.dart';



/// Uses [PaperInput]
@PolymerRegister('add-appsettings')
class AddAppsettings extends PolymerElement {

  PaperDialog dialog;
  /// Constructor used to create instance of MainApp.
  AddAppsettings.created() : super.created();

 /// Called when main-app has been fully prepared (Shadow DOM created,
 /// property observers set up, event listeners attached).
  ready() {
    print ("ADD App Settings Dialog item created");
    dialog = this.$$('#dialog');
    print ("PAPER DIALOG ${dialog}");
  }
}
