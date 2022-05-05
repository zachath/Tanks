# Inlämningsuppgift 2
## Grupp 7: Michael Foussianis & Zacharias Thorell

### Revideringar av programmet:
- Team1.pde, vi har lagt till 3 instanser AgentTank  vilka är våra agenter som samarbetar för att lösa problemet,
- Node.pde & Grid.pde & gui_functions.pde, små modifikationer för att noderna som tanken agerar på kan färgläggas,
- tanks_190324.pde, tanksen läggs till om content i grid så att de kan upptäckas genom att kolla på deras nod.
- Träden har tagits bort.

### Förutsättningar:
- Tanken känner till sin hembas (Alla noder i basen är automatiskt besökta),
- Tanken kan se andra tanks i närliggande noder (Alla riktningar) samt rakt fram i 5 noder,
- Tanken vill hellre gå till en nod där den själv eller någon tank i samma lag inte varit i förr,
- Tanken kan gå i alla riktningar (även diagonalt),
- Tanken patrullerar slumpmässigt tills den hittar en fiende tank,
- Därefter skickas en signal till laget om att alla ska ta sig hem, vilket räknas ut för varje indviduell tank med BFS,
- om kommunikationen ligger nere så kommer ingen signal skickas och tanken tar sig hem själv.

### Brister:
- Vägen hem tanken tar är inte garanterad att vara den kortaste,
- färgläggningen av vägen hem är lite trasig,
- tanks kan välja sammma nod som slutnod,
- Tanken stannar helt och fortsätter inte när den väl har kommit hem,
- Även om den gjorde det så skulle den inte undvika området där den redan hittat en fiende.

### Testning:
Eftersom vi inte använder oss av några separata bibliotek så borde det gå att köra som det kommer.
För att testa programmet kan man antingen låta Agent-Tanken gå slumpmässigt och vänta tills den har hittat
en fiende tank och låta den hitt hem. Om man inte har tid för det kan man ta över kontrollen med 'c' och 
gå själv genom att klicka på noder, men var noga med att endast gå till de närliggande noderna. I debug som
man kommer in i med 'd' så kan man se vilka noder tanken har besökt (grönt) och sett (gul), när den väl
har planerat en väg tillbaka så kan man se den vägen (de blåa noderna) samt slutnoden (den röda). För att testa nedbrytningen
av kommunkation så kan man trycka 'f' så stängs den av, för att sätta på den igen trycker man 'f' igen. För att kontrollera detta
kan man trycka 'p' som pausar spelet och ger information om varje tank, bland annat hur stor dess egna kunskap (graf) om världen är.

Github: [repo](https://github.com/zachath/Tanks/tree/Inlupp2).

s0da - Michael Foussianis

zachath -  Zacharias Thorell
