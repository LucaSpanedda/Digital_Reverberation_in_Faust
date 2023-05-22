# La Riverberazione Digitale

La riverberazione digitale è un argomento sempre attuale e ampiamente discusso nelgli ambiti della computer music e del Digital Signla Processing, e della musica elettroacustica in generale. Le sue applicazioni e gli studi in hanno coinvolto sia il settore commerciale che quello accademico. Di conseguenza, si è sviluppata nel tempo una storia complessa caratterizzata da numerose ramificazioni e implicazioni, che hanno portato a una proliferazione di diversi metodi e topologie di implementazione. In questo studio, approfondiremo in dettaglio l'argomento, esaminando le principali implementazioni esistenti

## Il Riverbero

Il riverbero è la persistenza di un suono dopo che un suono è stato prodotto.
è un fenomeno acustico legato alla riflessione dell'onda sonora da parte di un ostacolo posto davanti alla sorgente del suono.
Presupposti che determinano la percezione di un fenomeno di riverberazione:

1. L'orecchio umano non riesce a distinguere due suoni se essi sono percepiti a meno di 100 millisecondi di distanza uno dall'altro.
2. La velocità del suono nell'aria a 20 °C è di circa 340 m/s.
3. La fonte sonora e l'ascoltatore si trovano nello stesso punto di fronte all'ostacolo.

Dati questi presupposti, in uno spazio aperto si può parlare di riverbero quando l'ostacolo si trova a meno di 17 metri dalla fonte del suono. 
Infatti, fino a questa distanza, il percorso dell'onda sonora dalla fonte all'ostacolo e ritorno è inferiore a 34 metri 
e quindi il suono impiega meno di 100 millisecondi 
per tornare al punto di partenza confondendosi nell'orecchio dell'ascoltatore con il suono originario.
Se l'ostacolo si trova a più di 17 metri di distanza dalla fonte, 
allora il ritardo del suono riflesso rispetto al suono diretto è superiore ai 100 millisecondi e i due suoni risultano quindi distinti. 
In questo caso si parla di eco.

### La durata di un riverbero

I fattori che influenzano la durata di un riverbero sono molteplici.
Quelli più influenti sono:

1. La dimensione di una stanza
   
   - stanze più grandi producono riverberi più lunghi
   - piccole stanze producono riverberi corti

2. I materiali
   
   - materiali duri come creta e plastici riflettono di più il suono
   - i materiali morbidi come il legno assorbono molto di più il suono
   
   per questi motivi legati ai materiali una piccola stanza come il bagno ha tempi di riverberazione più lunghi
   di una grande stanza in legno.

Il miglior modo per ascoltare il riverbero di uno spazio riverberante è quello di produrre un suono impulsivo;
come un battito di mani o uno schiocco di dita.

### Il Riverbero nella musica

La musica ha fatto largo uso di riverberi per migliaia di anni.
Gli archeologi pensano che sin dall'antichità veniva utilizzato il riverbero prodotto dalle caverne nelle cerimonie.
Molte cattedrali in Europa hanno riverberi con una durata più lunga di 10 secondi, 
e la musica corale di certe ere funzionava particolarmente bene sfruttando il riverbero all'interno di queste cattedrali.
Infatti il riverbero delle singole note si sovrappone sulle note a seguito, trasformando una melodia monofonica in un suono polifonico.

### Le riflessioni

Una stanza standard ha 6 superfici:

- muro a destra
- muro a sinistra
- muro frontale
- muro dietro
- soffitto
- pavimento

un , nel momento in cui viene prodotto rimbalza sulle superfici e viene in seguito ascoltato
produrrà quelle che vengono chiamate

1. riflessioni del primo ordine

ognuna di queste produrrà altri 6 echo: 6 echo, ognuno rimbalzante sulle 6 superfici produrrà 36 echo;
queste vengono chiamate

2. riflessioni di secondo ordine

