//+------------------------------------------------------------------+
//|                                                  CommentView.mqh |
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

class CommentView : public View{
public:
   CommentView(TradeModel* model);
   ~CommentView();
   
   void Update() override;
private:
   TradeModel* _model;
};

// +-----------------------------------------------------------+
// |  DEFINITION                                               |
// +-----------------------------------------------------------+
// |  ctor                                                     |
// +-----------------------------------------------------------+
CommentView::CommentView(TradeModel* model):View(model){
   DEBUG(__FUNCTION__)
   _model = _target;
}

// +-----------------------------------------------------------+
// |  DEFINITION                                               |
// +-----------------------------------------------------------+
// |  dtor                                                     |
// +-----------------------------------------------------------+
CommentView::~CommentView(){
   Comment("");
}

// +-----------------------------------------------------------+
// |  void update()                                            |
// +-----------------------------------------------------------+
void CommentView::Update(void) override{
   DEBUG(__FUNCTION__)
   //_model = _target;
   Comment("Last ticket: ", IntegerToString(_model.GetLastTicket()) +
            "\n Account Balance: ", DoubleToString(_model.GetAccountBalance()));
}