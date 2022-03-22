#import "KnoviCallPlugin.h"
#if __has_include(<knovi_call/knovi_call-Swift.h>)
#import <knovi_call/knovi_call-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "knovi_call-Swift.h"
#endif

@implementation KnoviCallPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftKnoviCallPlugin registerWithRegistrar:registrar];
}
@end
