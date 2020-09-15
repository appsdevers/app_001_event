// BUILD 12 APPS. MEGA_APPS
// SHOP+CINEMA+DOCTOR+

// EXTRA APP_DEVELOPING ORDER
// STATE_MANAGEMENT  =>  USER_INPUT  =>  HTTP_REQUEST  =>  AUTHENTICATION  =>  ANIMATION

// 1 {STATE MANAGEMENT}

// 1.[start_app_explain]
//   [start] => productOverview => add_Dummy_Product => [dive_state_management]
//   [define_Model] => 4[structure] =>
//   .bool isFavorite [be changeable after the product has been created]
//   .id, title, description, price, imageUrl, isFavorite = false;
//
//  2.[Working_on Products_Grid/List & item_Widgets_explain]
//   [passing data to widgets will be always normal even if we use stateMngt system]
//    .wanna re-usable widget which you configure passing args throught them
//    ./take care of un-neccessaire args throught widget
//    .ProductItem => passing id, title, image ./Clip. GridTile()
//
//  3.[Styling&Theming_explain]
//    .primaryColor: purple, accentColor: deepOrange, fonts: Lato, Anton
//
//  4.[Adding_Navigation_explain]
//     ./going_new_screen   ProductItem  => ProductDetailScreen
//      1.push_on_the_fly: MaterialPageRoute.. downside: [1] when app become bigger
//        got many routes on the fly become difficult to understand routes
//        [2] pass data as args we don't need in a widget but we need in other widget
//        we wanna forward
//      2.named_routes: only forward id to fetch all the data we need in the forwarded widget
//        need CENTRAL_STATE_MANAGEMENT

// 2 => [Start_stateMg_explain]
//    1.[The_Problem] => Big's widget needs Data! manage to the
//    topMost_Widget: [1][Passing data via constructor can be cumbersome &difficult]
//        [2] [unnecessary rebuilds{routes} of entire app or major app]
//                  [MyApp]
//  Needs Data! {   [Products]          [Cart]
//                  [SingleProduct]
//                  [ProductDetail]
//
//    2.[state_&_state_Mangement]
//          Manage  .The UI is a function of your data(state)
//  [Data]                    &=>         [User Interface]
//    </>
//  {State = data which}
//  {affects UI(and which)}
//  {might change overtime}
//    </>
//  [App-wide State]                      [widget (local) State]
//    </>                                       </>
//  [Affects entire app or]                 {Affects only a widget its own}
//  [significant part  of the app]          {does not affect other widgets}
//    </>                                       </>
//  [Authentication (is the user]           {"Should a loading spinner}
//  [authenticated?), loadedProducts]       {should be displayed?" Form Input}
//    </>
//    {show wanna different app}
//    {show login instead of app}
//
//    3.[Provider_Package&Pattern]
//     [1] => can have multiple providers mulitple listeners and don't need to be attached
//        to the root level; can be attached to others Widgets
//     [2] => only build() of the listener widgets runs when data is updated
//
//                                          {All child widgets can now listen to the provider}
//  [State/Data Provider]        </attach>              [My App]            [Cart Provider]
//  ["(Container)"]  <doesn't to be the root Widget>                        [Cart] </attach/listener>
//      </> .of(context)      {child widgets listen}    [Products]
//   [Listener]      =>     <SingleProduct listen>  => [SingleProduct]
//      </>
//  {build() runs (=UI can be updated) }                [ProductDetail]       </listen to cart>
//  {when state changes}
//  {only build() of the listen widgets runs}
//
//    4.[Working_with Providers&Listener_explain]
//    [1] => providers based on a class: BIGGER State Mngt
//      mixin: merge some properties into existing class: inheritance light
//      [why_ChangeNotifier?]:
//      [why_getters (get items)]:  dart objects are referenced type.
//       [1*] when get access to: _items; get access to Objects in memory and can edit
//        it anywhere in the memory when access to the class (Products)
//       [2*] when data change in our class (Products) I want to call a method to tell
//        all listeners that listen to the class (notifyListeners) there is changes
//        we want to make sure we listen only in (Products) class not _items=[];
//        so widgets listening to the class can be rebuild correctly
//     [2] => you need to provide a class to the highest possible point in the interested Widgets
//       ProductsScreen && ProductsDetailScreen: interested in class Products
//       PROVIDE instance Products: in ABOVE WIDGET: [MyApp_Widget]
//       All children listening to the instance will be rebuild not the MaterialApp
//        ProductOverviewScreen => {Listening}ProductsGrid/List => ProductItem
//        only [ProductGrid] will rebuild
//       Provider.of<Products>(context); //want to established direct communication channel
//       the to instance of the Provided class
//      Package goahead to parents Widgets until get providers instance
//
//

