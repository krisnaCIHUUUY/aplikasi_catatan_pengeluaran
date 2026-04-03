import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker_app/utils/colors.dart';

class DateHeader extends StatelessWidget {
  final TextTheme textTheme;
  final double? totalAmount;
  final DateTime date;
  const DateHeader({
    super.key,
    required this.textTheme,
    this.totalAmount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final displayAmount = totalAmount ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Hari ini, ${DateFormat('dd MMMM yyyy', 'id_ID').format(date)}",
            style: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            "-${currencyFormat.format(displayAmount)}",
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}




// errornya
// bisakan anda cek mode date header ini, karena error:

// The getter 'isNegative' was called on null.

// Receiver: null

// Tried calling: isNegative

// The relevant error-causing widget was:

//     DateHeader DateHeader:file:///D:/FLUTTER%20PROJECT/aplikasi_catatan_pengeluaran/expense_tracker_app/lib/screens/home_screen.dart:157:23



// berikut adalah kode  Date Headernya:



// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:expense_tracker_app/utils/colors.dart';

// class DateHeader extends StatelessWidget {
//   final TextTheme textTheme;
//   final double? totalAmount;
//   const DateHeader({super.key, required this.textTheme, this.totalAmount});

//   @override
//   Widget build(BuildContext context) {
//     final currencyFormat = NumberFormat.currency(
//       locale: 'id_ID',
//       symbol: 'Rp ',
//       decimalDigits: 0,
//     );
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             "Hari ini, ${DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now())}",
//             style: textTheme.labelLarge?.copyWith(
//               fontWeight: FontWeight.w600,
//               color: AppColors.textPrimary,
//             ),
//           ),
//           Text(
//             "-${currencyFormat.format(totalAmount)}",
//             style: textTheme.bodyMedium?.copyWith(
//               color: AppColors.error,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