producendo nel totale 42 echo in un brevissimo periodo di tempo
e così via...
Di tutti questi echo non se ne percepisce nessuno singolarmente, 
ma piuttosto si percepisce il loro insieme e la dispersione di questi nel tempo.
Il riverbero è dunque composto da migliaia di echo 
del suono originale che persistono e decadono nel tempo

### I modelli di riverberazione artificiali

Il riverbero è artificiale quando non è presente nella stanza dove sta avvenendo la registrazione,
ma viene invece aggiunto in un secondo momento. 

1. Riverbero a nastro
   Si utilizza un particolare registratore/riproduttore a nastro magnetico che fa scorrere 
   a velocità costante un anello di nastro dentro una meccanica dotata di una testina di registrazione 
   fissa e di una di riproduzione mobile. 
   Il segnale registrato dalla prima testina viene letto dalla seconda e miscelato all'originale generando l'effetto. 
   Il tempo di ritardo dipende dalla distanza tra le due testine e permette di generare sia l'effetto riverbero sia l'effetto eco. 
   Questi apparecchi sono ingombranti e pesanti. Come in ogni registrazione a nastro, si ha un rumore di fondo simile a un fruscio, 
   nettamente superiore a quello prodotto con tecnologie digitali.

2. Riverbero a molla
   Il segnale viene fatto passare, tramite un trasduttore, 
   attraverso una spirale metallica (la molla). 
   All'altro capo della molla un trasduttore equivalente al primo reimmette il segnale nel circuito di amplificazione 
   miscelandolo a quello originale. 
   Il segnale prelevato dal secondo trasduttore risulta leggermente ritardato rispetto 
   a quello applicato al primo originando nell'orecchio dell'ascoltatore l'effetto del riverbero.

3. Riverbero a camera
   Sulla falsariga del riverbero a molla, in una scatola isolata acusticamente dall'esterno 
   viene inserito un tubo curvato in maniera da creare il percorso più lungo possibile. 
   Ad un'estremità del tubo viene posto un piccolo altoparlante mentre all'altra estremità c'è un microfono. 
   Il suono emesso dall'altoparlante impiegherà un certo tempo per percorrere tutto il tubo 
   ed arrivare al microfono generando così il ritardo necessario.

4. Riverbero digitale
   Il segnale analogico viene digitalizzato ed immagazzinato in banchi di memoria RAM 
   che viene utilizzata come la spirale metallica del riverbero a molla. 

## I Riverberi Digitali

Vengono prodotti da un computer o da circuiti integrati DSP dedicati.
Esistono sul mercato circuiti integrati che comprendono i convertitori A/D e D/A, 
le memorie ed i circuiti di temporizzazione. 
Un segnale acustico viene trasdotto e convertito in numeri che entrano dentro memorie,
Infatti i byte vengono fatti "scorrere" da un banco al successivo fino al raggiungimento dell'ultimo. 
Il segnale digitale prelevato dall'ultima memoria viene poi riconvertito in analogico e miscelato 
al segnale originale ottenendo l'effetto riverbero;
più lontano è il punto di lettura rispetto al punto di scrittura e più lungo sarà il tempo dell'echo.
la grandezza di queste memorie di lettura e scrittura è chiamata: linea di ritatdo, ed è espressa in campioni.
La grande capacità delle memorie RAM permette di raggiungere anche ritardi 
di parecchi secondi e quindi passare agevolmente da riverbero a eco. 
La strategia utilizzata in seguito è quella di retroazionare l'output della linea di ritardo sommandola all'input,
creando così un circuito di feedback.
Tutto questo processo viene fatto poichè i computer moderni sono molto potenti, 
ma non sono ancora abbastanza potenti da essere in grado di generare tutte le riflessioni 
ascoltate in una grande stanza, una per una.
Piuttosto l'obiettivo di creare riverberi digitali è quello di implementare modelli e strategie
per replicare l'impressione della riverberazione di una stanza.
Il processo di replica ha generato nella storia dei riverberi digitali veri e propri suoni tipici differenti fra loro
che possono essere implementati e preferiti dai musicisti per ragioni estetiche.

# La Riverberazione Digitale in FAUST

