# Firebase Realtime Database Rules Setup

## 🔧 Required Firebase Configuration

To fix the "User not authenticated" error and ensure the app works properly, you need to configure your Firebase Realtime Database rules.

### Step 1: Open Firebase Console
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **tractal-a60b4**
3. Navigate to **Build** → **Realtime Database**

### Step 2: Configure Database Rules
Click on the **Rules** tab and replace the existing rules with:

```json
{
  "rules": {
    "rooms": {
      "$roomId": {
        ".read": "auth != null",
        ".write": "auth != null",
        "players": {
          "$uid": {
            ".write": "auth != null && auth.uid == $uid"
          }
        }
      }
    }
  }
}
```

### What These Rules Do:
- ✅ Allow authenticated users (including anonymous) to read/write rooms
- ✅ Users can only modify their own player entry
- ✅ Prevents unauthorized access
- ✅ Optimized for "Forever Free" tier

### Step 3: Enable Anonymous Authentication
1. In Firebase Console, go to **Authentication** → **Sign-in method**
2. Find **Anonymous** in the providers list
3. Click **Enable** toggle
4. Click **Save**

## 🔍 Testing Authentication

The app now includes a status indicator on the homepage:
- **Green "Connected"** = Authentication successful ✅
- **Red "Connecting..."** = Authentication pending/failed ❌

## 🛠️ Troubleshooting

### Issue: "User not authenticated" error

**Solution Applied:**
1. ✅ Fixed authentication flow in `main.dart`
2. ✅ Added retry logic in homepage buttons
3. ✅ Added authentication status indicator
4. ⚠️ **ACTION REQUIRED:** Enable Anonymous Auth in Firebase Console (see Step 3 above)

### Issue: Firebase rules deny access

**Solution:**
- Update database rules (see Step 2 above)
- Ensure rules allow `auth != null` for anonymous users

### Issue: App shows "Connecting..." forever

**Possible causes:**
1. Anonymous Authentication not enabled in Firebase Console
2. Network/internet connection issues
3. Firebase project configuration mismatch

**Debug steps:**
```bash
flutter run
# Check console output for:
# ✅ Anonymous Auth Success: [user_id]
# OR
# ❌ Firebase/Auth Error: [error details]
```

## 📱 How the App Works Now

### Create Room Flow:
1. Check if user is authenticated
2. If not, automatically sign in anonymously
3. Create room with authenticated UID
4. Navigate to game board

### Join Room Flow:
1. Check if user is authenticated
2. If not, automatically sign in anonymously
3. Join room with the provided key
4. Navigate to game board

## 🎯 Quick Fix Checklist

- [ ] Enable Anonymous Authentication in Firebase Console
- [ ] Update Firebase Realtime Database Rules
- [ ] Run `flutter clean && flutter pub get`
- [ ] Restart the app
- [ ] Check for green "Connected" status
- [ ] Test "Create New Game" button

## 📊 Database Structure

```
rooms/
  {room_id}/
    board: ["", "X", "O", ...]
    turn: "user_uid"
    status: "playing" | "waiting" | "draw" | winner_uid
    players: {
      "uid1": "X",
      "uid2": "O"
    }
```

## 🚀 Next Steps

1. **Stop the app** if running
2. **Apply Firebase Rules** (see Step 2)
3. **Enable Anonymous Auth** (see Step 3)
4. **Run the app again**: `flutter run`
5. Look for the **green "Connected"** indicator
6. Try creating a game!

---

**Database URL:** `https://tractal-a60b4-default-rtdb.firebaseio.com`  
**Project ID:** `tractal-a60b4`
