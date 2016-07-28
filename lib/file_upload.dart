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
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';


//style imports
import 'package:polymer_elements/color.dart';
import 'package:polymer_elements/typography.dart';
import 'package:polymer_elements/default_theme.dart';

import 'dart:convert' show HtmlEscape;
import 'dart:convert';

//todo - usage for
class UploadFile extends JsProxy {
  @reflectable
  String fileName;

  @reflectable
  int fileSize;

  @reflectable
  String fileType;

  @reflectable
  String content;

  @reflectable
  Map responseContent;

  @reflectable
  int uploadProgress;

  @reflectable
  int loadProgress;

  @reflectable
  String error;

  @reflectable
  File file;

  UploadFile(File file) {
    this.file = file;
    this.fileName = file.name;
    this.fileSize = file.size;
    this.fileType = file.type;
    this.loadProgress = 0;
    this.uploadProgress = 0;
  }
}

@PolymerRegister('file-upload')
class FileUpload extends PolymerElement {
  InputElement _fileInput;
  Element _dropZone;
  OutputElement _output;
  HtmlEscape sanitizer = new HtmlEscape();

  @property
  String url; //Upload URL

  @property
  bool auto = false; //automatic upload

  @Property(notify: true)
  int uploadProgress; //upload progress when sent to a server

  @Property(notify: true)
  String error; //upload progress when sent to a server

  @Property(notify: true)
  List<UploadFile> files = [];

  @reflectable
  void clicked(_, __) {
    print("Do Upload clicked");
    doFileUpload();
  }

