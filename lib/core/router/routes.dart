class Routes {
  static const home = '/home';
  static const quotes = '/quotes';
  static const quoteEditor = '/quote/:id';
  static const quotePreview = '/quote/:id/preview';
  static const library = '/library';
  static const settings = '/settings';
  static const onboardingLogin = '/onboarding/login';
  static const onboardingSignup = '/onboarding/signup';
  static const onboardingOtp = '/onboarding/otp';
  static const onboardingForgot = '/onboarding/forgot';
  static const onboardingReset = '/onboarding/reset';
  static const onboarding1 = '/onboarding/step1';
  static const onboarding2 = '/onboarding/step2';
  static const onboarding3 = '/onboarding/step3';
  static const billingPaywall = '/billing/paywall';
  static const billingPlans = '/billing/plans';
  static const billingOperator = '/billing/operator';
  static const billingWaiting = '/billing/waiting';
  static const billingResult = '/billing/result';
  static const billingSubscription = '/billing/subscription';
  static const publicQuote = '/p/:token';

  static String quoteEditorPath(String id) => '/quote/$id';
  static String quotePreviewPath(String id) => '/quote/$id/preview';
  static String publicQuotePath(String token) => '/p/$token';
}
