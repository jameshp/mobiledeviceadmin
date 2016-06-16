@HtmlImport('file_upload.html')
library mobiledeviceadmin.lib.file_upload;

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

import 'dart:convert' show HtmlEscape;
import 'dart:convert';

/// Uses [PaperInput]
@PolymerRegister('file-upload')
class FileUpload extends PolymerElement {

    InputElement _fileInput;
    Element _dropZone;
    OutputElement _output;
    HtmlEscape sanitizer = new HtmlEscape();

    @Property(notify:true)
    Map content;
    //
    // @property
    // bool searchTextHidden = true;

    // @reflectable
    // toggleSearch([_, __]) {
    //     set('searchTextHidden', !this.searchTextHidden);
    // }
    //
    // @Property(notify: true, observer: 'selectedChanged')
    // int selected = 0; //default selected tab


    // Constructor used to create instance of MainApp.
    FileUpload.created() : super.created();

    // @reflectable
    // String reverseText(String text) {
    //   return text.split('').reversed.join('');
    // }
    //
    // @reflectable
    // selectedChanged(newValue,oldValue){
    //      print ("Seleced changed from {$oldValue} to {$newValue}");
    // }

    // @reflectable
    // void drawerChanged(String newState, String oldState) {
    //     print ("$newState  <-->  $oldState");
    // }



    /// Called when main-app has been fully prepared (Shadow DOM created,
    /// property observers set up, event listeners attached).
    ready() {
        _output = $$('#list');
        _fileInput = $$('#files');
        _fileInput.onChange.listen((e) => _onFileInputChange());

        _dropZone = $$('#drop-zone');
        _dropZone.onDragOver.listen(_onDragOver);
        _dropZone.onDragEnter.listen((e) => _dropZone.classes.add('hover'));
        _dropZone.onDragLeave.listen((e) => _dropZone.classes.remove('hover'));
        _dropZone.onDrop.listen(_onDrop);
    }

    void _onDragOver(MouseEvent event) {
        event.stopPropagation();
        event.preventDefault();
        event.dataTransfer.dropEffect = 'copy';
    }

    void _onDrop(MouseEvent event) {
        event.stopPropagation();
        event.preventDefault();
        _dropZone.classes.remove('hover');
        _onFilesSelected(event.dataTransfer.files);
    }

    void _onFileInputChange() {
        //_onFilesSelected((_fileInput as InputElement).files);
        _onFilesSelected(_fileInput.files);
    }

    @reflectable
    void FilesChanged(event,__){
        print ("Files Changed fired! {$event}  : {$__}");
        _onFilesSelected(_fileInput.files);
    }

    void _onFilesSelected(List<File> files) {
        _output.nodes.clear();
        var list = new Element.tag('ul');
        for (var file in files) {
            var item = new Element.tag('li');

            // If the file is an image, read and display its thumbnail.
            if (true /*file.type.endsWith('txt')*/) {
                //var thumbHolder = new Element.tag('span');
                var reader = new FileReader();
                reader.onLoad.listen((e) {
                    //print (reader.result);
                    var content = reader.result;
                    Map jsonmap= JSON.decode(content);
                    print ("MAP set to content attribute: $jsonmap");
                    set('content',jsonmap);
                    // var thumbnail = new ImageElement(src: reader.result);
                    // thumbnail.classes.add('thumb');
                    // thumbnail.title = sanitizer.convert(file.name);
                    // thumbHolder.nodes.add(thumbnail);
                });
                reader.readAsText(file);
                //item.nodes.add(thumbHolder);
            }

            // For all file types, display some properties.
            var properties = new Element.tag('span');
            properties.innerHtml = (new StringBuffer('<strong>')
            ..write(sanitizer.convert(file.name))
            ..write('</strong> (')
            ..write(file.type != null ? sanitizer.convert(file.type) : 'n/a')
            ..write(') ')
            ..write(file.size)
            ..write(' bytes')
            // TODO(jason9t): Re-enable this when issue 5070 is resolved.
            // http://code.google.com/p/dart/issues/detail?id=5070
            // ..add(', last modified: ')
            // ..add(file.lastModifiedDate != null ?
            //       file.lastModifiedDate.toLocal().toString() :
            //       'n/a')
        ).toString();
        item.nodes.add(properties);
        list.nodes.add(item);
    }
    _output.nodes.add(list);
}
}