Esperimenti e algoritmi di modelli di riverberazione digitale in linguaggio FAUST (GRAME)

## Le linee di ritardo in Faust

Le linee di ritardo in Faust si suddividono nelle seguenti categorie:
mem - indica un solo campione di ritardo
@ - indica un numero (ex. 44100) di campioni di ritardo variabile
x'- x indica un qualsiasi ingresso e: ' un campione di ritardo, ''(2), ecc.
rdtable - indica una tabella di sola lettura
rwtable - indica una tabella di scrittura e lettura.

Tramite le linee di ritardo
possiamo creare un impulso di Dirac, che rappresenta 
la nostra unità minima, ovvero il singolo campione
mettendo un numero 1 e sottraendo da esso lo stesso valore
ma facendolo ad un campione di ritardo. 

esempio:

```
// IMPULSO DI DIRAC tramite linea di ritardo
// Importo la libreria
import("stdfaust.lib");


// Impulso di Dirac
dirac = 1-1';
// Process
process = dirac, dirac;
```

## Alcuni metodi per implementare circuiti ricorsivi nel linguaggio Faust

Illustreremo 3 Metodi principali:

- Scrivere la riga di codice con recorsività interne:
  
  in questo modo l'operatore tilde ~ manda il segnale
  in uscita all'interno di se stesso, al primo ingresso
  disponibile. Creando un circuito di retroazione (feedback).
  Un modo per forzare l'operatore a puntare in un certo punto
  del codice, è mettere le parentesi (), in questo modo ~
  punterà all'ingresso prima della parentesi.

- Un secondo metodo consiste nell'utilizzo del with{} .
  
  Si può definire una funzione in cui vengono passati
  i vari argomenti della funzione che controllano 
  i paramteri del codice,
  e dire che quella funzione è uguale a
  uscita dal with con ~ _
  esempio:
  
      funzione_with(argomento1, argomento2) = out_with ~ _
       with{  
        sezione1 = _ * argomento1;
        sezione2 = argomento1 * argomento2;
        out_with = sezione2;
        };
      
        dove out_with ~ _ rientra in se stesso.

Inoltre il with in Faust permette di dichiarare delle variabili
che non vengono puntate dall'esterno del codice ma solo
dalla funzione di appartenenza; in questo caso
la funzione a cui appartiene il with è "funzione_with".

- Un terzo metodo è utilizzare l'ambiente letrec.
  
  con questo metodo possiamo scrivere un segnale
  in modo ricorsivo, in modo simile a come vengono
  scritte le equazioni di ricorrenza.
  
  esempio:
  
  ```
  Importo la libreria standard di FAUST
   import("stdfaust.lib");
  
  // metodo con letrec:
   // funzione
   lowpass(cf, x) = y
   // definizione letrec
   letrec {
   'y = b0 * x - a1 * y;
   }
   // cosa contiene il letrec
   with {
   b0 = 1 + a1;
   a1 = exp(-w(cf)) * -1;
   w(f) = 2 * ma.PI * f / ma.SR;
   };
  
  // Uscita della funzione ricorsiva scritta con letrec
   process = lowpass;
  ```

## Conversione Millisecondi in Campioni e viceversa

### Conversione Millisecondi in Campioni

Funzione Conversione Campioni in ms. :
inserisco il tempo in Millisecondi,
e la funzione mi tira fuori il valore in Campioni.

Ad esempio, se ho una frequenza di campionamento 
di 48.000 campioni al secondo, 
vuole dire che 1000ms (1 secondo) sono rappresentati
da 48.000 parti, e che quindi una singola unità
temporale come 1 ms. Corrisponde in digitale a 48 campioni.

Per questo motivo si divide la frequenza di campionamento
per 1000ms avendo dunque in risultato un tot. di campioni
che corrisponde ad 1 ms. nel mondo digitale ad 
una determinata frequenza di campionamento.

