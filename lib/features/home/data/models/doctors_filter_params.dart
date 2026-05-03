class DoctorsFilterParams {
  static const String defaultFields =
      'id,name,avatarUrl,consultationFee,yearsOfExperience,rating,reviewCount,address,department,isFavorited';

  final String? query;
  final int? gender;
  final String? cityId;
  final String? departmentId;
  final String? sort;
  final String? sortByRating;
  final String? sortByReviewCount;
  final String? fields;
  final int pageSize;

  const DoctorsFilterParams({
    this.query,
    this.gender,
    this.cityId,
    this.departmentId,
    this.sort,
    this.sortByRating,
    this.sortByReviewCount,
    this.fields = defaultFields,
    this.pageSize = 10,
  });

  DoctorsFilterParams copyWith({
    String? query,
    int? gender,
    String? cityId,
    String? departmentId,
    String? sort,
    String? sortByRating,
    String? sortByReviewCount,
    String? fields,
    int? pageSize,
    bool clearQuery = false,
    bool clearGender = false,
    bool clearCity = false,
    bool clearDepartment = false,
    bool clearSort = false,
    bool clearSortByRating = false,
    bool clearSortByReviewCount = false,
    bool clearFields = false,
  }) {
    return DoctorsFilterParams(
      query: clearQuery ? null : query ?? this.query,
      gender: clearGender ? null : gender ?? this.gender,
      cityId: clearCity ? null : cityId ?? this.cityId,
      departmentId: clearDepartment ? null : departmentId ?? this.departmentId,
      sort: clearSort ? null : sort ?? this.sort,
      sortByRating: clearSortByRating ? null : sortByRating ?? this.sortByRating,
      sortByReviewCount: clearSortByReviewCount ? null : sortByReviewCount ?? this.sortByReviewCount,
      fields: clearFields ? null : fields ?? this.fields,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  Map<String, dynamic> toQueryParameters({required int page}) {
    final params = <String, dynamic>{
      'Page': page,
      'PageSize': pageSize,
    };

    void addIfPresent(String key, dynamic value) {
      if (value == null) return;
      if (value is String && value.trim().isEmpty) return;
      params[key] = value is String ? value.trim() : value;
    }

    addIfPresent('q', query);
    addIfPresent('Gender', gender);
    addIfPresent('CityId', cityId);
    addIfPresent('DepartmentId', departmentId);
    addIfPresent('Sort', sort);
    if (sortByRating?.toLowerCase() == 'asc' || sortByRating?.toLowerCase() == 'desc') {
      addIfPresent('SortByRating', sortByRating);
    }
    if (sortByReviewCount?.toLowerCase() == 'asc' || sortByReviewCount?.toLowerCase() == 'desc') {
      addIfPresent('SortByReviewCount', sortByReviewCount);
    }
    addIfPresent('Fields', fields);

    return params;
  }

  bool get hasActiveFilters =>
      gender != null ||
      cityId != null ||
      departmentId != null ||
      (sort != null && sort!.trim().isNotEmpty) ||
      (sortByRating != null && sortByRating!.trim().isNotEmpty && (sortByRating!.toLowerCase() == 'asc' || sortByRating!.toLowerCase() == 'desc')) ||
      (sortByReviewCount != null && sortByReviewCount!.trim().isNotEmpty && (sortByReviewCount!.toLowerCase() == 'asc' || sortByReviewCount!.toLowerCase() == 'desc')) ||
      pageSize != 10;      
}
