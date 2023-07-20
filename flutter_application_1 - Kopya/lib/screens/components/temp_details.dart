import 'package:flutter/material.dart';

import '../../constanins.dart';
import '../../home_controller.dart';
import 'tmp_btn.dart';

class TempDetails extends StatefulWidget {
  const TempDetails({
    Key? key,
    required HomeController controller,
  })  : _controller = controller,
        super(key: key);

  final HomeController _controller;

  @override
  _TempDetailsState createState() => _TempDetailsState();
}

class _TempDetailsState extends State<TempDetails> {
  int temperature = 29;

  void increaseTemperature() {
    if (!widget._controller.isCoolSelected) {
      setState(() {
        temperature++;
      });
    }
  }

  void decreaseTemperature() {
    if (widget._controller.isCoolSelected) {
      setState(() {
        temperature--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 120,
            child: Row(
              children: [
                TempBtn(
                  isActive: widget._controller.isCoolSelected,
                  svgSrc: "assets/coolShape.svg",
                  title: "Cool",
                  press: widget._controller.updateCoolSelectedTab,
                ),
                const SizedBox(width: defaultPadding),
                TempBtn(
                  isActive: !widget._controller.isCoolSelected,
                  svgSrc: "assets/heatShape.svg",
                  title: "Heat",
                  activeColor: redColor,
                  press: widget._controller.updateCoolSelectedTab,
                ),
              ],
            ),
          ),
          Spacer(),
          Column(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: increaseTemperature,
                icon: Icon(Icons.arrow_drop_up, size: 48),
              ),
              Text(
                temperature.toString() + "\u2103",
                style: TextStyle(fontSize: 86),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: decreaseTemperature,
                icon: Icon(Icons.arrow_drop_down, size: 48),
              ),
            ],
          ),
          Spacer(),
          Text("CURRENT TEMPERATURE"),
          const SizedBox(height: defaultPadding),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Inside".toUpperCase(),
                  ),
                  Text(
                    "20" + "\u2103",
                    style: Theme.of(context).textTheme.headline5,
                  )
                ],
              ),
              const SizedBox(width: defaultPadding),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Outside".toUpperCase(),
                    style: TextStyle(color: Colors.white54),
                  ),
                  Text(
                    "35" + "\u2103",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Colors.white54),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