  // Constructor used to create instance of MainApp.
  FileUpload.created() : super.created();

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
    _onFilesSelected(_fileInput.files);
  }

  //called when file reader api finished loading
  void _onLoad(UploadFile f, FileReader _reader) {
    var index = files.indexOf(f);
    print("index: ${index}");
    var path = "files.${index}.content";
    print("path: ${path}");
    set(path, _reader.result);

    path = "files.${index}.loadProgress";
    set(path, 100);
    //print (reader.result);
    //var content = _reader.result;
    // Map jsonmap = JSON.decode(content);
    // print("MAP set to content attribute: $jsonmap");
    // set('content', content);
    // set('loadProgress', 100);

    if (auto) {
      doFileUpload(f);
    }
    // var thumbnail = new ImageElement(src: reader.result);
    // thumbnail.classes.add('thumb');
    // thumbnail.title = sanitizer.convert(file.name);
    // thumbHolder.nodes.add(thumbnail);
  }

  //called while file reader API is in progress of loading the whole file
  //sets the progress attribute to the corresponding progress value
  //Note: future improvement: breaking file upload into junks
  void _onProgress(ProgressEvent event, UploadFile f) {
    print("on Progress called");
    if (event.lengthComputable) {
      var percentLoaded = (100 * event.loaded / event.total).round().toInt();
      print(
          "percent loaded: $percentLoaded - ${event.loaded}  from ${event.total} ");

      var index = files.indexOf(f);
      print("index: ${index}");
      var path = "files.${index}.loadProgress";
      print("path: ${path}");
      set(path, percentLoaded);
    }
  }

  //calle in case of some error  - sets the error property
  void _onError(UploadFile f, FileReader _reader) {
    print("ON ERROR called");
    var index = files.indexOf(f);
    print("index: ${index}");
    var path = "files.${index}.error";
    print("path: ${path}");
    switch (_reader.error.code) {
      case FileError.NOT_FOUND_ERR:
        set(path, 'File not found!');
        //window.alert('File not found!');
        break;
      case FileError.NOT_READABLE_ERR:
        set(path, 'File not found!');
        //window.alert('File is not readable.');
        break;
      case FileError.ABORT_ERR:
        set(path, 'Abort Error!');
        break; // no-op.
      default:
        set(path, 'An error occurred reading this file.');
        //window.alert('An error occurred reading this file.');
        break;
    }
  }

  void _onFilesSelected(List<File> files) {
    _output.nodes.clear();
    var list = new Element.tag('ul');
    clear('files');
    for (var file in files) {
      var item = new Element.tag('li');
      // If the file is an image, read and display its thumbnail.
      if (true /*file.type.endsWith('txt')*/) {
        UploadFile f = new UploadFile(file);
        add('files', f);
        readFileContent(f);
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
          )
          .toString();
      item.nodes.add(properties);
      list.nodes.add(item);
    }
    _output.nodes.add(list);
  }

  void readFileContent(UploadFile f) {
    FileReader _reader = new FileReader();
    _reader.onProgress.listen((e) => _onProgress(e, f));
    _reader.onError.listen((e) => _onError(f, _reader));
    _reader.onLoad.listen((e) => _onLoad(f, _reader));
    _reader.readAsText(f.file);
    //_reader.readAsDataUrl(f.file);
  }

  @Observe('files.*')
  void filesChanged(Map changeRecord) {
    if (changeRecord['path'] == 'files.splices') {
      print("the files list changed -wohoo!");
      print("Change Record Path: ${changeRecord['path']}");
      print("Change Record Value: ${changeRecord['value']}");
    } else {
      print("Change Record Path: ${changeRecord['path']}");
      print("Change Record Value: ${changeRecord['value']}");
      // an individual user or its sub-properties changed
      // check "changeRecord.path" to determine what changed
    }
  }

  void doFileUpload([UploadFile uploadFile]) {
    print("Real File Uploads started");
    List<UploadFile> processFiles = [];

    if (url == "") {
      set('error', "no URL defined");
      return;
    }

    //to switch between auto upload and manual triggerd
    if (uploadFile != null) {
      processFiles.add(uploadFile);
    } else {
      processFiles = this.files;
    }

    for (UploadFile f in files) {
      var index = files.indexOf(f);
      var path = "files.${index}.uploadProgress";
      set(path, 0);

      final blob = new Blob([f.content], 'text/plain');
      FormData fdata = new FormData(); // from dart:html
      fdata.appendBlob("appConfig", blob, f.fileName);
      fdata.append("fileName", f.fileName);
      fdata.append("fileSize", f.fileSize.toString());
      //fdata.appendBlob("file2", data, "file2 super filename.txt"); //I thought this would set the filename... but it does not.

      HttpRequest req = new HttpRequest();
      req.open("POST", url, async: true);
      //req.setRequestHeader("Content-type", "multipart/form-data");  //this works on chrome and firefox, but edge doubles the "multipart/form-adat" entry)
      req.send(fdata);
      req.onProgress.listen((e) => _onUploadProgress(e, f));
      req.onError.listen((e) => _onUploadError(e, f));
      req.onReadyStateChange.listen((Event e) {
        if (req.readyState == HttpRequest.DONE &&
            (req.status == 200 || req.status == 0)) {
          var  result = JSON.decode(req.responseText);
          print (result);
          set('files.${index}.responseContent', result);
          set(path, 100);
        }
        if (req.readyState == HttpRequest.DONE &&(req.status == 500)){
          var errorResult = JSON.decode(req.responseText);
          var reason = errorResult['error']['errors'][0]['reason'];
          set('files.${index}.error', reason);
        }
      });
    }
  }

  void _onUploadError(ProgressEvent event, UploadFile f) {
    var index = files.indexOf(f);
    var path = "files.${index}.error";
    print("error path: ${path}");
    // HttpRequest x = event.target;
    // print ("unsent status: ${HttpRequest.UNSENT}");
    // print (x);
    // error = x.statusText + " : " + x.status.toString() + " : " + x.readyState.toString();
    set(path, "Upload failed");
    //window.alert('An error occurred uploading this file. ${error}');
  }

  void _onUploadProgress(ProgressEvent event, UploadFile f) {
    print("Real File Upload on Progress called");
    var index = files.indexOf(f);
    print("index: ${index}");
    var path = "files.${index}.uploadProgress";
    print("path: ${path}");

    if (event.lengthComputable) {
      var percentLoaded = (100 * event.loaded / event.total).round().toInt();
      set(path, percentLoaded);
    }
  }
}
