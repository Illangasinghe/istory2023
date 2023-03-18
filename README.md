# story - History of Sinhala Chats

This is a Flutter project for a mobile application delivering chat fiction stories in the form of text messages between fictional characters, in Sinhala language. The app provides a unique and engaging platform for users to enjoy a wide range of stories in a convenient and accessible format.

## Features

- Story Catalog: Browse through a curated collection of chat fiction stories
- Read a Story: Immerse yourself in a chat conversation between characters as they build a narrative
- Create a Story: Write and share your own chat fiction stories with the community

## Requirements

- Flutter SDK
- Android or iOS emulator
- Android or iOS device (optional)

## Installation

To run this project, follow these steps:
1. Clone the repository: git clone https://github.com/Illangasinghe/istory.git
2. Change into the project directory: cd Istory
3. Install the dependencies: flutter packages get
4. Run the app on an emulator or a connected device: flutter run

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Contributing

If you would like to contribute to the project, please follow the guidelines in the CONTRIBUTING.md file.

## License

This project is licensed under the MIT License. Please see the LICENSE file for details.

## Acknowledgements

- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [OpenAI](https://openai.com/)
Thank you for your interest in Istory! We hope you enjoy using it as much as we enjoyed building it.

## Database
users:
  user_id:
    email: 
    public_name: 
    real_name: 
    rating: 
    level: 
    profile_pic: 
    bio: 

stories:
  story_id:
    title: 
    author_id: 
    desc: 
    last_updated: 
    category: 
    person1: 
    person2: 
    character1_pic: 
    character2_pic: 
    sender: 
    views: 
    likes: 
    dislikes: 
    cover_img: 
    bg_img: 
    tags: 

messages:
  story_id:
    message_id: 
    sender: 
    text: 
    timestamp: 
