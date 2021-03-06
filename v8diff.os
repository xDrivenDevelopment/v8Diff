///////////////////////////////////////////////////////////////////
//
// Выполняет сравнение внешних бинарных файлов 1С (внешние обработки, отчеты, конфигурации
//
///////////////////////////////////////////////////////////////////

#Использовать cmdline
#Использовать "src"

Перем Лог;
Перем ВыполняемаяКоманда;
Перем ЗначенияПараметров;

/////////////////////////////////////////////////////////////////////////////////////////

Процедура ВывестиВерсию()
	
	Сообщить("v8Diff v" + ПараметрыСистемы.ВерсияПродукта());
	
КонецПроцедуры // ВывестиВерсию()

Функция ПолучитьПарсерКоманднойСтроки()

    Парсер = Новый ПарсерАргументовКоманднойСтроки();
    
    МенеджерКомандПриложения.ЗарегистрироватьКоманды(Парсер);
    
    Возврат Парсер;

КонецФункции

Функция ПолезнаяРабота()
	ВывестиВерсию();

    ПараметрыЗапуска = РазобратьАргументыКоманднойСтроки();

    Если ПараметрыЗапуска = Неопределено или ПараметрыЗапуска.Количество() = 0 Тогда
        Лог.Ошибка("Некорректные аргументы командной строки");
        МенеджерКомандПриложения.ПоказатьСправкуПоКомандам();
        Возврат МенеджерКомандПриложения.РезультатыКоманд().ОшибкаВремениВыполнения;
    КонецЕсли;

    Если ТипЗнч(ПараметрыЗапуска) = Тип("Структура") Тогда
        // это команда
        ВыполняемаяКоманда            = ПараметрыЗапуска.Команда;
        ЗначенияПараметров = ПараметрыЗапуска.ЗначенияПараметров;
    ИначеЕсли ЗначениеЗаполнено(ПараметрыСистемы.ИмяКомандыПоУмолчанию()) Тогда
        // это команда по-умолчанию
        ВыполняемаяКоманда            = ПараметрыСистемы.ИмяКомандыПоУмолчанию();
        ЗначенияПараметров = ПараметрыЗапуска;
    Иначе
        ВызватьИсключение "Некорректно настроено имя команды по-умолчанию.";
    КонецЕсли;
    
    Возврат МенеджерКомандПриложения.ВыполнитьКоманду(ВыполняемаяКоманда, ЗначенияПараметров);
    
КонецФункции

Функция РазобратьАргументыКоманднойСтроки()
    Парсер = ПолучитьПарсерКоманднойСтроки();
    Возврат Парсер.Разобрать(АргументыКоманднойСтроки);
КонецФункции

/////////////////////////////////////////////////////////////////////////

Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы());
МенеджерКомандПриложения.РегистраторКоманд(ПараметрыСистемы);

Попытка
    КодВозврата = ПолезнаяРабота();

Исключение
    Лог.КритичнаяОшибка(ОписаниеОшибки());

	Сообщить("Нажмите любой символ для завершения ...");
	Консоль = Новый Консоль;
	Консоль.Прочитать();

    КодВозврата = МенеджерКомандПриложения.РезультатыКоманд().ОшибкаВремениВыполнения;
КонецПопытки;

ВременныеФайлы.Удалить();
ЗавершитьРаботу(КодВозврата);