E poi si moltiplica il risultato di questa operazione
per il totale di ms. che vogliamo ottenere come 
rappresentazione in campioni.
Se moltiplico *10. Ad esempio avrò in uscita 
dalla funzione, 480 campioni ad una frequenza di campionamento 
di 48.000 campioni al secondo.

```
// (t) = give time in milliseconds we want to know in samples
msasamps(t) = (ma.SR / 1000.) * t;

process = _;
```

### Conversione Campioni in Millisecondi

Funzione Conversione ms. in Campioni :
inserisco un totale di campioni,
di cui mi serve di sapere la durata complessiva
in millisecondi basandomi sulla mia frequenza di campionamento.

Sappiamo che una frequenza di campionamento
corrisponde ad un insieme di valori che esprimono 
nel loro insieme la durata di 1 secondo (1000 ms.).

Vuole dire ad esempio,
che ad una frequenza di campionamento di 48.000
campioni al secondo, 
ho 1000 millisecondi rappresentati da 48.000 parti.
E dunque se divido i miei 1000ms. / 
nelle 48.000 parti che sarebbero i campioni del mio sistema,
otterrei la durata in millisecondi di un singolo campione
a quella frequenza di campionamento,
in questo caso dunque: 
1000 / 48.000 = 0,02ms. 
E dunque la durata in millisecondi di un singolo campione a 48.000
campioni al secondo, è di 0,02 millisecondi.
se moltiplico il numero ottenuto *
un totale di campioni, otterrò il tempo in millisecondi
di quei campioni per quella frequenza di campionamento usata.

Ovviamente come si può dedurre dalle considerazioni,
all'incrementare della frequenza di campionamento 
corrisponde una durata temporale più piccola del singolo campione,
e dunque una definizione maggiore.

```
// (samps) = give tot. samples we want to know in milliseconds
sampsams(samps) = ((1000 / ma.SR) * samps);

process = _;
```



## Messa in Fase della Retroiniezione

nel dominio digitale la retroazione di una 
linea di ritardo, nel momento in cui viene
applicata, costa di default un campione di ritardo.
Retroazione = 1 Campione 

Nel momento in cui decido dunque di porre 
all'interno della retroazione un numero 
di campioni di ritardo,
possiamo prendere ad esempio 10 campioni
nella nostra linea di ritardo, vuole dire che,
Il segnale diretto uscirà per ritardo campioni a:

ingresso nel delay segnale --> uscita dal delay 10samp

Il 1° Ricircolo:
uscita dal delay a 10samp + 1 retroazione = 
ingresso nel delay 11samp --> uscita dal delay 21samp

Il 2° Ricircolo:
uscita dal delay a 21samp + 1 retroazione = 
ingresso nel delay 22samp --> uscita dal delay 32samp

Il 3° Ricircolo:
uscita dal delay a 32samp + 1 retroazione = 
ingresso nel delay 33samp --> uscita dal delay 43samp

e così via...

possiamo dunque notare da subito che non avremo
il corretto valore di ritardo richiesto all'interno della stessa,
a causa del campione di ritardo che avviene nel momento
in cui decido di creare un circuito di retroazione.
se utilizziamo il metodo di sottrarre un campione dalla linea 
di ritardo, avremo questo risultato:

ingresso nel delay segnale --> -1, uscita dal delay 9samp

Il 1° Ricircolo:
uscita dal delay a 9samp + 1 retroazione = 
ingresso nel delay 10samp --> -1, uscita dal delay 19samp

Il 2° Ricircolo:
uscita dal delay a 19samp + 1 retroazione = 
ingresso nel delay 20samp --> -1, uscita dal delay 29samp

Il 3° Ricircolo:
uscita dal delay a 29samp + 1 retroazione = 
ingresso nel delay 30samp --> -1, uscita dal delay 39samp

e così via...

possiamo dunque notare che con questo metodo,
rispetto al precedente avremo in ingresso alla linea di ritardo
sempre il numero di campioni di ritardo richiesti.
Ma notiamo che sin dalla prima uscita del segnale ritardato
sottraendo -1 abbiamo in out un campione di ritardo
in meno rispetto a quanto vorremmo.
Per rimettere in fase il tutto, basterà sommare un campione di ritardo
all'uscita complessiva del circuito, avendo così sin dal primo out:

ingresso nel delay segnale --> -1, uscita dal delay 9samp +1 = 10out

Il 1° Ricircolo:
uscita dal delay a 9samp + 1 retroazione = 
ingresso nel delay 10samp --> -1, uscita dal delay 19samp +1 = 20out

e così via...



Procediamo con una implementazione:

```
campioni_ritardo = ma.SR; 
// frequenza campionamento

process =   _ : 
            // segnale in input entra in
            +~ @(campioni_ritardo -1) *(0.8) 
            // linea ritardo con feedback: +~
            : mem;
            // uscita entra in campione singolo ritardo
```



## Decadimento T60

Il termine "T60" nell'ambito della riverberazione digitale si riferisce al tempo di riverberazione. Il tempo di riverberazione è una misura della durata con cui il suono persiste in un ambiente dopo che la sorgente sonora è stata interrotta. Indica quanto velocemente l'energia sonora diminuisce nel tempo.

Il valore T60 rappresenta il tempo richiesto affinché il livello sonoro del suono si riduca di 60 decibel (dB) rispetto al suo valore iniziale. In altre parole, è il tempo impiegato perché l'energia sonora si attenui di 60 dB. Un T60 lungo indica una riverberazione prolungata, mentre un T60 breve indica una riverberazione più breve.



La formula esposta di seguito utilizza la relazione tra il tempo di decadimento T60 e il numero di campioni del filtro per calcolare il guadagno di amplificazione necessario. Il risultato del calcolo è un valore lineare compreso tra 0 e 1, che rappresenta l'amplificazione da applicare alla retroazione del filtro.

Inserisci all'interno degli argomenti della funzione:



- il valore in campioni del filtro 
  che stai usando per il ritardo.
  
  

- il valore di decadimento in T60
  (tempo di decadimento di 60 dB in secondi)
  
  

- = OTTIENI in uscita dalla funzione, 
  il valore che devi passare come amplificazione
  alla retroazione del filtro per ottenere
  il tempo di decadimento T60 che si desidera
  
  ```
  // (samps,seconds) = give: samples of the filter, seconds we want for t60 decay
  dect60(samps,seconds) = 1/(10^((3*(((1000 / ma.SR)*samps)/1000))/seconds));
  
  
  process = _;
  ```



# Topologie e design dei Riverberi Digitali

## Testi

- Manfred Schroeder, “Natural Sounding Artificial Reverb,” 1962. 

- Michael Gerzon, “Synthetic Stereo Reverberation,” 1971. 

- James (Andy) Moorer, “About This Reverberation Business,” 1979

- Christopher Moore, “Time-Modulated Delay System and Improved Reverberation Using Same,” 1979. 

- John Stautner and Miller Puckette, “Designing Multichannel Reverberators,” 1982. 

- Jon Dattorro, “Effect Design - Part 1: Reverberator and Other Filters,” 1997.

- Jean-Marc Jot, “Efficient models for reverberation and distance rendering in computer music and virtual audio reality,” 1997. 

- D. Rochesso, “Reverberation,” DAFX - Digital Audio Effects, Udo Zölzer, 2002.
  
  ## Topologie
  
  - Manfred Schroeder propone l'applicazione di una rete di allpass e comb filters.
  - James Moorer implementa un filtro lowpass all'interno della retroazione dei comb.
  - Christopher Moore propone linee di ritardo modulate nel tempo e uscite Multi-tap da modelli delle early relfection.
  - William Martens e Gary Kendall propongono delle early reflection spazializzate.
  - Michael Gerzon, John Stautner & Miller Puckette propongono le Feedback Delay Network (mixer a matrice per i feedback).
  - David Griesinger propone un singolo Loop di Feedback utilizzando ritardi e filtri allpass.

# Referenze principali

Introduction to Digital Filters: 
With Audio Applications.
Libro di Julius O. Smith III.
Links alla serie di Libri di Smith:

