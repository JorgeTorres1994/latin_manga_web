import 'dart:developer';
import 'dart:io';

import 'package:aplicacion_manga_admin_panel/screens/loading_manager.dart';
import 'package:aplicacion_manga_admin_panel/services/global_method.dart';
import 'package:aplicacion_manga_admin_panel/services/utils.dart';
import 'package:aplicacion_manga_admin_panel/widgets/buttons.dart';
import 'package:aplicacion_manga_admin_panel/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';

class EditarMangaScreen extends StatefulWidget {
  const EditarMangaScreen({
    Key? key,
    required this.id,
    required this.title,
    required this.numberPages,
    required this.productCat,
    required this.type,
    required this.imageUrl,
    required this.pdfUrl,
  }) : super(key: key);

  final String id, title, numberPages, productCat, type, imageUrl, pdfUrl;
  @override
  // ignore: library_private_types_in_public_api
  _EditarMangaScreenState createState() => _EditarMangaScreenState();
}

class _EditarMangaScreenState extends State<EditarMangaScreen> {
  final _formKey = GlobalKey<FormState>();
  // Title and price controllers
  late final TextEditingController _titleController, _numberPagesController;
  // Category
  late String _catValue;
  //Type Book
  late String _typeValue;

  Uint8List? _pickedPdfBytes;
  late String percToShow;
  // Image
  File? _pickedImage;
  Uint8List webImage = Uint8List(10);
  late String _imageUrl;
  //late String _pdfUrl;
  late int val;
  @override
  void initState() {
    // set the price and title initial values and initialize the controllers
    _titleController = TextEditingController(text: widget.title);
    _numberPagesController = TextEditingController(text: widget.numberPages);
    _catValue = widget.productCat;
    _typeValue = widget.type;
    _imageUrl = widget.imageUrl;
    //_pdfUrl = widget.pdfUrl;
    super.initState();
  }

