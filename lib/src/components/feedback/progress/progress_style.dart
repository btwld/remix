part of 'progress.dart';

class RxProgressStyle extends ProgressSpecUtility<ProgressSpecAttribute> {
  RxProgressStyle() : super((v) => v);

  factory RxProgressStyle._default() {
    return RxProgressStyle()
      ..container.height(6)
      ..container.clipBehavior.antiAlias()
      ..container.shape.stadium()
      ..fill.color.black()
      ..fill.borderRadius(99)
      ..track.color.grey.shade200();
  }

  @override
  RxProgressStyle merge(RxProgressStyle other) {
    return super.merge(other) as RxProgressStyle;
  }
}
