# getx_ecommerce

This is an e-commerce Flutter application using GetX for state management. It includes features for product browsing, cart management, ordering, and a calendar synchronization module. 

The application uses Firebase Auth for user authentication and Cloud Firestore for storing application data in the cloud. Locally, it employs a multi-database strategy. It uses the sqflite package to manage a local SQLite database for registration or simple local caching, and the Realm database (with code generation via build_runner) to persist cart items and complex local state.

The app's product and cart systems are managed by GetX controllers, which handle adding items to the cart and processing orders. 

A significant feature is the calendar sync module. The app uses the table_calendar package to display a calendar interface. It integrates with the user's native device calendar using the device_calendar package, allowing the app to read and write events (like delivery dates) directly to the phone's calendar system.

To keep data synchronized when the app is running in the background, it uses the workmanager package to execute periodic sync tasks. The connectivity_plus package is used to check network availability before attempting network requests. 

The app uses the http package for network calls, image_picker for selecting images, uuid for generating unique IDs, and intl for formatting dates.

Technologies used: Flutter, GetX (get + get_x), Firebase Core, Firebase Auth, Cloud Firestore, sqflite, Realm (with build_runner), device_calendar, workmanager, connectivity_plus, table_calendar, image_picker, http, intl, uuid, path_provider, path.

## Working Flow
1. Open the app -> GetX controllers check authentication status via Firebase Auth.
2. Authenticate -> Users log in or register. Registration data may be cached locally via SQLite.
3. Browse Products -> The app fetches products (from Firestore or local Realm database) and displays them.
4. Add to Cart -> The GetX controller updates the cart state and saves the cart item locally into the Realm database.
5. Place Order -> The order details are processed and saved to Cloud Firestore, and the local cart is cleared.
6. Open Calendar -> The table_calendar widget displays a calendar interface.
7. Sync Event -> When an event (like a delivery reminder) is created, the app uses the device_calendar package to insert the event into the operating system's native calendar application.
8. Background Sync -> The workmanager package periodically triggers a headless task to sync local Realm data with Firestore.
