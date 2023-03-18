import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:istory/screens/write/write_story_screen.dart';
import 'package:istory/models/story.dart';
import 'package:istory/models/character.dart';
import 'package:istory/models/user.dart';
// import 'package:istory/services/firebase_database.dart';
import 'package:istory/constants/categories.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class CreateStoryScreen extends StatefulWidget {
  @override
  _CreateStoryScreenState createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? storyId;

  // Variables to store the form values
  String title = '';
  String description = 'no description';
  // String category = '';
  String selectedCategory = '#shortstory';
  String character1Name = 'character1';
  String character2Name = 'character2';
  late File character1Image;
  late File character2Image;
  String character1ImageURL =
      'https://firebasestorage.googleapis.com/v0/b/istory-bc418.appspot.com/o/default_images%2Fcharacter1.png?alt=media&token=fcc01246-9c50-499e-9a2b-059232b67ca0';
  String character2ImageURL =
      'https://firebasestorage.googleapis.com/v0/b/istory-bc418.appspot.com/o/default_images%2Fcharacter2.png?alt=media&token=c12cbaa0-b462-40b7-8e84-37ce13d01d0e';
  late File coverImage;
  String coverImageURL =
      'https://firebasestorage.googleapis.com/v0/b/istory-bc418.appspot.com/o/default_images%2Fcover_image.png?alt=media&token=99843a7f-3afc-4a29-a02c-e56c3b7e8c8f';
  String tags = 'chat';
  String status = 'new';
  String error = '';
  bool isUpload1Success = false;
  bool isUpload2Success = false;
  bool isUpload3Success = false;
  late StoryModel newStory;

  // Function to select person1
  void selectPerson1() {
    // Code to select person1
  }

  // Function to select person2
  void selectPerson2() {
    // Code to select person2
  }

  // Function to save the story details to the database
  Future<void> saveStory() async {
    _formKey.currentState!.save();

    final characterRef = FirebaseDatabase.instance.ref().child("characters");
    final character1 = CharacterModel(
      id: character1Name,
      name: character1Name,
      img: character1ImageURL,
    );

    final character2 = CharacterModel(
      id: character2Name,
      name: character2Name,
      img: character2ImageURL,
    );
    final character1Ref = characterRef.push();
    final character2Ref = characterRef.push();
    character1.id = character1Ref.key!;
    character2.id = character2Ref.key!;
    await character1Ref.set(character1.toMap());
    await character2Ref.set(character2.toMap());
    // final authUserId = FirebaseAuth.instance.currentUser!.uid;
    // final userRef =
    //     FirebaseDatabase.instance.ref().child('users').child(authUserId);
    // final userSnapshot = await userRef.once();
    //Write function to save user details on login.
    // final user = UserModel.fromSnapshot(userSnapshot.snapshot);
    final user = UserModel(
      id: "user1",
      email: "sample@email.com",
      name: "Sample User",
      bio: "good",
      img:
          "https://firebasestorage.googleapis.com/v0/b/istory-bc418.appspot.com/o/default_images%2Fno_user_image.png?alt=media&token=141016a4-5994-48ce-9e0f-7e1041fa9b71",
      level: 2,
      pseudonym: "නිර්නාමික කතෘ",
      rating: 0,
    );

    final timestamp = DateTime.now().toIso8601String();
    String localStoryId;
    if (storyId?.isEmpty ?? true) {
      localStoryId =
          FirebaseDatabase.instance.ref().child("stories").push().key!;
    } else {
      localStoryId = storyId!;
    }
    newStory = StoryModel(
      id: localStoryId,
      title: title,
      authorId: user.id,
      authorPseudonym: user.pseudonym,
      authorImg: user.img,
      characters: [character1, character2],
      desc: description,
      lastUpdated: timestamp,
      category: selectedCategory,
      firstSender: "character1",
      views: 0,
      likes: 0,
      dislikes: 0,
      coverImg: coverImageURL,
      bgImg:
          "https://firebasestorage.googleapis.com/v0/b/istory-bc418.appspot.com/o/default_images%2Fyellow_background.png?alt=media&token=fc08acac-800b-4882-9d2b-0d2ab62e101d",
      tags: tags.split(","),
      status: status,
    );
    await FirebaseDatabase.instance
        .ref()
        .child("stories")
        .child(localStoryId)
        .set(newStory.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(40),
          color: const Color.fromARGB(0, 192, 88, 3),
          child: Material(
            color: Colors.white,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Title"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a title";
                      }
                      return null;
                    },
                    onSaved: (value) => title = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Description"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a description";
                      }
                      return null;
                    },
                    onSaved: (value) => description = value!,
                  ),
                  // TextFormField(
                  //   decoration: const InputDecoration(labelText: "Category"),
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return "Please enter a category";
                  //     }
                  //     return null;
                  //   },
                  //   onSaved: (value) => category = value!,
                  // ),
                  buildDropdownButtonFormField(),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Tags"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter tags separated by comas";
                      }
                      return null;
                    },
                    onSaved: (value) => tags = value!,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "First person details",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        var selectedImage = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        var compressedImg =
                            await _resizeImage(File(selectedImage!.path), 512);
                        setState(() {
                          character1Image = compressedImg;
                        });
                        String timestamp =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        Reference reference = FirebaseStorage.instance
                            .ref()
                            .child("person1_images")
                            .child(
                                '$timestamp.${selectedImage!.path.split(".").last}');
                        UploadTask uploadTask =
                            reference.putFile(compressedImg);
                        // UploadTask uploadTask = reference.putFile(File(selectedImage.path));
                        String downloadUrl1 = await uploadTask
                            .then((p0) => p0.ref.getDownloadURL());
                        try {
                          downloadUrl1 = await uploadTask
                              .then((p0) => p0.ref.getDownloadURL());
                          setState(() {
                            character1ImageURL = downloadUrl1;
                            isUpload1Success = true;
                          });
                        } catch (e) {
                          setState(() {
                            isUpload1Success = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isUpload1Success ? Colors.green : Colors.blue,
                        textStyle: const TextStyle(color: Colors.white),
                      ),
                      child: const Text("Select picture"),
                    ),
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "1st person name"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter Person 1's name";
                      }
                      return null;
                    },
                    onSaved: (value) => character1Name = value!,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Second person details",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                  Row(),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        var selectedImage = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        var compressedImg =
                            await _resizeImage(File(selectedImage!.path), 512);
                        setState(() {
                          character2Image = compressedImg;
                        });
                        String timestamp =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        Reference reference = FirebaseStorage.instance
                            .ref()
                            .child("person2_images")
                            .child(
                                '$timestamp.${selectedImage.path.split(".").last}');
                        UploadTask uploadTask =
                            reference.putFile(File(selectedImage.path));
                        String downloadUrl2 = await uploadTask.then(
                            (character2) => character2.ref.getDownloadURL());
                        try {
                          downloadUrl2 = await uploadTask.then(
                              (character2) => character2.ref.getDownloadURL());
                          setState(() {
                            character2ImageURL = downloadUrl2;
                            isUpload2Success = true;
                          });
                        } catch (e) {
                          setState(() {
                            isUpload2Success = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isUpload2Success ? Colors.green : Colors.blue,
                        textStyle: const TextStyle(color: Colors.white),
                      ),
                      child: const Text("Select image"),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Enter 2nd person name"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter Person 2's name";
                      }
                      return null;
                    },
                    onSaved: (value) => character2Name = value!,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text("Upload story cover photo (optional)"),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        var selectedImage = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        var compressedImg =
                            await _resizeImage(File(selectedImage!.path), 512);
                        setState(() {
                          coverImage = compressedImg;
                        });
                        String timestamp =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        Reference reference = FirebaseStorage.instance
                            .ref()
                            .child("story_cover_images")
                            .child(
                                '$timestamp.${selectedImage!.path.split(".").last}');
                        UploadTask uploadTask =
                            reference.putFile(File(selectedImage.path));
                        String downloadUrl3 = await uploadTask
                            .then((p3) => p3.ref.getDownloadURL());
                        try {
                          downloadUrl3 = await uploadTask
                              .then((p3) => p3.ref.getDownloadURL());
                          setState(() {
                            coverImageURL = downloadUrl3;
                            isUpload3Success = true;
                          });
                        } catch (e) {
                          setState(() {
                            isUpload3Success = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isUpload3Success ? Colors.green : Colors.blue,
                        textStyle: const TextStyle(color: Colors.white),
                      ),
                      child: const Text("Select story cover image"),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text("Let's write"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDropdownButtonFormField() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      hint: const Text('Select a category'),
      onChanged: (String? value) {
        setState(() {
          selectedCategory = value!;
        });
      },
      items: CATEGORIES.map((Category category) {
        String val = category.hashtag;
        String name = category.name;
        return DropdownMenuItem<String>(
          value: val,
          child: Text(name),
        );
      }).toList(),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await saveStory();
      if (!mounted) return;
      Navigator.pushNamed(
        context,
        '/create-story/write-story',
        arguments: newStory,
      );
    }
  }

  Future<File> _resizeImage(File file, int size) async {
    final imageBytes = await file.readAsBytes();
    final originalImage = await decodeImageFromList(imageBytes);

    // Calculate the aspect ratio of the original image
    final aspectRatio = originalImage.width / originalImage.height;

    // Calculate the new dimensions based on the aspect ratio and the desired size
    int width = aspectRatio > 1 ? size : (size * aspectRatio).round();
    int height = aspectRatio > 1 ? (size / aspectRatio).round() : size;

    // Resize the image using the calculated dimensions
    final resizedImage = await FlutterNativeImage.compressImage(
      file.path,
      quality: 70,
      targetWidth: width,
      targetHeight: height,
    );

    return File(resizedImage.path);
  }
}
