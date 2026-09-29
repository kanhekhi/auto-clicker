#MaxThreadsPerHotkey 2
#NoEnv
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%

; =========================================================================
; CONFIGURAÇÕES DO DESENVOLVEDOR (CHAVE PIX E PICPAY)
ChavePix   := "bf868c6e-1a3f-45d6-8b59-ed68f2a7c9bb"
LinkPicPay := "[https://picpay.me](https://picpay.me)"
; =========================================================================

; --- Carregar / Inicializar Configurações do Arquivo INI ---
IniRead, SavedAtivacao, config.ini, Settings, Ativacao, p
IniRead, SavedTecla1, config.ini, Settings, Tecla1, q
IniRead, SavedTecla2, config.ini, Settings, Tecla2, e
IniRead, SavedDelay, config.ini, Settings, Delay, 100
IniRead, SavedAntiBan, config.ini, Settings, AntiBan, 1
IniRead, SavedTurbo, config.ini, Settings, Turbo, 0
IniRead, SavedModo, config.ini, Settings, Modo, 1
IniRead, SavedMouseButton, config.ini, Settings, MouseButton, 1
IniRead, SavedClickType, config.ini, Settings, ClickType, 1

if SavedModo not in 1,2
    SavedModo := 1
if SavedMouseButton not in 1,2,3
    SavedMouseButton := 1
if SavedClickType not in 1,2
    SavedClickType := 1

; --- Interface Gráfica Profissional ---
Gui, Main:New, -MaximizeBox +Caption, Auto Clicker
Gui, Color, 0xF4F4F4

; Menu Superior
Menu, MenuArquivo, Add, Limpar Cache, LimparCache
Menu, MenuAjuda, Add, Sobre, ExibirSobre
Menu, MyMenuBar, Add, Arquivo, :MenuArquivo
Menu, MyMenuBar, Add, Ajuda, :MenuAjuda
Gui, Menu, MyMenuBar

; --- Grupo 1: Intervalo de Cliques ---
Gui, Font, S9 Normal C0x000000, Segoe UI
Gui, Add, GroupBox, x12 y12 w276 h75, Intervalo de Cliques
Gui, Add, Text, x22 y38 w85 h20, Atraso Base (ms):
Gui, Add, Edit, x110 y35 w60 h22 vDelayInput +Number, %SavedDelay%
Gui, Add, CheckBox, x180 y37 w95 h20 vAntiBan Checked%SavedAntiBan%, Anti-Ban (Rnd)

; --- Grupo 2: Opções de Cliques ---
Gui, Add, GroupBox, x12 y95 w276 h110, Opções de Cliques
Gui, Add, Text, x22 y122 w75 h20, Botão Mouse:
Gui, Add, DropDownList, x95 y118 w75 vMouseButton Choose%SavedMouseButton%, Esquerdo||Direito|Meio
Gui, Add, Text, x178 y122 w50 h20, Tipo:
Gui, Add, DropDownList, x230 y118 w48 vClickType Choose%SavedClickType%, 1/S||2/D

Gui, Add, Text, x22 y162 w50 h20, Atalho:
Gui, Add, Hotkey, x75 y158 w45 h22 vKeyAtivacao, %SavedAtivacao%
Gui, Add, Text, x128 y162 w35 h20, Teclas:
Gui, Add, Edit, x165 y158 w32 h22 +Uppercase vKey1 Limit1, %SavedTecla1%
Gui, Add, Text, x202 y162 w10 h20, +
Gui, Add, Edit, x215 y158 w32 h22 +Uppercase vKey2 Limit1, %SavedTecla2%

; --- Grupo 3: Modo de Execução ---
Gui, Add, GroupBox, x12 y212 w276 h95, Modo de Execução
Gui, Add, Text, x22 y238 w70 h20, Comportamento:
Gui, Add, DropDownList, x95 y235 w183 vModo Choose%SavedModo%, Alternar||Segurar Tecla
Gui, Add, CheckBox, x22 y270 w240 h20 vTurboMode Checked%SavedTurbo%, Modo Turbo (Prioridade Alta de CPU)

; --- Painel de Controle ---
Gui, Font, S9 Bold
Gui, Add, Button, x12 y318 w132 h36 gAplicarConfig vBtnStatus, Iniciar (%KeyAtivacao%)
Gui, Add, Button, x152 y318 w136 h36 gLiberarCampos vBtnStop +Disabled, Parar (%KeyAtivacao%)

; --- Botão de Contribuição ---
Gui, Font, S9 Normal
Gui, Add, Button, x12 y362 w276 h30 gFazerDoacao, Contribuir com o Projeto (Pix / PicPay)

; --- Barra de Status ---
Gui, Font, S8 Normal C0x555555
Gui, Add, Text, x12 y400 w276 h18 +Left vTxtStatus, Status: Ocioso

Gui, Main:Show, w300 h430, Auto Clicker Profissional
GoSub, RegistrarAtalho
Return

; --- Ações dos Menus ---
LimparCache:
FileDelete, config.ini
MsgBox, 64, Cache, O arquivo config.ini foi apagado. Reinicie o script para limpar completamente.
Return

ExibirSobre:
MsgBox, 64, Sobre, Auto Clicker Profissional v1.0`n`nDesenvolvido com automação avançada e controle de latência otimizado.
Return

