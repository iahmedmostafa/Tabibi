import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/features/doctor_details/presentation/controller/reviews_cubit.dart';
import 'package:tabibi/features/doctor_details/presentation/controller/reviews_state.dart';
import 'package:tabibi/features/doctor_details/presentation/widgets/review_item.dart';

class DoctorReviewsScreen extends StatefulWidget {
  final String doctorId;

  const DoctorReviewsScreen({super.key, required this.doctorId});

  @override
  State<DoctorReviewsScreen> createState() => _DoctorReviewsScreenState();
}

class _DoctorReviewsScreenState extends State<DoctorReviewsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ReviewsCubit>().getMoreReviews(widget.doctorId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReviewsCubit>()..getReviews(widget.doctorId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.reviews),
          centerTitle: true,
        ),
        body: BlocBuilder<ReviewsCubit, ReviewsState>(
          builder: (context, state) {
            if (state is ReviewsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReviewsFailure) {
              return Center(child: Text(state.message));
            } else if (state is ReviewsSuccess ||
                state is ReviewsPaginationLoading) {
              final reviews = state is ReviewsSuccess
                  ? state.reviews
                  : (state as ReviewsPaginationLoading).reviews;
              final hasNextPage = state is ReviewsSuccess
                  ? state.hasNextPage
                  : true;

              if (reviews.isEmpty) {
                return const Center(child: Text("No reviews found"));
              }

              return ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(24.w),
                itemCount: reviews.length + (hasNextPage ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < reviews.length) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: ReviewItem(review: reviews[index]),
                    );
                  } else {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
