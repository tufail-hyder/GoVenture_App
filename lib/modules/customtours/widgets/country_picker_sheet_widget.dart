import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

const List<String> kCountryList = [
  'Afghanistan', 'Akrotiri', 'Albania', 'Algeria', 'American Samoa', 'Andorra', 'Angola',
  'Anguilla', 'Antarctica', 'Antigua and Barbuda', 'Argentina', 'Armenia', 'Aruba',
  'Ashmore and Cartier Islands', 'Australia', 'Austria', 'Azerbaijan', 'Bahamas, The',
  'Bahrain', 'Bangladesh', 'Barbados', 'Bassas da India', 'Belarus', 'Belgium', 'Belize',
  'Benin', 'Bermuda', 'Bhutan', 'Bolivia', 'Bosnia and Herzegovina', 'Botswana',
  'Bouvet Island', 'Brazil', 'British Indian Ocean Territory', 'British Virgin Islands',
  'Brunei', 'Bulgaria', 'Burkina Faso', 'Burma', 'Burundi', 'Cambodia', 'Cameroon', 'Canada',
  'Cape Verde', 'Cayman Islands', 'Central African Republic', 'Chad', 'Chile', 'China',
  'Christmas Island', 'Clipperton Island', 'Cocos (Keeling) Islands', 'Colombia', 'Comoros',
  'Congo, Democratic Republic of the', 'Congo, Republic of the', 'Cook Islands',
  'Coral Sea Islands', 'Costa Rica', "Cote d'Ivoire", 'Croatia', 'Cuba', 'Cyprus',
  'Czech Republic', 'Denmark', 'Dhekelia', 'Djibouti', 'Dominica', 'Dominican Republic',
  'Ecuador', 'Egypt', 'El Salvador', 'Equatorial Guinea', 'Eritrea', 'Estonia', 'Ethiopia',
  'Europa Island', 'Falkland Islands (Islas Malvinas)', 'Faroe Islands', 'Fiji', 'Finland',
  'France', 'French Guiana', 'French Polynesia', 'French Southern and Antarctic Lands',
  'Gabon', 'Gambia, The', 'Gaza Strip', 'Georgia', 'Germany', 'Ghana', 'Gibraltar',
  'Glorioso Islands', 'Greece', 'Greenland', 'Grenada', 'Guadeloupe', 'Guam', 'Guatemala',
  'Guernsey', 'Guinea', 'Guinea-Bissau', 'Guyana', 'Haiti', 'Heard Island and McDonald Islands',
  'Holy See (Vatican City)', 'Honduras', 'Hong Kong', 'Hungary', 'Iceland', 'India',
  'Indonesia', 'Iran', 'Iraq', 'Ireland', 'Isle of Man', 'Israel', 'Italy', 'Jamaica',
  'Jan Mayen', 'Japan', 'Jersey', 'Jordan', 'Juan de Nova Island', 'Kazakhstan', 'Kenya',
  'Kiribati', 'Korea, North', 'Korea, South', 'Kuwait', 'Kyrgyzstan', 'Laos', 'Latvia',
  'Lebanon', 'Lesotho', 'Liberia', 'Libya', 'Liechtenstein', 'Lithuania', 'Luxembourg',
  'Macau', 'Macedonia', 'Madagascar', 'Malawi', 'Malaysia', 'Maldives', 'Mali', 'Malta',
  'Marshall Islands', 'Martinique', 'Mauritania', 'Mauritius', 'Mayotte', 'Mexico',
  'Micronesia, Federated States of', 'Moldova', 'Monaco', 'Mongolia', 'Montenegro',
  'Montserrat', 'Morocco', 'Mozambique', 'Namibia', 'Nauru', 'Navassa Island', 'Nepal',
  'Netherlands', 'Netherlands Antilles', 'New Caledonia', 'New Zealand', 'Nicaragua',
  'Niger', 'Nigeria', 'Niue', 'Norfolk Island', 'Northern Mariana Islands', 'Norway', 'Oman',
  'Pakistan', 'Palau', 'Panama', 'Papua New Guinea', 'Paracel Islands', 'Paraguay', 'Peru',
  'Philippines', 'Pitcairn Islands', 'Poland', 'Portugal', 'Puerto Rico', 'Qatar', 'Reunion',
  'Romania', 'Russia', 'Rwanda', 'Saint Helena', 'Saint Kitts and Nevis', 'Saint Lucia',
  'Saint Pierre and Miquelon', 'Saint Vincent and the Grenadines', 'Samoa', 'San Marino',
  'Sao Tome and Principe', 'Saudi Arabia', 'Senegal', 'Serbia', 'Seychelles', 'Sierra Leone',
  'Singapore', 'Slovakia', 'Slovenia', 'Solomon Islands', 'Somalia', 'South Africa',
  'South Georgia and the South Sandwich Islands', 'Spain', 'Spratly Islands', 'Sri Lanka',
  'Sudan', 'Suriname', 'Svalbard', 'Swaziland', 'Sweden', 'Switzerland', 'Syria', 'Taiwan',
  'Tajikistan', 'Tanzania', 'Thailand', 'Timor-Leste', 'Togo', 'Tokelau', 'Tonga',
  'Trinidad and Tobago', 'Tromelin Island', 'Tunisia', 'Turkey', 'Turkmenistan',
  'Turks and Caicos Islands', 'Tuvalu', 'Uganda', 'Ukraine', 'United Arab Emirates',
  'United Kingdom', 'United States', 'Uruguay', 'Uzbekistan', 'Vanuatu', 'Venezuela',
  'Vietnam', 'Virgin Islands', 'Wake Island', 'Wallis and Futuna', 'West Bank',
  'Western Sahara', 'Yemen', 'Zambia', 'Zimbabwe',
];

