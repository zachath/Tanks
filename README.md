# Inlämningsuppgift 1
## Grupp 7: Michael Foussianis & Zacharias Thorell

### Revideringar av programmet:
- Team1.pde, vi har lagt till AgentTank  vilket är vår agent för att lösa problemet,
- Node.pde & Grid.pde & gui_functions.pde, små modifikationer för att noderna som tanken agerar på kan färgläggas,
- tanks_190324.pde, tanksen läggs till om content i grid så att de kan upptäckas genom att kolla på deras nod.

### Förutsättningar:
- Tanken känner till sin hembas (Alla noder i basen är automatiskt besökta),
- Tanken kan se andra tanks i närliggande noder (Alla riktningar),
- Tanken vill hellre gå till en nod den inte varit i förr,
- Tanken kan gå i alla riktningar (även diagonalt),
- Tanken patrulerar slumpmässigt tills den hittar en fiende tank,
- Därefter tar den sig efter den väg den räknat ut med BFS, baserat på där den tidigare varit

### Brister:
- Sökalgoritmen tar inte hänsyn till träd,
- Kollisioner med träd kan orsaka att tanken fastnar,
- Vägen hem tanken tar är inte garanterad att vara den kortaste,
- Tanken stannar helt och fortsätter inte när den väl har kommit hem,
- Även om den gjorde det så skulle den inte undvika området där den redan hittat en fiende.

### Testning:
Eftersom vi inte använder oss av några separata bibliotek så borde det gå att köra som det kommer.
För att testa programmet kan man antigen låta Agent-Tanken gå slumpmässigt och vänta tills den har hittat
en fiende tank och låta den hitt hem. Om man inte har tid för det kan man ta över kontrollen med 'c' och 
gå själv genom att klicka på noder, men var noga med att endast gå till de närliggande noderna. I debug som
man kommer in i med 'd' så kan man se vilka noder tanken har besökt (grönt) och sett (gul), när den väl
har planerat en väg tillbaka så kan man se den vägen (de blåa noderana) samt slutnoden (den röda).

Github: [repo](https://github.com/zachath/Tanks).

s0da - Michael Foussianis

zachath -  Zacharias Thorell
