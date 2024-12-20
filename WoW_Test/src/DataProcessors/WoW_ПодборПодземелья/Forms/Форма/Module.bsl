///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////Обработчики Событий Формы \\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////\\\\\\\\\\\\\\\///////////////\\\\\\\\\\\\\\///////////////

#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	РежимПодбора = "Рандомное подземелье";
	ДляТанка = Неопределено;
КонецПроцедуры

#КонецОбласти


///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////Обработчики Событий Команд\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////\\\\\\\\\\\\\\\///////////////\\\\\\\\\\\\\\///////////////

#Область КомандыФормы

&НаКлиенте
Процедура БроситьКубики(Команда)
	КартинкаПодземелия = "";
	Элементы.ИмяТанка.Заголовок = "";
	Элементы.НазваниеПодземелья.Заголовок = "";
	Элементы.ИмяСезона.Заголовок = "";
	
	ПодключитьОбработчикОжидания("ПроигратьЗвук", 0.1, Истина);	
	ПодключитьОбработчикОжидания("ПолучениеПодземелья", 2, Истина);				
КонецПроцедуры 	 

#КонецОбласти

///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////Обработчики Событий Элементов\\\\\\\\\\\\\\\\\\\\\\\
////////////////\\\\\\\\\\\\\\\///////////////\\\\\\\\\\\\\\///////////////

#Область ЭлементыФормы

&НаКлиенте
Процедура БанСписокНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	WoW_СезонныеПодземелья.Подземелье КАК ЗначениеВыбора
	|ИЗ
	|	РегистрСведений.WoW_СезонныеПодземелья КАК WoW_СезонныеПодземелья
	|ГДЕ
	|	WoW_СезонныеПодземелья.Сезон = &Сезон";
			
	СтруктураЗапроса = новый Структура;
	СтруктураЗапроса.Вставить("ТекстЗапроса",ТекстЗапроса);
	СтруктураЗапроса.Вставить("СтруктураПараметровЗапроса",новый Структура("Сезон",ПолучитьТекущийСезон()));
	СтруктураЗапроса.Вставить("СтруктураЗаменяемыхЗначений",новый Структура);
	
	
	ТранзитныеПараметры = новый Структура;
	ТранзитныеПараметры.Вставить("СтруктураЗапроса", СтруктураЗапроса);
	ТранзитныеПараметры.Вставить("ВыборИзТаблицы", Истина);
	ТранзитныеПараметры.Вставить("ДопДействие", "БанСписок_ВыбраноПодземелье(РезультатВыбора)");
	КиурКл.ОтобразитьВыборЗначения(ЭтаФорма, ТранзитныеПараметры);
КонецПроцедуры

&НаКлиенте
Процедура БанСписок_ВыбраноПодземелье(ВыбранноеПодземелье) ЭКСПОРТ
	Если НЕ ЗначениеЗаполнено(ВыбранноеПодземелье) Тогда
		Возврат;
	КонецЕсли;
		
	БанСписок.Добавить(ВыбранноеПодземелье);	
КонецПроцедуры	

#КонецОбласти

///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////////////////Служебные методы\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////\\\\\\\\\\\\\\\///////////////\\\\\\\\\\\\\\///////////////

#Область Служебные

