import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:myproject_app/model/product.dart';
import '../../service/product_service.dart';
import 'product_detail.dart';

class ProductFilter extends StatefulWidget {
  const ProductFilter(this.type, {super.key});
  final String type;

  @override
  State<ProductFilter> createState() => _ProductFilterState();
}

class _ProductFilterState extends State<ProductFilter> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
        stream: ProductService.readProduct(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.hasError.toString());
          } else if (snapshot.hasData) {
            final product = snapshot.data!;
            return GridView(
              padding: const EdgeInsets.only(top: 3),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 2 / 3.6,
              ),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: product
                  .where((product) => product.type == widget.type)
                  .map(buidProduct)
                  .toList(),
            );
          } else {
            return const Center(
              child: Text("Sản phẩm hiện chưa được trưng bày"),
            );
          }
        });
  }

  Widget buidProduct(Product product) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          Stack(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductDetail(product)));
                },
                child: Image.network(product.productUrl[0],
                    height: 285, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Hot",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Icon(Icons.favorite_border, color: Colors.red),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            alignment: Alignment.centerLeft,
            child: Text(
              product.productName.toString(),
              textAlign: TextAlign.justify,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(
              height: 0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${MoneyFormatter(amount: product.price.toDouble()).output.withoutFractionDigits}đ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Text(
                  'Đã bán: ${product.sold}',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
