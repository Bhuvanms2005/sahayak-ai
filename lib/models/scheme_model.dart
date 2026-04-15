class SchemeModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String ministry;
  final String? imageUrl;
  final List<String> eligibilityCriteria;
  final List<String> benefits;
  final List<String> requiredDocuments;
  final List<String> applicationSteps;
  final String? officialLink;
  final String? applicationLink;
  final DateTime? deadline;
  final bool isActive;
  final List<String> targetGroups;
  final String? maxBenefitAmount;
  final List<String> applicableStates; // empty = all India
  final DateTime createdAt;
  final int? viewCount;
  final double? rating;

  SchemeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.ministry,
    this.imageUrl,
    required this.eligibilityCriteria,
    required this.benefits,
    required this.requiredDocuments,
    required this.applicationSteps,
    this.officialLink,
    this.applicationLink,
    this.deadline,
    this.isActive = true,
    required this.targetGroups,
    this.maxBenefitAmount,
    this.applicableStates = const [],
    required this.createdAt,
    this.viewCount,
    this.rating,
  });

  factory SchemeModel.fromMap(Map<String, dynamic> map, String docId) {
    return SchemeModel(
      id: docId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      ministry: map['ministry'] ?? '',
      imageUrl: map['imageUrl'],
      eligibilityCriteria: List<String>.from(map['eligibilityCriteria'] ?? []),
      benefits: List<String>.from(map['benefits'] ?? []),
      requiredDocuments: List<String>.from(map['requiredDocuments'] ?? []),
      applicationSteps: List<String>.from(map['applicationSteps'] ?? []),
      officialLink: map['officialLink'],
      applicationLink: map['applicationLink'],
      deadline: map['deadline'] != null
          ? (map['deadline'] as dynamic).toDate()
          : null,
      isActive: map['isActive'] ?? true,
      targetGroups: List<String>.from(map['targetGroups'] ?? []),
      maxBenefitAmount: map['maxBenefitAmount'],
      applicableStates: List<String>.from(map['applicableStates'] ?? []),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
      viewCount: map['viewCount'],
      rating: map['rating']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'ministry': ministry,
      'imageUrl': imageUrl,
      'eligibilityCriteria': eligibilityCriteria,
      'benefits': benefits,
      'requiredDocuments': requiredDocuments,
      'applicationSteps': applicationSteps,
      'officialLink': officialLink,
      'applicationLink': applicationLink,
      'deadline': deadline,
      'isActive': isActive,
      'targetGroups': targetGroups,
      'maxBenefitAmount': maxBenefitAmount,
      'applicableStates': applicableStates,
      'createdAt': createdAt,
      'viewCount': viewCount ?? 0,
      'rating': rating,
    };
  }

  bool get isNationwide => applicableStates.isEmpty;

  bool get hasDeadline => deadline != null;

  bool get isDeadlinePassed =>
      deadline != null && deadline!.isBefore(DateTime.now());

  String get eligibilityShort => eligibilityCriteria.take(2).join(', ');
}

