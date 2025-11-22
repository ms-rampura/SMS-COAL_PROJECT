INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

.MODEL FLAT, STDCALL
.STACK 4096

.data

; ====== Limits ======
MAX_SOCIETIES     = 5
MAX_NAME_LENGTH   = 30

MAX_MEMBERS       = 5
MAX_MEMBER_LENGTH = 30

; ====== Menus & messages ======
menuMsg BYTE \
"==== Society Management System ====",0dh,0ah,\
"1. Society Management",0dh,0ah,\
"2. Member Management",0dh,0ah,\
"3. Exit",0dh,0ah,\
"Enter your choice: ",0

societyMenuMsg BYTE \
"===== Society Management =====",0dh,0ah,\
"1. Add Society",0dh,0ah,\
"2. View Societies",0dh,0ah,\
"3. Delete Society",0dh,0ah,\
"4. Edit Society Name",0dh,0ah,\
"5. Show Total Member Count",0dh,0ah,\
"6. Back to Main Menu",0dh,0ah,\
"Enter your choice: ",0

memberMenuPrompt BYTE \
"===== Member Management =====",0dh,0ah,0
entersociety BYTE \
"Enter society number: ",0

memberOptions BYTE \
"1. Add Member",0dh,0ah,\
"2. View Members",0dh,0ah,\
"3. Delete Member",0dh,0ah,\
"4. Edit Member Name",0dh,0ah,\
"5. Search Member",0dh,0ah,\
"6. Back to Main Menu",0dh,0ah,\
"Enter your choice: ",0

enterSocietyMsg BYTE "Enter society name: ",0
addedMsg BYTE "Society added successfully.",0dh,0ah,0
fullMsg BYTE "Cannot add more societies.",0dh,0ah,0

enterMemberMsg BYTE "Enter member name: ",0
memberAddedMsg BYTE "Member added successfully.",0dh,0ah,0
memberFullMsg BYTE "This society already has 5 members.",0dh,0ah,0

noSocietiesMsg BYTE "No societies registered yet.",0dh,0ah,0
societyListMsg BYTE "===== Registered Societies =====",0dh,0ah,0

memberListMsg BYTE "===== Members =====",0dh,0ah,0
noMembersMsg  BYTE "No members found.",0dh,0ah,0

dotSpace BYTE ". ",0

deletePrompt BYTE "Enter society number to delete: ",0
invalidDeleteMsg BYTE "Invalid society number!",0dh,0ah,0
deletedMsg BYTE "Society deleted successfully.",0dh,0ah,0

deleteMemberPrompt BYTE "Enter member number to delete: ",0
invalidMemberDeleteMsg BYTE "Invalid member number!",0dh,0ah,0
memberDeletedMsg BYTE "Member deleted successfully.",0dh,0ah,0

editPrompt BYTE "Enter number to edit: ",0
editedMsg BYTE "Edited successfully.",0dh,0ah,0

searchPrompt BYTE "Enter name to search: ",0
searchNotFoundMsg BYTE "Member not found.",0dh,0ah,0
searchFoundMsg BYTE "Member found at position: ",0

totalMembersMsg BYTE "Total members across all societies: ",0

pauseMsg BYTE 0dh,0ah,"Press any key to continue...",0

; ====== Data arrays ======
; societies storage: MAX_SOCIETIES * MAX_NAME_LENGTH
societyNames BYTE MAX_SOCIETIES * MAX_NAME_LENGTH DUP(?)
societyCount DWORD 0

; members storage: flattened 3D: societyIndex * (MAX_MEMBERS*MAX_MEMBER_LENGTH) + memberIndex * MAX_MEMBER_LENGTH
memberNames BYTE MAX_SOCIETIES * MAX_MEMBERS * MAX_MEMBER_LENGTH DUP(?)
memberCount DWORD MAX_SOCIETIES DUP(0)   ; one DWORD per society

; temporary buffer for searching / input reuse
tempMemberName BYTE MAX_MEMBER_LENGTH DUP(?)

