import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/validation/app_validations.dart';
import '../../../../core/values/app_strings.dart';
import '../screens/login_with_google.dart';

class LoginWidget extends StatelessWidget {
   LoginWidget({super.key});
  final formKey = GlobalKey<FormState>();
   final emailController = TextEditingController();
   final passwordController = TextEditingController();



   @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBlack.withValues(alpha: .40),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(50),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 20,
          children: [
            Text(AppStrings.login,
            style: TextStyles.bodyRegular24,
              textAlign: TextAlign.center,
            ),
            TextFormField(
              controller: emailController,
              validator: (value) =>
                  AppValidations.validateEmail(value ?? ''),
              decoration: InputDecoration(
                hintText: AppStrings.email,
                prefixIcon:Icon(Icons.email) ,
              ),

            ),
            TextFormField(
              controller: passwordController,
              validator: (value) =>
                  AppValidations.validatePassword(value ?? ''),
              decoration: InputDecoration(
                hintText: AppStrings.password,
                prefixIcon:Icon(Icons.lock) ,
                suffixIcon:Icon(Icons.visibility),
            ),),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  AppStrings.forgetPassword,
                  style: TextStyles.bodyRegular12.copyWith(
                    color: AppColors.orange,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.orange,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  child: Divider(
                    color: AppColors.white,
                    thickness: 1.5,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  AppStrings.or,
                  style: TextStyles.bodyRegular16,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Divider(
                    color: AppColors.white,
                    thickness: 1.5,
                  ),
                ),
              ],
            ),
            LoginWithGoogle(),
            ElevatedButton(
                onPressed: (){}, child: Text(AppStrings.login)),
            RichText(
              text: TextSpan(
                text: AppStrings.doNotHaveAnAccountYet,
                style: TextStyles.bodyRegular16,
                children: [
                  TextSpan(
                    text: AppStrings.register,
                    style: TextStyles.bodyRegular16.copyWith(
                      color: AppColors.orange,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.orange,
                    ),
                    // recognizer: TapGestureRecognizer()
                    //   ..onTap = () =>
                    //       Navigator.pushNamed(context, AppRoutsName.registerScreen),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
