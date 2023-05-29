# SMEV-Works

XSL Transformation of an incoming Request.xml into its response XML +
printable HTML/TEXT.

Формирование с помощью XSLT подтверждения на получение файла XML из Адаптера
СМЭВ для отправки ответного XML обратно + формирование печатного бланка в
формате HTML или TEXT. Образцы можно посмотреть здесь - XslTrans/samples/save

В комплекте прилагаются эталонный образец `in\SampleRequest.xml` и XSLT для
вида сведений ФНС 313-19 "Сведения о снятии физического лица с учета...":

- *'313-19.xslt'* для формирования ответного response XML с помощью
пользовательских скриптов.
- *'313-19a.xslt'* для формирования ответного response XML с помощью
параметров XSLT без использования скриптов.
- *'313-19p.xslt'* для формирования печатного бланка в формате HTML.
- *'313-19t.xslt'* для формирования печатного бланка в формате TEXT.

Файлы в кодировке utf8 формируются без BOM (нетипично для XSLT), который
не позволен в СМЭВ.

## Usage

Выходной файл зависит от значения метода вывода `<xsl:output method='*'/>`
в файле XSLT:

- *'xml'* (по умолчанию):  
`XslTrans.exe Request.xml Trans.xslt [Request.response.xml]`
- *'html'*:  
`XslTrans.exe Request.xml Trans.xslt [Request.html]`
- *'text'*:  
`XslTrans.exe Request.xml Trans.xslt [Request.txt]`

Если третий параметр не указан, будет создан файл в папке исходного файла
с изменением его расширения в зависимости от указанного метода вывода в
указанном вторым параметром файле XSLT.

Если третий параметр указан, то:

- если указано имя файла с путем - будут созданы все папки этого пути;
- если указано имя существующей папки - в ней будет создан файл с именем
исходного файла;
- если указано имя несуществующей папки с `\` на конце - будет создана
эта папка и в ней будет создан файл с именем исходного файла;
- если вместо имени `guid` или `{guid}`, то при использовании XSLT с
параметрами будет подставлено в имя файла значение `client_id`.

Коды возврата:

- `0`: Преобразование успешно выполнено.
- `1`: Ошибка в числе параметров - показ Usage.
- `2`: Не найден указанный в параметрах исходный файл (XML или XSLT).

## Examples

- `XslTrans.exe in\SampleRequest.xml XSLT\313-19.xslt`  
делает *'in\SampleRequest.response.xml'* для передачи обратно (по умолчанию).
- `XslTrans.exe in\SampleRequest.xml XSLT\313-19.xslt out\Response.xml`  
делает *'out\Response.xml'* для передачи обратно (файл указан).
- `XslTrans.exe in\SampleRequest.xml XSLT\313-19a.xslt out\Guid.xml`  
делает *'out\36a96404-df69-...89.xml'* для передачи обратно (файл указан  
как `guid`, будет подставлено значение поля `client_id` без скобок).
- `XslTrans.exe in\SampleRequest.xml XSLT\313-19a.xslt out\{Guid}.xml`  
делает *'out\{36a96404-df69-...89}.xml'* для передачи обратно (файл указан  
как `{guid}`, будет подставлено значение поля `client_id` со скобками).
- `XslTrans.exe in\SampleRequest.xml XSLT\313-19p.xslt`  
делает *'in\SampleRequest.html'* для печати (по умолчанию).
- `XslTrans.exe in\SampleRequest.xml XSLT\313-19p.xslt Request-print.htm`  
делает *'Request-print.htm'* для печати (файл указан).
- `XslTrans.exe in\SampleRequest.xml XSLT\313-19t.xslt save\Request.txt`  
делает *'save\Request.txt'* для сохранения/печати в формате TEXT
(файл указан).
- `XslTrans.exe in\SampleRequest.xml XSLT\313-19t.xslt save`  
делает *'save\SampleRequest.txt'* (файл не указан, но есть такая папка).
- `XslTrans.exe in\SampleRequest.xml XSLT\313-19t.xslt save\2023\`  
делает *'save\2023\SampleRequest.txt'* (указано создать такую папку).

## Requirements

- .Net Framework 4.8 (возможно, и ниже - не тестировалось).

## License

Licensed under the [Apache License, Version 2.0].

[Apache License, Version 2.0]: LICENSE