; ====== Animation Messages ======
loadingMsg BYTE "Loading",0
dots BYTE "...",0
completeMsg BYTE " Complete!",0
exitMsg BYTE "Thank you for using Society Management System!",0dh,0ah,0
welcomeMsg BYTE "Welcome to Society Management System",0dh,0ah,0

.code

; ===== PauseProc =====
PauseProc PROC
    mov eax, white            
    call SetTextColor
    mov edx, OFFSET pauseMsg
    call WriteString
    call ReadChar
    ret
PauseProc ENDP

; ===== Loading Animation =====
LoadingAnimation PROC
    pushad
    mov eax, lightCyan
    call SetTextColor
    
    mov edx, OFFSET loadingMsg
    call WriteString
    
    mov ecx, 3
    mov esi, OFFSET dots
loading_loop:
    mov al, [esi]
    call WriteChar
    mov eax, 200
    call Delay
    inc esi
    loop loading_loop
    
    mov edx, OFFSET completeMsg
    call WriteString
    call Crlf
    call Crlf
    
    popad
    ret
LoadingAnimation ENDP

; ===== Color Fade Title Animation =====
ColorFadeTitle PROC
    pushad
    mov ecx, 2 ; Number of fade cycles
    
fade_loop:
    ; Fade in - light blue to cyan
    mov eax, lightBlue
    call SetTextColor
    call Clrscr
    mov edx, OFFSET menuMsg
    call WriteString
    mov eax, 100
    call Delay
    
    mov eax, cyan
    call SetTextColor
    call Clrscr
    mov edx, OFFSET menuMsg
    call WriteString
    mov eax, 100
    call Delay
    
    mov eax, lightCyan
    call SetTextColor
    call Clrscr
    mov edx, OFFSET menuMsg
    call WriteString
    mov eax, 150
    call Delay
    
    loop fade_loop
    
    popad
    ret
ColorFadeTitle ENDP

; ===== Welcome Animation =====
WelcomeAnimation PROC
    pushad
    call Clrscr
    
    ; Display welcome message with color cycle
    mov ecx, 3
welcome_loop:
    mov eax, lightGreen
    call SetTextColor
    mov edx, OFFSET welcomeMsg
    call WriteString
    mov eax, 300
    call Delay
    call Clrscr
    
    mov eax, lightCyan
    call SetTextColor
    mov edx, OFFSET welcomeMsg
    call WriteString
    mov eax, 300
    call Delay
    call Clrscr
    
    mov eax, lightBlue
    call SetTextColor
    mov edx, OFFSET welcomeMsg
    call WriteString
    mov eax, 300
    call Delay
    call Clrscr
    
    loop welcome_loop
    
    popad
    ret
WelcomeAnimation ENDP

; ===== Exit Animation =====
ExitAnimation PROC
    pushad
    mov ecx, 3
exit_anim:
    mov eax, lightRed
    call SetTextColor
    call Clrscr
    mov edx, OFFSET exitMsg
    call WriteString
    mov eax, 200
    call Delay
    
    mov eax, red
    call SetTextColor
    call Clrscr
    mov edx, OFFSET exitMsg
    call WriteString
    mov eax, 200
    call Delay
    
    mov eax, lightMagenta
    call SetTextColor
    call Clrscr
    mov edx, OFFSET exitMsg
    call WriteString
    mov eax, 200
    call Delay
    loop exit_anim
    
    popad
    ret
ExitAnimation ENDP

; ===== main =====
main PROC

; Start with welcome animation
    call WelcomeAnimation
    mov eax, 1000
    call Delay

mainMenu:
    call ColorFadeTitle        ; Fading title effect
    
    mov eax, lightBlue
    call SetTextColor
    call ReadInt
    mov ebx, eax

    cmp ebx, 1
    je societyMenuWithAnim
    cmp ebx, 2
    je memberMenuWithAnim
    cmp ebx, 3
    je exitWithAnim

    jmp mainMenu

societyMenuWithAnim:
    call LoadingAnimation      ; Show loading when entering society menu
    jmp societyMenu

memberMenuWithAnim:
    call LoadingAnimation      ; Show loading when entering member menu  
    jmp memberMenu

exitWithAnim:
    call ExitAnimation         ; Show exit animation
    jmp exitProgram

