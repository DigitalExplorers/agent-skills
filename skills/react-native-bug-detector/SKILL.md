---
name: react-native-bug-detector
description: Detects React Native specific bugs including JS thread blocking, memory leaks, FlatList misuse, animation issues, platform-specific breakage, navigation bugs, AsyncStorage misuse, keyboard handling, and touch/gesture problems
metadata:
  version: 1.0.0
---

# React Native Bug Detector

## Provides

- JS thread and animation performance bug detection
- Memory leak identification (listeners, timers, subscriptions)
- FlatList and ScrollView misuse checks
- Platform-specific (iOS vs Android) bug detection
- Navigation and auth guard review
- AsyncStorage and secure storage misuse checks
- Touch, gesture, layout, and keyboard handling bugs
- Permissions and state/async bug detection
- Severity-ranked findings with file references and fix guidance

## Use When

- Debugging unexpected crashes or freezes in a React Native app
- Investigating performance issues, dropped frames, or slow screens
- Reviewing React Native code for correctness and mobile-specific pitfalls
- Auditing a React Native codebase before release
- Investigating bugs that only appear on iOS or only on Android
- Reviewing navigation, auth flow, or data fetching behavior in a mobile app

---

## Instructions

### 1. Identify the Affected Screen or Flow

- Start with the screen, navigator, or component involved in the reported bug
- Trace the component tree from the entry point (route or stack screen) downward
- Identify all data sources: API calls, AsyncStorage reads, context, redux/zustand store
- Focus on the smallest code path that can explain the observed behavior before reviewing unrelated files

---

### 2. Check for JS Thread Blocking

- Look for heavy computation running directly inside render functions or `useEffect` without deferral
- Flag synchronous loops, large array sorts, data transformations, or JSON parsing on large datasets performed during render or on the main execution path
- Check whether `InteractionManager.runAfterInteractions()` is used for expensive operations that should run after animations complete
- Confirm that navigation transitions are not being blocked by synchronous work triggered on screen mount

Examples to flag:

- Large `data.map().filter().reduce()` chains computed inline during render
- Heavy data processing inside `useEffect` without deferral to a worker or deferred task
- Synchronous file reads or database queries blocking the JS thread on screen load

---

### 3. Check Animation Bugs

- Confirm every `Animated` API usage includes `useNativeDriver: true` where applicable — missing this forces the animation through the JS thread and causes jank
- Flag `useNativeDriver: false` on animations that animate `transform` or `opacity`, as these can use the native driver
- Check `LayoutAnimation` calls on Android — `UIManager.setLayoutAnimationEnabledExperimental(true)` must be called before use or the animation silently fails
- Review Reanimated worklets for accidental calls to JS-side functions, which break the UI thread execution guarantee

Examples to flag:

- `Animated.timing(value, { toValue: 1, duration: 300 })` without `useNativeDriver: true`
- `LayoutAnimation.configureNext(...)` on Android without the experimental flag enabled
- Reanimated `runOnUI` worklet calling a regular JS function

---

### 4. Check FlatList and ScrollView Misuse

- Flag `ScrollView` used to render dynamic or large lists — `FlatList` or `SectionList` should be used instead to avoid rendering all items at once
- Check that `keyExtractor` returns a stable unique string per item — missing or unstable keys cause incorrect re-renders and recycling bugs
- Confirm `renderItem` is wrapped in `useCallback` — a new function reference on every render causes every visible item to re-render
- Check whether `getItemLayout` is defined for lists with fixed-height rows — without it, `scrollToIndex` and initial scroll position are unreliable
- Review large lists for missing performance props: `removeClippedSubviews`, `initialNumToRender`, `maxToRenderPerBatch`, `windowSize`
- Flag `onEndReached` implementations that fire multiple times — missing `onEndReachedThreshold` tuning or a loading guard causes duplicate pagination requests

Examples to flag:

- `<ScrollView>{items.map(item => <Row key={item.id} />)}</ScrollView>` for lists with more than ~20 items
- `renderItem={(item) => <Row data={item} />}` defined inline without `useCallback`
- `FlatList` with hundreds of items and no `getItemLayout`, `removeClippedSubviews`, or batch tuning

---

### 5. Check for Memory Leaks

- Review every `useEffect` that registers a listener or subscription — confirm the cleanup function removes it
- Flag `AppState`, `Keyboard`, `NetInfo`, `Linking`, and `BackHandler` event listeners added without a corresponding `removeEventListener` or subscription `.remove()` in the cleanup
- Check for `setTimeout` and `setInterval` calls not cleared with `clearTimeout` / `clearInterval` in the `useEffect` cleanup
- Look for async operations (API calls, promises) that call `setState` or dispatch after the component may have unmounted — flag missing cancellation or mounted-flag guards
- Review Firebase, WebSocket, and EventEmitter subscriptions for missing cleanup

