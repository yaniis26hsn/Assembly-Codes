.MODEL SMALL
.STACK 100h

.DATA
    ; variables  
   
    newline DB 0Dh, 0Ah, '$'  
    msg DB 'enter two numbers to get the gcd :$'          
    buffer DB 6 DUP('$')                            
    errormsg DB 'since both are 0 , gcd is undefined$'
    

.CODE
MAIN PROC
    ; initialize data segment   
    MOV AX, @DATA
    MOV DS, AX      
    
    MOV DX, offset msg    
    MOV AH, 09h
    INT 21h
     
                                                                                                     
    ;input to ax and bx :             
    ; cleaning            
    XOR DX , DX 
    XOR BX , BX
    
    ; WE START BY AX  (I WILL STORE IT IN DX FIRST)  
    NEXTdIGIT1 :
    MOV AH, 01h
    INT 21h              
    CMP AL , 0Dh             ; the ascii code of enter key
    JE DONEiNPUT1    
    SUB AL , '0'     
    MOV BL , AL    
    MOV AX , DX 
    MOV CX , 10
    MUL CX ; AX * CX (AX * 10 )
    MOV DX , AX                
    XOR BH, BH
    ADD DX , BX 
    JMP NEXTdIGIT1      
    
    DONEiNPUT1:
       
     MOV SI , DX    
         
    MOV DX, OFFSET newline
    MOV AH, 09h
    INT 21h          
    
    XOR BX, BX
    
    ;NOW BX  
    NEXTdIGIT :     
           
    
    MOV AH, 01h
    INT 21h              
    CMP AL , 0Dh             ; the ascii code of enter key
    JE DONEiNPUT    
    SUB AL , '0'     
    MOV DL , AL    
    MOV AX , BX 
    MOV CX , 10
    MUL CX ; AX * CX (AX * 10 )
    MOV BX , AX   
    XOR DH, DH
    ADD BX , DX
    JMP NEXTdIGIT     
    
    DONEiNPUT: 
    
    MOV AX, SI  
    
    CMP AX,0 
    JNE NOeRROR
    CMP BX,0
    JNE NOeRROR
    MOV DX, OFFSET errormsg  ; BOTH NUMS ARE 0 , IT IS AN ERROR   
    MOV AH, 09h            
    INT 21h 
    JMP EXIT_PROG
    
    
    
    NOeRROR : 
            
    ;getting the results: 
    
    ITERATE :      
    ; we start by removing garbage value in dx 
    XOR DX , DX      ; or i could do mov dx, 0 but xor is faster 
    CMP BX,0 
    JE END_LOOP 
    
    DIV BX  
    MOV AX , BX       
    MOV BX, DX
    
    JMP ITERATE  
              
                         
    END_LOOP :                      
    
    ; THE GCD IS SAVED IN AX       
    
    ; OUTPUTTING THE RESULT :                 
    LEA SI, buffer+5 
    MOV CX, 5   ; NO MORE THAN FIVE DIGITS , IT SHOULD BE ENOUGH SINCE WE ARE IN 8 BITS (FOR THE TWO NUMS)                  
    MOV BX, 10  
    
    
    MYLOOP :
    XOR DX,DX ; CLEANING DX CZ WE DIVIDE DX:AX (IN DIV)
    DIV BX 
    ADD DL , '0'
    MOV [SI], DL 
    DEC SI  
    CMP AX, 0 
    JE BREAK 
    LOOP MYLOOP   
    
    BREAK :
       
       ; FINAL PRINT :
    MOV DX, OFFSET newline
    MOV AH, 09h
    INT 21h          
    
    ; NOW PRINTING THE RESULT IN BUFFER :
      
      MOV DX, OFFSET buffer    ;
      MOV AH, 09h            
      INT 21h           
          
          
    ; exit program                 
     EXIT_PROG :
     
    MOV AH, 4Ch
    INT 21h
MAIN ENDP
END MAIN