; =================================================
; SOCIETY MANAGEMENT
; =================================================
societyMenu:
societyMenuStart:
    call Clrscr
    mov eax, lightCyan       ; section title
    call SetTextColor
    mov edx, OFFSET societyMenuMsg
    call WriteString

    mov eax, lightBlue
    call SetTextColor
    call ReadInt
    mov ebx, eax

    cmp ebx, 1
    je addSociety

    cmp ebx, 2
    je viewSocieties

    cmp ebx, 3
    je deleteSociety

    cmp ebx, 4
    je editSocietyName

    cmp ebx, 5
    je showTotalMembers

    cmp ebx, 6
    je mainMenu

    jmp societyMenuStart

; Add Society
addSociety:
    mov eax, societyCount
    cmp eax, MAX_SOCIETIES
    jae addSocietyFull

    mov eax, lightGreen      ; prompt color: green
    call SetTextColor
    mov edx, OFFSET enterSocietyMsg
    call WriteString

    mov eax, societyCount
    imul eax, MAX_NAME_LENGTH      ; offset for new society
    mov edx, OFFSET societyNames
    add edx, eax

    mov ecx, MAX_NAME_LENGTH
    call ReadString

    inc societyCount

    mov eax, lightGreen      ; success color
    call SetTextColor
    mov edx, OFFSET addedMsg
    call WriteString
    call PauseProc
    jmp societyMenuStart

addSocietyFull:
    mov eax, lightRed        ; error color
    call SetTextColor
    mov edx, OFFSET fullMsg
    call WriteString
    call PauseProc
    jmp societyMenuStart

; View Societies
viewSocieties:
    mov eax, societyCount
    cmp eax, 0
    je noSocieties

    call Clrscr
    mov eax, lightCyan       ; section title color
    call SetTextColor
    mov edx, OFFSET societyListMsg
    call WriteString

    ; setup loop: ECX = count, EBX = index (0..count-1), ESI -> first name
    mov ecx, societyCount        ; loop counter = societyCount
    mov ebx, 0                   ; index = 0
    mov esi, OFFSET societyNames

printSocietyLoop:
    ; print index+1
    mov eax, ebx
    inc eax
    call WriteDec

    mov edx, OFFSET dotSpace
    call WriteString

    mov edx, esi
    call WriteString
    call Crlf

    add esi, MAX_NAME_LENGTH
    inc ebx
    loop printSocietyLoop

    call PauseProc
    jmp societyMenuStart

noSocieties:
    mov eax, lightRed
    call SetTextColor
    mov edx, OFFSET noSocietiesMsg
    call WriteString
    call PauseProc
    jmp societyMenuStart


; Delete Society (also shift member blocks and memberCount)
deleteSociety:
    mov eax, societyCount
    cmp eax, 0
    je noSocietiesDelete

    call Clrscr
    mov eax, lightCyan
    call SetTextColor
    mov edx, OFFSET societyListMsg
    call WriteString

    mov ecx, societyCount
    mov ebx, 0                   ; index
    mov esi, OFFSET societyNames

deleteDisplayLoop:
    mov eax, ebx
    inc eax
    call WriteDec

    mov edx, OFFSET dotSpace
    call WriteString

    mov edx, esi
    call WriteString
    call Crlf

    add esi, MAX_NAME_LENGTH
    inc ebx
    loop deleteDisplayLoop

    mov eax, lightGreen
    call SetTextColor
    mov edx, OFFSET deletePrompt
    call WriteString
    call ReadInt
    mov ebx, eax

    cmp ebx, 1
    jl invalidDelete
    cmp ebx, societyCount
    jg invalidDelete

    dec ebx                 ; zero-based index of society to delete

    ; --- compute pointer to society block to delete ---
    mov eax, ebx
    imul eax, MAX_NAME_LENGTH
    mov esi, OFFSET societyNames
    add esi, eax            ; ESI -> societyNames + offset

    ; --- compute how many societies after this ---
    mov eax, societyCount
    dec eax
    sub eax, ebx
    cmp eax, 0
    jle deleteSocietyLastOnly

    ; shift remaining society name blocks up
    mov ecx, eax            ; number of blocks to move
