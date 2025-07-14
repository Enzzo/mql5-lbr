//+------------------------------------------------------------------+
//|                                                        lbrUI.mqh |
//|                                                   Sergey Vasilev |
//|                                         vasilevnogliki@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "vasilevnogliki@yandex.ru"

#include <Controls\Dialog.mqh>

#include <vasilev\view\View.mqh>
#include <vasilev\view\LbrConfig.mqh>
#include <vasilev\model\TradeModel.mqh>
#include <vasilev\logger\logger.mqh>
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

class LbrUI : public View{
public:
   LbrUI(Observable*, const LbrConfig&);
   ~LbrUI();
   
   void run();
   void update() override;
   void onChartEvent(const int, const long&, const double&, const string&);
            
private:
   inline   bool is_running() const;
   
private:
   bool running;
   CAppDialog* _dialog;
   TradeModel* _model;
};

// +-----------------------------------------------------------+
// |  ctor                                                     |
// +-----------------------------------------------------------+
LbrUI::LbrUI(Observable* model, const LbrConfig& conf) : 
   View(model),
   running(false), 
   _dialog(new CAppDialog()),
   _model(model){
   
   DEBUG("Entering LbrUI constructor...")
   
   if(!_dialog.Create(conf.chart, 
      conf.name,
      conf.subwin, 
      conf.x, 
      conf.y, 
      conf.x + conf.w,
      conf.y + conf.h)){
         Alert("failed to create expert window!!!");
         FATAL("failed to create expert window")
         ExpertRemove();
      }
}
   
// +-----------------------------------------------------------+
// |  dtor                                                     |
// +-----------------------------------------------------------+
LbrUI::~LbrUI(){
   _dialog.Destroy();
   if(CheckPointer(_dialog) == POINTER_DYNAMIC){
      delete (_dialog);
      _dialog = NULL;
   }   
}

// +-----------------------------------------------------------+
// |  void run()                                               |
// +-----------------------------------------------------------+
void LbrUI::run(void){
   if(!is_running()){
      _dialog.Run();
      running = true;
   }
}

void LbrUI::update() override{

}

void LbrUI::onChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam){
   _dialog.ChartEvent(id, lparam, dparam, sparam);
   PrintFormat("%d, %d, %d, %s", id, lparam, dparam, sparam);
}

// +-----------------------------------------------------------+
// |  void is_running()                                        |
// +-----------------------------------------------------------+
bool LbrUI::is_running(void) const{
   return running;
}