/// Same brightness-aware color resolution used by the customize-tour screen,
/// kept local to this file since it's a standalone reusable widget.
class _PickerPalette {
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color divider;
  final Color primary;
  final Color primarySoft;

  const _PickerPalette({
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.divider,
    required this.primary,
    required this.primarySoft,
  });

  factory _PickerPalette.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return _PickerPalette(
        background: const Color(0xFF1A1D21),
        surface: const Color(0xFF23272D),
        textPrimary: Colors.white,
        textSecondary: const Color(0xFFA3A8B0),
        divider: const Color(0xFF2C3036),
        primary: AppColors.primary,
        primarySoft: AppColors.primary.withValues(alpha: 0.2),
      );
    }
    return _PickerPalette(
      background: AppColors.surfaceLight,
      surface: AppColors.backgroundLight,
      textPrimary: AppColors.textPrimaryLight,
      textSecondary: AppColors.textSecondaryLight,
      divider: AppColors.dividerLight,
      primary: AppColors.primary,
      primarySoft: AppColors.primaryLight,
    );
  }
}

/// Opens a searchable bottom sheet and returns the selected country name,
/// or null if the user dismisses it without picking one.
Future<String?> showCountryPicker(BuildContext context, {String? selected}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _CountryPickerSheet(selected: selected),
  );
}

class _CountryPickerSheet extends StatefulWidget {
  const _CountryPickerSheet({this.selected});
  final String? selected;

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  late List<String> _filtered;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = kCountryList;
  }

  void _onSearch(String query) {
    setState(() {
      _filtered = kCountryList
          .where((c) => c.toLowerCase().contains(query.trim().toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = _PickerPalette.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: p.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSizes.sm),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: p.divider, borderRadius: BorderRadius.circular(4)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.md, AppSizes.md, AppSizes.sm),
                child: Row(
                  children: [
                    Text(
                      'Select Nationality',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: p.textPrimary),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close_rounded, size: 20, color: p.textSecondary),
                      splashRadius: 18,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: _onSearch,
                  autofocus: false,
                  style: TextStyle(fontSize: 14, color: p.textPrimary),
                  cursorColor: p.primary,
                  decoration: InputDecoration(
                    hintText: 'Search country',
                    hintStyle: TextStyle(fontSize: 13.5, color: p.textSecondary),
                    prefixIcon: Icon(Icons.search_rounded, size: 20, color: p.textSecondary),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                      icon: Icon(Icons.clear_rounded, size: 18, color: p.textSecondary),
                      onPressed: () {
                        _searchCtrl.clear();
                        _onSearch('');
                      },
                    )
                        : null,
                    filled: true,
                    fillColor: p.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      borderSide: BorderSide(color: p.primary, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              Expanded(
                child: _filtered.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.public_off_rounded, size: 36, color: p.textSecondary),
                      const SizedBox(height: 8),
                      Text('No country found', style: TextStyle(fontSize: 13.5, color: p.textSecondary)),
                    ],
                  ),
                )
                    : ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: p.divider),
                  itemBuilder: (context, index) {
                    final country = _filtered[index];
                    final isSelected = country == widget.selected;
                    return ListTile(
                      onTap: () => Navigator.of(context).pop(country),
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: isSelected ? p.primary : p.primarySoft,
                        child: Text(
                          country.isNotEmpty ? country[0] : '?',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : p.primary,
                          ),
                        ),
                      ),
                      title: Text(
                        country,
                        style: TextStyle(
                          fontSize: 14,
                          color: p.textPrimary,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      trailing: isSelected ? Icon(Icons.check_circle_rounded, size: 20, color: p.primary) : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}