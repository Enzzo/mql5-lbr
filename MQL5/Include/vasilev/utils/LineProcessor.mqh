//+------------------------------------------------------------------+
//|                                                LineProcessor.mqh |
//|                                                   Sergey Vasilev |
//|                                         vasilevnogliki@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "vasilevnogliki@yandex.ru"

#include <Object.mqh>

#include <vasilev\logger\logger.mqh>

class LineProcessor : public CObject{
public:
   LineProcessor(){};
   virtual ~LineProcessor(){};
public:
   bool LineCreate(const string          name = "HLine",
                    double                price=0,           // цена линии 
                    const color           clr=clrRed,        // цвет линии 
                    const string          text="",           // описание линии
                    const ENUM_LINE_STYLE style=STYLE_SOLID, // стиль линии 
                    const int             width=1,           // толщина линии 
                    const bool            back=false,        // на заднем плане 
                    const bool            selection=false,   // выделить для перемещений 
                    const bool            hidden=true,       // скрыт в списке объектов 
                    const long            z_order=0);
  
   bool LineCreate( const string          name="VLine",      // имя линии 
                    datetime              time=0,            // время линии 
                    const color           clr=clrRed,        // цвет линии 
                    const string          text="",           // описание линии
                    const ENUM_LINE_STYLE style=STYLE_SOLID, // стиль линии 
                    const int             width=1,           // толщина линии 
                    const bool            back=false,        // на заднем плане 
                    const bool            selection=false,    // выделить для перемещений 
                    const bool            ray=true,          // продолжение линии вниз 
                    const bool            hidden=true,       // скрыт в списке объектов 
                    const long            z_order=0);        // приоритет на нажатие мышью
                    
   bool LineMove(const string name, const double price, const datetime date);
   bool LineRemove(const string name);
   // создать горизонтальную линию
   // создать вертикальную линию
   // создать косую линию
   // двигать линию по линии
   // двигать список линий, сохраняя их оффсет
   // удалить линию по имени
   // удалить список линий
   
   // получить цену горизонтальной линии
   // получить дату вертикальной линии
private:
   
};

bool LineProcessor::LineCreate(const string name="HLine",      // имя линии
                 double                price=0,           // цена линии 
                 const color           clr=clrRed,        // цвет линии 
                 const string          text="",           // описание линии
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // стиль линии 
                 const int             width=1,           // толщина линии 
                 const bool            back=false,        // на заднем плане 
                 const bool            selection=false,   // выделить для перемещений 
                 const bool            hidden=true,       // скрыт в списке объектов 
                 const long            z_order=0){        // приоритет на нажатие мышью 
//--- если цена не задана, то установим ее на уровне текущей цены Bid 
   DEBUG("CREATE HORIZONTAL LINE: " + DoubleToString(price))
   if(!price) 
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
   ResetLastError(); 
//--- создадим горизонтальную линию 
   string label_name = name + "_Label";
   if(ObjectFind(ChartID(), name)!= -1)ObjectDelete(ChartID(), name);
   if(ObjectFind(ChartID(), label_name) != -1) ObjectDelete(ChartID(), label_name);
   
   if(!ObjectCreate(0,name,OBJ_HLINE,0,0,price) ||
      !ObjectCreate(0, label_name, OBJ_TEXT, 0, 0, price)){ 
      Print(__FUNCTION__, 
            ": не удалось создать горизонтальную линию! Код ошибки = ",GetLastError()); 
      return(false); 
   }
   ObjectSetInteger(0, name, OBJPROP_COLOR,clr);
   ObjectSetInteger(0, name, OBJPROP_STYLE,style);
   ObjectSetInteger(0, name, OBJPROP_WIDTH,width);
   ObjectSetInteger(0, name, OBJPROP_BACK,back);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(0, name, OBJPROP_SELECTED,selection);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(0, name, OBJPROP_ZORDER,z_order);

   ObjectSetInteger(0, label_name, OBJPROP_COLOR, clrBlack);
   ObjectSetString(0,  label_name, OBJPROP_TEXT, text);
   return(true); 
}

bool LineProcessor::LineCreate(
                 const string          name="VLine",      // имя линии 
                 datetime              time=0,            // время линии 
                 const color           clr=clrRed,        // цвет линии 
                 const string          text="",           // описание линии
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // стиль линии 
                 const int             width=1,           // толщина линии 
                 const bool            back=false,        // на заднем плане 
                 const bool            selection=false,    // выделить для перемещений 
                 const bool            ray=true,          // продолжение линии вниз 
                 const bool            hidden=true,       // скрыт в списке объектов 
                 const long            z_order=0)         // приоритет на нажатие мышью 
  { 
//--- если время линии не задано, то проводим ее через последний бар 
   DEBUG("CREATE VERTICAL LINE: " + TimeToString(time))
   if(!time) 
      time=TimeCurrent(); 
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим вертикальную линию 
   if(!ObjectCreate(0,name,OBJ_VLINE,0,time,0)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать вертикальную линию! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- установим цвет линии 
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr); 
//--- установим стиль отображения линии 
   ObjectSetInteger(0,name,OBJPROP_STYLE,style); 
//--- установим толщину линии 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,width); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(0,name,OBJPROP_BACK,back); 
//--- включим (true) или отключим (false) режим перемещения линии мышью 
//--- при создании графического объекта функцией ObjectCreate, по умолчанию объект 
//--- нельзя выделить и перемещать. Внутри же этого метода параметр selection 
//--- по умолчанию равен true, что позволяет выделять и перемещать этот объект 
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(0,name,OBJPROP_SELECTED,selection); 
//--- включим (true) или отключим (false) режим отображения линии в подокнах графика 
   ObjectSetInteger(0,name,OBJPROP_RAY,ray); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,hidden); 
//--- установим приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(0,name,OBJPROP_ZORDER,z_order); 
//--- успешное выполнение 
   return(true); 
}

//+------------------------------------------------------------------+
bool LineProcessor::LineMove(const string name, const double price, const datetime date){
   ChartRedraw();
   bool result = ObjectMove(0,name,0,date,price) && ObjectMove(0, name+"Label", 0, date, price);
   return result;
}

bool LineProcessor::LineRemove(const string name){
   ChartRedraw();
   if(ObjectFind(ChartID(), name)!= -1)ObjectDelete(ChartID(), name);
   if(ObjectFind(ChartID(), name + "_Label") != -1) ObjectDelete(ChartID(), name + "_Label");
   return true;
}