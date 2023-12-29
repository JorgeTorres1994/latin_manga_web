/*import 'dart:io';

import 'package:aplicacion_manga_admin_panel/screens/loading_manager.dart';
import 'package:aplicacion_manga_admin_panel/services/global_method.dart';
import 'package:aplicacion_manga_admin_panel/services/utils.dart';
import 'package:aplicacion_manga_admin_panel/widgets/buscador_mangas.dart';
import 'package:aplicacion_manga_admin_panel/widgets/buttons.dart';
import 'package:aplicacion_manga_admin_panel/widgets/side_menu.dart';
import 'package:aplicacion_manga_admin_panel/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../responsive.dart';

class AgregarMangaForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  const AgregarMangaForm({Key? key}) : super(key: key);

  @override
  _AgregarMangaFormState createState() => _AgregarMangaFormState();
}

class _AgregarMangaFormState extends State<AgregarMangaForm> {
  final _formKey = GlobalKey<FormState>();
  String _catValue = 'Comedia';
  String _typeBook = 'Manga';
  late final TextEditingController _titleController, _numberPagesController;
  File? _pickedImage;

  Uint8List webImage = Uint8List(8);
  Uint8List?
      _pickedPdfBytes; // Variable para almacenar los bytes del PDF seleccionado

  @override
  void initState() {
    _titleController = TextEditingController();
    _numberPagesController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _numberPagesController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void _uploadForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    String? imageUrl;

    if (isValid) {
      _formKey.currentState!.save();
      if (_pickedImage == null) {
        _showImageWarningDialog();
        return;
      }

      final _uuid = const Uuid().v4();
      try {
        setState(() {
          _isLoading = true;
        });

        String? pdfUrl;

        final DocumentSnapshot mangaDoc = await FirebaseFirestore.instance
            .collection('mangas')
            .doc(_uuid)
            .get();

        if (mangaDoc.exists) {
          _showImageWarningDialog();
          return;
        }

        final ref = FirebaseStorage.instance
            .ref()
            .child('mangasImages')
            .child('$_uuid.jpg');

        if (kIsWeb) {
          await ref.putData(webImage);
        } else {
          await ref.putFile(_pickedImage!);
        }
        imageUrl = await ref.getDownloadURL();

        if (_pickedPdfBytes != null) {
          final pdfRef =
              FirebaseStorage.instance.ref().child('pdfs').child('$_uuid.pdf');
          await pdfRef.putData(_pickedPdfBytes!);
          pdfUrl = await pdfRef.getDownloadURL();

          await FirebaseFirestore.instance.collection('mangas').doc(_uuid).set({
            'id': _uuid,
            'title': _titleController.text,
            'imageUrl': imageUrl.toString(),
            'type': _typeBook,
            'mangaCategoryName': _catValue,
            'numberPages': _numberPagesController.text,
            'pdfUrl': pdfUrl,
            'fechaPublicacion': Timestamp.now(),
          });

          _clearForm();
          Fluttertoast.showToast(
            msg: "Manga Subido correctamente",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
          );
          // Redirige a MangasWidget para refrescar los resultados
          // Cierra la pantalla actual y regresa a la anterior
          Navigator.of(context).pop();
        } else {
          _showPdfWarningDialog();
          return;
        }
      } catch (error) {
        //Maneja errores
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showImageWarningDialog() {
    GlobalMethods.warningDialog(
      title: 'Imagen no seleccionada',
      subtitle: 'Selecciona una imagen antes de continuar',
      fct: () {
        // No hacemos nada en la función, simplemente cerramos el diálogo
        Navigator.pop(context);
      },
      context: context,
    );
  }

  void _showPdfWarningDialog() {
    GlobalMethods.warningDialog(
      title: 'PDF no seleccionado',
      subtitle: 'Selecciona un archivo PDF antes de continuar',
      fct: () {
        // No hacemos nada en la función, simplemente cerramos el diálogo
        Navigator.pop(context);
      },
      context: context,
    );
  }

  void _clearForm() {
    _titleController.clear();
    _numberPagesController.clear();
    setState(() {
      _pickedImage = null;
      _pickedPdfBytes = null;
      webImage = Uint8List(8);
    });
  }

  @override
  Widget build(BuildContext context) {
    //final theme = Utils(context).getTheme;
    final color = Utils(context).color;
    final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = Utils(context).getScreenSize;

    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: _scaffoldColor,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1.0,
        ),
      ),
    );
    return Scaffold(
        drawer: const SideMenu(),
        body: LoadingManager(
          isLoading: _isLoading,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  child: SideMenu(),
                ),
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BuscadorMangas(
                            fct: () {},
                            title: 'Agregar manga',
                            showTexField: false),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: size.width > 650 ? 650 : size.width,
                        color: Theme.of(context).cardColor,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextWidget(
                                text: 'Título del manga*',
                                color: color,
                                isTitle: true,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _titleController,
                                key: const ValueKey('Title'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Ingresa título del manga';
                                  }
                                  return null;
                                },
                                decoration: inputDecoration,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: FittedBox(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 20),
                                          TextWidget(
                                            text: 'Género del manga*',
                                            color: color,
                                            isTitle: true,
                                          ),
                                          const SizedBox(height: 10),
                                          _categoryDropDown(),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          /******************/
                                          TextWidget(
                                            text: 'Tipo de libro*',
                                            color: color,
                                            isTitle: true,
                                          ),
                                          const SizedBox(height: 10),
                                          _typeBookDropDown(),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 4,
                                      child: Container(
                                          height: size.width > 650
                                              ? 350
                                              : size.width * 0.45,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: _pickedImage == null
                                              ? dottedBorder(color: color)
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: kIsWeb
                                                      ? Image.memory(
                                                          webImage,
                                                          fit: BoxFit.fill,
                                                        )
                                                      : Image.file(
                                                          _pickedImage!,
                                                          fit: BoxFit.fill,
                                                        ),
                                                ))),
                                  Expanded(
                                      flex: 1,
                                      child: FittedBox(
                                        child: Column(
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _pickedImage = null;
                                                  webImage = Uint8List(8);
                                                });
                                              },
                                              child: TextWidget(
                                                text: 'Limpiar',
                                                color: Colors.red,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {},
                                              child: TextWidget(
                                                text: 'Editar imágen',
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                              TextWidget(
                                text: '# Páginas*',
                                color: color,
                                isTitle: true,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _numberPagesController,
                                key: const ValueKey('Páginas'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Ingresa el # de paginas del manga';
                                  }
                                  return null;
                                },
                                decoration: inputDecoration,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ButtonsWidget(
                                onPressed:
                                    pickFile, // Nuevo botón para seleccionar el archivo PDF
                                text: 'Seleccionar archivo PDF',
                                icon: Icons.attach_file,
                                backgroundColor: Colors
                                    .orangeAccent, // Puedes cambiar el color del botón
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ButtonsWidget(
                                      onPressed: () {
                                        _clearForm();
                                      },
                                      text: 'Limpiar formulario',
                                      icon: IconlyBold.danger,
                                      backgroundColor: Colors.red.shade300,
                                    ),
                                    ButtonsWidget(
                                      onPressed: () {
                                        _uploadForm();
                                      },
                                      text: 'Subir',
                                      icon: IconlyBold.upload,
                                      backgroundColor: Colors.blue,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
        });
      } else {
        print('Ninguna imágen fue seleccionada');
      }
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a');
        });
      } else {
        print('Ninguna imágen fue seleccionada');
      }
    } else {
      print('Ha ocurrido un error');
    }
  }

  Future<void> pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pickedFile != null) {
      _pickedPdfBytes =
          pickedFile.files[0].bytes; // Almacenar los bytes del PDF seleccionado
    }

    setState(() {});
  }

  Widget dottedBorder({
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
          dashPattern: const [6.7],
          borderType: BorderType.RRect,
          color: color,
          radius: const Radius.circular(12),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  color: color,
                  size: 50,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: (() {
                      _pickImage();
                    }),
                    child: TextWidget(
                      text: 'Elegir una imágen',
                      color: Colors.blue,
                    ))
              ],
            ),
          )),
    );
  }

  Widget _categoryDropDown() {
    final color = Utils(context).color;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          value: _catValue,
          onChanged: (value) {
            setState(() {
              _catValue = value!;
            });
            print(_catValue);
          },
          hint: const Text('Selecciona una categoría'),
          items: const [
            DropdownMenuItem(
              child: Text(
                'Comedia',
              ),
              value: 'Comedia',
            ),
            DropdownMenuItem(
              child: Text(
                'Escolar',
              ),
              value: 'Escolar',
            ),
            DropdownMenuItem(
              child: Text(
                'Gore',
              ),
              value: 'Gore',
            ),
            DropdownMenuItem(
              child: Text(
                'Misterio',
              ),
              value: 'Misterio',
            ),
            DropdownMenuItem(
              child: Text(
                'Romance',
              ),
              value: 'Romance',
            ),
            DropdownMenuItem(
              child: Text(
                'Shonen',
              ),
              value: 'Shonen',
            )
          ],
        )),
      ),
    );
  }

  Widget _typeBookDropDown() {
    final color = Utils(context).color;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          value: _typeBook,
          onChanged: (value) {
            setState(() {
              _typeBook = value!;
            });
            print(_typeBook);
          },
          hint: const Text('Selecciona tipo de libro'),
          items: const [
            DropdownMenuItem(
              child: Text(
                'Manga',
              ),
              value: 'Manga',
            ),
            DropdownMenuItem(
              child: Text(
                'Comic',
              ),
              value: 'Comic',
            ),
          ],
        )),
      ),
    );
  }
}
*/
import 'dart:io';

