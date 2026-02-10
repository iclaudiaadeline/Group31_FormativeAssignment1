# Offline Support Testing Guide

## Quick Testing Checklist

This guide provides step-by-step instructions for manually testing the offline support and sync indicators feature.

## Prerequisites

- Flutter app installed on a physical device or emulator
- Firebase project configured and connected
- Internet connection available

## Test 1: Verify Firestore Offline Persistence

### Steps:
1. ✅ Launch the app with internet connection
2. ✅ Navigate to Assignments screen
3. ✅ Create a new assignment (e.g., "Test Assignment 1")
4. ✅ Navigate to Schedule screen
5. ✅ Create a new session (e.g., "Test Session 1")
6. ✅ Verify items appear in the lists
7. ✅ Check Firebase Console to confirm data is saved

### Expected Result:
- All items created successfully
- Data visible in Firebase Console
- No errors displayed

## Test 2: Verify Sync Status Indicator in AppBar

### Steps:
1. ✅ Open the app (with internet connection)
2. ✅ Check Dashboard AppBar - should show green "Online" indicator with text
3. ✅ Navigate to Assignments screen - should show green cloud icon (compact)
4. ✅ Navigate to Schedule screen - should show green cloud icon (compact)
5. ✅ Verify all indicators are visible and properly colored

### Expected Result:
- Dashboard: Green cloud icon + "Online" text
- Assignments: Green cloud icon only
- Schedule: Green cloud icon only
- All indicators clearly visible in AppBar

## Test 3: Test Offline Badge Display

### Steps:
1. ✅ Open Dashboard screen
2. ✅ Turn off WiFi and mobile data on device
3. ✅ Wait 2-3 seconds for connectivity change detection
4. ✅ Observe the Dashboard screen

### Expected Result:
- Red "Offline" badge appears at top of Dashboard
- AppBar indicator changes to red cloud-off icon
- Badge is prominent and clearly visible
- No app crashes or errors

## Test 4: Test Offline CRUD Operations - Assignments

### Steps:
1. ✅ Ensure device is offline (WiFi and mobile data off)
2. ✅ Navigate to Assignments screen
3. ✅ Create a new assignment:
   - Title: "Offline Assignment"
   - Course: "Test Course"
   - Due Date: Tomorrow
   - Priority: High
4. ✅ Tap Save
5. ✅ Verify assignment appears in the list
6. ✅ Edit the assignment (change title to "Offline Assignment - Edited")
7. ✅ Verify changes appear immediately
8. ✅ Toggle completion status
9. ✅ Verify status changes immediately

### Expected Result:
- All operations work without errors
- UI updates immediately (optimistic updates)
- No error messages or loading failures
- Assignment persists in list

## Test 5: Test Offline CRUD Operations - Sessions

### Steps:
1. ✅ Ensure device is still offline
2. ✅ Navigate to Schedule screen
3. ✅ Create a new session:
   - Title: "Offline Session"
   - Date: Today
   - Start Time: 10:00 AM
   - End Time: 11:00 AM
   - Location: "Room 101"
   - Type: Class
4. ✅ Tap Save
5. ✅ Verify session appears in the schedule
6. ✅ Record attendance for the session (mark as Present)
7. ✅ Verify attendance is recorded
8. ✅ Edit the session (change location to "Room 202")
9. ✅ Verify changes appear immediately

### Expected Result:
- All operations work without errors
- UI updates immediately
- No error messages
- Session persists in schedule

## Test 6: Test Sync When Connectivity Restored

### Steps:
1. ✅ Ensure you have made changes while offline (from Tests 4 & 5)
2. ✅ Turn on WiFi or mobile data
3. ✅ Wait 2-3 seconds
4. ✅ Observe the sync status indicator in AppBar
5. ✅ Wait for sync to complete (indicator should change from orange to green)
6. ✅ Open Firebase Console
7. ✅ Verify all offline changes are now in Firestore:
   - "Offline Assignment - Edited" in assignments collection
   - "Offline Session" in sessions collection
   - Attendance record for the session

### Expected Result:
- Sync indicator briefly shows orange "Syncing..." with spinner
- After 2-3 seconds, indicator changes to green "Online"
- Offline badge disappears from Dashboard
- All offline changes visible in Firebase Console
- No data loss

## Test 7: Test Delete Operations Offline

### Steps:
1. ✅ Turn off internet connection again
2. ✅ Navigate to Assignments screen
3. ✅ Delete the "Offline Assignment - Edited"
4. ✅ Verify it disappears from the list
5. ✅ Navigate to Schedule screen
6. ✅ Delete the "Offline Session"
7. ✅ Verify it disappears from the schedule
8. ✅ Turn on internet connection
9. ✅ Wait for sync to complete
10. ✅ Check Firebase Console
11. ✅ Verify deleted items are removed from Firestore