shiftSocietyBlocks:
    push ecx                ; save outer loop counter
    mov edi, esi            ; destination
    lea esi, [edi + MAX_NAME_LENGTH] ; source (next block)
    mov ecx, MAX_NAME_LENGTH
    rep movsb               ; copy block
    pop ecx                 ; restore outer loop counter
    dec ecx
    jnz shiftSocietyBlocks

deleteSocietyLastOnly:
    ; also shift the member blocks and memberCount entries
    ; compute pointer to member block to delete: memberNames + societyIndex*(MAX_MEMBERS*MAX_MEMBER_LENGTH)
    mov eax, ebx
    imul eax, MAX_MEMBERS*MAX_MEMBER_LENGTH
    mov esi, OFFSET memberNames
    add esi, eax            ; ESI -> start of this society's member block

    ; how many society member blocks after this?
    mov eax, societyCount
    dec eax
    sub eax, ebx
    cmp eax, 0
    jle shiftMemberCountsDone

    mov ecx, eax            ; number of blocks to move
shiftMemberBlocks:
    push ecx                ; save outer loop counter
    mov edi, esi            ; destination
    lea esi, [edi + MAX_MEMBERS*MAX_MEMBER_LENGTH] ; source (next member block)
    mov ecx, MAX_MEMBERS*MAX_MEMBER_LENGTH
    rep movsb               ; copy member block
    pop ecx                 ; restore outer loop counter
    dec ecx
    jnz shiftMemberBlocks

shiftMemberCountsDone:
    ; shift memberCount DWORDs
    mov esi, OFFSET memberCount
    mov eax, ebx
    shl eax, 2              ; multiply by 4 (size of DWORD)
    add esi, eax            ; ESI -> memberCount[ebx]
    mov ecx, societyCount
    dec ecx
    sub ecx, ebx
    cmp ecx, 0
    jle shiftMemberCountDone

shiftCountLoop:
    mov eax, [esi + 4]      ; next society's member count
    mov [esi], eax
    add esi, 4
    dec ecx
    jnz shiftCountLoop

shiftMemberCountDone:
    ; decrement societyCount
    dec societyCount

    mov eax, lightGreen
    call SetTextColor
    mov edx, OFFSET deletedMsg
    call WriteString
    call PauseProc
    jmp societyMenuStart

invalidDelete:
    mov eax, lightRed
    call SetTextColor
    mov edx, OFFSET invalidDeleteMsg
    call WriteString
    call PauseProc
    jmp societyMenuStart

noSocietiesDelete:
    mov eax, lightRed
    call SetTextColor
    mov edx, OFFSET noSocietiesMsg
    call WriteString
    call PauseProc
    jmp societyMenuStart

; Edit society name
editSocietyName:
    mov eax, societyCount
    cmp eax, 0
    je noSocieties

    call Clrscr
    mov eax, lightCyan
    call SetTextColor
    mov edx, OFFSET societyListMsg
    call WriteString

    mov ecx, societyCount
    mov esi, OFFSET societyNames

printSocListForEdit:
    mov eax, societyCount
    sub eax, ecx
    inc eax
    call WriteDec
    mov edx, OFFSET dotSpace
    call WriteString
    mov edx, esi
    call WriteString
    call Crlf
    add esi, MAX_NAME_LENGTH
    loop printSocListForEdit

    mov eax, lightGreen
    call SetTextColor
    mov edx, OFFSET editPrompt
    call WriteString
    call ReadInt
    mov ebx, eax
    cmp ebx, 1
    jl invalidDelete
    cmp ebx, societyCount
    jg invalidDelete

    dec ebx                ; zero-based
    mov eax, ebx
    imul eax, MAX_NAME_LENGTH
    mov edx, OFFSET societyNames
    add edx, eax
    mov ebx, eax
    mov eax, lightGreen
    call SetTextColor
    mov edx, OFFSET enterSocietyMsg
    call WriteString
    mov edx, OFFSET societyNames
    add edx, ebx
    mov ecx, MAX_NAME_LENGTH
    call ReadString

    mov eax, lightGreen
    call SetTextColor
    mov edx, OFFSET editedMsg
    call WriteString
    call PauseProc
    jmp societyMenuStart

