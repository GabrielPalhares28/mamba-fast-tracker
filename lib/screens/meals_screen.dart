import 'package:flutter/material.dart';

import '../services/user_preferences.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  List<Meal> meals = [];

  final UserPreferences _userPreferences = UserPreferences();

  int dailyCalorieGoal = 2000;

  @override
  void initState() {
    super.initState();
    _loadMeals();
    _loadDailyCalorieGoal();
    _editDailyCalorieGoal();
  }

  Future<void> _editDailyCalorieGoal() async {
    final controller = TextEditingController(text: dailyCalorieGoal.toString());

    final newGoal = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Meta diária'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Calorias',
              suffixText: 'kcal',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                final goal = int.tryParse(controller.text.trim());

                if (goal == null || goal <= 0) {
                  return;
                }

                Navigator.pop(context, goal);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.dispose();
    });

    if (newGoal == null) {
      return;
    }

    await _userPreferences.saveDailyCalorieGoal(newGoal);

    if (!mounted) return;

    setState(() {
      dailyCalorieGoal = newGoal;
    });
  }

  Future<void> _loadDailyCalorieGoal() async {
    final savedGoal = await _userPreferences.loadDailyCalorieGoal();

    if (!mounted) return;

    setState(() {
      dailyCalorieGoal = savedGoal;
    });
  }

  Future<void> _loadMeals() async {
    final loadedMeals = await database.getMealsForDay(DateTime.now());

    if (!mounted) return;

    setState(() {
      meals = loadedMeals;
    });
  }

  Future<void> _addMeal() async {
    final nameController = TextEditingController();
    final caloriesController = TextEditingController();

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nova refeição'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome da refeição',
                  hintText: 'Ex: Frango com arroz',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: caloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Calorias',
                  hintText: 'Ex: 650',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );

    if (shouldSave != true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        nameController.dispose();
        caloriesController.dispose();
      });

      return;
    }

    final name = nameController.text.trim();
    final calories = int.tryParse(caloriesController.text.trim());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameController.dispose();
      caloriesController.dispose();
    });

    if (name.isEmpty || calories == null || calories <= 0) {
      return;
    }

    await database.addMeal(
      MealsCompanion.insert(
        name: name,
        calories: calories,
        createdAt: DateTime.now(),
      ),
    );

    await _loadMeals();
  }

  Future<void> _editMeal(Meal meal) async {
    final nameController = TextEditingController(text: meal.name);
    final caloriesController = TextEditingController(
      text: meal.calories.toString(),
    );

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar refeição'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome da refeição',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: caloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Calorias'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (shouldSave != true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        nameController.dispose();
        caloriesController.dispose();
      });

      return;
    }

    final name = nameController.text.trim();
    final calories = int.tryParse(caloriesController.text.trim());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameController.dispose();
      caloriesController.dispose();
    });

    if (name.isEmpty || calories == null || calories <= 0) {
      return;
    }

    final updatedMeal = meal.copyWith(name: name, calories: calories);

    await database.updateMeal(updatedMeal);

    await _loadMeals();
  }

  Future<void> _deleteMeal(Meal meal) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir refeição'),
          content: Text('Deseja excluir "${meal.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    await database.deleteMeal(meal.id);

    await _loadMeals();
  }

  @override
  Widget build(BuildContext context) {
    final totalCalories = meals.fold<int>(
      0,
      (total, meal) => total + meal.calories,
    );
    final isWithinGoal = totalCalories <= dailyCalorieGoal;

    return Scaffold(
      appBar: AppBar(title: const Text('Refeições')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Hoje', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                '$totalCalories kcal consumidas',

                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(child: Text('Meta: $dailyCalorieGoal kcal')),
                  TextButton.icon(
                    onPressed: _editDailyCalorieGoal,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Alterar'),
                  ),
                ],
              ),

              Text(isWithinGoal ? 'Dentro da meta' : 'Acima da meta'),
              const SizedBox(height: 24),

              Expanded(
                child: meals.isEmpty
                    ? const Center(
                        child: Text('Nenhuma refeição registrada hoje.'),
                      )
                    : ListView.separated(
                        itemCount: meals.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final meal = meals[index];

                          return Card(
                            child: ListTile(
                              title: Text(meal.name),
                              subtitle: Text(
                                '${meal.createdAt.hour.toString().padLeft(2, '0')}:'
                                '${meal.createdAt.minute.toString().padLeft(2, '0')}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${meal.calories} kcal'),
                                  IconButton(
                                    onPressed: () {
                                      _editMeal(meal);
                                    },
                                    icon: const Icon(Icons.edit_outlined),
                                    tooltip: 'Editar',
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _deleteMeal(meal);
                                    },
                                    icon: const Icon(Icons.delete_outline),
                                    tooltip: 'Excluir',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 16),

              FilledButton.icon(
                onPressed: _addMeal,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar refeição'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