// --- Sample Scheme Data ---
class SampleSchemes {
  static List<Map<String, dynamic>> get data => [
    {
      'name': 'PM Scholarship Scheme',
      'description':
          'Scholarship for children of ex-servicemen and ex-coast guard personnel to pursue professional degree courses.',
      'category': 'Education',
      'ministry': 'Ministry of Defence',
      'eligibilityCriteria': [
        'Children of ex-servicemen or ex-coast guard',
        'Minimum 60% marks in Class 12',
        'Age between 18-25 years',
        'Enrolled in first year of professional degree',
      ],
      'benefits': [
        '₹2,500/month for boys',
        '₹3,000/month for girls',
        'Duration: Course period (max 5 years)',
      ],
      'requiredDocuments': [
        'Discharge certificate of parent',
        'Mark sheet of Class 12',
        'Bonafide certificate',
        'Bank account details',
        'Aadhaar card',
      ],
      'applicationSteps': [
        'Visit ksb.gov.in',
        'Register with your details',
        'Fill the scholarship form',
        'Upload required documents',
        'Submit and note application number',
      ],
      'officialLink': 'https://ksb.gov.in/pm-scholarship.htm',
      'isActive': true,
      'targetGroups': ['Students'],
      'maxBenefitAmount': '₹36,000/year',
      'applicableStates': [],
    },
    {
      'name': 'Pradhan Mantri Awas Yojana (PMAY)',
      'description':
          'Housing for All mission to provide affordable housing to urban and rural poor by 2022.',
      'category': 'Housing',
      'ministry': 'Ministry of Housing and Urban Affairs',
      'eligibilityCriteria': [
        'Annual household income below ₹18 lakh',
        'Should not own a pucca house anywhere in India',
        'First-time home buyer',
        'EWS/LIG/MIG categories eligible',
      ],
      'benefits': [
        'Interest subsidy up to 6.5% on home loans',
        'Subsidy up to ₹2.67 lakh',
        'For EWS/LIG: ₹1.5 lakh grant (rural)',
      ],
      'requiredDocuments': [
        'Aadhaar card',
        'Income certificate',
        'Caste certificate (if applicable)',
        'Bank statement',
        'Property documents',
      ],
      'applicationSteps': [
        'Visit pmaymis.gov.in',
        'Select your category (EWS/LIG/MIG)',
        'Fill application form with personal and income details',
        'Upload documents',
        'Submit application and save acknowledgement',
        'Track status on portal',
      ],
      'officialLink': 'https://pmaymis.gov.in',
      'isActive': true,
      'targetGroups': ['All Citizens', 'BPL Families'],
      'maxBenefitAmount': '₹2,67,280',
      'applicableStates': [],
    },
    {
      'name': 'Ayushman Bharat PM-JAY',
      'description':
          'World\'s largest health insurance scheme providing ₹5 lakh coverage per family per year for secondary and tertiary hospitalization.',
      'category': 'Health',
      'ministry': 'Ministry of Health & Family Welfare',
      'eligibilityCriteria': [
        'Listed in SECC 2011 database or RSBY',
        'Annual income below poverty line',
        'No age or family size restriction',
        'Rural/urban deprivation criteria',
      ],
      'benefits': [
        '₹5 lakh health cover per family per year',
        '25,000+ empanelled hospitals',
        'Pre and post-hospitalization expenses',
        'No premium payment by beneficiary',
      ],
      'requiredDocuments': [
        'Aadhaar card or government ID',
        'Ration card',
        'SECC/RSBY proof',
      ],
      'applicationSteps': [
        'Check eligibility at pmjay.gov.in',
        'Visit nearest CSC or empanelled hospital',
        'Verify identity with Aadhaar',
        'Get Ayushman card issued',
        'Use card at empanelled hospitals',
      ],
      'officialLink': 'https://pmjay.gov.in',
      'isActive': true,
      'targetGroups': ['BPL Families', 'Rural Poor', 'Urban Poor'],
      'maxBenefitAmount': '₹5,00,000/year',
      'applicableStates': [],
    },
    {
      'name': 'PM Kisan Samman Nidhi',
      'description':
          'Direct income support of ₹6,000 per year to all farmer families across India.',
      'category': 'Agriculture',
      'ministry': 'Ministry of Agriculture & Farmers Welfare',
      'eligibilityCriteria': [
        'Small and marginal farmers',
        'Cultivable land holding in name',
        'Valid Aadhaar card',
        'Active bank account',
      ],
      'benefits': [
        '₹6,000 per year in 3 equal installments',
        '₹2,000 every 4 months directly to bank account',
        'No middlemen — direct DBT transfer',
      ],
      'requiredDocuments': [
        'Aadhaar card',
        'Land ownership documents',
        'Bank account details',
        'Mobile number',
      ],
      'applicationSteps': [
        'Visit pmkisan.gov.in',
        'Click "New Farmer Registration"',
        'Enter Aadhaar and mobile number',
        'Fill land and bank details',
        'Submit and verify via OTP',
        'Track status online',
      ],
      'officialLink': 'https://pmkisan.gov.in',
      'isActive': true,
      'targetGroups': ['Farmers'],
      'maxBenefitAmount': '₹6,000/year',
      'applicableStates': [],
    },
    {
      'name': 'Startup India Scheme',
      'description':
          'Government initiative to build a strong startup ecosystem and transform India into a country of job creators.',
      'category': 'Startup',
      'ministry': 'Department for Promotion of Industry and Internal Trade (DPIIT)',
      'eligibilityCriteria': [
        'Incorporated as Private Ltd, LLP, or Partnership',
        'Age of entity less than 10 years',
        'Annual turnover not exceeding ₹100 crore',
        'Working on innovation/improvement of product/service',
      ],
      'benefits': [
        'Tax exemption for 3 consecutive years',
        '80% rebate on patent filing fees',
        'Fast-track patent examination',
        'Self-certification for 9 labour and environmental laws',
        'Access to ₹10,000 crore Fund of Funds',
      ],
      'requiredDocuments': [
        'Certificate of Incorporation',
        'Company PAN card',
        'Pitch deck or business description',
        'Proof of innovation',
        'Director/partner Aadhaar and PAN',
      ],
      'applicationSteps': [
        'Visit startupindia.gov.in',
        'Register on the portal',
        'Apply for DPIIT recognition',
        'Fill details about your startup',
        'Upload required documents',
        'Get recognition certificate',
      ],
      'officialLink': 'https://startupindia.gov.in',
      'isActive': true,
      'targetGroups': ['Entrepreneurs', 'Job Seekers'],
      'maxBenefitAmount': 'Varies',
      'applicableStates': [],
    },
  ];
}