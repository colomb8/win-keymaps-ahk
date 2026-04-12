
; Author: Dario Colombotto
; US Layout

#Requires AutoHotkey v2.0

; ======== Gui per Popup ================================

global modeGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
modeGui.SetFont("s15", "Segoe UI")

global modeText := modeGui.AddText("cBlack w120 Center", " INSERT ")

ShowPopup(text)
{
  global modeGui, modeText

  ; padding
  modeText.Value := " " text " "

  ; colori dinamici
  switch text
  {
    case "NORMAL":
      modeGui.BackColor := "FF9700"
    case "INSERT":
      modeGui.BackColor := "A4E400"
    case "NOP":
      modeGui.BackColor := "FC1A70"
    default:
      modeGui.BackColor := "White"
  }

  ; calcolo dimensione
  modeGui.Show("AutoSize NoActivate")

  WinGetPos(, , &w, &h, modeGui.Hwnd)

  x_margin := 5
  y_margin := 65
  x := x_margin
  y := A_ScreenHeight - h - y_margin

  modeGui.Show("x" x " y" y " NoActivate")
}

HidePopup()
{
  global modeGui
  modeGui.Hide()
}

Popup(text)
{
  ShowPopup(text)
  SetTimer(HidePopup, -700)
}

; =======================================================

global vimMode := false   ; insert all'avvio

SetVimMode(mode)
{
  global vimMode
  vimMode := mode
  Popup(vimMode ? "NORMAL" : "INSERT")
}

BlockKeys()
{
  global vimMode

  HotIf((*) => vimMode)
    for key in StrSplit(
      "qwertyuiop"
      "asdfghjkl"
      "zxcvbnm"
      )
      {
        Hotkey(key, (*) => (Popup("NOP"), 0))
        Hotkey("+" key, (*) => (Popup("NOP"), 0))
      }
    for key in StrSplit(
      "`1234567890-="
      "[]\"
      ";'"
      ",./"
      ; shift
      "~!@#$%^&*()_+"
      "{}|"
      ":"
      "<>?"
      )
      {
        Hotkey(key, (*) => (Popup("NOP"), 0))
      }
    for key in [
      "Space",
      "Enter",
      "Tab",
      "Backspace",
      "Del",
      ]
      {
        Hotkey(key, (*) => (Popup("NOP"), 0))
      }

  HotIf()
}

BlockKeys()

#HotIf vimMode

  ; Per qualche motivo oscuro mappando con Send
  ; sovrascrive la logica dei BlockKeys,
  ; invece mappando normalmente (es. h::Left)
  ; non la sovrascrive e va implementata la whitelist.
  ; con Send invece ci evitiamo la whitelist.
  ; Send però richiede di mappare esplicitamente  Ctrl, Shift, etc

  ; nota:
  ; non si può mappare C-qualcosa su qualcosa non C-
  ; bug-feature:
  ;   con Ctrl: manda come impostato
  ;   con CapsLock: manda Ctrl + come impostato

  ; frecce
  h::Send("{Left}")
  j::Send("{Down}")
  k::Send("{Up}")
  l::Send("{Right}")
  +h::Send("+{Left}")
  +j::Send("+{Down}")
  +k::Send("+{Up}")
  +l::Send("+{Right}")
  ^h::Send("^{Left}")
  ^j::Send("^{Down}")
  ^k::Send("^{Up}")
  ^l::Send("^{Right}")
  !h::Send("!{Left}")
  !j::Send("!{Down}")
  !k::Send("!{Up}")
  !l::Send("!{Right}")
  ^+h::Send("^+{Left}")
  ^+j::Send("^+{Down}")
  ^+k::Send("^+{Up}")
  ^+l::Send("^+{Right}")
  ; #h::Send("#{Left}") ; conflitto con funzionalità Win
  #j::Send("#{Down}")
  #k::Send("#{Up}")
  ; #l::Send("#{Right}") ; conflitto con funzionalità Win

  ; words jumps
  w::Send("^{Right}")
  b::Send("^{Left}")
  +w::Send("^+{Right}")
  +b::Send("^+{Left}")

  ; pgup, pgdown
  8::Send("{PgDn}")
  9::Send("{PgUp}")
  ^8::Send("^{PgDn}")
  ^9::Send("^{PgUp}")

  ; home, end
  y::Send("{Home}")
  u::Send("{End}")
  +y::Send("+{Home}")
  +u::Send("+{End}")
  ^y::Send("^{Home}")
  ^u::Send("^{End}")
  ^+y::Send("^+{Home}")
  ^+u::Send("^+{End}")

  ; 0::Send("{Home}")
  ; $::Send("{End}")

  ; seleziona riga
  +v::Send("{Home}+{End}")

  ; x e d come Del
  d::Send("{Del}")
  +d::Send("+{End}{Del}")
  x::Send("{Del}")

  ; Per comodità, questi li facciamo passare anche in Normal
  Enter::Send("{Enter}")
  Backspace::Send("{Backspace}")
  Del::Send("{Del}")
  Tab::Send("{Tab}") ; utile per muoversi nelle interfacce

  ; Solo popup perchè siamo già in Normal
  ^CapsLock::
  {
    Popup("NORMAL")
  }

  ; Disattiva vimMode (entra in insert mode)

  o::
  {
    Send("{End}{Enter}")
    SetVimMode(false)
  }
  +o::
  {
    Send("{Home}{Enter}{Up}")
    SetVimMode(false)
  }

  i::SetVimMode(false)
  +i::
  {
    Send("{Home}")
    SetVimMode(false)
  }

  c::SetVimMode(false)
  +c::
  {
    Send("+{End}") ; no Del perchè rimanendo in select è cmq ok
    SetVimMode(false)
  }

  a::
  {
    SetVimMode(false)
  }
  +a::
  {
    Send("{End}")
      SetVimMode(false)
  }

