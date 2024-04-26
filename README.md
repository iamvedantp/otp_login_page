# OTP Login Page

This is a Flutter project that demonstrates a login flow using One-Time Password (OTP) authentication.
![Screenshot_1714132792](https://github.com/iamvedantp/otp_login_page/assets/128803902/6a5fa9f3-25c2-4232-ad32-9374d423166f)
![Screenshot_1714132828](https://github.com/iamvedantp/otp_login_page/assets/128803902/43695bee-b44f-4b63-9068-0db01d042d93)
![Screenshot_1714132836](https://github.com/iamvedantp/otp_login_page/assets/128803902/ddd24efc-28b8-4734-9b52-25a0ca64df73)


## Features

1. **OTP Generation**: The user can enter their email/handle, and the app will generate an OTP and display it.
2. **OTP Login**: The user can then enter the OTP to log in to the app.
3. **User Data Persistence**: The user data collected from the backend during the login process is saved and passed to the home screen.
4. **Logout**: The user can log out of the app by clicking the logout button in the home screen.

## Getting Started

1. Clone the repository:
git clone https://github.com/your-username/otp_login_page.git

2. Navigate to the project directory:
     cd otp_login_page

3. Install the dependencies:
     flutter pub get

4. Run the app:
   flutter run


## Project Structure

The project consists of the following files:

1. `main.dart`: The entry point of the application, which sets up the initial route and the available routes.
2. `login_page.dart`: Implements the login page, which includes the OTP generation and login functionality.
3. `home.dart`: Implements the home page, which displays the user data collected during the login process and provides a logout functionality.

## Usage

1. When the app is launched, the user is directed to the login page.
2. The user can enter their email/handle and click the "Get OTP" button to generate an OTP.
3. Once the OTP is displayed, the user can enter it and click the "Login" button to log in.
4. After a successful login, the user is directed to the home page, which displays the user data collected from the backend.
5. The user can log out by clicking the logout button in the home page.

## Dependencies

The project uses the following dependencies:

- `flutter/material.dart`: Provides the Material Design widgets and functionality.
- `http/http.dart`: Allows making HTTP requests to the backend.
- `dart:convert`: Provides JSON encoding and decoding functionality.

## Customization

You can customize the app by modifying the following:

1. **Backend Integration**: Update the API endpoints and request/response handling in the `login_page.dart` file to match your backend implementation.
2. **User Data Display**: Modify the `home.dart` file to display the user data in the desired format.
3. **UI Styling**: Customize the UI elements, colors, and layouts in the `login_page.dart` and `home.dart` files to match your branding and design requirements.

## Contributing

If you find any issues or have suggestions for improvements, feel free to create a new issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