import 'package:aplicacion_manga_admin_panel/screens/loading_manager.dart';
import 'package:aplicacion_manga_admin_panel/services/global_method.dart';
import 'package:aplicacion_manga_admin_panel/services/utils.dart';
import 'package:aplicacion_manga_admin_panel/widgets/buscador_mangas.dart';
import 'package:aplicacion_manga_admin_panel/widgets/buttons.dart';
import 'package:aplicacion_manga_admin_panel/widgets/side_menu.dart';
import 'package:aplicacion_manga_admin_panel/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../responsive.dart';

class AgregarMangaForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  const AgregarMangaForm({Key? key}) : super(key: key);

  @override
  _AgregarMangaFormState createState() => _AgregarMangaFormState();
}

class _AgregarMangaFormState extends State<AgregarMangaForm> {
  final _formKey = GlobalKey<FormState>();
  String _catValue = 'Comedia';
  String _typeBook = 'Manga';
  late final TextEditingController _titleController, _numberPagesController;
  File? _pickedImage;

  Uint8List webImage = Uint8List(8);
  Uint8List?
      _pickedPdfBytes; // Variable para almacenar los bytes del PDF seleccionado

  @override
  void initState() {
    _titleController = TextEditingController();
    _numberPagesController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _numberPagesController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void _uploadForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    String? imageUrl;

    if (isValid) {
      _formKey.currentState!.save();
      if (_pickedImage == null) {
        _showImageWarningDialog();
        return;
      }

      final _uuid = const Uuid().v4();
      try {
        setState(() {
          _isLoading = true;
        });

        String? pdfUrl;

        final DocumentSnapshot mangaDoc = await FirebaseFirestore.instance
            .collection('mangas')
            .doc(_uuid)
            .get();

        if (mangaDoc.exists) {
          _showImageWarningDialog();
          return;
        }

        final ref = FirebaseStorage.instance
            .ref()
            .child('mangasImages')
            .child('$_uuid.jpg');

        if (kIsWeb) {
          await ref.putData(webImage);
        } else {
          await ref.putFile(_pickedImage!);
        }
        imageUrl = await ref.getDownloadURL();

        if (_pickedPdfBytes != null) {
          final pdfRef =
              FirebaseStorage.instance.ref().child('pdfs').child('$_uuid.pdf');
          await pdfRef.putData(_pickedPdfBytes!);
          pdfUrl = await pdfRef.getDownloadURL();

          await FirebaseFirestore.instance.collection('mangas').doc(_uuid).set({
            'id': _uuid,
            'title': _titleController.text,
            'imageUrl': imageUrl.toString(),
            'type': _typeBook,
            'mangaCategoryName': _catValue,
            'numberPages': _numberPagesController.text,
            'pdfUrl': pdfUrl,
            'fechaPublicacion': Timestamp.now(),
          });

          _clearForm();
          Fluttertoast.showToast(
            msg: "Manga Subido correctamente",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
          );
          // Redirige a MangasWidget para refrescar los resultados
          // Cierra la pantalla actual y regresa a la anterior
          Navigator.of(context).pop();
        } else {
          _showPdfWarningDialog();
          return;
        }
      } catch (error) {
        //Maneja errores
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showImageWarningDialog() {
    GlobalMethods.warningDialog(
      title: 'Imagen no seleccionada',
      subtitle: 'Selecciona una imagen antes de continuar',
      fct: () {
        // No hacemos nada en la función, simplemente cerramos el diálogo
        Navigator.pop(context);
      },
      context: context,
    );
  }

  void _showPdfWarningDialog() {
    GlobalMethods.warningDialog(
      title: 'PDF no seleccionado',
      subtitle: 'Selecciona un archivo PDF antes de continuar',
      fct: () {
        // No hacemos nada en la función, simplemente cerramos el diálogo
        Navigator.pop(context);
      },
      context: context,
    );
  }

  void _clearForm() {
    _titleController.clear();
    _numberPagesController.clear();
    setState(() {
      _pickedImage = null;
      _pickedPdfBytes = null;
      webImage = Uint8List(8);
    });
  }

  @override
  Widget build(BuildContext context) {
    //final theme = Utils(context).getTheme;
    final color = Utils(context).color;
    final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = Utils(context).getScreenSize;

    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: _scaffoldColor,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1.0,
        ),
      ),
    );
    return Scaffold(
        drawer: const SideMenu(),
        body: LoadingManager(
          isLoading: _isLoading,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  child: SideMenu(),
                ),
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BuscadorMangas(
                            fct: () {},
                            title: 'Agregar manga',
                            showTexField: false),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: size.width > 650 ? 650 : size.width,
                        color: Theme.of(context).cardColor,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextWidget(
                                text: 'Título del manga*',
                                color: color,
                                isTitle: true,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _titleController,
                                key: const ValueKey('Title'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Ingresa título del manga';
                                  }
                                  return null;
                                },
                                decoration: inputDecoration,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: FittedBox(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 20),
                                          TextWidget(
                                            text: 'Género del manga*',
                                            color: color,
                                            isTitle: true,
                                          ),
                                          const SizedBox(height: 10),
                                          _categoryDropDown(),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          /******************/
                                          TextWidget(
                                            text: 'Tipo de libro*',
                                            color: color,
                                            isTitle: true,
                                          ),
                                          const SizedBox(height: 10),
                                          _typeBookDropDown(),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 4,
                                      child: Container(
                                          height: size.width > 650
                                              ? 350
                                              : size.width * 0.45,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: _pickedImage == null
                                              ? dottedBorder(color: color)
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: kIsWeb
                                                      ? Image.memory(
                                                          webImage,
                                                          fit: BoxFit.fill,
                                                        )
                                                      : Image.file(
                                                          _pickedImage!,
                                                          fit: BoxFit.fill,
                                                        ),
                                                ))),
                                  Expanded(
                                      flex: 1,
                                      child: FittedBox(
                                        child: Column(
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _pickedImage = null;
                                                  webImage = Uint8List(8);
                                                });
                                              },
                                              child: TextWidget(
                                                text: 'Limpiar',
                                                color: Colors.red,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {},
                                              child: TextWidget(
                                                text: 'Editar imágen',
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                              TextWidget(
                                text: '# Páginas*',
                                color: color,
                                isTitle: true,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _numberPagesController,
                                key: const ValueKey('Páginas'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Ingresa el # de paginas del manga';
                                  }
                                  return null;
                                },
                                decoration: inputDecoration,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ButtonsWidget(
                                onPressed:
                                    pickFile, // Nuevo botón para seleccionar el archivo PDF
                                text: 'Seleccionar archivo PDF',
                                icon: Icons.attach_file,
                                backgroundColor: Colors
                                    .orangeAccent, // Puedes cambiar el color del botón
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ButtonsWidget(
                                      onPressed: () {
                                        _clearForm();
                                      },
                                      text: 'Limpiar formulario',
                                      icon: IconlyBold.danger,
                                      backgroundColor: Colors.red.shade300,
                                    ),
                                    ButtonsWidget(
                                      onPressed: () {
                                        _uploadForm();
                                      },
                                      text: 'Subir',
                                      icon: IconlyBold.upload,
                                      backgroundColor: Colors.blue,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
        });
      } else {
        print('Ninguna imágen fue seleccionada');
      }
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a');
        });
      } else {
        print('Ninguna imágen fue seleccionada');
      }
    } else {
      print('Ha ocurrido un error');
    }
  }

  Future<void> pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pickedFile != null) {
      _pickedPdfBytes =
          pickedFile.files[0].bytes; // Almacenar los bytes del PDF seleccionado
    }

    setState(() {});
  }

  Widget dottedBorder({
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
          dashPattern: const [6.7],
          borderType: BorderType.RRect,
          color: color,
          radius: const Radius.circular(12),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  color: color,
                  size: 50,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: (() {
                      _pickImage();
                    }),
                    child: TextWidget(
                      text: 'Elegir una imágen',
                      color: Colors.blue,
                    ))
              ],
            ),
          )),
    );
  }

  Widget _categoryDropDown() {
    final color = Utils(context).color;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          value: _catValue,
          onChanged: (value) {
            setState(() {
              _catValue = value!;
            });
            print(_catValue);
          },
          hint: const Text('Selecciona una categoría'),
          items: const [
            DropdownMenuItem(
              child: Text(
                'Comedia',
              ),
              value: 'Comedia',
            ),
            DropdownMenuItem(
              child: Text(
                'Escolar',
              ),
              value: 'Escolar',
            ),
            DropdownMenuItem(
              child: Text(
                'Gore',
              ),
              value: 'Gore',
            ),
            DropdownMenuItem(
              child: Text(
                'Misterio',
              ),
              value: 'Misterio',
            ),
            DropdownMenuItem(
              child: Text(
                'Romance',
              ),
              value: 'Romance',
            ),
            DropdownMenuItem(
              child: Text(
                'Shonen',
              ),
              value: 'Shonen',
            )
          ],
        )),
      ),
    );
  }

  Widget _typeBookDropDown() {
    final color = Utils(context).color;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          value: _typeBook,
          onChanged: (value) {
            setState(() {
              _typeBook = value!;
            });
            print(_typeBook);
          },
          hint: const Text('Selecciona tipo de libro'),
          items: const [
            DropdownMenuItem(
              child: Text(
                'Manga',
              ),
              value: 'Manga',
            ),
            DropdownMenuItem(
              child: Text(
                'Comic',
              ),
              value: 'Comic',
            ),
          ],
        )),
      ),
    );
  }
}
