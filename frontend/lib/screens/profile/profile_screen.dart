import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:amc8/screens/auth/auth_actions.dart';
import 'package:amc8/services/api_service.dart';
import 'package:amc8/services/session_prefs.dart';
import 'package:amc8/theme/app_theme.dart';

/// 与 `pubspec.yaml` 的 version 对齐（发版时请同步修改）。
const String _kAppVersionLabel = '1.0.0+1';

bool _apiBizOk(dynamic code) => code == 200 || code == '200';

/// 个人中心（Figma `/profile` 无法用 API 读取时，按产品说明实现布局）。
///
/// 展示 [SessionPrefs] 中的登录用户；[onLoggedOut] 在清除会话后由父级切回登录页。
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.onLoggedOut,
  });

  /// 清除 token 后调用（例如 `Amc8Root` 将 `_signedIn = false`）。
  final VoidCallback onLoggedOut;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  SessionProfileSnapshot? _snapshot;
  bool _loading = true;
  bool _loggingOut = false;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final s = await SessionPrefs.loadProfileSnapshot();
    if (mounted) {
      setState(() {
        _snapshot = s;
        _loading = false;
      });
    }
  }

  /// 先关闭个人中心页，再在下一帧通知根组件切登录页，避免 Navigator 与 `home` 同时替换时偶发无响应。
  Future<void> _logout() async {
    if (_loggingOut) return;
    setState(() => _loggingOut = true);
    try {
      await AuthActions.clearLocalSession();
      if (!mounted) return;

      final nav = Navigator.of(context);
      final onOut = widget.onLoggedOut;
      if (nav.canPop()) {
        nav.pop();
      }
      SchedulerBinding.instance.addPostFrameCallback((_) => onOut());
    } catch (e, st) {
      debugPrint('logout failed: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('退出失败：$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loggingOut = false);
    }
  }

  Future<void> _openEditFullName() async {
    final snap = _snapshot;
    if (snap == null) return;

    final stored = await SessionPrefs.getStoredFullName();
    final initial = (stored != null && stored.isNotEmpty)
        ? stored
        : (snap.displayName == 'Student' ? '' : snap.displayName);

    if (!mounted) return;
    final controller = TextEditingController(text: initial);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Full name',
              hintText: 'Your display name',
            ),
            onSubmitted: (_) => Navigator.pop(ctx, true),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (ok != true || !mounted) {
      controller.dispose();
      return;
    }

    final name = controller.text.trim();
    controller.dispose();

    final username = snap.email.trim();
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('无法更新：未找到登录邮箱')),
      );
      return;
    }

    // 先写本地，保证界面与首页欢迎语立刻一致；再请求服务器同步。
    await SessionPrefs.setFullName(name);
    await _reload();

    final res = await appApiService.updateUserFullName(
      username: username,
      fullName: name,
    );
    if (!mounted) return;

    if (_apiBizOk(res['code'])) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('全名已更新')),
      );
    } else {
      final msg = res['msg']?.toString() ?? '未知错误';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已保存在本机，服务器未同步：$msg')),
      );
    }
  }

  void _stub(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title — coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? scheme.surface : const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: _loading || _snapshot == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _reload,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  _ProfileHeaderCard(
                    snapshot: _snapshot!,
                    scheme: scheme,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),
                  _ProfileMenuCard(
                    scheme: scheme,
                    isDark: isDark,
                    onEditProfile: _openEditFullName,
                    onSettings: () => _stub('Settings'),
                    onMyResults: () => _stub('My Results'),
                    onHelp: () => _stub('Help & Support'),
                    onLogoutTap: _logout,
                    loggingOut: _loggingOut,
                  ),
                  const SizedBox(height: 28),
                  Center(
                    child: Text(
                      'Version $_kAppVersionLabel',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

/// 顶部：头像、姓名、邮箱。
class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({
    required this.snapshot,
    required this.scheme,
    required this.isDark,
  });

  final SessionProfileSnapshot snapshot;
  final ColorScheme scheme;
  final bool isDark;

  String get _initial {
    final n = snapshot.displayName.trim();
    if (n.isEmpty) return '?';
    final first = n.runes.first;
    return String.fromCharCode(first).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final email = snapshot.email.isEmpty ? 'No email on file' : snapshot.email;

    return Material(
      color: scheme.surface,
      elevation: isDark ? 0 : 1,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isDark
            ? BorderSide(color: scheme.outline.withValues(alpha: 0.35))
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: Amc8BrandColors.primary.withValues(alpha: 0.15),
              foregroundColor: Amc8BrandColors.primary,
              child: Text(
                _initial,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              snapshot.displayName,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              email,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 中间功能列表（含菜单 Logout）。
class _ProfileMenuCard extends StatelessWidget {
  const _ProfileMenuCard({
    required this.scheme,
    required this.isDark,
    required this.onEditProfile,
    required this.onSettings,
    required this.onMyResults,
    required this.onHelp,
    required this.onLogoutTap,
    required this.loggingOut,
  });

  final ColorScheme scheme;
  final bool isDark;
  final VoidCallback onEditProfile;
  final VoidCallback onSettings;
  final VoidCallback onMyResults;
  final VoidCallback onHelp;
  final VoidCallback onLogoutTap;
  final bool loggingOut;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: scheme.surface,
      elevation: isDark ? 0 : 1,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isDark
            ? BorderSide(color: scheme.outline.withValues(alpha: 0.35))
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _MenuTile(
            icon: Icons.person_outline_rounded,
            title: 'Edit Profile',
            onTap: onEditProfile,
          ),
          const Divider(height: 1),
          _MenuTile(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: onSettings,
          ),
          const Divider(height: 1),
          _MenuTile(
            icon: Icons.bar_chart_rounded,
            title: 'My Results',
            onTap: onMyResults,
          ),
          const Divider(height: 1),
          _MenuTile(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            onTap: onHelp,
          ),
          const Divider(height: 1),
          _MenuTile(
            icon: Icons.logout_rounded,
            title: 'Logout',
            onTap: onLogoutTap,
            destructive: true,
            trailing: loggingOut
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: scheme.error,
                    ),
                  )
                : null,
            enabled: !loggingOut,
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.destructive = false,
    this.trailing,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool destructive;
  final Widget? trailing;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = destructive ? scheme.error : scheme.onSurface;

    return ListTile(
      enabled: enabled,
      leading: Icon(icon, color: fg),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
      trailing: trailing ??
          Icon(
            Icons.chevron_right_rounded,
            color: scheme.onSurfaceVariant,
          ),
      onTap: onTap,
    );
  }
}
