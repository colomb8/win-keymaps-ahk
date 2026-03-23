# AHK Vim Mode + CapsLock Mod

Script AutoHotkey v2 che aggiunge una modalità di navigazione in stile Vim e alcune rimappature utili per l'uso quotidiano su Windows.

## Funzionalità

- CapsLock si comporta come Ctrl
- Ctrl + CapsLock attiva la modalità NORMAL
- Modalità INSERT e NORMAL con indicazione visiva
- Navigazione con tasti stile Vim (`h`, `j`, `k`, `l`, `w`, `b`, ecc.)
- Blocco dei tasti non consentiti in modalità NORMAL
- Inserimento rapido di lettere accentate tramite Right Alt
- Mapping di tasti funzione e altre scorciatoie personalizzate

## Modalità

### INSERT (default)
- Tastiera standard
- CapsLock = Ctrl

### NORMAL
- Navigazione:
  - `h` / `j` / `k` / `l` → frecce
  - `w` / `b` → movimento tra parole
  - `o` / `p` → inizio / fine riga
  - altri binding configurabili nello script
- I tasti non mappati vengono bloccati

## Lettere accentate

Lo script include un layer con `Right Alt` per inserire rapidamente alcuni caratteri accentati e simboli.

Esempi:
- `Right Alt + a` → `à`
- `Right Alt + e` → ciclo tra `è`, `é`, `€`
- `Right Alt + i` → `ì`
- `Right Alt + o` → `ò`
- `Right Alt + u` → `ù`

## Controlli principali

- `CapsLock` → Ctrl
- `Ctrl + CapsLock` → entra in NORMAL mode
- `i` → torna in INSERT mode

## Requisiti

- AutoHotkey v2.0

## Avvio automatico (opzionale)

Per avviare lo script automaticamente all'accesso:

1. Premi `Win + R`
2. Digita `shell:startup`
3. Inserisci lo script (o un collegamento) nella cartella

## Note

- CapsLock non attiva più il maiuscolo
- Alcuni comportamenti possono variare tra applicazioni diverse
- Alcune scorciatoie di sistema di Windows non sono intercettabili tramite AutoHotkey
- I mapping sono pensati per essere modificati facilmente direttamente nello script

