# Assembly



## 函数调用流程

1. push 参数
2. push 函数的返回地址
3. push bp，保留bp之前的值，方便以后恢复
4. push 可能用到的寄存器，（ax是返回值，保护除了ax之前的可能用到的寄存器）
5. mov bp, sp，保留sp的值，方便以后恢复
6. sub sp, 空间大小，分配内存给局部变量
7. 保护局部变量的内容(放在被误用，给一个默认值)
8. 执行业务逻辑
9. pop 可能用到的寄存器
10. mov sp, bp，恢复sp的值
11. pop bp，恢复bp的值
12. ret，将函数的返回地址出栈，执行下一条指令
13. 恢复栈平衡（add sp, 参数所占空间）

## 函数实现流程

```
;定义代码段、数据段、栈段assume cs: code, ds: data, ss: stack;------------ 栈段 begin ------------stack segment     ;创建100个字节的内容为0的栈空间    db 100 dup(0)    stack ends;------------ 栈段  end ------------;------------ 数据段 begin ------------data segment    string db 'Hello World!$'    a dw 0   data ends;------------ 数据段  end ------------ ;------------ 代码段 begin ------------code segment;代码段开始start:     ;手动设置ds、ss的值    mov ax, data    mov ds, ax        mov ax, stack    mov ss, ax                 ;业务逻辑代码        ;给函数传入两个参数，返回两个参数之和    push 3    push 5        call sum     add sp, 4    ;保证栈平衡的        mov bx, ax                  ;退出程序    mov ax, 4c00h    int 21h;带参数的函数，求两个参数之和;两个参数存放在栈空间里面sum:    ;把bp的值入栈，保存bp进入函数之前的值     push bp    ;访问栈中的参数    mov bp, sp    ;预留10个字节的空间给局部变量    sub sp, 10    ;保护可能用到的寄存器如：cx，si等    push si    push cx    push di    push es        ;保护局部变量,给局部变量空间填充int 0cccch(在window下中断指令 int 3)    ;stosw 的作用，将ax的值拷贝到es:di内存空间中,同时di的值加2        mov ax, 0cccch    ;es等于ss    mov bx, ss    mov es, bx    ;让di等于bp-10(局部变量的大小)    mov di, bp    sub di, 10    ;循环次数    mov cx, 5     ;rep的作用重复执行某命令，(执行次数有cx觉得)    rep stosw                ;业务逻辑-------begin---    ;定义局部变量，实现下面的效果    ;int c = 4;	;int d = 1;	;int e = c + d;	;return a+b+e		mov word ptr ss[bp - 2], 4	mov word ptr ss[bp - 4], 1	mov ax, ss[bp - 2]	add ax, ss[bp - 4]	mov ss[bp - 6], ax	;传入的参数    add ax, ss:[bp+4]    add ax, ss:[bp+6]         ;业务逻辑-------end---           ;恢复可能用到的寄存器    pop es    pop di    pop cx    pop si        ;恢复sp指针    mov sp, bp    ;恢复bp的值    pop bp        ret     code ends;------------ 代码段  end ------------;程序编译结束，start程序入口 end start; 
```