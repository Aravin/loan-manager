import 'package:flutter/material.dart';
import 'package:loan_manager/constants.dart';
import 'package:loan_manager/widgets/drawer.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Terms & Privacy'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
      ),
      body: Padding(
        padding: appPaddingM,
        child: Card(
          child: ListView(
            children: [
              Container(
                child: Text('Privacy Policy'),
              ),
              Container(
                child: Text(
                    'This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.'),
              ),
              Container(
                child: Text(
                    'If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.'),
              ),
              Container(
                child: Text(
                    'The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at Loan EMI Calculator unless otherwise defined in this Privacy Policy.'),
              ),
              Container(
                child: Text('i) Information Collection and Use'),
              ),
              Container(
                child: Text(
                    'For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information. The information that we request will be retained by us and used as described in this privacy policy.'),
              ),
              Container(
                child: Text(
                    'The app does use third party services that may collect information used to identify you.'),
              ),
              Container(
                child: Text('ii) Log Data'),
              ),
              Container(
                child: Text(
                    'We want to inform you that whenever you use our Service, in a case of an error in the app we collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.'),
              ),
              Container(
                child: Text('iii) Cookies'),
              ),
              Container(
                child: Text(
                    'Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device\'s internal memory.'),
              ),
              Container(
                child: Text(
                    'This Service does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.'),
              ),
              Container(
                child: Text('iv) Service Providers'),
              ),
              Container(
                child: Text(
                    'We may employ third-party companies and individuals due to the following reasons: To facilitate our Service; To provide the Service on our behalf; To perform Service-related services; or To assist us in analyzing how our Service is used. We want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.'),
              ),
              Container(
                child: Text(''),
              ),
              Container(
                child: Text(''),
              ),
              Container(
                child: Text(''),
              ),
              Container(
                child: Text(''),
              ),
              Container(
                child: Text(''),
              ),
              Container(
                child: Text(''),
              ),
              Container(
                child: Text(''),
              ),
              Container(
                child: Text(''),
              ),
              Container(
                child: Text(''),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: themeWhite,
    );
  }
}
