//+------------------------------------------------------------------+
//|                                                        lbrUI.mqh |
//|                                                   Sergey Vasilev |
//|                                         vasilevnogliki@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "vasilevnogliki@yandex.ru"

#include <Controls\Dialog.mqh>

#include <vasilev\view\View.mqh>
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
   LbrUI(Observable*);
   ~LbrUI();
   
   void Run();
   void Update() override;
   void OnChartEvent(const int, const long&, const double&, const string&);
   void Destroy(const int reason);
   
private:
   CAppDialog _dialog;
   TradeModel* _model;
};

// +-----------------------------------------------------------+
// |  ctor                                                     |
// +-----------------------------------------------------------+
LbrUI::LbrUI(Observable* model) : 
   View(model),
   //_dialog(new CAppDialog()),
   _model(model){
   
   DEBUG(__FUNCTION__)
   
   if(!_dialog.Create(ChartID(), 
      "LBR",
      0, 
      20, 
      20, 
      100,
      100)){
         Alert("failed to create expert window!!!");
         FATAL("failed to create expert window")
         ExpertRemove();
      }
}
   
// +-----------------------------------------------------------+
// |  dtor                                                     |
// +-----------------------------------------------------------+
LbrUI::~LbrUI(){
   DEBUG(__FUNCTION__)
   //delete _dialog;
}

// +-----------------------------------------------------------+
// |  void run()                                               |
// +-----------------------------------------------------------+
void LbrUI::Run(void){
   DEBUG(__FUNCTION__)
   _dialog.Run();
}

void LbrUI::Update() override{
   
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