import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sustainable_living/Custom/customwidget.dart';

class CarbonCalculatorScreen extends StatefulWidget {
  const CarbonCalculatorScreen({super.key});

  @override
  State<CarbonCalculatorScreen> createState() => _CarbonCalculatorScreenState();
}

class _CarbonCalculatorScreenState extends State<CarbonCalculatorScreen>
    with SingleTickerProviderStateMixin {
  String? transportMode = 'Car';
  double distance = 0;
  double electricityHours = 0;
  double showerMinutes = 0;
  String foodType = 'Meat';
  bool usedPlastic = false;
  bool recycledWaste = false;

  double totalCO2 = 0;
  double yearCO2 = 0;
  String yearlyImpact = '';
  String yearlySuggestion = '';
  String impactLevel = '';
  String suggestion = '';
  bool showResult = false;

  @override
  void initState() {
    super.initState();
    getvalues();
  }

  void getvalues() async {
    // firebase firestore get the values of the user's carbon calculations
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('carbon_calculations')
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = querySnapshot.docs.first;
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        totalCO2 = data['total_co2'];
        yearCO2 = data['yearly_co2'];
        impactLevel = data['impact_level'];
        suggestion = data['suggestion'];
        yearlyImpact = data['yearly_impact'];
        yearlySuggestion = data['yearly_suggestion'];
        transportMode = data['transport_mode'];
        distance = data['distance'];
        electricityHours = data['electricity_hours'];
        showerMinutes = data['shower_minutes'];
        foodType = data['food_type'];
        usedPlastic = data['used_plastic'];
        recycledWaste = data['recycled_waste'];
        setState(() {});
      }
    }
  }

  Color getImpactColor() {
    if (totalCO2 < 3) return Colors.green.shade300;
    // Use a yellow-orange warning color with good contrast for white text.
    if (totalCO2 < 6) return const Color(0xFFFFA726); // Orange 400
    return Colors.red.shade400;
  }

  void calculateImpact() {
    double factor = 0;

    switch (transportMode) {
      case 'Car':
        factor = 0.21;
        break;
      case 'Bus':
        factor = 0.11;
        break;
      case 'Bike':
        factor = 0.02;
        break;
      case 'Walk':
        factor = 0;
        break;
    }

    double foodFactor = 0;
    if (foodType == 'Meat') foodFactor = 2.0;
    if (foodType == 'Vegetarian') foodFactor = 0.8;
    if (foodType == 'Vegan') foodFactor = 0.5;

    double plasticFactor = usedPlastic ? 1.2 : 0;
    double recycleBonus = recycledWaste ? 1.0 : 0;

    // Daily CO₂ (kg)
    totalCO2 =
        (distance * factor) +
        (electricityHours * 0.12) +
        (showerMinutes * 0.1) +
        foodFactor +
        plasticFactor -
        recycleBonus;

    // Yearly CO₂ (approx.)
    yearCO2 = totalCO2 * 365;

    // Yearly CO₂ in tons
    double yearCO2Tons = yearCO2 / 1000;

    // Impact level (daily)
    if (totalCO2 < 3) {
      impactLevel = "🌿 Low";
      suggestion = "Excellent! Keep walking and reusing bottles.";
    } else if (totalCO2 < 6) {
      impactLevel = "🌤 Moderate";
      suggestion = "Good work! Try shorter showers or public transport.";
    } else {
      impactLevel = "🔥 High";
      suggestion = "High carbon day! Try biking or skipping meat tomorrow.";
    }

    // Yearly impact evaluation
    if (yearCO2Tons < 3) {
      yearlyImpact = "🌿 Excellent (Low)";
      yearlySuggestion = "You're living sustainably!";
    } else if (yearCO2Tons < 6) {
      yearlyImpact = "🌤 Average (Moderate)";
      yearlySuggestion = "You're around the global average — keep improving!";
    } else if (yearCO2Tons < 10) {
      yearlyImpact = "🔥 High";
      yearlySuggestion = "Try cutting down on energy and car use.";
    } else {
      yearlyImpact = "🌋 Very High";
      yearlySuggestion =
          "Consider major lifestyle changes to reduce emissions.";
    }

    setState(() {
      showResult = true;
    });
  }

  void saveCo2Breakdown() async {
    final user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    try {
      // if users with same uid already have collection 'carbon_calculations', and firstime field, then update document instead of adding new one
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('carbon_calculations')
              .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            querySnapshot.docs.first;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('carbon_calculations')
            .doc(userDoc.id)
            .update({
              'Firstime': 'no',
              'date': DateTime.now(),
              'daily_co2': totalCO2,
              'yearly_co2': yearCO2,
              'impact_level': impactLevel,
              'suggestion': suggestion,
              'yearly_impact': yearlyImpact,
              'yearly_suggestion': yearlySuggestion,
              'transport_mode': transportMode,
              'distance': distance,
              'electricity_hours': electricityHours,
              'shower_minutes': showerMinutes,
              'food_type': foodType,
              'used_plastic': usedPlastic,
              'recycled_waste': recycledWaste,
              'total_co2': totalCO2,
            });
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('carbon_calculations')
            .add({
              'Firstime': 'yes',
              'date': DateTime.now(),
              'daily_co2': totalCO2,
              'yearly_co2': yearCO2,
              'impact_level': impactLevel,
              'suggestion': suggestion,
              'yearly_impact': yearlyImpact,
              'yearly_suggestion': yearlySuggestion,
              'transport_mode': transportMode,
              'distance': distance,
              'electricity_hours': electricityHours,
              'shower_minutes': showerMinutes,
              'food_type': foodType,
              'used_plastic': usedPlastic,
              'recycled_waste': recycledWaste,
              'total_co2': totalCO2,
              'Green_Points': 50,
            });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("🌿 Great! You earned +50 Green Points 💚"),
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error saving data: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset('assets/name.png', height: 58, fit: BoxFit.contain),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: buildCustomBottomBar(context, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Calculate Your Daily Carbon Footprint 🌿",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Answer the questions below to see your impact.",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Transportation
            buildCard(
              title: "🚗 Transportation",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<String>(
                    value: transportMode,
                    items: ['Car', 'Bus', 'Bike', 'Walk']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => transportMode = val),
                  ),
                  Text("Distance Traveled: ${distance.toStringAsFixed(1)} km"),
                  Slider(
                    value: distance,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: "${distance.toStringAsFixed(1)} km",
                    onChanged: (val) => setState(() => distance = val),
                    activeColor: Colors.green.shade700,
                  ),
                ],
              ),
            ),

            // Electricity
            buildCard(
              title: "⚡ Electricity Usage",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hours Used: ${electricityHours.toStringAsFixed(1)} hrs",
                  ),
                  Slider(
                    value: electricityHours,
                    min: 0,
                    max: 12,
                    divisions: 12,
                    label: "${electricityHours.toStringAsFixed(1)} hrs",
                    onChanged: (val) => setState(() => electricityHours = val),
                    activeColor: Colors.green.shade700,
                  ),
                ],
              ),
            ),

            // Water
            buildCard(
              title: "💧 Water Usage",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Shower Duration: ${showerMinutes.toStringAsFixed(0)} min",
                  ),
                  Slider(
                    value: showerMinutes,
                    min: 0,
                    max: 30,
                    divisions: 30,
                    label: "${showerMinutes.toStringAsFixed(0)} min",
                    onChanged: (val) => setState(() => showerMinutes = val),
                    activeColor: Colors.green.shade700,
                  ),
                ],
              ),
            ),

            // Food & Waste
            buildCard(
              title: "🍽️ Food & Waste",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select your meal type:",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),

                  // Make meal options vertical (no overflow)
                  Column(
                    children: ['Meat', 'Vegetarian', 'Vegan']
                        .map(
                          (e) => RadioListTile<String>(
                            title: Text(e),
                            value: e,
                            groupValue: foodType,
                            activeColor: Colors.green.shade700,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) => setState(() => foodType = val!),
                          ),
                        )
                        .toList(),
                  ),

                  const Divider(height: 10, thickness: 0.5),

                  CheckboxListTile(
                    title: const Text("Used single-use plastic 🗑️"),
                    value: usedPlastic,
                    activeColor: Colors.green.shade700,
                    onChanged: (val) => setState(() => usedPlastic = val!),
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    title: const Text("Recycled waste ♻️"),
                    value: recycledWaste,
                    activeColor: Colors.green.shade700,
                    onChanged: (val) => setState(() => recycledWaste = val!),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Calculate Button
            ElevatedButton(
              onPressed: calculateImpact,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 32,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "💚 Calculate My Impact",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),

            // Result Section (Animated)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: showResult
                  ? Container(
                      key: const ValueKey(1),
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: getImpactColor(),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🌿 DAILY SECTION
                          Text(
                            "🌍 Daily Carbon Footprint",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${totalCO2.toStringAsFixed(2)} kg CO₂ emitted today",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Impact Level: $impactLevel",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            suggestion,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),

                          const Divider(
                            height: 25,
                            thickness: 1,
                            color: Colors.white30,
                          ),

                          // 📅 YEARLY SECTION
                          Text(
                            "📅 Estimated Yearly Footprint",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${yearCO2.toStringAsFixed(2)} kg CO₂ per year",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Yearly Impact: $yearlyImpact",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            yearlySuggestion,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // 🌈 CO2 PROGRESS BAR (interactive)
                          Text(
                            "🌡️ Global Comparison",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),

                          GestureDetector(
                            onTap: () {
                              // Calculate contributions
                              double transportCO2 = distance * 0.21;
                              double electricityCO2 = electricityHours * 0.12;
                              double showerCO2 = showerMinutes * 0.1;
                              double foodCO2 = foodType == 'Meat'
                                  ? 2.0
                                  : foodType == 'Vegetarian'
                                  ? 0.8
                                  : 0.5;
                              double plasticCO2 = usedPlastic ? 1.2 : 0;
                              double recycleCO2 = recycledWaste ? -1.0 : 0;

                              Map<String, double> categories = {
                                "🚗 Transport": transportCO2,
                                "⚡ Electricity": electricityCO2,
                                "🚿 Showers": showerCO2,
                                "🍽️ Food": foodCO2,
                                "🧴 Plastic": plasticCO2,
                                "♻️ Recycling": recycleCO2,
                              };

                              double positiveTotal = categories.values
                                  .where((v) => v > 0)
                                  .fold(0.0, (a, b) => a + b);

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: const Text(
                                    "Your CO₂ Breakdown 🌿",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...categories.entries.map((entry) {
                                          final percent = entry.value > 0
                                              ? (entry.value /
                                                    positiveTotal *
                                                    100)
                                              : 0.0;
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 10,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${entry.key} — ${entry.value.toStringAsFixed(2)} kg (${percent.toStringAsFixed(1)}%)",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                LinearProgressIndicator(
                                                  value: percent / 100,
                                                  minHeight: 6,
                                                  backgroundColor:
                                                      Colors.grey.shade300,
                                                  color: percent < 20
                                                      ? Colors.green
                                                      : percent < 40
                                                      ? Colors.yellow[700]
                                                      : Colors.redAccent,
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                        const SizedBox(height: 12),
                                        const Text(
                                          "💡 Personalized Eco Tips:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          foodType == 'Meat'
                                              ? "Try 1–2 meat-free days per week 🌱"
                                              : usedPlastic
                                              ? "Switch to reusable bottles and bags ♻️"
                                              : electricityHours > 5
                                              ? "Unplug devices and use LEDs ⚡"
                                              : "You're doing great! Keep reducing little by little 🌿",
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        "Close",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double globalAverage = 5000;
                                double normalizedValue =
                                    (yearCO2 / globalAverage).clamp(0.0, 2.0);

                                return Stack(
                                  children: [
                                    // Background gradient
                                    Container(
                                      width: constraints.maxWidth,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF2ECC71), // green
                                            Color(0xFFF1C40F), // yellow
                                            Color(0xFFE74C3C), // red
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Progress overlay
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 800,
                                      ),
                                      width:
                                          constraints.maxWidth *
                                          (normalizedValue / 2),
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 8),
                          Text(
                            "⬅️ 0 kg  5,000 kg (Average)  10,000+ kg ➡️",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // 💾 SAVE BUTTON
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                saveCo2Breakdown();
                              },
                              icon: const Icon(Icons.save, color: Colors.green),
                              label: Text(
                                "Save Result",
                                style: TextStyle(
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ),

            const SizedBox(height: 20),
            const Text(
              "Every small change helps our planet 🌎💚",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget buildCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
