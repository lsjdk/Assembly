;�������Ρ����ݶΡ�ջ��
assume cs: code, ds: data, ss: stack

;------------ ջ�� begin ------------
stack segment 
    ;����100���ֽڵ�����Ϊ0��ջ�ռ�
    db 100 dup(0)    
stack ends
;------------ ջ��  end ------------

;------------ ���ݶ� begin ------------
data segment
    string db 'Hello World!$'
    a dw 0   
data ends
;------------ ���ݶ�  end ------------ 

;------------ ����� begin ------------
code segment
;����ο�ʼ
start: 

    ;�ֶ�����ds��ss��ֵ
    mov ax, data
    mov ds, ax
    
    mov ax, stack
    mov ss, ax
             
    ;ҵ���߼�����
    
    ;��������������������������������֮��
    push 1122h
    push 4455h
    
    call sum 
    add sp 4;��֤ջƽ���
                 
    ;��ӡHello World
    call printf   
    
    ;����2��3�η�
    
    call mathTun3
    ;call mathTun2 
    ;call mathTun1
    
    mov dx, ax 
             
    ;�˳�����
    mov ax, 4c00h
    int 21h

;loop ָ����ԣ�ʵ��2����η�
loopTest:
    ;ѭ�����    
    mov ax, 2
    mov cx, 5 
    s: add ax, ax
    loop s
    ret
    

;�������ĺ���������������֮��
;�������������ջ�ռ�����

sum:
    mov bp, sp
    mov ax, ss:[bp+2]
    add ax, ss:[bp+4]
    ret 
 
 
;��������Ĭ��ax�Ĵ�����ŷ�������   
mathTun3:
    mov ax, 2
    add ax, ax
    add ax, ax
    
    ret

;�������������ݶ��ж���һ������a����ŷ�������   
mathTun2:
    mov ax, 2
    add ax, ax
    add ax, ax
    
    mov a, ax
    
    ret

;����һ�������ݶ��е�[0]����ŷ�������   
mathTun1:
    mov ax, 2
    add ax, ax
    add ax, ax
    
    mov [0], ax
    
    ret
     
;��ӡ�ַ�������   
printf:
    mov dx, offset string
    mov ah, 09h
    int 21h
    ;�Ƴ���������
    ret
    
code ends
;------------ �����  end ------------


;������������start������� 
end start  ;hjs�ϺõĿƷ�˹��