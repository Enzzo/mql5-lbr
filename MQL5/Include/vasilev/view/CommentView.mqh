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
   const string GetTradeType() const;
   
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
   Comment("Last ticket: ", IntegerToString(_model.GetLastTicket()) +
            "\nAccount Balance: \t", DoubleToString(_model.GetAccountBalance(), 2) + 
            "\nAccount Margin: \t", DoubleToString(_model.GetAccountMargin(), 2) + 
            "\nAccount Profit: \t", DoubleToString(_model.GetAccountProfit(), 2) +
            "\nAccount Equity: \t", DoubleToString(_model.GetAccountEquity(), 2) +
            "\nTP: \t", DoubleToString(_model.GetTp(), Digits()) +
            "\nSL: \t", DoubleToString(_model.GetSl(), Digits()) +
            "\nOpen Price: \t", DoubleToString(_model.GetPrice(), Digits()) +
            "\nOpen Time: \t", TimeToString(_model.GetOpenTime()) +
            "\nClose Time: \t", TimeToString(_model.GetCloseTime()) +
            "\nTrade type: \t", GetTradeType() +
            "\nLot: \t", DoubleToString(_model.GetLot(), 2) +
            "\nRisk percent: \t", DoubleToString(_model.GetRiskPcnt(), 2) +
            "\nRisk real: \t", _model.GetRiskReal()
            );
}

const string CommentView::GetTradeType() const{
   switch(_model.GetTradeType()){
      case TM_BUY: return "BUY";
      case TM_SELL: return "SELL";
      case TM_BUYSTOP: return "BUYSTOP";
      case TM_SELLSTOP: return "SELLSTOP";
      case TM_BUYLIMIT: return "BUYLIMIT";
      case TM_SELLLIMIT: return "SELLLIMIT";
      default: return "TRADE IMPOSSIBLE";
   }
}