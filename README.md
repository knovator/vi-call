
# knovi_call

knovi_call is the One-to-One video calling using [Vonage Video API](https://tokbox.com/developer/guides/basics/).


## Usage

- Create [Vonage Account](https://tokbox.com/account/user/signup) for Creating the video session.
- Add `knovi_call` as dependency in `pubspec.yaml` file.
- Generate [Session ID](https://tokbox.com/developer/guides/create-session/) and [Token](https://tokbox.com/developer/guides/create-session/) From Vonage Project DashBoard.


```dart
import 'package:knovi_call/knovi_call.dart';

Widget build(BuildContext context) {
    return Scaffold(
      body: KnoviCall(
        apiKey: 'YOUR_VONAGE_API_KEY',
        sessionId: "VIDEO_SESSION_ID",
        token: "VIDEO_SESSION_ID",
      ),
    );
  }
```


## Documentation

[Vonage Video API](https://tokbox.com/developer/guides/basics/)
