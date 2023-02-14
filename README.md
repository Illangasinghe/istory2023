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

## Firebase Realtime Database

- Firebase Realtime Database
  - users
    - user_id
      - email: string
      - pseudonym: string
      - name: string
      - rating: number
      - level: number
      - img: string
      - bio: string
  - stories
    - story_id
      - title: string
      - author_id: string (is a user_id)
      - author_pseudonym: string
      - author_img: string
      - desc: string
      - last_updated: string
      - category: string (Romance, Political, etc.)
      - characters: array
        - character_id: string (is a character_id)
      - first_sender: string
      - total_messages: number
      - views: number
      - likes: number
      - dislikes: number
      - rating: number
      - cover_img: string
      - bg_img: string
      - tags: array of strings (new, trending, popular, etc.)
      - status: string (draft, in-review, published, restricted, unpublished)
  - messages
    - story_id: string (is a story_id)
      - message_id: string
      - character_name: string
      - character_img: string
      - text: string
      - timestamp: string
  - characters
    - character_id: string
      - character_name: string
      - character_img: string
  - reviews
    - story_id: string (is a story_id)
      - review_id: string
      - rating: number
      - comment: string
      - timestamp: string
      - user_id: string