// 2 => [Data/Products_Provider_explain]
//   [1]Products => ChangeNotifier(established behind the scene communication with widgets)
//      List<Products> _items = []; _{private property}
//      List<Products> get items {}: we want to make sure we listen only in (Products) class not _items=[];
//                                   so widgets listening to the class can be rebuild correctly
//   [2]Provide_Products => ABOVE INTERESTED WIDGET
//
//   [3][Data/products_List/Grid_explain]
//      ProductOverviewScreen => {Listening}ProductsGrid/List => ProductItem
//        only [ProductGrid] will rebuild
//
//   [4][Data/products_Listening_explain]
//    products objects based on Products class: final productsData = Provider.of<Products>(context);
//    products work with is: final products = productsData.items;
//      want to established direct communication channel the to instance of the Provided class
//      Package goahead to parents Widgets until get providers instance
//
//    [5][Inheritance(extends) vs Mixins(with)]
//     Person extends Mammal {} :it's has 2 types Person & Mammal
//      inheritance: Person get all properties and methods of Mammal
//       and override it methods @override => void breathe(){} //Mammal methods
//       technically: Person & Mammal inherit properties and methods
//       logically: have strong connnection between Person & Mammal
//     mixin Agility{var speed = 10, void SitDown() {print('...');}};;  Person extends Mammal with Agility{}
//      inherite all properties and methods of Agility
//  DIFFERENCE EXTENDS && MIXINS
//    MIXINS_Agility: used to build UTILITIES_METHODS: add to classes, objects, containers....
//    Agility: UTILITY_FUNCTIONNALITY_PROVIDER
//
//    class Person extends Mammal with Agility, Mixins {}
//    extends: add one class to to the same class
//    mixins: add mulitple mixins to to the same class
//
//    [6][Listening in differents places & ways]
//      Find Products by Id: as LOADEDPRODUCTS
//        Access_list_of_Products find firstWhere got productId is prod.id of Providers
//     Product findById(String id) => items.firstWhere((prod) => prod.id == id);
//       Never really update ProductsDetailScreen when something changes
//      Provider.of<Products>(context, listen:false).findById(productId);
//        listen: false when you want to tap globally in data but don't need to update.
//      ProductsGrid;List  listen: true
//
//     [7][Nested Models & Providers_explain]
//        Put IN THE SAME DOCS LIST<PROVIDERS_CLASS> & PROVIDER
//      [1].Provide Single Product listener to ProductItem
//      Send a new Provider ABOVE Single Product and listen to change inside ProductItem
//        ChangeNotifierProvider.value(value: products[i],)
//      We need multiple provider ONE FOR EACH PRODUCT different for Products Provider
//      I already instantiate Product Object in Products Provider class. I don't want to re-Instantiate
//      Provide single Product products[i] of the Products Provider class in Provider Item
//      then don't need to provide args to ProductItem[different pattern]
//      ProductItem()
//      [2].ToggleFavoriteStatus  Provider Pattern
//       class Product with ChangeNotifer{ void toggleFavoriteStatus(){
//       inverted_favoriteStatus:  isFavorite =! isFavorite; notifyListeners();}}
//      ProductGrid =>  ChangeNotifierProvider.value(value: products[i]{value of a single product in Products Class Provider})
//       don't need to forward args cause args will be get dynamically in ProductItem Widget
//      ProductItem: call Single Product Provider product= Provider.of<Product>(context);
//       ProductItem: IconButton(onPressed:(){ call.toggleFavorite status:
//        product.toggleFavoriteStatus(); }) icon: products.isFavorte ? some_Icon : some_other_Icon;
//
//    [8][Alternative Provider syntaxe]
//    ChangeNotifierProvider.value(value: Products(),)
//    ChangeNotifierProvider: clean automatically data even if you use value or not clean data for pushReplacement pages
//
//    [9][Using Consumer instead of Provider]
//    Wrap subPart of your widget who need to listen to changes
//    Listen to Changes: listen only_to: IconButton(favorite)
//    ProductItem: Provider.of(context, listen:false) + Consumer<Provider>
//    Consumer always listen to changes
//    Consumer<Generic_type: Product>(builder: (ctx, instance_of_nearest_product: product, ch[_]) => WidgetTree,
//      label:ch ), child: Text('Never changes!), pass_as_reference_to_WidgetTree_part)
//    Or Spliting your widget: outsource & use Provider(true);
//
//    [10][Local State /App Wide state]
//     .don't Provider in a providing class if only want to
//      change how something is displayed on a widget
//     ProductOverviewScreen will add button & filtering grid:
//      .mean the information product isFavorite or not concern
//      .not only ProductItem but the entireApp or significant
//      .part of that app
//     enum FilterOptions {Favorites, All}
//      .build PopupMenuButton(icon:, onSelected:(FilterOptions selectedValue) {print(selectedValue)}
//      itemBuilder:(ctx) => [PopupMenuItem(child: Txt(), value: FilterOptions.Favorites)
//                            PopupMenuItem(child: Txt(), value: FilterOptions.All)] )
//     Idea. Filter items we are displaying based on the Filter we choose!
//      more efficient is to change Product in the Products class
//      ProductOverviewScreen: onSelected: (... selectedValue) {if(selectedValue == ...Favorites){...} else {...}  }
//
//            APP++WIDE++LOCAL++STATE++
//  outside of the class: enum FilterOptions {Favorites, All}: assigning labels to integers
// PopupMenuButton( icon:, itemBuilder:(ctx, _{don't need it})
//   onSelected: (int selectedValue) {
//  if(selectedValue == FilterOptions.Favorites){
//      //... }
//  else {//}
//    print(selectedValue)},
//   => list_Widgets.add.as.entries[
// PopupMenuItem(child: Text('Only Favorites'), value: 0,),
// PopupMenuItem(child: Text('Show All'), value: 1,),
// ]
//
// APP WIDE FILTER
// now in our Products provider class we do:
// var _showFavoritesOnly = false;
// List<Product> get _items {if(_showFavoritesOnly() {
//  return _items.where((prodItem) => prodItem.isFavorite);   }  )}
// void showFavoritesOnly () {_showFavoritesOnly = true; }
// void showAll () {_showFavoritesOnly = false; }
// if it's favorite call new method in Products Provider
// call objects productContainer.showFavorites(), // productContainer.showAll()
//
//  HAS A FLAW:
// If we have a screen which used productsContainer then filter
// will be apply caused our products getter  [_items Products]
// only return data based only on _showFavoritesOnly__filter
// APPLICATION WIDE FILTER
// OFTEN APPLY FILTER ON ONE SCREEN: MANAGE_PRODUCT & VIEW_PRODUCT
// :filtering on ALL ProductsScreen NOT ON MyProductScreen
//
//  YOU SHOULD MANAGE FILTERING LOGIC AND SIMILAR KIND OF THINGS
// OF COURSE) [IN A WIDGET] TYPICALLY. [NOT GLOBALLY!]
//
// APP LOCAL FILTER:  STATEFULL_WIDGET
// Products Provider _build_new_list_of getter_Favorites: favoriteItems()
// ... return _items.where((prodItem) => prodItem.isFavorite);
// Affects: ProductOverviewScreen & ProductGrid
// var _showOnlyFavorites = false;
// onSelected(... ... ) { setState(){( if(...){_showOnlyFavorites = true;}
// else {_showOnlyFavorites = false;} )} }
// forward => _showOnlyFavorites = false;
//    ProductsGrid(_showFavorites);
//    In ProductsGrid__render..
// products =_showFavs ? productsData.favoriteItems : productsData.items;

