// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('appsettings_list.html')
library mobiledeviceadmin.lib.appsettings_list;

import 'dart:html';
import 'dart:core';

import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_material.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_icon_item.dart';
import 'package:polymer_elements/paper_item_body.dart';
import 'package:polymer_elements/iron_ajax.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:mobiledeviceadmin/appsettings_item.dart';

/// Uses [PaperInput]
@PolymerRegister('appsettings-list')
class AppsettingsList extends PolymerElement {

  IronAjax _appsettingsRequest;

  @property
  String url = "http://equipmentmanager.service.sitstlproxy.gpsllab.local/v1/appsettings";

  @Property(observer: 'ajaxErrorChanged')
  Object ajaxError;

  @property
  String error ="";

  @reflectable
  void ajaxErrorChanged(newValue, oldValue){
    print ("AjaxError_new: ${newValue}  + ${oldValue}");
    set('error', _appsettingsRequest.lastError);
    print ("Ajax Error2 : ${_appsettingsRequest.lastError}");
  }

  @reflectable
  void handleRequestError(event,target){
    print("handle Error $event - $target");
  }
  // @property
  // String headers = '{"Authorization" : "Basic dXNlcjE6cGFzc3dvcmQ="}';

  //'{"Origin" : "http://equipmentmanager.service.sitstlproxy.gpsllab.local"}';

  @Property(notify: true, observer: 'filterChanged', reflectToAttribute: true)
  String filter;


  @reflectable
  filterChanged(newValue,oldValue){
       print ("Search Filter changed from {$oldValue} to {$newValue}");
       ($$('#appsettingsList')as DomRepeat).render(); //call on each change of the filter attribute in oder that filterItems is executed
  }

  @reflectable
  filterItems(item){
    print ("filter items for:  {$item}");
    if (filter == ""){
      return true;
    }
    else if (filter == null){
      return true;
    }
    else {
      String description = item['description'];
      return description.contains(filter);
    }
  }

  @reflectable
  reloadList(){
    this._appsettingsRequest.generateRequest();
  }


  /// Constructor used to create instance of MainApp.
  AppsettingsList.created() : super.created();



 /// Called when main-app has been fully prepared (Shadow DOM created,
 /// property observers set up, event listeners attached).
  ready() {
      _appsettingsRequest = $$('#appsettingsRequest');
      print ("App Settings List init done");
  }
}
