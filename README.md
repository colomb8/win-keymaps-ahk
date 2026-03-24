# AHK Vim Mode + CapsLock Mod

Script AutoHotkey v2 che aggiunge una modalità di navigazione in stile Vim e alcune rimappature utili per tastiere 60%. Progettato per ambiente Windows ma facilmente adattabile ad altri sistemi.

## Funzionalità

- Modalità modale per gestire tastiere 60% e/o usare alcune vim motion senza lasciare la home row; indicazione visiva della modalità tramite popup non invasivo
- Inserimento rapido di lettere accentate tramite Right Alt come layer
Per ergonomia:
- CapsLock mappato su Ctrl
- Backtick mappato su Esc

## Modalità

### INSERT (default)
- Tastiera standard
- `Ctrl + CapsLock` attiva la modalità NORMAL (aka vimMode)

### NORMAL
- Navigazione:
  - `h` / `j` / `k` / `l` → frecce
  - `w` / `b` → movimento tra parole
  - `o` / `p` → inizio / fine riga
  - altri binding configurabili nello script
- in NORMAL, si torna in INSERT con `i`, `a`
- per la lista completa di mapping, consultare il blocco
```autohotkey
#HotIf vimMode
...
```
- I tasti non mappati vengono bloccati e l'utente è avvisato tramite popup non invasivo

## Immissione caratteri speciali

L'idea è di avere `Righ Alt` come tasto standard per accedere ad altri caratteri (layer). Un ciclatore permette di inserire rapidamente alcuni caratteri accentati e simboli. Consultare la mappa per visionare la lista completa e/o aggiungere caratteri personalizzati.

Esempi:
- `Right Alt + a` → `à`
- `Right Alt + e` → ciclo tra `è`, `é`, `€`
- `Right Alt + i` → `ì`
- `Right Alt + o` → `ò`
- `Right Alt + u` → `ù`

## Requisiti

- Windows
- AutoHotkey v2.0

## Avvio automatico (opzionale)

Per avviare lo script automaticamente all'accesso:

1. Premi `Win + R`
2. Digita `shell:startup`
3. Inserisci lo script (o un collegamento) nella cartella

## Note

- CapsLock non attiva più il maiuscolo. Rimappato su `Right Alt + CapsLock`
- Alcune scorciatoie di sistema di Windows non sono intercettabili tramite AutoHotkey (e.g. WinL)
- I mapping sono pensati per essere modificati facilmente direttamente nello script
