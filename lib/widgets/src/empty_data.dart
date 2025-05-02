import 'package:employee_work/core/extensions/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyData extends StatefulWidget {
  const EmptyData({super.key, this.title, this.icon, this.onRetry});
  final String? title;
  final Widget? icon;
  final void Function()? onRetry;

  //Sliver version of Empty Data. Use combination with CustomScrollView or NestedScrollView.
  static Widget sliver({String? title, EdgeInsetsGeometry? padding}) {
    return SliverPadding(
      padding: padding ?? const EdgeInsets.only(top: 24),
      sliver: SliverToBoxAdapter(
        child: EmptyData(
          title: title,
        ),
      ),
    );
  }

  @override
  State<EmptyData> createState() => _EmptyDataState();
}

class _EmptyDataState extends State<EmptyData> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.75,
            child: widget.icon ??
                SvgPicture.asset(
                  'assets/svgs/no_data.svg',
                ),
          ),
          // Text(
          //   title,
          //   style: Theme.of(context)
          //       .textTheme
          //       .bodyLarge!
          //       .copyWith(color: context.colors.neutral0),
          // ),
          SizedBox(height: widget.onRetry != null ? 16 : 0),
          if (widget.onRetry != null)
            CupertinoButton(
              onPressed: widget.onRetry,
              color: context.colors.redPrimary,
              borderRadius: BorderRadius.circular(100),
              minSize: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Text(
                'Reload',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: context.colors.neutral0,
                    ),
              ),
            )
          else
            const SizedBox(),
        ],
      ),
    );
  }
}
