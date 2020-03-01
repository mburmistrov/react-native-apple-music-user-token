# react-native-apple-music-user-token

Request apple music user token with your developer token from React Native app (iOS only).

## Getting Started

```
yarn add mburmistrov/react-native-apple-music-user-token

# RN >= 0.60
cd ios && pod install

# RN < 0.60
react-native link react-native-apple-music-user-token
```

You will also need to add **Privacy - Apple Music usage Description (NSAppleMusicUsageDescription)** key to Info.plist inside your project.

## Usage
```javascript
import AppleMusicUserToken from 'react-native-apple-music-user-token';

const devToken = '<your apple music developer token>';

await AppleMusicUserToken.requestAuthorization();
const userToken = await AppleMusicUserToken.requestUserTokenForDeveloperToken(devToken);
console.log(userToken);
```