Examples to flag:

- `AppState.addEventListener('change', handler)` with no removal in cleanup
- `setInterval(fetchData, 5000)` with no `clearInterval` in the `useEffect` return
- `fetchData().then(data => setState(data))` with no check that the component is still mounted

---

### 6. Check Platform-Specific Bugs (iOS vs Android)

- Identify code paths with platform-sensitive behavior and confirm `Platform.OS` or `Platform.select()` is used where needed
- Check `KeyboardAvoidingView` behavior prop — `'padding'` is correct for iOS, `'height'` for Android; using one value for both platforms causes broken keyboard avoidance on one platform
- Confirm `SafeAreaView` or `useSafeAreaInsets` is used on screens to prevent content being obscured by notches, the Dynamic Island, the status bar, or the Android gesture navigation bar
- Check Android back button handling — screens that should intercept the hardware back button need a `BackHandler` listener or React Navigation's `beforeRemove` event
- Flag text components that do not handle Android font scaling — if `allowFontScaling` is not controlled, system font size changes can break layouts

Examples to flag:

- `<KeyboardAvoidingView behavior="padding">` used on Android without platform check
- A full-screen modal with no `SafeAreaView` or inset handling
- A screen with a confirm/discard flow that does not handle the Android back button
- Fixed-height containers with text that overflows when system font size is increased

---

### 7. Check Navigation Bugs

- Review auth-protected screens and confirm navigation guards prevent unauthenticated access — check whether the navigator conditionally renders screens based on auth state
- Confirm navigation state is fully reset on logout — users should not be able to navigate back to authenticated screens after logging out
- Check whether `useEffect` is used to load screen data that should refresh every time the screen is focused — this should use `useFocusEffect` instead
- Flag buttons or links that trigger navigation without debouncing or a `disabled` state — rapid presses can push duplicate screens onto the stack
- Review deep link handling for cold start crashes or missing parameter validation

Examples to flag:

- A protected screen rendered unconditionally regardless of auth state
- `navigation.navigate('Home')` called on logout without resetting the navigation stack
- `useEffect(() => fetchData(), [])` on a screen that should reload data each time it is visited
- A `navigate` call in `onPress` with no guard against double-tap

---

### 8. Check AsyncStorage Usage

- Find every `AsyncStorage` read and write and confirm it is wrapped in `try/catch` — unhandled rejections cause silent failures that are hard to debug
- Confirm `await` is used on all AsyncStorage calls — missing await causes race conditions where the app proceeds before the read or write completes
- Flag sensitive data stored in AsyncStorage — auth tokens, passwords, PINs, and personal data should use `react-native-keychain` or Expo `SecureStore` instead
- Check for large objects or arrays serialized and stored in AsyncStorage — this causes slow reads and can trigger ANR dialogs on Android

Examples to flag:

- `AsyncStorage.setItem('token', token)` without `await` and without `try/catch`
- Auth tokens, session data, or user credentials stored in AsyncStorage
- An entire API response object serialized and written to AsyncStorage on every fetch

---

### 9. Check Image Bugs

- Confirm that `Image` components with remote URIs have explicit `width` and `height` — without dimensions the image collapses to 0×0 and is invisible
- Check that `resizeMode` is set appropriately — missing `resizeMode` causes stretched or incorrectly cropped images on different screen sizes
- Flag large remote images loaded without a caching library — images re-download on every render without `react-native-fast-image` or equivalent
- Check for missing `defaultSource` or a placeholder component while remote images load

Examples to flag:

- `<Image source={{ uri: url }} />` with no `style` defining width and height
- Profile or banner images with no `resizeMode` set
- A feed of user images with no caching layer

---

### 10. Check Touch and Gesture Bugs

- Flag nested touchable components — a `TouchableOpacity` inside another `Touchable` causes the inner press to be swallowed on Android
- Check touch target sizes — interactive elements smaller than 44×44 points should have `hitSlop` defined to make them easier to tap
- Confirm action buttons (submit, confirm, delete) have a `disabled` prop set to `true` while an async operation is in progress — missing this allows double-submit
- Review `onPress` handlers on buttons that trigger API calls for missing debounce logic — rapid taps can fire multiple requests

Examples to flag:

- `<TouchableOpacity><TouchableHighlight>...</TouchableHighlight></TouchableOpacity>`
- A close icon with `width: 20, height: 20` and no `hitSlop`
- A submit button with no `disabled` state during form submission

---

### 11. Check Layout and Style Bugs

