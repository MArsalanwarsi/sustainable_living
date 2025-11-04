import 'package:flutter/material.dart';

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
  String impactLevel = '';
  String suggestion = '';
  bool showResult = false;

  Color getImpactColor() {
    if (totalCO2 < 3) return Colors.green.shade300;
    if (totalCO2 < 6) return Colors.yellow.shade600;
    return Colors.red.shade400;
  }

  void calculateImpact() {
    double factor = 0;

    // Transportation emission factor
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

    // Food emission factor
    double foodFactor = 0;
    if (foodType == 'Meat') foodFactor = 2.0;
    if (foodType == 'Vegetarian') foodFactor = 0.8;
    if (foodType == 'Vegan') foodFactor = 0.5;

    // Plastic and recycle effect
    double plasticFactor = usedPlastic ? 1.2 : 0;
    double recycleBonus = recycledWaste ? 1.0 : 0;

    // Final CO2 calculation
    totalCO2 = (distance * factor) +
        (electricityHours * 0.12) +
        (showerMinutes * 0.1) +
        foodFactor +
        plasticFactor -
        recycleBonus;

    // Determine impact level
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

    setState(() {
      showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
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
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
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
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
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
                  Text("Hours Used: ${electricityHours.toStringAsFixed(1)} hrs"),
                  Slider(
                    value: electricityHours,
                    min: 0,
                    max: 12,
                    divisions: 12,
                    label: "${electricityHours.toStringAsFixed(1)} hrs",
                    onChanged: (val) =>
                        setState(() => electricityHours = val),
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
                  Text("Shower Duration: ${showerMinutes.toStringAsFixed(0)} min"),
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
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "🌍 You produced ${totalCO2.toStringAsFixed(2)} kg CO₂ today",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Impact Level: $impactLevel",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            suggestion,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "🌿 Great! You earned +50 Green Points 💚"),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              "💾 Save Result",
                              style: TextStyle(color: Colors.green.shade800),
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
