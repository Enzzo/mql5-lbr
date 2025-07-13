//+------------------------------------------------------------------+
//|                                                  ConsoleView.mqh |
//|                                                   Sergey Vasilev |
//|                                         vasilevnogliki@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "vasilevnogliki@yandex.ru"

#include <vasilev\view\View.mqh>
#include <vasilev\model\TradeModel.mqh>
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

// +-----------------------------------------------------------+
// |  DECLARATION                                              |
// +-----------------------------------------------------------+
// |  ConsoleView : View : Observer                            |
// +-----------------------------------------------------------+
class ConsoleView : public View{
public:
   ConsoleView(TradeModel* model);
   ~ConsoleView();
   
   void update() override;
private:
   TradeModel* _model;
};

// +-----------------------------------------------------------+
// |  DEFINITION                                               |
// +-----------------------------------------------------------+
// |  ctor                                                     |
// +-----------------------------------------------------------+
ConsoleView::ConsoleView(TradeModel* model) : View(model){
   _model = _target;
}

// +-----------------------------------------------------------+
// |  DEFINITION                                               |
// +-----------------------------------------------------------+
// |  dtor                                                     |
// +-----------------------------------------------------------+
ConsoleView::~ConsoleView(){

}

// +-----------------------------------------------------------+
// |  void update()                                            |
// +-----------------------------------------------------------+
void ConsoleView::update(void) override{
   Print("Last ticket: "+ IntegerToString(_model.getLastTicket()));
}