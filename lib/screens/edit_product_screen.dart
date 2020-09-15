import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

// Adding Product and Editing Product to repopulate this Input
// when user validate wanna edit temporay this product
// when submit press save data in your app Wide State

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  // InputData: data can be changed externally by the constructor.
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

// using Forms & Working with Forms Input
// Form() build_Scrollable_List_of__Elements: ListView
// less Screen Available_ Form(child:fcol[SinglwChildScollView()])
// Form()

class _EditProductScreenState extends State<EditProductScreen> {
  // internal state: can't be recreated it's persistant it's attached to the class. The external data can be recreated but the state NO!

  // lecture: Column SingleCSV small device landscape => avoid data_lost
  // manage own controller not necessary: want to have value before form submitted
  // error: an input decorator cannot have unbound width..TextFormField(take infinite amount of width: wrap Expanded())
  // add an listener focusNode to previewImage when tap on new Fields
  // add our own _imageUrlFocusNode not to set Focus but add aur own Listener and when user loose focus to it we use the _imageUrlController to update UI and show a preview
  // inistate add a listener inits a function will be executed whenever the focus changes and removes it before dispose

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', imageUrl: '', description: '', price: 0);
  var _isInit = false; // I only run the logic if _isInit is true
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  // to initialize the values of our textForm: intialize it with the _initialize _editedProduct

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // fargs
    // when we run for the first time
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      // after we retrieving, we have to absolutely check if we have a Product before we continue
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context).findById(productId);
        // we now initalize _editedProduct with our product
        // f_initEdited
        // use String only cause TextFormFields works only with String
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        // _imageUrlController.text = _editedProduct.imageUrl;
        // onTextFormField: in
        // for image we can't set intialValues & controller: instead set controller to : _intialValues['image'];
        // don't set intialValue to imageUrl, set to null, imageUrl: '' and set: _imageUrlController.text = _editedProduct.imageUrl;
        // now call the edited product
        // NOW EDITING PRODUCT
      }

      // we now need to initalize all the form input with default values
    }

    // for future execution of didChangeDependencies we don't reinitialize our form
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

// if imageUrlFocusNode lost focus => we update the UI little hack
// if we have incorrect URL don't show a preview don't update
  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('png') &&
              !_imageUrlController.text.endsWith('jpg') &&
              !_imageUrlController.text.endsWith('jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();

    // if form is notValid we return nothing the submitting form cannot be executed
    if (!isValid) {
      return;
    }

    _form.currentState.save();
    // know if _editedProduct has an id: then updateProduct..else addProduct
    if (_editedProduct.id != null) {
      //
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      // make sure we don't loose Id & Favorite which will be bad!
    } else {
      // 2 differents approaches of how to send http.Request
      //

      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }

    Navigator.of(context).pop();

    // fedit_print
    // print(_editedProduct.title);
    // print(_editedProduct.price);
    // print(_editedProduct.description);
    // print(_editedProduct.imageUrl);
  }

  // internal state: can't be recreated it's persistant it's attached to the class. The external data can be recreated but the state NO!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      title: value,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value.';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      price: double.parse(value),
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      title: _editedProduct.title,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero.';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                //don't need textInputAction keybodarType auto gives InputAction
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.length < 10) {
                    return 'Should be at least 10 characters long.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      description: value,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(_imageUrlController.text,
                                fit: BoxFit.cover),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: _initValues['imageUrl'],
                      decoration: InputDecoration(labelText: 'Enter URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done, //form submission
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter an image URL.';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        }
                        if (!value.endsWith('png') &&
                            !value.endsWith('jpg') &&
                            !value.endsWith('jpeg')) {
                          return 'Please enter a value image URL';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: value,
                            price: _editedProduct.price,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// formsubmitting :URL done button   &&  save actions:[ IconButton.save]:
// saveForm() {}    onFieldSubmitted: take a string but I need to return anonymous function which flutter will executed
// interact with Form() widget    to submit   GlobalKey
// _form = GlobalKey<FormState>() globalKey allow us to interact with the state behind the form Widget
// now we can the _form property to interact with the Forms
// saveForm will trigger a method in every TextFormField and collect in a map_example
// var _editedProduct = Product(); initialValue and update _editedProduct when call in Form Widget
// execute onSave Function: onSave: (value) {_edited}

// Formvalidator: function return String
// TextFormField: validator: (value) {}  => executed on each input or each keyStroke: Form(autovalidate:)
// return null = input is correct; return 'This is an error';
// return a Text if we have validation error and null if we don't have one
// if (value.isEmpty) error {return 'Please provide a value} return null;
// configure errorMessage in InputDecoration(errorBorder, errorStyle, errorText:default error Text)
// TRIGGER VALIDATION ON FORM
// final isValid = form.currentState.validate(); return true (no error) false()
// if(!isValid) {return ;}
// price_valid: value.isEmpty double.tryParse(value)==null  ,double.parse(value) ==null;

// update don't update ui if we have validation error

// addingProduct in the Products Provider class
// then in saveForm() after submitting the form, validate it
// _form.currentState.save();  Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
// Navigator.of(context).pop();

// edited Product forward the ProductId:
// change how this _editedProduct isLoaded

// fform
// fform_focus //dispo
// fform_valid
// fform_submit //dispo
// fvform
// fsform

// fextracting: args >> didChangedDependencies

//
// fprod_add
// fnewApp

// Build widget to be usefull after wraping widget
// flvmap
// fstles   d
// fstful   d
// fmatApp
// fgv      d

// ftoggle

// flvb     d
// flvs     d
// fgethttp
// fexlview d
// flviewB  d
// flmap
// fform
// fdrawer    d
// faddItem
// frmItem
// faddRoute    d
// fregRoute   => flutter register new route    d
// ftxtheme     d
// fpopupbutton
// fbuilder     d
// flbuilder    d
// fl_lview => list_listView_Builder  d

// faRoute    d
// frRoute    d

// fnocart
// fcartItem

// myshortcut