- Mathematics of the Discrete Fourier Transform (DFT)
- Introduction to Digital Filters
- Physical Audio Signal Processing
- Spectral Audio Signal Processing
  sulla pagina CCRMA di J.Smith https://ccrma.stanford.edu/~jos/fp/ su DSP Related [Free DSP Books](https://www.dsprelated.com/freebooks.php)

TOM ERBE - UC SAN DIEGO - REVERB TOPOLOGIES AND DESIGN http://tre.ucsd.edu/wordpress/wp-content/uploads/2018/10/reverbtopo.pdf

ARTIFICIAL REVERBERATION: su DSPRELATED [Artificial Reverberation | Physical Audio Signal Processing](https://www.dsprelated.com/freebooks/pasp/Artificial_Reverberation.html)

Corey Kereliuk - Building a Reverb Plugin in Faust
Keith Barr’s reverb architecture http://blog.reverberate.ca/post/faust-reverb/

Spin Semiconductor DSP Basics [Spin Semiconductor - DSP Basics](http://www.spinsemi.com/knowledge_base/dsp_basics.html) Spin Semiconductor Audio Effects [Spin Semiconductor - Effects](http://www.spinsemi.com/knowledge_base/effects.html#Reverberation)

freeverb3vst - Reverb Algorithms Tips http://freeverb3vst.osdn.jp/tips/reverb.shtml

History of allpass loop / "ring" reverbs [History of allpass loop / &quot;ring&quot; reverbs? - Spin Semiconductor](http://www.spinsemi.com/forum/viewtopic.php?p=555&sid=5d31391b3883f1b9e013d5af80805019)

Musical Applications of Microprocessors (The Hayden microcomputer series) http://sites.music.columbia.edu/cmc/courses/g6610/fall2016/week8/Musical_Applications_of_Microprocessors-Charmberlin.pdf

Acustica_Riverbero - Alfredo Ardia [Appunti: acustica_Riverbero](http://appuntimusicaelettronica.blogspot.com/2012/10/acusticariverbero.html)

Algorithmic Reverbs: The Moorer Design [Algorithmic Reverbs: The Moorer Design | flyingSand](https://christianfloisand.wordpress.com/2012/10/18/algorithmic-reverbs-the-moorer-design/)

Dattorro Convex Optimization of a Reverberator [Dattorro Convex Optimization of a Reverberator - Wikimization](https://www.convexoptimization.com/wikimization/index.php/Dattorro_Convex_Optimization_of_a_Reverberator)

Tabella dei numeri primi inferiori a 10.000 https://www.matematika.it/public/allegati/34/Numeri_primi_minori_di_10000_1_3.pdf

Introduction to Digital Filters: 
With Audio Applications.
Libro di Julius O. Smith III.
Links alla serie di Libri di Smith:

- Mathematics of the Discrete Fourier Transform (DFT)
- Introduction to Digital Filters
- Physical Audio Signal Processing
- Spectral Audio Signal Processing
  sulla pagina CCRMA di J.Smith https://ccrma.stanford.edu/~jos/fp/ su DSP Related [Free DSP Books](https://www.dsprelated.com/freebooks.php)

TOM ERBE - UC SAN DIEGO - REVERB TOPOLOGIES AND DESIGN http://tre.ucsd.edu/wordpress/wp-content/uploads/2018/10/reverbtopo.pdf

ARTIFICIAL REVERBERATION: su DSPRELATED [Artificial Reverberation | Physical Audio Signal Processing](https://www.dsprelated.com/freebooks/pasp/Artificial_Reverberation.html)

Corey Kereliuk - Building a Reverb Plugin in Faust
Keith Barr’s reverb architecture http://blog.reverberate.ca/post/faust-reverb/

Spin Semiconductor DSP Basics [Spin Semiconductor - DSP Basics](http://www.spinsemi.com/knowledge_base/dsp_basics.html) Spin Semiconductor Audio Effects [Spin Semiconductor - Effects](http://www.spinsemi.com/knowledge_base/effects.html#Reverberation)

freeverb3vst - Reverb Algorithms Tips http://freeverb3vst.osdn.jp/tips/reverb.shtml

History of allpass loop / "ring" reverbs http://www.spinsemi.com/forum/viewtopic.php?p=555&sid=5d31391b3883f1b9e013d5af80805019

Musical Applications of Microprocessors (The Hayden microcomputer series) http://sites.music.columbia.edu/cmc/courses/g6610/fall2016/week8/Musical_Applications_of_Microprocessors-Charmberlin.pdf

Acustica_Riverbero - Alfredo Ardia [Appunti: acustica_Riverbero](http://appuntimusicaelettronica.blogspot.com/2012/10/acusticariverbero.html)

Algorithmic Reverbs: The Moorer Design [Algorithmic Reverbs: The Moorer Design | flyingSand](https://christianfloisand.wordpress.com/2012/10/18/algorithmic-reverbs-the-moorer-design/)

Dattorro Convex Optimization of a Reverberator [Dattorro Convex Optimization of a Reverberator - Wikimization](https://www.convexoptimization.com/wikimization/index.php/Dattorro_Convex_Optimization_of_a_Reverberator)

Tabella dei numeri primi inferiori a 10.000 https://www.matematika.it/public/allegati/34/Numeri_primi_minori_di_10000_1_3.pdfReferenze principali

Introduction to Digital Filters: 
With Audio Applications.
Libro di Julius O. Smith III.
Links alla serie di Libri di Smith:

- Mathematics of the Discrete Fourier Transform (DFT)
- Introduction to Digital Filters
- Physical Audio Signal Processing
- Spectral Audio Signal Processing
  sulla pagina CCRMA di J.Smith https://ccrma.stanford.edu/~jos/fp/ su DSP Related [Free DSP Books](https://www.dsprelated.com/freebooks.php)

TOM ERBE - UC SAN DIEGO - REVERB TOPOLOGIES AND DESIGN http://tre.ucsd.edu/wordpress/wp-content/uploads/2018/10/reverbtopo.pdf

ARTIFICIAL REVERBERATION: su DSPRELATED [Artificial Reverberation | Physical Audio Signal Processing](https://www.dsprelated.com/freebooks/pasp/Artificial_Reverberation.html)

Corey Kereliuk - Building a Reverb Plugin in Faust
Keith Barr’s reverb architecture http://blog.reverberate.ca/post/faust-reverb/

Spin Semiconductor DSP Basics [Spin Semiconductor - DSP Basics](http://www.spinsemi.com/knowledge_base/dsp_basics.html) Spin Semiconductor Audio Effects [Spin Semiconductor - Effects](http://www.spinsemi.com/knowledge_base/effects.html#Reverberation)

freeverb3vst - Reverb Algorithms Tips http://freeverb3vst.osdn.jp/tips/reverb.shtml

History of allpass loop / "ring" reverbs http://www.spinsemi.com/forum/viewtopic.php?p=555&sid=5d31391b3883f1b9e013d5af80805019

Musical Applications of Microprocessors (The Hayden microcomputer series) http://sites.music.columbia.edu/cmc/courses/g6610/fall2016/week8/Musical_Applications_of_Microprocessors-Charmberlin.pdf

Acustica_Riverbero - Alfredo Ardia http://appuntimusicaelettronica.blogspot.com/2012/10/acusticariverbero.html

Algorithmic Reverbs: The Moorer Design [Algorithmic Reverbs: The Moorer Design | flyingSand](https://christianfloisand.wordpress.com/2012/10/18/algorithmic-reverbs-the-moorer-design/)

Dattorro Convex Optimization of a Reverberator [Dattorro Convex Optimization of a Reverberator - Wikimization](https://www.convexoptimization.com/wikimization/index.php/Dattorro_Convex_Optimization_of_a_Reverberator)

Tabella dei numeri primi inferiori a 10.000 https://www.matematika.it/public/allegati/34/Numeri_primi_minori_di_10000_1_3.pdf 
