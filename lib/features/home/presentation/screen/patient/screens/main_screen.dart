import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/departments_cubit.dart';
import 'package:tabibi/features/home/presentation/screen/patient/screens/all_doctors_screen.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/custom_container.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int selectedIndex = 0;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    context.read<DepartmentsCubit>().getDepartments();
  }

  void _initOnce(int length) {
    if (_initialized) return;
    _tabController = TabController(length: length, vsync: this);
    _tabController!.addListener(() {
      setState(() => selectedIndex = _tabController!.index);
    });
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Departments")),
      body: BlocBuilder<DepartmentsCubit, DepartmentsState>(
        builder: (context, state) {
          if (state.departmentsStatus == DepartmentsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.departmentsStatus == DepartmentsStatus.success) {
            _initOnce(state.departments!.length);

            return Column(
              children: [
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: Colors.transparent,
                  tabs: List.generate(state.departments!.length, (index) {
                    return CustomContainer(
                      widget: Text(state.departments![index].name),
                      isSelected: selectedIndex == index,
                    );
                  }),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: state.departments!.map((dept) {
                      return AllDoctorsScreen(
                        departmentName: dept.name,
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }

          return Center(child: Text(state.errorMessage ?? "Error"));
        },
      ),
    );
  }
}
