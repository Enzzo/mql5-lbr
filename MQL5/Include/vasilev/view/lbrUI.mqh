//+------------------------------------------------------------------+
//|                                                        lbrUI.mqh |
//|                                                   Sergey Vasilev |
//|                                         vasilevnogliki@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "vasilevnogliki@yandex.ru"

#include <Controls\Dialog.mqh>
#include <Controls\Defines.mqh>

#include <vasilev\view\View.mqh>
#include <vasilev\model\TradeModel.mqh>
#include <vasilev\logger\logger.mqh>

#undef CONTROLS_DIALOG_COLOR_BG
#undef CONTROLS_DIALOG_COLOR_CLIENT_BG

#undef CONTROLS_DIALOG_COLOR_BORDER_LIGHT  
#undef CONTROLS_DIALOG_COLOR_BORDER_DARK   
#undef CONTROLS_DIALOG_COLOR_CLIENT_BORDER

#define CONTROLS_DIALOG_COLOR_BG             C'87,173,202'
#define CONTROLS_DIALOG_COLOR_CLIENT_BG      C'87,173,202'

#define CONTROLS_DIALOG_COLOR_BORDER_LIGHT  clrBlack
#define CONTROLS_DIALOG_COLOR_BORDER_DARK   C'0x00,0x00,0x00'
#define CONTROLS_DIALOG_COLOR_CLIENT_BORDER C'0x00,0x00,0x00'

struct UIParams{
   long chart;
   string name; 
   int subwin;
   int x;
   int y; 
   int w; 
   int h; 
   ENUM_BASE_CORNER corner;
   int fontSize;
   
   void UIParams::operator=(const UIParams& other){
      this.chart = other.chart;
      this.name = other.name; 
      this.subwin = other.subwin;
      this.x = other.x;
      this.y = other.y; 
      this.w = other.w; 
      this.h = other.h; 
      this.corner = other.corner;
      this.fontSize = other.fontSize;
   }
};

class LbrUI : public View{
public:
   LbrUI(Observable*, const UIParams& params);
   ~LbrUI();
   
   void Run() const;
   void Update() override;
   bool Redraw() const;
   bool Create() const;
   
   void OnChartEvent(const int, const long&, const double&, const string&);
   void Destroy(const int reason);
   
private:
   UIParams _params;
   CAppDialog* _dialog;
   TradeModel* _model;
};

// +-----------------------------------------------------------+
// |  ctor                                                     |
// +-----------------------------------------------------------+
LbrUI::LbrUI(Observable* model, const UIParams& params) :
   View(model),
   _dialog(new CAppDialog()),
   _model(model){
   
   DEBUG(__FUNCTION__)
   _params = params;
}
   
// +-----------------------------------------------------------+
// |  dtor                                                     |
// +-----------------------------------------------------------+
LbrUI::~LbrUI(){
   DEBUG(__FUNCTION__)
   delete _dialog;
   _dialog = NULL;
}

// +-----------------------------------------------------------+
// |  void run()                                               |
// +-----------------------------------------------------------+
void LbrUI::Run(void) const{
   DEBUG(__FUNCTION__)
   _dialog.Run();
}

void LbrUI::Update() override{
   
}

bool LbrUI::Redraw() const{
   DEBUG(__FUNCTION__)
   return Create();
}

bool LbrUI::Create() const{
   const UIParams p = _params;
   
   int x1 = p.x;
   int y1 = p.y;
   int x2 = p.x + p.w;
   int y2 = p.y + p.h;
   
   int width   = (int)ChartGetInteger(p.chart, CHART_WIDTH_IN_PIXELS, 0);
   int height  = (int)ChartGetInteger(p.chart, CHART_HEIGHT_IN_PIXELS, 0);
   
   switch(p.corner){
     case CORNER_RIGHT_UPPER:
         x1 = width - (p.w + x1);
         x2 = width - x2 + p.w;
     break;
     case CORNER_LEFT_LOWER:
         y1 = height - (p.h + y1);
         y2 = height - y2 + p.h;
     break;
     case CORNER_RIGHT_LOWER:
         x1 = width - (p.w + x1);
         x2 = width - x2 + p.w;
         y1 = height - (p.h + y1);
         y2 = height - y2 + p.h;
     break;
   }

   /*
   _prefix = Name();
   _fontSize = fontSize;
   
   if(!LabelCmntCreate())      return false;
   if(!LabelRiskCreate())      return false;
   if(!EditCmntCreate())       return false;
   if(!EditRiskCreate())       return false;
   if(!ButtonOpenCreate())     return false;
   if(!ButtonCloseCreate())    return false;
   */
   return _dialog.Create(p.chart, p.name, p.subwin, x1, y1, x2, y2);
}

void LbrUI::OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam){
   _dialog.ChartEvent(id, lparam, dparam, sparam);
}

void LbrUI::Destroy(const int reason){
   DEBUG(__FUNCTION__ + " reason: " + IntegerToString(reason))
   _dialog.Destroy(reason);
}