// 3.. => [Card_Provider]
//  [1].Add_Item_to__a_Card
//   .How do we wanna manage our Cart => Cart Provider
//      .CartItem: define how a cart should look like
//      .Cart Provider: id, title: of_the_Product, price: [of_Product]
//      .addingItem
//      // map an Item where the Key is the ProductId
//    now add_Item
//    check if we have cartItem entry in the Cart
//    if _items.containsKey(productId): yes: we only need to update the quantity
//    _items.update(productId, (existingCartItem) => CartItem(id: existingCartItem.id,
//    title: existingCartItem.title, price: existingCartItem.price,
//    quantity: existingCartItem.quantity +1),),
//    else: we need to add a new entry:
//    _items.putIfAbsent(productId, () => CartItem(id: DateTime.now(), title:, price:, quantity:1))
// define couple of cartItem: can define into separate file define it into same file
//
//    [2].Working_with_Multiple_Providers
//    Cart_Provider: where needed__ProductOverViewScreen
//        ProductItem, CartScreen
//    MultiProviders[]
//
//    [3].Connecting_the_Cart_Provider
//    ProductItem => addToCarts
//    See cardAddingNum: Badge => value to output in the Badge
//  ProductOverviewScreen: Consumer<Cart>
//    Badge: value: amount+of+value_in The+Card
//  countItem:  int get itemCount => _items.length
//
//    [4].Working on Shopping_Cart& Display_Total
//
//     [5].Displaying a List of CartItems
//    ListView.builder(itemCount: [cart.items.length ||cart.itemCount ])
//
//    [6].Making CartItems Dismissible
//      [2].Update_data_Visually_and_on_Data
//
//    [7].Adding ProductDetail Data
//
//    [8].

