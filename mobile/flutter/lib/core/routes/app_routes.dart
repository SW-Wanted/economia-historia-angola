import 'package:flutter/material.dart';

import '../../models/app_user.dart';
import '../../models/community_category.dart';
import '../../models/feed.dart';
import '../../models/weekly_quiz.dart';
import '../../screens/admin_panel_screen.dart';
import '../../screens/admin_users_screen.dart';
import '../../screens/community_screen.dart';
import '../../screens/community_detail_screen.dart';
import '../../screens/create_community_screen.dart';
import '../../screens/create_content_screen.dart';
import '../../screens/create_quiz_screen.dart';
import '../../screens/create_topic_screen.dart';
import '../../screens/discussion_room_screen.dart';
import '../../screens/faq_screen.dart';
import '../../screens/feedback_screen.dart';
import '../../screens/dashboard_screen.dart';
import '../../screens/edit_profile_screen.dart';
import '../../screens/explore_screen.dart';
import '../../screens/forgot_password_screen.dart';
import '../../screens/forum_screen.dart';
import '../../screens/forum_topic_screen.dart';
import '../../screens/help_center_screen.dart';
import '../../screens/invite_screen.dart';
import '../../screens/landing_screen.dart';
import '../../screens/library_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/manage_content_screen.dart';
import '../../screens/manage_forums_screen.dart';
import '../../screens/management_panel_screen.dart';
import '../../screens/map_screen.dart';
import '../../screens/notifications_screen.dart';
import '../../screens/offline_mode_screen.dart';
import '../../screens/onboarding_screen.dart';
import '../../screens/pending_reports_screen.dart';
import '../../screens/private_forum_access_screen.dart';
import '../../screens/private_rooms_screen.dart';
import '../../screens/reset_password_screen.dart';
import '../../models/discussion_room.dart';
import '../../screens/profile_screen.dart';
import '../../screens/province_contents_screen.dart';
import '../../screens/publish_confirmation_screen.dart';
import '../../screens/publish_content_screen.dart';
import '../../screens/quick_start_screen.dart';
import '../../screens/quiz_feedback_screen.dart';
import '../../screens/quiz_hub_screen.dart';
import '../../screens/quiz_question_screen.dart';
import '../../screens/quiz_result_screen.dart';
import '../../screens/ranking_detail_screen.dart';
import '../../screens/ranking_screen.dart';
import '../../screens/reading_screen.dart';
import '../../screens/register_screen.dart';
import '../../screens/report_screen.dart';
import '../../screens/restricted_content_screen.dart';
import '../../screens/search_results_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/splash_screen.dart';
import '../../screens/subscription_screen.dart';
import '../../screens/super_admin_chain_screen.dart';
import '../../screens/super_admin_screen.dart';
import '../../screens/content_moderation_screen.dart';
import '../../screens/podcast_player_screen.dart';
import '../../screens/video_player_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const splash = '/';
  static const onboarding1 = '/onboarding/1';
  static const onboarding2 = '/onboarding/2';
  static const onboarding3 = '/onboarding/3';
  static const landing = '/landing';
  static const login = '/login';
  static const register1 = '/register/1';
  static const register2 = '/register/2';
  static const register3 = '/register/3';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const quickStart = '/quick-start';
  static const dashboard = '/dashboard';
  static const explore = '/explore';
  static const reading = '/reading';
  static const restrictedContent = '/restricted-content';
  static const unlockedText = '/unlocked-text';
  static const map = '/map';
  static const provinceContents = '/province-contents';
  static const quizHub = '/quiz-hub';
  static const quizQuestion = '/quiz-question';
  static const quizFeedback = '/quiz-feedback';
  static const quizResult = '/quiz-result';
  static const ranking = '/ranking';
  static const rankingDetail = '/ranking-detail';
  static const forum = '/forum';
  static const forumTopic = '/forum-topic';
  static const createTopic = '/create-topic';
  static const createQuiz = '/create-quiz';
  static const createContent = '/create-content';
  static const privateForumAccess = '/private-forum-access';
  static const profile = '/profile';
  static const editProfile = '/edit-profile';
  static const notifications = '/notifications';
  static const adminPanel = '/admin-panel';
  static const publishContent = '/publish-content';
  static const publishConfirmation = '/publish-confirmation';
  static const searchResults = '/search-results';
  static const videoPlayer = '/video-player';
  static const podcastPlayer = '/podcast-player';
  static const helpCenter = '/help-center';
  static const library = '/library';
  static const offlineMode = '/offline-mode';
  static const subscription = '/subscription';
  static const manageForums = '/manage-forums';
  static const adminUsers = '/admin-users';
  static const superAdmin = '/super-admin';
  static const superAdminChain = '/super-admin-chain';
  static const contentModeration = '/content-moderation';
  static const community = '/community';
  static const communityDetail = '/community/detail';
  static const createCommunity = '/community/create';
  static const discussionRoom = '/discussion-room';
  static const privateRooms = '/private-rooms';
  static const faq = '/faq';
  static const feedback = '/feedback';
  static const invite = '/invite';
  static const report = '/report';
  static const pendingReports = '/pending-reports';
  static const settings = '/settings';
  static const manageContent = '/manage-content';
  static const managementPanel = '/management-panel';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final page = switch (settings.name) {
      splash => const SplashScreen(),
      onboarding1 => const OnboardingScreen(step: 1),
      onboarding2 => const OnboardingScreen(step: 2),
      onboarding3 => const OnboardingScreen(step: 3),
      landing => const LandingScreen(),
      login => const LoginScreen(),
      register1 => const RegisterScreen(step: 1),
      register2 => const RegisterScreen(step: 2),
      register3 => const RegisterScreen(step: 3),
      forgotPassword => const ForgotPasswordScreen(),
      resetPassword => ResetPasswordScreen(
          token: settings.arguments is String ? settings.arguments as String : null),
      quickStart => const QuickStartScreen(),
      dashboard => const DashboardScreen(),
      explore => const ExploreScreen(),
      reading => const ReadingScreen(),
      restrictedContent => const RestrictedContentScreen(),
      unlockedText => const ReadingScreen(unlocked: true),
      map => MapScreen(preview: settings.arguments == true),
      provinceContents => ProvinceContentsScreen(
          province: settings.arguments is String ? settings.arguments as String : null,
        ),
      quizHub => const QuizHubScreen(),
      quizQuestion => QuizQuestionScreen(
          quiz: settings.arguments is WeeklyQuiz ? settings.arguments as WeeklyQuiz : null,
          quizId: settings.arguments is String
              ? settings.arguments as String
              : settings.arguments is FeedContent
                  ? (settings.arguments as FeedContent).id
                  : null,
        ),
      quizFeedback => const QuizFeedbackScreen(),
      quizResult => const QuizResultScreen(),
      ranking => const RankingScreen(),
      rankingDetail => const RankingDetailScreen(),
      forum => const ForumScreen(),
      forumTopic => const ForumTopicScreen(),
      createTopic => CreateTopicScreen(
          communityId: settings.arguments is String ? settings.arguments as String : null),
      createQuiz => CreateQuizScreen(
          content: settings.arguments is FeedContent ? settings.arguments as FeedContent : null,
          editQuizId: settings.arguments is String ? settings.arguments as String : null,
        ),
      createContent => const CreateContentScreen(),
      privateForumAccess => const PrivateForumAccessScreen(),
      profile => const ProfileScreen(),
      editProfile => const EditProfileScreen(),
      notifications => const NotificationsScreen(),
      adminPanel => const AdminPanelScreen(),
      publishContent => const PublishContentScreen(),
      publishConfirmation => const PublishConfirmationScreen(),
      searchResults => const SearchResultsScreen(),
      videoPlayer => VideoPlayerScreen(
          content: settings.arguments is FeedContent ? settings.arguments as FeedContent : null,
          preview: settings.arguments == true,
        ),
      podcastPlayer => PodcastPlayerScreen(
          content: settings.arguments is FeedContent ? settings.arguments as FeedContent : null,
          preview: settings.arguments == true,
        ),
      helpCenter => const HelpCenterScreen(),
      library => LibraryScreen(initialFilter: settings.arguments is int ? settings.arguments as int : 0),
      offlineMode => const OfflineModeScreen(),
      subscription => const SubscriptionScreen(),
      manageForums => const ManageForumsScreen(),
      adminUsers => const AdminUsersScreen(),
      superAdmin => SuperAdminScreen(user: settings.arguments is AppUser ? settings.arguments as AppUser : null),
      superAdminChain => const SuperAdminChainScreen(),
      contentModeration => const ContentModerationScreen(),
      community => const CommunityScreen(),
      communityDetail => CommunityDetailScreen(
          community: settings.arguments is CommunityCategory ? settings.arguments as CommunityCategory : null),
      createCommunity => const CreateCommunityScreen(),
      discussionRoom => DiscussionRoomScreen(
          room: settings.arguments is DiscussionRoom ? settings.arguments as DiscussionRoom : null),
      privateRooms => const PrivateRoomsScreen(),
      faq => const FaqScreen(),
      feedback => const FeedbackScreen(),
      invite => const InviteScreen(),
      report => const ReportScreen(),
      pendingReports => const PendingReportsScreen(),
      AppRoutes.settings => const SettingsScreen(),
      manageContent => const ManageContentScreen(),
      managementPanel => const ManagementPanelScreen(),
      _ => const SplashScreen(),
    };

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, animation, _) => page,
      transitionsBuilder: (_, animation, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        child: SlideTransition(
          position: Tween(begin: const Offset(0, .02), end: Offset.zero).animate(animation),
          child: child,
        ),
      ),
    );
  }
}
