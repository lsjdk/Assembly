;定义代码段、数据段、栈段
assume cs: code, ds: data, ss: stack

;------------ 栈段 begin ------------
stack segment 
    ;创建100个字节的内容为0的栈空间
    db 100 dup(0)    
stack ends
;------------ 栈段  end ------------

;------------ 数据段 begin ------------
data segment
    string db 'Hello World!$'
    a dw 0   
data ends
;------------ 数据段  end ------------ 

;------------ 代码段 begin ------------
code segment
;代码段开始
start: 

    ;手动设置ds、ss的值
    mov ax, data
    mov ds, ax
    
    mov ax, stack
    mov ss, ax
             
    ;业务逻辑代码
    
    ;给函数传入两个参数，返回两个参数之和
    push 1122h
    push 4455h
    
    call sum 
    add sp 4;保证栈平衡的
                 
    ;打印Hello World
    call printf   
    
    ;返回2的3次方
    
    call mathTun3
    ;call mathTun2 
    ;call mathTun1
    
    mov dx, ax 
             
    ;退出程序
    mov ax, 4c00h
    int 21h

;loop 指令测试，实现2的五次方
loopTest:
    ;循环五次    
    mov ax, 2
    mov cx, 5 
    s: add ax, ax
    loop s
    ret
    

;带参数的函数，求两个参数之和
;两个参数存放在栈空间里面

sum:
    mov bp, sp
    mov ax, ss:[bp+2]
    add ax, ss:[bp+4]
    ret 
 
 
;方法三：默认ax寄存器存放返回数据   
mathTun3:
    mov ax, 2
    add ax, ax
    add ax, ax
    
    ret

;方法二：在数据段中定义一个变量a，存放返回数据   
mathTun2:
    mov ax, 2
    add ax, ax
    add ax, ax
    
    mov a, ax
    
    ret

;方法一：在数据段中的[0]，存放返回数据   
mathTun1:
    mov ax, 2
    add ax, ax
    add ax, ax
    
    mov [0], ax
    
    ret
     
;打印字符串函数   
printf:
    mov dx, offset string
    mov ah, 09h
    int 21h
    ;推出函数调用
    ret
    
code ends
;------------ 代码段  end ------------


;程序编译结束，start程序入口 
end start  ;hjs较好的科夫斯克