&НаСервереБезКонтекста
Функция БроситьКубикиНаСервере(Знач ФиксированныеПараметры, МодифицируемыеПараметры = Неопределено)
	Если ТипЗнч(МодифицируемыеПараметры) <> Тип("Структура") Тогда
		МодифицируемыеПараметры = Новый Структура();
	КонецЕсли;
	
	Танк = ФиксированныеПараметры.Танк;
	РежимПодбора = ФиксированныеПараметры.РежимПодбора;
	БанСписок = ФиксированныеПараметры.БанСписок;
	
	ТекущийСезон = ПолучитьТекущийСезон();
	
	Если НЕ ЗначениеЗаполнено(ТекущийСезон) Тогда
		МодифицируемыеПараметры.Вставить("ИмяСезона", "Сезон не заполнен в настройках.");
		Возврат Неопределено;
	КонецЕсли;
			
	МодифицируемыеПараметры.Вставить("ИмяСезона",ТекущийСезон.Наименование);			
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Сезон", ТекущийСезон);
	Запрос.УстановитьПараметр("БанСписок", БанСписок);
	Запрос.УстановитьПараметр("Танк", Танк);
	
	Если РежимПодбора = "Рандомное подземелье" Тогда
		ЗапросаТекст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	WoW_СезонныеПодземелья.Подземелье.ОсновноеИзображение КАК ПутьККартинкеПодземелия,
		|	WoW_СезонныеПодземелья.Подземелье.Представление КАК НазваниеПодземелья,
		|	WoW_СезонныеПодземелья.Подземелье КАК ВыпавшееПодземелье,
		|	WoW_СезонныеПодземелья.Танк.Представление КАК ИмяТанка
		|ИЗ
		|	РегистрСведений.WoW_СезонныеПодземелья КАК WoW_СезонныеПодземелья
		|ГДЕ
		|	НЕ WoW_СезонныеПодземелья.Подземелье В (&БанСписок)
		|	И WoW_СезонныеПодземелья.Сезон = &Сезон
		|	И &ОтборПоТанку";		
	ИначеЕсли РежимПодбора = "Перемешать" Тогда
		ЗапросаТекст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	WoW_СезонныеПодземелья.Подземелье
		|ПОМЕСТИТЬ втПодземельяСезона
		|ИЗ
		|	РегистрСведений.WoW_СезонныеПодземелья КАК WoW_СезонныеПодземелья
		|ГДЕ
		|	НЕ WoW_СезонныеПодземелья.Подземелье В (&БанСписок)
		|	И WoW_СезонныеПодземелья.Сезон = &Сезон
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	WoW_СезонныеПодземелья.Танк
		|ПОМЕСТИТЬ втТанкиСезона
		|ИЗ
		|	РегистрСведений.WoW_СезонныеПодземелья КАК WoW_СезонныеПодземелья
		|ГДЕ
		|	WoW_СезонныеПодземелья.Сезон = &Сезон
		|	И &ОтборПоТанку
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втПодземельяСезона.Подземелье.ОсновноеИзображение КАК ПутьККартинкеПодземелия,
		|	втПодземельяСезона.Подземелье.Представление КАК НазваниеПодземелья,
		|	втПодземельяСезона.Подземелье КАК ВыпавшееПодземелье,
		|	втТанкиСезона.Танк.Представление КАК ИмяТанка
		|ИЗ
		|	втПодземельяСезона КАК втПодземельяСезона
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втТанкиСезона КАК втТанкиСезона
		|		ПО ИСТИНА";
		
	Иначе
		МодифицируемыеПараметры.Вставить("НазваниеПодземелья", "Не опознанный режим подбора.");
		Возврат Неопределено;
	КонецЕсли;		

	Запрос.Текст = СтрЗаменить(ЗапросаТекст,"&ОтборПоТанку",?(ЗначениеЗаполнено(Танк),"WoW_СезонныеПодземелья.Танк = &Танк","ИСТИНА"));
	
	Подземелия = Запрос.Выполнить().Выгрузить();
	
	КоличествоПодземелий = Подземелия.Количество();
	
	Если КоличествоПодземелий = 0 Тогда
		МодифицируемыеПараметры.Вставить("НазваниеПодземелья","По условиям ничего не нашлось.");
		Возврат Неопределено;
	КонецЕсли;
	
	Генератор = Новый ГенераторСлучайныхЧисел();
	ИскомыйИндекс = Генератор.СлучайноеЧисло(0, КоличествоПодземелий - 1);
	
	МодифицируемыеПараметры.Вставить("ИмяТанка",Подземелия[ИскомыйИндекс].ИмяТанка);
	МодифицируемыеПараметры.Вставить("НазваниеПодземелья",Подземелия[ИскомыйИндекс].НазваниеПодземелья);		
	МодифицируемыеПараметры.Вставить("ВыпавшееПодземелье",Подземелия[ИскомыйИндекс].ВыпавшееПодземелье);
				
	Возврат Подземелия[ИскомыйИндекс].ПутьККартинкеПодземелия;
КонецФункции