; Show total members across all societies - FIXED
showTotalMembers:
    mov ecx, societyCount    ; Use actual society count
    cmp ecx, 0
    je noSocietiesTotal
    
    mov eax, 0              ; total in EAX
    mov esi, OFFSET memberCount

sumLoop:
    add eax, [esi]          ; add member count for this society
    add esi, 4              ; move to next society's member count
    dec ecx
    jnz sumLoop

    mov edx, OFFSET totalMembersMsg
    call WriteString
    call WriteDec           ; display the total count
    call Crlf

    call PauseProc
    jmp societyMenuStart

noSocietiesTotal:
    mov eax, lightRed
    call SetTextColor
    mov edx, OFFSET noSocietiesMsg
    call WriteString
    call PauseProc
    jmp societyMenuStart

; =================================================
; MEMBER MANAGEMENT
; =================================================
memberMenu:
memberMenuStart:
    call Clrscr

    mov edx, OFFSET memberMenuPrompt
    call WriteString
    call crlf

    mov eax, societyCount
    cmp eax, 0
    je noSocieties

    mov edx, OFFSET societyListMsg
    call WriteString

    mov ecx, eax
    mov esi, OFFSET societyNames

PrintSociety:
    mov eax, societyCount
    sub eax, ecx
    inc eax
    call WriteDec
    mov edx, OFFSET dotSpace
    call WriteString
    mov edx, esi
    call WriteString
    call Crlf
    add esi, MAX_NAME_LENGTH
    loop PrintSociety

    mov edx, OFFSET entersociety
    call WriteString

    call ReadInt
    mov eax, eax           ; user input (1-based)
    cmp eax, 1
    jl invalidSocietyMsg
    ; check not greater than societyCount
    mov ebx, societyCount
    cmp eax, ebx
    jg invalidSocietyMsg

    dec eax                ; zero-based society index in EAX
    mov ebx, eax           ; EBX = societyIndex

memberOptionsMenu:
    call Clrscr
    mov eax, lightCyan
    call SetTextColor
    mov edx, OFFSET memberOptions
    call WriteString

    mov eax, lightBlue
    call SetTextColor
    call ReadInt

    cmp eax, 1
    je addMember
    cmp eax, 2
    je viewMembers
    cmp eax, 3
    je deleteMember
    cmp eax, 4
    je editMember
    cmp eax, 5
    je searchMember
    cmp eax, 6
    je mainMenu

    jmp memberOptionsMenu

invalidSocietyMsg:
    mov eax, lightRed
    call SetTextColor
    mov edx, OFFSET invalidDeleteMsg
    call WriteString
    call PauseProc
    jmp mainMenu

; Add Member to EBX society
addMember:
    mov esi, OFFSET memberCount
    mov eax, [esi + ebx*4]    ; current count
    cmp eax, MAX_MEMBERS
    jae memberFull

    ; compute destination pointer:
    mov edx, ebx
    imul edx, MAX_MEMBERS*MAX_MEMBER_LENGTH
    mov ecx, eax
    imul ecx, MAX_MEMBER_LENGTH
    add edx, ecx
    mov edi, OFFSET memberNames
    add edi, edx

    mov eax, lightGreen
    call SetTextColor
    mov edx, OFFSET enterMemberMsg
    call WriteString

    mov edx, edi
    mov ecx, MAX_MEMBER_LENGTH
    call ReadString

    ; increment memberCount[society]
    mov esi, OFFSET memberCount
    inc DWORD PTR [esi + ebx*4]

    mov eax, lightGreen
    call SetTextColor
    mov edx, OFFSET memberAddedMsg
    call WriteString
    call PauseProc
    jmp memberOptionsMenu

memberFull:
    mov eax, lightRed
    call SetTextColor
    mov edx, OFFSET memberFullMsg
    call WriteString
    call PauseProc
    jmp memberOptionsMenu

