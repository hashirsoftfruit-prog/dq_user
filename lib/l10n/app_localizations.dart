import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ml.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ml')
  ];

  /// No description provided for @chooseLocation.
  ///
  /// In en, this message translates to:
  /// **'Choose Location'**
  String get chooseLocation;

  /// No description provided for @bookAppoinment.
  ///
  /// In en, this message translates to:
  /// **'Book Your Appointment'**
  String get bookAppoinment;

  /// No description provided for @liveVideoConsult.
  ///
  /// In en, this message translates to:
  /// **'Live Video Consulting'**
  String get liveVideoConsult;

  /// No description provided for @liveVideoConsult2.
  ///
  /// In en, this message translates to:
  /// **'Live Video Consulting'**
  String get liveVideoConsult2;

  /// No description provided for @connectWithin30.
  ///
  /// In en, this message translates to:
  /// **'Connect within 30 Secs'**
  String get connectWithin30;

  /// No description provided for @onlineCounselling.
  ///
  /// In en, this message translates to:
  /// **'Online Counselling'**
  String get onlineCounselling;

  /// No description provided for @consultNow.
  ///
  /// In en, this message translates to:
  /// **'Consult Now'**
  String get consultNow;

  /// No description provided for @connectNow.
  ///
  /// In en, this message translates to:
  /// **'Connect Now'**
  String get connectNow;

  /// No description provided for @waitingForSomeBodyToAttend.
  ///
  /// In en, this message translates to:
  /// **'Nobody attended your consultation yet'**
  String get waitingForSomeBodyToAttend;

  /// No description provided for @ayurvedicTreatment.
  ///
  /// In en, this message translates to:
  /// **'Ayurvedic Treatment'**
  String get ayurvedicTreatment;

  /// No description provided for @findNearby.
  ///
  /// In en, this message translates to:
  /// **'Find Nearby'**
  String get findNearby;

  /// No description provided for @findDoctorsNearby.
  ///
  /// In en, this message translates to:
  /// **'Find Doctors Nearby'**
  String get findDoctorsNearby;

  /// No description provided for @upcomingAppoinments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointments'**
  String get upcomingAppoinments;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @physiciansYouConsulted.
  ///
  /// In en, this message translates to:
  /// **'Physicians you have consulted recently'**
  String get physiciansYouConsulted;

  /// No description provided for @appoinments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appoinments;

  /// No description provided for @searchSpecialitesSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Search Specialities/Symptoms'**
  String get searchSpecialitesSymptoms;

  /// No description provided for @weWillAssignYou.
  ///
  /// In en, this message translates to:
  /// **'We will assign You'**
  String get weWillAssignYou;

  /// No description provided for @theBestDoctor.
  ///
  /// In en, this message translates to:
  /// **'the best doctor'**
  String get theBestDoctor;

  /// No description provided for @preferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Preferred Language'**
  String get preferredLanguage;

  /// No description provided for @preferredDoc.
  ///
  /// In en, this message translates to:
  /// **'Doctor preference'**
  String get preferredDoc;

  /// No description provided for @noPreference.
  ///
  /// In en, this message translates to:
  /// **'No preferences'**
  String get noPreference;

  /// No description provided for @consultingFor.
  ///
  /// In en, this message translates to:
  /// **'Consulting For'**
  String get consultingFor;

  /// No description provided for @scheduledTime.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Date & Time'**
  String get scheduledTime;

  /// No description provided for @selectPatientFillDetails.
  ///
  /// In en, this message translates to:
  /// **'Select the patient'**
  String get selectPatientFillDetails;

  /// No description provided for @applyCoupon.
  ///
  /// In en, this message translates to:
  /// **'Apply Coupon'**
  String get applyCoupon;

  /// No description provided for @thisCouponisNotApplic.
  ///
  /// In en, this message translates to:
  /// **'This coupon is not applicable'**
  String get thisCouponisNotApplic;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @notApplicable.
  ///
  /// In en, this message translates to:
  /// **'NOT APPLICABLE'**
  String get notApplicable;

  /// No description provided for @yourCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Your coupon code'**
  String get yourCouponCode;

  /// No description provided for @availableCoupons.
  ///
  /// In en, this message translates to:
  /// **'Available Coupons'**
  String get availableCoupons;

  /// No description provided for @couponNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Coupon not available'**
  String get couponNotAvailable;

  /// No description provided for @offersNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Offers not available'**
  String get offersNotAvailable;

  /// No description provided for @appointmentsNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Appointments'**
  String get appointmentsNotAvailable;

  /// No description provided for @noRecords.
  ///
  /// In en, this message translates to:
  /// **'No Records'**
  String get noRecords;

  /// No description provided for @noOffers.
  ///
  /// In en, this message translates to:
  /// **'No Offers'**
  String get noOffers;

  /// No description provided for @noPackages.
  ///
  /// In en, this message translates to:
  /// **'No Packages'**
  String get noPackages;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @noConsults.
  ///
  /// In en, this message translates to:
  /// **'No Consultations'**
  String get noConsults;

  /// No description provided for @noPatients.
  ///
  /// In en, this message translates to:
  /// **'No Members Added'**
  String get noPatients;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @noDoctors.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t consulted any doctors before'**
  String get noDoctors;

  /// No description provided for @noSpecialityDoctors.
  ///
  /// In en, this message translates to:
  /// **'No Doctors available'**
  String get noSpecialityDoctors;

  /// No description provided for @consultations.
  ///
  /// In en, this message translates to:
  /// **'Consultations'**
  String get consultations;

  /// No description provided for @offers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offers;

  /// No description provided for @myDoctors.
  ///
  /// In en, this message translates to:
  /// **'My Doctors'**
  String get myDoctors;

  /// No description provided for @myPatients.
  ///
  /// In en, this message translates to:
  /// **'Family members'**
  String get myPatients;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addMember.
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get addMember;

  /// No description provided for @editMember.
  ///
  /// In en, this message translates to:
  /// **'Edit Member'**
  String get editMember;

  /// No description provided for @bookingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking Successful'**
  String get bookingSuccess;

  /// No description provided for @paymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful'**
  String get paymentSuccess;

  /// No description provided for @paymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Payment Details'**
  String get paymentDetails;

  /// No description provided for @closingMsg1.
  ///
  /// In en, this message translates to:
  /// **'Closing this page will interrupt your consultation'**
  String get closingMsg1;

  /// No description provided for @changePatientInfo.
  ///
  /// In en, this message translates to:
  /// **'Change Patient Info'**
  String get changePatientInfo;

  /// No description provided for @doctorDetailsNotAvail.
  ///
  /// In en, this message translates to:
  /// **'Doctor Details not Available'**
  String get doctorDetailsNotAvail;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @fees.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get fees;

  /// No description provided for @bookOnline.
  ///
  /// In en, this message translates to:
  /// **'Book Online'**
  String get bookOnline;

  /// No description provided for @bookClinic.
  ///
  /// In en, this message translates to:
  /// **'Book Clinic'**
  String get bookClinic;

  /// No description provided for @inClinic.
  ///
  /// In en, this message translates to:
  /// **'In-Clinic'**
  String get inClinic;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @doctorProfile.
  ///
  /// In en, this message translates to:
  /// **'Doctor’s profile'**
  String get doctorProfile;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @pickSlots.
  ///
  /// In en, this message translates to:
  /// **'Pick Slots'**
  String get pickSlots;

  /// No description provided for @selectSlot.
  ///
  /// In en, this message translates to:
  /// **'Select Slot'**
  String get selectSlot;

  /// No description provided for @scheduleBooking.
  ///
  /// In en, this message translates to:
  /// **'Schedule Booking'**
  String get scheduleBooking;

  /// No description provided for @slotsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Slots available'**
  String get slotsAvailable;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @findDoctorsClinic.
  ///
  /// In en, this message translates to:
  /// **'Find Doctor/ Clinic'**
  String get findDoctorsClinic;

  /// No description provided for @clinicsNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Clinics not available'**
  String get clinicsNotAvailable;

  /// No description provided for @consultationTime.
  ///
  /// In en, this message translates to:
  /// **'Consultation Time'**
  String get consultationTime;

  /// No description provided for @chooseClinic.
  ///
  /// In en, this message translates to:
  /// **'Choose Clinic'**
  String get chooseClinic;

  /// No description provided for @chooseSpeciality.
  ///
  /// In en, this message translates to:
  /// **'Choose Speciality'**
  String get chooseSpeciality;

  /// No description provided for @notFeelingWell.
  ///
  /// In en, this message translates to:
  /// **'Not Feeling well?'**
  String get notFeelingWell;

  /// No description provided for @treatYourMindWithProperCouncelling.
  ///
  /// In en, this message translates to:
  /// **'Treat your mind with proper counselling?'**
  String get treatYourMindWithProperCouncelling;

  /// No description provided for @chooseWhichTypeOfTherapyYouWant.
  ///
  /// In en, this message translates to:
  /// **'Choose Which Type of Therapy You Want'**
  String get chooseWhichTypeOfTherapyYouWant;

  /// No description provided for @chooseWhichTypeOfCounsellingYouWant.
  ///
  /// In en, this message translates to:
  /// **'Choose Which Type\nof Counselling You Want'**
  String get chooseWhichTypeOfCounsellingYouWant;

  /// No description provided for @chooseWhatAreYouSearchingFor.
  ///
  /// In en, this message translates to:
  /// **'Choose What Are You \nSearching For'**
  String get chooseWhatAreYouSearchingFor;

  /// No description provided for @chooseYourPreferredConsultationMode.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Preferred \nConsultation Mode.'**
  String get chooseYourPreferredConsultationMode;

  /// No description provided for @clinicConsultations.
  ///
  /// In en, this message translates to:
  /// **'Clinic Consultations'**
  String get clinicConsultations;

  /// No description provided for @onlineConsultations.
  ///
  /// In en, this message translates to:
  /// **'Online Consultations'**
  String get onlineConsultations;

  /// No description provided for @counsellingSection.
  ///
  /// In en, this message translates to:
  /// **'Counselling Section'**
  String get counsellingSection;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get recentSearches;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @specialities.
  ///
  /// In en, this message translates to:
  /// **'Specialities'**
  String get specialities;

  /// No description provided for @symptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get symptoms;

  /// No description provided for @doctors.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get doctors;

  /// No description provided for @clinics.
  ///
  /// In en, this message translates to:
  /// **'Clinics'**
  String get clinics;

  /// No description provided for @continue1.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue1;

  /// No description provided for @appoinmentDetailsNotAvail.
  ///
  /// In en, this message translates to:
  /// **'Appoinment details not available'**
  String get appoinmentDetailsNotAvail;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// No description provided for @appointmentId.
  ///
  /// In en, this message translates to:
  /// **'Appointment ID'**
  String get appointmentId;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @typeOfAppoinment.
  ///
  /// In en, this message translates to:
  /// **'Type of Appointment'**
  String get typeOfAppoinment;

  /// No description provided for @patientDetails.
  ///
  /// In en, this message translates to:
  /// **'Patient Details'**
  String get patientDetails;

  /// No description provided for @doctorDetails.
  ///
  /// In en, this message translates to:
  /// **'Doctor Details'**
  String get doctorDetails;

  /// No description provided for @clinicDetails.
  ///
  /// In en, this message translates to:
  /// **'Clinic Details'**
  String get clinicDetails;

  /// No description provided for @freefollowup.
  ///
  /// In en, this message translates to:
  /// **'Free Follow Up'**
  String get freefollowup;

  /// No description provided for @pleaseProvideTypeofRec.
  ///
  /// In en, this message translates to:
  /// **'Please provide type of record'**
  String get pleaseProvideTypeofRec;

  /// No description provided for @coupons.
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get coupons;

  /// No description provided for @discounts.
  ///
  /// In en, this message translates to:
  /// **'Discounts'**
  String get discounts;

  /// No description provided for @nowYourConsultationIs.
  ///
  /// In en, this message translates to:
  /// **'Now your consultation is'**
  String get nowYourConsultationIs;

  /// No description provided for @completelyFree.
  ///
  /// In en, this message translates to:
  /// **'completely Free'**
  String get completelyFree;

  /// No description provided for @forFamily.
  ///
  /// In en, this message translates to:
  /// **'For family'**
  String get forFamily;

  /// No description provided for @selectYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Select your Location'**
  String get selectYourLocation;

  /// No description provided for @searchLocation.
  ///
  /// In en, this message translates to:
  /// **'Search location'**
  String get searchLocation;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @popularCities.
  ///
  /// In en, this message translates to:
  /// **'Popular cities'**
  String get popularCities;

  /// No description provided for @enterPatientDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter Patient Details'**
  String get enterPatientDetails;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal info'**
  String get personalInfo;

  /// No description provided for @therapyProblems.
  ///
  /// In en, this message translates to:
  /// **'Therapy / Problems'**
  String get therapyProblems;

  /// No description provided for @patientName.
  ///
  /// In en, this message translates to:
  /// **'Patient Name'**
  String get patientName;

  /// No description provided for @firstname.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstname;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @relationWithPatient.
  ///
  /// In en, this message translates to:
  /// **'Relation with Patient'**
  String get relationWithPatient;

  /// No description provided for @medicalInfo.
  ///
  /// In en, this message translates to:
  /// **'Medical Info'**
  String get medicalInfo;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'(optional)'**
  String get optional;

  /// No description provided for @mandatory.
  ///
  /// In en, this message translates to:
  /// **'(mandatory)'**
  String get mandatory;

  /// No description provided for @allFieldsAreRequiredUnless.
  ///
  /// In en, this message translates to:
  /// **'All fields are required unless specified optional'**
  String get allFieldsAreRequiredUnless;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height(cm)'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight(kg)'**
  String get weight;

  /// No description provided for @bloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Blood Group(e.g.A+,O-)'**
  String get bloodGroup;

  /// No description provided for @bloodGroup2.
  ///
  /// In en, this message translates to:
  /// **'Blood Group'**
  String get bloodGroup2;

  /// No description provided for @bloodSugar.
  ///
  /// In en, this message translates to:
  /// **'Blood Sugar(e.g.140 mg/dL)'**
  String get bloodSugar;

  /// No description provided for @bloodSugar2.
  ///
  /// In en, this message translates to:
  /// **'Blood Sugar'**
  String get bloodSugar2;

  /// No description provided for @bloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure(e.g.115/75 mmHg)'**
  String get bloodPressure;

  /// No description provided for @bloodPressure2.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure'**
  String get bloodPressure2;

  /// No description provided for @serumCreatinine.
  ///
  /// In en, this message translates to:
  /// **'Serum Creatinine(e.g.1.20 mg/dL)'**
  String get serumCreatinine;

  /// No description provided for @serumCreatinine2.
  ///
  /// In en, this message translates to:
  /// **'Serum Creatinine'**
  String get serumCreatinine2;

  /// No description provided for @medicalRecords.
  ///
  /// In en, this message translates to:
  /// **'Medical Records'**
  String get medicalRecords;

  /// No description provided for @uploadFile.
  ///
  /// In en, this message translates to:
  /// **'Upload File'**
  String get uploadFile;

  /// No description provided for @medicalRecordsDiagnosisReport.
  ///
  /// In en, this message translates to:
  /// **'Medical records,diagnosis report ..etc'**
  String get medicalRecordsDiagnosisReport;

  /// No description provided for @maxCountAndFileSize.
  ///
  /// In en, this message translates to:
  /// **'(You can upload up to 5 files, with a total size limit of 30MB)'**
  String get maxCountAndFileSize;

  /// No description provided for @maritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get maritalStatus;

  /// No description provided for @married.
  ///
  /// In en, this message translates to:
  /// **'Married'**
  String get married;

  /// No description provided for @unmarried.
  ///
  /// In en, this message translates to:
  /// **'Unmarried'**
  String get unmarried;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @weOfferFreeConsultationForSeniors.
  ///
  /// In en, this message translates to:
  /// **'We offer free consultation for senior citizens'**
  String get weOfferFreeConsultationForSeniors;

  /// No description provided for @seniorCareOnDq.
  ///
  /// In en, this message translates to:
  /// **'Senior Care on DQ app'**
  String get seniorCareOnDq;

  /// No description provided for @verifyYourAge.
  ///
  /// In en, this message translates to:
  /// **'Verify your age'**
  String get verifyYourAge;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @completeVerification.
  ///
  /// In en, this message translates to:
  /// **'Complete verification'**
  String get completeVerification;

  /// No description provided for @chooseType.
  ///
  /// In en, this message translates to:
  /// **'Choose type'**
  String get chooseType;

  /// No description provided for @enterIdNo.
  ///
  /// In en, this message translates to:
  /// **'Enter ID No'**
  String get enterIdNo;

  /// No description provided for @typeOfRecord.
  ///
  /// In en, this message translates to:
  /// **'Type of Record'**
  String get typeOfRecord;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use current location'**
  String get useCurrentLocation;

  /// No description provided for @documentNo.
  ///
  /// In en, this message translates to:
  /// **'Document No'**
  String get documentNo;

  /// No description provided for @uploadSoftCopy.
  ///
  /// In en, this message translates to:
  /// **'Upload soft copy of your id card'**
  String get uploadSoftCopy;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @backQn.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backQn;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @answer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get answer;

  /// No description provided for @answers.
  ///
  /// In en, this message translates to:
  /// **'Answers'**
  String get answers;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @editYourResponse.
  ///
  /// In en, this message translates to:
  /// **'Edit your response '**
  String get editYourResponse;

  /// No description provided for @wasThisAnswerHelpful.
  ///
  /// In en, this message translates to:
  /// **'Was this answer helpful?'**
  String get wasThisAnswerHelpful;

  /// No description provided for @youMarkedThisResponseAsHelpful.
  ///
  /// In en, this message translates to:
  /// **'You marked this response as helpful'**
  String get youMarkedThisResponseAsHelpful;

  /// No description provided for @updating.
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get updating;

  /// No description provided for @oopsItLookLikeYouForgotToType.
  ///
  /// In en, this message translates to:
  /// **'Oops! It looks like you forgot to type your reply.'**
  String get oopsItLookLikeYouForgotToType;

  /// No description provided for @youMarkedThisResponseAsNotHelpful.
  ///
  /// In en, this message translates to:
  /// **'You marked this response as not helpful'**
  String get youMarkedThisResponseAsNotHelpful;

  /// No description provided for @appointmentCancelled.
  ///
  /// In en, this message translates to:
  /// **'Appointment Cancelled'**
  String get appointmentCancelled;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @doctorWantstoknowsomethingaboutu.
  ///
  /// In en, this message translates to:
  /// **'Doctor wants to know something about you!'**
  String get doctorWantstoknowsomethingaboutu;

  /// No description provided for @allergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get allergies;

  /// No description provided for @currentMedications.
  ///
  /// In en, this message translates to:
  /// **'Current Medications'**
  String get currentMedications;

  /// No description provided for @postMedications.
  ///
  /// In en, this message translates to:
  /// **'Past Medications'**
  String get postMedications;

  /// No description provided for @chronicDiseases.
  ///
  /// In en, this message translates to:
  /// **'Chronic Diseases'**
  String get chronicDiseases;

  /// No description provided for @injuries.
  ///
  /// In en, this message translates to:
  /// **'Injuries'**
  String get injuries;

  /// No description provided for @surgeries.
  ///
  /// In en, this message translates to:
  /// **'Surgeries'**
  String get surgeries;

  /// No description provided for @healthCareOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers For\nYour healthcare'**
  String get healthCareOffers;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @purchasedPackages.
  ///
  /// In en, this message translates to:
  /// **'Purchased Packages'**
  String get purchasedPackages;

  /// No description provided for @packages.
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get packages;

  String get paymentInfo;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get language;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @malayalam.
  ///
  /// In en, this message translates to:
  /// **'Malayalam'**
  String get malayalam;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @youMustAgreeTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'You must agree terms and conditions to continue'**
  String get youMustAgreeTermsAndConditions;

  /// No description provided for @selectPatientToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please select a patient to continue'**
  String get selectPatientToContinue;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @packageDetails.
  ///
  /// In en, this message translates to:
  /// **'Package Details'**
  String get packageDetails;

  /// No description provided for @addYourFamilyMembers.
  ///
  /// In en, this message translates to:
  /// **'Add your family members'**
  String get addYourFamilyMembers;

  /// No description provided for @addPackage.
  ///
  /// In en, this message translates to:
  /// **'Add Package'**
  String get addPackage;

  /// No description provided for @askQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask your question'**
  String get askQuestion;

  /// No description provided for @forum.
  ///
  /// In en, this message translates to:
  /// **'Forum'**
  String get forum;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @addFromPrescription.
  ///
  /// In en, this message translates to:
  /// **'Add From Prescription'**
  String get addFromPrescription;

  /// No description provided for @noOneAnswered.
  ///
  /// In en, this message translates to:
  /// **'No one answered'**
  String get noOneAnswered;

  /// No description provided for @youHaveNoPrescription.
  ///
  /// In en, this message translates to:
  /// **'You have no prescriptions received'**
  String get youHaveNoPrescription;

  /// No description provided for @medicalExpertsAnswersToYourQuestion.
  ///
  /// In en, this message translates to:
  /// **'Medical experts answers to your question'**
  String get medicalExpertsAnswersToYourQuestion;

  /// No description provided for @askYourDoubts.
  ///
  /// In en, this message translates to:
  /// **'Ask Your Doubts'**
  String get askYourDoubts;

  /// No description provided for @thisBookingIsComingUnderThePackage.
  ///
  /// In en, this message translates to:
  /// **'This Booking is coming under the package you have purchased'**
  String get thisBookingIsComingUnderThePackage;

  /// No description provided for @petCare.
  ///
  /// In en, this message translates to:
  /// **'Pet Care'**
  String get petCare;

  /// No description provided for @expertDoctorsPeopleAreHere.
  ///
  /// In en, this message translates to:
  /// **'Expert doctors & people are here to answer'**
  String get expertDoctorsPeopleAreHere;

  /// No description provided for @onlineVetConsultation.
  ///
  /// In en, this message translates to:
  /// **'Online Vet Consultation'**
  String get onlineVetConsultation;

  /// No description provided for @exclusiveOffers.
  ///
  /// In en, this message translates to:
  /// **'Exclusive Offers'**
  String get exclusiveOffers;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @whatAreYouLookingFor.
  ///
  /// In en, this message translates to:
  /// **'What are you looking for?'**
  String get whatAreYouLookingFor;

  /// No description provided for @petGrooming.
  ///
  /// In en, this message translates to:
  /// **'Pet Grooming'**
  String get petGrooming;

  /// No description provided for @addAComment.
  ///
  /// In en, this message translates to:
  /// **'Add a comment'**
  String get addAComment;

  /// No description provided for @addAReminder.
  ///
  /// In en, this message translates to:
  /// **'Add a reminder'**
  String get addAReminder;

  /// No description provided for @addNew.
  ///
  /// In en, this message translates to:
  /// **'Add new'**
  String get addNew;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @timeAndDosage.
  ///
  /// In en, this message translates to:
  /// **'Time & Dosage'**
  String get timeAndDosage;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @howManyTimesADay.
  ///
  /// In en, this message translates to:
  /// **'How many times a day'**
  String get howManyTimesADay;

  /// No description provided for @dosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get dosage;

  /// No description provided for @intervals.
  ///
  /// In en, this message translates to:
  /// **'intervals'**
  String get intervals;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @inIntervalOfDays.
  ///
  /// In en, this message translates to:
  /// **'In interval of days'**
  String get inIntervalOfDays;

  /// No description provided for @enterReminderNameSearchMed.
  ///
  /// In en, this message translates to:
  /// **'Enter Reminder name / Search Medicine'**
  String get enterReminderNameSearchMed;

  /// No description provided for @addReminder.
  ///
  /// In en, this message translates to:
  /// **'Add a reminder'**
  String get addReminder;

  /// No description provided for @packageFee.
  ///
  /// In en, this message translates to:
  /// **'Package fee'**
  String get packageFee;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'days left'**
  String get daysLeft;

  /// No description provided for @consultationLeftOutOf.
  ///
  /// In en, this message translates to:
  /// **'consultation left out of'**
  String get consultationLeftOutOf;

  /// No description provided for @slotsNotAvailableInThisDate.
  ///
  /// In en, this message translates to:
  /// **'Slots not available in this date'**
  String get slotsNotAvailableInThisDate;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get years;

  /// No description provided for @billDetails.
  ///
  /// In en, this message translates to:
  /// **'Bill Details'**
  String get billDetails;

  /// No description provided for @consultationFee.
  ///
  /// In en, this message translates to:
  /// **'Consultation Fee'**
  String get consultationFee;

  /// No description provided for @platformFee.
  ///
  /// In en, this message translates to:
  /// **'Platform Fee'**
  String get platformFee;

  /// No description provided for @serviceFee.
  ///
  /// In en, this message translates to:
  /// **'Service Fee & Tax'**
  String get serviceFee;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @couponDiscount.
  ///
  /// In en, this message translates to:
  /// **'Coupon Discount'**
  String get couponDiscount;

  /// No description provided for @packagePrice.
  ///
  /// In en, this message translates to:
  /// **'Package Price'**
  String get packagePrice;

  /// No description provided for @totalAmt.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmt;

  /// No description provided for @withSixtyPlus.
  ///
  /// In en, this message translates to:
  /// **'with 60+ care offer'**
  String get withSixtyPlus;

  /// No description provided for @freeCapital.
  ///
  /// In en, this message translates to:
  /// **'FREE'**
  String get freeCapital;

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking Cancelled'**
  String get bookingCancelled;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// No description provided for @goToChat.
  ///
  /// In en, this message translates to:
  /// **'Go to Chat'**
  String get goToChat;

  /// No description provided for @areYouSureWantToCancelThisBooking.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to cancel this booking'**
  String get areYouSureWantToCancelThisBooking;

  /// No description provided for @deleteTheReminder.
  ///
  /// In en, this message translates to:
  /// **'Delete this reminder?'**
  String get deleteTheReminder;

  /// No description provided for @searchFor.
  ///
  /// In en, this message translates to:
  /// **'Search for '**
  String get searchFor;

  /// No description provided for @connectingDoctor.
  ///
  /// In en, this message translates to:
  /// **'Connecting Doctor...'**
  String get connectingDoctor;

  /// No description provided for @connectingd.
  ///
  /// In en, this message translates to:
  /// **'Connecting Doctor...'**
  String get connectingd;

  /// No description provided for @noDoctorsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Doctors Available now'**
  String get noDoctorsAvailable;

  /// No description provided for @locationUnavailablePlzChoose.
  ///
  /// In en, this message translates to:
  /// **'Location unavailable, please choose a location'**
  String get locationUnavailablePlzChoose;

  /// No description provided for @theDetailsOFTHePersonWillNotBeEditable.
  ///
  /// In en, this message translates to:
  /// **'The details of the person will not be editable until this package expires'**
  String get theDetailsOFTHePersonWillNotBeEditable;

  /// No description provided for @onlyTheMembersAddedUnderThisPackageWillRecieve.
  ///
  /// In en, this message translates to:
  /// **'Only the members added under this package will receive the benefits of this package'**
  String get onlyTheMembersAddedUnderThisPackageWillRecieve;

  /// No description provided for @updateReminder.
  ///
  /// In en, this message translates to:
  /// **'Update Reminder'**
  String get updateReminder;

  /// No description provided for @forYour.
  ///
  /// In en, this message translates to:
  /// **'For your'**
  String get forYour;

  /// No description provided for @timing.
  ///
  /// In en, this message translates to:
  /// **'Timing'**
  String get timing;

  /// No description provided for @serviceWeProvide.
  ///
  /// In en, this message translates to:
  /// **'Service we provide'**
  String get serviceWeProvide;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @contactNow.
  ///
  /// In en, this message translates to:
  /// **'Contact Now'**
  String get contactNow;

  /// No description provided for @whoWeAreHelping.
  ///
  /// In en, this message translates to:
  /// **'Who are we helping'**
  String get whoWeAreHelping;

  /// No description provided for @areYouAPetLover.
  ///
  /// In en, this message translates to:
  /// **'Are you a pet lover/owner'**
  String get areYouAPetLover;

  /// No description provided for @selectTreatmentType.
  ///
  /// In en, this message translates to:
  /// **'Select treatment type'**
  String get selectTreatmentType;

  /// No description provided for @problemAndTreatment.
  ///
  /// In en, this message translates to:
  /// **'Problem & treatment type'**
  String get problemAndTreatment;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @healthInfo.
  ///
  /// In en, this message translates to:
  /// **'Health info'**
  String get healthInfo;

  /// No description provided for @seePackageDetails.
  ///
  /// In en, this message translates to:
  /// **'See package details >>'**
  String get seePackageDetails;

  /// No description provided for @questionnaireCompleted.
  ///
  /// In en, this message translates to:
  /// **'Questionnaire completed'**
  String get questionnaireCompleted;

  /// No description provided for @feeRange.
  ///
  /// In en, this message translates to:
  /// **'Fee Range'**
  String get feeRange;

  /// No description provided for @howDoYouFeelToday.
  ///
  /// In en, this message translates to:
  /// **'How Do You Feel Today?'**
  String get howDoYouFeelToday;

  /// No description provided for @therapies.
  ///
  /// In en, this message translates to:
  /// **'Therapies'**
  String get therapies;

  /// No description provided for @yourSleepQuality.
  ///
  /// In en, this message translates to:
  /// **'Your Sleep Quality'**
  String get yourSleepQuality;

  /// No description provided for @neverMissADose.
  ///
  /// In en, this message translates to:
  /// **'Never Miss a Dose,\nStay on Track!'**
  String get neverMissADose;

  /// No description provided for @getSmartNotificationsForYour.
  ///
  /// In en, this message translates to:
  /// **'Get smart notifications for your medications, track doses, and set custom schedules with ease.'**
  String get getSmartNotificationsForYour;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ml'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ml': return AppLocalizationsMl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
