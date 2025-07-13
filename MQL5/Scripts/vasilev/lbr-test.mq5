//+------------------------------------------------------------------+
//|                                                     lbr-test.mq5 |
//|                                                   Sergey Vasilev |
//|                                         vasilevnogliki@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "vasilevnogliki@yandex.ru"
#property version   "1.00"

#define DEBUG_LOG

#include <vasilev/test/TestFramework.mqh>
#include <vasilev/utils/StringToToken.mqh>

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart(){
//---
   RUN_TEST(TestDigitsToToken)
   RUN_TEST(TestUpperCharToToken)
   RUN_TEST(TestLowerCharToToken)
   
   delete CharToToken::getInstance();
}
//+------------------------------------------------------------------+

void TestDigitsToToken(){
   CharToToken* inst = CharToToken::getInstance();
   ASSERT_EQUAL(48, inst.getToken('0'));
   ASSERT_EQUAL(49, inst.getToken('1'));
   ASSERT_EQUAL(50, inst.getToken('2'));
   ASSERT_EQUAL(51, inst.getToken('3'));
   ASSERT_EQUAL(52, inst.getToken('4'));
   ASSERT_EQUAL(53, inst.getToken('5'));
   ASSERT_EQUAL(54, inst.getToken('6'));
   ASSERT_EQUAL(55, inst.getToken('7'));
   ASSERT_EQUAL(56, inst.getToken('8'));
   ASSERT_EQUAL(57, inst.getToken('9'));
}

void TestUpperCharToToken(){
   CharToToken* inst = CharToToken::getInstance();
   ASSERT_EQUAL(65, inst.getToken('A'));
   ASSERT_EQUAL(66, inst.getToken('B'));
   ASSERT_EQUAL(67, inst.getToken('C'));
   ASSERT_EQUAL(68, inst.getToken('D'));
   ASSERT_EQUAL(69, inst.getToken('E'));
   ASSERT_EQUAL(70, inst.getToken('F'));
   ASSERT_EQUAL(71, inst.getToken('G'));
   ASSERT_EQUAL(72, inst.getToken('H'));
   ASSERT_EQUAL(73, inst.getToken('I'));
   ASSERT_EQUAL(74, inst.getToken('J'));
   ASSERT_EQUAL(75, inst.getToken('K'));
   ASSERT_EQUAL(76, inst.getToken('L'));
   ASSERT_EQUAL(77, inst.getToken('M'));
   ASSERT_EQUAL(78, inst.getToken('N'));
   ASSERT_EQUAL(79, inst.getToken('O'));
   ASSERT_EQUAL(80, inst.getToken('P'));
   ASSERT_EQUAL(81, inst.getToken('Q'));
   ASSERT_EQUAL(82, inst.getToken('R'));
   ASSERT_EQUAL(83, inst.getToken('S'));
   ASSERT_EQUAL(84, inst.getToken('T'));
   ASSERT_EQUAL(85, inst.getToken('U'));
   ASSERT_EQUAL(86, inst.getToken('V'));
   ASSERT_EQUAL(87, inst.getToken('W'));
   ASSERT_EQUAL(88, inst.getToken('X'));
   ASSERT_EQUAL(89, inst.getToken('Y'));
   ASSERT_EQUAL(90, inst.getToken('Z'));
}

void TestLowerCharToToken(){
   CharToToken* inst = CharToToken::getInstance();
   ASSERT_EQUAL(65, inst.getToken('a'));
   ASSERT_EQUAL(98, inst.getToken('b'));
   ASSERT_EQUAL(67, inst.getToken('c'));
   ASSERT_EQUAL(68, inst.getToken('d'));
   ASSERT_EQUAL(69, inst.getToken('e'));
   ASSERT_EQUAL(70, inst.getToken('f'));
   ASSERT_EQUAL(71, inst.getToken('g'));
   ASSERT_EQUAL(72, inst.getToken('h'));
   ASSERT_EQUAL(73, inst.getToken('i'));
   ASSERT_EQUAL(74, inst.getToken('j'));
   ASSERT_EQUAL(75, inst.getToken('k'));
   ASSERT_EQUAL(76, inst.getToken('l'));
   ASSERT_EQUAL(77, inst.getToken('m'));
   ASSERT_EQUAL(78, inst.getToken('n'));
   ASSERT_EQUAL(79, inst.getToken('o'));
   ASSERT_EQUAL(80, inst.getToken('p'));
   ASSERT_EQUAL(81, inst.getToken('q'));
   ASSERT_EQUAL(82, inst.getToken('r'));
   ASSERT_EQUAL(83, inst.getToken('s'));
   ASSERT_EQUAL(84, inst.getToken('t'));
   ASSERT_EQUAL(85, inst.getToken('u'));
   ASSERT_EQUAL(86, inst.getToken('v'));
   ASSERT_EQUAL(87, inst.getToken('w'));
   ASSERT_EQUAL(88, inst.getToken('x'));
   ASSERT_EQUAL(89, inst.getToken('y'));
   ASSERT_EQUAL(90, inst.getToken('z'));
}