#HotIf

; #HotIf !vimMode
;   ; mapping solo in insert
;   ; WARNING: SPERIMENTALE
;   ;
;   ; nota:
;   ; non si può mappare C-qualcosa su qualcosa non C-
;   ; bug-feature:
;   ;   con Ctrl: manda come impostato
;   ;   con CapsLock: manda Ctrl + come impostato
;   ;
;   ^h::Send("{Backspace}")
;   ^l::Send("{Del}")
; #HotIf

; questa logica mappa CapsLock su Ctrl
; e con C-CapsLock fa toggle su vimMode
global capsAsCtrl := false
*CapsLock::
{
  global capsAsCtrl
  if GetKeyState("Ctrl", "P")
    return
  capsAsCtrl := true
  Send("{Blind}{Ctrl down}")
}
*CapsLock Up::
{
  global capsAsCtrl
  if capsAsCtrl
  {
    Send("{Blind}{Ctrl up}")
    capsAsCtrl := false
  }
}
^CapsLock Up::
{
  ; toggle vimMode
  SetVimMode(!vimMode)
  ; attiva vimMode solo se disattivo
  ; if !vimMode
  ;   SetVimMode(true)
}

; altri mapping -------------------------------

; backtick per Esc
`::Esc
^`::SendText("``")
+`::SendText("~")

; Combinazioni particolari Windows con Ctrl-Alt-
; Nota: meglio non usare il tasto Windows perchè problematico
;   Chiudi finestra
^!q::Send("!{F4}")
;   Aggancio finestra
;   Necessario questo workaround (win down e win up) perchè il tasto Win è rognoso
^!h::SendEvent("{LWin down}{Left}{LWin up}")
^!j::SendEvent("{LWin down}{Down}{LWin up}")
^!k::SendEvent("{LWin down}{Up}{LWin up}")
^!l::SendEvent("{LWin down}{Right}{LWin up}")

; RAlt per CapsLock
RAlt & CapsLock::SetCapsLockState(!GetKeyState("CapsLock", "T"))

; RAlt per Function-1, 2, ...
for i, key in ["1","2","3","4","5","6","7","8","9","0","-","="]
{
idx := i
       Hotkey("RAlt & " key, MakeFKeyFunc(idx))
}
MakeFKeyFunc(idx)
{
  return (*) => (
      GetKeyState("Shift", "P")
      ? Send("+{F" idx "}")
      : Send("{F" idx "}") )
}

; --- layer caratteri con RAlt -------------------------------

; RAlt & '::Send("``")
; RAlt & t::Send("~") ; t per tilde

; Mappa configurabile per caratteri specali
global cycleState := Map()
for key, chars in Map(
  ; accenti italiani e caratteri speciali
  "a", ["à",],
  "e", ["è","é","€",],
  "i", ["ì",],
  "o", ["ò",],
  "u", ["ù",],
  "l", ["λ",],
  ; per tastiere in cui Esc rimpiazza il tasto tilde/backtick
  "'", ["``",],
  "t", ["~",], ; t per tilde
)
{
  Hotkey("RAlt & " key, MakeCycleFunc(key, chars))
}
MakeCycleFunc(key, chars)
{
  return (*) => CycleKey(key, chars)
}
CycleKey(key, chars)
{
  global cycleState
  if !cycleState.Has(key)
    cycleState[key] := 0
  else
    Send("{Backspace}")
  idx := Mod(cycleState[key], chars.Length) + 1
  cycleState[key] := idx
  SendText(chars[idx])
}
~RAlt Up::
{
  global cycleState
  cycleState.Clear()
}
