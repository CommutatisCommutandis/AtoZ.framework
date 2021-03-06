




//@protocol AZWebKitProgressDelegate <NSObject>
//- (void)webKitProgressDidChangeFinishedCount:(NSInteger)finishedCount ofTotalCount:(NSInteger)totalCount;
//@end

//@interface AZWebKitProgressController : NSObject
//@property (nonatomic, weak) IBOutlet id<AZWebKitProgressDelegate> delegate;
//@end

typedef NS_ENUM(NSUI,BarProgressPhase) { AZProgressPhaseNone = 0, AZProgressPhasePending, AZProgressPhaseDownloading };

//@class AZURLBar;
//@protocol AZURLBarDelegate <NSObject>
//- (void)urlBar:(AZURLBar *)urlBar didRequestURL:(NSURL *)url;
//@optional
//- (void)urlBarColorConfig;
//@end
//@property (nonatomic, weak) id<AZURLBarDelegate> delegate;


@class AZWebView;
@interface AZURLBar : NSView
@property (weak) AZWebView *webView;
@property (nonatomic) double progress;
@property (nonatomic) BarProgressPhase progressPhase;
@property (nonatomic,weak) NSString *addressString;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic,strong) NSColor *gradientColorTop, *gradientColorBottom, *borderColorTop, *borderColorBottom, *barColorPendingTop,  *barColorPendingBottom, *barColorDownloadingTop, *barColorDownloadingBottom;

@property (nonatomic, strong) NSArray *leftItems, *rightItems;

//- (instancetype)initWithDelegate:(id<AZURLBarDelegate>)delegate;


@end



@interface AZURLFormatter : NSFormatter
@end

@interface AZWebView : WebView //<AZURLBarDelegate>
@property AGNSSplitView *split, *consoleSplit;
@property NSLogConsoleView  *console;
@property (nonatomic, weak) IBOutlet AZURLBar *urlBar;
- (void)urlBar:(AZURLBar *)urlBar didRequestURL:(NSURL *)url;
- (BOOL)urlBar:(AZURLBar *)urlBar isValidRequestStringValue:(NSString *)requestString;

//@interface WebView (AZURLBar) <AZURLBarDelegate, AZWebKitProgressDelegate>

//@property (weak) IBOutlet AZURLBar *urlBar;
@end
