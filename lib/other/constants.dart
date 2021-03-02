// const String BaseUrl = "http://10.0.2.2:5001/api/";
const String pcIp = "http://41.190.32.215:4002";
const String BaseUrl = pcIp + "/api/";
//const String BaseUrl = "http://41.190.32.215:5001/api/";
const String serverUrl ="41.190.32.215:8081";

String policySearchUrl =
    "http://$serverUrl/CustomerRegistration/getAutoCustomers";

String policyDetailUrl =
    "http://$serverUrl/CustomerRegistration/GetCustomername";

//urls to be used in various sections
const String urlLogin = BaseUrl + "auth/login";
const String urlGetUserUrl = BaseUrl + "auth/drivers/";
const String urlGetMyDeliveries = BaseUrl + "deliveries/mydeliveries";
const String urlMyInCompletedDeliveries = BaseUrl + "deliveries/myincomplete";
const String urlMyCompletedDeliveries = BaseUrl + "deliveries/mycomplete";
const String urlStartDelivery = BaseUrl + "deliveries/start/";
const String urlStopDelivery = BaseUrl + "deliveries/stop/";
const String urlDeliveryConfirmation = BaseUrl + "DeliveryConfirmations/";
const String urlPostComments = BaseUrl + "DeliveryComments/";
const String urlGetComments = BaseUrl + "DeliveryComments/GetDeliveryComments/";

//shared prefs keys
const String spkUserId = "userID";
const String spkToken = "token";
const String spkAccountType = "accountType";
const String spkUserId2 = "id";
const String spkFirstName = "firstName";
const String spkSecondName = "lastName";
const String spkActive = "active";
const String spkPhone = "phoneNumber";
const String spkHasZone = "hasZone";

//settings
const String spkShouldShowCompleted = "should_show_completed_deliveries";
const String spkShouldAutoLogin = "should_auto_login";
