<img width="420" alt="image" src="https://github.com/theMycron/Mokhtabri/assets/134844972/a55d825f-0c0e-40ba-8586-358e0d9632fb"># Mokhtabri
iOS app that allows users to find hospitals or labs and book packages online.

This app was made by:

- 202100937 Yousif Alhawaj
- 202101293 Ali Abdulrasool
- 202102290 Fatema Naser
- 202101800 Maryam Aleskafi
- 202103422 Noora Qasim

# Setting up the Project
The project was designed to run on iPhone 14 Pro and iPad Pro 12.9-inch.

Sample data will be loaded if no AppData was found. The sample data includes a number of patients, bookings, hospitals, and labs, with tests for some facilities and some packages. The sample packages have some inaccurate data (the tests listed in the image are different from the tests stored for the package) because of time constraints, but the sample data as a whole should resemble real-world usage of the app.

The KingFisher library was used in this project to support loading and caching images into local storage.

## Login Credentials
- Admin
   - Email: admin@gmail.com
   - Password: 12345678
- Sample Facility (Al Salam)
   - Email: alsalam@mokhtabri.com
   - Password: 12345678
- Sample Facility (Al Hilal)
   - Email: alhilal@mokhtabri.com
   - Password: 12345678
- Sample Patient (Noora)
   - Email: nooraw376@gmail.com
   - Password: 12345678


# List of Features and Changes from Prototype
The following is a list of developers and their features, along with any changes made from the prototype.
## Yousif Alhawaj

### Admin View/Delete Facilities
- Changed font color of City field to gray
### Admin Add/Edit Facilities
- Username has been replaced with Email
- Design of 'Add Image' has been changed
- Swiping down to dismiss the modal will prompt the user to discard changes or cancel
- Email cannot be changed as Firebase does not have good support for it
## Ali Abdulrasool

### Lab View/Delete Services
- The icons have been unified between tests and medical packages. 
### Lab Add/Edit Services
- Removed navigation bar from select tests screen, can return by swiping down
- The category now is a textbox
- The edit page now has a segmented control to change between test and package
## Fatema Naser
### View labs / tests (including Search, Sort, Filter)  
### Settings Page

## Maryam Aleskafi

### Login (All Users)
- Changed from using usernames to emails in order to implement Firebase Auth (sign in with email and password method)
### Register Patient
- The registration screen is now one page only, previously it was multiple seperate screens due to figma’s big date picker which needed a seperate page, but in ios it is quite small so it fits one screen with all the fields

## Noora Qasim
### Lab Bookings
### Booking History (Patient/Lab)
### View/Complete/Cancel Bookings (Lab)
- Changed the confirmation for booking page with an alert that says booking successful