- Flag containers missing `flex: 1` that are expected to fill available space — without it the component renders with zero height and is invisible
- Check `width: '100%'` used inside a horizontal `ScrollView` — the parent has no defined width, so percentage dimensions resolve incorrectly
- Review `position: 'absolute'` usage without all necessary position values defined — unpredictable placement across screen sizes
- Flag missing `overflow: 'hidden'` on containers where children are expected to be clipped
- Check for hardcoded pixel values that do not account for different screen densities — use `Dimensions`, `useWindowDimensions`, or responsive scaling utilities

Examples to flag:

- A screen container with no `flex: 1` that renders blank
- `<View style={{ width: '100%' }}>` as a direct child of `<ScrollView horizontal>`
- A card with `borderRadius` clipping content but missing `overflow: 'hidden'`

---

### 12. Check Keyboard Handling

- Confirm screens with text inputs use `KeyboardAvoidingView` to prevent the keyboard from covering the focused input
- Check that tapping outside an input dismisses the keyboard — missing `Keyboard.dismiss()` or a `TouchableWithoutFeedback` wrapper leaves the keyboard stuck open
- Verify that `ScrollView` wrapping a form scrolls the focused input into view when the keyboard appears — confirm `keyboardShouldPersistTaps="handled"` is set where needed

Examples to flag:

- A login or signup form with no `KeyboardAvoidingView`
- A screen where tapping the background does not dismiss the keyboard
- A form inside `ScrollView` that does not scroll to the active field when the keyboard opens

---

### 13. Check Permissions Handling

- Find every use of device features that require permission — camera, microphone, location, contacts, notifications, photo library — and confirm permission is requested before use
- Check that permission denial is handled gracefully — the app should not crash or show a blank state when permission is denied
- Confirm the current permission status is checked before requesting again — repeatedly requesting a denied permission on iOS causes the system to block future requests

Examples to flag:

- `CameraRoll.getPhotos(...)` called without first checking and requesting photo library permission
- A denied camera permission that causes an unhandled error instead of a user-friendly message
- `PermissionsAndroid.request(...)` called on every mount without checking the current status first

---

### 14. Check State and Async Bugs

- Flag `useEffect` hooks with missing or incorrect dependencies — stale closures capture outdated state or prop values silently
- Review async data fetching for race conditions — multiple in-flight requests where a slower earlier response overwrites a faster later one
- Confirm all network calls have loading and error states — missing these leaves users with a blank screen or no feedback on failure
- Check for `setState` called conditionally inside async callbacks without verifying the component is still mounted

Examples to flag:

- `useEffect(() => { fetchUser(userId); }, [])` where `userId` changes but the effect does not re-run
- Two concurrent API calls where the first response can overwrite the second if it resolves later
- A screen that shows nothing on network error with no retry or message

---

### 15. Report Findings by Severity

Group all findings under the following severity levels:

- **Critical** — app crashes, data loss, authentication bypass via navigation, uncleared timers causing memory exhaustion
- **High** — JS thread blocking causing frozen UI, missing memory leak cleanup, broken platform behavior, double-submit bugs
- **Medium** — FlatList performance issues, platform-specific layout breakage, missing keyboard handling, stale closures
- **Low** — missing image dimensions, small touch targets without hitSlop, missing loading states, minor optimization gaps

Standard audit flow:

1. Identify the affected screen or component
2. Check JS thread, animation, and rendering performance
3. Review memory management and cleanup
4. Audit platform-specific and navigation behavior
5. Check storage, permissions, and async state handling
6. Report findings with file, line, explanation, and fix

---

### 16. Safety Notes

- Do not flag a pattern as a bug unless the code behavior supports it — check whether a cleanup function actually exists before reporting a memory leak
- Distinguish confirmed bugs from patterns that are risky but require runtime context to verify
- React Native bridge behavior, Hermes optimizations, and native module interactions may affect findings — note uncertainty when native code is involved
- Platform-specific bugs may not be visible in code alone — flag anything that behaves differently on iOS vs Android without explicit platform handling

## Output Format

### Critical Bugs

- **Type** — e.g. Memory Leak
- **File** — path and line number
- **Explanation** — what is wrong and why it causes the issue
- **Fix** — specific code-level recommendation

### High Priority Issues

- **Type**
- **File**
- **Explanation**
- **Fix**

### Medium Issues

- **Type**
- **File**
- **Explanation**
- **Fix**

### Low / Optimization Suggestions

- **Type**
- **Suggestion**

### Passed Checks

- Checks that were reviewed and confirmed correct

## Standard Flow

```
identify affected screen or flow
-> check JS thread blocking and animation bugs
-> review FlatList and ScrollView usage
-> audit memory leaks and cleanup
-> check platform-specific behavior (iOS vs Android)
-> review navigation and auth guard correctness
-> audit AsyncStorage, permissions, and async state
-> check touch, layout, keyboard, and image handling
-> report findings by severity with file references and fixes
```
