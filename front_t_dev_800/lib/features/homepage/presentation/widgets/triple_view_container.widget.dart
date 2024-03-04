import 'package:flutter/material.dart';
import 'package:front_t_dev_800/features/homepage/presentation/widgets/container_image.widget.dart';

class TripleContainerWidget extends StatelessWidget {
  const TripleContainerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: ContainerImageWidget(imageUrl: 'assets/images/card.png'),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: ContainerImageWidget(imageUrl: 'assets/images/card.png'),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: ContainerImageWidget(imageUrl: 'assets/images/card.png'),
          ),
        ),
      ],
    );
  }
}