// 3.. => [Order_Provider]
//    [1].Providing Order Objects
//  => where
//
//    [2].Adding Orders
//  CartScreen:  ORDER_NOW: BUTTON.
//
//    [3].Adding an OrdersScreen & Expandable Card
//      [2].Expandable Card
//
//      [3].Using a Side Drawer
//

// 2 {USER_INPUT}
//   User  Interaction & From Input:  Interacting with the User, Collecting Data
//    [1] Showing Dialogs & SnackBars(Info popups)
//    [2] Fetching User Input via Forms
//    [3] Input Validation
//
//   [1].SnackBars & Undoing Cart Actions
//

// 3 {HTTP_REQUEST}
//  Interacting with Web Servers
//
//    Storing  Data & Http
//    Sending Http Requests (Store + Fetch Data)   Persist MUltiple users
//    Showing Loading Progress  => loading data take some times
//    Handling Errors   => Handle errors show errors to User
//
//    [1]Storing Data
//
// On Device Storage<Memory>           [Your App]     On Web Server
//  memory reset when the App is Lost
//    temporarly
//
//    ONly available in your App/                    Available for all users
//      for your user                               accross different devices
//                                                Shop_app availables on WebServers
//                                                so every Users can see the same Products
//
//    Data persists app restart                     Survives app restarts
//                                              WebServers is not touch
//                                            reinstall otherDevices
//
//        Work offline                            Internet connection Required
//    on your local device                        users can interact with this app
//
//
//      [2] Connection Flutter|WebServers to a Database[ServersDatabase]
//
//                                                   [Flutter App]
//
//  Technicall Complex&Insecure
//  [you need to include your ]
//  [your db credentials: userName&password ]
//  [to give you write and read access to db]
//  [from AppStore users cannot easily see your]
//  [source code not 100% sure that someone get]      [Web Server = Firebase]
//  [your appBundle and look for your credentials]  [Protection MEchanism]
//  [if people access your db credentials get all]  [storing your credentials]
//  [your data do not include your credentials in]  [storing your db]
//  [your source code their USE: WEB_SERVER]
//
//                                                  Database(MySql, NoSql)
//
//       [3]Preparing Our Backend => FIREBASE
//    FIREBASE = SERVER SIDE SOLUTIONS GIVE A LOT OF SERVICES
//
//     WEBSERVER WITH AN ATTACHED DATABASE:
//    knowledge I learn in this course is applicable
//          to ANY SERVER = NOT JUST FIREBASE
//
//    GOOGLE: SEARCH_FOR:   FIREBASE_FLUTTER
//      offers_DOCS: Flutter SDK
//    I don't teach you Firebase + Flutter but FLUTTER WITH ANY BACKEND
// we'll use GENERIC PART of FIREBASE WE easily REPLACE ANY BACK-END
//
//        [1].Firebase Console => Database
//      Create Database = [RealTime Database]  => [Test_Mode]
//    Later we will [lock__Database] => in Authenticate Mode.. Get__URL when we have to send requests and
//      AND WHERE FIREBASE TRANSFORM IT AUTOMATICALLY INTO QUERIES
//  WE DON'T DIRECTLY TALK TO DB BUT WEBSERVER={URL} who interprete some of my request and interact with my DB
//
//      [4]How to Send Http Requests
// Store = products{add_delete_edit_ _favoriteStatus_Orders OnServer} => then
//       {fetching Data &use_it_locally},
//
//  START = {ADD_NEW_PRODUCT}   =>  http.package to this url_servers
//
//          Http Requests
//
//  THE SERVER TALKING TO DECIDE WHICH KIND OF HTTP_REQUEST
//      YOU ARE GOING TO HANDLE   UNLESS YOU NEED CHECK THE DOCS OF THE BACKEND
//        YOU ARE WORKING
//
//    typically I'll work with a
//  REST(RESTFUL) APIs follow a default approach regarding
//    HOW INCOMING  REQUESTS SHOULD BE STRUCTURED/ set up
//   The MOST COMMON WEB APPLICATION WE USE FOR FRONT END APPLICATION FOR UI LIKE
//                      FLUTTER APP
//
//              WHEN COMMUNICATING WITH A (REST) API
//
//      depending of the combination of URL&VERB you use an certain ACTION
//         is executed = {YOU  CAN ONLY USE COMBINATION THAT WEBSERVERS ACCEPT}
//            why you need to READ DOCS or build your OWN WEBSERVER
//
//           Convention: Http Endpoint(URL) + Http Verb = Action
//
//  HTTP_REQUEST_VERB:
//
//    GET                 POST              PATCH           DELETE
// [open a page]       [APPEND data]      [editing data]
// [a get request is]  [to an existing]   [in a field]
// [send to display]   [list of data]
// [data in browser]
//
// {send request to}    {again depends}    {depends of}
// {REST APIs get you}  {of the server}    {webServer}
// {some data:<single}  {convetion: post}  {which type of}
// {piece, lists}      {&url add_data}     {requests it}
// {depend of the}      {to an list or}    {accepts and }
// {server you are}     {application your} {what it does}
// {work and the app}   {server does}      {in details: DOCS}
// { you are building}   {add data to DB}
//
//   <Fetch data>        <store data>       <update data>     <delete>
//
//                                            PUT
//                                          [take a new data ]
//                                          [block a replace ]
//                                          [it with an ]
//                                          [existing]
//
//                                           {depends of}
//                                           {webServer}
//                                          {official: DOCS}
//
//                                            <replace data>
//
//        WE WILL WORK FROM DIFFERENT: [VERB & ENDPOINT]
//
//    [6].Sending POST Requests
//
//      Where POST requests:  when HIT_SAVE_BUTTON__SUBMIT_FORM
//
//      Sending HTTP requests: backend  DO PROVIDER
//

//
// 4 {AUTHENTICATION}

// 5 {ANIMATION}

// 6 {NATIVE_DEVIE_FEATURES}

// [package_use]:
// provider
// intl
// http
// shared_preferences
// font_awesome
//
// [native_device_db]
// image_picker
// path_picker
// path
// sqflite
//
// [maps]
// location
// google_maps_flutter

// color_picker

// install pubsec.yaml  formatter
// download ask T-MONEY_API
// download xd, figma, file, convertor: plan
// download windows free desktop app to open: .xd, .fg, .sketch
//
