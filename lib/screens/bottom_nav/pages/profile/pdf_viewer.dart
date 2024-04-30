// import 'package:flutter/cupertino.dart';
// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
//
// class PrivacyPolicyPdfViewer extends StatefulWidget {
//   const PrivacyPolicyPdfViewer({Key? key}) : super(key: key);
//
//   @override
//   _PrivacyPolicyPdfViewerState createState() => _PrivacyPolicyPdfViewerState();
// }
//
// class _PrivacyPolicyPdfViewerState extends State<PrivacyPolicyPdfViewer> {
//   PDFDocument? document;
//
//   @override
//   void initState() {
//     super.initState();
//     loadDocument();
//     debugPrint(document.toString());
//   }
//
//   loadDocument() async {
//     try {
//       final pdf = await PDFDocument.fromAsset(
//           "Assets/privacy_policy/privacy_policy.pdf");
//       setState(() {
//         document = pdf;
//       });
//     } catch (e) {
//       print("Error loading PDF document: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       navigationBar: const CupertinoNavigationBar(
//         middle: Text('Privacy Policy'),
//       ),
//       child: Center(
//         child: document == null
//             ? CupertinoActivityIndicator()
//             : PDFViewer(
//                 document: document!,
//                 zoomSteps: 1,
//               ),
//       ),
//     );
//   }
// }
