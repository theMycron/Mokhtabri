# Mokhtabri
iOS app that allows users to find hospitals or labs and book packages online.

This app was made by:

- 202100937 Yousif Alhawaj
- 202101293 Ali Abdulrasool
- 202102290 Fatema Naser
- 202101800 Maryam Aleskafi
- 202103422 Noora Qasim

<img width="509" alt="Labs page" src="https://github.com/theMycron/Mokhtabri/assets/134844972/b81c23b7-a090-456c-a408-480c4585735e">

# Setting up the Project
The project was designed to run on iPhone 14 Pro and iPad Pro 12.9-inch.

Sample data will be loaded if no AppData was found. The sample data includes a number of patients, bookings, hospitals, and labs, with tests for some facilities and some packages. The sample packages have some inaccurate data (the tests listed in the image are different from the tests stored for the package) because of time constraints, but the sample data as a whole should resemble real-world usage of the app.

The KingFisher library was used in this project to support loading and caching images into local storage.
Firebase Storage was used for storing facility and service images.
Firebase Auth was used for authenticating user emails and passwords.

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
- Sample Patient (Fatema)
   - Email: fateman376@gmail.com
   - Password: 12345678
- Sample Patient (Fatema)
   - Email: hamoodhaboob@gmail.com
   - Password: 12345678

# Screenshots

<img width="509" alt="Screenshot 2024-06-10 at 11 52 29ΓÇ»PM" src="https://github.com/theMycron/Mokhtabri/assets/134844972/f1985ff8-288c-4987-b612-84d2f46a4041">
<img width="509" alt="Screenshot 2024-06-10 at 11 56 33ΓÇ»PM" src="https://github.com/theMycron/Mokhtabri/assets/134844972/5e2b50a3-f177-4e37-b802-3b8c5e5009bc">
<img width="509" alt="Screenshot 2024-06-10 at 11 57 19ΓÇ»PM" src="https://github.com/theMycron/Mokhtabri/assets/134844972/613e5007-98be-4b38-aa10-4ccbce9dea7a">
<img width="509" alt="Screenshot 2024-06-11 at 12 03 47ΓÇ»AM" src="https://github.com/theMycron/Mokhtabri/assets/134844972/292336ce-eb10-4faf-80ce-7eb82180221a">
<img width="509" alt="Screenshot 2024-06-11 at 12 03 55ΓÇ»AM" src="https://github.com/theMycron/Mokhtabri/assets/134844972/259e38fd-4825-455a-a1a8-e24b0de5c250">
<img width="509" alt="Screenshot 2024-06-11 at 12 05 34ΓÇ»AM" src="https://github.com/theMycron/Mokhtabri/assets/134844972/81ca4a7d-05e2-4bf6-a7cd-0d8fbb71bb2a">


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
### Patient Home 
- the way the data is arranged in cells changed, added only relevant data to the cell.
### Patient settings 
- Changed fields that can be updated
- Added few extra alerts for the validation of data changed ( passwords and profile data)
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
