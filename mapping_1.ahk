
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

  x_margin := 10
  y_margin := 70
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
  ^+h::Send("^+{Left}")
  ^+j::Send("^+{Down}")
  ^+k::Send("^+{Up}")
  ^+l::Send("^+{Right}")
  ; #h::Send("#{Left}") ; conflitto con funzionalità Win
  #j::Send("#{Down}")
  #k::Send("#{Up}")
  ; #l::Send("#{Right}") ; conflitto con funzionalità Win

  ; jumps
  w::Send("^{Right}")
  b::Send("^{Left}")
  +w::Send("^+{Right}")
  +b::Send("^+{Left}")

  ; queste 2 non funzionano con CapsLock, solo con Ctrl è corretto così.
  ; per come è implementata la logica
  ;
  ; non si può mappare C-qualcosa su qualcosa non C-
  ; bug-feature:
  ;   con Ctrl: manda come impostato
  ;   con CapsLock: manda Ctrl + come impostato
  8::Send("{PgUp}")
  9::Send("{PgDn}")

  ^8::Send("^{PgUp}")
  ^9::Send("^{PgDn}")

  ; inizio e fine riga
  y::Send("{Home}")
  u::Send("{End}")
  +y::Send("+{Home}")
  +u::Send("+{End}")
  ^y::Send("^{Home}")
  ^u::Send("^{End}")
  ^+y::Send("^+{Home}")
  ^+u::Send("^+{End}")

  0::Send("{Home}")
  $::Send("{End}")

  ; seleziona riga
  +v::Send("{Home}+{End}")

  ; x e d come Del
  d::Send("{Del}")
  x::Send("{Del}")

  ; Per comodità, questi li facciamo passare anche in Normal
  Enter::Send("{Enter}")
  Backspace::Send("{Backspace}")
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
  c::SetVimMode(false)
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
;   ; non si può mappare C-qualcosa su qualcosa non C-
;   ; bug-feature:
;   ;   con Ctrl: manda come impostato
;   ;   con CapsLock: manda Ctrl + come impostato
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
  ; SetVimMode(!vimMode)
  ; attiva vimMode
  if !vimMode
    SetVimMode(true)
}

; altri mapping -------------------------------

; backtick per Esc
`::Esc
^`::SendText("``")
+`::SendText("~")

; RAlt per combinazioni particolari Windows
RAlt & q::Send("!{F4}")

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
  ; ridondante ma comodo
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
