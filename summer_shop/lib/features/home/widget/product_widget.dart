import 'package:flutter/material.dart';
import 'package:summer_shop/utils/theme.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Container(
      padding: EdgeInsets.all(6),
      margin: EdgeInsets.only(bottom: 4),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: const Color.from(
            alpha: 1,
            red: 0.765,
            green: 0.757,
            blue: 0.757,
          ),
        ),
        borderRadius: BorderRadius.circular(6),
        color: const Color.fromARGB(0, 230, 162, 162),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Container(
            width: double.infinity,
            height: height * 0.3,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
            child: Image.asset("assets/images/T-shirt.webp", fit: BoxFit.fill),
          ),
          Text(
            "Classic Grey Hooded Sweatshirtkjhgh",
            style: TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              Text("Price: 32.000Fb", style: TextStyle(fontWeight: .bold)),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 18),
                decoration: BoxDecoration(
                  color: ThemeColor.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text("Detail"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
