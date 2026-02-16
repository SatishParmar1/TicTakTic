class ApiEndPoints {
  final String USER_LOGIN = "api/login";
  final String ADD_TYRE_MODEL = "api/add-tyre-model";
  final String MARKETPLACE_TYRE_LISTING_2_NOLOGIN =
      "/new-rtd-tyre-buyer/listing-tyre-available-to-buy2";
  final String MARKETPLACE_TYRE_LISTING_LOGIN =
      "/new-rtd-tyre-buyer/listing-tyre-available-to-buy";
  final String MARKETPLACE_LISTING_FILTERS =
      "/new-rtd-tyre-buyer/marketplace-listing-filters";
  final String MARKETPLACE_CATEGORY_FILTERS =
      "/new-rtd-tyre-buyer/marketplace-listing-filters";
  final String GET_TYRE_SIZES = "/get-tyre-sizes";
  final String UPLOAD_SELL_IMAGE = "/upload/sell-image";
  final String UPLOAD_SELL_VIDEO = "/upload/sell-video";
  final String CREATE_SELL_REQUEST = "/sell/create-sell-request";
  final String fetchMyAllListings = '/tyredealer/fetch-my-all-listings';
  final String BUY_PRODUCT_DETAILS =
      "/new-rtd-tyre-buyer/particular-listing-details";
  final String LISTING_DETAILS =
      "/new-rtd-tyre-buyer/particular-listing-details";
  final String NEGOTIATION_SESSION_DETAILS = "/tyredealer/listing/negotiations";
  final String SUBMIT_NEGOTIATION_FirstTime =
      "/new-rtd-tyre-buyer/create-listing-buy-request";
  final String SUBMIT_NEGOTIATION_AFTER_FIRST_TIME =
      "/new-rtd-tyre-buyer/send-listing-negotiation-message";
  final String NEGOTIATION_MESSAGES =
      "/new-rtd-tyre-buyer/negotiation/session_id/messages";
  final String APP_MEDIA_CONTENT_DETAILS = "/banners";

  final String MASTER_DATA_SIZES = "/get-tyre-sizes";
  final String MASTER_DATA_BRANDS = "/master-data/brands";
  final String MASTER_DATA_MODELS = "/master-data/models";
  final String RTD_BELT_BRAND_LIST = "/tyredealer/rtd-belt-brand-list";
  final String CREATE_LISTING = "/tyredealer/create-listing";

  final String ACCEPT_NEGOTIATION =
      "/new-rtd-tyre-buyer/accept-listing-negotiation";
  final String REJECT_NEGOTIATION =
      "/new-rtd-tyre-buyer/reject-listing-negotiation";
  final String EDIT_NEGOTIATION_MESSAGE =
      "/new-rtd-tyre-buyer/edit-listing-negotiation-message";
  final String MY_ONGOING_LISTING_REQUESTS =
      "/tyredealer/my-ongoing-listing-requests";
  final String GET_ALL_ADDRESSES = "/address/get-all-addresses";
  final String CREATE_LISTING_ENQUIRY = "/enquiry/create-listing-enquiry";
  final String GET_LISTING_ENQUIRIES = "/enquiry/get-listing-enquiries";
  final String TOGGLE_SHORTLIST = "/shortlist/toggle-shortlist";
  final String MY_SHORTLISTED_ITEMS = "/shortlist/my-shortlisted-items";
  final String GET_MARKETPLACE_CITIES = "/tyredealer/get-marketplace-cities";

  final String NOTIFICATION_HISTORY = "/notifications/user";
  final String NOTIFICATION_FILTER = "/notifications/types";
}
