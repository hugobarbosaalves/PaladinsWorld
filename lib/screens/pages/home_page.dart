import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:paladins_world/models/champion.dart';
import '../../global/variables.dart';
import '../../service/api_paladins_hirez.dart';
import '../../translation/translations.dart';
import '../../utils/functions.dart';
import '../widgets/avatar_champion.dart';
import '../widgets/btn_category_champion_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List champions = [];
  List displayChampions = [];

  bool btnSupSelected = false;
  bool btnTankSelected = false;
  bool btnFlankSelected = false;
  bool btnDmgSelected = false;
  bool btnAll = true;
  @override
  void initState() {
    _getChampions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return I18n(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
            appTitle.i18n,
            style: TextStyle(
              color: GlobalsVariables.purpleTitles,
              fontFamily: 'Montserrat',
              fontSize: 22,
            ),
          ),
          centerTitle: true,
          backgroundColor: GlobalsVariables.backgroundColorLight,
        ),
        body: Column(
          children: [
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 80,
                          child: TextButton(
                            style: ButtonStyle(
                              elevation: WidgetStateProperty.all(10.0),
                              backgroundColor: btnAll
                                  ? WidgetStateProperty.all<Color>(
                                      GlobalsVariables.buttonBlueDark
                                          .withValues(alpha: 0.6))
                                  : WidgetStateProperty.all<Color>(
                                      GlobalsVariables.buttonBlueDark),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                GlobalsVariables.textButtonGrey,
                              ),
                              alignment: Alignment.center,
                            ),
                            onPressed: () => _getChampionsByFilterClass(0),
                            child: const Text(
                              'All',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: GlobalsVariables.textButtonGrey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BtnCategoryChampion(
                          selected: btnSupSelected,
                          onPressed: () => _getChampionsByFilterClass(1),
                          pathIcon: 'assets/icons/Support.png',
                          label: 'Support',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BtnCategoryChampion(
                          selected: btnTankSelected,
                          onPressed: () => _getChampionsByFilterClass(2),
                          pathIcon: 'assets/icons/Front_Line.png',
                          label: 'Tanker',
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BtnCategoryChampion(
                          selected: btnFlankSelected,
                          onPressed: () => _getChampionsByFilterClass(3),
                          pathIcon: 'assets/icons/Flank.png',
                          label: 'Flank',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BtnCategoryChampion(
                          selected: btnDmgSelected,
                          onPressed: () => _getChampionsByFilterClass(4),
                          pathIcon: 'assets/icons/Damage.png',
                          label: 'Damage',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: GridView.count(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 3 / 2.5,
                crossAxisCount: 2,
                children: List.generate(
                  displayChampions.length,
                  (index) {
                    return AvatarChampion(
                      champion: Champion.fromJson(
                        displayChampions[index],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getChampionsByFilterClass(int championCategory) {
    //0 all
    //1 sup
    //2 tank
    //3 flank
    //4 damage

    setState(() {
      switch (championCategory) {
        case 0:
          displayChampions.clear();
          for (var item in champions) {
            displayChampions.add(item);
          }
          btnSupSelected = false;
          btnTankSelected = false;
          btnFlankSelected = false;
          btnDmgSelected = false;
          btnAll = true;
          break;
        case 1:
          displayChampions.clear();
          for (var item in champions) {
            if (item["Roles"].contains("Suporte")) {
              displayChampions.add(item);
            }
          }

          btnSupSelected = true;
          btnTankSelected = false;
          btnFlankSelected = false;
          btnDmgSelected = false;
          btnAll = false;
          break;
        case 2:
          displayChampions.clear();
          for (var item in champions) {
            if (item["Roles"].contains("Tanque")) {
              displayChampions.add(item);
            }
          }
          btnTankSelected = true;
          btnSupSelected = false;
          btnFlankSelected = false;
          btnDmgSelected = false;
          btnAll = false;
          break;
        case 3:
          displayChampions.clear();
          for (var item in champions) {
            if (item["Roles"].contains("Flanco")) {
              displayChampions.add(item);
            }
          }
          btnFlankSelected = true;
          btnSupSelected = false;
          btnTankSelected = false;
          btnDmgSelected = false;
          btnAll = false;
          break;
        case 4:
          displayChampions.clear();
          for (var item in champions) {
            if (item["Roles"].contains("Dano")) {
              displayChampions.add(item);
            }
          }
          btnDmgSelected = true;
          btnSupSelected = false;
          btnTankSelected = false;
          btnFlankSelected = false;
          btnAll = false;
          break;
        default:
          displayChampions.clear();
          for (var item in champions) {
            displayChampions.add(item);
          }
          btnSupSelected = false;
          btnTankSelected = false;
          btnFlankSelected = false;
          btnDmgSelected = false;
          btnAll = true;
      }
    });
  }

  _getChampions() async {
    try {
      // Verifica se tem sessão válida, se não tenta criar uma nova
      if (GlobalsVariables.sessionId.isEmpty) {
        print('Session ID is empty, trying to create session...');
        await UtilsFunctions.createSession();
      }

      if (GlobalsVariables.sessionId.isNotEmpty) {
        print('Using session ID: ${GlobalsVariables.sessionId}');
        var responseChampions = await ApiPaladinsHirez.getChampions(
            sessionId: GlobalsVariables.sessionId);

        if (responseChampions != null && responseChampions.isNotEmpty) {
          champions.clear();
          displayChampions.clear();

          for (var item in responseChampions) {
            champions.add(item);
            displayChampions.add(item);
          }
          print('Loaded ${champions.length} champions');
          setState(() {});
        } else {
          print('No champions returned from API');
          _loadMockData(); // Carrega dados de exemplo para teste
        }
      } else {
        print('Failed to create session, loading mock data');
        _loadMockData(); // Carrega dados de exemplo se não conseguir conectar
      }
    } catch (e) {
      print('Error in _getChampions: $e');
      _loadMockData(); // Carrega dados de exemplo em caso de erro
    }
  }

  // Função para carregar dados de exemplo quando a API não está disponível
  _loadMockData() {
    champions.clear();
    displayChampions.clear();

    // Dados de exemplo para teste com todos os campos necessários
    var mockChampions = [
      {
        'Name': 'Viktor',
        'Title': 'Lone Wolf',
        'Role': 'Damage',
        'ChampionIcon_URL':
            'https://web2.hirez.com/paladins/champion-icons/viktor.jpg',
        'Health': 2200,
        'Lore': 'A former Sentinel soldier...',
        'Name_English': 'Viktor',
        'OnFreeRotation': 'Y',
        'OnFreeWeeklyRotation': 'N',
        'Pros': 'High DPS, Easy to play',
        'Cons': 'No mobility, Vulnerable',
        'Speed': 365,
        'Type': 'Damage',
        'abilityDescription1': 'Assault Rifle',
        'abilityDescription2': 'Iron Sights',
        'abilityDescription3': 'Frag Grenade',
        'abilityDescription4': 'Hustle',
        'abilityDescription5': 'Barrage',
        'id': 2285,
        'latestChampion': 'n',
        'ret_msg': null,
        'Ability1': 'Assault Rifle',
        'Ability2': 'Iron Sights',
        'Ability3': 'Frag Grenade',
        'Ability4': 'Hustle',
        'Ability5': 'Barrage',
        'AbilityId1': 8528,
        'AbilityId2': 8503,
        'AbilityId3': 8504,
        'AbilityId4': 8505,
        'AbilityId5': 8548
      },
      {
        'Name': 'Cassie',
        'Title': 'Night Hunter',
        'Role': 'Damage',
        'ChampionIcon_URL':
            'https://web2.hirez.com/paladins/champion-icons/cassie.jpg',
        'Health': 2000,
        'Lore': 'A skilled archer...',
        'Name_English': 'Cassie',
        'OnFreeRotation': 'Y',
        'OnFreeWeeklyRotation': 'N',
        'Pros': 'High mobility, Consistent DPS',
        'Cons': 'Requires aim, Low health',
        'Speed': 365,
        'Type': 'Damage',
        'abilityDescription1': 'Crossbow',
        'abilityDescription2': 'Disengage',
        'abilityDescription3': 'Blast Shot',
        'abilityDescription4': 'Dodge Roll',
        'abilityDescription5': 'Big Game',
        'id': 2092,
        'latestChampion': 'n',
        'ret_msg': null,
        'Ability1': 'Crossbow',
        'Ability2': 'Disengage',
        'Ability3': 'Blast Shot',
        'Ability4': 'Dodge Roll',
        'Ability5': 'Big Game',
        'AbilityId1': 7405,
        'AbilityId2': 7406,
        'AbilityId3': 7407,
        'AbilityId4': 7408,
        'AbilityId5': 7409
      },
      {
        'Name': 'Fernando',
        'Title': 'Self-Appointed Knight',
        'Role': 'Front Line',
        'ChampionIcon_URL':
            'https://web2.hirez.com/paladins/champion-icons/fernando.jpg',
        'Health': 4500,
        'Lore': 'A self-appointed knight...',
        'Name_English': 'Fernando',
        'OnFreeRotation': 'Y',
        'OnFreeWeeklyRotation': 'N',
        'Pros': 'High health, Good shield',
        'Cons': 'Low damage, Slow',
        'Speed': 340,
        'Type': 'Front Line',
        'abilityDescription1': 'Lance',
        'abilityDescription2': 'Shield',
        'abilityDescription3': 'Fireball',
        'abilityDescription4': 'Charge',
        'abilityDescription5': 'Immortal',
        'id': 2071,
        'latestChampion': 'n',
        'ret_msg': null,
        'Ability1': 'Lance',
        'Ability2': 'Shield',
        'Ability3': 'Fireball',
        'Ability4': 'Charge',
        'Ability5': 'Immortal',
        'AbilityId1': 7201,
        'AbilityId2': 7202,
        'AbilityId3': 7203,
        'AbilityId4': 7204,
        'AbilityId5': 7205
      }
    ];

    for (var champion in mockChampions) {
      champions.add(champion);
      displayChampions.add(champion);
    }

    print('Loaded ${champions.length} mock champions');
    setState(() {});
  }
}