### Expected Result:
- Delete operations work offline
- Items removed from UI immediately
- After sync, items removed from Firebase
- No orphaned data in Firestore

## Test 8: Test Dashboard Data While Offline

### Steps:
1. ✅ Ensure device is offline
2. ✅ Navigate to Dashboard screen
3. ✅ Verify all dashboard cards display correctly:
   - Current date
   - Academic week
   - Today's sessions
   - Upcoming assignments
   - Attendance percentage
   - Pending assignments count
4. ✅ Pull down to refresh
5. ✅ Verify refresh works with cached data

### Expected Result:
- All dashboard data displays correctly
- Data is from local cache
- Refresh works without errors
- Offline badge visible at top

## Test 9: Test Navigation State Preservation

### Steps:
1. ✅ While offline, navigate to Assignments screen
2. ✅ Scroll down the list
3. ✅ Navigate to Schedule screen
4. ✅ Navigate back to Assignments screen
5. ✅ Verify scroll position is preserved
6. ✅ Navigate to Dashboard
7. ✅ Navigate back to Assignments
8. ✅ Verify list state is still preserved

### Expected Result:
- Scroll positions preserved
- No data reloading
- Smooth navigation
- State maintained across tab switches

## Test 10: Test Multi-Device Sync (Optional)

### Prerequisites:
- Two devices with the app installed
- Both connected to the same Firebase project

### Steps:
1. ✅ Device A: Online, viewing Assignments screen
2. ✅ Device B: Go offline
3. ✅ Device B: Create assignment "Multi-Device Test"
4. ✅ Device B: Go back online
5. ✅ Wait for sync to complete on Device B
6. ✅ Device A: Observe the assignments list
7. ✅ Verify "Multi-Device Test" appears on Device A automatically

### Expected Result:
- Changes from Device B sync to Firestore
- Device A receives real-time update
- Assignment appears on Device A without manual refresh
- No conflicts or data loss

## Test 11: Test Rapid Online/Offline Transitions

### Steps:
1. ✅ Start with device online
2. ✅ Turn off internet
3. ✅ Wait 2 seconds
4. ✅ Turn on internet
5. ✅ Wait 2 seconds
6. ✅ Repeat steps 2-5 three times
7. ✅ Observe sync indicator behavior
8. ✅ Verify no crashes or errors

### Expected Result:
- Sync indicator updates correctly each time
- No crashes or freezes
- App remains responsive
- All state transitions handled gracefully

## Test 12: Test Long Offline Period

### Steps:
1. ✅ Turn off internet connection
2. ✅ Create 5 assignments
3. ✅ Create 5 sessions
4. ✅ Edit 3 existing items
5. ✅ Delete 2 items
6. ✅ Record attendance for 3 sessions
7. ✅ Wait 5 minutes (simulate long offline period)
8. ✅ Turn on internet connection
9. ✅ Wait for sync to complete
10. ✅ Verify all changes in Firebase Console

### Expected Result:
- All operations work offline
- No data loss after long offline period
- Sync completes successfully
- All changes reflected in Firestore
- Correct order of operations maintained

## Common Issues and Solutions

### Issue: Sync indicator not updating
**Solution**: 
- Pull down to refresh on Dashboard
- Check device connectivity settings
- Restart the app

### Issue: Offline badge not appearing
**Solution**:
- Wait 3-5 seconds after disconnecting
- Ensure connectivity_plus plugin is installed
- Check device airplane mode is not enabled

### Issue: Changes not syncing
**Solution**:
- Verify internet connection is stable
- Check Firebase Console for errors
- Ensure Firestore security rules allow writes
- Try force-closing and reopening the app

### Issue: App crashes when going offline
**Solution**:
- This should not happen - report as a bug
- Check error logs
- Verify Firestore offline persistence is enabled

## Success Criteria

All tests should pass with:
- ✅ No crashes or errors
- ✅ All CRUD operations work offline
- ✅ Sync indicators display correctly
- ✅ Data syncs successfully when online
- ✅ No data loss
- ✅ Smooth user experience

## Reporting Issues

If any test fails, document:
1. Test number and name
2. Steps to reproduce
3. Expected vs actual result
4. Device information
5. Error messages (if any)
6. Screenshots or screen recording

## Conclusion

This comprehensive testing guide ensures that the offline support feature works correctly in all scenarios. Complete all tests before marking the task as done.
