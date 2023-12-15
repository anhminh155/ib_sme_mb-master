import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'providers.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => CustInfoProvider()),
  ChangeNotifierProvider(create: (_) => OtpProvider()),
  ChangeNotifierProvider(create: (_) => TddAccountProvider()),
  ChangeNotifierProvider(create: (_) => TransLotProvider()),
  ChangeNotifierProvider(create: (_) => SourceAcctnoProvider()),
  ChangeNotifierProvider(create: (_) => SpecialCharactersProvider()),
  ChangeNotifierProvider(create: (_) => CountTransProvider()),
  ChangeNotifierProvider(create: (_) => CountUnreadProvider()),
  ChangeNotifierProvider(create: (_) => NotificationProvider()),
  ChangeNotifierProvider(create: (_) => RejectTransProvider()),
  ChangeNotifierProvider(create: (_) => FavoriteProductProvider()),
  ChangeNotifierProvider(create: (_) => LastUserProvider()),
];
