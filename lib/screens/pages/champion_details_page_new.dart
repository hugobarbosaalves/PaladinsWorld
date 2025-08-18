import 'package:flutter/material.dart';
import '../../global/variables.dart';
import '../widgets/neon_animations.dart';
import '../widgets/tech_widgets.dart';

class ChampionDetailsPageNew extends StatefulWidget {
  final dynamic champion;

  const ChampionDetailsPageNew({
    super.key,
    required this.champion,
  });

  @override
  State<ChampionDetailsPageNew> createState() => _ChampionDetailsPageNewState();
}

class _ChampionDetailsPageNewState extends State<ChampionDetailsPageNew>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _heroController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _heroAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _heroAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _heroController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _heroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TechBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildHeroSection(),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildStatsSection(),
                    const SizedBox(height: 30),
                    _buildAbilitiesSection(),
                    const SizedBox(height: 30),
                    _buildLoreSection(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    String championName = widget.champion['Name'] ?? 'Unknown Champion';
    String championTitle = widget.champion['Title'] ?? '';
    String? imageUrl = widget.champion['ChampionIcon_URL'];
    String championRole = _getRoleName(widget.champion['Roles']);
    Color roleColor = _getRoleColor(widget.champion['Roles']);

    return SliverAppBar(
      expandedHeight: 350,
      floating: false,
      pinned: true,
      backgroundColor: GlobalsVariables.primaryDark.withValues(alpha: 0.9),
      leading: NeonGlowWidget(
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        NeonGlowWidget(
          child: IconButton(
            icon: const Icon(Icons.favorite_border,
                color: Colors.white, size: 28),
            onPressed: () {
              // Add to favorites
            },
          ),
        ),
        const SizedBox(width: 10),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Background particles
            const ParticleField(
              particleCount: 30,
              particleColor: Color(0xFF00D4FF),
              particleSize: 1.0,
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    GlobalsVariables.primaryDark.withValues(alpha: 0.3),
                    GlobalsVariables.primaryDark.withValues(alpha: 0.8),
                    GlobalsVariables.primaryDark,
                  ],
                ),
              ),
            ),
            // Champion content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Champion image with portal effect
                  AnimatedBuilder(
                    animation: _heroAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _heroAnimation.value,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Portal background
                            const PortalLoadingAnimation(
                              size: 140,
                              color: Color(0xFF00D4FF),
                            ),
                            // Champion image
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: roleColor,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: roleColor.withValues(alpha: 0.6),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: imageUrl != null && imageUrl.isNotEmpty
                                    ? Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return _buildFallbackAvatar(
                                              championName, roleColor);
                                        },
                                      )
                                    : _buildFallbackAvatar(
                                        championName, roleColor),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  // Champion name
                  NeonTitle(
                    title: championName,
                    fontSize: 20,
                    glowColor: roleColor,
                  ),
                  const SizedBox(height: 6),
                  // Champion title/subtitle
                  if (championTitle.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        championTitle,
                        style: TextStyle(
                          color: GlobalsVariables.neonCyan,
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          shadows: [
                            Shadow(
                              color: GlobalsVariables.neonCyan
                                  .withValues(alpha: 0.6),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 8),
                  // Role badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          roleColor.withValues(alpha: 0.8),
                          roleColor.withValues(alpha: 0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: roleColor),
                    ),
                    child: Text(
                      championRole,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackAvatar(String name, Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.8),
            color.withValues(alpha: 0.4),
          ],
        ),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 60,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    int health = widget.champion['Health'] ?? 0;
    int speed = widget.champion['Speed'] ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const NeonTitle(
            title: 'STATS',
            fontSize: 24,
            glowColor: GlobalsVariables.neonBlue,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.favorite,
                  label: 'HEALTH',
                  value: health.toString(),
                  color: GlobalsVariables.neonGreen,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.speed,
                  label: 'SPEED',
                  value: speed.toString(),
                  color: GlobalsVariables.neonCyan,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return TechCard(
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: GlobalsVariables.textSecondary,
              fontSize: 12,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: color.withValues(alpha: 0.8),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbilitiesSection() {
    List<Map<String, dynamic>> abilities = _getAbilities();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const NeonTitle(
            title: 'ABILITIES',
            fontSize: 24,
            glowColor: GlobalsVariables.neonPurple,
          ),
          const SizedBox(height: 20),
          // Lista de habilidades expandida - sem seletor horizontal
          Column(
            children: abilities.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> ability = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: TechCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header da habilidade
                        Row(
                          children: [
                            // Imagem da habilidade
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: GlobalsVariables.neonPurple,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: GlobalsVariables.neonPurple
                                        .withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: ability['imageUrl'] != null
                                    ? Image.network(
                                        ability['imageUrl'],
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              gradient: RadialGradient(
                                                colors: [
                                                  GlobalsVariables.neonPurple
                                                      .withValues(alpha: 0.8),
                                                  GlobalsVariables.neonPurple
                                                      .withValues(alpha: 0.4),
                                                ],
                                              ),
                                            ),
                                            child: Icon(
                                              _getAbilityIcon(index),
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          gradient: RadialGradient(
                                            colors: [
                                              GlobalsVariables.neonPurple
                                                  .withValues(alpha: 0.8),
                                              GlobalsVariables.neonPurple
                                                  .withValues(alpha: 0.4),
                                            ],
                                          ),
                                        ),
                                        child: Icon(
                                          _getAbilityIcon(index),
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Nome e tipo da habilidade
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ability['name'],
                                    style: const TextStyle(
                                      color: GlobalsVariables.textPrimary,
                                      fontSize: 16,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          GlobalsVariables.neonPurple
                                              .withValues(alpha: 0.6),
                                          GlobalsVariables.neonPurple
                                              .withValues(alpha: 0.3),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      _getAbilityType(index),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Divisor neon
                        const NeonDivider(
                          color: GlobalsVariables.neonPurple,
                        ),
                        const SizedBox(height: 12),
                        // Descrição da habilidade
                        Text(
                          ability['description'],
                          style: const TextStyle(
                            color: GlobalsVariables.textSecondary,
                            fontSize: 13,
                            fontFamily: 'Montserrat',
                            height: 1.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Função para obter ícone baseado no índice da habilidade
  IconData _getAbilityIcon(int index) {
    switch (index) {
      case 0:
        return Icons.gps_fixed; // Primary weapon
      case 1:
        return Icons.flash_on; // Secondary ability
      case 2:
        return Icons.directions_run; // Movement ability
      case 3:
        return Icons.shield; // Defensive ability
      case 4:
        return Icons.whatshot; // Ultimate
      default:
        return Icons.flash_on;
    }
  }

  // Função para obter tipo da habilidade baseado no índice
  String _getAbilityType(int index) {
    switch (index) {
      case 0:
        return 'PRIMARY';
      case 1:
        return 'SECONDARY';
      case 2:
        return 'MOVEMENT';
      case 3:
        return 'DEFENSIVE';
      case 4:
        return 'ULTIMATE';
      default:
        return 'ABILITY';
    }
  }

  Widget _buildLoreSection() {
    String lore =
        widget.champion['Lore'] ?? 'No lore available for this champion.';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const NeonTitle(
            title: 'LORE',
            fontSize: 24,
            glowColor: GlobalsVariables.neonCyan,
          ),
          const SizedBox(height: 20),
          TechCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_stories,
                        color: GlobalsVariables.neonCyan,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Champion\'s Story',
                        style: TextStyle(
                          color: GlobalsVariables.textPrimary,
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const NeonDivider(
                    height: 2,
                    color: GlobalsVariables.neonCyan,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    lore,
                    style: const TextStyle(
                      color: GlobalsVariables.textSecondary,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getAbilities() {
    List<Map<String, dynamic>> abilities = [];

    for (int i = 1; i <= 5; i++) {
      String? abilityName = widget.champion['Ability$i'];
      String? abilityDescription = widget.champion['abilityDescription$i'];
      String? abilityImageUrl = widget.champion['ChampionAbility${i}_URL'];

      if (abilityName != null && abilityName.isNotEmpty) {
        abilities.add({
          'name': abilityName,
          'description': abilityDescription ?? 'No description available.',
          'imageUrl': abilityImageUrl,
        });
      }
    }

    // Se não há habilidades da API, criar algumas padrão
    if (abilities.isEmpty) {
      abilities = [
        {
          'name': 'Primary',
          'description': 'Primary weapon attack.',
          'imageUrl': null,
        },
        {
          'name': 'Secondary',
          'description': 'Secondary ability.',
          'imageUrl': null,
        },
        {
          'name': 'Movement',
          'description': 'Movement ability.',
          'imageUrl': null,
        },
        {
          'name': 'Ultimate',
          'description': 'Ultimate ability.',
          'imageUrl': null,
        },
      ];
    }

    return abilities;
  }

  String _getRoleName(String? role) {
    switch (role) {
      case 'Paladins Suporte':
        return 'SUPPORT';
      case 'Paladins Tanque':
        return 'TANK';
      case 'Paladins Flanco':
        return 'FLANK';
      case 'Paladins Dano':
        return 'DAMAGE';
      default:
        return role?.replaceAll('Paladins ', '').toUpperCase() ?? 'UNKNOWN';
    }
  }

  Color _getRoleColor(String? role) {
    switch (role) {
      case 'Paladins Suporte':
        return GlobalsVariables.neonGreen;
      case 'Paladins Tanque':
        return GlobalsVariables.neonBlue;
      case 'Paladins Flanco':
        return GlobalsVariables.neonPurple;
      case 'Paladins Dano':
        return const Color(0xFFFF4444);
      default:
        return GlobalsVariables.textSecondary;
    }
  }
}
