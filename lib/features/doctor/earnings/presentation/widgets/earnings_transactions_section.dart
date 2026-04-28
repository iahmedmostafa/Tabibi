import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/features/doctor/earnings/presentation/cubit/earnings_cubit.dart';
import 'package:tabibi/features/doctor/earnings/presentation/cubit/earnings_state.dart';
import 'package:tabibi/features/doctor/earnings/presentation/widgets/earnings_dashboard_card.dart';
import 'package:tabibi/features/doctor/earnings/presentation/widgets/earnings_inline_states.dart';
import 'package:tabibi/features/doctor/earnings/presentation/widgets/earnings_section_header.dart';
import 'package:tabibi/features/doctor/earnings/presentation/widgets/earnings_transaction_card.dart';

class EarningsTransactionsSection extends StatelessWidget {
  const EarningsTransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningsCubit, EarningsState>(
      buildWhen: (previous, current) =>
          previous.transactions != current.transactions ||
          previous.transactionsStatus != current.transactionsStatus ||
          previous.hasNextPage != current.hasNextPage ||
          previous.isLoadingMore != current.isLoadingMore,
      builder: (context, state) {
        return EarningsDashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const EarningsSectionHeader(
                title: 'Recent Transactions',
                subtitle: 'Completed visit payments',
                icon: Icons.receipt_long_outlined,
              ),
              SizedBox(height: 16.h),
              if (state.isTransactionsLoading)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.hasInitialTransactionsFailure)
                EarningsInlineError(
                  message:
                      state.transactionsErrorMessage ??
                      'Failed to load transactions.',
                  onRetry: context.read<EarningsCubit>().retryTransactions,
                )
              else if (state.transactions.isEmpty)
                const EarningsEmptyInlineState(message: 'No transactions yet.')
              else ...[
                ...state.transactions.map(
                  (transaction) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: EarningsTransactionCard(transaction: transaction),
                  ),
                ),
                if (state.hasNextPage)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: !state.canLoadMoreTransactions
                          ? null
                          : context.read<EarningsCubit>().loadMoreTransactions,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 13.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: state.isLoadingMore
                          ? SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Load More'),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}