  @override
  void dispose() {
    // Dispose the controllers
    _titleController.dispose();
    _numberPagesController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void _updateForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    String? imageUrl;

    if (isValid) {
      _formKey.currentState!.save();

      try {
        setState(() {
          _isLoading = true;
        });

        // Verifica si el documento existe antes de realizar la actualización
        final DocumentSnapshot mangaDoc = await FirebaseFirestore.instance
            .collection('mangas')
            .doc(widget.id)
            .get();

        if (!mangaDoc.exists) {
          // El documento no existe
          // Maneja la situación según sea necesario
          print('El documento no existe');
          // Aquí podrías mostrar un mensaje al usuario o realizar otras acciones
          return;
        }

        String? pdfUrl;

        // Comprueba si se seleccionó una nueva imagen
        if (_pickedImage != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('mangasImages')
              .child(widget.id + '.jpg');

          if (kIsWeb) {
            await ref.putData(webImage);
          } else {
            await ref.putFile(_pickedImage!);
          }

          imageUrl = await ref.getDownloadURL();
        }

        // Comprueba si se seleccionó un nuevo archivo PDF
        if (_pickedPdfBytes != null) {
          final pdfRef = FirebaseStorage.instance
              .ref()
              .child('pdfs')
              .child(widget.id + '.pdf');

          await pdfRef.putData(_pickedPdfBytes!);
          pdfUrl = await pdfRef.getDownloadURL();
        }

        // Crear un mapa para almacenar solo los campos que han sido modificados
        Map<String, dynamic> updatedData = {};

        if (_titleController.text != widget.title) {
          updatedData['title'] = _titleController.text;
        }

        if (_catValue != widget.productCat) {
          updatedData['mangaCategoryName'] = _catValue;
        }

        if (_typeValue != widget.type) {
          updatedData['type'] = _typeValue;
        }

        if (_numberPagesController.text != widget.numberPages) {
          updatedData['numberPages'] = _numberPagesController.text;
        }

        if (imageUrl != null) {
          updatedData['imageUrl'] = imageUrl;
        }

        if (pdfUrl != null) {
          updatedData['pdfUrl'] = pdfUrl;
        }

        if (updatedData.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('mangas')
              .doc(widget.id)
              .update(updatedData);

          Fluttertoast.showToast(
            msg: "Manga Editado correctamente",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
          );
          Navigator.of(context).pop();
          // Opcional: Redirige a la pantalla anterior (si es necesario)
          /*Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );*/
        } else {
          Fluttertoast.showToast(
            msg: "No se realizaron cambios",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
          );
        }
      } catch (error) {
        print('Error: $error');
        // Aquí podrías mostrar un mensaje al usuario o realizar otras acciones
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = theme == true ? Colors.white : Colors.black;
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
      body: LoadingManager(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
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
                          key: const ValueKey('Título'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Porfavor ingresa un título';
                            }
                            return null;
                          },
                          decoration: inputDecoration,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextWidget(
                          text: 'Género del manga*',
                          color: color,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          color: _scaffoldColor,
                          child: Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                catDropDownWidget(color),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextWidget(
                          text: 'Tipo de libro*',
                          color: color,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          color: _scaffoldColor,
                          child: Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                typeDropDownWidget(color),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  height: size.width > 650
                                      ? 350
                                      : size.width * 0.45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ),
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    child: _pickedImage == null
                                        ? Image.network(_imageUrl)
                                        : (kIsWeb)
                                            ? Image.memory(
                                                webImage,
                                                fit: BoxFit.fill,
                                              )
                                            : Image.file(
                                                _pickedImage!,
                                                fit: BoxFit.fill,
                                              ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    FittedBox(
                                      child: TextButton(
                                        onPressed: () {
                                          _pickImage();
                                        },
                                        child: TextWidget(
                                          text: 'Editar imágen',
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextWidget(
                          text: 'Cantidad de Páginas*',
                          color: color,
                          isTitle: true,
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
                        SizedBox(
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
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ButtonsWidget(
                                onPressed: () async {
                                  GlobalMethods.warningDialog(
                                      title: '¿Borrar?',
                                      subtitle: '¿Estás seguro?',
                                      fct: () async {
                                        await FirebaseFirestore.instance
                                            .collection('mangas')
                                            .doc(widget.id)
                                            .delete();
                                        await Fluttertoast.showToast(
                                          msg: "Manga eliminado correctamente",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                        );
                                        while (Navigator.canPop(context)) {
                                          Navigator.pop(context);
                                        }
                                      },
                                      context: context);
                                },
                                text: 'Eliminar',
                                icon: IconlyBold.danger,
                                backgroundColor: Colors.red.shade700,
                              ),
                              ButtonsWidget(
                                onPressed: () {
                                  _updateForm();
                                },
                                text: 'Actualizar',
                                icon: IconlyBold.setting,
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
      ),
    );
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

  Future<void> pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pickedFile != null) {
      String fileName = pickedFile.files[0].name;
      _pickedPdfBytes =
          pickedFile.files[0].bytes; // Almacenar los bytes del PDF seleccionado
    }

    setState(() {});
  }

  DropdownButtonHideUnderline catDropDownWidget(Color color) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        style: TextStyle(color: color),
        items: const [
          DropdownMenuItem<String>(
            child: Text(
              'Comedia',
            ),
            value: 'Comedia',
          ),
          DropdownMenuItem<String>(
            child: Text(
              'Escolar',
            ),
            value: 'Escolar',
          ),
          DropdownMenuItem<String>(
            child: Text(
              'Gore',
            ),
            value: 'Gore',
          ),
          DropdownMenuItem<String>(
            child: Text(
              'Misterio',
            ),
            value: 'Misterio',
          ),
          DropdownMenuItem<String>(
            child: Text(
              'Romance',
            ),
            value: 'Romance',
          ),
          DropdownMenuItem<String>(
            child: Text(
              'Shonen',
            ),
            value: 'Shonen',
          ),
        ],
        onChanged: (value) {
          setState(() {
            _catValue = value!;
          });
        },
        hint: const Text('Selecciona una categoría'),
        value: _catValue,
      ),
    );
  }

  /**************/
  DropdownButtonHideUnderline typeDropDownWidget(Color color) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        style: TextStyle(color: color),
        items: const [
          DropdownMenuItem<String>(
            child: Text(
              'Manga',
            ),
            value: 'Manga',
          ),
          DropdownMenuItem<String>(
            child: Text(
              'Comic',
            ),
            value: 'Comic',
          ),
        ],
        onChanged: (value) {
          setState(() {
            _typeValue = value!;
          });
        },
        hint: const Text('Selecciona tipo de libro'),
        value: _typeValue,
      ),
    );
  }

  Future<void> _pickImage() async {
    // MOBILE
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);

        setState(() {
          _pickedImage = selected;
        });
      } else {
        log('Imágen no seleccionada');
      }
    }
    // WEB
    else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          _pickedImage = File("a");
          webImage = f;
        });
      } else {
        log('Imágen no seleccionada');
      }
    } else {
      log('Perm not granted');
    }
  }
}
