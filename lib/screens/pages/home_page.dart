import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import '../../global/variables.dart';
import '../../service/api_paladins_hirez.dart';
import '../../translation/translations.dart';
import '../widgets/neon_animations.dart';
import '../widgets/tech_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List champions = [];
  List displayChampions = [];
  bool isLoading = true;

  String selectedRole = 'ALL';
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _getChampions();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return I18n(
      child: TechBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: _buildTechDrawer(),
          appBar: _buildTechAppBar(),
          body: Stack(
            children: [
              // Particle field background
              const ParticleField(
                particleCount: 50,
                particleColor: Color(0xFF00D4FF),
                particleSize: 1.5,
              ),
              // Main content
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Title with neon effect
                    NeonTitle(
                      title: appTitle.i18n,
                      fontSize: 32,
                      glowColor: GlobalsVariables.neonBlue,
                    ),
                    const SizedBox(height: 30),
                    // Role filter buttons
                    _buildRoleFilterSection(),
                    const SizedBox(height: 20),
                    // Champions grid
                    Expanded(
                      child: _buildChampionsGrid(),
                    ),
                  ],
                ),
              ),
              // Loading overlay
              if (isLoading) _buildLoadingOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTechDrawer() {
    return Drawer(
      backgroundColor: GlobalsVariables.primaryDark,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0A0E1A),
              Color(0xFF1A1F2E),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: GlobalsVariables.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: GlobalsVariables.neonBlue.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PortalLoadingAnimation(
                      size: 80,
                      color: Color(0xFFFFFFFF),
                    ),
                    SizedBox(height: 10),
                    NeonTitle(
                      title: 'PALADINS',
                      fontSize: 24,
                      glowColor: Colors.white,
                      textColor: Colors.white,
                      animated: false,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildDrawerItem(
              icon: Icons.home,
              title: 'Home',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.sports_esports,
              title: 'Champions',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.info,
              title: 'About',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TechCard(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        hasGlow: false,
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              color: GlobalsVariables.neonBlue,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: GlobalsVariables.textPrimary,
                fontSize: 16,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildTechAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Builder(
        builder: (context) => NeonGlowWidget(
          child: IconButton(
            icon: const Icon(
              Icons.menu,
              color: GlobalsVariables.textPrimary,
              size: 28,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      actions: [
        NeonGlowWidget(
          child: IconButton(
            icon: const Icon(
              Icons.search,
              color: GlobalsVariables.textPrimary,
              size: 28,
            ),
            onPressed: () {
              // Implement search
            },
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildRoleFilterSection() {
    final roles = [
      {
        'name': 'ALL',
        'icon': Icons.grid_view,
        'color': GlobalsVariables.neonCyan
      },
      {
        'name': 'SUP',
        'icon': Icons.favorite,
        'color': GlobalsVariables.neonGreen
      },
      {
        'name': 'TANK',
        'icon': Icons.shield,
        'color': GlobalsVariables.neonBlue
      },
      {
        'name': 'FLANK',
        'icon': Icons.flash_on,
        'color': GlobalsVariables.neonPurple
      },
      {'name': 'DMG', 'icon': Icons.whatshot, 'color': const Color(0xFFFF4444)},
    ];

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: roles.map((role) {
          final isSelected = selectedRole == role['name'] ||
              (selectedRole == 'SUPPORT' && role['name'] == 'SUP') ||
              (selectedRole == 'DAMAGE' && role['name'] == 'DMG');
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: _buildCompactRoleButton(
                text: role['name'] as String,
                icon: role['icon'] as IconData,
                color: role['color'] as Color,
                isSelected: isSelected,
                onPressed: () {
                  String actualRole = role['name'] as String;
                  if (actualRole == 'SUP') actualRole = 'SUPPORT';
                  if (actualRole == 'DMG') actualRole = 'DAMAGE';
                  _filterChampionsByRole(actualRole);
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCompactRoleButton({
    required String text,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: isSelected
                ? [color.withValues(alpha: 0.8), color.withValues(alpha: 0.6)]
                : [GlobalsVariables.secondaryDark, GlobalsVariables.accentDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: isSelected
                ? color
                : GlobalsVariables.textSecondary.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : GlobalsVariables.textSecondary,
              size: 18,
            ),
            const SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                color:
                    isSelected ? Colors.white : GlobalsVariables.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChampionsGrid() {
    if (isLoading) {
      return const Center(
        child: PortalLoadingAnimation(
          size: 120,
          color: Color(0xFF00D4FF),
        ),
      );
    }

    if (displayChampions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 80,
              color: GlobalsVariables.textSecondary,
            ),
            const SizedBox(height: 20),
            const NeonTitle(
              title: 'No Champions Found',
              fontSize: 24,
              glowColor: GlobalsVariables.textSecondary,
              textColor: GlobalsVariables.textSecondary,
              animated: false,
            ),
          ],
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: displayChampions.length,
          itemBuilder: (context, index) {
            final champion = displayChampions[index];
            return _buildChampionCard(champion);
          },
        ),
      ),
    );
  }

  Widget _buildChampionCard(dynamic champion) {
    String? imageUrl =
        champion['ChampionIcon_URL'] ?? champion['champion_icon_url'];

    // Se a URL da API não funcionar, tentar construir URL baseada no nome
    if (imageUrl == null || imageUrl.isEmpty) {
      String championName = champion['Name']?.toString() ?? '';
      if (championName.isNotEmpty) {
        // Usar URL padrão da Hi-Rez baseada no nome do campeão
        imageUrl =
            'https://webcdn.hirezstudios.com/paladins/champion-icons/${championName.toLowerCase().replaceAll(' ', '-')}.jpg';
      }
    }

    return TechCard(
      onTap: () => _navigateToChampionDetails(champion),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: GlobalsVariables.primaryGradient,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: PortalLoadingAnimation(
                              size: 30,
                              color: Color(0xFF00D4FF),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          // Se falhar, tentar URL alternativa
                          return _buildChampionFallbackImage(champion);
                        },
                      )
                    : _buildChampionFallbackImage(champion),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    champion['Name'] ?? 'Unknown',
                    style: const TextStyle(
                      color: GlobalsVariables.textPrimary,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getRoleName(champion['Roles']),
                    style: TextStyle(
                      color: _getRoleColor(champion['Roles']),
                      fontSize: 10,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChampionFallbackImage(dynamic champion) {
    Color roleColor = _getRoleColor(champion['Roles']);
    IconData roleIcon = _getRoleIcon(champion['Roles']);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            roleColor.withValues(alpha: 0.3),
            roleColor.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              roleIcon,
              size: 40,
              color: roleColor,
            ),
            const SizedBox(height: 8),
            Text(
              champion['Name']?.toString().substring(0, 1).toUpperCase() ?? '?',
              style: TextStyle(
                color: roleColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getRoleIcon(String? role) {
    switch (role) {
      case 'Paladins Support':
      case 'Paladins Supporter':
        return Icons.favorite;
      case 'Paladins Front Line':
      case 'Paladins Tanker':
        return Icons.shield;
      case 'Paladins Flank':
      case 'Paladins Flanker':
        return Icons.flash_on;
      case 'Paladins Damage':
      case 'Paladins Damager':
        return Icons.whatshot;
      default:
        return Icons.person;
    }
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: GlobalsVariables.primaryDark.withValues(alpha: 0.8),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PortalLoadingAnimation(
              size: 150,
              color: Color(0xFF00D4FF),
            ),
            SizedBox(height: 30),
            NeonTitle(
              title: 'Loading Champions...',
              fontSize: 20,
              glowColor: Color(0xFF00D4FF),
            ),
          ],
        ),
      ),
    );
  }

  String _getRoleName(String? role) {
    switch (role) {
      case 'Paladins Support':
      case 'Paladins Supporter':
        return 'SUPPORT';
      case 'Paladins Front Line':
      case 'Paladins Tanker':
        return 'TANK';
      case 'Paladins Flank':
      case 'Paladins Flanker':
        return 'FLANK';
      case 'Paladins Damage':
      case 'Paladins Damager':
        return 'DAMAGE';
      default:
        return role?.replaceAll('Paladins ', '').toUpperCase() ?? 'UNKNOWN';
    }
  }

  Color _getRoleColor(String? role) {
    switch (role) {
      case 'Paladins Support':
      case 'Paladins Supporter':
        return GlobalsVariables.neonGreen;
      case 'Paladins Front Line':
      case 'Paladins Tanker':
        return GlobalsVariables.neonBlue;
      case 'Paladins Flank':
      case 'Paladins Flanker':
        return GlobalsVariables.neonPurple;
      case 'Paladins Damage':
      case 'Paladins Damager':
        return const Color(0xFFFF4444);
      default:
        return GlobalsVariables.textSecondary;
    }
  }

  void _filterChampionsByRole(String role) {
    setState(() {
      selectedRole = role;
      if (role == 'ALL') {
        displayChampions = List.from(champions);
      } else {
        String targetRole;
        switch (role) {
          case 'SUPPORT':
            targetRole = 'Paladins Support';
            break;
          case 'TANK':
            targetRole = 'Paladins Front Line';
            break;
          case 'FLANK':
            targetRole = 'Paladins Flank';
            break;
          case 'DAMAGE':
            targetRole = 'Paladins Damage';
            break;
          default:
            targetRole = '';
        }
        displayChampions = champions
            .where((champion) =>
                champion['Roles'] == targetRole ||
                champion['Roles'] ==
                    targetRole.replaceAll('Paladins ', 'Paladins ') +
                        'r' || // Support -> Supporter
                (targetRole == 'Paladins Flank' &&
                    champion['Roles'] == 'Paladins Flanker') ||
                (targetRole == 'Paladins Damage' &&
                    champion['Roles'] == 'Paladins Damager'))
            .toList();
      }
    });
    _fadeController.reset();
    _fadeController.forward();
  }

  void _navigateToChampionDetails(dynamic champion) {
    // Navigate to champion details page
    // Navigator.pushNamed(context, '/champion-details', arguments: champion);
  }

  void _getChampions() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Create session if needed
      if (GlobalsVariables.sessionId.isEmpty) {
        var sessionResult = await ApiPaladinsHirez.createSession();
        if (sessionResult != null) {
          GlobalsVariables.sessionId = sessionResult;
        }
      }

      var result = await ApiPaladinsHirez.getChampions(
          sessionId: GlobalsVariables.sessionId);

      if (result != null && result.isNotEmpty) {
        print('Champions loaded: ${result.length}');
        if (result.isNotEmpty) {
          print('Sample champion data: ${result[0]}');
        }

        setState(() {
          champions = result;
          displayChampions = List.from(champions);
          isLoading = false;
        });
        _fadeController.forward();
      } else {
        // Handle error - show mock data or error message
        _loadMockData();
      }
    } catch (e) {
      print('Error loading champions: $e');
      _loadMockData();
    }
  }

  void _loadMockData() {
    setState(() {
      champions = [
        {
          'Name': 'Androxus',
          'Roles': 'Paladins Flank',
          'champion_icon_url': null,
        },
        {
          'Name': 'Ash',
          'Roles': 'Paladins Front Line',
          'champion_icon_url': null,
        },
        {
          'Name': 'Barik',
          'Roles': 'Paladins Front Line',
          'champion_icon_url': null,
        },
        {
          'Name': 'Bomb King',
          'Roles': 'Paladins Damage',
          'champion_icon_url': null,
        },
      ];
      displayChampions = List.from(champions);
      isLoading = false;
    });
    _fadeController.forward();
  }
}
