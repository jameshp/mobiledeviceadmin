// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('device_list.html')
library mobiledeviceadmin.lib.device_list;

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

import 'package:mobiledeviceadmin/device_item.dart';

/// Uses [PaperInput]
@PolymerRegister('device-list')
class DeviceList extends PolymerElement {

  IronAjax _deviceRequest;

  @property
  String url = "http://equipmentmanager.service.sitstlproxy.gpsllab.local/v1/devices";

  @Property(observer: 'ajaxErrorChanged')
  Object ajaxError;

  @property
  String error ="";

  @reflectable
  void ajaxErrorChanged(newValue, oldValue){
    print ("AjaxError_new: ${newValue}  + ${oldValue}");
    set('error', _deviceRequest.lastError);
    print ("Ajax Error2 : ${_deviceRequest.lastError}");
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
       ($$('#deviceList')as DomRepeat).render(); //call on each change of the filter attribute in oder that filterItems is executed
  }

  @reflectable
  filterItems(item){
    print ("filter items for:  {$item}");
    if (filter == ""){
      return true;
    }
    else {
      String deviceID = item['deviceId'];
      return deviceID.contains(filter);
    }
  }

  // @Property(computed: 'computeFullName(first, last)')
  // String fullName;

  // @reflectable
  // String computeFullName(String first, String last) {
  //   return '$first $last';
  // }

  /// Constructor used to create instance of MainApp.
  DeviceList.created() : super.created();

  // @reflectable
  // String reverseText(String text) {
  //   return text.split('').reversed.join('');
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
      _deviceRequest = $$('#deviceRequest');
      print ("DevicList init done");
  }
}
