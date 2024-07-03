import 'package:flutter/material.dart';
import 'package:flutter_sport/widgets/pages/groupdetails/group_detail_page.dart';


class SmallListWidget extends StatelessWidget {

  final int id;
  final Image image;
  final String title;
  final String intro;
  final String sportType;
  final String region;
  final int personCount;

  const SmallListWidget({super.key, required this.id, required this.image, required this.title, required this.intro, required this.sportType, required this.region, required this.personCount});



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) => GroupDetailWidget(id: id,),)
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 70, height: 70,
              margin: const EdgeInsets.only(right: 15),
              child: image,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(intro,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.secondary
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFDFDFDF)

                        ),
                        child: Text(sportType,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(' · ',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 12,
                        ),
                      ),
                      Text(region,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 12,
                        ),
                      ),
                      Text(' · ',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 12,
                        ),
                      ),
                      Text('$personCount명',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 12,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],

        ),
      ),
    );
  }
}