&НаКлиенте
Процедура ВывестиКартинкуВПолеФормы_ПровереноСуществованиеФайла(ФайлСуществует, ТранзитныеПараметры) ЭКСПОРТ
	
	ПутьКФайлу = ТранзитныеПараметры.ПутьКФайлу;
	
	Если НЕ ФайлСуществует Тогда
		ТекстПредупреждения = "По указанному пути отсутствует файл." + Символы.ПС;
		ТекстПредупреждения = ТекстПредупреждения + ПутьКФайлу + Символы.ПС;
		КиурКл.ОтобразитьПредупреждение(ТекстПредупреждения, ЭтаФорма);
		Возврат;
	КонецЕсли;
		
	ПутьКФайлу = СтрЗаменить(ПутьКФайлу, "\", "/");
	
	КартинкаПодземелия = КиурКлСрв.ПолучитьТекстHTML_ФайлаКартинки(ПутьКФайлу);
КонецПроцедуры

&НаКлиенте
Процедура ПроигратьЗвук()

	ПолеАудио = "";
	ПолеАудио = "<!DOCTYPE html><html><head></head><body><audio controls=""controls"" autoplay autobuffer=""autobuffer"" autoplay=""autoplay"">
  	  |<source src=""data:audio/wav;base64," + ПолучитьДанныеЗвука() + """></audio></body></html>";
КонецПроцедуры 

Функция ПолучитьДанныеЗвука() Экспорт
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ДД = ОбработкаОбъект.ПолучитьМакет("Kosti");
	
	Возврат Base64Строка(ДД);
КонецФункции 

&НаКлиенте
Процедура СделатьПаузу(мСек)
	МоментСтарт = ТекущаяУниверсальнаяДатаВМиллисекундах();
	МоментФиниш = МоментСтарт + мСек;
	
	Пока Истина Цикл
		Если ТекущаяУниверсальнаяДатаВМиллисекундах() > МоментФиниш Тогда
			Прервать;
		КонецЕсли;
			
	КонецЦикла;	  
КонецПроцедуры

&НаКлиенте
 Процедура ПолучениеПодземелья() ЭКСПОРТ
 	массивБанСписка = БанСписок.ВыгрузитьЗначения();
 	массивБанСписка.Добавить(ВыпавшееПодземелье);
 	
 	
 	ПараметрыПолучения = Новый Структура;
	ПараметрыПолучения.Вставить("Танк", ДляТанка);
	ПараметрыПолучения.Вставить("РежимПодбора", РежимПодбора);
	ПараметрыПолучения.Вставить("БанСписок", массивБанСписка);
	ПараметрыПолучения = Новый ФиксированнаяСтруктура(ПараметрыПолучения);
	ПараметрыПолучения_мод = новый Структура();
	
	ПутьККартинкеПодземелия = БроситьКубикиНаСервере(ПараметрыПолучения, ПараметрыПолучения_мод);
	
		
	Элементы.ИмяТанка.Заголовок = ?(ПараметрыПолучения_мод.Свойство("ИмяТанка"),ПараметрыПолучения_мод.ИмяТанка,"");
	Элементы.НазваниеПодземелья.Заголовок = ?(ПараметрыПолучения_мод.Свойство("НазваниеПодземелья"),ПараметрыПолучения_мод.НазваниеПодземелья,"");
	Элементы.ИмяСезона.Заголовок = ?(ПараметрыПолучения_мод.Свойство("ИмяСезона"),ПараметрыПолучения_мод.ИмяСезона,"");
	
	ВыпавшееПодземелье = ?(ПараметрыПолучения_мод.Свойство("ВыпавшееПодземелье"),ПараметрыПолучения_мод.ВыпавшееПодземелье,Неопределено);
	
	ФайлКартинки = новый Файл(ПутьККартинкеПодземелия);
	
	ТранзитныеПараметры = новый Структура;
	ТранзитныеПараметры.Вставить("ПутьКФайлу", ПутьККартинкеПодземелия);
	ОповещениеПроверкиФайла = новый ОписаниеОповещения("ВывестиКартинкуВПолеФормы_ПровереноСуществованиеФайла", ЭтаФорма, ТранзитныеПараметры);	
	ФайлКартинки.НачатьПроверкуСуществования(ОповещениеПроверкиФайла);
 	
 КонецПроцедуры	
 
 &НаСервереБезКонтекста
 Функция ПолучитьТекущийСезон()
 	Возврат Константы.WoW_ТекущийСезон.Получить(); 
 КонецФункции		

#КонецОбласти

/////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//////////////////////////////////Для удаления\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
/////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

#Область ДляУдаления

#КонецОбласти

////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////////
////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Для удаления/////////////////////////////
////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////////




