; --- Doações ---
FazerDoacao:
Clipboard := ChavePix 
MsgBox, 64, Contribuição, A chave Pix foi copiada para a área de transferência.`n`nChave: %ChavePix%`n`nO navegador será aberto no PicPay. Obrigado pelo apoio!
Run, %LinkPicPay%
Return

; --- Gerenciamento de Atalhos ---
RegistrarAtalho:
Gui, Main:Submit, NoHide
if (OldAtivacao != "") {
    try Hotkey, *~%OldAtivacao%, ToggleMacro, Off
}
try {
    Hotkey, *~%KeyAtivacao%, ToggleMacro, On
} catch {
    MsgBox, 16, Erro, A tecla de atalho escolhida ("%KeyAtivacao%") é inválida.
    return
}
OldAtivacao := KeyAtivacao
Return

AplicarConfig:
Gui, Main:Submit, NoHide

GuiControlGet, ModoIndex, Main:, Modo, Choose
GuiControlGet, MouseBtnIndex, Main:, MouseButton, Choose
GuiControlGet, ClickTypeIndex, Main:, ClickType, Choose

IniWrite, %KeyAtivacao%, config.ini, Settings, Ativacao
IniWrite, %Key1%, config.ini, Settings, Tecla1
IniWrite, %Key2%, config.ini, Settings, Tecla2
IniWrite, %DelayInput%, config.ini, Settings, Delay
IniWrite, %ModoIndex%, config.ini, Settings, Modo
IniWrite, %AntiBan%, config.ini, Settings, AntiBan
IniWrite, %TurboMode%, config.ini, Settings, Turbo
IniWrite, %MouseBtnIndex%, config.ini, Settings, MouseButton
IniWrite, %ClickTypeIndex%, config.ini, Settings, ClickType

if (TurboMode) {
    Process, Priority,, High
} else {
    Process, Priority,, Normal
}

GuiControl, Main:Disabled, KeyAtivacao
GuiControl, Main:Disabled, Key1
GuiControl, Main:Disabled, Key2
GuiControl, Main:Disabled, DelayInput
GuiControl, Main:Disabled, AntiBan
GuiControl, Main:Disabled, TurboMode
GuiControl, Main:Disabled, Modo
GuiControl, Main:Disabled, MouseButton
GuiControl, Main:Disabled, ClickType
GuiControl, Main:Disabled, BtnStatus
GuiControl, Main:Enabled, BtnStop

Toggle := 1
GuiControl, Main:, TxtStatus, Status: Executando...
SoundBeep, 600, 80 
SetTimer, LoopPremium, -1
Return

LiberarCampos:
Toggle := 0
GuiControl, Main:Enabled, KeyAtivacao
GuiControl, Main:Enabled, Key1
GuiControl, Main:Enabled, Key2
GuiControl, Main:Enabled, DelayInput
GuiControl, Main:Enabled, AntiBan
GuiControl, Main:Enabled, TurboMode
GuiControl, Main:Enabled, Modo
GuiControl, Main:Enabled, MouseButton
GuiControl, Main:Enabled, ClickType
GuiControl, Main:Enabled, BtnStatus
GuiControl, Main:Disabled, BtnStop
GuiControl, Main:, TxtStatus, Status: Ocioso
SoundBeep, 300, 80
GoSub, RegistrarAtalho
Return

ToggleMacro:
Gui, Main:Submit, NoHide
SoundBeep, 500, 80 

if (Modo = "Alternar") {
    Toggle := !Toggle
    if (Toggle) {
        GuiControl, Main:, TxtStatus, Status: Executando...
        GuiControl, Main:Disabled, BtnStatus
        GuiControl, Main:Enabled, BtnStop
        SetTimer, LoopPremium, -1
    } else {
        GuiControl, Main:Enabled, BtnStatus
        GuiControl, Main:Disabled, BtnStop
        GuiControl, Main:, TxtStatus, Status: Pronto
    }
} else {
    Toggle := 1
    GuiControl, Main:, TxtStatus, Status: Executando...
    GuiControl, Main:Disabled, BtnStatus
    GuiControl, Main:Enabled, BtnStop
    SetTimer, LoopPremium, -1
    KeyWait, %KeyAtivacao%
    Toggle := 0
    GuiControl, Main:Enabled, BtnStatus
    GuiControl, Main:Disabled, BtnStop
    GuiControl, Main:, TxtStatus, Status: Pronto
    SoundBeep, 400, 80
}
Return

; --- Loop Principal de Automação ---
LoopPremium:
While Toggle
{
    if (!WinActive("A")) {
        Sleep, 500
        continue
    }

    MouseBtnText := (MouseButton = 1) ? "Left" : (MouseButton = 2) ? "Right" : "Middle"
    ClickCount := (ClickType = 1) ? 1 : 2

    Click, %MouseBtnText%, , %ClickCount%

    StringLower, SendKey1, Key1
    StringLower, SendKey2, Key2

    if (SendKey1 != "") {
        Send, {%SendKey1%}
    }
    CalcularDelay(DelayInput, AntiBan)
    if not Toggle
        break
        
    if (SendKey2 != "") {
        Send, {%SendKey2%}
    }
    CalcularDelay(DelayInput, AntiBan)
}
Return

CalcularDelay(DelayBase, UsarAntiBan) {
    if (UsarAntiBan) {
        Random, Variacao, -15, 15
        TempoFinal := DelayBase + Variacao
        if (TempoFinal < 5)
            TempoFinal := 5
        Sleep, %TempoFinal%
    } else {
        Sleep, %DelayBase%
    }
}

MainGuiClose:
ExitApp