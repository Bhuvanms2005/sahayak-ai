import '../../models/scheme_model.dart';

class AppConstants {
  static const appName = 'Sahayak AI';
  static const appTagline = 'AI-powered Government Scheme Navigator';
  static const geminiApiKey = 'PASTE_YOUR_GEMINI_API_KEY_HERE';
  static const geminiModel = 'gemini-1.5-flash';

  static const usersCollection = 'users';
  static const schemesCollection = 'schemes';
  static const savedSchemesCollection = 'saved_schemes';

  static const categories = [
    'All',
    'Education',
    'Health',
    'Agriculture',
    'Women',
    'Startup',
    'Housing',
    'Employment',
    'Senior Citizens',
  ];

  static const systemPrompt = '''
You are Sahayak AI, a helpful assistant for Indian government schemes.
Give practical, simple, citizen-friendly guidance. Ask for missing profile
details when eligibility is unclear. Never invent official rules; clearly say
when the user should verify details on the official portal.
''';

  static const demoSchemes = <SchemeModel>[
    SchemeModel(
      id: 'pm-kisan',
      name: 'PM-KISAN Samman Nidhi',
      description: 'Income support for eligible farmer families across India.',
      category: 'Agriculture',
      benefits: 'Rs 6,000 per year in three equal installments directly to the bank account.',
      eligibility: 'Small and marginal farmer families with cultivable land, subject to exclusions.',
      documents: ['Aadhaar card', 'Land records', 'Bank passbook', 'Mobile number'],
      targetGroups: ['Farmers', 'Rural families'],
      ministry: 'Ministry of Agriculture and Farmers Welfare',
      applicationMode: 'Online or CSC',
      deadline: 'Open all year',
      popularity: 96,
    ),
    SchemeModel(
      id: 'ayushman-bharat',
      name: 'Ayushman Bharat PM-JAY',
      description: 'Health insurance coverage for vulnerable families.',
      category: 'Health',
      benefits: 'Cashless health cover up to Rs 5 lakh per family per year at empanelled hospitals.',
      eligibility: 'Families identified through deprivation and occupational criteria in SECC data.',
      documents: ['Aadhaar card', 'Ration card', 'PM-JAY card if available'],
      targetGroups: ['Low-income families', 'Patients'],
      ministry: 'National Health Authority',
      applicationMode: 'Hospital helpdesk or online verification',
      deadline: 'Open all year',
      popularity: 94,
    ),
    SchemeModel(
      id: 'sukanya-samriddhi',
      name: 'Sukanya Samriddhi Yojana',
      description: 'Long-term savings scheme for the education and future of girl children.',
      category: 'Women',
      benefits: 'High-interest small savings account with tax benefits for a girl child.',
      eligibility: 'Girl child below 10 years; account opened by parent or guardian.',
      documents: ['Birth certificate', 'Guardian ID proof', 'Address proof'],
      targetGroups: ['Girl child', 'Parents'],
      ministry: 'Ministry of Finance',
      applicationMode: 'Post office or authorised bank',
      deadline: 'Before child turns 10',
      popularity: 88,
    ),
    SchemeModel(
      id: 'pmay-urban',
      name: 'Pradhan Mantri Awas Yojana',
      description: 'Affordable housing support for eligible urban and rural households.',
      category: 'Housing',
      benefits: 'Interest subsidy and housing assistance depending on category and location.',
      eligibility: 'Households without a pucca house, meeting income and ownership rules.',
      documents: ['Aadhaar card', 'Income certificate', 'Address proof', 'Bank details'],
      targetGroups: ['Low-income households', 'Urban poor', 'Rural families'],
      ministry: 'Ministry of Housing and Urban Affairs',
      applicationMode: 'Online portal or local body',
      deadline: 'As per state notification',
      popularity: 91,
    ),
    SchemeModel(
      id: 'mudra',
      name: 'Pradhan Mantri Mudra Yojana',
      description: 'Collateral-free loans for micro and small business owners.',
      category: 'Startup',
      benefits: 'Loans up to Rs 10 lakh under Shishu, Kishor, and Tarun categories.',
      eligibility: 'Non-corporate, non-farm micro enterprises and small entrepreneurs.',
      documents: ['Business plan', 'Identity proof', 'Address proof', 'Bank statements'],
      targetGroups: ['Entrepreneurs', 'Small businesses', 'Self-employed'],
      ministry: 'Ministry of Finance',
      applicationMode: 'Bank, NBFC, MFI, or online',
      deadline: 'Open all year',
      popularity: 89,
    ),
    SchemeModel(
      id: 'nsp-scholarship',
      name: 'National Scholarship Portal Schemes',
      description: 'Central and state scholarships for students across categories.',
      category: 'Education',
      benefits: 'Tuition support, maintenance allowance, and direct benefit transfer.',
      eligibility: 'Students meeting income, merit, category, and course rules for each scholarship.',
      documents: ['Aadhaar card', 'Income certificate', 'Marksheets', 'Bank details'],
      targetGroups: ['Students', 'Minority students', 'SC/ST/OBC students'],
      ministry: 'Ministry of Education',
      applicationMode: 'Online',
      deadline: 'Varies by scholarship',
      popularity: 87,
    ),
  ];
}
