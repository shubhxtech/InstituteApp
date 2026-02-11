import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vertex/features/home/presentation/providers/dynamic_content_provider.dart';
import 'package:vertex/utils/constants.dart';
import 'package:vertex/widgets/glass_container.dart';

class MessMenuPage extends StatefulWidget {
  const MessMenuPage({super.key});

  @override
  State<MessMenuPage> createState() => _MessMenuPageState();
}

class _MessMenuPageState extends State<MessMenuPage> with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Meal type icons
  final Map<String, IconData> mealIcons = {
    'Breakfast': Icons.free_breakfast_rounded,
    'Lunch': Icons.lunch_dining_rounded,
    'Snacks': Icons.coffee_rounded,
    'Dinner': Icons.dinner_dining_rounded,
  };

  @override
  void initState() {
    super.initState();
    // Initialize with 7 days default, will be updated in build
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DynamicContentProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        Map<String, Map<String, List<String>>> messMenu = provider.messMenuMap;
        
        // Null safety check to prevent crashes
        if (messMenu.isEmpty) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                "Mess Menu",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu_rounded,
                    size: 64,
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Mess menu not available',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
                  ElevatedButton(
                     onPressed: () => provider.fetchAllContent(),
                     child: const Text('Retry'),
                  )
                ],
              ),
            ),
          );
        }
        
        List<String> days = messMenu.keys.toList();
        
        // Re-initialize tab controller if length changes
        if (_tabController.length != days.length) {
           _tabController.dispose();
           _tabController = TabController(length: days.length, vsync: this);
           _tabController.animateTo(0);
        }
        
        return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Mess Menu",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).primaryColor,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: days.map((day) => Tab(text: day)).toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: days.map((day) => _buildDayMenu(context, day, messMenu[day]!)).toList(),
      ),
    );
  });
  }

  Widget _buildDayMenu(BuildContext context, String day, Map<String, List<String>> meals) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: meals.entries.map((entry) {
        return _buildMealCard(context, entry.key, entry.value);
      }).toList(),
    );
  }

  Widget _buildMealCard(BuildContext context, String mealType, List<String> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(20),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meal type header with icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    mealIcons[mealType] ?? Icons.restaurant_rounded,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  mealType,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Food items
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: items.map((item) => _buildFoodChip(context, item)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodChip(BuildContext context, String item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        item,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
