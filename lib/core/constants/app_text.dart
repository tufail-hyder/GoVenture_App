class AppTexts {
  AppTexts._();

  static const String appName = 'GoVenture';
  static const String appTagline = 'Work · Explore · Belong';

  static const String splashHeadlineLine1 = 'Adventure Awaits,';
  static const String splashHeadlineLine2 = 'You Belong Here.';

  static const String onboardingTitle1Line1 = 'Explore';
  static const String onboardingTitle1Line2 = 'Beautiful Places';
  static const String onboardingSubTitle1 =
      'Discover handpicked destinations and hidden gems around the world.';

  static const String onboardingTitle2Line1 = 'Plan';
  static const String onboardingTitle2Line2 = 'Epic Trips';
  static const String onboardingSubTitle2 =
      'Plan your perfect trip with curated itineraries and smart recommendations.';

  static const String onboardingTitle3Line1 = 'Join a';
  static const String onboardingTitle3Line2 = 'Community';
  static const String onboardingSubTitle3 =
      'Connect with like-minded people and be part of a global community.';

  static const String skip = 'Skip';
  static const String next = 'Next';
  static const String getStarted = 'Get Started';

  // Home
  static const String homeAppBarTitle = "";
  static const String homeAppBarSubTitle = "";
  static const String searchDestinationsHint = 'Search destinations...';

  // Auth — Login
  static const String loginWelcomePrefix = 'Welcome ';
  static const String loginWelcomeHighlight = 'Back!';
  static const String loginSubtitle = 'Sign in to continue your adventure';
  static const String emailHint = 'Email address';
  static const String passwordHint = 'Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String signIn = 'Sign In';
  static const String orDivider = 'or';
  static const String signInWithGoogle = 'Sign in with Google';
  static const String continueWithApple = 'Continue with Apple';
  static const String noAccountPrompt = "Don't have an account? ";
  static const String signUp = 'Sign Up';

  // Auth — Sign up
  static const String createAccountPrefix = 'Create ';
  static const String createAccountHighlight = 'Account';
  static const String signupSubtitle = 'Join GoVenture and start your journey';
  static const String firstNameHint = 'First name';
  static const String lastNameHint = 'Last name';
  static const String confirmPasswordHint = 'Confirm password';
  static const String termsPrefix = 'By creating an account, you agree to our ';
  static const String termsOfService = 'Terms of Service';
  static const String termsConjunction = ' & ';
  static const String privacyPolicy = 'Privacy Policy.';
  static const String signUpWithGoogle = 'Sign up with Google';
  static const String alreadyHaveAccountPrompt = 'Already have an account? ';


  // Auth — trust badges
  static const String trustSecureTitle = 'Secure & Safe';
  static const String trustSecureSubtitle = 'Your data is protected';
  static const String trustExploreTitle = 'Explore More';
  static const String trustExploreSubtitle = 'Discover new places';
  static const String trustCommunityTitle = 'Join Community';
  static const String trustCommunitySubtitle = 'Connect & belong';

  // Remote Config keys — fetched at startup by RemoteConfigService.
  static const String rcKeyWhatsappNumber = '923400189816';
  static const String rcKeySupportEmail = 'goventure001@gmail.com';

  static const String fallbackWhatsappNumber = '+923400189816';
  static const String fallbackSupportEmail = 'goventure001@gmail.com';

  // Shared preference keys
  static const String prefOnboardingComplete = 'onboarding_complete';
  static const String prefPromotionalNotifs = 'promotional_notifs_enabled';

  // Firestore collection names — central so a rename is a one-file change.
  static const String colUsers = 'users';
  static const String colTrips = 'trips';
  static const String colBookings = 'bookings';
  static const String colBlogs = 'blogs';
  static const String colAnnouncements = 'announcements';
  static const String colFavorites = 'favorites';
  static const String colNewsletter = 'newsletter_subscribers';
  static const String colNotifications = 'notifications';

  // Trip type enum values (stored as strings in Firestore)
  static const String tripTypeWorkcation = 'workcation';
  static const String tripTypeAdventure = 'adventure';
  static const String tripTypeRetreat = 'retreat';

  // Payment status values
  static const String paymentPending = 'pending';
  static const String paymentProcessing = 'processing';
  static const String paymentPaid = 'paid';
  static const String paymentFailed = 'failed';
  static const String paymentRefunded = 'refunded';
  static const String paymentCancelled = 'cancelled';

  // Booking status values
  static const String bookingUpcoming = 'upcoming';
  static const String bookingCompleted = 'completed';
  static const String bookingCancelled = 'cancelled';

  static const String forgotPasswordTitlePrefix = 'Forgot ';
  static const String forgotPasswordTitleHighlight = 'Password?';
  static const String forgotPasswordSubtitle =
      "No worries! Enter your email and we'll send you instructions to reset your password.";
  static const String sendResetLink = 'Send Reset Link';
  static const String resetWithGoogle = 'Reset with Google';
  static const String rememberPasswordPrompt = 'Remember your password? ';

  static const String checkEmailTitlePrefix = 'Check Your ';
  static const String checkEmailTitleHighlight = 'Email!';
  static const String checkEmailSubtitle = "We've sent a password reset link to";
  static const String linkExpiryNote =
      "The link will expire in 15 minutes. If you don't see the email, check your spam or junk folder.";
  static const String backToSignIn = 'Back to Sign In';
  static const String didntReceiveEmailPrompt = "Didn't receive the email? ";
  static const String resendLink = 'Resend Link';


}