; View Members for society EBX - COMPLETELY FIXED
viewMembers:
    mov esi, OFFSET memberCount
    mov ecx, [esi + ebx*4]    ; ecx = count
    cmp ecx, 0
    je noMembersView

    call Clrscr
    mov eax, lightCyan
    call SetTextColor
    mov edx, OFFSET memberListMsg
    call WriteString

    ; show society name
    mov eax, lightBlue
    call SetTextColor
    mov edx, OFFSET societyNames
    mov ecx, ebx
    imul ecx, MAX_NAME_LENGTH
    add edx, ecx
    call WriteString
    call Crlf
    call Crlf
    mov esi, OFFSET memberCount
    mov ecx , [esi + ebx*4]
    ; compute pointer to first member
    mov esi, ebx
    imul esi, MAX_MEMBERS*MAX_MEMBER_LENGTH
    add esi, OFFSET memberNames


    
viewMemberLoop:
    ; print member number
    mov eax, [memberCount + ebx*4]
    sub eax, ecx
    inc eax
    call WriteDec
    mov edx, OFFSET dotSpace
    call WriteString
    
    ; print member name
    mov edx, esi
    call WriteString
    call Crlf
    
    add esi, MAX_MEMBER_LENGTH
    loop viewMemberLoop

    call PauseProc
    jmp memberOptionsMenu

noMembersView:
    mov eax, lightRed
    call SetTextColor
    mov edx, OFFSET noMembersMsg
    call WriteString
    call PauseProc
    jmp memberOptionsMenu

; Delete Member from society EBX
deleteMember:
    mov esi, OFFSET memberCount
    mov ecx, [esi + ebx*4]    ; ecx = count
    cmp ecx, 0
    je noMembersDelete

    call Clrscr
    mov eax, lightCyan
    call SetTextColor
    mov edx, OFFSET memberListMsg
    call WriteString

    ; compute pointer to first member
    mov esi, ebx
    imul esi, MAX_MEMBERS*MAX_MEMBER_LENGTH
    add esi, OFFSET memberNames

   
    
showDeleteList:
    ; print member number and name
    mov eax,[memberCount + ebx*4]
    sub eax, ecx
    inc eax
    call WriteDec
    mov edx, OFFSET dotSpace
    call WriteString
    mov edx, esi
    call WriteString
    call Crlf
    
    add esi, MAX_MEMBER_LENGTH
    loop showDeleteList

    mov eax, lightGreen
    call SetTextColor
    mov edx, OFFSET deleteMemberPrompt
    call WriteString
    call ReadInt
    dec eax                ; convert to zero-based
    cmp eax, 0
    jl invalidMemberDelete
    mov ecx, [memberCount + ebx*4]
    cmp eax, ecx
    jge invalidMemberDelete

    ; compute address of member to delete
    mov esi, ebx
    imul esi, MAX_MEMBERS*MAX_MEMBER_LENGTH
    mov ecx, eax
    imul ecx, MAX_MEMBER_LENGTH
    add esi, ecx
    add esi, OFFSET memberNames

    ; shift subsequent members up
    mov ecx, [memberCount + ebx*4]
    dec ecx
    sub ecx, eax           ; number of members to shift
    cmp ecx, 0
    jle deleteMemberLastOnly

    mov edi, esi           ; destination
shiftLoopM:
    lea esi, [edi + MAX_MEMBER_LENGTH] ; source
    push ecx
    mov ecx, MAX_MEMBER_LENGTH
    rep movsb
    pop ecx
    dec ecx
    jnz shiftLoopM

deleteMemberLastOnly:
    ; decrement member count
    dec DWORD PTR [memberCount + ebx*4]

    mov eax, lightGreen
    call SetTextColor
    mov edx, OFFSET memberDeletedMsg
    call WriteString
    call PauseProc
    jmp memberOptionsMenu

invalidMemberDelete:
    mov eax, lightRed
    call SetTextColor
    mov edx, OFFSET invalidMemberDeleteMsg
    call WriteString
    call PauseProc
    jmp memberOptionsMenu

noMembersDelete:
    mov eax, lightRed
    call SetTextColor
    mov edx, OFFSET noMembersMsg
    call WriteString
    call PauseProc
    jmp memberOptionsMenu

