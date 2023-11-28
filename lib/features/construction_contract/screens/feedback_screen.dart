import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile_solar_mp/common/handle_exception/bad_request_exception.dart';
import 'package:mobile_solar_mp/common/widgets/custom_textfield.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:mobile_solar_mp/constants/utils.dart';
import 'package:mobile_solar_mp/features/history_construction_contract/service/history_construction_contract_service.dart';
import 'package:mobile_solar_mp/models/construction_contract.dart';

class FeedbackScreen extends StatefulWidget {
  static const String routeName = RoutePath.feedbackRoute;
  final ConstructionContract? constructionContract;

  const FeedbackScreen({
    super.key,
    this.constructionContract,
  });

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late bool _isLoading = false;
  late double _rating = 0;
  final TextEditingController _feedbackDescriptionController =
      TextEditingController();

  void _createFeedback({
    required String contructionContractId,
    required String packageId,
  }) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await HistoryConstructionContractService().createFeedback(
        context: context,
        rating: _rating,
        feedbackDescription: _feedbackDescriptionController.text,
        contructionContractId: contructionContractId,
        packageId: packageId,
      );
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        showSnackBar(
          context,
          'Đánh giá thành công',
        );
        Navigator.pop(context);
      }
    } on CustomException catch (e) {
      if (mounted) {
        showSnackBar(
          context,
          e.cause,
          color: Colors.red,
        );
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(
          context,
          e.toString(),
          color: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ConstructionContract constructionContract = widget.constructionContract!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá gói trong hợp đồng'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    RatingBar.builder(
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                    ),
                    const SizedBox(height: 20.0),
                    _buildMessageRating(_rating),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Mức độ hài lòng của quý khách.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20.0),
                    CustomTextField(
                      controller: _feedbackDescriptionController,
                      hintText: 'Bạn có điều gì muốn chia sẻ?',
                      maxLines: 3,
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: ElevatedButton(
              onPressed: _rating != 0
                  ? () {
                      _createFeedback(
                        contructionContractId:
                            constructionContract.constructioncontractId!,
                        packageId: constructionContract.packageId!,
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Gửi',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMessageRating(double rating) {
    switch (rating) {
      case 1:
        return const Text('Rất tệ');
      case 2:
        return const Text('Tệ');
      case 3:
        return const Text('Tạm được');
      case 4:
        return const Text('Tốt');
      case 5:
        return const Text('Tuyệt vời');
      default:
        return const Text('');
    }
  }
}
