import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_scout/view.dart';





class EditNotePage extends StatefulWidget {
    EditNotePage({Key key}): super(key: key);
    //final Function(String) callback;

    //EditNotePage(this.callback);

    @override
    EditNotePageState createState() => EditNotePageState();
}



class EditNotePageState extends State<EditNotePage> {
    final controller = TextEditingController();
    TextEditingController text_controller;
    bool selected;
    //TextEditingController text_controller = new TextEditingController();

    @override
    void initState() {
        super.initState();
        text_controller = TextEditingController(
            //text: "Placeholder note text",
        );
        selected = false;
    }


    @override
    Widget build(BuildContext context) {


        text_controller.addListener(() {
            setState(() {
                selected = text_controller.selection.baseOffset
                    != text_controller.selection.extentOffset;
            });
        });

        List<Widget> actions = [];

        if (selected) {
            actions.add(IconButton(
                icon: Icon(Icons.content_cut),
                onPressed: () {
                    int start = text_controller.selection.baseOffset;

                    Clipboard.setData(ClipboardData(text: text_controller.text.substring(start, text_controller.selection.extentOffset)));
                    text_controller.text = text_controller.text.substring(0, start) + text_controller.text.substring(text_controller.selection.extentOffset, text_controller.text.length);

                    text_controller.selection = TextSelection.collapsed(offset: start);
                }
            ));
            actions.add(IconButton(
                icon: Icon(Icons.content_copy),
                onPressed: () {
                    Clipboard.setData(ClipboardData(text: text_controller.text.substring(text_controller.selection.baseOffset, text_controller.selection.extentOffset)));
                }
            ));
        } else {
            actions.add(IconButton(
                icon: Icon(Icons.undo),
                onPressed: () {
                    print("FIXME: Undo");
                }
            ));
            actions.add(IconButton(
                icon: Icon(Icons.redo),
                onPressed: () {
                    print("FIXME: Redo");
                }
            ));
        }

        actions.add(IconButton(
            icon: Icon(Icons.select_all),
            onPressed: () {
                text_controller.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: text_controller.text.length,
                );
            }
        ));
        actions.add(IconButton(
            icon: Icon(Icons.content_paste),
            onPressed: () {
                int start = text_controller.selection.baseOffset;
                int end = text_controller.selection.extentOffset;

                Clipboard.getData("text/plain").then((clip) {
                    String new_text = clip.text;

                    int new_end = end + new_text.length - (end - start);

                    text_controller.text = text_controller.text.substring(0, start) + new_text + text_controller.text.substring(end, text_controller.text.length);

                    text_controller.selection = TextSelection.collapsed(offset: new_end);
                });
            }
        ));


        return Scaffold(
            appBar: AppBar(
                title: Text("Edit Note"),
                actions: actions,
            ),

            body: TextField(
                controller: this.controller,
                //This is to make sure the Area to type is the whole page
                autofocus: true,
                maxLines: null,
                minLines: null,
                expands: true,
                toolbarOptions: ToolbarOptions(
                    copy: false, cut: false, paste: false, selectAll: false
                ),
                decoration: InputDecoration(
                    //prefixIcon: Icon(Icons.message),
                    labelText: 'What would You like to note down?',
                ),

            ),
            floatingActionButton: FloatingActionButton(
                child: Text("Done"),
                //color: Color.fromARGB(0xFF, 0x00, 0xc8, 0xff),
                onPressed: () {
                    print(controller.text);





                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context){
                            return ViewNotePage(mode: ViewNoteMode.Owned);
                        }
                        ));
                }
            ),
        );
    }
}

class TextInputWidget extends StatefulWidget {
    final Function(String) callback;

    TextInputWidget(this.callback);

    @override
    _TextInputWidgetState createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
    final controller = TextEditingController();

    @override
    void dispose() {
        super.dispose();
        controller.dispose();
    }

    void click() {
        widget.callback(controller.text);
        FocusScope.of(context).unfocus();
        controller.clear();
    }

    @override
    Widget build(BuildContext context) {
        return TextField(
            controller: this.controller,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.message),
                labelText: "Type a message:",
                suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    splashColor: Colors.blue,
                    tooltip: "Post message",
                    onPressed: this.click,
                )));
    }
}