; Edit member name in society EBX
editMember:
    mov esi, OFFSET memberCount
    mov ecx, [esi + ebx*4]    ; ecx = count
    cmp ecx, 0
    je noMembersEdit

    call Clrscr
    mov eax, lightCyan
    call SetTextColor
    mov edx, OFFSET memberListMsg
    call WriteString

    ; compute pointer to first member
   mov edx, ebx
    imul edx, MAX_MEMBERS*MAX_MEMBER_LENGTH
    add edx, OFFSET memberNames
    mov esi, edx

    
showEditList:
    ; print member number and name
    mov eax, [memberCount + ebx*4]
    sub eax, ecx
    inc eax
    call WriteDec
    mov edx, OFFSET dotSpace
    call WriteString
    mov edx, esi
    call WriteString
    call Crlf
    
    add esi, MAX_MEMBER_LENGTH
    loop showEditList

    mov eax, lightGreen
    call SetTextColor
    mov edx, OFFSET editPrompt
    call WriteString
    call ReadInt
    dec eax                ; convert to zero-based
    cmp eax, 0
    jl invalidMemberDelete
    mov ecx, [memberCount + ebx*4]
    cmp eax, ecx
    jge invalidMemberDelete

    ; compute address of member to edit
    mov edx, ebx
    imul edx, MAX_MEMBERS*MAX_MEMBER_LENGTH
    mov ecx, eax
    imul ecx, MAX_MEMBER_LENGTH
    add edx, ecx
    add edx, OFFSET memberNames
    mov ecx , edx
    mov eax, lightGreen
    call SetTextColor
    mov edx, OFFSET enterMemberMsg
    call WriteString

    mov edx, ecx
    mov ecx, MAX_MEMBER_LENGTH
    call ReadString

    mov eax, lightGreen
    call SetTextColor
    mov edx, OFFSET editedMsg
    call WriteString
    call PauseProc
    jmp memberOptionsMenu

noMembersEdit:
    mov eax, lightRed
    call SetTextColor
    mov edx, OFFSET noMembersMsg
    call WriteString
    call PauseProc
    jmp memberOptionsMenu

; Search Member in society EBX - FIXED
searchMember:
    push ebx                ; preserve society index
    
    mov eax, lightGreen
    call SetTextColor
    mov edx, OFFSET searchPrompt
    call WriteString

    mov edx, OFFSET tempMemberName
    mov ecx, MAX_MEMBER_LENGTH
    call ReadString

    ; get member count for this society
    mov esi, OFFSET memberCount
    mov ecx, [esi + ebx*4]
    cmp ecx, 0
    je searchNotFoundPop

    ; compute base pointer to members
    mov esi, ebx
    imul esi, MAX_MEMBERS*MAX_MEMBER_LENGTH
    add esi, OFFSET memberNames

    mov edx, 0              ; index counter
searchLoop:
    push ecx
    push esi
    push edx
    
    ; compare strings
    mov edi, esi
    mov esi, OFFSET tempMemberName
compareLoop:
    mov al, [esi]
    mov bl, [edi]
    cmp al, bl
    jne notEqual
    cmp al, 0
    je foundEqual
    inc esi
    inc edi
    jmp compareLoop

notEqual:
    pop edx
    pop esi
    pop ecx
    add esi, MAX_MEMBER_LENGTH
    inc edx
    loop searchLoop
    
    jmp searchNotFoundPop

foundEqual:
    pop edx
    pop esi
    pop ecx
    pop ebx                 ; restore society index
    
    ; found at position edx (0-based), display as 1-based
    mov eax, lightGreen
    call SetTextColor
    mov edx, OFFSET searchFoundMsg
    call WriteString
    mov eax, edx
    inc eax                 ; convert to 1-based
    call WriteDec
    call Crlf
    call PauseProc
    jmp memberOptionsMenu

searchNotFoundPop:
    pop ebx                 ; restore society index
searchNotFound:
    mov eax, lightRed
    call SetTextColor
    mov edx, OFFSET searchNotFoundMsg
    call WriteString
    call PauseProc
    jmp memberOptionsMenu

; =================================================
; EXIT
; =================================================
exitProgram:
    mov eax, white
    call SetTextColor
    exit

main ENDP
END main
