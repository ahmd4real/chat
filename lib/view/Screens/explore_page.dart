import 'package:chat/core/utils/constants.dart';
import 'package:chat/services/services.dart';
import 'package:chat/view/Widgets/explore_people_widget.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late Future<List<dynamic>> people;
  late List<dynamic> allPeople;
  List<dynamic> filteredPeople = [];
  final TextEditingController _searchController = TextEditingController();

  Map<int, bool> pendingRequests = {};

  @override
  void initState() {
    super.initState();
    people = explore('');
    people.then((fetchedPeople) {
      setState(() {
        allPeople = fetchedPeople;
        filteredPeople = fetchedPeople;
      });
    });

    _searchController.addListener(_filterPeople);
  }

  void _filterPeople() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredPeople = allPeople.where((person) {
        final fullName =
            '${person['firstName']} ${person['lastName']}'.toLowerCase();
        return fullName.contains(query);
      }).toList();
    });
  }

  void updatePendingState(int id, bool isPending) {
    setState(() {
      pendingRequests[id] = isPending;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: 
      
      
      background,
      appBar: AppBar(
        backgroundColor: background,
        title: Text(
          'Explore',
          style: TextStyle( 
            color: mainColor,
            fontSize: 32,
            fontFamily: font,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SearchBar(
                hintStyle:
                    WidgetStatePropertyAll(TextStyle(color: searchContent)),
                backgroundColor: WidgetStatePropertyAll(searchBack),
                controller: _searchController,
                hintText: 'Search for Friends',
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.search_sharp,
                    color: searchContent,
                    size: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: people,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: mainColor,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No People available'));
                  } else {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: filteredPeople.length,
                      itemBuilder: (context, index) {
                        final person = filteredPeople[index];

                        final fullName =
                            '${person['firstName']} ${person['lastName']}';
                        final profilePic = person['profilePicture'];
                        final isPending =
                            pendingRequests[person['id']] ?? false;
                            final bio=person['biography'];


                        return ExplorePeopleWidget(
                          bio: bio,
                          userName: fullName,
                          id: person['id'],
                          profilePic: profilePic,
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
