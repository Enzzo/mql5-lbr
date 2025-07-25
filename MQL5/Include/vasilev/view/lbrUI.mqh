//+------------------------------------------------------------------+
//|                                                        lbrUI.mqh |
//|                                                   Sergey Vasilev |
//|                                         vasilevnogliki@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "vasilevnogliki@yandex.ru"

#include <vasilev\view\View.mqh>
#include <vasilev\model\TradeModel.mqh>
#include <vasilev\logger\logger.mqh>

#include <Controls\Dialog.mqh>

// +-----------------------------------------------------------+
// |  UIParams                                                 |
// +-----------------------------------------------------------+
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
   
   UIParams(){}
   
   UIParams(const UIParams& other){
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

// +-----------------------------------------------------------+
// |  DECLARATION                                              |
// +-----------------------------------------------------------+
// |  LbrUI : public View                                      |
// +-----------------------------------------------------------+
class LbrUI : public View{
public:
   LbrUI(Observable*, const UIParams& params);
   ~LbrUI();
   
   void Run();
   void Update() override;
   bool Redraw();
   bool Create();
   
   const double GetTpField() const;
   
   void OnChartEvent(const int, const long&, const double&, const string&);
   void Destroy(const int reason);
   
private:   
   bool WindowCreate();
   bool EditTpCreate();
   
   void ApplyParams(const UIParams&);

// params
private:
   long _chart;
   string _name; 
   int _subwin;
   int _x;
   int _y; 
   int _w; 
   int _h; 
   ENUM_BASE_CORNER _corner;
   int _font_size;
   
private:
   CEdit* _e_tp, _e_sl, _e_op;
   CAppDialog* _dialog;
   TradeModel* _model;
};

// +-----------------------------------------------------------+
// |  DEFINITION                                               |
// +-----------------------------------------------------------+
// |  ctor                                                     |
// +-----------------------------------------------------------+
LbrUI::LbrUI(Observable* model, const UIParams& params) :
   View(model),
   _dialog(new CAppDialog()),
   _model(model){
   
   ApplyParams(params);
   
   DEBUG(__FUNCTION__)
}
   
// +-----------------------------------------------------------+
// |  dtor                                                     |
// +-----------------------------------------------------------+
LbrUI::~LbrUI(){
   DEBUG(__FUNCTION__)
   delete _dialog;
   _dialog = NULL;
   delete _e_tp;
   _e_tp = NULL;
}

// +-----------------------------------------------------------+
// |  void ApplyParams()                                       |
// +-----------------------------------------------------------+
void LbrUI::ApplyParams(const UIParams& p){
   _chart = p.chart;
   _name = p.name; 
   _subwin = p.subwin;
   _x = p.x;
   _y = p.y; 
   _w = p.w; 
   _h = p.h; 
   _corner = p.corner;
   _font_size = p.fontSize;
}

// +-----------------------------------------------------------+
// |  void Run()                                               |
// +-----------------------------------------------------------+
void LbrUI::Run(){
   DEBUG(__FUNCTION__)
   _dialog.Run();
};

void LbrUI::Update() override{
   _e_tp.Text(DoubleToString(_model.GetTp(), Digits()));
};

bool LbrUI::Redraw(){
   DEBUG(__FUNCTION__)
   return Create();
}

// +-----------------------------------------------------------+
// |  bool Create                                              |
// +-----------------------------------------------------------+
bool LbrUI::Create(){
   bool result = WindowCreate() & EditTpCreate();
   /*
   EditTpCreate
   if(!LabelCmntCreate())      return false;
   if(!LabelRiskCreate())      return false;
   if(!EditCmntCreate())       return false;
   if(!EditRiskCreate())       return false;
   if(!ButtonOpenCreate())     return false;
   if(!ButtonCloseCreate())    return false;
   */
   DEBUG("CREATE DIALOG: " + IntegerToString(_chart) + " " + _name)
   return result;
}

const double LbrUI::GetTpField(void) const{
   return StringToDouble(_e_tp.Text());
}

// +-----------------------------------------------------------+
// |  void OnChartEvent                                        |
// +-----------------------------------------------------------+
void LbrUI::OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam){
   _dialog.ChartEvent(id, lparam, dparam, sparam);
}

// +-----------------------------------------------------------+
// |  void Destroy                                             |
// +-----------------------------------------------------------+
void LbrUI::Destroy(const int reason){
   DEBUG(__FUNCTION__ + " reason: " + IntegerToString(reason))
   _dialog.Destroy(reason);
}

// +-----------------------------------------------------------+
// |  bool WindowCreate                                        |
// +-----------------------------------------------------------+
bool LbrUI::WindowCreate(){
   int x1 = _x;
   int y1 = _y;
   int x2 = _x + _w;
   int y2 = _y + _h;
   
   int width   = (int)ChartGetInteger(_chart, CHART_WIDTH_IN_PIXELS, 0);
   int height  = (int)ChartGetInteger(_chart, CHART_HEIGHT_IN_PIXELS, 0);
   
   switch(_corner){
     case CORNER_RIGHT_UPPER:
         x1 = width - (_w + x1);
         x2 = width - x2 + _w;
     break;
     case CORNER_LEFT_LOWER:
         y1 = height - (_h + y1);
         y2 = height - y2 + _h;
     break;
     case CORNER_RIGHT_LOWER:
         x1 = width - (_w + x1);
         x2 = width - x2 + _w;
         y1 = height - (_h + y1);
         y2 = height - y2 + _h;
     break;
   }
   bool result = _dialog.Create(_chart, _name, _subwin, x1, y1, x2, y2);
   if(result) DEBUG("WINDOW SUCCESSFULLY CREATED WITH NAME: " + _name)
   else FATAL("CAN'T CREATE WINDOW")
   return result;
}

// +-----------------------------------------------------------+
// |  bool EditTpCreate                                        |
// +-----------------------------------------------------------+
bool LbrUI::EditTpCreate(){
   _e_tp = new CEdit();
    if(!_e_tp.Create(_chart, _name + "_edit_tp", _subwin, 50, 4, 98, 20)) return (false);
    if(!_e_tp.FontSize(_font_size)) return (false);
    if(!_e_tp.Text(DoubleToString(0, Digits()))) return (false);
    if(!_dialog.Add(_e_tp)) return (false);
    return (true);
}